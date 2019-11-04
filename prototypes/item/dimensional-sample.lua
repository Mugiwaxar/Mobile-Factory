-- Dimensional Sample --

-- Item --
local dmS = {}
dmS.type = "tool"
dmS.name = "DimensionalSample"
dmS.durability = 1
dmS.infinite = false
dmS.icon = "__Mobile_Factory__/graphics/icones/DimensionalSample.png"
dmS.icon_size = 32
dmS.subgroup = "Resources"
dmS.order = "c"
dmS.stack_size = 1000
data:extend{dmS}

-- Recipe --
local dmR = {}
dmR.type = "recipe"
dmR.name = "DimensionalSample"
dmR.energy_required = 1
dmR.ingredients =
    {
      {"DimensionalOre", 1}
    }
dmR.result = "DimensionalSample"
dmR.result_count = 3
data:extend{dmR}