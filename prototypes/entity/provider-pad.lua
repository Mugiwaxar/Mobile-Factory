---------------------------------- REQUESTER PAD ---------------------------

-- Entity --
pcE = {}
pcE.type = "logistic-container"
pcE.name = "ProviderPad"
pcE.icon = "__Mobile_Factory__/graphics/icones/ProviderPad.png"
pcE.icon_size = 32
pcE.flags = {"placeable-neutral", "player-creation"}
pcE.minable = {mining_time = 0.5, result = "ProviderPad"}
pcE.max_health = 100
pcE.corpse = "small-remnants"
pcE.logistic_mode = "requester"
pcE.logistic_slots_count = 1
pcE.render_not_in_network_icon = false
pcE.collision_box = {{-0.35, -0.35}, {0.35, 0.35}}
pcE.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
pcE.inventory_size = 3
pcE.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" }
pcE.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" }
pcE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
pcE.picture =
    {
      layers =
      {
        {
            filename = "__Mobile_Factory__/graphics/entity/ProviderPad.png",
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
pcE.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
pcE.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
pcE.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{pcE}

-- Item --
local pcI = {}
pcI.type = "item"
pcI.name = "ProviderPad"
pcI.icon = "__Mobile_Factory__/graphics/icones/ProviderPad.png"
pcI.icon_size = 32
pcI.place_result = "ProviderPad"
pcI.subgroup = "Pad"
pcI.order = "b"
pcI.stack_size = 20
data:extend{pcI}


-- Recipe --
local pcI = {}
pcI.type = "recipe"
pcI.name = "ProviderPad"
pcI.energy_required = 2
pcI.enabled = false
pcI.ingredients =
    {
      {"iron-chest", 1},
      {"DimensionalPlate", 10},
    }
pcI.result = "ProviderPad"
data:extend{pcI}