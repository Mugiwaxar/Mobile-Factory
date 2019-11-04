----------------------------------------- QUATRON FUNCTION ---------------------------

-- Create a Quatron --
function createQuatron(level, ingredients, previousLevel)

-- Item --
qI = {}
qI.name = "Quatron" .. tonumber(level)
qI.type = "item"
qI.stack_size = 50
qI.icon = "__Mobile_Factory__/graphics/icones/Quatron.png"
qI.icon_size = 32
qI.subgroup = "Quatrons"
if level < 10 then qI.order = "0" .. tonumber(level) else qI.order = tonumber(level) end

data:extend{qI}

-- Recipe --
qR = {}
qR.name = "Quatron" .. tonumber(level)
qR.type = "recipe"
qR.icon = "__Mobile_Factory__/graphics/icones/Quatron.png"
qR.icon_size = 32
qR.category = "Elements"
qR.subgroup = "Quatrons"
qR.energy_required = 3 * level
qR.enabled = false
qR.ingredients = {}
for k, i in pairs(ingredients) do
	table.insert(qR.ingredients, {type=i[1], name=i[2], amount=i[3]})
end
qR.result = "Quatron" .. tonumber(level)
data:extend{qR}

-- Technology --
qT = {}
qT.name = "Quatron" .. tonumber(level)
qT.type = "technology"
qT.icon = "__Mobile_Factory__/graphics/icones/Quatron.png"
qT.icon_size = 32
if level == 1 then qT.prerequisites = {"DimensionalPlant"} else qT.prerequisites = {"Quatron" .. previousLevel} end
qT.unit = {
	count=level,
	time=2,
	ingredients={{"DimensionalCrystal", 1},{"DimensionalSample",100}}
	}
qT.effects = {{type="unlock-recipe", recipe="Quatron" .. tonumber(level)}}
data:extend{qT}

end