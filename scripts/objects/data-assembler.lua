-- DATA ASSEMBLER OBJECT --

-- Create the Data Assembler base object --
DA = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
    stateSprite = 0,
	active = false,
	consumption = _mfDAEnergyDrainPerUpdate,
	updateTick = 5,
	completeUpdateTick = 60,
	lastUpdate = 0,
	lastCompleteUpdate = 0,
	dataNetwork = nil,
	recipeID = 0,
	recipeTable = nil, -- [id]{recipePrototype, sprite, amount, progress, ingredients{name, type, amount, sprite, missing}, mainProduct{name, type, amount, sprite}, missingIngredient, inventoryFull, toManyInInventory}
	quatronLevel = 0,
	quatronCharge = 0,
	lastRecipeUpdatedID = 1
}

-- Constructor --
function DA:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DA
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	t.recipeTable = {}
    UpSys.addObj(t)
    -- Draw the state Sprite --
	t.stateSprite = rendering.draw_sprite{sprite="DataAssemblerSprite1", target=object, surface=object.surface, render_layer=131}
	return t
end

-- Reconstructor --
function DA:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = DA
	setmetatable(object, mt)
end

-- Destructor --
function DA:remove()
	-- Destroy the Sprites --
	rendering.destroy(self.stateSprite)
	-- Remove from the Update System --
	UpSys.removeObj(self)
	-- Remove from the Data Network --
	if self.dataNetwork ~= nil and getmetatable(self.dataNetwork) ~= nil then
		self.dataNetwork:removeObject(self)
	end
end

-- Is valid --
function DA:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function DA:update()
	
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end

	-- Update and Process a Recipe --
	if self.active == true then
		if self.lastRecipeUpdatedID > table_size(self.recipeTable) then self.lastRecipeUpdatedID = 1 end
		local i = 1
		for k, recipe in pairs(self.recipeTable) do
			if i == self.lastRecipeUpdatedID then
				self:updateRecipe(recipe, k)
			end
			i = i + 1
		end
		self.lastRecipeUpdatedID = self.lastRecipeUpdatedID + 1
	end
	
	-- Stop the express Update --
	if game.tick - self.lastCompleteUpdate < self.completeUpdateTick then return end
	self.lastCompleteUpdate = game.tick

    -- Try to find a connected Data Network --
	local obj = Util.getConnectedDN(self)
	if obj ~= nil and valid(obj.dataNetwork) then
		self.dataNetwork = obj.dataNetwork
		self.dataNetwork:addObject(self)
	else
		if valid(self.dataNetwork) then
			self.dataNetwork:removeObject(self)
		end
		self.dataNetwork = nil
	end

	-- Set Active or Not --
	if self.dataNetwork ~= nil and self.dataNetwork:isLive() == true then
		self:setActive(true)
	else
		self:setActive(false)
    end

    -- Stop if not active --
	if self.active == false then return end

	-- Get Quatron Charge if needed --
	if self.quatronCharge <= 15 then
		local quatron = self.dataNetwork.dataCenter.invObj:getBestQuatron()
		if quatron > 0 then
			self.quatronLevel = quatron
			self.quatronCharge = 100
		end
	end
	
end

-- Tooltip Infos --
function DA:getTooltipInfos(GUIObj, gui, justCreated)

	-- Create the Data Network Frame --
	GUIObj:addDataNetworkFrame(gui, self)

	-- Get the ScrollPane and the Flows --
	local assemblerScrollPane = GUIObj.AssemblerScrollPane
	local informationFlow = GUIObj.InformationFlow
	

	if justCreated == true then

		-- Add the Data Assembler to the GUI --
		GUIObj.DA = self

		-- Create the Assembler Title and Flow --
		local assemblerTitle = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Assembler"}, _mfOrange)

		-- Create the Assembler Scroll Pane
		assemblerScrollPane = GUIObj:addScrollPane("AssemblerScrollPane", assemblerTitle, 500, true)
		assemblerScrollPane.style = "MF_DA_scroll_pan"
		assemblerScrollPane.style.minimal_height = 450
		assemblerScrollPane.style.minimal_width = 250
		assemblerScrollPane.style.vertically_stretchable = true

		-- Create the Information Title and Flow --
		local informationTitle = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Information"}, _mfOrange)
		informationFlow = GUIObj:addFlow("InformationFlow", informationTitle, "vertical", true)

		-- Add the Add Recipe Text --
		GUIObj:addLabel("", informationFlow, {"gui-description.AddRecipe"}, _mfGreen, "", false, "LabelFont")

		-- Create the Add Recipe Flow --
		local addRFlow = GUIObj:addFlow("", informationFlow, "horizontal", false)
		addRFlow.style.bottom_padding = 10

		-- Create the Recipe selector --
		GUIObj:addFilter("DARecipe", addRFlow, {"gui-description.AddRecipeTT"}, true, "recipe", 28)

		-- Create the Amount selector --
		local amountSelector = GUIObj:addTextField("DAAmount", addRFlow, "", {"gui-description.AmountSelectorTT"}, true, true, false, false, false)
		amountSelector.style.width = 75

		-- Create the Add Recipe Button --
		GUIObj:addButton("DAAddR," .. self.entID, addRFlow, "PlusIcon", "PlusIcon", {"gui-description.AddRecipeTT"}, 28)

		-- Create the Quatron level Dual Label --
		GUIObj:addDualLabel(informationFlow, {"gui-description.Quatronlevel"}, self.quatronLevel, _mfOrange, _mfGreen, nil, "", "", "QuatronLevel", true)

		-- Create the Quatron Charge Dual Label --
		GUIObj:addDualLabel(informationFlow, {"gui-description.QuatronCharge"}, math.floor(self.quatronCharge), _mfOrange, _mfGreen, nil, "", "",  "QuatronCharge", true)

		-- Add the help Label --
		GUIObj:addLabel("", informationFlow, {"gui-description.DataAssemblerText1"}, _mfGreen)
		GUIObj:addLabel("", informationFlow, {"gui-description.DataAssemblerText2"}, _mfGreen)
		GUIObj:addLabel("", informationFlow, {"gui-description.DataAssemblerText3"}, _mfGreen)

	end

	-- Check the Data Network --
	if valid(self.dataNetwork) == true then
		
		-- Clear the ScrollPane --
		assemblerScrollPane.clear()

		-- Create all Recipe Frame --
		for k, recipe in pairs(self.recipeTable) do
			self:createFrame(GUIObj, assemblerScrollPane, recipe, k)
		end

	end

	-- Update the Quatron Level and Charge --
	if GUIObj.QuatronLevel ~= nil then GUIObj.QuatronLevel.Label2.caption = self.quatronLevel end
	if GUIObj.QuatronCharge ~= nil then GUIObj.QuatronCharge.Label2.caption = math.floor(self.quatronCharge) end
	
end

-- Set Active --
function DA:setActive(set)
    self.active = set
    if set == true then
        -- Create the Active Sprite --
        rendering.destroy(self.stateSprite)
        self.stateSprite = rendering.draw_sprite{sprite="DataAssemblerSprite2", target=self.ent, surface=self.ent.surface, render_layer=131}
    else
        -- Create the Inactive Sprite --
        rendering.destroy(self.stateSprite)
        self.stateSprite = rendering.draw_sprite{sprite="DataAssemblerSprite1", target=self.ent, surface=self.ent.surface, render_layer=131}
    end
end

-- Copy Settings --
function DA:copySettings(obj)
	self.recipeTable = {}
	for k, recipe in pairs(obj.recipeTable) do
		self:addRecipe(recipe.recipePrototype.name, recipe.amount)
	end
end

-- Create a Recipe Frame --
function DA:createFrame(GUIObj, gui, recipe, id)

	-- Check the Recipe --
	if recipe == nil or recipe.recipePrototype == nil or game.recipe_prototypes[recipe.recipePrototype.name] == nil then
		self.recipeTable[id] = nil
		return
	end
	
	-- Create the Frame --
	local frame = GUIObj:addFrame("", gui, "horizontal")

	-- Create the Recipe Flow --
	local recipeFlow = GUIObj:addFlow("", frame, "vertical")
	recipeFlow.style.horizontal_align = "center"

	-- Create the Recipe Icone --
	if game.item_prototypes[recipe.mainProduct.name] == nil and game.fluid_prototypes[recipe.mainProduct.name] == nil then
		self.recipeTable[id] = nil
		return
	end
	local tooltip = (recipe.amount or 0) > 0 and {"", recipe.recipePrototype.localised_name, " (max:", recipe.amount, ")"} or recipe.recipePrototype.localised_name
	local recipeButton = GUIObj:addButton("DARem," .. self.entID .. "," .. id, recipeFlow, recipe.sprite, recipe.sprite, tooltip, 50, false, true, recipe.amount)
	recipeButton.style = recipe.toManyInInventory == true and "MF_Fake_Button_Red" or "MF_Fake_Button_Green"
	recipeButton.style.padding = 0
	recipeButton.style.margin = 0

	-- Create the Process Flow --
	local processFlow = GUIObj:addFlow("", frame, "vertical")

	-- Create the Ingredients Flow --
	local ingredientsFlow = GUIObj:addFlow("", processFlow, "horizontal")

	-- Add all Buttons --
	for k, ingredient in pairs(recipe.ingredients) do
		if game.item_prototypes[ingredient.name] == nil and game.fluid_prototypes[ingredient.name] == nil then
			self.recipeTable[id] = nil
			return
		end
		local storedAmount = ingredient.type == "item" and self.dataNetwork:hasItem(ingredient.name) or self.dataNetwork:hasFluid(ingredient.name)
		local ingredientButton = GUIObj:addButton("", ingredientsFlow, ingredient.sprite, ingredient.sprite, ingredient.name, 30, false, true, storedAmount or 0)
		ingredientButton.style = ingredient.missing == true and "MF_Fake_Button_Red" or "MF_Fake_Button_Green"
		ingredientButton.style.padding = 0
		ingredientButton.style.margin = 0
	end

	-- Create the Progress Bar --
	local barColor = (self.quatronCharge > 0 and self.active == true ) and _mfGreen or _mfRed
	local PBar = GUIObj:addProgressBar("", processFlow, "", "", false, barColor, recipe.progress / recipe.recipePrototype.energy, 150)
	if GUIObj.PBarsTable == nil then GUIObj.PBarsTable = {} end
	GUIObj.PBarsTable[PBar] = recipe

	-- Check the Product --
	if game.item_prototypes[recipe.mainProduct.name] == nil and game.fluid_prototypes[recipe.mainProduct.name] == nil then
		self.recipeTable[id] = nil
		return
	end

	-- Create the Result Flow --
	local resultFlow = GUIObj:addFlow("", frame, "vertical")
	local storedAmount = recipe.mainProduct.type == "item" and self.dataNetwork:hasItem(recipe.mainProduct.name) or self.dataNetwork:hasFluid(recipe.mainProduct.name)
	local productButton = GUIObj:addButton("", resultFlow, recipe.mainProduct.sprite, recipe.mainProduct.sprite, recipe.mainProduct.name, 50, false, true, storedAmount or 0)
	productButton.style = recipe.inventoryFull == true and "MF_Fake_Button_Red" or "MF_Fake_Button_Green"
	productButton.style.padding = 0
	productButton.style.margin = 0

end

-- Update all Progress Bars --
function DA:updatePBars(GUIObj)
	local barColor = (self.quatronCharge > 0 and self.active == true ) and _mfGreen or _mfRed
	for PBar, recipe in pairs(GUIObj.PBarsTable or {}) do
		if valid(PBar) == true and recipe ~= nil then
			PBar.value = recipe.progress / recipe.recipePrototype.energy
			PBar.style.color = barColor
		end
	end
end

-- Get the next Recipe ID --
function DA:getID()
	self.recipeID = self.recipeID + 1
	return self.recipeID
end

-- Add a recipe to the Recipe list --
function DA:addRecipe(name, amount)

	-- Check the Values --
	if name == nil then return end
	amount = tonumber(amount)
	if amount == 0 then return end
	
	-- Check the Recipe --
	local recipePrototype = game.recipe_prototypes[name]
	if recipePrototype == nil then return end

	-- Create the Ingredients Table --
	local ingredientsTable = {}
	for k, ingredient in pairs(recipePrototype.ingredients) do
		if game.item_prototypes[ingredient.name] ~= nil then
			table.insert(ingredientsTable, {name=ingredient.name, type=ingredient.type, amount=ingredient.amount, sprite="item/" .. ingredient.name})
		elseif game.fluid_prototypes[ingredient.name] ~= nil then
			table.insert(ingredientsTable, {name=ingredient.name, type=ingredient.type, amount=ingredient.amount, sprite="fluid/" .. ingredient.name})
		else
			return
		end
	end

	-- Get the Main Product --
	local mainProduct = recipePrototype.main_product or recipePrototype.products[1]
	if mainProduct == nil then
		return
	end
	local mainProductTable = nil
	if game.item_prototypes[mainProduct.name] ~= nil then
		mainProductTable = {name=mainProduct.name, type=mainProduct.type, amount=mainProduct.amount, sprite="item/" .. mainProduct.name}
	elseif game.fluid_prototypes[mainProduct.name] ~= nil then
		mainProductTable = {name=mainProduct.name, type=mainProduct.type, amount=mainProduct.amount, sprite="fluid/" .. mainProduct.name}
	end
	if mainProductTable == nil then return end

	-- Create the Recipe Table --
	local recipeTable = {recipePrototype=recipePrototype, sprite="recipe/" .. recipePrototype.name, amount=amount, progress=0, ingredients=ingredientsTable, mainProduct=mainProductTable}

	-- Get all ingredients --
	self:getIngredients(recipeTable)

	-- Add the Recipe --
	self.recipeTable[self:getID()] = recipeTable

	-- Check if the recipe must be done --
	self:toManyInInventory(recipeTable, 0)

end

-- Remove a Recipe --
function DA:removeRecipe(id)
	if id == nil then return end
	self.recipeTable[id] = nil
end

-- Update a Recipe --
function DA:updateRecipe(recipe, id)

	-- Check the Recipe --
	if recipe == nil or recipe.recipePrototype == nil or game.recipe_prototypes[recipe.recipePrototype.name] == nil then
		self.recipeTable[id] = nil
		return
	end

	-- Check if the Recipe has terminated --
	if recipe.progress >= recipe.recipePrototype.energy then
		-- Send the Items to the Data Network --
		if recipe.mainProduct.type == "item" then
			if self.dataNetwork:canAcceptItem(recipe.mainProduct.name, recipe.mainProduct.amount) then
				self.dataNetwork:addItems(recipe.mainProduct.name, recipe.mainProduct.amount)
				recipe.inventoryFull = false
				recipe.progress = recipe.progress - recipe.recipePrototype.energy
				recipe.missingIngredient = true
			else
				recipe.inventoryFull = true
				return
			end
		end
		-- Send the Fluid to the Data Network --
		if recipe.mainProduct.type == "fluid" then
			if self.dataNetwork:canAcceptFluid(recipe.mainProduct.name, recipe.mainProduct.amount) then
				self.dataNetwork:addFluid(recipe.mainProduct.name, recipe.mainProduct.amount, 15)
				recipe.inventoryFull = false
				recipe.progress = recipe.progress - recipe.recipePrototype.energy
				recipe.missingIngredient = true
			else
				recipe.inventoryFull = true
				return
			end
		end
	end


	-- Check if the Recipe need Ingredients --
	if recipe.missingIngredient == true then
		self:getIngredients(recipe)
	end

	-- Check if the recipe must be done --
	self:toManyInInventory(recipe, id)

	-- Check if the Recipe can be processed --
	if recipe.missingIngredient == true or recipe.toManyInInventory == true or recipe.progress >= recipe.recipePrototype.energy or self.quatronCharge <= 0 then return end

	-- Process the Recipe --
	self:processRecipe(recipe)

end

-- Process a Recip --
function DA:processRecipe(recipe)
	recipe.progress = recipe.progress + ((1/ (self.completeUpdateTick / self.updateTick) ) * (self.quatronLevel/4))
	self.quatronCharge = self.quatronCharge - 1/12
	if self.quatronCharge < 0 then self.quatronCharge = 0 end
end

-- Check if the Recipe can get all Ingredients --
function DA:getIngredients(recipe)

	-- Check the Ingredients list --
	local missingIngredients = false
	for k, ingredient in pairs(recipe.ingredients) do
		local missing = false
		if ingredient.type == "item" then
			missing = self.dataNetwork:hasItem(ingredient.name) < ingredient.amount and true or false
		elseif ingredient.type == "fluid" then
			missing = self.dataNetwork:hasFluid(ingredient.name) < ingredient.amount and true or false
		end
		if missingIngredients ~= true then missingIngredients = missing end
		ingredient.missing = missing
	end

	-- Set missing --
	recipe.missingIngredient = missingIngredients

	-- Take all Ingredients --
	if missingIngredients == false then
		for k, ingredient in pairs(recipe.ingredients) do
			if ingredient.type == "item" then
				self.dataNetwork:getItem(ingredient.name, ingredient.amount)
			elseif ingredient.type == "fluid" then
				self.dataNetwork:getFluid(ingredient.name, ingredient.amount)
			end
		end
	end

end

-- Check if the Recipe must be done --
function DA:toManyInInventory(recipe, id)
	-- Get and check the main Product --
	local mainProduct = recipe.mainProduct
	if game.item_prototypes[mainProduct.name] == nil and game.fluid_prototypes[mainProduct.name] == nil then
		self.recipeTable[id] = nil
		return
	end
	-- Check if this is a Item --
	if mainProduct.type == "item" then
		if recipe.amount ~= nil and self.dataNetwork:hasItem(mainProduct.name) >= recipe.amount then
			recipe.toManyInInventory = true
		else
			recipe.toManyInInventory = false
		end
	end
	-- Check if this is a Fluid --
	if mainProduct.type == "fluid" then
		if recipe.amount ~= nil and self.dataNetwork:hasFluid(mainProduct.name) >= recipe.amount then
			recipe.toManyInInventory = true
		else
			recipe.toManyInInventory = false
		end
	end
end