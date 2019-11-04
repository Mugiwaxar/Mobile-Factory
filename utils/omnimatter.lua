---------------------- Omnimatter Recipe -------------------------------

-- Omnite to Dimensional Ore --
local doR = {}
doR.type = "recipe"
doR.name = "OmniDimOre"
doR.energy_required = 0.3
doR.enabled = true
doR.ingredients =
    {
		{"omnite", 1}
    }
doR.result = "DimensionalOre"
data:extend{doR}

-- Omnite to Dimensional Fluid --
local dfR = {}
dfR.type = "recipe"
dfR.name = "OmniDimFluid"
dfR.energy_required = 0.3
dfR.enabled = true
dfR.category = "crafting-with-fluid"
dfR.ingredients =
    {
		{type="fluid", name="omnic-water", amount=1}
    }
dfR.results = {{type="fluid", name="DimensionalFluid", amount=1}}
data:extend{dfR}