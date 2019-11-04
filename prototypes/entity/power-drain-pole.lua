---------------------------- POWER DRAIN POLE -------------------------

-- Entity --
pdpE = {}
pdpE.type = "beacon"
pdpE.name = "PowerDrainPole"
pdpE.icon = "__Mobile_Factory__/graphics/icones/PowerDrainPole.png"
pdpE.icon_size = 32
pdpE.flags = {"placeable-neutral", "player-creation", "fast-replaceable-no-build-while-moving"}
pdpE.minable = {mining_time = 0.1, result = "PowerDrainPole"}
pdpE.max_health = 100
pdpE.corpse = "medium-electric-pole-remnants"
ez.dying_explosion = "medium-explosion"
pdpE.resistances = {{type = "fire",percent = 100}}
pdpE.collision_box = {{-1.2, -1}, {1.2, 2}}
pdpE.selection_box = {{-1.2, -1}, {1.2, 2}}
pdpE.drawing_box = {{-1.2, -1}, {1.2, 2}}
pdpE.allowed_effects = {"consumption", "speed", "pollution"}
pdpE.supply_area_distance = 0
pdpE.energy_usage = "1J"
pdpE.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
pdpE.base_picture =
    {
      layers =
      {
        {
          filename = "__Mobile_Factory__/graphics/entity/PowerDrainPole.png",
          priority = "extra-high",
            width = 148,
            height = 312,
          direction_count = 4,
          shift = util.by_pixel(1, -51),
		  scale = 0.85
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
pdpE.animation =
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
pdpE.animation_shadow =
  {
    filename = "__base__/graphics/entity/beacon/beacon-antenna-shadow.png",
    width = 63,
    height = 49,
    line_length = 8,
    frame_count = 32,
    animation_speed = 0.5,
	scale = 0.001
  }
pdpE.energy_source =
  {
    type = "electric",
    usage_priority = "secondary-input",
	render_no_power_icon = false,
	render_no_network_icon = false
  }
pdpE.distribution_effectivity = 0.5
pdpE.module_specification =
  {
    module_slots = 9,
    module_info_icon_shift = {0, 0.5},
    module_info_multi_row_initial_height_modifier = -0.3
  }
data:extend{pdpE}

-- Item --
local pdpI = {}
pdpI.type = "item"
pdpI.name = "PowerDrainPole"
pdpI.icon = "__Mobile_Factory__/graphics/icones/PowerDrainPole.png"
pdpI.icon_size = 32
pdpI.place_result = "PowerDrainPole"
pdpI.subgroup = "Poles"
pdpI.order = "p"
pdpI.stack_size = 5
pdpI.enable = false
data:extend{pdpI}

-- Recipe --
local dpdR = {}
dpdR.type = "recipe"
dpdR.name = "PowerDrainPole"
dpdR.energy_required = 5
dpdR.enabled = false
dpdR.ingredients =
    {
      {"big-electric-pole", 1},
      {"DimensionalPlate", 20}
    }
dpdR.result = "PowerDrainPole"
data:extend{dpdR}

-- Technologie --
local pdpT = {}
pdpT.name = "PowerDrainPole"
pdpT.type = "technology"
pdpT.icon = "__Mobile_Factory__/graphics/icones/PowerDrainPole.png"
pdpT.icon_size = 32
pdpT.unit = {
	count=500,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
pdpT.prerequisites = {"EnergyDistribution1"}
pdpT.effects = {{type="unlock-recipe", recipe="PowerDrainPole"}}
data:extend{pdpT}