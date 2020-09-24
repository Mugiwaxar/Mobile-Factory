for _, da in pairs(global.dataAssemblerTable or {}) do
	for id, recipe in pairs(da.recipeTable or {}) do
		local recipePrototype = recipe.recipePrototype
		recipe.mainProduct = nil
		recipe.products = {}
		-- Update products
		for _, product in ipairs(recipePrototype.products) do
			if game.item_prototypes[product.name] ~= nil then
				table.insert(recipe.products, {name=product.name, type=product.type, amount=product.amount, probability = product.probability or 1,sprite="item/" .. product.name, tooltip=game.item_prototypes[product.name].localised_name})
			elseif game.fluid_prototypes[product.name] ~= nil then
				table.insert(recipe.products, {name=product.name, type=product.type, amount=product.amount, probability = product.probability or 1, sprite="fluid/" .. product.name, tooltip=game.fluid_prototypes[product.name].localised_name})
			end
		end
		-- Select default main product
		if recipePrototype.main_product ~= nil and recipePrototype.main_product.name ~= recipe.products[1].name then
			for idx, product in ipairs(recipe.products) do
				if product.name == recipePrototype.main_product.name then
					products[1], products[idx] = products[idx], products[1]
					break
				end
			end
		end
		-- Add tooltips to ingredients
		for _, ingredient in ipairs(recipe.ingredients) do
			if game.item_prototypes[ingredient.name] ~= nil then
				ingredient.tooltip = game.item_prototypes[ingredient.name].localised_name
			elseif game.fluid_prototypes[ingredient.name] ~= nil then
				ingredient.tooltip = game.fluid_prototypes[ingredient.name].localised_name
			else
				ingredient.tooltip = ""
			end
		end
	end
end