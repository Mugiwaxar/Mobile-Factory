-- MACHINE FRAME MK1 --

-- Item --
local mfI = {}
mfI.type = "item"
mfI.name = "MachineFrame"
mfI.icon = "__Mobile_Factory__/graphics/icones/MachineFrame.png"
mfI.icon_size = 64
mfI.subgroup = "Intermediate"
mfI.order = "b1"
mfI.stack_size = 150
data:extend{mfI}

-- Recipe --
local mfR = {}
mfR.type = "recipe"
mfR.name = "MachineFrame"
mfR.energy_required = 1
mfR.ingredients =
    {
      {"DimensionalOre", 7}
    }
mfR.result = "MachineFrame"
data:extend{mfR}

-- MACHINE FRAME MK2 --

-- Item --
local mf2I = {}
mf2I.type = "item"
mf2I.name = "MachineFrame2"
mf2I.icon = "__Mobile_Factory__/graphics/icones/MachineFrame2.png"
mf2I.icon_size = 64
mf2I.subgroup = "Intermediate"
mf2I.order = "b2"
mf2I.stack_size = 150
data:extend{mf2I}

-- Recipe --
local mf2R = {}
mf2R.type = "recipe"
mf2R.name = "MachineFrame2"
mf2R.energy_required = 1.5
mf2R.enabled = false
mf2R.ingredients =
    {
      {"DimensionalPlate", 10}
    }
mf2R.result = "MachineFrame2"
data:extend{mf2R}


-- MACHINE FRAME MK3 --

-- Item --
local mf3I = {}
mf3I.type = "item"
mf3I.name = "MachineFrame3"
mf3I.icon = "__Mobile_Factory__/graphics/icones/MachineFrame3.png"
mf3I.icon_size = 64
mf3I.subgroup = "Intermediate"
mf3I.order = "b3"
mf3I.stack_size = 150
data:extend{mf3I}

-- Recipe --
local mf3I = {}
mf3I.type = "recipe"
mf3I.name = "MachineFrame3"
mf3I.energy_required = 3
mf3I.enabled = false
mf3I.category = "DimensionalCrystallizaton"
mf3I.ingredients =
    {
      {"MachineFrame2", 1},
	  {"DimensionalCrystal", 1}
    }
mf3I.result = "MachineFrame3"
data:extend{mf3I}