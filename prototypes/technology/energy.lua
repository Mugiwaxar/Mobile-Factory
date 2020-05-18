---------------- Mobile Factory Laser Energy Drain tehcnology ----------------
local ldT = {}
ldT.name = "EnergyDrain1"
ldT.type = "technology"
ldT.icon = "__Mobile_Factory_Graphics__/graphics/icones/TecEnergyDrain1.png"
ldT.icon_size = 32
ldT.unit = {
	count=600,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
ldT.prerequisites = {"DimensionalOre"}
ldT.effects = {{type="nothing", effect_description={"description.EnergyDrain1"}}}
data:extend{ldT}

---------------- ENERGY LOGISTIC ----------------
local elT = {}
elT.name = "EnergyLogistic"
elT.type = "technology"
elT.icon = "__Mobile_Factory__/graphics/InternalEnergyCubeI.png"
elT.icon_size = 128
elT.unit = {
	count=1000,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
elT.prerequisites = {"DimensionalElectronic"}
elT.effects =
{
	{type="unlock-recipe", recipe="EnergyCubeMK1"},
	{type="unlock-recipe", recipe="EnergyLaser1"}
}
data:extend{elT}

---------------- QUATRON LOGISTIC ----------------
local qlT = {}
qlT.name = "QuatronLogistic"
qlT.type = "technology"
qlT.icon = "__Mobile_Factory__/graphics/InternalQuatronCubeI.png"
qlT.icon_size = 128
qlT.unit = {
	count=10,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
qlT.prerequisites = {"DimensionalElectronic", "Quatron"}
qlT.effects =
{
	{type="unlock-recipe", recipe="QuatronCubeMK1"},
	{type="unlock-recipe", recipe="QuatronLaser1"},
	{type="unlock-recipe", recipe="QuatronReactor"}
}
data:extend{qlT}