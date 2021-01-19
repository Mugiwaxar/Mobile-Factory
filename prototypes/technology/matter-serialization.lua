---------------- DIMENSIONAL LOGISTIC -------------------

-- Matter Serialization --
local msT = {}
msT.name = "MatterSerialization"
msT.type = "technology"
msT.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/MatterSerializationI.png"
msT.icon_size = 64
msT.unit = {
	count=15,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
msT.prerequisites = {"Quatron"}
msT.effects =
{
	{type="nothing", effect_description={"description.MatterSerialization"}},
	{type="unlock-recipe", recipe="NetworkAccessPoint"},
	{type="unlock-recipe", recipe="MatterInteractor"},
	{type="unlock-recipe", recipe="DataStorage"}
}
data:extend{msT}

-- Item Drain --
local idT = {}
idT.name = "TechItemDrain"
idT.type = "technology"
idT.icon = "__Mobile_Factory_Graphics__/graphics/icons/TechItemDrain.png"
idT.icon_size = 32
idT.unit = {
	count=5,
	time=60,
	ingredients={
		{"DimensionalSample", 200},
		{"DimensionalCrystal", 1}
	}
}
idT.prerequisites = {"MatterSerialization"}
idT.effects = {{type="nothing", effect_description={"description.TechItemDrain"}}}
data:extend{idT}