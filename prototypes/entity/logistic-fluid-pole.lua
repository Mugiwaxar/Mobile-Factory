---------------------------- LOGISTIC FLUID POLE -------------------------

-- Entity --
lfpE = {}
lfpE.type = "beacon"
lfpE.name = "LogisticFluidPole"
lfpE.icon = "__Mobile_Factory__/graphics/icones/LogisticFluidPole.png"
lfpE.icon_size = 32
lfpE.flags = {"placeable-neutral", "player-creation", "fast-replaceable-no-build-while-moving"}
lfpE.minable = {mining_time = 0.1, result = "LogisticFluidPole"}
lfpE.max_health = 100
lfpE.corpse = "medium-electric-pole-remnants"
ez.dying_explosion = "medium-explosion"
lfpE.resistances = {{type = "fire",percent = 100}}
lfpE.collision_box = {{-1.5, -0.8}, {0.8, 2.2}}
lfpE.selection_box = {{-1.5, -0.8}, {0.8, 2.2}}
lfpE.drawing_box = {{-1.2, -1}, {1.2, 2}}
lfpE.allowed_effects = {"consumption", "speed", "pollution"}
lfpE.supply_area_distance = 0
lfpE.energy_usage = "1J"
lfpE.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
lfpE.base_picture =
    {
      layers =
      {
        {
          filename = "__Mobile_Factory__/graphics/entity/LogisticFluidPole.png",
          priority = "extra-high",
            width = 84,
            height = 252,
          direction_count = 4,
          shift = util.by_pixel(1, -51),
		  scale = 1
        },
        {
          filename = "__base__/graphics/entity/big-electric-pole/hr-big-electric-pole-shadow.png",
          priority = "extra-high",
          width = 174,
          height = 94,
          direction_count = 4,
          shift = util.by_pixel(60, 0),
          draw_as_shadow = true
        }
      }
    }
lfpE.animation =
  {
    filename = "__base__/graphics/entity/beacon/beacon-antenna.png",
    width = 54,
    height = 50,
    line_length = 8,
    frame_count = 32,
	shift = { -1.5, -7.0},
    animation_speed = 0.5,
	scale = 0.001
  }
lfpE.animation_shadow =
  {
    filename = "__base__/graphics/entity/beacon/beacon-antenna-shadow.png",
    width = 63,
    height = 49,
    line_length = 8,
    frame_count = 32,
    animation_speed = 0.5,
	scale = 0.001
  }
lfpE.energy_source =
  {
    type = "electric",
    usage_priority = "secondary-input",
	input_flow_limit = "1W",
	render_no_power_icon = false,
	render_no_network_icon = false
  }
lfpE.distribution_effectivity = 1
lfpE.module_specification =
  {
    module_slots = 11,
    module_info_icon_shift = {0, 0.5},
    module_info_multi_row_initial_height_modifier = -0.3
  }
data:extend{lfpE}

-- Item --
local lfpE = {}
lfpE.type = "item"
lfpE.name = "LogisticFluidPole"
lfpE.icon = "__Mobile_Factory__/graphics/icones/LogisticFluidPole.png"
lfpE.icon_size = 32
lfpE.place_result = "LogisticFluidPole"
lfpE.subgroup = "Poles"
lfpE.order = "p"
lfpE.stack_size = 5
lfpE.enable = false
data:extend{lfpE}

-- Recipe --
local lfpR = {}
lfpR.type = "recipe"
lfpR.name = "LogisticFluidPole"
lfpR.energy_required = 5
lfpR.enabled = false
lfpR.ingredients =
    {
      {"medium-electric-pole", 1},
      {"DimensionalPlate", 20},
    }
lfpR.result = "LogisticFluidPole"
data:extend{lfpR}

-- Technologie --
local lfpT = {}
lfpT.name = "LogisticFluidPole"
lfpT.type = "technology"
lfpT.icon = "__Mobile_Factory__/graphics/icones/LogisticFluidPole.png"
lfpT.icon_size = 32
lfpT.unit = {
	count=380,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
lfpT.prerequisites = {"EnergyDistribution1"}
lfpT.effects = {{type="unlock-recipe", recipe="LogisticFluidPole"}}
data:extend{lfpT}