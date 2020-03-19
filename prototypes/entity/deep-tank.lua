-------------------------- DEEP TANK ----------------------------

-- Entity --
dtE = {}
dtE.type = "container"
dtE.name = "DeepTank"
dtE.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/DeepTankI.png"
dtE.icon_size = 128
dtE.flags = {"placeable-neutral", "player-creation"}
dtE.minable = {mining_time = 0.8, result = "DeepTank"}
dtE.max_health = 200
dtE.corpse = "small-remnants"
dtE.open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 }
dtE.close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 }
dtE.resistances ={}
dtE.collision_box = {{-1.75, -1.45}, {1.75, 1.2}}
dtE.selection_box = {{-2.4, -1.7}, {2.4, 1.7}}
dtE.fast_replaceable_group = nil
dtE.next_upgrade = nil
dtE.inventory_size = 0
dtE.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
dtE.picture =
	{
	  layers =
	  {
		{
			filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/DeepTankE.png",
			priority = "low",
			width = 600,
			height = 600,
			--shift = util.by_pixel(-0.5, -0.5),
			scale = 1/4
		},
		{
			filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/DeepTankS.png",
			priority = "very-low",
			width = 600,
			height = 600,
			draw_as_shadow = true,
			shift = util.by_pixel(4, 2),
			scale = 1/4
		}
	  }
	}
dtE.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
dtE.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
dtE.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{dtE}

-- Item --
local dtI = {}
dtI.type = "item-with-tags"
dtI.name = "DeepTank"
dtI.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/DeepTankI.png"
dtI.icon_size = 128
dtI.place_result = "DeepTank"
dtI.subgroup = "DataSerialization"
dtI.order = "d2"
dtI.stack_size = 5
data:extend{dtI}

-- Recipe --
local dtR = {}
dtR.type = "recipe"
dtR.name = "DeepTank"
dtR.energy_required = 2
dtR.enabled = false
dtR.ingredients =
    {
      {"CrystalizedCircuit", 8},
      {"MachineFrame3", 2}
    }
dtR.result = "DeepTank"
data:extend{dtR}

-- Technologie --
local dtT = {}
dtT.name = "DeepTank"
dtT.type = "technology"
dtT.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/DeepTankI.png"
dtT.icon_size = 128
dtT.unit = {
	count=20,
	time=60,
	ingredients={
		{"DimensionalSample", 50},
		{"DimensionalCrystal", 1}
	}
}
dtT.prerequisites = {"ControlCenter", "MatterSerialization"}
dtT.effects = {
	{type="nothing", effect_description={"description.DeepTank"}},
	{type="unlock-recipe", recipe="DeepTank"},
	{type="unlock-recipe", recipe="FluidInteractor"}
}
data:extend{dtT}