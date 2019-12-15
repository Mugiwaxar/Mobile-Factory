-- Dimensional Sample --

-- Item --
local dsI = {}
dsI.type = "tool"
dsI.name = "DimensionalSample"
dsI.durability = 1
dsI.infinite = false
dsI.icon = "__Mobile_Factory__/graphics/icones/DimensionalSample.png"
dsI.icon_size = 32
dsI.subgroup = "Resources"
dsI.order = "c"
dsI.stack_size = 1000
data:extend{dsI}

-- Recipe --
local dsR = {}
dsR.type = "recipe"
dsR.name = "DimensionalSample"
dsR.energy_required = 1
dsR.ingredients =
    {
      {"DimensionalOre", 1}
    }
dsR.result = "DimensionalSample"
dsR.result_count = 3
data:extend{dsR}