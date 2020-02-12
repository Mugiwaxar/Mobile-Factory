-- WIRELESS DATA RECEIVER --

-- Entity --
wdrE = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
table.insert(wdrE.flags, "not-rotatable")
wdrE.type = "constant-combinator"
wdrE.name = "WirelessDataReceiver"
wdrE.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/WirelessDataReceiverI.png"
wdrE.icon_size = 64
wdrE.minable = {mining_time = 0.5, result = "WirelessDataReceiver"}
wdrE.max_health = 200
wdrE.corpse = "big-remnants"
wdrE.collision_box = {{-1, -1}, {1, 1}}
wdrE.selection_box = wdrE.collision_box
wdrE.item_slot_count = 999
wdrE.circuit_wire_max_distance = 20
wdrE.circuit_connector_sprites = nil
wdrE.sprites.sheets =
	{	{
			filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/WirelessDataReceiverE.png",
			width = 200,
			height = 400,
			scale = 1 / 2.5,
			shift = {0,-1.5},
			frames = 1
		},
		{
			filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/WirelessDataReceiverS.png",
			draw_as_shadow = true,
			width = 400,
			height = 200,
			scale = 1/2,
			shift = {3.0,0.1},
			frames = 1
		}
	}
wdrE.circuit_wire_connection_points =
{
	{
		wire = {green={-0.1,0.2}, red={0,0.2}},
		shadow = {green={-0.1,0.3}, red={0,0.3}}
	},
	{
		wire = {green={-0.1,0.2}, red={0,0.2}},
		shadow = {green={-0.1,0.3}, red={0,0.3}}
	},
	{
		wire = {green={-0.1,0.2}, red={0,0.2}},
		shadow = {green={-0.1,0.3}, red={0,0.3}}
	},
	{
		wire = {green={-0.1,0.2}, red={0,0.2}},
		shadow = {green={-0.1,0.3}, red={0,0.3}}
	}
}
data:extend{wdrE}

-- Item --
local wdrI = {}
wdrI.type = "item"
wdrI.name = "WirelessDataReceiver"
wdrI.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/WirelessDataReceiverI.png"
wdrI.icon_size = 64
wdrI.place_result = "WirelessDataReceiver"
wdrI.subgroup = "DataSerialization"
wdrI.order = "f"
wdrI.stack_size = 10
data:extend{wdrI}

-- Recipe --
local wdrR = {}
wdrR.type = "recipe"
wdrR.name = "WirelessDataReceiver"
wdrR.energy_required = 5
wdrR.enabled = false
wdrR.ingredients =
    {
      {"CrystalizedCircuit", 10},
      {"MachineFrame3", 3}
    }
wdrR.result = "WirelessDataReceiver"
data:extend{wdrR}

-- Animation --
wdrA = {}
wdrA.name = "WirelessDataReceiverA"
wdrA.type = "animation"
wdrA.frame_count = 120
wdrA.filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/WirelessDataReceiverA.png"
wdrA.width = 100
wdrA.height = 400
wdrA.line_length = 10
wdrA.animation_speed = 1/6
wdrA.scale = 1/10 * 3.0
wdrA.flags = {"terrain"}
data:extend{wdrA}