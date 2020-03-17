-- Power Module Item --
pMI = {}
pMI.type = "module"
pMI.name = "EnergyPowerModule"
pMI.icon = "__Mobile_Factory_Graphics__/graphics/icones/EnergyPowerModule.png"
pMI.icon_size = 32
pMI.subgroup = "Modules1"
pMI.category = "productivity"
pMI.tier = 1
pMI.order = "MA"
pMI.stack_size = 5
pMI.effect = {}
data:extend{pMI}

-- Power Module Recipe --
local pMR = {}
pMR.type = "recipe"
pMR.name = "EnergyPowerModule"
pMR.energy_required = 3
pMR.enabled = false
pMR.ingredients =
    {
      {"DimensionalWire", 3},
	  {"DimensionalCircuit", 8}
    }
pMR.result = "EnergyPowerModule"
pMR.result_count = 1
data:extend{pMR}


-- Efficiency Module Item --
eMI = {}
eMI.type = "module"
eMI.name = "EnergyEfficiencyModule"
eMI.icon = "__Mobile_Factory_Graphics__/graphics/icones/EnergyEfficiencyModule.png"
eMI.icon_size = 32
eMI.subgroup = "Modules1"
eMI.category = "productivity"
eMI.tier = 1
eMI.order = "MB"
eMI.stack_size = 5
eMI.effect = {}
data:extend{eMI}

-- Efficiency Module Recipe --
local eMR = {}
eMR.type = "recipe"
eMR.name = "EnergyEfficiencyModule"
eMR.energy_required = 3
eMR.enabled = false
eMR.ingredients =
    {
      {"DimensionalWire", 3},
	  {"DimensionalCircuit", 8}
    }
eMR.result = "EnergyEfficiencyModule"
eMR.result_count = 1
data:extend{eMR}


-- Focus Module Item --
fMI = {}
fMI.type = "module"
fMI.name = "EnergyFocusModule"
fMI.icon = "__Mobile_Factory_Graphics__/graphics/icones/EnergyFocusModule.png"
fMI.icon_size = 32
fMI.subgroup = "Modules1"
fMI.category = "productivity"
fMI.tier = 1
fMI.order = "MC"
fMI.stack_size = 5
fMI.effect = {}
data:extend{fMI}

-- Focus Module Recipe --
local fMR = {}
fMR.type = "recipe"
fMR.name = "EnergyFocusModule"
fMR.energy_required = 3
fMR.enabled = false
fMR.ingredients =
    {
      {"DimensionalWire", 3},
	  {"DimensionalCircuit", 8}
    }
fMR.result = "EnergyFocusModule"
fMR.result_count = 1
data:extend{fMR}


-- Power Module Technology --
local pMT = {}
pMT.name = "EnergyPowerModule"
pMT.type = "technology"
pMT.icon = "__Mobile_Factory_Graphics__/graphics/icones/EnergyPowerModule.png"
pMT.icon_size = 32
pMT.unit = {
	count=400,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
pMT.prerequisites = {"DimensionalElectronic"}
pMT.effects = {
	{type="unlock-recipe", recipe="EnergyPowerModule"},
	{type="unlock-recipe", recipe="EnergyEfficiencyModule"},
	{type="unlock-recipe", recipe="EnergyFocusModule"},
}
data:extend{pMT}