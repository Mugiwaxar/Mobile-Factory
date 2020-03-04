-- Erya Powder Item --
local epI = {}
epI.type = "item"
epI.name = "EryaPowder"
epI.icon = "__Mobile_Factory_Graphics__/graphics/Erya/EryaPowder.png"
epI.icon_size = 256
epI.subgroup = "EryaRessources"
epI.order = "a"
epI.stack_size = 1000
data:extend{epI}

-- Erya Powder Recipe --
local epR = {}
epR.type = "recipe"
epR.name = "EryaPowder"
epR.energy_required = 1
epR.enabled = false
epR.ingredients =
    {
      {"EryaSample", 3}
    }
epR.result = "EryaPowder"
epR.result_count = 1
data:extend{epR}

-- Erya Powder Recipe 2 --
local epR2 = {}
epR2.type = "recipe"
epR2.name = "EryaPowder2"
epR2.energy_required = 2
epR2.enabled = false
epR2.category = "EryaPowder"
epR2.ingredients = {}
epR2.hidden = true
epR2.result = "EryaPowder"
epR2.result_count = 1
data:extend{epR2}

-- Erya Sample Item --
local esI = {}
esI.type = "tool"
esI.name = "EryaSample"
esI.icon = "__Mobile_Factory_Graphics__/graphics/Erya/EryaSample.png"
esI.icon_size = 256
esI.subgroup = "EryaRessources"
esI.durability = 1
esI.infinite = false
esI.order = "b"
esI.stack_size = 1000
data:extend{esI}

-- Erya Sample Recipe --
local esR = {}
esR.type = "recipe"
esR.name = "EryaSample"
esR.energy_required = 1
esR.enabled = false
esR.ingredients =
    {
      {"EryaPowder", 1}
    }
esR.result = "EryaSample"
esR.result_count = 3
data:extend{esR}

-- Erya Plate Item --
local eplI = {}
eplI.type = "item"
eplI.name = "EryaPlate"
eplI.icon = "__Mobile_Factory_Graphics__/graphics/Erya/EryaPlate.png"
eplI.icon_size = 256
eplI.subgroup = "EryaIntermediates"
eplI.order = "a"
eplI.stack_size = 1000
data:extend{eplI}

-- Erya Plate Recipe --
local eplR = {}
eplR.type = "recipe"
eplR.name = "EryaPlate"
eplR.energy_required = 1
eplR.enabled = false
eplR.ingredients =
    {
        {"EryaPowder", 4}
    }
eplR.result = "EryaPlate"
data:extend{eplR}

-- Erya Wire Item --
local ewI = {}
ewI.type = "item"
ewI.name = "EryaWire"
ewI.icon = "__Mobile_Factory_Graphics__/graphics/Erya/EryaWire.png"
ewI.icon_size = 64
ewI.subgroup = "EryaIntermediates"
ewI.order = "c"
ewI.stack_size = 1000
data:extend{ewI}

-- Erya Wire Recipe --
local ewR = {}
ewR.type = "recipe"
ewR.name = "EryaWire"
ewR.energy_required = 1
ewR.enabled = false
ewR.ingredients =
    {
        {"EryaPlate", 1}
    }
ewR.result = "EryaWire"
data:extend{ewR}

-- Erya Circuit Item --
local ecI = {}
ecI.type = "item"
ecI.name = "EryaCircuit"
ecI.icon = "__Mobile_Factory_Graphics__/graphics/Erya/EryaCircuit.png"
ecI.icon_size = 64
ecI.subgroup = "EryaIntermediates"
ecI.order = "d"
ecI.stack_size = 200
data:extend{ecI}

-- Erya Circuit Recipe --
local ecR = {}
ecR.type = "recipe"
ecR.name = "EryaCircuit"
ecR.energy_required = 1
ecR.enabled = false
ecR.ingredients =
    {
        {"EryaPlate", 1},
        {"EryaWire", 2}
    }
ecR.result = "EryaCircuit"
data:extend{ecR}

-- Erya Machine Frame 1 Item --
local emf1I = {}
emf1I.type = "item"
emf1I.name = "EryaMachineFrame1"
emf1I.icon = "__Mobile_Factory_Graphics__/graphics/Erya/EryaMachineFrame1.png"
emf1I.icon_size = 256
emf1I.subgroup = "EryaIntermediates"
emf1I.order = "e"
emf1I.stack_size = 20
data:extend{emf1I}

-- Erya Machine Frame Recipe --
local emf1R = {}
emf1R.type = "recipe"
emf1R.name = "EryaMachineFrame1"
emf1R.energy_required = 1
emf1R.enabled = false
emf1R.ingredients =
    {
      {"EryaPlate", 3}
    }
emf1R.result = "EryaMachineFrame1"
data:extend{emf1R}

-- Technologie --
local eT = {}
eT.name = "Erya"
eT.type = "technology"
eT.icon = "__Mobile_Factory_Graphics__/graphics/Erya/EryaPowder.png"
eT.icon_size = 256
eT.unit = {
	count=300,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
eT.prerequisites = {"DimensionalOre"}
eT.effects =
{
    {type="unlock-recipe", recipe="EryaPowder"},
    {type="unlock-recipe", recipe="EryaSample"},
    {type="unlock-recipe", recipe="EryaPlate"},
    {type="unlock-recipe", recipe="EryaWire"},
    {type="unlock-recipe", recipe="EryaCircuit"},
    {type="unlock-recipe", recipe="EryaMachineFrame1"},
    {type="unlock-recipe", recipe="EryaCollector"}
}
data:extend{eT}