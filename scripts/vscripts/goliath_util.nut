if ("Util" in ::Termination)
	delete ::Termination.Util

const BLOOD_COLOR_MECH = 3
const DAMAGE_YES = 2
const INT_MAX = 0x7FFFFFFF
const TFCOLLISION_GROUP_COMBATOBJECT = 23

::Termination.Util <- {}

function Termination::Util::GlowEnt(hEnt, iDuration = 5)
{
	NetProps.SetPropBool(hEnt, "m_bForcePurgeFixedupStrings", true)
	hEnt.ValidateScriptScope()
	local hScope = hEnt.GetScriptScope()

	if (!("__glow" in hScope))
	{
		local glow = SpawnFromTableSafe("tf_glow",
		{
			GlowColor = "255 255 255 255"
			target = "BigNet"
		})
		NetProps.SetPropEntity(glow, "m_hTarget", hEnt)

		glow.ValidateScriptScope()
		local scope = glow.GetScriptScope()
		scope.ExpireTime <- Time() + iDuration

		local function RemoveGlowThink()
		{
			if (Time() > ExpireTime)
				self.Destroy()
		}
		scope.RemoveGlowThink <- RemoveGlowThink
		AddThinkToEnt(glow, "RemoveGlowThink")

		return
	}

	local glow = hScope.__glow
	if (Time() + iDuration > glow.GetScriptScope().ExpireTime)
		glow.GetScriptScope().ExpireTime <- Time() + iDuration
}

function Termination::Util::ProcessBot(bot)
{
	if (!bot.IsAlive())
		return

	if (bot.HasBotTag("bot_goliath"))
		Termination.GoliathSetup(bot)
}

function Termination::Util::CreateByClassnameSafe(sClassname)
{
	local hEnt = CreateByClassname(sClassname)
	NetProps.SetPropBool(hEnt, "m_bForcePurgeFixedupStrings", true)
	return hEnt
}

function Termination::Util::SpawnFromTableSafe(sClassname, params)
{
	local hEnt = SpawnEntityFromTable(sClassname, params)
	NetProps.SetPropBool(hEnt, "m_bForcePurgeFixedupStrings", true)
	return hEnt
}

function Termination::Util::EntsOfClassname(classname)
{
	local ent = Entities.FindByClassname(null, classname)
	if (!ent)
		return null
	NetProps.SetPropBool(ent, "m_bForcePurgeFixedupStrings", true)

	for (local next; ent; ent = next)
	{
		next = Entities.FindByClassname(ent, classname)
		if (next)
			NetProps.SetPropBool(next, "m_bForcePurgeFixedupStrings", true)

		yield ent
	}

	return null
}

function Termination::Util::SetMissionConvar(convar, value)
{
	// TODO
	printl("\"" + convar + " : " + value.tostring() + "\" not set.")
}

function Termination::Util::KillEntWithPlayerOwner(ent)
{
	// TODO: This should make a table or class instead of dumping the events straight in to the ent's scope.
	ent.ValidateScriptScope()
	local scope = ent.GetScriptScope()
	local function destroy(_)
	{
		self.Destroy()
	}
	local function destroy_if_userid(params)
	{
		if (!self.IsValid())
			// This can happen if the ent is a child in the move hierarchy of the player.
			return

		if (GetPlayerFromUserID(params.userid) == self.GetOwner())
			self.Destroy()
	}
	scope.OnGameEvent_mvm_reset_stats <- destroy
	scope.OnGameEvent_player_death <- destroy_if_userid
	scope.OnGameEvent_player_disconnect <- destroy_if_userid
	__CollectGameEventCallbacks(scope)
}

function Termination::Util::GivePlayerAttachmentWearable(player, attachment, model)
{
	local wearable = CreateByClassnameSafe("tf_wearable")
	NetProps.SetPropInt(wearable, "m_nModelIndex", PrecacheModel(model))
	NetProps.SetPropBool(wearable, "m_bValidatedAttachedEntity", true)

	wearable.SetOwner(player)
	wearable.DispatchSpawn()

	wearable.AcceptInput("SetParent", "!activator", player, null)
	wearable.AcceptInput("SetParentAttachment", attachment, null, null)
	// TODO: Shadows are broken on this even when setting EF_NOSHADOW|EF_NORECEIVESHADOW.
	// Not the biggest deal for us since Goliath stands in water, obscuring the shadow.
	NetProps.SetPropInt(wearable, "m_fEffects", 0)
	wearable.SetMoveType(MOVETYPE_NOCLIP, MOVECOLLIDE_DEFAULT)

	KillEntWithPlayerOwner(wearable)

	return wearable
}

class Termination.Util.AttachmentPoint
{
	Player = null
	Target = null

	constructor(player, attachment_name)
	{
		Player = player

		Target = Termination.Util.CreateByClassnameSafe("info_target")
		Target.KeyValueFromString("classname", "info_target_nopreserve")
		NetProps.SetPropInt(Target, "m_fEffects", EF_NOINTERP)
		Target.SetMoveType(MOVETYPE_NOCLIP, MOVECOLLIDE_DEFAULT)

		Target.AcceptInput("SetParent", "!activator", Player, null)
		Target.AcceptInput("SetParentAttachment", attachment_name, null, null)

		Termination.Util.KillEntWithPlayerOwner(Target)
	}

	function AttachEnt(ent)
	{
		ent.AcceptInput("SetParent", "!activator", Target, null)
		ent.SetLocalOrigin(Vector())
		ent.SetLocalAngles(QAngle())

		// Stop parenting stuff being really laggy on large player model scales.
		ent.SetMoveType(MOVETYPE_NOCLIP, MOVECOLLIDE_DEFAULT)
	}
}

class Termination.Util.IndestructibleCollisionPiece
{
	Player = null

	Collision = null
	AttachmentPoint = null

	static ARMOUR_SCALE_FACTOR = 30.0

	// TODO: We may need the ability to forward damage to the player at some point.

	constructor(player, attachment_name, collision_model)
	{
		Player = player

		Collision = CreateCollision(collision_model)

		// Must be made last (why?).
		AttachmentPoint = Termination.Util.AttachmentPoint(player, attachment_name)
		AttachmentPoint.AttachEnt(Collision)
	}

	function CreateCollision(collision_model)
	{
		// TODO: This doesn't collide with rockets suddenly...

		local collision = Termination.Util.SpawnFromTableSafe("entity_medigun_shield", {})
		collision.AddEFlags(EFL_NO_THINK_FUNCTION|EFL_DONTBLOCKLOS)
		collision.SetTeam(Player.GetTeam())

		// Do this hack to let flames deal damage.
		collision.KeyValueFromString("classname", "tf_generic_bomb")
		collision.RemoveSolidFlags(FSOLID_TRIGGER)

		collision.SetModel(collision_model)
		collision.SetModelScale(Player.GetModelScale() / ARMOUR_SCALE_FACTOR, -1.0)
		collision.SetSolid(SOLID_VPHYSICS)

		NetProps.SetPropInt(collision, "m_nRenderMode", kRenderNone)
		NetProps.SetPropInt(collision, "m_fEffects", EF_NOINTERP|EF_NOSHADOW|EF_NORECEIVESHADOW)

		// IDK if this works I think I have these particles off!!
		// If it doesn't work, we can use the "bot_impact_light"/"bot_impact_heavy" particles that tanks use.
		NetProps.SetPropInt(collision, "m_bloodColor", BLOOD_COLOR_MECH)

		Termination.Util.KillEntWithPlayerOwner(collision)

		return collision
	}
}

class Termination.Util.BreakableArmourPiece
{
	// Creates an info_target at the player attachment point, attaches a
	// collision model to receive hits and base_boss to allow sentries to target it,
	// and also receive the damage itself (which is forwarded from the collision model)
	// so we can benefit from CTFGameRules::ApplyOnDamageModifyRules.

	// TODO: Could probably inherit from IndestructibleCollisionPiece

	Player = null
	CosmeticModel = null

	AttachmentPoint = null
	Collision = null
	DamageProxy = null

	OnBreakCallbacks = null

	static ARMOUR_SCALE_FACTOR = 30.0
	static ARMOUR_HEALTH = 10000

	constructor(player, attachment_name, cosmetic_model, collision_model)
	{
		OnBreakCallbacks = []
		Player = player

		CosmeticModel = Termination.Util.GivePlayerAttachmentWearable(Player, attachment_name, cosmetic_model)
		CosmeticModel.SetModelScale(Player.GetModelScale() / ARMOUR_SCALE_FACTOR, -1.0)

		Collision = CreateCollision(collision_model)
		DamageProxy = CreateDamageProxy()
		// Must be made last (why?).
		AttachmentPoint = Termination.Util.AttachmentPoint(player, attachment_name)

		AttachmentPoint.AttachEnt(Collision)
		AttachmentPoint.AttachEnt(DamageProxy)

		OnBreakCallbacks.push(@() Collision.Destroy())
		OnBreakCallbacks.push(@() CosmeticModel.Destroy())
		// Removing DamageProxy is delayed so that OnTakeDamage hooks don't have an invalid const_entity.
		OnBreakCallbacks.push(@() EntFireByHandle(DamageProxy, "Kill", "", -1.0, null, null))
	}

	function OnScriptHook_OnTakeDamage(params)
	{
		if (params.const_entity != Collision)
			return

		params.early_out = true

		Termination.Util.GlowEnt(CosmeticModel) // DEBUG

		DamageProxy.TakeDamageCustom(
			params.inflictor,
			params.attacker,
			params.weapon,
			params.damage_force,
			params.damage_position,
			params.damage,
			params.damage_type,
			params.damage_stats
		)
	}

	function OnGameEvent_npc_hurt(params)
	{
		if (EntIndexToHScript(params.entindex) != DamageProxy)
			return

		if ((DamageProxy.GetHealth() - params.damageamount) <= (INT_MAX - ARMOUR_HEALTH))
			Break()
	}

	function CreateCollision(collision_model)
	{
		local collision = Termination.Util.SpawnFromTableSafe("entity_medigun_shield", {})
		collision.AddEFlags(EFL_NO_THINK_FUNCTION|EFL_DONTBLOCKLOS)
		collision.SetTeam(Player.GetTeam())

		// Do this hack to let flames deal damage.
		collision.KeyValueFromString("classname", "tf_generic_bomb")
		collision.RemoveSolidFlags(FSOLID_TRIGGER)

		collision.SetModel(collision_model)
		collision.SetModelScale(Player.GetModelScale() / ARMOUR_SCALE_FACTOR, -1.0)
		collision.SetSolid(SOLID_VPHYSICS)

		NetProps.SetPropInt(collision, "m_nRenderMode", kRenderNone)
		NetProps.SetPropInt(collision, "m_fEffects", EF_NOINTERP|EF_NOSHADOW|EF_NORECEIVESHADOW)

		// IDK if this works I think I have these particles off!!
		// If it doesn't work, we can use the "bot_impact_light"/"bot_impact_heavy" particles that tanks use.
		NetProps.SetPropInt(collision, "m_bloodColor", BLOOD_COLOR_MECH)

		Termination.Util.KillEntWithPlayerOwner(collision)

		return collision
	}

	function CreateDamageProxy()
	{
		local proxy = Termination.Util.CreateByClassnameSafe("base_boss")

		proxy.SetHealth(INT_MAX)
		NetProps.SetPropInt(proxy, "m_takedamage", DAMAGE_YES)
		proxy.SetModelScale(0.0001, -1.0) // Stop damage numbers appearing above location.
		proxy.SetTeam(Player.GetTeam())

		proxy.ValidateScriptScope()
		local scope = proxy.GetScriptScope()
		scope.OnScriptHook_OnTakeDamage <- OnScriptHook_OnTakeDamage.bindenv(this)
		scope.OnGameEvent_npc_hurt <- OnGameEvent_npc_hurt.bindenv(this)

		NetProps.SetPropInt(proxy, "m_fEffects", EF_NOINTERP|EF_NOSHADOW|EF_NORECEIVESHADOW)

		Termination.Util.KillEntWithPlayerOwner(proxy)

		return proxy
	}

	function Break()
	{
		CosmeticModel.Destroy()

		foreach (func in OnBreakCallbacks)
			func()
	}
}
