------------------------------- DIMENSIONAL TILE -------------------------------

-- Entity --
local dtE = table.deepcopy(data.raw.tile["refined-concrete"])
dtE.name = "DimensionalTile"
dtE.minable = {mining_time = 0.1, result = "DimensionalTile"}
dtE.variants.material_background =
{
    picture = "__Mobile_Factory__/graphics/DimensionalTileE.png",
    count = 8,
    scale = 0.5
}
data:extend{dtE}

-- Item --
local dtI = {}
dtI.type = "item"
dtI.name = "DimensionalTile"
dtI.icon = "__Mobile_Factory__/graphics/DimensionalTileI.png"
dtI.icon_size = 64
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