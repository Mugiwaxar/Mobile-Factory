---------------- DIMENSIONAL LOGISTIC -------------------

-- Dimensional Logisctic --
local dlT = {}
dlT.name = "DimensionalLogistic"
dlT.type = "technology"
dlT.icon = "__Mobile_Factory__/graphics/icones/TechDimensionalLogistic.png"
dlT.icon_size = 32
dlT.unit = {
	count=15,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
dlT.prerequisites = {"DimensionalCrystal"}
dlT.effects = {{type="nothing", effect_description={"description.DimensionalLogistic"}}, {type="unlock-recipe", recipe="RequesterPad"}, {type="unlock-recipe", recipe="ProviderPad"}}
data:extend{dlT}


-- Item Drain --
local idT = {}
idT.name = "TechItemDrain"
idT.type = "technology"
idT.icon = "__Mobile_Factory__/graphics/icones/TechItemDrain.png"
idT.icon_size = 32
idT.unit = {
	count=5,
	time=60,
	ingredients={
		{"DimensionalSample", 200},
		{"DimensionalCrystal", 1}
	}
}
idT.prerequisites = {"DimensionalLogistic"}
idT.effects = {{type="nothing", effect_description={"description.TechItemDrain"}}}
data:extend{idT}