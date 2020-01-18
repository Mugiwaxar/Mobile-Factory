----------------------------------------------------- WIRELESS DATA TRANSMITTER ---------------------------------

-- Entity --
wdtE = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
wdtE.type = "constant-combinator"
wdtE.name = "WirelessDataTransmitter"
wdtE.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/WirelessDataTransmitterI.png"
wdtE.icon_size = 64
wdtE.minable = {mining_time = 0.2, result = "WirelessDataTransmitter"}
wdtE.max_health = 200
wdtE.corpse = "big-remnants"
wdtE.collision_box = {{-1.8, -1.8}, {1.8, 1.8}}
wdtE.selection_box = wdtE.collision_box
wdtE.item_slot_count = 999
wdtE.circuit_wire_max_distance = 20
wdtE.circuit_connector_sprites = nil
wdtE.sprites.sheets =
	{	{
            filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/WirelessDataTransmitterE.png",
            width = 400,
            height = 400,
            shift = {0,-0.2},
            scale = 1/10 * 3.2,
			frames = 1
        },
        {
            filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/WirelessDataTransmitterS.png",
            width = 400,
            height = 400,
            shift = {1.8,0.4},
            draw_as_shadow = true,
            scale = 1/10 * 3.2,
			frames = 1
        }
    }
wdtE.circuit_wire_connection_points =
{
	{
		wire = {green={-0.05,0.82}, red={0.05,0.82}},
		shadow = {green={-0.05,0.85}, red={0.05,0.85}}
	},
	{
		wire = {green={-0.05,0.82}, red={0.05,0.82}},
		shadow = {green={-0.05,0.85}, red={0.05,0.85}}
	},
	{
		wire = {green={-0.05,0.82}, red={0.05,0.82}},
		shadow = {green={-0.05,0.85}, red={0.05,0.85}}
	},
	{
		wire = {green={-0.05,0.82}, red={0.05,0.82}},
		shadow = {green={-0.05,0.85}, red={0.05,0.85}}
	}
}
data:extend{wdtE}

-- Item --
local wdtI = {}
wdtI.type = "item"
wdtI.name = "WirelessDataTransmitter"
wdtI.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/WirelessDataTransmitterI.png"
wdtI.icon_size = 64
wdtI.place_result = "WirelessDataTransmitter"
wdtI.subgroup = "DataSerialization"
wdtI.order = "e"
wdtI.stack_size = 10
data:extend{wdtI}

-- Recipe --
local wdtR = {}
wdtR.type = "recipe"
wdtR.name = "WirelessDataTransmitter"
wdtR.energy_required = 6
wdtR.enabled = false
wdtR.ingredients =
    {
      {"CrystalizedCircuit", 18},
      {"MachineFrame3", 6}
    }
wdtR.result = "WirelessDataTransmitter"
data:extend{wdtR}

-- Animation --
wdtA = {}
wdtA.name = "WirelessDataTransmitterA"
wdtA.type = "animation"
wdtA.frame_count = 60
wdtA.filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/WirelessDataTransmitterA.png"
wdtA.size = 500
wdtA.line_length = 10
wdtA.animation_speed = 1/6
wdtA.scale = 1/8 * 3.2
wdtA.flags = {"terrain"}
data:extend{wdtA}