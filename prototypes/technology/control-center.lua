---------------------- Control Center Technology ---------------------

-- Unlock Control Center --
local CC = {}
CC.name = "ControlCenter"
CC.type = "technology"
CC.icon = "__Mobile_Factory_Graphics__/graphics/icones/TecControlCenter.png"
CC.icon_size = 32
CC.unit = {
	count=300,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
CC.prerequisites = {"DimensionalOre"}
CC.effects = {{type="nothing", effect_description={"description.ControlCenter"}}}
data:extend{CC}

-- Unlock Constructible Area 1 --
local ca1T = {}
ca1T.name = "ConstructibleArea1"
ca1T.type = "technology"
ca1T.icons = 
	{
		{icon="__base__/graphics/terrain/tutorial-grid/tutorial-grid-o.png", tint={32,165,3}}
	}
ca1T.icon_size = 32
ca1T.unit = {
	count=3,
	time=60,
	ingredients={
		{"DimensionalSample", 300},
		{"DimensionalCrystal", 1}
	}
}
ca1T.prerequisites = {"ControlCenter", "DimensionalCrystal"}
ca1T.effects = {{type="nothing", effect_description={"description.ConstructibleArea1"}}}
data:extend{ca1T}

-- Unlock Constructible Area 2 --
local ca2T = {}
ca2T.name = "ConstructibleArea2"
ca2T.type = "technology"
ca2T.icons = 
	{
		{icon="__base__/graphics/terrain/tutorial-grid/tutorial-grid-o.png", tint={32,165,3}}
	}
ca2T.icon_size = 32
ca2T.unit = {
	count=3,
	time=60,
	ingredients={
		{"DimensionalSample", 300},
		{"DimensionalCrystal", 1}
	}
}
ca2T.prerequisites = {"ControlCenter", "DimensionalCrystal"}
ca2T.effects = {{type="nothing", effect_description={"description.ConstructibleArea2"}}}
data:extend{ca2T}