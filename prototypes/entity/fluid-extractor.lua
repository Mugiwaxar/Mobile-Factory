------------------------- FLUID EXTRACTOR -------------------------

-- Entity --
feE = table.deepcopy(data.raw["mining-drill"]["pumpjack"])
feE.name = "FluidExtractor"
feE.icon = "__Mobile_Factory__/graphics/icones/FluidExtractor.png"
feE.minable = {mining_time = 0.5, result = "FluidExtractor"}
feE.energy_source =
    {
		type = "electric",	
		emissions_per_minute = 0,
		usage_priority = "secondary-input",
		render_no_power_icon = false,
		render_no_network_icon = false
    }
feE.output_fluid_box =
    {
      pipe_connections =
      {
        {
          positions = { {1, -2}, {2, -1}, {-1, 2}, {-2, 1} }
        }
      }
    }
feE.energy_usage = "1J"
feE.mining_speed = 0
feE.module_specification =
    {
      module_slots = 1
    }
feE.animations =
    {
      north =
      {
        layers =
        {
          {
              priority = "high",
              filename = "__Mobile_Factory__/graphics/entity/FluidExtractor.png",
              animation_speed = 0.5,
              scale = 0.5,
              line_length = 8,
              width = 206,
              height = 202,
              frame_count = 40,
              shift = util.by_pixel(-4, -24)
          },
          {
              priority = "high",
              filename = "__base__/graphics/entity/pumpjack/hr-pumpjack-horsehead-shadow.png",
              animation_speed = 0.5,
              draw_as_shadow = true,
              line_length = 8,
              width = 309,
              height = 82,
              frame_count = 40,
              scale = 0.5,
              shift = util.by_pixel(17.75, 14.5)
          }
        }
      }
    }
feE.fast_replaceable_group = nil
data:extend{feE}

-- Item --
local feI = {}
feI.type = "item"
feI.name = "FluidExtractor"
feI.place_result = "FluidExtractor"
feI.icon = "__Mobile_Factory__/graphics/icones/FluidExtractor.png"
feI.icon_size = 32
feI.subgroup = "DimensionalStuff"
feI.order = "h"
feI.stack_size = 1
data:extend{feI}

-- Crafting --
local feR = {}
feR.type = "recipe"
feR.name = "FluidExtractor"
feR.energy_required = 10
feR.enabled = false
feR.ingredients =
    {
      {"pumpjack", 1},
	  {"DimensionalCrystal", 1},
      {"DimensionalPlate", 30}
    }
feR.result = "FluidExtractor"
data:extend{feR}

-- Technology --
local feT = {}
feT.name = "FluidExtractor"
feT.type = "technology"
feT.icon = "__Mobile_Factory__/graphics/icones/FluidExtractor.png"
feT.icon_size = 32
feT.unit = {
	count=15,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
feT.prerequisites = {"DimensionalCrystal"}
feT.effects = {{type="unlock-recipe", recipe="FluidExtractor"}}
data:extend{feT}