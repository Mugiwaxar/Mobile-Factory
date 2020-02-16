------------------------------- DIMENSIONAL TILE -------------------------------

local dtTint = {150,50,130}

-- Entity --
local dtE = table.deepcopy(data.raw.tile["refined-concrete"])
dtE.name = "DimensionalTile"
dtE.tint = dtTint
data:extend{dtE}

-- Item --
local dtI = {}
dtI.type = "item"
dtI.name = "DimensionalTile"
dtI.icons = {{icon="__base__/graphics/icons/refined-concrete.png", icon_size=64, tint = dtTint}}
dtI.subgroup = "Tiles"
dtI.order = "c"
dtI.stack_size = 1000
dtI.place_as_tile =
    {
      result = "DimensionalTile",
      condition_size = 1,
      condition = {}
    }
data:extend{dtI}

-- Recipe --
local dtR = {}
dtR.type = "recipe"
dtR.name = "DimensionalTile"
dtR.energy_required = 1.3
dtR.enabled = true
dtR.ingredients =
    {
		{"DimensionalOre", 8}
    }
dtR.result = "DimensionalTile"
data:extend{dtR}