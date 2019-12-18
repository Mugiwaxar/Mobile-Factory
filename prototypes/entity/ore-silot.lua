-------------------------------------- Ore Silot ----------------------------

-- Create Ore Silot --
function createOreSilot(id)

	-- Entity --
	osE = {} table.deepcopy("data.raw.container.iron-chest")
	osE.type = "container"
	osE.name = "OreSilot" .. tonumber(id)
	osE.icon = "__Mobile_Factory__/graphics/icones/OreSilot" .. tonumber(id) .. ".png"
	osE.order = "z"
	osE.icon_size = 34
	osE.flags = {"placeable-neutral", "player-creation"}
	osE.minable = nil
	osE.max_health = 200
	osE.corpse = "small-remnants"
	osE.open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 }
	osE.close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 }
	osE.resistances ={}
	osE.collision_box = {{-8, -8}, {8, 8}}
	osE.selection_box = {{-8, -8}, {8, 8}}
	osE.fast_replaceable_group = nil
	osE.inventory_size = 300
	osE.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
	osE.picture =
		{
		  layers =
		  {
			{
				filename = "__Mobile_Factory__/graphics/entity/OreSilot" .. tonumber(id) .. ".png",
				priority = "extra-high",
				width = 66,
				height = 76,
				--shift = util.by_pixel(-0.5, -0.5),
				scale = 8
			}
		  }
		}
	osE.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
	osE.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
	osE.circuit_wire_max_distance = default_circuit_wire_max_distance
	data:extend{osE}
	
	-- Pad Entity --
	osPE = {}
	osPE.type = "logistic-container"
	osPE.name = "OreSilotPad" .. tonumber(id)
	osPE.icon = "__Mobile_Factory__/graphics/icones/OreSilotPad" .. tonumber(id) ..  ".png"
	osPE.icon_size = 32
	osPE.flags = {"placeable-neutral", "player-creation"}
	osPE.minable = {mining_time = 0.5, result = "OreSilotPad" .. tonumber(id)}
	osPE.max_health = 100
	osPE.corpse = "small-remnants"
	osPE.logistic_mode = "buffer"
	osPE.logistic_slots_count = 1
	osPE.render_not_in_network_icon = false
	osPE.collision_box = {{-0.35, -0.35}, {0.35, 0.35}}
	osPE.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
	osPE.inventory_size = 3
	osPE.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" }
	osPE.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" }
	osPE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
	osPE.picture =
		{
		  layers =
		  {
			{
				filename = "__Mobile_Factory__/graphics/entity/OreSilotPad" .. tonumber(id) ..  ".png",
				priority = "extra-high",
				width = 62,
				height = 72,
				shift = util.by_pixel(0.5, -2),
				scale = 0.5
			},
			{
				filename = "__base__/graphics/entity/iron-chest/hr-iron-chest-shadow.png",
				priority = "extra-high",
				width = 104,
				height = 40,
				shift = util.by_pixel(10, 6.5),
				draw_as_shadow = true,
				scale = 0.5
			}
		  }
		}
	osPE.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
	osPE.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
	osPE.circuit_wire_max_distance = default_circuit_wire_max_distance
	data:extend{osPE}
	
	-- Pad Item --
	local osPI = {}
	osPI.type = "item"
	osPI.name = "OreSilotPad" .. tonumber(id)
	osPI.icon = "__Mobile_Factory__/graphics/icones/OreSilotPad" .. tonumber(id) ..  ".png"
	osPI.icon_size = 32
	osPI.place_result = "OreSilotPad" .. tonumber(id)
	osPI.subgroup = "Pad"
	osPI.order = "b"  .. tonumber(id)
	osPI.stack_size = 20
	data:extend{osPI}
	
	
	-- Pad Recipe --
	local osPR = {}
	osPR.type = "recipe"
	osPR.name = "OreSilotPad" .. tonumber(id)
	osPR.energy_required = 2
	osPR.enabled = false
	osPR.ingredients =
		{
		  {"iron-chest", 1},
		  {"DimensionalPlate", 10},
		}
	osPR.result = "OreSilotPad" .. tonumber(id)
	data:extend{osPR}
	
	
	-- Ore Silot Technologie --
	local osT = {}
	osT.name = "OreSilot" .. tonumber(id)
	osT.type = "technology"
	osT.icon = "__Mobile_Factory__/graphics/icones/OreSilotPad" .. tonumber(id) ..  ".png"
	osT.icon_size = 32
	osT.unit = {
		count=300 + 200*id,
		time=2,
		ingredients={
			{"DimensionalSample", 1}
		}
	}
	osT.prerequisites = {"ControlCenter"}
	osT.effects = {
	{type="nothing", effect_description={"description.OreSilot" .. tonumber(id)}},
	{type="unlock-recipe", recipe="ModuleID" .. tonumber(id)},
	{type="unlock-recipe", recipe="OreSilotPad" .. tonumber(id)}
	}
	data:extend{osT}
end


createOreSilot(1)
createOreSilot(2)
createOreSilot(3)
createOreSilot(4)
createOreSilot(5)