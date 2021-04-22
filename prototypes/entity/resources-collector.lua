------------------------------- RESOURCES COLLECTOR ---------------------------

-- Entity --
local rcE = {}
rcE.type = "container"
rcE.name = "ResourcesCollector"
rcE.icon = "__Mobile_Factory_Graphics__/graphics/entity/ResourcesCollectorI.png"
rcE.icon_size = 256
rcE.flags = {"placeable-neutral", "player-creation", "not-rotatable"}
rcE.minable = {mining_time = 1, result = "ResourcesCollector"}
rcE.max_health = 500
rcE.inventory_size = 50
rcE.picture = {
	layers = {
		{
			filename = "__Mobile_Factory_Graphics__/graphics/entity/ResourcesCollectorE.png",
			width = 600,
			height = 600,
			frames = 1,
			scale = 1/600*33*6
		},
		{
			filename = "__Mobile_Factory_Graphics__/graphics/entity/ResourcesCollectorS.png",
			width = 600,
			height = 600,
			frames = 1,
			scale = 1/600*33*6,
			draw_as_shadow = true,
			shift = {1.5,0}
		}
	}
}
rcE.collision_box = {{ -2.85, -0.99}, {2.85, 1.99}}
rcE.selection_box = {{ -2.85, -1.85}, {2.85, 2.99}}
rcE.radius_visualisation_specification =
{
	sprite = {
		filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-radius-visualization.png",
		width = 10,
		height = 10
	},
	distance = 50
}
data:extend{rcE}

-- Tank Entity --
local rctE = {}
rctE.name = "ResourcesCollectorTank"
rctE.type = "assembling-machine"
rctE.icon = "__Mobile_Factory_Graphics__/graphics/entity/ResourcesCollectorI.png"
rctE.icon_size = 256
rctE.flags = {"placeable-neutral", "player-creation", "not-rotatable"}
rctE.minable = {mining_time = 1}
rctE.collision_box = {{ -2.85, -0.99}, {2.85, 1.99}}
rctE.selection_box = nil
rctE.energy_usage = "1J"
rctE.crafting_speed = 1
rctE.crafting_categories = {"crafting"}
rctE.energy_source = {type="void"}
rctE.animation = {filename="__Mobile_Factory_Graphics__/graphics/Alpha.png", size=1}
rctE.idle_animation = {filename="__Mobile_Factory_Graphics__/graphics/Alpha.png", size=1}
rctE.squeak_behaviour = false
rctE.fluid_boxes = {
	{
		production_type = "output",
		base_area = 100,
		height = 1,
		base_level = 10,
		pipe_connections = {{ type="output", position = {-3.6, 0} }},
		pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures()
	},
	{
		production_type = "output",
		base_area = 100,
		height = 1,
		base_level = 10,
		pipe_connections = {{ type="output", position = {3.6, 0} }},
		pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures()
	},
	{
		production_type = "output",
		base_area = 100,
		height = 1,
		base_level = 10,
		pipe_connections = {{ type="output", position = {-3.6, 1.90} }},
		pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures()
	},
	{
		production_type = "output",
		base_area = 100,
		height = 1,
		base_level = 10,
		pipe_connections = {{ type="output", position = {3.6, 1.90} }},
		pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures()
	}

}
data:extend{rctE}


-- Item --
local rcI = {}
rcI.type = "item-with-tags"
rcI.name = "ResourcesCollector"
rcI.icon = "__Mobile_Factory_Graphics__/graphics/entity/ResourcesCollectorI.png"
rcI.icon_size = 256
rcI.place_result = "ResourcesCollector"
rcI.subgroup = "DimensionalStuff"
rcI.order = "g"
rcI.stack_size = 1
rcI.enable = true
data:extend{rcI}

-- Recipe --
local rcR = {}
rcR.type = "recipe"
rcR.name = "ResourcesCollector"
rcR.energy_required = 10
rcR.enabled = false
rcR.ingredients =
    {
	  {"CrystalizedCircuit", 12},
      {"MachineFrame3", 10}
    }
rcR.result = "ResourcesCollector"
data:extend{rcR}

-- Technology --
local rcT = {}
rcT.name = "ResourcesCollector"
rcT.type = "technology"
rcT.icon = "__Mobile_Factory_Graphics__/graphics/entity/ResourcesCollectorI.png"
rcT.icon_size = 256
rcT.unit = {
	count=15,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
rcT.prerequisites = {"Quatron"}
rcT.effects = {{type="unlock-recipe", recipe="ResourcesCollector"}}
data:extend{rcT}

-- Animation --
local rcAn = {}
rcAn.name = "ResourcesCollectorAn"
rcAn.type = "animation"
rcAn.frame_count = 60
rcAn.filename = "__Mobile_Factory_Graphics__/graphics/entity/ResourcesCollectorAn.png"
rcAn.size = 600
rcAn.line_length = 10
rcAn.animation_speed = 1
rcAn.scale = 1/600*33*6
rcAn.flags = {"terrain"}
rcAn.draw_as_glow = true
data:extend{rcAn}