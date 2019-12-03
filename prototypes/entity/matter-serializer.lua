---------------------------------- MATTER SERIALIZER ---------------------------

-- Entity --
msE = {}
msE.type = "logistic-container"
msE.name = "MatterSerializer"
msE.icon = "__Mobile_Factory__/graphics/icones/ProviderPad.png"
msE.icon_size = 32
msE.flags = {"placeable-neutral", "player-creation"}
msE.minable = {mining_time = 0.5, result = "MatterSerializer"}
msE.max_health = 100
msE.corpse = "small-remnants"
msE.logistic_mode = "requester"
msE.logistic_slots_count = 1
msE.render_not_in_network_icon = false
msE.collision_box = {{-0.35, -0.35}, {0.35, 0.35}}
msE.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
msE.inventory_size = 1
msE.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" }
msE.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" }
msE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
msE.picture =
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
msE.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
msE.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
msE.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{msE}

-- Item --
local msI = {}
msI.type = "item"
msI.name = "MatterSerializer"
msI.icon = "__Mobile_Factory__/graphics/icones/ProviderPad.png"
msI.icon_size = 32
msI.place_result = "MatterSerializer"
msI.subgroup = "Pad"
msI.order = "b"
msI.stack_size = 20
data:extend{msI}


-- Recipe --
local msR = {}
msR.type = "recipe"
msR.name = "MatterSerializer"
msR.energy_required = 2
msR.enabled = false
msR.ingredients =
    {
      {"iron-chest", 1},
      {"DimensionalPlate", 10},
    }
msR.result = "MatterSerializer"
data:extend{msR}