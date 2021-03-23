-- Power Module Item --
local pMI = {}
pMI.type = "item"
pMI.name = "EnergyPowerModule"
pMI.placed_as_equipment_result = "EnergyPowerModule"
pMI.icon = "__Mobile_Factory_Graphics__/graphics/icons/MFEnergyPowerModule.png"
pMI.icon_size = 64
pMI.subgroup = "Modules1"
pMI.order = "a"
pMI.stack_size = 20
data:extend{pMI}

-- Power Module Equipement --
local pmE = {}
pmE.name = "EnergyPowerModule"
pmE.type = "battery-equipment"
pmE.categories = {"mfEquipments"}
pmE.sprite = {filename="__Mobile_Factory_Graphics__/graphics/icons/MFEnergyPowerModule.png", size=64}
pmE.shape = {width=2, height=2, type="full"}
pmE.energy_source =
{
	type="electric",
	usage_priority="tertiary",
	input_flow_limit="0J",
	output_flow_limit="0J",
	buffer_capacity="0J"
}
data:extend{pmE}

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
local eMI = {}
eMI.type = "item"
eMI.name = "EnergyEfficiencyModule"
eMI.placed_as_equipment_result = "EnergyEfficiencyModule"
eMI.icon = "__Mobile_Factory_Graphics__/graphics/icons/MFLaserEfficiencyModule.png"
eMI.icon_size = 64
eMI.subgroup = "Modules1"
eMI.order = "b"
eMI.stack_size = 20
data:extend{eMI}

-- Efficiency Module Equipement --
local emE = {}
emE.name = "EnergyEfficiencyModule"
emE.type = "battery-equipment"
emE.categories = {"mfEquipments"}
emE.sprite = {filename="__Mobile_Factory_Graphics__/graphics/icons/MFLaserEfficiencyModule.png", size=64}
emE.shape = {width=2, height=2, type="full"}
emE.energy_source =
{
	type="electric",
	usage_priority="tertiary",
	input_flow_limit="0J",
	output_flow_limit="0J",
	buffer_capacity="0J"
}
data:extend{emE}

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
local fMI = {}
fMI.type = "item"
fMI.name = "EnergyFocusModule"
fMI.placed_as_equipment_result = "EnergyFocusModule"
fMI.icon = "__Mobile_Factory_Graphics__/graphics/icons/MFLaserFocusModule.png"
fMI.icon_size = 64
fMI.subgroup = "Modules1"
fMI.order = "c"
fMI.stack_size = 20
data:extend{fMI}

-- Focus Module Equipement --
local fmE = {}
fmE.name = "EnergyFocusModule"
fmE.type = "battery-equipment"
fmE.categories = {"mfEquipments"}
fmE.sprite = {filename="__Mobile_Factory_Graphics__/graphics/icons/MFLaserFocusModule.png", size=64}
fmE.shape = {width=2, height=2, type="full"}
fmE.energy_source =
{
	type="electric",
	usage_priority="tertiary",
	input_flow_limit="0J",
	output_flow_limit="0J",
	buffer_capacity="0J"
}
data:extend{fmE}

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
pMT.icon = "__Mobile_Factory_Graphics__/graphics/icons/MFLasersModulesT.png"
pMT.icon_size = 128
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