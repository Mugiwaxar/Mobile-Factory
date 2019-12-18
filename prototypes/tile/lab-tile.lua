------------------------------- LAB TILE ------------------

-- Item --
local ltI = {}
ltI.type = "item"
ltI.name = "LabTile"
ltI.icon = "__base__/graphics/terrain/tutorial-grid/tutorial-grid-o.png"
ltI.icon_size = 32
ltI.subgroup = "Capsules"
ltI.order = "b"
ltI.stack_size = 1000
ltI.place_as_tile =
    {
      result = "tutorial-grid",
      condition_size = 1,
      condition = {}
    }
data:extend{ltI}

-- Recipe --
local lbR = {}
lbR.type = "recipe"
lbR.name = "LabTile"
lbR.energy_required = 1
lbR.enabled = false
lbR.ingredients =
    {
		{"DimensionalOre", 4}
    }
lbR.result = "LabTile"
data:extend{lbR}

-- Technology --
local lbT = {}
lbT.name = "LabTile"
lbT.type = "technology"
lbT.icon = "__base__/graphics/terrain/tutorial-grid/tutorial-grid-o.png"
lbT.icon_size = 32
lbT.unit = {
	count=350,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
lbT.prerequisites = {"DimensionalOre"}
lbT.effects = {{type="unlock-recipe", recipe="LabTile"}}
data:extend{lbT}

------------------------ BUILDTILE ------------------

-- Entity --
local btE = table.deepcopy(data.raw.tile["tutorial-grid"])
btE.name = "BuildTile"
btE.tint = {32,165,3}
data:extend{btE}