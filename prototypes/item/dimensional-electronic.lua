-- DIMENSIONAL WIRE --

-- Item --
local dwI = {}
dwI.type = "item"
dwI.name = "DimensionalWire"
dwI.icon = "__Mobile_Factory__/graphics/icones/DimensionalWire.png"
dwI.icon_size = 32
dwI.subgroup = "Resources"
dwI.order = "e"
dwI.stack_size = 500
data:extend{dwI}

-- Recipe --
local dwR = {}
dwR.type = "recipe"
dwR.name = "DimensionalWire"
dwR.energy_required = 1
dwR.enabled = false
dwR.ingredients =
{
	{"DimensionalPlate", 1}
}
dwR.result = "DimensionalWire"
data:extend{dwR}


-- DIMENSIONAL CIRCUIT --

-- Item --
local dcI = {}
dcI.type = "item"
dcI.name = "DimensionalCircuit"
dcI.icon = "__Mobile_Factory__/graphics/icones/DimensionalCircuit.png"
dcI.icon_size = 32
dcI.subgroup = "Resources"
dcI.order = "f"
dcI.stack_size = 200
data:extend{dcI}

-- Recipe --
local dcR = {}
dcR.type = "recipe"
dcR.name = "DimensionalCircuit"
dcR.energy_required = 2
dcR.enabled = false
dcR.ingredients =
{
	{"DimensionalPlate", 1},
	{"DimensionalWire", 3}
}
dcR.result = "DimensionalCircuit"
data:extend{dcR}


-- TECHNOLOGY --
local deT = {}
deT.type = "technology"
deT.name = "DimensionalElectronic"
deT.icon = "__Mobile_Factory__/graphics/icones/DimensionalElectronic.png"
deT.icon_size = 128
deT.unit =
{
	count = 350,
	time = 2,
	ingredients = 
	{
		{"DimensionalSample", 1}
	}
}
deT.prerequisites = {"DimensionalOreSmelting"}
deT.effects = {{type="unlock-recipe", recipe="DimensionalWire"},{type="unlock-recipe", recipe="DimensionalCircuit"}}
data:extend{deT}