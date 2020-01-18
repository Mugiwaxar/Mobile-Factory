-- Equalizer --
ez = {}
ez.type = "beacon"
ez.name = "Equalizer"
ez.icon = "__Mobile_Factory_Graphics__/graphics/icones/Equalizer.png"
ez.icon_size = 32
ez.flags = {}
ez.minable = nil
ez.max_health = 200
ez.corpse = "big-remnants"
ez.dying_explosion = "medium-explosion"
ez.collision_box = {{-7, -6}, {4, 5}}
ez.selection_box = {{-7, -6}, {4, 5}}
ez.allowed_effects = {"consumption", "speed", "pollution"}
ez.supply_area_distance = 0
ez.energy_usage = "1J"
ez.base_picture =
  {
    filename = "__Mobile_Factory_Graphics__/graphics/entity/Equalizer.png",
    width = 116,
    height = 93,
	scale = 4
  }
ez.animation =
  {
    filename = "__base__/graphics/entity/beacon/beacon-antenna.png",
    width = 54,
    height = 50,
    line_length = 8,
    frame_count = 32,
	shift = { -1.5, -7.0},
    animation_speed = 0.5,
	scale = 4
  }
ez.animation_shadow =
  {
    filename = "__base__/graphics/entity/beacon/beacon-antenna-shadow.png",
    width = 63,
    height = 49,
    line_length = 8,
    frame_count = 32,
    animation_speed = 0.5,
	scale = 4
  }
ez.energy_source =
  {
    type = "electric",
    usage_priority = "secondary-input",
	render_no_power_icon = false,
	render_no_network_icon = false
  }
ez.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
ez.distribution_effectivity = 0.5
ez.module_specification =
  {
    module_slots = 20,
    module_info_icon_shift = {0, 0.5},
    module_info_multi_row_initial_height_modifier = -0.3
  }
data:extend{ez}

-- Technologie --
local ezT = {}
ezT.name = "UpgradeModules"
ezT.type = "technology"
ezT.icon = "__Mobile_Factory_Graphics__/graphics/icones/Equalizer.png"
ezT.icon_size = 32
ezT.unit = {
	count=350,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
ezT.prerequisites = {"ControlCenter"}
ezT.effects = {{type="nothing", effect_description={"description.UpgradeModules"}}}
data:extend{ezT}