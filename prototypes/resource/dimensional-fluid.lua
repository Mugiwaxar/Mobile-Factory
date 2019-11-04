-- Create the Dimensional Fluid resource --

local dmFR = table.deepcopy(data.raw.resource["crude-oil"])
dmFR.name = "DimensionalFluid"
dmFR.icon = "__Mobile_Factory__/graphics/icones/DimensionalFluid.png"
dmFR.stages["sheet"]["filename"] = "__Mobile_Factory__/graphics/entity/DimensionalFluid.png"
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
dmFR.map_color = {102, 0, 102}
dmFR.autoplace = resource_autoplace.resource_autoplace_settings{
      name = "DimensionalFluid",
      order = "c", -- Other resources are "b"; oil won't get placed if something else is already there.
      base_density = 8.2,
      base_spots_per_km2 = 1.8,
      random_probability = 1/48,
      random_spot_size_minimum = 1,
      random_spot_size_maximum = 1, -- don't randomize spot size
      additional_richness = 220000, -- this increases the total everywhere, so base_density needs to be decreased to compensate
      has_starting_area_placement = true,
      regular_rq_factor_multiplier = 1
    }
data:extend{dmFR}

local dmFAPC = {}
dmFAPC.type = "autoplace-control"
dmFAPC.category = "resource"
dmFAPC.name = "DimensionalFluid"
dmFAPC.richness = true
data:extend{dmFAPC}

local dmFI = table.deepcopy(data.raw.fluid["crude-oil"])
dmFI.name = "DimensionalFluid"
dmFI.icon = "__Mobile_Factory__/graphics/icones/DimensionalFluidIcon.png"
dmFI.subgroup = "Resources"
dmFI.order = "b"
dmFI.fuel_category = nil
dmFI.fuel_value = nil
dmFI.fuel_acceleration_multiplier = nil
dmFI.fuel_top_speed_multiplier = nil
dmFI.fuel_emissions_multiplier = nil
dmFI.fuel_glow_color = nil
data:extend{dmFI}

local dmFNL = {}
dmFNL.name = "DimensionalFluid"
dmFNL.type = "noise-layer"
data:extend{dmFNL}