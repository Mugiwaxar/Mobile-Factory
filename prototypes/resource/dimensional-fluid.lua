-- Create the Dimensional Fluid resource --

local dmFR = {}
dmFR.name = "DimensionalFluid"
dmFR.type = "resource"
dmFR.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalFluid.png"
dmFR.icon_size = 32
dmFR.stages = table.deepcopy(data.raw.resource["crude-oil"].stages)
dmFR.stages["sheet"]["filename"] = "__Mobile_Factory_Graphics__/graphics/entity/DimensionalFluid.png"
dmFR.stage_counts = data.raw.resource["crude-oil"].stage_counts
dmFR.map_color = {102/255, 0, 102/255}
dmFR.category = "basic-fluid"
dmFR.infinite = true
dmFR.minimum = 60000
dmFR.normal = 300000
dmFR.infinite_depletion_amount = 10
dmFR.resource_patch_search_radius = 9
dmFR.collision_box = data.raw.resource["crude-oil"].collision_box
dmFR.selection_box = data.raw.resource["crude-oil"].selection_box
dmFR.minable = {
	mining_time = 1,
	results = {
	  {
		amount_max = 10,
		amount_min = 10,
		name = "DimensionalFluid",
		probability = 1,
		type = "fluid"
	  }
	}
}
dmFR.autoplace = resource_autoplace.resource_autoplace_settings{
      name = "DimensionalFluid",
      order = "c",
      base_density = 8.2,
      base_spots_per_km2 = 1.8,
      random_probability = 1/48,
      random_spot_size_minimum = 1,
      random_spot_size_maximum = 1,
      additional_richness = 220000,
      has_starting_area_placement = true,
      regular_rq_factor_multiplier = 1
    }
data:extend{dmFR}

local dmFF = {}
dmFF.name = "DimensionalFluid"
dmFF.type = "fluid"
dmFF.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalFluidIcon.png"
dmFF.icon_size = 32
dmFF.default_temperature = 20
dmFF.max_temperature = 100
dmFF.base_color={151,0,147}
dmFF.flow_color={151,0,147}
dmFF.subgroup = "Resources"
dmFF.order = "b"
data:extend{dmFF}

local dmFAPC = {}
dmFAPC.type = "autoplace-control"
dmFAPC.category = "resource"
dmFAPC.name = "DimensionalFluid"
dmFAPC.richness = true
data:extend{dmFAPC}

--[[
local dmFI = {}
dmFI.name = "DimensionalFluid"
dmFI.type= "item"
dmFI.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalFluidIcon.png"
dmFI.icon_size = 32
dmFI.stack_size = 1000
dmFI.subgroup = "Resources"
dmFI.order = "b"
data:extend{dmFI}
]]--

local dmFNL = {}
dmFNL.name = "DimensionalFluid"
dmFNL.type = "noise-layer"
data:extend{dmFNL}

-- Dimensional Fluid to Water --
local wR = {}
wR.type = "recipe"
wR.name = "mfWater"
wR.energy_required = 0.3
wR.enabled = true
wR.category = "crafting-with-fluid"
wR.ingredients =
    {
		{type="fluid", name="DimensionalFluid", amount=1}
    }
wR.results = {{type="fluid", name="water", amount=10}}
data:extend{wR}