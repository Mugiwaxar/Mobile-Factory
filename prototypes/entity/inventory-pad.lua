---------------------------------- INVENTORY PAD ---------------------------

-- Entity --
ipE = {}
ipE.type = "logistic-container"
ipE.name = "InventoryPad"
ipE.icon = "__Mobile_Factory__/graphics/icones/InventoryPad.png"
ipE.icon_size = 32
ipE.flags = {"placeable-neutral", "player-creation"}
ipE.minable = {mining_time = 0.5, result = "InventoryPad"}
ipE.max_health = 100
ipE.corpse = "small-remnants"
ipE.logistic_mode = "buffer"
ipE.logistic_slots_count = 1
ipE.render_not_in_network_icon = false
ipE.collision_box = {{-0.35, -0.35}, {0.35, 0.35}}
ipE.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
ipE.inventory_size = 10
ipE.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" }
ipE.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" }
ipE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
ipE.picture =
    {
      layers =
      {
        {
            filename = "__Mobile_Factory__/graphics/entity/InventoryPad.png",
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
ipE.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
ipE.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
ipE.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{ipE}

-- Item --
local ipI = {}
ipI.type = "item"
ipI.name = "InventoryPad"
ipI.icon = "__Mobile_Factory__/graphics/icones/InventoryPad.png"
ipI.icon_size = 32
ipI.place_result = "InventoryPad"
ipI.subgroup = "Pad"
ipI.order = "c"
ipI.stack_size = 20
data:extend{ipI}


-- Recipe --
local ipR = {}
ipR.type = "recipe"
ipR.name = "InventoryPad"
ipR.energy_required = 4
ipR.enabled = false
ipR.ingredients =
    {
      {"iron-chest", 1},
      {"DimensionalPlate", 15},
      {"DimensionalCrystal", 1}
    }
ipR.result = "InventoryPad"
data:extend{ipR}

-- Technologie --
local dpT = {}
dpT.name = "InventoryPad"
dpT.type = "technology"
dpT.icon = "__Mobile_Factory__/graphics/icones/InventoryPad.png"
dpT.icon_size = 32
dpT.unit = {
	count=5,
	time=60,
	ingredients={
		{"DimensionalSample", 200},
		{"DimensionalCrystal", 1}
	}
}
dpT.prerequisites = {"DimensionalLogistic", "ConstructibleArea1"}
dpT.effects = {{type="unlock-recipe", recipe="InventoryPad"}}
data:extend{dpT}