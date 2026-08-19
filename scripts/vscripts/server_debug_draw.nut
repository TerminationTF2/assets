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

const SF_BEAM_STARTON = 0x1

PrecacheModel("sprites/laserbeam.vmt")

::DebugDraw <-
{
	BoxEdges =
	[
        [0, 1], [0, 2], [0, 4], [1, 3],
        [1, 5], [2, 3], [2, 6], [3, 7],
        [4, 5], [4, 6], [5, 7], [6, 7]
	]

	function Line(start, end, r, g, b, duration)
	{
		local beam = Entities.CreateByClassname("env_beam")
		NetProps.SetPropBool(beam, "m_bForcePurgeFixedupStrings", true)

		beam.SetModel("sprites/laserbeam.vmt")
		NetProps.SetPropFloat(beam, "m_fWidth", 0.5)
		NetProps.SetPropFloat(beam, "m_fEndWidth", 0.5)
		beam.KeyValueFromInt("spawnflags", SF_BEAM_STARTON)
		NetProps.SetPropInt(beam, "m_clrRender", r | (g << 8) | (b << 16) | (255 << 24))
		beam.AddEFlags(EFL_IN_SKYBOX)
		beam.DispatchSpawn()

		beam.SetAbsOrigin(start)
		NetProps.SetPropVector(beam, "m_vecEndPos", end)

		EntFireByHandle(beam, "Kill", "", duration, null, null)
	}

	function Box(origin, mins, maxs, r, g, b, duration, angles = null)
	{
		local abs_mins = origin + mins
		local abs_maxs = origin + maxs

		local min = @(a, b) a < b ? a : b
		local max = @(a, b) a > b ? a : b

		abs_mins.x = min(abs_mins.x, abs_maxs.x)
		abs_mins.y = min(abs_mins.y, abs_maxs.y)
		abs_mins.z = min(abs_mins.z, abs_maxs.z)
		abs_maxs.x = max(abs_mins.x, abs_maxs.x)
		abs_maxs.y = max(abs_mins.y, abs_maxs.y)
		abs_maxs.z = max(abs_mins.z, abs_maxs.z)

		local verts = array(8)
		verts[0] = Vector(abs_mins.x, abs_mins.y, abs_mins.z)
		verts[1] = Vector(abs_mins.x, abs_mins.y, abs_maxs.z)
		verts[2] = Vector(abs_mins.x, abs_maxs.y, abs_mins.z)
		verts[3] = Vector(abs_mins.x, abs_maxs.y, abs_maxs.z)
		verts[4] = Vector(abs_maxs.x, abs_mins.y, abs_mins.z)
		verts[5] = Vector(abs_maxs.x, abs_mins.y, abs_maxs.z)
		verts[6] = Vector(abs_maxs.x, abs_maxs.y, abs_mins.z)
		verts[7] = Vector(abs_maxs.x, abs_maxs.y, abs_maxs.z)

		if (angles)
		{
			foreach (i, vert in verts)
			{
				vert -= origin
				vert = RotatePosition(Vector(), angles, vert)
				verts[i] = vert + origin
			}
		}

		foreach (edge in BoxEdges)
			Line(verts[edge[0]], verts[edge[1]], r, g, b, duration)
	}

	function Trigger(trigger, r, g , b, duration)
	{
		local origin = trigger.GetOrigin()
		local mins = trigger.GetBoundingMins()
		local maxs = trigger.GetBoundingMaxs()

		switch (trigger.GetSolid())
		{
			case SOLID_BSP:
				trigger.EnableDraw()
				EntFireByHandle(trigger, "RunScriptCode", "self.DisableDraw()", duration, null, null)
				break
			case SOLID_BBOX:
				Box(origin, mins, maxs, r, g, b, duration)
				break
			case SOLID_OBB:
				Box(origin, mins, maxs, r, g, b, duration, trigger.GetAbsAngles())
				break
			case SOLID_OBB_YAW:
				printl("SOLID_OBB_YAW is not implemented in the engine, use SOLID_OBB with x&z=0 instead.")
				break
			default:
				printf("Trigger(%i, ...) is unimplemented.\n", trigger.GetSolid())
		}
	}
}
