-- Item --
local dpI = {}
dpI.type = "item"
dpI.name = "DimensionalPlate"
dpI.icon = "__Mobile_Factory_Graphics__/graphics/icons/DimensionalPlate.png"
dpI.icon_size = 32
dpI.subgroup = "Resources"
dpI.order = "d"
dpI.stack_size = 1000
data:extend{dpI}

-- Recipe --
local dpR = {}
dpR.type = "recipe"
dpR.name = "DimensionalPlate"
dpR.energy_required = 1
dpR.category = "DimensionalSmelting"
dpR.enabled = false
dpR.ingredients =
    {
		{"DimensionalOre", 2}
    }
dpR.result = "DimensionalPlate"
data:extend{dpR}