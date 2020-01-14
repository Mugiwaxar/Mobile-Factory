-------------------------- DEEP STORAGE ----------------------------

-- Entity --
dsE = {}
dsE.type = "container"
dsE.name = "DeepStorage"
dsE.icon = "__Mobile_Factory__/graphics/icones/DeepStorageI.png"
dsE.icon_size = 256
dsE.flags = {"placeable-neutral", "player-creation"}
dsE.minable = {mining_time = 0.8, result = "DeepStorage"}
dsE.max_health = 200
dsE.corpse = "small-remnants"
dsE.open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 }
dsE.close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 }
dsE.resistances ={}
dsE.collision_box = {{-1.75, -1.45}, {1.75, 1.2}}
dsE.selection_box = {{-2.4, -1.7}, {2.4, 1.7}}
dsE.fast_replaceable_group = nil
dsE.inventory_size = 0
dsE.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
dsE.picture =
	{
	  layers =
	  {
		{
			filename = "__Mobile_Factory__/graphics/entity/DeepStorageE.png",
			priority = "low",
			width = 600,
			height = 600,
			--shift = util.by_pixel(-0.5, -0.5),
			scale = 1/4
		},
		{
			filename = "__Mobile_Factory__/graphics/entity/DeepStorageS.png",
			priority = "very-low",
			width = 620,
			height = 608,
			draw_as_shadow = true,
			shift = util.by_pixel(4, 2),
			scale = 1/4
		}
	  }
	}
dsE.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
dsE.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
dsE.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{dsE}

-- Item --
local dsI = {}
dsI.type = "item"
dsI.name = "DeepStorage"
dsI.icon = "__Mobile_Factory__/graphics/icones/DeepStorageI.png"
dsI.icon_size = 256
dsI.place_result = "DeepStorage"
dsI.subgroup = "DataSerialization"
dsI.order = "e"
dsI.stack_size = 5
data:extend{dsI}

-- Recipe --
local dsR = {}
dsR.type = "recipe"
dsR.name = "DeepStorage"
dsR.energy_required = 2
dsR.enabled = false
dsR.ingredients =
    {
      {"CrystalizedCircuit", 8},
      {"MachineFrame3", 2}
    }
dsR.result = "DeepStorage"
data:extend{dsR}
	
-- Deep Storage Technologie --
local dsT = {}
dsT.name = "DeepStorage"
dsT.type = "technology"
dsT.icon = "__Mobile_Factory__/graphics/icones/DeepStorageI.png"
dsT.icon_size = 256
dsT.unit = {
	count=20,
	time=60,
	ingredients={
		{"DimensionalSample", 50},
		{"DimensionalCrystal", 1}
	}
}
dsT.prerequisites = {"ControlCenter"}
dsT.effects = {
	{type="nothing", effect_description={"description.DeepStorage"}},
	{type="unlock-recipe", recipe="DeepStorage"}
}
data:extend{dsT}














