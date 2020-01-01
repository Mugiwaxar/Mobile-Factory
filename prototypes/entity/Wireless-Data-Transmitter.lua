----------------------------------------------------- WIRELESS DATA TRANSMITTER ---------------------------------

-- Entity --
wdtE = {}
wdtE.type = "container"
wdtE.name = "WirelessDataTransmitter"
wdtE.icon = "__Mobile_Factory__/graphics/matter-serialization/WirelessDataTransmitterI.png"
wdtE.icon_size = 64
wdtE.flags = {"placeable-neutral", "player-creation"}
wdtE.minable = {mining_time = 0.2, result = "WirelessDataTransmitter"}
wdtE.max_health = 100
wdtE.corpse = "small-remnants"
wdtE.render_not_in_network_icon = false
wdtE.collision_box = {{-1.8, -1.6}, {1.8, 1.8}}
wdtE.selection_box = wdtE.collision_box
wdtE.inventory_size = 0
wdtE.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" }
wdtE.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" }
wdtE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
wdtE.picture =
    {
      layers =
      {
        {
            filename = "__Mobile_Factory__/graphics/matter-serialization/WirelessDataTransmitterE.png",
            priority = "extra-high",
            width = 400,
            height = 400,
            shift = {0,-0.2},
            scale = 1/10 * 3.2
        },
        {
            filename = "__Mobile_Factory__/graphics/matter-serialization/WirelessDataTransmitterS.png",
            priority = "high",
            width = 400,
            height = 400,
            shift = {1.8,0.4},
            draw_as_shadow = true,
            scale = 1/10 * 3.2
        }
      }
    }
wdtE.circuit_wire_connection_point =
{
	wire = {green={-0.05,0.82}, red={0.05,0.82}},
	shadow = {green={-0.05,0.85}, red={0.05,0.85}}
}
wdtE.circuit_connector_sprites = nil
wdtE.circuit_wire_max_distance = 20
data:extend{wdtE}

-- Item --
local wdtI = {}
wdtI.type = "item"
wdtI.name = "WirelessDataTransmitter"
wdtI.icon = "__Mobile_Factory__/graphics/matter-serialization/WirelessDataTransmitterI.png"
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
      {"DimensionalPlate", 15},
      {"DimensionalCrystal", 8},
      {"radar", 1}
    }
wdtR.result = "WirelessDataTransmitter"
data:extend{wdtR}

-- Animation --
wdtA = {}
wdtA.name = "WirelessDataTransmitterA"
wdtA.type = "animation"
wdtA.frame_count = 60
wdtA.filename = "__Mobile_Factory__/graphics/matter-serialization/WirelessDataTransmitterA.png"
wdtA.size = 500
wdtA.line_length = 10
wdtA.animation_speed = 1/6
wdtA.scale = 1/8 * 3.2
wdtA.flags = {"terrain"}
data:extend{wdtA}