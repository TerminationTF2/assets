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

const CHAN_WEAPON = 1
const MASK_SHOT = 0x46004003
const MAX_COORD_FLOAT = 16384.0
const NO_MISSION = 0
const TICK_INTERVAL = 0.015
::CONTENTS_REDTEAM <- CONTENTS_TEAM1

::ATTRIBUTE_NOT_FOUND <- -444.4

PrecacheScriptSound("Cart.Explode")

::TestMainAttack_TempSpawnWarn <- false
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

	local base_ai = goliath.GetScriptScope().MyBaseAI
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

	local function baseof(derived_class, base_class)
	{
		for (local current_base; current_base = derived_class.getbase();)
			if (current_base == base_class)
				return true
		return false
	}

	local main_attack_class = GoliathAI[main_attack_name]
	if (!baseof(main_attack_class, GoliathAI.MainAttack))
	{
		printf("GoliathAI.%s is not a derived class of GoliathAI.MainAttack.\n", main_attack_name)
		return
	}

	printf("Performing main attack \"%s\"...\n", main_attack_name)
	if (!TestMainAttack_TempSpawnWarn && "USE_TEMP_SPAWN" in Termination && Termination.USE_TEMP_SPAWN)
	{
		TestMainAttack_TempSpawnWarn = true
		printl("Warning: Goliath is in a temporary spawn location, some AI routines may not function as expected.")
	}

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
	//  Think functions can return a null value to remove themselves.
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
		{
			delay = func.call(ent)
			if (delay == null)
				return
		}
		scope.ThinkTable[identifier] <- ThinkInfo() {Func = func, NextThink = Time() + delay}
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

	static WEAPON_COUNT = 3

	constructor(bot, base_ai)
	{
		Goliath = bot
		BaseAI = base_ai
		EndCallbacks = []
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

	function WithAttribute(item, attribute, value, func)
	{
		local original_value = item.GetAttribute(attribute, ATTRIBUTE_NOT_FOUND)

		if (value == null)
			item.RemoveAttribute(attribute)
		else
			item.AddAttribute(attribute, value, 0.0)

		func()

		if (original_value == ATTRIBUTE_NOT_FOUND)
			item.RemoveAttribute(attribute)
		else
			item.AddAttribute(attribute, original_value, 0.0)
	}

	function GetWeaponByClassname(classname)
	{
		local is_matching_weapon = @(weapon) weapon.GetClassname() != classname
		if (classname[-1] == '*')
		{
			// Allow trailing wildcards.
			classname = classname.slice(0, -1)
			is_matching_weapon = @(weapon) startswith(weapon.GetClassname(), classname)
		}

		for (local i = 0; i < WEAPON_COUNT; i++)
		{
			local weapon = NetProps.GetPropEntityArray(Goliath, "m_hMyWeapons", i)
			if (!weapon)
				continue

			NetProps.SetPropBool(weapon, "m_bForcePurgeFixedupStrings", true)

			if (!is_matching_weapon(weapon))
				continue

			return weapon
		}

		throw format("MainAttack.GetWeaponByClassname(): Goliath does not have a \"%s\" equipped.", classname)
	}
}

class GoliathAI.ShotgunAttack extends GoliathAI.MainAttack
{
	Shotgun = null

	//GameEvents = null // TODO: Should write some kind of util that can collect game events from class instances.

	// constructor(bot, base_ai)
	// {
	// 	GameEvents = {}
	// 	GameEvents.OnScriptHook_OnTakeDamage <- OnScriptHook_OnTakeDamage.bindenv(this)
	// 	__CollectGameEventCallbacks(GameEvents)
	// 	base.constructor(bot, base_ai)
	// }

	// function OnScriptHook_OnTakeDamage(params)
	// {
	// 	if (params.const_entity != Goliath)
	// 		return

	// 	if (params.attacker != Goliath)
	// 		return

	// 	params.early_out = true
	// }

	// TODO: Since most main attack routines will require a weapon, we can probably move a lot of this to the base class.

	function SwitchToShotgun()
	{
		Shotgun = GetWeaponByClassname("tf_weapon_shotgun*")
		BaseAI.SwitchWeapon(Shotgun)
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

		if (NetProps.GetPropFloat(Shotgun, "m_flNextPrimaryAttack") > Time())
			return -1.0

		// TODO: Check that there is sufficient ammo?

		Fire()

		return null
	}

	BreakablePieceSizeInfo = class
	{
		handle = null
		mins = null
		maxs = null
	}

	function GetAimTargetPosition()
	{
		// CONTENTS_REDTEAM is not respected against shields because CTFPlayer::FireBullet
		//  doesn't use it, CTraceFilterIgnoreFriendlyCombatItems is used for hitscan
		//  (which we can't use because TraceLineEx doesn't support filters).
		// So just make all the armour pieces nonsolid and revert.
		local goliath_scope = Goliath.GetScriptScope()


		foreach (piece in goliath_scope.BreakableArmourPieces)
			piece.Collision.AddSolidFlags(FSOLID_NOT_SOLID)
		foreach (piece in goliath_scope.IndestructibleCollision)
			piece.Collision.AddSolidFlags(FSOLID_NOT_SOLID)

		local trace =
		{
			start = Goliath.EyePosition(),
			end = Goliath.GetOrigin() + (Goliath.EyeAngles().Forward() * MAX_COORD_FLOAT),
			mask = MASK_SHOT|CONTENTS_REDTEAM
		}
		TraceLineEx(trace)

		foreach (piece in goliath_scope.BreakableArmourPieces)
			piece.Collision.RemoveSolidFlags(FSOLID_NOT_SOLID)
		foreach (piece in goliath_scope.IndestructibleCollision)
			piece.Collision.RemoveSolidFlags(FSOLID_NOT_SOLID)

		if (trace.hit)
			return trace.endpos

		// Not throwing an error here because this is technically possible so we need to always handle it.
		printl("GetAimTargetPosition(): Could not find trace end position.")
		return null
	}

	// For Napalm, try:
	//  cinefx_goldrush
	//  cinefx_goldrush_flames
	//  etc.
	function Fire()
	{
		WithAttribute(Shotgun, "override projectile type", -1, function()
		{
			Shotgun.PrimaryAttack()

			// TODO: Effects here are placeholder.
			EmitSoundEx(
			{
				sound_name = "Cart.Explode",
				entity = Shotgun,
				sound_level = 255,
				channel = CHAN_WEAPON,
				filter_type = RECIPIENT_FILTER_GLOBAL
			})

			PointExplosion(PointExplosionInfo()
			{
				origin = GetAimTargetPosition(),
				angles = QAngle(-90.0, 0.0, 0.0)
				particle = "hightower_explosion",
				radius = 400.0
			})
		})

		End()
	}

	PointExplosionInfo = class
	{
		origin = null
		angles = null
		sound = "BaseExplosionEffect.Sound"
		particle = "ExplosionCore_wall"
		damage = 90.0
		radius = 146.0
	}

	function PointExplosion(info)
	{
		local bomb = Entities.CreateByClassname("tf_generic_bomb")
		NetProps.SetPropBool(bomb, "m_bForcePurgeFixedupStrings", true)

		bomb.SetAbsOrigin(info.origin)
		bomb.KeyValueFromString("sound", info.sound)
		bomb.KeyValueFromString("explode_particle", info.particle)
		bomb.KeyValueFromFloat("damage", info.damage)
		bomb.KeyValueFromFloat("radius", info.radius)

		if (info.angles)
			bomb.SetAbsAngles(info.angles)

		bomb.DispatchSpawn()

		bomb.SetHealth(1)
		bomb.TakeDamage(1.0, DMG_GENERIC, Goliath)
	}
}

class GoliathAI.BaseAI
{
	Goliath = null
	CurrentMainAttack = null // Active attack instance.

	// Passive attacks (I think shoulder rockets are the only ones).
	ShoulderRockets = null

	constructor(bot)
	{
		Goliath = bot

		DisableNextbot()

		local scope = Goliath.GetScriptScope()
		scope.MyBaseAI <- this
		scope.MyBaseAIEvents <- {}
		scope.MyBaseAIEvents.OnGameEvent_player_death <- player_death.bindenv(this)
		scope.MyBaseAIEvents.OnGameEvent_mvm_reset_stats <- mvm_reset_stats.bindenv(this)
		__CollectGameEventCallbacks(scope.MyBaseAIEvents)
	}

	// Do some logic with an attribute set, then revert it.
	function WithAttribute(attribute, value, func)
	{
		local original_value = Goliath.GetCustomAttribute(attribute, ATTRIBUTE_NOT_FOUND)

		if (value == null)
			Goliath.RemoveCustomAttribute(attribute)
		else
			Goliath.AddCustomAttribute(attribute, value, 0.0)

		func()

		if (original_value == ATTRIBUTE_NOT_FOUND)
			Goliath.RemoveCustomAttribute(attribute)
		else
			Goliath.AddCustomAttribute(attribute, original_value, 0.0)
	}

	function DoMainAttack(attack_class)
	{
		CurrentMainAttack = attack_class(Goliath, this)

		CurrentMainAttack.AddEndCallback(function() {CurrentMainAttack = null}.bindenv(this))
		CurrentMainAttack.Start()
	}

	function SwitchWeapon(weapon)
	{
		WithAttribute("disable weapon switch", null, function()
		{
			Goliath.Weapon_Switch(weapon)
		})
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

