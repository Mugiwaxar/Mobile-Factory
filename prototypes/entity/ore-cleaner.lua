------------------------------- ORE CLEANER ---------------------------

-- Entity --
local ocE = {}
ocE.type = "container"
ocE.name = "OreCleaner"
ocE.icon = "__Mobile_Factory_Graphics__/graphics/entity/OreCleanerI.png"
ocE.icon_size = 32
ocE.flags = {"placeable-neutral", "player-creation", "not-rotatable"}
ocE.minable = {mining_time = 1, result = "OreCleaner"}
ocE.max_health = 500
ocE.inventory_size = 50
ocE.picture = {
	layers = {
		{
			filename = "__Mobile_Factory_Graphics__/graphics/entity/OreCleanerE.png",
			width = 600,
			height = 600,
			frames = 1,
			scale = 1/600*33*6
		},
		{
			filename = "__Mobile_Factory_Graphics__/graphics/entity/OreCleanerS.png",
			width = 600,
			height = 600,
			frames = 1,
			scale = 1/600*33*6,
			draw_as_shadow = true,
			shift = {1.5,0}
		}
	}
}
ocE.collision_box = {{ -2.85, -1.85}, {2.85, 2.99}}
ocE.selection_box = ocE.collision_box
ocE.radius_visualisation_specification =
{
	sprite = {
		filename = "__base__/graphics/entity/electric-mining-drill/electric-mining-drill-radius-visualization.png",
		width = 10,
		height = 10
	},
	distance = 50
}
data:extend{ocE}


-- Item --
local ocI = {}
ocI.type = "item-with-tags"
ocI.name = "OreCleaner"
ocI.icon = "__Mobile_Factory_Graphics__/graphics/entity/OreCleanerI.png"
ocI.icon_size = 256
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
ocT.icon = "__Mobile_Factory_Graphics__/graphics/entity/OreCleanerI.png"
ocT.icon_size = 256
ocT.unit = {
	count=15,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
ocT.prerequisites = {"MatterSerialization", "DeepStorage"}
ocT.effects = {{type="unlock-recipe", recipe="OreCleaner"}}
data:extend{ocT}

-- Animation --
local ocAn = {}
ocAn.name = "OreCleanerAn"
ocAn.type = "animation"
ocAn.frame_count = 60
ocAn.filename = "__Mobile_Factory_Graphics__/graphics/entity/OreCleanerAn.png"
ocAn.size = 600
ocAn.line_length = 10
ocAn.animation_speed = 1
ocAn.scale = 1/600*33*6
ocAn.flags = {"terrain"}
ocAn.draw_as_glow = true
data:extend{ocAn}