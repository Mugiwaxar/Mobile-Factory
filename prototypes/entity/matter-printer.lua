---------------------------------- MATTER PRINTER ---------------------------

-- Entity --
mpE = {}
mpE.type = "logistic-container"
mpE.name = "MatterPrinter"
mpE.icon = "__Mobile_Factory__/graphics/icones/RequesterPad.png"
mpE.icon_size = 32
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
            filename = "__Mobile_Factory__/graphics/entity/RequesterPad.png",
            priority = "extra-high",
            width = 62,
            height = 72,
            shift = util.by_pixel(0.5, -2),
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/wooden-chest/hr-wooden-chest-shadow.png",
            priority = "extra-high",
            width = 104,
            height = 40,
            shift = util.by_pixel(10, 6.5),
            draw_as_shadow = true,
            scale = 0.5
        }
      }
    }
mpE.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
mpE.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
mpE.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{mpE}

-- Item --
local rcI = {}
rcI.type = "item"
rcI.name = "MatterPrinter"
rcI.icon = "__Mobile_Factory__/graphics/icones/RequesterPad.png"
rcI.icon_size = 32
rcI.place_result = "MatterPrinter"
rcI.subgroup = "Pad"
rcI.order = "a"
rcI.stack_size = 20
data:extend{rcI}


-- Recipe --
local rcI = {}
rcI.type = "recipe"
rcI.name = "MatterPrinter"
rcI.energy_required = 2
rcI.enabled = false
rcI.ingredients =
    {
      {"iron-chest", 1},
      {"DimensionalPlate", 10},
    }
rcI.result = "MatterPrinter"
data:extend{rcI}