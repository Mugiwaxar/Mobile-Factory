-- DATA ASSEMBLER OBJECT --

-- Create the Data Assembler base object --
DA = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	stateSprite = 0,
	active = false,
	consumption = _mfDAQuatronDrainPerUpdate,
	updateTick = 5,
	completeUpdateTick = 60,
	lastUpdate = 0,
	lastCompleteUpdate = 0,
	dataNetwork = nil,
	networkAccessPoint = nil,
	recipeID = 0,
	recipeTable = nil, -- [id]{recipePrototype, sprite, progress, paused, ingredients{name, type, amount, sprite, missing, tooltip}, products{name, type, amount, max, probability, sprite, tooltip, toManyInInventory}, missingIngredient, inventoryFull, toManyInInventory}
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
	t.dataNetwork = t.MF.dataNetwork
	t.recipeTable = {}
	-- Draw the state Sprite --
	t.stateSprite = rendering.draw_sprite{sprite="DataAssemblerSprite1", target=object, surface=object.surface, render_layer=131}
	UpSys.addObj(t)
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
	-- Remove from the Network Access Point --
	if self.networkAccessPoint ~= nil and self.ent ~= nil and self.ent.valid == true then
		self.networkAccessPoint.objTable[self.ent.unit_number] = nil
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
				-- Check if the Recipe still exist --
				if recipe.recipePrototype.valid == false then
					self.recipeTable[k] = nil
					return
				end
				self:updateRecipe(recipe, k)
			end
			i = i + 1
		end
		self.lastRecipeUpdatedID = self.lastRecipeUpdatedID + 1
	end
	
	-- Stop the express Update --
	if game.tick - self.lastCompleteUpdate < self.completeUpdateTick then return end
	self.lastCompleteUpdate = game.tick

    -- Try to find a Network Access Point if needed --
	if valid(self.networkAccessPoint) == false or self.dataNetwork ~= self.networkAccessPoint.dataNetwork then
		self.networkAccessPoint = self.dataNetwork:getCloserNAP(self)
		if self.networkAccessPoint ~= nil then
			self.networkAccessPoint.objTable[self.ent.unit_number] = self
		end
	end

	-- Set Active or Not --
	if self.networkAccessPoint ~= nil and self.networkAccessPoint.quatronCharge > 0 then
		self:setActive(true)
	else
		self:setActive(false)
	end

    -- Stop if not active --
	if self.active == false then return end

	if self.quatronCharge <= 15 and self.networkAccessPoint ~= nil then
		local chargeToBorrow = math.min(self.networkAccessPoint.quatronCharge, 100 - self.quatronCharge)
		if chargeToBorrow > 0 then
			self:addQuatron(chargeToBorrow, self.networkAccessPoint.quatronLevel)
			self.networkAccessPoint:removeQuatron(chargeToBorrow)
		end
	end
end

-- Tooltip Infos --
function DA:getTooltipInfos(GUITable, mainFrame, justCreated)

	-- Create the Data Network Frame --
	DN.addDataNetworkFrame(GUITable, mainFrame, self, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.DataAssembler"}

		-- Add the Data Assembler to the GUI --
		GUITable.vars.DA = self

		-- Add the Assembler Frame --
		local assemblerFrame = GAPI.addFrame(GUITable, "AssemblerFrame", mainFrame, "vertical", true)
		assemblerFrame.style = "MFFrame1"
		assemblerFrame.style.vertically_stretchable = true
		assemblerFrame.style.left_padding = 3
		assemblerFrame.style.right_padding = 3
		assemblerFrame.style.left_margin = 3
		assemblerFrame.style.right_margin = 3

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", assemblerFrame, {"gui-description.Assembler"})

		-- Add the ScrollPane --
		local assemblerScrollPane = GAPI.addScrollPane(GUITable, "", assemblerFrame)
		assemblerScrollPane.style = "MF_DA_scroll_pan"
		assemblerScrollPane.style.minimal_height = 450
		assemblerScrollPane.style.minimal_width = 230
		assemblerScrollPane.style.vertically_stretchable = true
		assemblerScrollPane.style.bottom_margin = 3

		-- Add the Recipe Table --
		GAPI.addTable(GUITable, "DARecipeTable", assemblerScrollPane, 1, true)

		-- Create the Information Frame --
		local infoFrame = GAPI.addFrame(GUITable, "InformationFrame", mainFrame, "vertical", true)
		infoFrame.style = "MFFrame1"
		infoFrame.style.vertically_stretchable = true
		infoFrame.style.left_padding = 3
		infoFrame.style.right_padding = 3

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", infoFrame, {"gui-description.Information"})

		-- Create the Add Recipe Label --
		GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.AddRecipeLabel"}, nil, nil, false, nil, _mfLabelType.yellowTitle )

		-- Create the Add Recipe Flow --
		local addRFlow = GAPI.addFlow(GUITable, "", infoFrame, "horizontal", false)
		addRFlow.style.bottom_padding = 10

		-- Create the Recipe selector --
		local recipeSelector = GAPI.addFilter(GUITable, "D.A.RecipeFilter", addRFlow, {"gui-description.AddRecipeFilterTT"}, true, "recipe", 28)
		recipeSelector.locked = not global.useVanillaChooseElem

		-- Create the Add Recipe Button --
		GAPI.addButton(GUITable, "D.A.AddRecipeButton," .. self.entID, addRFlow, "PlusIcon", "PlusIcon", {"gui-description.AddRecipeButtonTT"}, 28)

		-- Create the Information FLow --
		GAPI.addFlow(GUITable, "InformatioFLow", infoFrame, "vertical", true)

		-- Add the Line --
		GAPI.addLine(GUITable, "", infoFrame, "horizontal")

		-- Add the help Label --
		GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.DataAssemblerHelp1"}, _mfWhite)
		GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.DataAssemblerHelp2"}, _mfWhite)
		GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.DataAssemblerHelp3"}, _mfWhite)

	end

	-- Get the Information Flow --
	local infoFlow = GUITable.vars.InformatioFLow

	-- Clear the Flow --
	infoFlow.clear()

	-- Create the Quatron Charge Dual Label --
	GAPI.addLabel(GUITable,"", infoFlow, {"gui-description.QuatronCharge", math.floor(self.quatronCharge)}, _mfOrange)

	-- Create the Quatron level Dual Label --
	GAPI.addLabel(GUITable,"", infoFlow, {"gui-description.Quatronlevel", string.format("%.3f", self.quatronLevel)}, _mfOrange)

	-- Get the Recipe Table --
	local DARecipeTable = GUITable.vars.DARecipeTable

	-- Clear the Table --
	DARecipeTable.clear()

	-- Create all Recipes Frame --
	for k, recipe in pairs(self.recipeTable) do
		self:createFrame(GUITable, DARecipeTable, recipe, k)
	end

	-- Update the Recipe Information GUI --
	self:updateInfoRecipeWindow(GUITable)
	
end

-- Create a Recipe Frame --
function DA:createFrame(GUITable, recipeTable, recipe, recipeID)

	-- Create the Frame --
	local frame = GAPI.addFrame(GUITable, "", recipeTable, "horizontal")
	frame.style.horizontal_align = "left"

	-- Create the Recipe Icon --
	local recipeButton = GAPI.addButton(GUITable, "D.A.RecipeButton," .. self.entID .. "," .. recipeID, frame, recipe.sprite, recipe.sprite, {"", "[color=blue]", recipe.recipePrototype.localised_name, "[/color]"}, 50, false, true)
	recipeButton.style = DA.isProcessing(recipe) == true and "MF_Fake_Button_Green" or "MF_Fake_Button_Red"

	-- Create the Info Table --
	local infoTable = GAPI.addTable(GUITable, "", frame, 1)

	-- Create the Name Flow --
	local nameFlow = GAPI.addFlow(GUITable, "", infoTable, "horizontal")

	-- Create the Recipe Name Label --
	GAPI.addLabel(GUITable, "", nameFlow, recipe.recipePrototype.localised_name, nil, "", false, nil, _mfLabelType.yellowTitle)

	-- Create the Information Button Flow --
	local infoButtonFlow = GAPI.addFlow(GUITable, "", nameFlow, "horizontal")
	infoButtonFlow.style.horizontally_stretchable = true
	infoButtonFlow.style.horizontal_align = "right"

	-- Add the Information Button --
	local infoButton = GAPI.addButton(GUITable, "D.A.RecipeInfoButton," .. self.entID .. "," .. recipeID, infoButtonFlow, "MFIconI", "MFIconI", {"gui-description.DAInfoButton"}, 20, false, true, nil, "frame_action_button")
	infoButton.style.left_margin = 25

	-- Create the Recipe Processing Label --
	local processingText = DA.isProcessing(recipe) and {"gui-description.Running"} or {"gui-description.Stopped"}
	local color = DA.isProcessing(recipe) and _mfGreen or _mfYellow
	GAPI.addLabel(GUITable, "", infoTable, processingText, color)

	-- Create the Progress Bar --
	local barColor = ((self.quatronCharge > 0 and self.active == true) and _mfGreen) or _mfRed
	local PBar = GAPI.addProgressBar(GUITable, "", infoTable, "", "", false, barColor, recipe.progress / recipe.recipePrototype.energy)
	PBar.style.horizontally_stretchable = true
	if GUITable.vars.PBarsTable == nil then GUITable.vars.PBarsTable = {} end
	GUITable.vars.PBarsTable[PBar] = recipe

end

-- Create the Recipe Information Window --
function DA:createInfoRecipeWindow(MFPlayer, recipeID, recipeTable)

	-- Check the Recipe --
	local recipe = recipeID ~= nil and self.recipeTable[recipeID] or recipeTable
	if recipe == nil then return end

	-- Create the GUI --
	MFPlayer.GUI[_mfGUIName.RecipeInfoGUI] = GAPI.createBaseWindows(_mfGUIName.RecipeInfoGUI, recipe.recipePrototype.localised_name, MFPlayer)
	local GUITable = MFPlayer.GUI[_mfGUIName.RecipeInfoGUI]
	GUITable.vars.recipe = recipe

	-- Add the close Button --
	GAPI.addCloseButton(GUITable)

	-- Check if this is a new Recipe --
	if recipeTable ~= nil then GUITable.vars.newRecipe = true end

	-- Get the Main Frame and Set the style --
	local mainFrame = GUITable.vars.MainFrame
	mainFrame.style = "MFFrame1"
	mainFrame.style.minimal_height = 500
	mainFrame.style.padding = 3

	-- Create the Recipe Information Flow --
	local RInfoFlow = GAPI.addFlow(GUITable, "RecipeInfoFlow", mainFrame, "horizontal", true)

	-- Create the Ingredients Flow --
	local ingredientsFlow = GAPI.addFlow(GUITable, "IngredientsFlow", RInfoFlow, "vertical", true)
	ingredientsFlow.style.minimal_width = 200
	ingredientsFlow.style.vertically_stretchable = true
	ingredientsFlow.style.horizontal_align = "center"
	
	-- Add the Title --
	GAPI.addSubtitle(GUITable, "", ingredientsFlow, {"gui-description.DARIIngredients"})

	-- Create the Ingredients Table --
	local ingredientsTable = GAPI.addTable(GUITable, "IngredientsTable", ingredientsFlow, 5, true)

	-- Add all Ingredients --
	for _, ingredient in pairs(recipe.ingredients) do
		local storedAmount = (ingredient.type == "item" and self.dataNetwork:hasItem(ingredient.name)) or self.dataNetwork:hasFluid(ingredient.name)
		local color = ingredient.type == "item" and "[color=blue]" or "[color=purple]"
		local text = {"", color, ingredient.tooltip, "[/color]\n", {"gui-description.DARIAvailable"}, "[color=yellow] ", Util.toRNumber(storedAmount or 0), "[/color]"}
		local ingredientButton = GAPI.addButton(GUITable, "IngredientButton," .. ingredient.name, ingredientsTable, ingredient.sprite, ingredient.sprite, text, 35, true, true, ingredient.amount)
		ingredientButton.style = ingredient.missing == true and "MF_Fake_Button_Red" or "MF_Fake_Button_Green"
		ingredientButton.style.margin = 2
	end

	-- Add the Line --
	GAPI.addLine(GUITable, "", RInfoFlow, "vertical")

	-- Create the Information Flow --
	local infoFlow = GAPI.addFlow(GUITable, "InfoFlow", RInfoFlow, "vertical", true)
	infoFlow.style.minimal_width = 300
	infoFlow.style.vertically_stretchable = true

	-- Add the Title --
	GAPI.addSubtitle(GUITable, "", infoFlow, {"gui-description.DARInformation"})

	-- Create the Recipe Icon Flow --
	local recipeIconFlow = GAPI.addFlow(GUITable, "", infoFlow)
	recipeIconFlow.style.horizontal_align = "center"

	-- Add the Recipe Icon --
	local recipeButton = GAPI.addButton(GUITable, "RecipeIcon", recipeIconFlow, recipe.sprite, recipe.sprite, { "", "[color=blue]", recipe.recipePrototype.localised_name, "[/color]"}, 65, true)
	recipeButton.style = DA.isProcessing(recipe) == true and "MF_Fake_Button_Green" or "MF_Fake_Button_Red"

	-- Create the Information Table --
	GAPI.addTable(GUITable, "InformationTable", infoFlow, 1, true)

	-- Add the Line --
	GAPI.addLine(GUITable, "", RInfoFlow, "vertical")

	-- Create the Results Flow --
	local resultsFlow = GAPI.addFlow(GUITable, "ResultsFlow", RInfoFlow, "vertical", true)
	resultsFlow.style.minimal_width = 200
	resultsFlow.style.vertically_stretchable = true
	resultsFlow.style.horizontal_align = "center"

	-- Add the Title --
	GAPI.addSubtitle(GUITable, "", resultsFlow, {"gui-description.DARIResults"})

	-- Create the Results Table --
	local resultsTable = GAPI.addTable(GUITable, "ResultsTable", resultsFlow, 1, true)

	-- Add all Results --
	for _, product in pairs(recipe.products) do
		local resultTable = GAPI.addTable(GUITable, "", resultsTable, 2)
		local storedAmount = product.type == "item" and self.dataNetwork:hasItem(product.name) or self.dataNetwork:hasFluid(product.name)
		local color = product.type == "item" and "[color=blue]" or "[color=purple]"
		local text = {"", color, product.tooltip, "[/color]\n", {"gui-description.DARIAvailable"}, "[color=yellow] ", Util.toRNumber(storedAmount or 0), "[/color]\n", {"gui-description.Maximum"}, " [color=yellow]", product.max or {"gui-description.Unlimited"}, "[/color]"}
		local productButton = GAPI.addButton(GUITable, "ProductButton," .. product.name, resultTable, product.sprite, product.sprite, text, 35, true, true, product.amount)
		productButton.style = product.toManyInInventory == true and "MF_Fake_Button_Red" or "MF_Fake_Button_Green"
		productButton.style.margin = 2
		local textField = GAPI.addTextField(GUITable, "DARIMaxTextField" .. product.name, resultTable, product.max, {"gui-description.DARIMaxiumAmountTT"}, true, true, false, false, false)
		textField.style.maximal_width = 150
	end

	-- Create the Buttons Frame and Flow --
	local buttonsFrame = GAPI.addFrame(GUITable, "", mainFrame, "horizontal")
	buttonsFrame.style = "MFFrame1"
	buttonsFrame.style.top_padding = 2
	local buttonFlow = GAPI.addFlow(GUITable, "", buttonsFrame, "horizontal")
	buttonFlow.style.horizontal_align = "center"

	-- Create the Buttons --
	if recipeID ~= nil then
		GAPI.addSimpleButton(GUITable, "D.A.RIRemoveRecipe," .. self.entID .. "," .. (recipeID or 0), buttonFlow, {"gui-description.Remove"})
		GUITable.vars.pauseButton = GAPI.addSimpleButton(GUITable, "D.A.RIPauseResumeRecipe," .. self.entID .. "," .. (recipeID or 0), buttonFlow, recipe.paused == true and {"gui-description.Resume"} or {"gui-description.Pause"})
		GAPI.addSimpleButton(GUITable, "D.A.RIChangeRecipe," .. self.entID .. "," .. (recipeID or 0), buttonFlow, {"gui-description.Confirm"})
	else
		GAPI.addSimpleButton(GUITable, "D.A.RIAddRecipe," .. self.entID .. "," .. (recipeID or 0), buttonFlow, {"gui-description.Confirm"})
	end

	-- Save the Recipe Table --
	if recipeTable ~= nil then GUITable.vars.recipeTable = recipeTable end

	--Return the Table --
	return GUITable

end

function DA:updateInfoRecipeWindow(DAGUITable)
	
	-- Check if the Window can be Updated --
	if DAGUITable.MFPlayer.GUI[_mfGUIName.RecipeInfoGUI] == nil or DAGUITable.MFPlayer.GUI[_mfGUIName.RecipeInfoGUI].gui == nil or DAGUITable.MFPlayer.GUI[_mfGUIName.RecipeInfoGUI].gui.valid == false then return end

	-- Get the Variables --
	local GUITable = DAGUITable.MFPlayer.GUI[_mfGUIName.RecipeInfoGUI]
	local recipe = GUITable.vars.recipe
	local informationTable = GUITable.vars.InformationTable

	-- Clear all Tables --
	informationTable.clear()

	-- Update the Ingredients Buttons --
	for _, ingredient in pairs(recipe.ingredients) do
		local storedAmount = (ingredient.type == "item" and self.dataNetwork:hasItem(ingredient.name)) or self.dataNetwork:hasFluid(ingredient.name)
		local color = ingredient.type == "item" and "[color=blue]" or "[color=purple]"
		local text = {"", color, ingredient.tooltip, "[/color]\n", {"gui-description.DARIAvailable"}, "[color=yellow] ", Util.toRNumber(storedAmount or 0), "[/color]"}
		local button = GUITable.vars["IngredientButton," .. ingredient.name]
		button.tooltip = text
		button.style = ingredient.missing == true and "MF_Fake_Button_Red" or "MF_Fake_Button_Green"
		button.style.margin = 2
	end

	-- Update the Recipe Icon --
	local recipeButton = GUITable.vars.RecipeIcon
	recipeButton.style = DA.isProcessing(recipe) == true and "MF_Fake_Button_Green" or "MF_Fake_Button_Red"

	-- Create the Recipe Name Label --
	GAPI.addLabel(GUITable, "", informationTable, {"", {"gui-description.Recipe"}, " [color=yellow]", recipe.recipePrototype.localised_name, "[/color]"}, _mfOrange)

	-- Create the Recipe Pause Label --
	local pausedText = recipe.paused == true and {"gui-description.Yes"} or {"gui-description.No"}
	GAPI.addLabel(GUITable, "", informationTable, {"", {"gui-description.Paused"}, ": [color=yellow]", pausedText, "[/color]"}, _mfOrange)

	-- Create the Ingredients missing Label --
	local missingText = recipe.missingIngredient == true and {"gui-description.Yes"} or {"gui-description.No"}
	GAPI.addLabel(GUITable, "", informationTable, {"", {"gui-description.DARIMissingIngredients"}, " [color=yellow]", missingText, "[/color]"}, _mfOrange)

	-- Create the Space missing Missing Label --
	local spaceText = recipe.inventoryFull == true and {"gui-description.Yes"} or {"gui-description.No"}
	GAPI.addLabel(GUITable, "", informationTable, {"", {"gui-description.DARISpaceMissing"}, " [color=yellow]", spaceText, "[/color]"}, _mfOrange)

	-- Create the Ingredients Missing Label --
	local maxText = recipe.toManyInInventory == true and {"gui-description.Yes"} or {"gui-description.No"}
	GAPI.addLabel(GUITable, "", informationTable, {"", {"gui-description.DARIMaxReached"}, " [color=yellow]", maxText, "[/color]"}, _mfOrange)

	-- Update the Result Buttons --
	for _, product in pairs(recipe.products) do
		local storedAmount = product.type == "item" and self.dataNetwork:hasItem(product.name) or self.dataNetwork:hasFluid(product.name)
		local color = product.type == "item" and "[color=blue]" or "[color=purple]"
		local text = {"", color, product.tooltip, "[/color]\n", {"gui-description.DARIAvailable"}, "[color=yellow] ", Util.toRNumber(storedAmount or 0), "[/color]\n", {"gui-description.Maximum"}, " [color=yellow]", product.max or {"gui-description.Unlimited"}, "[/color]"}
		local button = GUITable.vars["ProductButton," .. product.name]
		button.tooltip = text
		button.style = product.toManyInInventory == true and "MF_Fake_Button_Red" or "MF_Fake_Button_Green"
		button.style.margin = 2
	end

	-- Update the Pause Button --
	if GUITable.vars.pauseButton ~= nil then
		GUITable.vars.pauseButton.caption = recipe.paused == true and {"gui-description.Resume"} or {"gui-description.Pause"}
	end

end

-- Update all Progress Bars --
function DA:updatePBars(GUIObj)
	local barColor = ((self.quatronCharge > 0 and self.active == true) and _mfGreen) or _mfRed
	for PBar, recipe in pairs(GUIObj.vars.PBarsTable or {}) do
		if valid(PBar) == true and recipe ~= nil then
			PBar.value = recipe.progress / recipe.recipePrototype.energy
			PBar.style.color = barColor
		end
	end
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

-- Get the next Recipe ID --
function DA:getID()
	self.recipeID = self.recipeID + 1
	return self.recipeID
end

-- Add a recipe to the Recipe list --
function DA:addRecipe(name)

	-- Check the Values --
	if name == nil then return false end
	
	-- Check the Recipe --
	local recipePrototype = game.recipe_prototypes[name]
	if recipePrototype == nil then return false end

	if self.ent.force.recipes[name] == nil or not self.ent.force.recipes[name].enabled or global.dataAssemblerBlacklist[recipePrototype.category] then
		local player = getPlayer(self.player)
		player.print({"", {"gui-description.DAWrongRecipe"}})
		return false
	end

	-- Create the Ingredients Table --
	local ingredientsTable = {}
	for _, ingredient in pairs(recipePrototype.ingredients) do
		if game.item_prototypes[ingredient.name] ~= nil then
			table.insert(ingredientsTable, {name=ingredient.name, type=ingredient.type, amount=ingredient.amount, sprite="item/" .. ingredient.name, tooltip=game.item_prototypes[ingredient.name].localised_name})
		elseif game.fluid_prototypes[ingredient.name] ~= nil then
			table.insert(ingredientsTable, {name=ingredient.name, type=ingredient.type, amount=ingredient.amount, sprite="fluid/" .. ingredient.name, tooltip=game.fluid_prototypes[ingredient.name].localised_name})
		else
			return false
		end
	end

	-- Get all Products
	local products = {}
	for _, product in ipairs(recipePrototype.products) do
		if game.item_prototypes[product.name] ~= nil then
			table.insert(products, {name=product.name, type=product.type, amount=product.amount, probability = product.probability or 1,sprite="item/" .. product.name, tooltip=game.item_prototypes[product.name].localised_name})
		elseif game.fluid_prototypes[product.name] ~= nil then
			table.insert(products, {name=product.name, type=product.type, amount=product.amount, probability = product.probability or 1, sprite="fluid/" .. product.name, tooltip=game.fluid_prototypes[product.name].localised_name})
		else
			return false
		end
	end
	if #products == 0 then return end

	-- Create the Recipe Table --
	local recipeTable = {recipePrototype=recipePrototype, sprite="recipe/" .. recipePrototype.name, progress=0, ingredients=ingredientsTable, products=products}

	-- Check all ingredients --
	self:getIngredients(recipeTable, true)

	-- Create the Information Recipe Windows --
	self:createInfoRecipeWindow(getMFPlayer(self.player), nil, recipeTable)

end

-- Confirm a Recipe (Recipe Information GUI Confirm Button) --
function DA:confirmRecipe(MFPlayer)

	-- Check the Recipe Information GUI -
	if MFPlayer.GUI[_mfGUIName.RecipeInfoGUI] == nil or MFPlayer.GUI[_mfGUIName.RecipeInfoGUI].gui == nil or MFPlayer.GUI[_mfGUIName.RecipeInfoGUI].gui.valid == false then return end

	-- Get the GUITable --
	local GUITable = MFPlayer.GUI[_mfGUIName.RecipeInfoGUI]
	if GUITable == nil then return end

	-- Get the Recipe --
	local recipe = GUITable.vars.recipe
	if recipe == nil then return end

	-- Set all Maximum --
	for _, product in pairs(recipe.products) do
		local textField = GUITable.vars["DARIMaxTextField" .. product.name]
		product.max = tonumber(textField.text)
	end

	-- Get all ingredients --
	self:getIngredients(recipe, true)

	-- Add the Recipe --
	self.recipeTable[self:getID()] = recipe

	-- Check if the recipe must be done --
	self:toManyInInventory(recipe)

end

-- Remove a Recipe --
function DA:removeRecipe(id)
	if id == nil then return end
	self.recipeTable[id] = nil
end

-- Update a Recipe --
function DA:updateRecipe(recipe, id)
	-- Check if the Recipe has terminated --
	if recipe.progress >= recipe.recipePrototype.energy then
		-- Send products to the Data Network --
		for _, product in ipairs(recipe.products) do
			-- It probably can lose some subroducts when suddenly run out of room to store it, but that's still much better than sending all of them directly to /dev/null
			if (product.type == "item" and not self.dataNetwork:canAcceptItem(product.name, product.amount)) or
			   (product.type == "fluid" and not self.dataNetwork:canAcceptFluid(product.name, product.amount)) then
				recipe.inventoryFull = true
				return
			end
		end
		for _, product in ipairs(recipe.products) do
			if product.probability == 1 or product.probability > math.random() then
				if product.type == "item" then
					self.dataNetwork:addItems(product.name, product.amount)
					self.ent.force.item_production_statistics.on_flow(product.name, product.amount)
				end
				if product.type == "fluid" then
					self.dataNetwork:addFluid(product.name, product.amount, 15)
					self.ent.force.fluid_production_statistics.on_flow(product.name, product.amount)
				end
			end
		end
		recipe.inventoryFull = false
		recipe.progress = recipe.progress - recipe.recipePrototype.energy
		recipe.missingIngredient = true
	end

	-- Check if the recipe must be done --
	if recipe.paused == true then return end
	self:toManyInInventory(recipe, id)
	if recipe.toManyInInventory == true then return end

	-- Check if the Recipe need Ingredients --
	if recipe.missingIngredient == true then
		self:getIngredients(recipe)
	end

	-- Check if the Recipe can be processed --
	if recipe.missingIngredient == true or recipe.progress >= recipe.recipePrototype.energy or self.quatronCharge <= 0 then return end

	-- Process the Recipe --
	self:processRecipe(recipe)

end

-- Process a Recip --
function DA:processRecipe(recipe)
	recipe.progress = recipe.progress + (1/12 * math.pow(self.quatronLevel, _mfQuatronScalePower) / 4)
	self.quatronCharge = self.quatronCharge - 1/12
	if self.quatronCharge < 0 then self.quatronCharge = 0 end
end

-- Check if the Recipe can get all Ingredients --
function DA:getIngredients(recipe, justCheck)

	-- Check the Ingredients list --
	local missingIngredients = false
	for _, ingredient in pairs(recipe.ingredients) do
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

	if justCheck == true then return end

	-- Take all Ingredients --
	if missingIngredients == false then
		for _, ingredient in pairs(recipe.ingredients) do
			if ingredient.type == "item" then
				self.dataNetwork:getItem(ingredient.name, ingredient.amount)
				self.ent.force.item_production_statistics.on_flow(ingredient.name, ingredient.amount * -1)
			elseif ingredient.type == "fluid" then
				self.dataNetwork:getFluid(ingredient.name, ingredient.amount)
				self.ent.force.fluid_production_statistics.on_flow(ingredient.name, ingredient.amount * -1)
			end
		end
	end

end

-- Check if the Recipe must be done --
function DA:toManyInInventory(recipe)
	-- Check all Products --
	local maxIngredientReached = false
	for _, product in pairs(recipe.products) do
		-- Check if the Product is unlimited --
		if product.max ~= nil and product.max ~= 0 then
			-- If this is a Item --
			if product.type == "item" then
				-- Check the Data Network --
				if self.dataNetwork:hasItem(product.name) >= product.max then
					product.toManyInInventory = true
					maxIngredientReached = true
				else
					product.toManyInInventory = false
				end
			end
			-- if this is a Fluid --
			if product.type == "fluid" then
				-- Check the Data Network --
				if self.dataNetwork:hasFluid(product.name) >= product.max then
					product.toManyInInventory = true
					maxIngredientReached = true
				else
					product.toManyInInventory = false
				end
			end
		else
			product.toManyInInventory = false
		end
	end
	recipe.toManyInInventory = maxIngredientReached
end

-- Settings To Blueprint Tags --
function DA:settingsToBlueprintTags()
	local tags = {}
	local recipes = {}
	-- We need to store order of products, as it can be changed
	for _, recipe in pairs(self.recipeTable) do
		local recipeSettings = { name = recipe.recipePrototype.name, amount = recipe.amount, productsOrder = {}}
		for _, product in pairs(recipe.products) do
			table.insert(recipeSettings.productsOrder, product.name)
		end
		table.insert(recipes, recipeSettings)
	end
	tags["recipes"] = recipes
	return tags
end

-- Blueprint Tags To Settings --
function DA:blueprintTagsToSettings(tags)
	self.recipeTable = {}
	for _, recipe in pairs(tags["recipes"] or {}) do
		if self:addRecipe(recipe.name, recipe.amount) then
			local products = self.recipeTable[self.recipeID].products
			local sortedProducts = {}
			for _, name in pairs(recipe.productsOrder) do
				for idx, product in pairs(products) do
					if product.name == name then
						table.insert(sortedProducts, product)
						products[idx] = nil
						break
					end
				end
			end
			for _, product in pairs(products) do
				table.insert(sortedProducts, product)
			end
			self.recipeTable[self.recipeID].products = sortedProducts
		end
	end
end

-- Add Quatron (Return the amount added) --
function DA:addQuatron(amount, level)
	if self.quatronCharge > 0 then
		mixQuatron(self, amount, level)
	else
		self.quatronCharge = amount
		self.quatronLevel = level
	end
	return amount
end

-- Check stored data, and remove invalid record
function DA:validate()
	-- Check recipes --
	for k, recipe in pairs(self.recipeTable) do
		-- If recipe was changed or removed --
		if recipe.recipePrototype.valid == false then
			self.recipeTable[k] = nil
		end
		-- No need to check ingredients and products, game won't load with broken recipe. When recipe itself valid - all associated items also valid
	end
end

-- Return true if a Recipe is processing --
function DA.isProcessing(recipe)
	if recipe.paused == true then
		return false
	end
	if recipe.missingIngredient == true then
		return false
	end
	if recipe.inventoryFull == true then
		return false
	end
	if recipe.toManyInInventory == true then
		return false
	end
	return true
end

-- Called if the Player interacted with the GUI --
function DA.interaction(event, MFPlayer)

	-- Select Recipe --
	if event.element.name == "D.A.RecipeFilter" and global.useVanillaChooseElem == false then
		if MFPlayer.GUI[_mfGUIName.RecipeGUI] ~= nil then
			MFPlayer.GUI[_mfGUIName.RecipeGUI].destroy()
			MFPlayer.GUI[_mfGUIName.RecipeGUI] = nil
		end
		local GUITable = GUI.createRecipeGUI(MFPlayer.ent)
		MFPlayer.GUI[_mfGUIName.RecipeGUI] = GUITable
		return
	end

	-- Add a Recipe --
	if string.match(event.element.name, "D.A.AddRecipeButton") then
		local GUITable = MFPlayer.GUI["MFTooltipGUI"]
		local objID = tonumber(split(event.element.name, ",")[2])
		local obj = global.dataAssemblerTable[objID]
		if valid(obj) == false then return end
		local recipe = GUITable.vars["D.A.RecipeFilter"].elem_value
		GUITable.vars["D.A.RecipeFilter"].elem_value = nil
		obj:addRecipe(recipe)
		GUI.updateAllGUIs(true)
		return
	end

	-- Remove a Recipe - Tooltip GUI --
	if string.match(event.element.name, "D.A.RecipeButton") and event.button == defines.mouse_button_type.right then
		local objID = tonumber(split(event.element.name, ",")[2])
		local obj = global.dataAssemblerTable[objID]
		local recipeID = tonumber(split(event.element.name, ",")[3])
		if valid(obj) == false then return end
		obj:removeRecipe(recipeID)
		GUI.updateAllGUIs(true)
		return
	end

	-- Open the Recipe Information GUI --
	if string.match(event.element.name, "D.A.RecipeInfoButton") then
		local objID = tonumber(split(event.element.name, ",")[2])
		local obj = global.dataAssemblerTable[objID]
		local recipeID = tonumber(split(event.element.name, ",")[3])
		if valid(obj) == false then return end
		obj:createInfoRecipeWindow(MFPlayer, recipeID)
		GUI.updateAllGUIs(true)
		return
	end

	-- Remove a Recipe - Recipe Information GUI --
	if string.match(event.element.name, "D.A.RIRemoveRecipe") then
		local objID = tonumber(split(event.element.name, ",")[2])
		local obj = global.dataAssemblerTable[objID]
		local recipeID = tonumber(split(event.element.name, ",")[3])
		if valid(obj) == false or recipeID == nil or recipeID == 0 then return end
		obj:removeRecipe(recipeID)
		MFPlayer.GUI[_mfGUIName.RecipeInfoGUI].gui.destroy()
		MFPlayer.GUI[_mfGUIName.RecipeInfoGUI] = nil
		GUI.updateAllGUIs(true)
		return
	end

	-- Pause a Recipe --
	if string.match(event.element.name, "D.A.RIPauseResumeRecipe") then
		local objID = tonumber(split(event.element.name, ",")[2])
		local obj = global.dataAssemblerTable[objID]
		local recipeID = tonumber(split(event.element.name, ",")[3])
		if valid(obj) == false or recipeID == nil or recipeID == 0 then return end
		if obj.recipeTable[recipeID].paused == true then
			obj.recipeTable[recipeID].paused = false
		else
			obj.recipeTable[recipeID].paused = true
		end
		GUI.updateAllGUIs(true)
		return
	end

	-- Confirm a Recipe - Change --
	if string.match(event.element.name, "D.A.RIChangeRecipe") then
		local objID = tonumber(split(event.element.name, ",")[2])
		local obj = global.dataAssemblerTable[objID]
		local recipeID = tonumber(split(event.element.name, ",")[3])
		if valid(obj) == false or recipeID == nil or recipeID == 0 then return end
		local GUITable = MFPlayer.GUI[_mfGUIName.RecipeInfoGUI]
		for _, product in pairs(obj.recipeTable[recipeID].products) do
			local textField = GUITable.vars["DARIMaxTextField" .. product.name]
			product.max = tonumber(textField.text)
		end
		MFPlayer.GUI[_mfGUIName.RecipeInfoGUI].gui.destroy()
		MFPlayer.GUI[_mfGUIName.RecipeInfoGUI] = nil
		return
	end

	-- Confirm a Recipe - Add --
	if string.match(event.element.name, "D.A.RIAddRecipe") then
		local objID = tonumber(split(event.element.name, ",")[2])
		local obj = global.dataAssemblerTable[objID]
		obj:confirmRecipe(MFPlayer)
		MFPlayer.GUI[_mfGUIName.RecipeInfoGUI].gui.destroy()
		MFPlayer.GUI[_mfGUIName.RecipeInfoGUI] = nil
		return
	end

end