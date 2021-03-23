---------------- Mobile Factory Laser Energy Drain tehcnology ----------------
local ldT = {}
ldT.name = "EnergyDrain1"
ldT.type = "technology"
ldT.icon = "__Mobile_Factory_Graphics__/graphics/icons/EnergyLaserE.png"
ldT.icon_size = 256
ldT.unit = {
	count=600,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
ldT.prerequisites = {"MobileFactory"}
ldT.effects = {{type="nothing", effect_description={"description.EnergyDrain1"}}}
data:extend{ldT}

---------------- ENERGY LOGISTIC 1 ----------------
local el1T = {}
el1T.name = "EnergyLogistic"
el1T.type = "technology"
el1T.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK1I.png"
el1T.icon_size = 128
el1T.unit = {
	count=1000,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
el1T.prerequisites = {"DimensionalElectronic"}
el1T.effects =
{
	{type="unlock-recipe", recipe="EnergyCubeMK1"},
	{type="unlock-recipe", recipe="EnergyLaser1"}
}
data:extend{el1T}

---------------- ENERGY LOGISTIC 2 ----------------
local el2T = {}
el2T.name = "EnergyLogistic2"
el2T.type = "technology"
el2T.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK2I.png"
el2T.icon_size = 128
el2T.unit = {
	count=15,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
el2T.prerequisites = {"EnergyLogistic", "DimensionalCrystal"}
el2T.effects =
{
	{type="unlock-recipe", recipe="EnergyCubeMK2"},
	{type="unlock-recipe", recipe="EnergyLaser2"}
}
data:extend{el2T}

---------------- ENERGY LOGISTIC 3 ----------------
local el3T = {}
el3T.name = "EnergyLogistic3"
el3T.type = "technology"
el3T.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK3I.png"
el3T.icon_size = 128
el3T.unit = {
	count=30,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
el3T.prerequisites = {"EnergyLogistic2", "EnergyCore"}
el3T.effects =
{
	{type="unlock-recipe", recipe="EnergyCubeMK3"},
	{type="unlock-recipe", recipe="EnergyLaser3"}
}
data:extend{el3T}

---------------- QUATRON LOGISTIC ----------------
local ql1T = {}
ql1T.name = "QuatronLogistic"
ql1T.type = "technology"
ql1T.icon = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK1I.png"
ql1T.icon_size = 128
ql1T.unit = {
	count=10,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
ql1T.prerequisites = {"Quatron"}
ql1T.effects =
{
	{type="unlock-recipe", recipe="QuatronCubeMK1"},
	{type="unlock-recipe", recipe="QuatronLaser1"},
	{type="unlock-recipe", recipe="QuatronReactor"}
}
data:extend{ql1T}

---------------- QUATRON LOGISTIC 2 ----------------
local ql2T = {}
ql2T.name = "QuatronLogistic2"
ql2T.type = "technology"
ql2T.icon = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK2I.png"
ql2T.icon_size = 128
ql2T.unit = {
	count=15,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
ql2T.prerequisites =  {"QuatronLogistic", "DimensionalCrystal"}
ql2T.effects =
{
	{type="unlock-recipe", recipe="QuatronCubeMK2"},
	{type="unlock-recipe", recipe="QuatronLaser2"}
}
data:extend{ql2T}

---------------- QUATRON LOGISTIC 3 ----------------
local qlT = {}
qlT.name = "QuatronLogistic3"
qlT.type = "technology"
qlT.icon = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK3I.png"
qlT.icon_size = 128
qlT.unit = {
	count=30,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
qlT.prerequisites = {"QuatronLogistic2", "EnergyCore"}
qlT.effects =
{
	{type="unlock-recipe", recipe="QuatronCubeMK3"},
	{type="unlock-recipe", recipe="QuatronLaser3"}
}
data:extend{qlT}