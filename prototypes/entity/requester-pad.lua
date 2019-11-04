---------------------------------- PROVIDER PAD ---------------------------

-- Entity --
rcE = {}
rcE.type = "logistic-container"
rcE.name = "RequesterPad"
rcE.icon = "__Mobile_Factory__/graphics/icones/RequesterPad.png"
rcE.icon_size = 32
rcE.flags = {"placeable-neutral", "player-creation"}
rcE.minable = {mining_time = 0.5, result = "RequesterPad"}
rcE.max_health = 100
rcE.corpse = "small-remnants"
rcE.logistic_mode = "buffer"
rcE.logistic_slots_count = 1
rcE.render_not_in_network_icon = false
rcE.collision_box = {{-0.35, -0.35}, {0.35, 0.35}}
rcE.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
rcE.inventory_size = 3
rcE.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" }
rcE.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" }
rcE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
rcE.picture =
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
rcE.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
rcE.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
rcE.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{rcE}

-- Item --
local rcI = {}
rcI.type = "item"
rcI.name = "RequesterPad"
rcI.icon = "__Mobile_Factory__/graphics/icones/RequesterPad.png"
rcI.icon_size = 32
rcI.place_result = "RequesterPad"
rcI.subgroup = "Pad"
rcI.order = "a"
rcI.stack_size = 20
data:extend{rcI}


-- Recipe --
local rcI = {}
rcI.type = "recipe"
rcI.name = "RequesterPad"
rcI.energy_required = 2
rcI.enabled = false
rcI.ingredients =
    {
      {"iron-chest", 1},
      {"DimensionalPlate", 10},
    }
rcI.result = "RequesterPad"
data:extend{rcI}