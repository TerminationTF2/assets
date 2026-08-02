::PointTemplates <- 
{
	imsolazyilldothis =
	{
		[0] =
		{
			OnParentKilledOutput =
			{
				Target = "flavour_front*",
				Action = "Kill",
				Delay = 0,
			},
		},
	},
	activateelevatorwindows =
	{
		[0] =
		{
			trigger_add_tf_player_condition =
			{
				targetname = "elevator_trigger",
				origin = "-2805 7147 688",
				spawnflags = 1,
				condition = 12,
				duration = 999,
				mins = "-175 -175 -175",
				maxs = "175 175 175",
			},
		},
		[1] =
		{
			trigger_multiple =
			{
				targetname = "checking_elevator",
				origin = "-2805 7147 688",
				mins = "-175 -175 -175",
				maxs = "175 175 175",
				StartDisabled = 0,
				spawnflags = 1,
				"OnStartTouchAll#1" : "elevator_transition,trigger,,25,-1",
			},
		},
		[2] =
		{
			logic_relay =
			{
				targetname = "elevator_transition",
				"OnTrigger#1" : "func_upgradestation*,disable,,0,-1",
				"OnTrigger#2" : "player,SetHUDVisibility,0,13,-1",
				"OnTrigger#3" : "door_upgrades,close,,0,-1",
				"OnTrigger#4" : "door_upgrades,SetSpeed,50,0,-1",
				"OnTrigger#5" : "tf_gamerules,PlayVO,ambient/rottenburg/tunneldoor_closed_quiet.wav,7.5,-1",
				"OnTrigger#6" : "tf_gamerules,PlayVO,ambient/rottenburg/tunneldoor_closed_quiet.wav,7.5,-1",
				"OnTrigger#7" : "tf_gamerules,PlayVO,plats/elevator_large_start1.wav,10,-1",
				"OnTrigger#8" : "tf_gamerules,PlayVO,plats/elevator_move_loop2.wav,12,-1",
				"OnTrigger#9" : "tf_gamerules,$ChangeLevel,mvm_robotfactory_b30|adv_termination_act_2,20,-1",
				"OnTrigger#10" : "redwin_relay,trigger,,19.9,-1",
				"OnTrigger#11" : "abrawlissurelybrewing,startshake,,7.5,1",
				"OnTrigger#12" : "insertterminationsplashtext,trigger,,6,-1",
				"OnTrigger#13" : "notoquesloscojonesniño,enable,,6.5,-1",
				"OnTrigger#14" : "notoquesloscojonesniño,disable,,7.4,-1",
				"OnTrigger#15" : "hudtimer,disable,,0,1",
				"OnTrigger#16" : "hudhint,hidehudhint,,0,1",
			},
		},
		[3] =
		{
			trigger_hurt =
			{
				targetname = "notoquesloscojonesniño",
				origin = "-2560 7152 688",
				mins = "-10 -300 -300",
				maxs = "10 300 300",
				damage = 3000000,
				damagecap = 3000000,
				damagemodel = 0,
				damagetype = 16,
				nodmgforce = 1,
				spawnflags = 1,
				StartDisabled = 1,
			},
		},
	},
	iguessihavetodothis =
	{
		[0] =
		{
			OnSpawnOutput =
			{
				Target = "bossbombattack",
				Action = "TurnOn",
			},
		},
		[1] =
		{
			prop_dynamic_ornament =
			{
				targetname = "bossbombattack",
				model = "models/props_td/atom_bomb.mdl",
				solid = 0,
				disablebonefollowers = 1,
				disableshadows = 1,
			},
		},
	},
	temp =
	{
		NoFIxup = 1,
		[0] =
		{
			info_particle_system =
			{
				targetname = "die",
				origin = "0 0 100",
				angles = "0 0 0",
				effect_name = "hammer_bell_ring_shockwave",
			},
		},
		[1] =
		{
			info_target =
			{
				targetname = "kill_me_if_you_dare",
				origin = "0 0 0",
			},
		},
		[2] =
		{
			env_fade =
			{
				targetname = "emp_fade",
				angles = "0 0 0",
				duration = 0.25,
				holdtime = 0.50,
				renderamt = 128,
				rendercolor = "51 153 255",
				spawnflags = 9,
			},
		},
		[3] =
		{
			info_particle_system =
			{
				targetname = "boss_about_to_blow",
				origin = "60 0 120",
				angles = "-90 0 0",
				effect_name = "charge_up",
			},
		},
		[4] =
		{
			prop_dynamic =
			{
				targetname = "tank_emp",
				origin = "0 0 0",
				model = "models/spybase/emp_tank.mdl",
				solid = 0,
				defaultanim = "movement",
				skin = 0,
			},
		},
		[5] =
		{
			prop_dynamic =
			{
				targetname = "tankrequirementslegs",
				model = "models/bots/boss_bot/tank_track_l.mdl",
				angles = "0 0 0",
				defaultanim = "forward",
				solid = 0,
				modelscale = 1,
				origin = "0 -55 0",
			},
		},
		[6] =
		{
			prop_dynamic =
			{
				targetname = "tankrequirementslegs",
				model = "models/bots/boss_bot/tank_track_l.mdl",
				angles = "0 0 0",
				defaultanim = "forward",
				solid = 0,
				modelscale = 1,
				origin = "0 55 0",
			},
		},
		[7] =
		{
			dispenser_touch_trigger =
			{
				targetname = "drill_dispenserzone",
				mins = "-300 -200 -60",
				maxs = "300 200 60",
			},
		},
		[8] =
		{
			mapobj_cart_dispenser =
			{
				targetname = "drill_dispensertarget",
				TeamNum = 2,
				touch_trigger = "drill_dispenserzone",
			},
		},
		[9] =
		{
			OnSpawnOutput =
			{
				Target = "emp_tank_prop*",
				Action = "Kill",
			},
		},
	},
	kaboom =
	{
		KeepAlive = 1,
		[0] =
		{
			item_teamflag =
			{
				targetname = "bomb1_timed",
				TeamNum = 2,
				StartDisabled = 1,
				modelscale = 1.4,
				flag_model = "models/props_td/atom_bomb.mdl",
				origin = "0 0 0",
				"OnReturn#1" : "!self,Kill,,0.1,-1",
				"OnReturn#2" : "02_door,kill,,0.2,-1",
				"OnReturn#3" : "meantoblowup*,kill,,0.2,-1",
				"OnReturn#4" : "waiterwaiter_nextsubwaveplease,trigger,,0,1",
				"OnPickup1#1" : "!activatorRunScriptCodeClientPrint(self, 4, `YOU PICKED UP THE BOMB! PLACE IT NEXT TO THE CONTAINERS!`)0-1",
				"OnPickup1#2" : "!activatorRunScriptCodeEmitSoundEx({sound_name = `ui/item_bag_pickup.wav`, channel = 0, volume = 1, pitch = 1, entity = self, filter_type = 4 })0-1",
				"OnPickup1#3" : "hologrambomb,enable,,0,-1",
			},
		},
		[1] =
		{
			tf_glow =
			{
				GlowColor = "0 176 199 255",
				target = "bomb1_timed",
				targetname = "flag_glow",
				startdisabled = 1,
			},
		},
		[2] =
		{
			OnParentKilledOutput =
			{
				Target = "flag_glow",
				Action = "Enable",
			},
		},
		[3] =
		{
			OnParentKilledOutput =
			{
				Target = "bomb1_timed",
				Action = "Enable",
			},
		},
		[4] =
		{
			OnParentKilledOutput =
			{
				Target = "bomb1_timed",
				Action = "SetTeam",
				Param = 3,
			},
		},
	},
	act1bossshit =
	{
		[0] =
		{
			info_particle_system =
			{
				targetname = "kablooey",
				origin = "0 0 0",
				angles = "0 0 0",
				effect_name = "mvm_tank_destroy",
			},
		},
		[1] =
		{
			tf_glow =
			{
				GlowColor = "255 255 0 255",
				target = "!parent",
				targetname = "LOOKATMEBITCH",
				startdisabled = 1,
			},
		},
		[2] =
		{
			tf_glow =
			{
				GlowColor = "102 153 255 255",
				target = "!parent",
				targetname = "LOOKATMEBITCH3",
				startdisabled = 1,
			},
		},
		[3] =
		{
			tf_glow =
			{
				GlowColor = "0 255 0 255",
				target = "!parent",
				targetname = "LOOKATMEBITCH2",
				startdisabled = 1,
			},
		},
		[4] =
		{
			logic_relay =
			{
				targetname = "flashpeoplewiththis",
				"OnTrigger#1" : "LOOKATMEBITCH,enable,,0,-1",
				"OnTrigger#2" : "LOOKATMEBITCH2,enable,,2.5,-1",
				"OnTrigger#3" : "LOOKATMEBITCH,disable,,2.49,-1",
				"OnTrigger#4" : "LOOKATMEBITCH2,disable,,4.99,-1",
				"OnTrigger#5" : "flashpeoplewiththis,trigger,,5,-1",
				spawnflags = 2,
			},
		},
	},
	ringOwner =
	{
		NoFixUp = 1,
		[0] =
		{
			env_entity_maker =
			{
				targetname = "ring_maker",
				entitytemplate = "ringshottest",
			},
		},
		[1] =
		{
			OnSpawnOutput =
			{
				target = "!activator",
				action = "RunScriptCode",
				param = "CzUtil.AddTracking(`ringOwner`, self)",
				delay = 0.0,
			},
		},
		[2] =
		{
			OnParentKilledOutput =
			{
				target = "ring_maker",
				action = "RunScriptCode",
				param = "CzUtil.RemoveTracking(`ringOwner`)",
				delay = 0.0,
			},
		},
	},
	ringshottest =
	{
		KeepAlive = 1,
		[0] =
		{
			OnSpawnOutput =
			{
				target = "tf_gamerules",
				action = "PlayVO",
				Param = "npc/combine_gunship/gunship_ping_search.wav",
				delay = 0.0,
			},
		},
		[1] =
		{
			OnSpawnOutput =
			{
				target = "ringmarkerone",
				action = "kill",
				delay = 5.5,
			},
		},
		[2] =
		{
			OnSpawnOutput =
			{
				target = "ringmarkertwo",
				action = "kill",
				delay = 5.5,
			},
		},
		[3] =
		{
			OnSpawnOutput =
			{
				target = "roundbeamtest",
				action = "TurnOff",
				delay = 4.5,
			},
		},
		[4] =
		{
			OnSpawnOutput =
			{
				target = "roundbeamtest",
				action = "StrikeOnce",
				delay = 0,
			},
		},
		[5] =
		{
			OnSpawnOutput =
			{
				target = "roundbeamtest",
				action = "kill",
				delay = 5.0,
			},
		},
		[6] =
		{
			OnSpawnOutput =
			{
				target = "ringmarkerone",
				action = "RunScriptCode",
				param = "SetMoveIgnoreSolid(self, 120)",
			},
		},
		[7] =
		{
			OnSpawnOutput =
			{
				target = "roundbeamtest",
				action = "RunScriptCode",
				param = "RingRegister(self,80,CzUtil.GetTracking(`ringOwner`))",
				delay = 0.0,
			},
		},
		[8] =
		{
			OnSpawnOutput =
			{
				target = "ringmarkertwo",
				action = "RunScriptCode",
				param = "SetMoveIgnoreSolid(self, 120)",
			},
		},
		[9] =
		{
			prop_dynamic =
			{
				parentname = "",
				targetname = "ringmarkerone",
				model = "models/empty.mdl",
				solid = 0,
				origin = "0 0 30",
			},
		},
		[10] =
		{
			prop_dynamic =
			{
				parentname = "",
				targetname = "ringmarkertwo",
				model = "models/empty.mdl",
				solid = 0,
				angles = "0 180 0",
				origin = "0 0 30",
			},
		},
		[11] =
		{
			env_beam =
			{
				parentname = "",
				targetname = "roundbeamtest",
				BoltWidth = 4,
				LightningStart = "ringmarkerone",
				LightningEnd = "ringmarkertwo",
				origin = "0 0 30",
				renderamt = 200,
				rendercolor = "200 200 255",
				damage = 0,
				NoiseAmplitude = 4,
				dissolvetype = 1,
				texture = "sprites/laserbeam.spr",
				life = 4,
				spawnflags = 8,
				TouchType = 1,
			},
		},
	},
	oops_dropped_the_pow_block =
	{
		[0] =
		{
			OnSpawnOutput =
			{
				Target = "player",
				Action = "RunScriptCode",
				Param = "self.ViewPunch(QAngle(-50,0,0))",
				Delay = 0.2,
			},
		},
	},
	DrillTankV2 =
	{
		NoFixup = 1,
		[0] =
		{
			info_target =
			{
				targetname = "repair_here",
				origin = "0 0 0",
			},
		},
		[1] =
		{
			logic_relay =
			{
				targetname = "tank_drill",
				"onspawn#1" : "!parent,addoutput,onuser4 @c@!self:fireuser1::0:-1,0,-1",
			},
		},
		[2] =
		{
			trigger_brush =
			{
				targetname = "drill_trap",
				origin = "182 0 86",
				mins = "0 -25 -50",
				maxs = "50 25 30",
				"onuser1#1" : "!self,disable,,0,-1",
			},
		},
		[3] =
		{
			trigger_multiple =
			{
				targetname = "drill_hurt",
				origin = "182 0 86",
				mins = "-50 -40 -50",
				maxs = "50 40 50",
				spawnflags = 1,
				"ontrigger#1" : "driller,SetSpeed,25,0,-1",
				"ontrigger#2" : "!activator,bleedplayer,1,0,-1",
				"ontrigger#3" : "!activatorRunScriptCodeself.TakeDamage(25, 0, null)0-1",
				"ontrigger#4" : "!activatorRunScriptCodeself.TakeDamage(25, 0, null)0.25-1",
				"ontrigger#5" : "!activatorRunScriptCodeself.TakeDamage(25, 0, null)0.50-1",
				"ontrigger#6" : "!activatorRunScriptCodeself.TakeDamage(25, 0, null)0.75-1",
				"ontrigger#7" : "drill,Pitch,100,0,-1",
				"ontrigger#8" : "drill2,Pitch,100,0.25,-1",
				"ontrigger#9" : "drill3,Pitch,100,0.50,-1",
				"ontrigger#10" : "drill4,Pitch,100,0.75,-1",
				"onendtouch#1" : "driller,SetSpeed,75,0,-1",
				wait = 0.1,
				"onuser1#1" : "!self,disable,,0,-1",
			},
		},
		[4] =
		{
			ambient_generic =
			{
				targetname = "drill",
				message = "ambient/grinder/grinderbot_01.wav",
				health = 10,
				pitch = 100,
				pitchstart = 100,
				radius = 5000,
				spawnflags = 17,
				sourceentityname = "!parent",
				"onuser1#1" : "!self,stopsound,,0,-1",
			},
		},
		[5] =
		{
			ambient_generic =
			{
				targetname = "drill2",
				message = "ambient/grinder/grinderbot_02.wav",
				health = 10,
				pitch = 100,
				pitchstart = 100,
				radius = 5000,
				spawnflags = 17,
				sourceentityname = "!parent",
				"onuser1#1" : "!self,stopsound,,0,-1",
			},
		},
		[6] =
		{
			ambient_generic =
			{
				targetname = "drill3",
				message = "ambient/grinder/grinderbot_03.wav",
				health = 10,
				pitch = 100,
				pitchstart = 100,
				radius = 5000,
				spawnflags = 17,
				sourceentityname = "!parent",
				"onuser1#1" : "!self,stopsound,,0,-1",
			},
		},
		[7] =
		{
			ambient_generic =
			{
				targetname = "drill4",
				message = "mvm/physics/robo_impact_hard_05.wav",
				health = 10,
				pitch = 100,
				pitchstart = 100,
				radius = 5000,
				spawnflags = 17,
				sourceentityname = "!parent",
				"onuser1#1" : "!self,stopsound,,0,-1",
			},
		},
		[8] =
		{
			ambient_generic =
			{
				targetname = "drill_sound",
				message = "ambient/sawblade.wav",
				health = 10,
				pitch = 60,
				pitchstart = 60,
				radius = 5000,
				sourceentityname = "!parent",
				"onuser1#1" : "!self,stopsound,,0,-1",
			},
		},
		[9] =
		{
			ambient_generic =
			{
				targetname = "drill_sound",
				message = "ambient/sawblade.wav",
				health = 10,
				pitch = 60,
				pitchstart = 60,
				radius = 5000,
				sourceentityname = "!parent",
				"onuser1#1" : "!self,stopsound,,0,-1",
			},
		},
	},
	revsetup =
	{
		[0] =
		{
			OnSpawnOutput =
			{
				Target = "ambient_timer",
				Action = "enable",
			},
		},
		[1] =
		{
			OnSpawnOutput =
			{
				Target = "boton",
				Action = "Lock",
			},
		},
		[2] =
		{
			OnSpawnOutput =
			{
				Target = "the_light",
				Action = "Color",
				Param = "0 0 0",
			},
		},
		[3] =
		{
			OnSpawnOutput =
			{
				Target = "upgrade_light",
				Action = "TurnOff",
			},
		},
		[4] =
		{
			point_populator_interface =
			{
				targetname = "pop_interface",
			},
		},
		[5] =
		{
			tf_point_nav_interface =
			{
				Name = "skibidi",
			},
		},
		[6] =
		{
			OnSpawnOutput =
			{
				Target = "boton_elevator",
				Action = "lock",
			},
		},
		[7] =
		{
			func_button =
			{
				disablereceiveshadows = 0,
				health = 0,
				lip = 0,
				locked_sentence = 9,
				locked_sound = 2,
				movedir = "0 0 0",
				origin = "-1790 568 587",
				renderamt = 255,
				rendercolor = "255 255 255",
				spawnflags = 512,
				speed = 5,
				targetname = "boton_elevator",
				unlocked_sentence = 1,
				unlocked_sound = 0,
				wait = 999,
				"OnPressed#1" : "tf_gamerules,PlayVO,passtime/ball_smack.wav,0,-1",
				"OnPressed#2" : "tf_gamerules,PlayVO,ui/gamestartup22.mp3,5,-1",
				"OnPressed#3" : "wave_finished_relay,trigger,,0,-1",
				"OnPressed#4" : "activateelevatorwindows,ForceSpawn,,10,-1",
				"OnPressed#5" : "player,$displaytexthint,[OBJECTIVE] GET TO THE ELEVATOR!,5,-1",
				"OnPressed#6" : "GO,show,,1,-1",
				"OnPressed#7" : "camera,$EnableAll,,0,-1",
				"OnPressed#8" : "camera,$DisableAll,,5,-1",
				"OnPressed#9" : "bluespawn_visualiser*,disable,,0,-1",
				OnPressed = "hudhintRunScriptCodeself.KeyValueFromString(`message`, `[OBJECTIVE] GET TO THE ELEVATOR`)5-1",
				mins = "-40 -65 -75",
				maxs = "20 20 75",
			},
		},
		[8] =
		{
			training_annotation =
			{
				targetname = "GO",
				display_text = "Get to the elevator!",
				lifetime = 6,
				origin = "-2827 7074 788",
			},
		},
		[9] =
		{
			point_viewcontrol =
			{
				acceleration = 0,
				deceleration = 0,
				interpolatepositiontoplayer = 0,
				spawnflags = 0,
				speed = 0,
				wait = 10,
				targetname = "camera",
				origin = "-1717 6854 902",
				angles = "10 165 0",
			},
		},
		[10] =
		{
			prop_dynamic =
			{
				targetname = "doorknob",
				origin = "-1790 568 587",
				angles = "0 0 -90",
				model = "models/props_barnblitz/track_switchbox_bb.mdl",
				modelscale = 1.5,
				color = "255 255 255",
				disablebonefollowers = 1,
				disableshadows = 1,
			},
		},
		[11] =
		{
			light_dynamic =
			{
				targetname = "upgrade_light",
				spotlight_radius = 225,
				distance = 225,
				brightness = 5,
				pitch = 90,
				origin = "-1816 7648 1000",
				_light = "255 50 50",
				_inner_cone = 0,
				_cone = 0,
			},
		},
		[12] =
		{
			env_lightglow =
			{
				targetname = "the_light",
				origin = "-1797 7631 1017",
				rendercolor = "255 50 50",
				angles = "-60 135 0",
				spawnflags = 1,
				GlowProxySize = 3.0,
				HDRColorScale = 1,
				HorizontalGlowSize = 25,
				VerticalGlowSize = 25,
				MaxDist = 2,
				MinDist = 1,
			},
		},
		[13] =
		{
			prop_dynamic =
			{
				targetname = "upgrade_light_model",
				disableshadows = 1,
				model = "models/props_badlands/siloroom_light2.mdl",
				origin = "-1797 7631 1017",
				angles = "-60 135 0",
			},
		},
		[14] =
		{
			light_dynamic =
			{
				targetname = "upgrade_light",
				spotlight_radius = 225,
				distance = 225,
				brightness = 5,
				pitch = 90,
				origin = "-2296 7648 1000",
				_light = "255 50 50",
				_inner_cone = 0,
				_cone = 0,
			},
		},
		[15] =
		{
			env_lightglow =
			{
				targetname = "the_light",
				origin = "-2316 7631 1017",
				rendercolor = "255 50 50",
				angles = "60 -135 0",
				spawnflags = 1,
				GlowProxySize = 3.0,
				HDRColorScale = 1,
				HorizontalGlowSize = 25,
				VerticalGlowSize = 25,
				MaxDist = 2,
				MinDist = 1,
			},
		},
		[16] =
		{
			prop_dynamic =
			{
				targetname = "upgrade_light_model",
				disableshadows = 1,
				model = "models/props_badlands/siloroom_light2.mdl",
				origin = "-2316 7631 1017",
				angles = "60 -135 0",
			},
		},
		[17] =
		{
			ambient_generic =
			{
				targetname = "moosic",
				message = "#act1withintro.mp3",
				health = 9,
				pitch = 100,
				spawnflags = 17,
			},
		},
		[18] =
		{
			ambient_generic =
			{
				targetname = "moosic2",
				message = "#act1loop.mp3",
				health = 9,
				pitch = 100,
				spawnflags = 17,
			},
		},
		[19] =
		{
			trigger_catapult =
			{
				targetname = "bye",
				playerspeed = 1700,
				physicsSpeed = 1700,
				mins = "-400 -400 -80",
				maxs = "400 400 250",
				origin = "-4564 5791 450",
				applyAngularImpulse = 1,
				entryAngleTolerance = -1.0,
				AirCtrlSupressionTime = 0.33,
				onlyVelocityCheck = 0,
				lowerthreshold = 0,
				upperthreshold = 0.75,
				useExactVelocity = 1,
				spawnflags = 1,
				startdisabled = 1,
				launchTarget = "targe_target_2",
			},
		},
		[20] =
		{
			info_target =
			{
				targetname = "targe_target_2",
				origin = "-3729 6063 826",
			},
		},
		[21] =
		{
			logic_relay =
			{
				targetname = "waiterwaiter_nextsubwaveplease",
				"OnTrigger#1" : "pop_interface,$ResumeWavespawn,postblastdoorkill,6,1",
				"OnTrigger#2" : "tf_point_nav_interface*,recomputeblockers,,8,1",
				"OnTrigger#3" : "tf_point_nav_interface*,recomputeblockers,,9,1",
				"OnTrigger#4" : "03_door_flank_2_unlock_relay,trigger,,4,1",
				"OnTrigger#5" : "02_door_flank_2_unlock_relay,trigger,,4,1",
				"OnTrigger#6" : "itspartytime,start,,0,-1",
				"OnTrigger#7" : "itspartytime,stop,,3,-1",
				"OnTrigger#8" : "urmamajoke,StartShake,,0,-1",
				"OnTrigger#9" : "bye,enable,,0,1",
				"OnTrigger#10" : "bye,disable,,0.1,1",
				"OnTrigger#11" : "tf_gamerules,playvo,ambient/explosions/explode_2.wav,0,-1",
			},
		},
		[22] =
		{
			logic_relay =
			{
				targetname = "musiccontroler",
				"OnTrigger#1" : "moosic2,PlaySound,,0,-1",
				"OnTrigger#2" : "moosic2,StopSound,,156,-1",
				"OnTrigger#3" : "musiccontroler,trigger,,156,-1",
				spawnflags = 2,
			},
		},
		[23] =
		{
			logic_relay =
			{
				targetname = "upgrade_light_relay",
				"OnTrigger#1" : "the_light,Color,0,1.2,-1",
				"OnTrigger#2" : "upgrade_light,TurnOff,,1.2,-1",
				"OnTrigger#3" : "the_light,Color,255 50 50,0,-1",
				"OnTrigger#4" : "upgrade_light,TurnOn,,0,-1",
				"OnTrigger#5" : "upgrade_light_relay,Trigger,,2,-1",
				spawnflags = 2,
			},
		},
		[24] =
		{
			trigger_push =
			{
				alternateticksfix = 0,
				mins = "-224 -20 -650",
				maxs = "224 20 650",
				origin = "-4502 6210 643",
				pushdir = "200 -200 0",
				spawnflags = 1,
				speed = 300,
				targetname = "iguesswearentfriendsanymore",
				filtername = "blue_team_filter",
			},
		},
		[25] =
		{
			env_shake =
			{
				targetname = "urmamajoke",
				spawnflags = 5,
				amplitude = 10,
				duration = 10,
				frequency = 15,
				radius = 2000,
			},
		},
		[26] =
		{
			info_particle_system =
			{
				targetname = "itspartytime",
				origin = "-4739 5741 551",
				effect_name = "cinefx_goldrush",
				start_active = 0,
			},
		},
		[27] =
		{
			info_particle_system =
			{
				targetname = "itspartytime",
				origin = "-4533 5726 593",
				effect_name = "cinefx_goldrush",
				start_active = 0,
			},
		},
		[28] =
		{
			info_particle_system =
			{
				targetname = "itspartytime",
				origin = "-4742 5994 572",
				effect_name = "cinefx_goldrush",
				start_active = 0,
			},
		},
		[29] =
		{
			info_particle_system =
			{
				targetname = "itspartytime",
				origin = "-4739 5741 551",
				effect_name = "fireSmoke_Collumn_mvmAcres",
				start_active = 0,
			},
		},
		[30] =
		{
			info_particle_system =
			{
				targetname = "itspartytime",
				origin = "-4533 5726 593",
				effect_name = "fireSmoke_Collumn_mvmAcres",
				start_active = 0,
			},
		},
		[31] =
		{
			info_particle_system =
			{
				targetname = "itspartytime",
				origin = "-4742 5994 572",
				effect_name = "fireSmoke_Collumn_mvmAcres",
				start_active = 0,
			},
		},
		[32] =
		{
			game_round_win =
			{
				TeamNum = 3,
				targetname = "red_loses",
				switch_teams = 0,
				force_map_reset = 1,
				classname = "game_round_win",
			},
		},
		[33] =
		{
			game_round_win =
			{
				TeamNum = 2,
				targetname = "red_wins",
				switch_teams = 0,
				force_map_reset = 1,
				classname = "game_round_win",
			},
		},
		[34] =
		{
			logic_relay =
			{
				targetname = "redlose_relay",
				"OnTrigger#1" : "red_loses,RoundWin,,0,-1",
			},
		},
		[35] =
		{
			logic_relay =
			{
				targetname = "redwin_relay",
				"OnTrigger#1" : "red_wins,RoundWin,,0,-1",
			},
		},
		[36] =
		{
			logic_auto =
			{
				"OnMapSpawn#1" : "red_rev_mission_relay,trigger,,0.1,-1",
				"OnMapSpawn#2" : "carrier_disable_relay,trigger,,0,-1",
				"OnMapSpawn#3" : "drydock_open_relay,trigger,,0,-1",
				"OnMapSpawn#4" : "shortcut_bridge_retract_relay,trigger,,0,-1",
				"OnMapSpawn#5" : "01_door_lock_relay,trigger,,0,-1",
				"OnMapSpawn#6" : "02_door_lock_relay,trigger,,0,-1",
				"OnMapSpawn#7" : "03_door_lock_relay,trigger,,0,-1",
				"OnMapSpawn#8" : "04_door_lock_relay,trigger,,0,-1",
				"OnMapSpawn#9" : "05_door_lock_relay,trigger,,0,-1",
				"OnMapSpawn#10" : "06_door_lock_relay,trigger,,0,-1",
				"OnMapSpawn#11" : "08_door_lock_relay,trigger,,0,-1",
				"OnMapSpawn#12" : "02_door_flank_1_lock_relay,trigger,,0,-1",
				"OnMapSpawn#13" : "02_door_flank_2_lock_relay,trigger,,0,-1",
				"OnMapSpawn#14" : "03_door_flank_1_lock_relay,trigger,,0,-1",
				"OnMapSpawn#15" : "03_door_flank_2_lock_relay,trigger,,0,-1",
				"OnMapSpawn#16" : "silo_door_close,trigger,,0,-1",
				"OnMapSpawn#17" : "telezone,disable,,1,-1",
				"OnMapSpawn#18" : "telezone,enable,,0.1,-1",
				"OnMapSpawn#19" : "carrier_lift,setspeed,99999,0,-1",
				"OnMapSpawn#20" : "01_door,setspeed,99999,0,-1",
				"OnMapSpawn#21" : "01_door,setspeed,50,1,-1",
				"OnMapSpawn#22" : "tf_objective_resourceRunScriptCodeNetProps.SetPropString(self, `m_iszMvMPopfileName`, Termination - Indium Infiltration)0-1",
				"OnMapSpawn#23" : "emp_tank_path_8,AddOutput,OnPass emp_tank:SetSpeed:0:0:-1,0,-1",
				"OnMapSpawn#24" : "emp_tank_path_8,AddOutput,OnPass 03_door_unlock_relay:trigger::13:-1,0,-1",
				"OnMapSpawn#25" : "emp_tank_path_8,AddOutput,OnPass tf_point_nav_interface*:RecomputeBlockers::20:-1,0,-1",
				OnMapSpawn = "tf_gamerules,PlayVO,misc/doomsday_lift_start.wav,13,-1,0,-1",
				"OnMapSpawn#26" : "emp_tank_path_8,AddOutput,OnPass tankrequirementslegs*:SetAnimation:ref:0:-1,0,-1",
				"OnMapSpawn#27" : "emp_tank_path_8,AddOutput,OnPass totheengiboss:enable::0.1:-1,0,-1",
				"OnMapSpawn#28" : "emp_tank_path_8,AddOutput,OnPass flashpeoplewiththis:trigger::0.1:-1,0,-1",
				"OnMapSpawn#29" : "emp_tank_path_8,AddOutput,OnPass hudtimer:enable::12:-1,0,-1",
				OnMapSpawn = "emp_tank_path_8AddOutputOnPass hudhint:RunScriptCode:self.KeyValueFromString(`message`, `[OBJECTIVE] KILL THE BOSS AND CAPTURE THE POINT`):7:-16-1",
				"OnMapSpawn#30" : "emp_tank_path_8,AddOutput,OnPass tank_hologram_relay_left:trigger::7:-1,6,-1",
				"OnMapSpawn#31" : "emp_tank_path_8,AddOutput,OnPass player:$displaytexthint:NEW OBJECTIVE - KILL THE CHIEF TECHNICIAN AND CONTROL THE MAIN CONSOLE:3:-1,7,-1",
				"OnMapSpawn#32" : "emp_tank_path_21,AddOutput,OnPass emp_tank:SetSpeed:0:0:-1,0,-1",
				"OnMapSpawn#33" : "emp_tank_path_21,AddOutput,OnPass tankrequirementslegs*:SetAnimation:ref:0:-1,0,-1",
				"OnMapSpawn#34" : "emp_tank_path_21,AddOutput,OnPass tank_emp:SetAnimation:deploy:0.3:-1,0,-1",
				"OnMapSpawn#35" : "emp_tank_path_21,AddOutput,OnPass tank_emp:SetPlaybackRate:0.67:0.3:-1,0,-1",
				"OnMapSpawn#36" : "emp_tank_path_21,AddOutput,OnPass emp_tank:RemoveHealth:9999999:12.6:-1,0,-1",
				OnMapSpawn = "tf_gamerules,PlayVO,tank_emp_deploy.mp3,0.2,-1,0,-1",
				"OnMapSpawn#37" : "emp_tank_path_21,AddOutput,OnPass redlose_relay:disable::12.3:-1,0,-1",
				"OnMapSpawn#38" : "emp_tank_path_21,AddOutput,OnPass moosic*:kill::0:-1,0,-1",
				"OnMapSpawn#39" : "emp_tank_path_21,AddOutput,OnPass spawnbot*:Disable::12.6:-1,0,-1",
				"OnMapSpawn#40" : "emp_tank_path_21,AddOutput,OnPass red_spawn*:Disable::12.6:-1,0,-1",
				"OnMapSpawn#41" : "emp_tank_path_21,AddOutput,OnPass cleanupbots:Enable::12.6:-1,0,-1",
				"OnMapSpawn#42" : "emp_tank_path_21,AddOutput,OnPass cleanupbots:Disable::12.7:-1,0,-1",
				"OnMapSpawn#43" : "emp_tank_path_21,AddOutput,OnPass red_normal_mission_relay:trigger::12:-1,0,-1",
				"OnMapSpawn#44" : "emp_tank_path_21,AddOutput,OnPass func_respawnroomvisualizer*:disable::12.8:-1,0,-1",
				"OnMapSpawn#45" : "emp_tank_path_21,AddOutput,OnPass oops_dropped_the_pow_block:ForceSpawn::12.6:-1,0,-1",
				"OnMapSpawn#46" : "emp_tank_path_21,AddOutput,OnPass emp_fade:fade::12.6:-1,0,-1",
				"OnMapSpawn#47" : "emp_tank_path_21,AddOutput,OnPass boss_about_to_blow:start::7.6:-1,0,-1",
				"OnMapSpawn#48" : "emp_tank_path_21,AddOutput,OnPass die:start::12.5:-1,0,-1",
				"OnMapSpawn#49" : "emp_tank_path_21,AddOutput,OnPass boton_elevator:unlock::12.6:-1,0,-1",
				"OnMapSpawn#50" : "emp_tank_path_21,AddOutput,OnPass spawnbarrierA*:kill::12.6:-1,0,-1",
				"OnMapSpawn#51" : "emp_tank_path_21,Addoutput,OnPass breaker_glow:enable::12.6:-1,0,-1",
				"OnMapSpawn#52" : "emp_tank_path_21,AddOutput,OnPass player:$displaytexthint:New Objective - Melee the breaker box to activate the elevator:18:-1,0,-1",
				"OnMapSpawn#53" : "emp_tank_path_21,AddOutput,OnPass punch_me_breaker:show::18:-1,0,-1",
				"OnMapSpawn#54" : "tankd_path_23,AddOutput,OnPass !activator:RemoveHealth:99999;0:-1,0,-1",
				"OnMapSpawn#55" : "tankd_path_23,AddOutput,OnPass redlose_relay:trigger::0:-1,0,-1",
				"OnMapSpawn#56" : "tankd_path_23,AddOutput,OnPass emp_tank_down:start::0:-1,0,-1",
				OnMapSpawn = "tf_gamerules,PlayVO,items/cart_explode.wav,0,-1,0,-1",
			},
		},
		[37] =
		{
			trigger_hurt =
			{
				targetname = "cleanupbots",
				origin = "0 0 0",
				mins = "-10000 -10000 -10000",
				maxs = "15000 15000 15000",
				damage = 3000000,
				damagecap = 3000000,
				damagemodel = 0,
				damagetype = 16,
				filtername = "blue_team_filter",
				nodmgforce = 1,
				spawnflags = 1,
				StartDisabled = 1,
			},
		},
		[38] =
		{
			logic_relay =
			{
				targetname = "disablethesewavespawns",
				"OnTrigger#1" : "pop_interface,$PauseWavespawn,wavemainfocus,0,1",
				"OnTrigger#2" : "pop_interface,$PauseWavespawn,wavemainfocus_1,0,1",
				"OnTrigger#3" : "pop_interface,$PauseWavespawn,disablewavespawn,0,1",
				"OnTrigger#4" : "pop_interface,$PauseWavespawn,postblastdoorkill,0,1",
				"OnTrigger#5" : "pop_interface,$PauseWavespawn,finalpush,0,1",
				"OnTrigger#6" : "pop_interface,$PauseWavespawn,finalpush_2,0,1",
			},
		},
		[39] =
		{
			logic_relay =
			{
				targetname = "insertterminationsplashtext",
				"OnTrigger#1" : "preTitleRelay,trigger,,6.45,1",
				"OnTrigger#2" : "fadedtoblack,fade,,0,1",
				"OnTrigger#3" : "outrotext,Display,,1,1",
				"OnTrigger#4" : "outrotheme*,playsound,,5,1",
				"OnTrigger#5" : "outrotheme*,FadeOut,1,11.7,1",
				"OnTrigger#6" : "tf_gamerules,playvo,mvm/mvm_deploy_small.wav,6.5,1",
				"OnTrigger#7" : "tf_gamerules,playvo,mvm/mvm_deploy_small.wav,7.5,1",
				"OnTrigger#8" : "tf_gamerules,playvo,mvm/mvm_deploy_small.wav,8.5,1",
				"OnTrigger#9" : "tf_gamerules,$StopVO,mvm/mvm_deploy_small.wav,7.4,1",
				"OnTrigger#10" : "tf_gamerules,$StopVO,mvm/mvm_deploy_small.wav,8.4,1",
				"OnTrigger#11" : "tf_gamerules,$StopVO,mvm/mvm_deploy_small.wav,9.4,1",
			},
		},
		[40] =
		{
			env_screenoverlay =
			{
				targetname = "preTitleOverlayEnt",
				OverlayName1 = "overlays/term_title_0_0",
				OverlayName2 = "overlays/term_title_0_1",
				OverlayName3 = "overlays/term_title_0_2",
				OverlayTime1 = 0.15,
				OverlayTime2 = 0.15,
				OverlayTime3 = 0.15,
			},
		},
		[41] =
		{
			env_screenoverlay =
			{
				targetname = "titleOverlayEnt",
				OverlayName1 = "overlays/term_title_1",
				OverlayName2 = "overlays/term_title_2_0",
				OverlayName3 = "overlays/term_title_2_1",
				OverlayName4 = "overlays/term_title_2_2",
				OverlayName5 = "overlays/term_title_2_3",
				OverlayName6 = "overlays/term_title_2_4",
				OverlayName7 = "overlays/term_title_2_5",
				OverlayName8 = "overlays/term_title_3",
				OverlayName9 = "overlays/term_title_4_0",
				OverlayName10 = "overlays/term_title_4_1",
				OverlayTime1 = 2,
				OverlayTime2 = 0.15,
				OverlayTime3 = 0.15,
				OverlayTime4 = 0.15,
				OverlayTime5 = 0.15,
				OverlayTime6 = 0.15,
				OverlayTime7 = 0.15,
				OverlayTime8 = 4.0,
				OverlayTime9 = 0.2,
				OverlayTime10 = 0.2,
			},
		},
		[42] =
		{
			logic_relay =
			{
				targetname = "preTitleRelay",
				"OnTrigger#1" : "preTitleOverlayEnt,SwitchOverlay,1,0,0",
				"OnTrigger#2" : "preTitleOverlayEnt,StartOverlays,,0.1,0",
				"OnTrigger#3" : "preTitleOverlayEnt,StopOverlays,,0.56,0",
				"OnTrigger#4" : "titleRelay,trigger,,0.55,0",
			},
		},
		[43] =
		{
			logic_relay =
			{
				targetname = "titleRelay",
				"OnTrigger#1" : "titleOverlayEnt,SwitchOverlay,1,0,0",
				"OnTrigger#2" : "titleOverlayEnt,StartOverlays,,0.1,0",
				"OnTrigger#3" : "titleOverlayEnt,StopOverlays,,7.4,0",
			},
		},
		[44] =
		{
			ambient_generic =
			{
				targetname = "outrotheme",
				message = "#music/hl1_song5.mp3",
				health = 10,
				pitch = 100,
				spawnflags = 17,
			},
		},
		[45] =
		{
			ambient_generic =
			{
				targetname = "outrotheme",
				message = "#music/hl1_song5.mp3",
				health = 10,
				pitch = 100,
				spawnflags = 17,
			},
		},
		[46] =
		{
			prop_dynamic =
			{
				targetname = "emp_tank_prop",
				Model = "models/spybase/emp_tank.mdl",
				angles = "0 -90 0",
				Origin = "-2283 8763 688",
				startdisabled = 0,
				defaultanim = "deploy",
				disableshadows = 0,
				modelscale = 1,
				skin = 0,
				solid = 6,
				"onanimationbegun#1" : "!self,setplaybackrate,0.0001,0.1,-1",
				"onanimationbegun#2" : "emp_tank_propRunScriptCodeNetProps.SetPropBool(self, `m_bClientSideAnimation`, false); self.SetCycle(0.5)-1-1",
			},
		},
		[47] =
		{
			prop_dynamic =
			{
				targetname = "emp_tank_prop",
				model = "models/bots/boss_bot/tank_track_l.mdl",
				angles = "0 -90 0",
				solid = 0,
				modelscale = 1,
				origin = "-2338 8763 688",
			},
		},
		[48] =
		{
			prop_dynamic =
			{
				targetname = "emp_tank_prop",
				model = "models/bots/boss_bot/tank_track_l.mdl",
				angles = "0 -90 0",
				solid = 0,
				modelscale = 1,
				origin = "-2227 8763 688",
			},
		},
		[49] =
		{
			info_particle_system =
			{
				TargetName = "emp_tank_down",
				angles = "0 0 0",
				origin = "-2289 8788 748",
				effect_name = "cinefx_goldrush",
			},
		},
		[50] =
		{
			info_particle_system =
			{
				targetname = "emp_tank_down",
				origin = "-2289 8788 748",
				effect_name = "fireSmoke_Collumn_mvmAcres",
				start_active = 0,
			},
		},
		[51] =
		{
			prop_dynamic =
			{
				targetname = "emp_tank_prop_engi",
				Model = "models/bots/engineer/bot_engineer.mdl",
				angles = "0 45 90",
				Origin = "-2351 8760 763",
				startdisabled = 0,
				defaultanim = "Melee_Swing",
				disableshadows = 0,
				modelscale = 1,
				skin = 0,
				setbodygroup = 1,
				"onanimationbegun#1" : "!self,setplaybackrate,1.4,0.1,-1",
			},
		},
		[52] =
		{
			prop_dynamic_ornament =
			{
				targetname = "emp_tank_prop_engi_wrench",
				model = "models/weapons/c_models/c_wrench/c_wrench.mdl",
				color = "255 0 0",
				solid = 0,
				disablebonefollowers = 1,
				disableshadows = 1,
				skin = 1,
				initialowner = "emp_tank_prop_engi",
				startdisabled = 0,
			},
		},
		[53] =
		{
			game_text =
			{
				origin = "0 0 0",
				targetname = "outrotext",
				message = "POTATO.TF PRESENTS",
				x = -1,
				y = 0.5,
				effect = 2,
				spawnflags = 1,
				channel = 1,
				color = "255 255 255",
				fxtime = 0.2,
				fadeout = 1,
				holdtime = 5,
			},
		},
		[54] =
		{
			env_fade =
			{
				targetname = "fadedtoblack",
				duration = 5.5,
				holdtime = 3,
				rendercolor = "0 0 0",
			},
		},
		[55] =
		{
			logic_relay =
			{
				targetname = "nowtherealfightbegins",
				"OnTrigger#1" : "kablooey*,Start,,0,-1",
				"OnTrigger#2" : "kablooey*,Stop,,5,-1",
				"OnTrigger#3" : "tf_gamerules,playvo,vo/mvm/norm/engineer_mvm_dominationengineer_mvm06.mp3,5,1",
				"OnTrigger#4" : "tf_gamerules,playvo,vo/mvm/norm/engineer_mvm_paincriticaldeath02.mp3,0,1",
				"OnTrigger#5" : "tf_gamerules,playvo,misc/rd_robot_explosion01.wav,0,1",
			},
		},
		[56] =
		{
			trigger_once =
			{
				targetname = "intermission",
				origin = "-5065 5972 512",
				mins = "100 100 100",
				maxs = "-100 -100 -100",
				spawnflags = 1,
				"onstarttouch#1" : "02_door_flank_1_unlock_relay,trigger,,0,-1",
				"onstarttouch#2" : "tf_point_nav_interface*,recomputeblockers,,1,1",
				"onstarttouch#3" : "pop_interface,$ResumeWavespawn,disablewavespawn,6,-1",
				filtername = "blue_team_filter",
			},
		},
		[57] =
		{
			trigger_once =
			{
				targetname = "totheengiboss",
				origin = "-4572 3391 512",
				mins = "500 500 100",
				maxs = "-500 -500 -100",
				spawnflags = 1,
				startdisabled = 1,
				"onstarttouch#1" : "05_door_unlock_relay,trigger,,0,-1",
				"onstarttouch#2" : "06_door_unlock_relay,trigger,,0,-1",
				"onstarttouch#3" : "tf_point_nav_interface*,recomputeblockers,,1,1",
				"onstarttouch#4" : "pop_interface,$ResumeWavespawn,finalpush,0,1",
				"onstarttouch#5" : "flashpeoplewiththis,cancelpending,,0.1,-1",
				"onstarttouch#6" : "flashpeoplewiththis,disable,,0,-1",
				"onstarttouch#7" : "LOOKATMEBITCH*,disable,,0,-1",
				"onstarttouch#8" : "LOOKATMEBITCH3,enable,,0.1,-1",
				filtername = "red_team_filter",
			},
		},
		[58] =
		{
			func_nobuild =
			{
				targetname = "flavour_front",
				origin = "-1315 8033 688",
				mins = "-100 -200 -100",
				maxs = "100 200 100",
				AllowTeleporters = 0,
				AllowSentry = 0,
				AllowDispenser = 0,
			},
		},
		[59] =
		{
			func_forcefield =
			{
				disablereceiveshadows = 0,
				origin = "-1415 8027 688",
				renderamt = 255,
				rendercolor = "255 255 255",
				renderfx = 0,
				rendermode = 10,
				TeamNum = 3,
				targetname = "flavour_front",
				mins = "-20 -200 0",
				maxs = "20 200 3000",
				StartDisabled = 0,
				angles = "0 90 0",
			},
		},
		[60] =
		{
			func_forcefield =
			{
				disablereceiveshadows = 0,
				origin = "-1415 8027 688",
				renderamt = 255,
				rendercolor = "255 255 255",
				renderfx = 0,
				rendermode = 10,
				TeamNum = 2,
				targetname = "flavour_front",
				mins = "-20 -200 0",
				maxs = "20 200 3000",
				StartDisabled = 0,
				angles = "0 90 0",
			},
		},
		[61] =
		{
			info_particle_system =
			{
				targetname = "kablooey",
				origin = "0 0 30",
				angles = "0 0 0",
				effect_name = "mvm_tank_destroy",
			},
		},
		[62] =
		{
			info_particle_system =
			{
				targetname = "kablooey",
				origin = "0 0 60",
				angles = "0 0 0",
				effect_name = "cinefx_goldrush",
			},
		},
		[63] =
		{
			prop_dynamic =
			{
				origin = "-1417 7996 805",
				targetname = "flavour_front",
				model = "models/props_coalmines/wood_fence_256.mdl",
				angles = "0 90 0",
				solid = 1,
			},
		},
		[64] =
		{
			prop_dynamic =
			{
				origin = "-1417 7996 1065",
				targetname = "flavour_front",
				model = "models/props_coalmines/wood_fence_256.mdl",
				angles = "0 90 0",
				solid = 1,
			},
		},
		[65] =
		{
			prop_dynamic =
			{
				origin = "-1417 8126 805",
				targetname = "flavour_front",
				model = "models/props_coalmines/wood_fence_128.mdl",
				angles = "0 90 0",
				solid = 1,
			},
		},
		[66] =
		{
			prop_dynamic =
			{
				origin = "-1417 8126 1065",
				targetname = "flavour_front",
				model = "models/props_coalmines/wood_fence_128.mdl",
				angles = "0 90 0",
				solid = 1,
			},
		},
		[67] =
		{
			prop_dynamic =
			{
				origin = "-2215 7525 1060",
				targetname = "front_button",
				model = "models/props_powerhouse/emergency_launch_button.mdl",
				angles = "0 0 0",
				modelscale = 1.5,
				disableshadows = 1,
				parentname = "01_door",
				solid = 1,
			},
		},
		[68] =
		{
			tf_glow =
			{
				GlowColor = "255 255 255 255",
				target = "front_button",
				targetname = "heytouchthis",
				startdisabled = 1,
			},
		},
		[69] =
		{
			prop_dynamic =
			{
				origin = "-5226 1940 536",
				targetname = "spy_terminal",
				model = "models/player/hwm/spy.mdl",
				defaultanim = "taunttailored_terminal_a2",
				angles = "0 125 0",
				modelscale = 1,
				disableshadows = 1,
				disablebonefollowers = 1,
				startdisabled = 1,
				solid = 1,
			},
		},
		[70] =
		{
			prop_dynamic_ornament =
			{
				targetname = "spy_terminal_skin",
				model = "models/bots/spy/bot_spy.mdl",
				modelscale = 1,
				solid = 0,
				skin = 1,
				disablebonefollowers = 1,
				disableshadows = 1,
				initialowner = "spy_terminal",
			},
		},
		[71] =
		{
			prop_dynamic =
			{
				origin = "-5253 1943 588",
				model = "models/props_moonbase/moon_interior_keyboard01.mdl",
				angles = "0 320 0",
				modelscale = 0.74,
				disableshadows = 1,
				disablebonefollowers = 1,
				solid = 1,
			},
		},
		[72] =
		{
			logic_relay =
			{
				"onspawn#1" : "cap_point_b_cap,setcontrolpoint,cap_point_b,0,-1",
			},
		},
		[73] =
		{
			team_control_point_master =
			{
				targetname = "cap_master",
				cpm_restrict_team_cap_win = 1,
				custom_position_x = 0.3,
			},
		},
		[74] =
		{
			prop_dynamic =
			{
				targetname = "cap_point_b_base",
				origin = "-5060 1790 536",
				model = "models/props_gameplay/cap_point_base.mdl",
				solid = 0,
				skin = 0,
			},
		},
		[75] =
		{
			trigger_capture_area =
			{
				targetname = "cap_point_b_cap",
				origin = "-5060 1790 536",
				area_time_to_cap = 20,
				area_cap_point = "cap_point_b",
				team_cancap_2 = 1,
				team_cancap_3 = 0,
				mins = "-210 -175 -166",
				solid = 0,
				maxs = "210 175 166",
			},
		},
		[76] =
		{
			team_control_point =
			{
				targetname = "cap_point_b",
				solid = 0,
				disableshadows = 1,
				origin = "-5060 1790 536",
				point_printname = "Main Console",
				point_default_owner = 3,
				point_index = 0,
				point_start_locked = 0,
				team_model_0 = "models/effects/mvm_holograms/mvm_cappoint_hologram_onlyblue.mdl",
				team_model_2 = "models/effects/mvm_holograms/mvm_cappoint_hologram.mdl",
				team_model_3 = "models/effects/mvm_holograms/mvm_cappoint_hologram_onlyblue.mdl",
				team_icon_0 = "sprites/obj_icons/icon_obj_neutral",
				team_icon_2 = "sprites/obj_icons/icon_obj_red",
				team_icon_3 = "sprites/obj_icons/icon_obj_blu",
				team_overlay_0 = "sprites/obj_icons/icon_obj_a",
				team_overlay_2 = "sprites/obj_icons/icon_obj_a",
				team_overlay_3 = "sprites/obj_icons/icon_obj_a",
				"oncapteam1#1" : "tf_gamerules,PlayVO,ambient/alarms/klaxon1.wav,2,-1",
				"oncapteam1#2" : "tf_gamerules,PlayVO,ambient/alarms/klaxon1.wav,5,-1",
				"oncapteam1#3" : "tf_gamerules,PlayVO,ambient/alarms/klaxon1.wav,8,-1",
				"oncapteam1#4" : "activateBridge,trigger,,2,-1",
				"oncapteam1#5" : "pop_interface,$ResumeWavespawn,finalpush_2,20,-1",
				"oncapteam1#6" : "tankrequirementslegs*,SetAnimation,forward,20,-1",
				"oncapteam1#7" : "tankrequirementslegs*,SetPlaybackRate,0.35,20,-1",
				"oncapteam1#8" : "emp_tank,setspeed,50,20,-1",
				oncapteam1 = "hudhintRunScriptCodeself.KeyValueFromString(`message`, `[OBJECTIVE] ESCORT THE TANK!`)20-1",
			},
		},
		[77] =
		{
			logic_relay =
			{
				targetname = "activateBridge",
				"OnTrigger#1" : "shortcut_bridge_extend_relay,trigger,,0,-1",
				"OnTrigger#2" : "drydock_close_relay,trigger,,0,-1",
				"OnTrigger#3" : "04_door_unlock_relay,trigger,,0,-1",
			},
		},
		[78] =
		{
			logic_timer =
			{
				"Ontimer#1" : "tf_gamerules,PlayVO,ambient/alarms/citadel_alert_loop2.wav,1,-1",
				"Ontimer#2" : "tf_gamerules,$StopVO,ambient/alarms/citadel_alert_loop2.wav,7.2,-1",
				targetname = "ambient_timer",
				RefireTime = 60,
			},
		},
		[79] =
		{
			func_button =
			{
				disablereceiveshadows = 0,
				health = 0,
				lip = 0,
				locked_sentence = 9,
				locked_sound = 2,
				movedir = "0 0 0",
				origin = "-2064 7505 750",
				renderamt = 255,
				rendercolor = "255 255 255",
				spawnflags = 512,
				speed = 5,
				targetname = "boton",
				unlocked_sentence = 1,
				unlocked_sound = 0,
				wait = 999,
				"OnPressed#1" : "01_door_unlock_relay,trigger,,12,-1",
				"OnPressed#2" : "upgrade_light_relay,trigger,,0,-1",
				"OnPressed#3" : "tf_gamerules,playvo,wee_woo_wee_woo.mp3,2,1",
				"OnPressed#4" : "tf_gamerules,playvo,ambient/machines/spindown.wav,11.6,1",
				"OnPressed#5" : "tf_gamerules,playvo,passtime/ball_smack.wav,0,-1",
				"OnPressed#6" : "tf_gamerules,playvo,ambient/alarms/klaxon1.wav,0,1",
				"OnPressed#7" : "tf_gamerules,playvo,ambient/alarms/klaxon1.wav,2,1",
				"OnPressed#8" : "tf_gamerules,playvo,ambient/alarms/klaxon1.wav,4,1",
				"OnPressed#9" : "tf_gamerules,playvo,ambient/alarms/klaxon1.wav,6,1",
				"OnPressed#10" : "tf_gamerules,playvo,ambient/alarms/klaxon1.wav,8,1",
				"OnPressed#11" : "tf_gamerules,playvo,ambient/alarms/klaxon1.wav,10,1",
				"OnPressed#12" : "tf_gamerules,playvo,ambient/alarms/klaxon1.wav,12,1",
				"OnPressed#13" : "playerRunScriptCodeClientPrint(self, 3, `/x07ffb200[ Now Playing: `)5-1",
				"OnPressed#14" : "pop_interface,$ResumeWavespawn,wavemainfocus,3,-1",
				"OnPressed#15" : "pop_interface,$ResumeWavespawn,wavemainfocus_1,11,-1",
				"OnPressed#16" : "moosic,StopSound,,258,1",
				"OnPressed#17" : "musiccontroler,trigger,,258,-1",
				"OnPressed#18" : "moosic,playsound,,6,-1",
				"OnPressed#19" : "!self,kill,,12,-1",
				"OnPressed#20" : "hudtimer,disable,,0,-1",
				"OnPressed#21" : "heytouchthis,disable,,0.5,-1",
				"OnPressed#22" : "hudhint,hidehudhint,,0,-1",
				"OnPressed#23" : "text,display,,4,-1",
				"OnPressed#24" : "text_lower,display,,5,-1",
				mins = "-40 -65 -75",
				maxs = "20 30 75",
			},
		},
		[80] =
		{
			game_text =
			{
				origin = "0 0 0",
				targetname = "text",
				message = "ACT 1",
				x = -1,
				y = 0.4,
				effect = 2,
				spawnflags = 1,
				channel = 1,
				color = "255 255 255",
				fxtime = 0.2,
				fadeout = 1,
				holdtime = 5,
			},
		},
		[81] =
		{
			game_text =
			{
				origin = "0 0 0",
				targetname = "text_lower",
				message = "INDIUM INFILTRATION",
				x = -1,
				y = 0.45,
				effect = 2,
				channel = 0,
				spawnflags = 1,
				color = "255 255 255",
				fadein = 0.05,
				fadeout = 1,
				holdtime = 4.8,
			},
		},
		[82] =
		{
			func_flagdetectionzone =
			{
				targetname = "drill_repairzone",
				mins = "-300 -300 -60",
				maxs = "250 300 60",
				origin = "-4906 5608 512",
				TeamNum = 2,
				"OnStartTouchFlag#1" : "bomb1_timed,ForceDrop,,0,-1",
				"OnDroppedFlag#1" : "bomb1_timed,setreturntime,12,0,-1",
				"OnDroppedFlag#2" : "bomb1_timed,SetTeam,2,0,-1",
				"OnDroppedFlag#3" : "hologrambomb,kill,,0,-1",
				"OnDroppedFlag#4" : "rotatebomb,kill,,0,-1",
			},
		},
		[83] =
		{
			func_rotating =
			{
				targetname = "rotatebomb",
				maxspeed = 80,
				origin = "-4639 5782 512",
				spawnflags = 65,
				dmg = 0,
				fanfriction = 0,
			},
		},
		[84] =
		{
			prop_dynamic =
			{
				parentname = "rotatebomb",
				targetname = "hologrambomb",
				angles = "0 0 0",
				DisableBoneFollowers = 1,
				disablereceiveshadows = 1,
				model = "models/props_td/atom_bomb.mdl",
				disableshadows = 1,
				origin = "-4639 5782 512",
				modelscale = 1,
				startdisabled = 1,
				renderfx = 15,
				solid = 0,
			},
		},
		[85] =
		{
			prop_dynamic =
			{
				targetname = "meantoblowup",
				angles = "0 30 0",
				DisableBoneFollowers = 1,
				disablereceiveshadows = 1,
				model = "models/robot_factory/monorail/trains/monorail_cargo_container_separate_open.mdl",
				disableshadows = 1,
				origin = "-4743 5735 590",
				modelscale = 1,
				solid = 6,
			},
		},
		[86] =
		{
			prop_dynamic =
			{
				targetname = "meantoblowup",
				angles = "0 37 0",
				DisableBoneFollowers = 1,
				disablereceiveshadows = 1,
				model = "models/robot_factory/monorail/trains/monorail_cargo_container_separate_open.mdl",
				disableshadows = 1,
				origin = "-4743 5735 715",
				modelscale = 1,
				solid = 6,
			},
		},
		[87] =
		{
			prop_dynamic =
			{
				targetname = "spawnbarrierA",
				angles = "0 135 0",
				DisableBoneFollowers = 1,
				disablereceiveshadows = 1,
				model = "models/mvm/barrier/barrier_spawn_blue1.mdl",
				disableshadows = 1,
				origin = "-2497 1743 602",
				modelscale = 0.75,
				solid = 6,
			},
		},
		[88] =
		{
			prop_dynamic =
			{
				targetname = "spawnbarrierA",
				angles = "0 90 0",
				DisableBoneFollowers = 1,
				disablereceiveshadows = 1,
				model = "models/mvm/barrier/barrier_spawn_blue1.mdl",
				disableshadows = 1,
				origin = "-1505 1536 602",
				modelscale = 0.75,
				solid = 6,
			},
		},
		[89] =
		{
			prop_dynamic =
			{
				targetname = "locker_model",
				model = "models/props_gameplay/resupply_locker.mdl",
				solid = 6,
				angles = "0 135 0",
				origin = "-1361 9264 688",
				disableshadows = 1,
			},
		},
		[90] =
		{
			func_regenerate =
			{
				StartDisabled = 0,
				targetname = "regenerate",
				TeamNum = 2,
				mins = "-60 -60 -96",
				maxs = "135 60 96",
				origin = "-1361 9264 688",
				"OnStartTouch#1" : "regenerate,Disable,,0,-1",
				"OnEndTouchAll#1" : "regenerate,Enable,,0,-1",
				"OnStartTouchAll#1" : "locker_model,SetAnimation,open,0,-1",
				"OnEndTouchAll#2" : "locker_model,SetAnimation,close,0,-1",
				associatedmodel = "locker_model",
				spawnflags = 1,
			},
		},
		[91] =
		{
			info_target =
			{
				targetname = "spawn_info_target",
				origin = "-1362 9449 688",
			},
		},
		[92] =
		{
			trigger_teleport =
			{
				spawnflags = 1,
				targetname = "telezone",
				origin = "-1821 1121 512",
				target = "spawn_info_target",
				mins = "-500 -500 -500",
				maxs = "500 500 500",
			},
		},
		[93] =
		{
			logic_timer =
			{
				targetname = "hudtimer",
				RefireTime = 2.0,
				StartDisabled = 1,
				"OnTimer#1" : "hudhint,showhudhint,,0,-1",
			},
		},
		[94] =
		{
			env_hudhint =
			{
				targetname = "hudhint",
				message = "MOUSE1: INTERACT WITH PROPS",
				spawnflags = 1,
			},
		},
	},
}
SpawnTemplate("revsetup")