::CONST <- getconsttable()
::ROOT <- getroottable()
::MAX_CLIENTS <- MaxClients().tointeger()

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

const INT_MAX = 0x7FFFFFFF

const kBonusEffect_Crit = 0x0
const kBonusEffect_MiniCrit = 0x1
const kBonusEffect_None = 0x4

const TF_WEAPON_NONE = 0
const TFCOLLISION_GROUP_RESPAWNROOMS = 25

::DMG_CRITICAL <- DMG_ACID

::GoliathModels <-
{
	ARMOR_PLATING =
	[
		{ collision_model = "models/bots/heavy_boss/base_belly.mdl",       path = "models/bots/heavy_boss/armour_piece_belly.mdl",       attachment = "armour_belly" },
		{ collision_model = "models/bots/heavy_boss/base_collar.mdl",      path = "models/bots/heavy_boss/armour_piece_collar.mdl",      attachment = "armour_collar" },
		{ collision_model = "models/bots/heavy_boss/base_lower_arm_l.mdl", path = "models/bots/heavy_boss/armour_piece_lower_arm_l.mdl", attachment = "armour_lower_arm_l" },
		{ collision_model = "models/bots/heavy_boss/base_lower_arm_r.mdl", path = "models/bots/heavy_boss/armour_piece_lower_arm_r.mdl", attachment = "armour_lower_arm_r" },
		{ collision_model = "models/bots/heavy_boss/base_pectoral.mdl",    path = "models/bots/heavy_boss/armour_piece_pectoral_l.mdl",  attachment = "armour_pectoral" },
		{ collision_model = "models/bots/heavy_boss/base_pectoral.mdl",    path = "models/bots/heavy_boss/armour_piece_pectoral_r.mdl",  attachment = "armour_pectoral" },
		{ collision_model = "models/bots/heavy_boss/base_shoulder_l.mdl",  path = "models/bots/heavy_boss/armour_piece_shoulder_l.mdl",  attachment = "armour_shoulder_l" },
		{ collision_model = "models/bots/heavy_boss/base_shoulder_r.mdl",  path = "models/bots/heavy_boss/armour_piece_shoulder_r.mdl",  attachment = "armour_shoulder_r" },
		{ collision_model = "models/bots/heavy_boss/base_upper_arm_l.mdl", path = "models/bots/heavy_boss/armour_piece_upper_arm_l.mdl", attachment = "armour_upper_arm_l" },
		{ collision_model = "models/bots/heavy_boss/base_upper_arm_r.mdl", path = "models/bots/heavy_boss/armour_piece_upper_arm_r.mdl", attachment = "armour_upper_arm_r" }
	]

	COLLISION_OTHER =
	[
		{ name = "foot_l", path = "models/bots/heavy_boss/base_foot_l.mdl",  attachment = "collision_foot_l" },
		{ name = "foot_r", path = "models/bots/heavy_boss/base_foot_r.mdl",  attachment = "collision_foot_r" },
		{ name = "hand_l", path = "models/bots/heavy_boss/base_hand_l.mdl",  attachment = "collision_hand_l" },
		{ name = "hand_r", path = "models/bots/heavy_boss/base_hand_r.mdl",  attachment = "collision_hand_r" },
		{ name = "head",   path = "models/bots/heavy_boss/base_head.mdl",    attachment = "collision_head"   },
		{ name = "hip_l",  path = "models/bots/heavy_boss/base_hip_l.mdl",   attachment = "collision_hip_l"  },
		{ name = "hip_r",  path = "models/bots/heavy_boss/base_hip_r.mdl",   attachment = "collision_hip_r"  },
		{ name = "knee_l", path = "models/bots/heavy_boss/base_knee_l.mdl",  attachment = "collision_knee_l" },
		{ name = "knee_r", path = "models/bots/heavy_boss/base_knee_r.mdl",  attachment = "collision_knee_r" },
		{ name = "neck",   path = "models/bots/heavy_boss/base_neck.mdl",    attachment = "collision_neck"   },
		{ name = "pelvis", path = "models/bots/heavy_boss/base_pelvis.mdl",  attachment = "collision_pelvis" }
	],

	ROOT_MODEL = "models/bots/heavy_boss/bot_heavy_goliath.mdl"
}

foreach (k,v in GoliathModels)
	if (k == "ARMOR_PLATING")
		foreach (m in v) { PrecacheModel(m.collision_model); PrecacheModel(m.path) }
	else if (k == "COLLISION_OTHER")
		foreach (m in v) PrecacheModel(m.path)
	else if (k == "ROOT_MODEL")
		PrecacheModel(v)

function ROOT::PrintTable(table, indent = 0)
{
	local prefix = "";
	for (local i = 0; i < indent; i++)
		prefix += "  ";

	foreach (key, value in table)
	{
		if (typeof value == "table")
		{
			printl(prefix + key + ":");
			PrintTable(value, indent + 1);
		}
		else if (typeof value == "array")
		{
			printl(prefix + key + ": [array len=" + value.len() + "]");
			foreach (i, v in value)
				printl(prefix + "  [" + i + "] = " + v);
		}
		else
		{
			printl(prefix + key + " = " + value);
		}
	}
}

::Termination <-
{
	USE_TEMP_SPAWN = true

	BOSS_TEMP_SPAWN = Vector(-1531.0, 3772.0, 577.0)
	BOSS_SPAWN_LOCATION = Vector(-53.0, 4819.0, -440.0)

	// ------------------------------------ MAIN GOLIATH LOGIC ------------------------------------
	function GoliathSetup(bot)
	{
		bot.SetCustomModelWithClassAnimations(GoliathModels.ROOT_MODEL)
		Util.SetMissionConvar("mp_forcecamera", true) // Armour pieces block the spectator cam + looks weird on titans anyway, should just place an observer in a good spot. Maybe there is some way to force change the player's observer camera whenever selecting the bot.
		bot.SetCollisionGroup(TFCOLLISION_GROUP_RESPAWNROOMS) // Disable bot being shot (the bounding box exceeds the armour plates). TODO: This does not reset on player death!!
		bot.AddFlag(FL_GODMODE|FL_NOTARGET)
		bot.AddCustomAttribute("wet immunity", 1, -1.0) // Rafmod: Stop wet particles showing up since they occupy the bounding space of the armour pieces. Might be possible to ParticleEffectStop for vanilla.
		bot.SetModel(GoliathModels.ROOT_MODEL)

		if (USE_TEMP_SPAWN)
		{
			bot.Teleport(true, BOSS_TEMP_SPAWN, false, QAngle(), false, Vector())
			bot.SetScaleOverride(1.0)
		}
		else
		{
			// TODO: Seabed at this location is not flat, so the boss at this scale clips in to the ground causing "Robot's getting stuck with worldspawn" spam.
			bot.Teleport(true, BOSS_SPAWN_LOCATION, false, QAngle(), false, Vector())
			bot.SetScaleOverride(35.0)
		}

		bot.ValidateScriptScope()
		local scope = bot.GetScriptScope()

		local breakable_pieces = []
		local indestructible_collision = []

		foreach (info in GoliathModels.ARMOR_PLATING)
			breakable_pieces.push(Util.BreakableArmourPiece(bot, info.attachment, info.path, info.collision_model))

		foreach (m in GoliathModels.COLLISION_OTHER)
			indestructible_collision.push(Termination.Util.IndestructibleCollisionPiece(bot, m.attachment, m.path))

		scope.BreakableArmourPieces <- breakable_pieces
		scope.IndestructibleCollision <- indestructible_collision
	}

	function MapFixup()
	{
		local filter_exclude_goliath = Util.CreateByClassnameSafe("filter_tf_bot_has_tag")
		filter_exclude_goliath.KeyValueFromString("tags", "bot_goliath")
		filter_exclude_goliath.KeyValueFromInt("require_all_tags", (true).tointeger())
		filter_exclude_goliath.KeyValueFromInt("Negated", (true).tointeger())
		filter_exclude_goliath.DispatchSpawn()

		foreach (trigger in Util.EntsOfClassname("trigger_hurt"))
			NetProps.SetPropEntity(trigger, "m_hFilter", filter_exclude_goliath)
	}

	// ------------------------------------ EVENTS AND GAME HANDLING ------------------------------------
	function OnGameEvent_player_spawn(params)
	{
		local hEntity = GetPlayerFromUserID(params.userid)
		if (!hEntity.IsBotOfType(TF_BOT_TYPE))
			return

		EntFireByHandle(hEntity, "RunScriptCode", "Termination.Util.ProcessBot(self)", -1.0, null, null)
	}

	function OnGameEvent_mvm_reset_stats(_)
	{
		for (local i = MaxClients().tointeger(); i > 0; i--)
		{
			local player = PlayerInstanceFromIndex(i)
			if (!player)
				continue

			player.SetCollisionGroup(COLLISION_GROUP_PLAYER) // TODO: Lazy!!
			AddThinkToEnt(player, null)
			player.TerminateScriptScope()
		}

		if ("Termination" in getroottable())
			delete ::Termination
	}

	function OnGameEvent_mvm_wave_complete(_)
	{
		if ("Termination" in getroottable())
			delete ::Termination
	}
}
__CollectGameEventCallbacks(::Termination)

IncludeScript("goliath_util" , getroottable())
