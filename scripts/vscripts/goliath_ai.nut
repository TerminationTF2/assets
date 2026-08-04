::CONST <- getconsttable()
::ROOT <- getroottable()
if (!("ConstantNamingConvention" in ROOT))
{
	foreach (enum_table in Constants)
	{
		foreach (name, value in enum_table)
		{
			if (value == null)
				value = 0

			CONST[name] <- value
			ROOT[name] <- value
		}
	}
}

const NO_MISSION = 0
const TICK_INTERVAL = 0.015

// script TestMainAttack("ShotgunAttack")
::TestMainAttack <- function(main_attack_name)
{
	local goliath = null

	for (local i = MaxClients().tointeger(); i > 0; i--)
	{
		local player = PlayerInstanceFromIndex(i)
		if (!player)
			continue

		if (!player.IsBotOfType(TF_BOT_TYPE))
			continue

		if (!player.IsAlive())
			continue

		if (player.HasBotTag("bot_goliath"))
		{
			goliath = player
			break
		}
	}

	if (!goliath)
	{
		printl("Could not find bot_goliath.")
		return
	}

	local base_ai = bot.GetScriptScope().GoliathAI
	if (base_ai.CurrentMainAttack)
	{
		printl("Goliath is already executing a main attack.")
		return
	}

	if (!(main_attack_name in GoliathAI))
	{
		printf("Could not find main attack by name of \"%s\".\n", main_attack_name)
		return
	}

	local main_attack_class = GoliathAI[main_attack_name]
	if (!(main_attack_class instanceof GoliathAI.MainAttack))
	{
		printf("\"%s\" is not a derived class of MainAttack.\n", main_attack_name)
		return
	}

	printf("Performing main attack \"%s\"...\n", main_attack_name)
	if ("USE_TEMP_SPAWN" in Termination && Termination.USE_TEMP_SPAWN)
		printl("Warning: Goliath is in a temporary spawn location, some AI routines may not function as expected.")

	base_ai.DoMainAttack(main_attack_class)
}

::GoliathAI <-
{
	function CheckBotTags(bot)
	{
		if (bot.HasBotTag("bot_goliath"))
			BaseAI(bot)
	}

	function OnGameEvent_player_spawn(params)
	{
		local bot = GetPlayerFromUserID(params.userid)
		if (!bot.IsBotOfType(TF_BOT_TYPE))
			return

		EntFireByHandle(bot, "RunScriptCode", "GoliathAI.CheckBotTags(self)", -1.0, null, null)
	}

	function OnGameEvent_mvm_reset_stats(_)
	{
		delete ::GoliathAI
	}

	ThinkInfo = class
	{
		Func = null
		NextThink = -1.0
	}

	// Add a Think context to an entity. Only one think may exist per context identifier.
	function AddContextThink(ent, func, identifier, delay = -1.0)
	{
		local scope = ent.GetScriptScope()

		if (!("ThinkTable" in scope))
		{
			scope.ThinkTable <- {}
			scope.ProcessThinks <- ProcessContextThinks
			AddThinkToEnt(ent, "ProcessThinks")
		}

		if (delay == -1.0)
			delay = func.call(ent)
		scope.ThinkTable[identifier] <- ThinkInfo(){Func = func, NextThink = Time() + delay}
	}

	function ProcessContextThinks()
	{
		local now = Time()
		foreach (identifier, info in ThinkTable)
		{
			if (now < info.NextThink)
				continue

			local delay = info.Func.call(self)
			if (delay == null)
			{
				GoliathAI.RemoveContextThink(self, identifier)
				continue
			}

			// Round next think to nearest tick.
			local delta = TICK_INTERVAL - delay
			if (delta < 0.0 || delta > TICK_INTERVAL)
				info.NextThink = now + delay
			else
				info.NextThink += delay
		}

		return -1.0
	}

	function RemoveContextThink(ent, identifier)
	{
		local scope = ent.GetScriptScope()
		delete scope.ThinkTable[identifier]
		if (scope.ThinkTable.len() == 0)
			RemoveAllContextThinks(ent)
	}

	function RemoveAllContextThinks(ent)
	{
		local scope = ent.GetScriptScope()
		delete scope.ThinkTable
		delete scope.ProcessThinks
		AddThinkToEnt(ent, null)
		NetProps.SetPropString(ent, "m_iszScriptThinkFunction", "")
	}
}
__CollectGameEventCallbacks(GoliathAI)

const WEAPON_STANDARD_ROCKET = 0

class GoliathAI.ShoulderRockets
{
	WeaponMimic = null
	RocketOwner = null
	ShootEnt = null // TODO: Can this be attached with logic_measure_movement?

	MimicParams = null
	StoredParams = null

	// "Weapon_RPG.Single"
	// "Weapon_RPG.SingleCrit"

	/*
	MimicParamsExample =
	{
		ModelOverride = "",
		Speed = 1200.0,
		Damage = 90.0,
		Crits = false,
		FireDelay = 0.25
	}
	*/

	constructor(player, shoot_ent)
	{
		RocketOwner = player
		ShootEnt = shoot_ent

		WeaponMimic = Entities.CreateByClassname("tf_point_weapon_mimic")
		NetProps.SetPropBool(WeaponMimic, "m_bForcePurgeFixedupStrings", true)
		WeaponMimic.KeyValueFromInt("WeaponType", WEAPON_STANDARD_ROCKET)
		WeaponMimic.SetAbsAngles(shoot_ent.GetAbsAngles())

		WeaponMimic.ValidateScriptScope()
		WeaponMimic.GetScriptScope().PassiveFireThink <- PassiveFireThink
		AddThinkToEnt(WeaponMimic, "PassiveFireThink")

		SlowFire()
	}

	function SlowFire()
	{
		MimicParams =
		{
			ModelOverride = "",
			Speed = 1200.0,
			Damage = 90,
			Crits = false,
			FireDelay = 0.8
		}
		ApplyMimicParams()
	}

	function ApplyMimicParams()
	{
		// KV params.
		WeaponMimic.KeyValueFromString("ModelOverride", MimicParams.ModelOverride)
		WeaponMimic.KeyValueFromFloat("SpeedMin", MimicParams.Speed)
		WeaponMimic.KeyValueFromFloat("SpeedMax", MimicParams.Speed)
		WeaponMimic.KeyValueFromFloat("Damage", MimicParams.Damage)
		WeaponMimic.KeyValueFromFloat("Crits", MimicParams.Crits)

		// Homing params.
		// TODO
	}

	function FireRocket()
	{
		//DispatchParticleEffect("rocketbackblast", WeaponMimic.GetOrigin(), WeaponMimic.GetForwardVector())

		WeaponMimic.AcceptInput("FireOnce", "", null, null)

		local rocket = null
		while (rocket = Entities.FindByClassname(rocket, "tf_projectile_rocket"))
		{
			NetProps.SetPropBool(rocket, "m_bForcePurgeFixedupStrings", true)
			if (rocket.GetScriptScope())
				continue

			if (rocket.GetOwner() != WeaponMimic)
				continue

			break
		}

		Assert(rocket && Rocket.GetOwner() == WeaponMimic)

		rocket.SetOwner(RocketOwner)
		NetProps.SetPropEntity(rocket, "m_hLauncher", RocketOwner)
		NetProps.SetPropEntity(rocket, "m_hOriginalLauncher", RocketOwner)
	}

	function PassiveFireThink()
	{
		return MimicParams.FireDelay
	}
}

class GoliathAI.MainAttack
{
	Goliath = null
	BaseAI = null

	EndCallbacks = null

	constructor(bot, base_ai)
	{
		Goliath = bot
		BaseAI = base_ai
	}

	function Start()
	{
		throw "MainAttack.Start is missing a required override method."
	}

	function AddEndCallback(func)
	{
		EndCallbacks.push(func)
	}

	function End()
	{
		foreach (func in EndCallbacks)
			func()
	}

	function GetWeaponByClassname(classname)
	{
		for (local i = 0; i < WEAPON_COUNT; i++)
		{
			local weapon = NetProps.GetPropEntityArray(Goliath, "m_hMyWeapons", i)
			if (!weapon)
				continue

			NetProps.SetPropBool(weapon, "m_bForcePurgeFixedupStrings", true)

			if (weapon.GetClassname() != classname)
				continue

			return weapon
		}

		throw format("MainAttack.GetWeaponByClassname(): Goliath does not have a \"%s\" equipped.", classname)
	}
}

class GoliathAI.ShotgunAttack extends MainAttack
{
	Shotgun = null

	constructor(bot, base_ai)
	{
		base.constructor(bot, base_ai)
		Shotgun = FindShotgun()
	}

	// TODO: Since most main attack routines will require a weapon, we can probably move a lot of this to the base class.

	function SwitchToShotgun()
	{
		Shotgun = GetWeaponByClassname("tf_weapon_shotgun")
		Goliath.Weapon_Switch(Shotgun)
	}

	function Start()
	{
		SwitchToShotgun()
		GoliathAI.AddContextThink(Goliath, AwaitShotgunReadyThink.bindenv(this), "AwaitShotgunReady")
	}

	function AwaitShotgunReadyThink()
	{
		if (Goliath.GetActiveWeapon() != Shotgun)
			return -1.0

		if (NetProps.GetPropInt(Shotgun, "m_flNextPrimaryAttack") > Time())
			return -1.0

		Fire()

		return null
	}

	function Fire()
	{
		/* Do stuff */

		/* Think and then end */
		End()
	}
}

class GoliathAI.BaseAI
{
	Goliath = null
	CurrentMainAttack = null // Active attack instance.

	// Passive attacks (I think shoulder rockets are the only ones).
	ShoulderRockets = null

	static WEAPON_COUNT = 3

	constructor(bot)
	{
		Goliath = bot

		DisableNextbot()

		local scope = Goliath.GetScriptScope()
		scope.GoliathAI <- this
		scope.GoliathAIEvents <- {}
		scope.GoliathAIEvents.OnGameEvent_player_death <- player_death.bindenv(this)
		scope.GoliathAIEvents.OnGameEvent_mvm_reset_stats <- mvm_reset_stats.bindenv(this)
		__CollectGameEventCallbacks(GoliathAIEvents)
	}

	function DoMainAttack(attack_class)
	{
		CurrentMainAttack = attack_class(Goliath, this)

		CurrentMainAttack.AddEndCallback(function() {CurrentMainAttack = null}.bindenv(this))
		CurrentMainAttack.Start()
	}

	function DisableNextbot()
	{
		Goliath.AddBotAttribute(IGNORE_ENEMIES|IGNORE_FLAG)
		Goliath.SetBehaviorFlag(0x7FF /* ignore all */)
		Goliath.SetMaxVisionRangeOverride(0.01)
		Goliath.AddCustomAttribute("disable weapon switch", 1.0, -1.0)
		Goliath.SetMission(NO_MISSION, true)
	}

	function Cleanup()
	{
		Goliath.ClearBehaviorFlag(0x7FF /* ignore all */)
		AddThinkToEnt(Goliath, null)
		Goliath.TerminateScriptScope()
	}

	function player_death(params)
	{
		local bot = GetPlayerFromUserID(params.userid)
		if (bot != Goliath)
			return

		Cleanup()
	}

	function mvm_reset_stats(_)
	{
		Cleanup()
	}
}

