-------------------------------- ELEMENTS FUNCTIONS ------------------------------

-- Create an element --
function createElement(name, atNumber, type, color)
	eI = {}
	eI.name = name
	eI.type = type
	eI.icon = "__Mobile_Factory_Graphics__/graphics/elements/" .. name .. ".png"
	eI.icon_size = 89
	eI.order = tonumber(atNumber)
	
	if atNumber > 0 then
		eI.subgroup = "Elements"
	else
		eI.subgroup = "Molecules"
	end
	
	if type == "fluid" then
		eI.default_temperature = 20
		eI.max_temperature = 300
		eI.base_color = color
		eI.flow_color = color
	else
		eI.stack_size = 100
	end
	
	data:extend{eI}
end

-- Create a Recipe --
function createRecipe(name, ingredients, results, subgroup)
	eR = {}
	eR.name = name
	eR.type = "recipe"
	eR.icon = "__Mobile_Factory_Graphics__/graphics/e-technology/" .. name .. ".png"
	eR.icon_size = 89
	eR.category = "Elements"
	eR.subgroup = subgroup or "Elements"
	eR.main_product = ""
	eR.energy_required = 1
	eR.enabled = false
	eR.ingredients = {}
	eR.results = {}
	for k, i in pairs(ingredients) do
		table.insert(eR.ingredients, {type=i[1], name=i[2], amount=i[3]})
	end
	for k, r in pairs(results) do
		table.insert(eR.results, {type=r[1], name=r[2], amount=r[3]})
	end
	data:extend{eR}
end
	
-- Create a Technology --
function createTechnology(name, unit, prerequisites, unlock)
	eT = {}
	eT.name = name
	eT.type = "technology"
	eT.icon = "__Mobile_Factory_Graphics__/graphics/e-technology/" .. name .. ".png"
	eT.icon_size = 89
	eT.prerequisites = prerequisites
	eT.unit = {
	count=unit[1],
	time=unit[2],
	ingredients=unit[3] 
	}
	eT.effects = {}
	for k, effect in pairs(unlock) do
		table.insert(eT.effects, {type="unlock-recipe", recipe=effect})
	end
	
	data:extend{eT}
end