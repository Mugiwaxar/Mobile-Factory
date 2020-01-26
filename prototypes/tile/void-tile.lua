------------------------------- VOID TILE ------------------

-- Item --
local vtI = {}
vtI.type = "item"
vtI.name = "VoidTile"
vtI.icon = "__base__/graphics/terrain/out-of-map.png"
vtI.icon_size = 32
vtI.subgroup = "Tiles"
vtI.order = "b"
vtI.stack_size = 1000
vtI.place_as_tile =
    {
      result = "out-of-map",
      condition_size = 1,
      condition = { "water-tile" }
    }
data:extend{vtI}

-- Recipe --
local vtR = {}
vtR.type = "recipe"
vtR.name = "VoidTile"
vtR.energy_required = 1
vtR.enabled = false
vtR.ingredients =
    {
		{"DimensionalOre", 4}
    }
vtR.result = "VoidTile"
data:extend{vtR}

-- Technology --
local vtT = {}
vtT.name = "VoidTile"
vtT.type = "technology"
vtT.icon = "__base__/graphics/terrain/out-of-map.png"
vtT.icon_size = 32
vtT.unit = {
	count=500,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
vtT.prerequisites = {"LabTile"}
vtT.effects = {{type="unlock-recipe", recipe="VoidTile"}}
data:extend{vtT}