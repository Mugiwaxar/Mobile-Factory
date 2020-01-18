----------------- HYDROCOAL ---------------

-- Item --
local hcI = {}
hcI.type = "item"
hcI.name = "Hydrocoal"
hcI.icon = "__Mobile_Factory_Graphics__/graphics/icones/Hydrocoal.png"
hcI.icon_size = 32
hcI.fuel_category = "chemical"
hcI.fuel_value = "15MJ"
hcI.subgroup = "Resources"
hcI.order = "i"
hcI.stack_size = 1000
data:extend{hcI}

-- Recipe --
local hcR = {}
hcR.type = "recipe"
hcR.name = "Hydrocoal"
hcR.energy_required = 5
hcR.enabled = false
hcR.category = "Elements"
hcR.ingredients =
    {
		{type="fluid", name="mfHydrogen", amount=150},
		{type="item", name="coal", amount=10}
    }
hcR.results = {{type="item", name="Hydrocoal", amount=10}}
data:extend{hcR}

-- Technology --
local hcT = {}
hcT.name = "Hydrocoal"
hcT.type = "technology"
hcT.icon = "__Mobile_Factory_Graphics__/graphics/icones/Hydrocoal.png"
hcT.icon_size = 32
hcT.unit = {
	count=800,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
hcT.prerequisites = {"DimensionalPlant"}
hcT.effects = {{type="unlock-recipe", recipe="Hydrocoal"}}
data:extend{hcT}