---------------------------------- MATTER PRINTER ---------------------------

-- Entity --
mpE = {}
mpE.type = "logistic-container"
mpE.name = "MatterPrinter"
mpE.icon = "__Mobile_Factory__/graphics/matter-serialization/MatterPrinterI.png"
mpE.icon_size = 64
mpE.flags = {"placeable-neutral", "player-creation"}
mpE.minable = {mining_time = 0.5, result = "MatterPrinter"}
mpE.max_health = 100
mpE.corpse = "small-remnants"
mpE.logistic_mode = "buffer"
mpE.logistic_slots_count = 1
mpE.render_not_in_network_icon = false
mpE.collision_box = {{-0.35, -0.35}, {0.35, 0.35}}
mpE.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
mpE.inventory_size = 1
mpE.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" }
mpE.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" }
mpE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
mpE.picture =
    {
      layers =
      {
        {
            filename = "__Mobile_Factory__/graphics/matter-serialization/MatterPrinterE.png",
            priority = "extra-high",
            width = 400,
            height = 400,
            shift = {0,0},
            scale = 1/400*33
        },
        {
            filename = "__Mobile_Factory__/graphics/matter-serialization/MatterPrinterS.png",
            priority = "high",
            width = 400,
            height = 400,
            shift = {1.3,0.1},
            draw_as_shadow = true,
            scale = 1/200*30
        }
      }
    }
mpE.circuit_wire_connection_point =
{
	wire = {red={0,0.14}, green={0,0.14}},
	shadow = {red={0,0.14}, green={0,0.14}}
}
mpE.circuit_connector_sprites = nil
mpE.circuit_wire_max_distance = 20
data:extend{mpE}

-- Item --
local mpI = {}
mpI.type = "item"
mpI.name = "MatterPrinter"
mpI.icon = "__Mobile_Factory__/graphics/matter-serialization/MatterPrinterI.png"
mpI.icon_size = 64
mpI.place_result = "MatterPrinter"
mpI.subgroup = "DataSerialization"
mpI.order = "d"
mpI.stack_size = 20
data:extend{mpI}


-- Recipe --
local mpR = {}
mpR.type = "recipe"
mpR.name = "MatterPrinter"
mpR.energy_required = 2
mpR.enabled = false
mpR.ingredients =
    {
      {"CrystalizedCircuit", 8},
      {"MachineFrame3", 2}
    }
mpR.result = "MatterPrinter"
data:extend{mpR}

-- Animation --
mpA = {}
mpA.name = "MatterPrinterA"
mpA.type = "animation"
mpA.frame_count = 80
mpA.filename = "__Mobile_Factory__/graphics/matter-serialization/MatterPrinterAn.png"
mpA.width = 340
mpA.height = 380
mpA.line_length = 10
mpA.animation_speed = 1/4
mpA.scale = 1/400*33
mpA.flags = {"terrain"}
data:extend{mpA}