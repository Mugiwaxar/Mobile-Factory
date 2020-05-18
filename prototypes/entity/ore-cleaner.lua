------------------------------- ORE CLEANER ---------------------------

-- Entity --
local ocE = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
ocE.type = "mining-drill"
ocE.name = "OreCleaner"
ocE.icon = "__Mobile_Factory_Graphics__/graphics/icones/OreCleaner.png"
ocE.icon_size = 32
ocE.flags = {"placeable-neutral", "player-creation", "not-rotatable"}
ocE.minable = {mining_time = 1, result = "OreCleaner"}
ocE.max_health = 500
ocE.resource_categories = {"basic-solid"}
ocE.corpse = "medium-remnants"
ocE.mining_speed = 0
ocE.collision_box = {{ -2.5, -2.5}, {2.5, 1.5}}
ocE.selection_box = {{ -2.5, -2.5}, {2.5, 1.5}}
ocE.energy_usage = "1J"
ocE.resource_searching_radius = 20
ocE.vector_to_place_result = {0, -1.85}
ocE.monitor_visualization_tint = {r=78, g=173, b=255}
ocE.working_sound = nil
ocE.input_fluid_patch_sprites = nil
ocE.input_fluid_patch_shadow_sprites = nil
ocE.input_fluid_patch_shadow_animations = nil
ocE.input_fluid_patch_window_sprites = nil
ocE.input_fluid_patch_window_flow_sprites = nil
ocE.input_fluid_patch_window_base_sprites = nil
ocE.monitor_visualization_tint = nil
ocE.fast_replaceable_group = nil
ocE.next_upgrade = nil
ocE.input_fluid_box =
    {
      pipe_connections =
      {
        { position = {-3.0, 0} },
      }
    }
ocE.radius_visualization_picture =
{
	filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-radius-visualization.png",
	width = 10,
	height = 10
}
ocE.animations =
{
	frame_count = 60,
	filename = "__Mobile_Factory_Graphics__/graphics/animations/OreCleaner.png",
	priority = "extra-high",
	width = 290,
	height = 400,
	animation_speed = 1/3,
	line_length = 10,
	shift = {0,-1.25},
	scale = 0.5
}
ocE.shadow_animations =
{
	frame_count = 1,
	filename = "__Mobile_Factory_Graphics__/graphics/animations/OreCleanerShadow.png",
	priority = "extra-high",
	width = 200,
	height = 150,
	line_length = 1,
	shift = {1.9,0},
	scale = 1.35
}
ocE.energy_source =
{
	type = "electric",
	emissions_per_minute = 0,
	usage_priority = "secondary-input",
	render_no_power_icon = false,
	render_no_network_icon = false,
	buffer_capacity = "5MJ",
	input_flow_limit = "0J",
	output_flow_limit = "0J"

}
ocE.module_specification =
{
	module_slots = 1
}
data:extend{ocE}

-- Item --
local ocI = {}
ocI.type = "item-with-tags"
ocI.name = "OreCleaner"
ocI.icon = "__Mobile_Factory_Graphics__/graphics/icones/OreCleaner.png"
ocI.icon_size = 64
ocI.place_result = "OreCleaner"
ocI.subgroup = "DimensionalStuff"
ocI.order = "g"
ocI.stack_size = 1
ocI.enable = true
data:extend{ocI}

-- Recipe --
local ocR = {}
ocR.type = "recipe"
ocR.name = "OreCleaner"
ocR.energy_required = 10
ocR.enabled = false
ocR.ingredients =
    {
	  {"CrystalizedCircuit", 12},
      {"MachineFrame3", 10}
    }
ocR.result = "OreCleaner"
data:extend{ocR}

-- Technology --
local ocT = {}
ocT.name = "OreCleaner"
ocT.type = "technology"
ocT.icon = "__Mobile_Factory_Graphics__/graphics/icones/OreCleanerTech.png"
ocT.icon_size = 512
ocT.unit = {
	count=15,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
ocT.prerequisites = {"MatterSerialization"}
ocT.effects = {{type="unlock-recipe", recipe="OreCleaner"}}
data:extend{ocT}