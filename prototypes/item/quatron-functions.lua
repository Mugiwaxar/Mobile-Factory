----------------------------------------- QUATRON FUNCTION ---------------------------

-- Create a Quatron --
function createQuatron(level, ingredients)

-- Item --
qI = {}
qI.name = "Quatron" .. tonumber(level)
qI.type = "item"
qI.stack_size = 50
qI.icon = "__Mobile_Factory_Graphics__/graphics/icones/Quatron.png"
qI.icon_size = 32
qI.subgroup = "Quatrons"
if level < 10 then qI.order = "a0" .. tonumber(level) else qI.order = "a" .. tonumber(level) end
data:extend{qI}

-- Fluid --
local qF = {}
qF.name = "LiquidQuatron" .. tonumber(level)
qF.type = "fluid"
qF.auto_barrel = false
qF.icon = "__Mobile_Factory_Graphics__/graphics/icones/FluidQuatron.png"
qF.icon_size = 32
qF.default_temperature = 20
qF.max_temperature = 100
qF.base_color={84,14,151}
qF.flow_color={84,14,151}
qF.subgroup = "Resources"
if level < 10 then qF.order = "b0" .. tonumber(level) else qF.order = "b" .. tonumber(level) end
data:extend{qF}

-- Fluid Recipe --
lqR = {}
lqR.name = "LiquidQuatron" .. tonumber(level)
lqR.type = "recipe"
-- lqR.order = "b"
lqR.icon = "__Mobile_Factory_Graphics__/graphics/icones/FluidQuatron.png"
lqR.icon_size = 32
lqR.category = "Elements"
lqR.subgroup = "Quatrons"
lqR.energy_required = level
lqR.enabled = false
lqR.ingredients = {}
for k, i in pairs(ingredients) do
	table.insert(lqR.ingredients, {type=i[1], name=i[2], amount=i[3]})
end
lqR.results = {{type="fluid", name="LiquidQuatron" .. tonumber(level), amount=100}}
data:extend{lqR}

-- Quatron to Cell Recipe --
qcR = {}
qcR.name = "Quatron" .. tonumber(level)
qcR.type = "recipe"
qcR.icon = "__Mobile_Factory_Graphics__/graphics/icones/Quatron.png"
qcR.icon_size = 32
qcR.category = "Elements"
qcR.subgroup = "QuatronsToCell"
qcR.energy_required = 2
qcR.enabled = false
qcR.ingredients = {{type="fluid", name="LiquidQuatron" .. tonumber(level), amount=100}}
qcR.result = "Quatron" .. tonumber(level)
data:extend{qcR}

-- Cell to Quatron Recipe --
clqR = {}
clqR.name = "CellToLiquidQuatron" .. tonumber(level)
clqR.type = "recipe"
clqR.icon = "__Mobile_Factory__/graphics/CellToFluidQuatron.png"
clqR.icon_size = 32
clqR.category = "Elements"
clqR.subgroup = "CellToQuatrons"
clqR.energy_required = 2
clqR.enabled = false
clqR.ingredients = {{type="item", name="Quatron" .. tonumber(level), amount=1}}
clqR.results = {{type="fluid", name="LiquidQuatron" .. tonumber(level), amount=100}}
data:extend{clqR}

end

-- Create the Quatron Technology --
function createQuatronTechnology()
	-- Create the Quatron table --
	local quatronTable = {}
	for i=1, 20 do
		table.insert(quatronTable, {type="unlock-recipe", recipe="Quatron" .. tonumber(i)})
		table.insert(quatronTable, {type="unlock-recipe", recipe="LiquidQuatron" .. tonumber(i)})
		table.insert(quatronTable, {type="unlock-recipe", recipe="CellToLiquidQuatron" .. tonumber(i)})
	end
	-- Technology --
	qT = {}
	qT.name = "Quatron"
	qT.type = "technology"
	qT.icon = "__Mobile_Factory_Graphics__/graphics/icones/Quatron.png"
	qT.icon_size = 32
	qT.prerequisites = {"DimensionalPlant", "DimensionalCrystal"}
	qT.unit = {
		count=5,
		time=60,
		ingredients={{"DimensionalCrystal", 1},{"DimensionalSample",200}}
		}
	qT.effects = quatronTable
	data:extend{qT}
end