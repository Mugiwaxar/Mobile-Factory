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
	
	-- Ore Silot Technologie --
	local osT = {}
	osT.name = "OreSilot" .. tonumber(id)
	osT.type = "technology"
	osT.icon = "__Mobile_Factory__/graphics/icones/OreSilot" .. tonumber(id) ..  ".png"
	osT.icon_size = 32
	osT.unit = {
		count=300 + 200*id,
		time=2,
		ingredients={
			{"DimensionalSample", 1}
		}
	}
	if id == 1 then
		osT.prerequisites = {"ControlCenter"}
	else
		osT.prerequisites = {"OreSilot" .. tonumber(id-1)}
	end
	osT.effects = {
	{type="nothing", effect_description={"description.OreSilot" .. tonumber(id)}},
	{type="unlock-recipe", recipe="ModuleID" .. tonumber(id)}
	}
	data:extend{osT}
end


createOreSilot(1)
createOreSilot(2)
createOreSilot(3)
createOreSilot(4)
createOreSilot(5)