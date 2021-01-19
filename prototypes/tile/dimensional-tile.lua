------------------------------- DIMENSIONAL TILE -------------------------------

-- Entity --
local dtE = table.deepcopy(data.raw.tile["refined-concrete"])
dtE.name = "DimensionalTile"
dtE.minable = {
	mining_time = 0.1,
    result = "DimensionalTile"
}
dtE.variants.material_background =
{
    picture = "__Mobile_Factory_Graphics__/graphics/entity/DimensionalTileE.png",
    count = 8,
    scale = 0.5
}
data:extend{dtE}

-- Item --
local dtI = {}
dtI.type = "item"
dtI.name = "DimensionalTile"
dtI.icon = "__Mobile_Factory_Graphics__/graphics/icons/DimensionalTileI.png"
dtI.icon_size = 64
dtI.subgroup = "Tiles"
dtI.order = "c"
dtI.stack_size = 1000
dtI.place_as_tile =
    {
      result = "DimensionalTile",
      condition_size = 1,
      condition = { "water-tile" }
    }
data:extend{dtI}

-- Recipe --
local dtR = {}
dtR.type = "recipe"
dtR.name = "DimensionalTile"
dtR.enabled = false
dtR.energy_required = 1.3
dtR.ingredients =
    {
		{"DimensionalOre", 8}
    }
dtR.result = "DimensionalTile"
data:extend{dtR}