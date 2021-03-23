------------------------------- LAB TILE -------------------------------

-- Item --
local ltI = {}
ltI.type = "item"
ltI.name = "LabTile"
ltI.icon = "__Mobile_Factory_Graphics__/graphics/icons/labTileI.png"
ltI.icon_size = 128
ltI.subgroup = "Tiles"
ltI.order = "a"
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
lbT.icon = "__Mobile_Factory_Graphics__/graphics/icons/labTileI.png"
lbT.icon_size = 128
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
btE.icon = "__Mobile_Factory_Graphics__/graphics/icons/CAreaTileI.png"
btE.icon_size = 128
data:extend{btE}