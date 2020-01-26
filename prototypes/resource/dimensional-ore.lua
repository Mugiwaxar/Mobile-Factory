-- Create the Dimensional Ore resource --

-- Resource --
local dmOR = {}
dmOR.name = "DimensionalOre"
dmOR.type = "resource"
dmOR.flags = {"placeable-neutral"}
dmOR.order="a"
dmOR.tree_removal_probability = 1
dmOR.tree_removal_max_distance = 32 * 32
dmOR.minable =
    {
      hardness = 0.9,
      mining_particle = "coal-particle",
      mining_time = 2,
      result = "DimensionalOre"
    }
dmOR.collision_box = {{ -0.1, -0.1}, {0.1, 0.1}}
dmOR.selection_box = {{ -0.5, -0.5}, {0.5, 0.5}}
dmOR.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalOreI.png"
dmOR.icon_size = 256
dmOR.stage_counts = {1500, 1200, 700, 600, 300}
dmOR.stages =
{
	sheet =
	{
		filename = "__Mobile_Factory_Graphics__/graphics/entity/DimensionalOreR.png",
		priority = "extra-high",	
		size = 128,
		frame_count = 3,
        variation_count = 5,
		scale = 0.25
	}
}
dmOR.map_color = {102/255, 0, 102/255}
dmOR.autoplace = resource_autoplace.resource_autoplace_settings{
		name = "DimensionalOre",
        order = "b",
        base_density = 10,
        has_starting_area_placement = true,        
        regular_rq_factor_multiplier = 1.10,
        starting_rq_factor_multiplier = 1.5
    }
data:extend{dmOR}

-- Auto Place Control --
local dmOAPC = {}
dmOAPC.type = "autoplace-control"
dmOAPC.category = "resource"
dmOAPC.name = "DimensionalOre"
dmOAPC.richness = true
data:extend{dmOAPC}

-- Item --
local dmOI = {}
dmOI.name = "DimensionalOre"
dmOI.type = "item"
dmOI.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalOreO.png"
dmOI.icon_size = 64
dmOI.subgroup = "Resources"
dmOI.order = "a"
dmOI.stack_size = 1000
data:extend{dmOI}

-- Noise Layer --
local dmONL = {}
dmONL.name = "DimensionalOre"
dmONL.type = "noise-layer"
data:extend{dmONL}

-- Recipe --
local dmOR = {}
dmOR.type = "recipe"
dmOR.name = "DimensionalOre"
dmOR.energy_required = 1
dmOR.ingredients =
    {
      {"DimensionalSample", 3}
    }
dmOR.result = "DimensionalOre"
dmOR.result_count = 1
data:extend{dmOR}

-- Technology --
local dmT = {}
dmT.name = "DimensionalOre"
dmT.type = "technology"
dmT.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalOreI.png"
dmT.icon_size = 256
dmT.unit = {
	count=1,
	time=1,
	ingredients={}
}
dmT.effects = nil
data:extend{dmT}

-- Dimensional Ore to Stone Recipe --
local sR = {}
sR.type = "recipe"
sR.name = "mfStone"
sR.energy_required = 0.3
sR.ingredients =
    {
      {"DimensionalOre", 1}
    }
sR.result = "stone"
sR.result_count = 3
data:extend{sR}