-- Create the Recipe GUI --
function GUI.createRecipeGUI(player)

	-- Get the MFPlayer --
	local MFPlayer = getMFPlayer(player.name)

	-- Create the GUI --
	local GUITable = GAPI.createBaseWindows(_mfGUIName.RecipeGUI, {"gui-description.RecipeGUITitle"}, MFPlayer, true, true, false, "vertical", "vertical")
	GUITable.gui.style.minimal_height = 100
	GUITable.gui.style.minimal_width = 100
	local mainFrame = GUITable.vars.MainFrame

	-- Add the Search textField --
	local textField = GAPI.addTextField(GUITable, "Rec.GUI.SearchTextField", GUITable.vars.topBarFlow, "", {"gui-description.ItemSearchTextTT"}, true, false, false, false, false)
	textField.style.maximal_width = 100

	-- Add the Close Button --
	GAPI.addCloseButton(GUITable)
	
	local RSGroupTable = GAPI.addTable(GUITable, "RSGroupTable", mainFrame, 6)
	RSGroupTable.style = "filter_group_table"

	local RSScrollPane = GAPI.addScrollPane(GUITable, "RSScrollPane", mainFrame, 445)
	RSScrollPane.style.minimal_height = 445
	local RSRecipeFrame = GAPI.addFrame(GUITable, "RSRecipeFrame", RSScrollPane, "vertical", true)
	RSRecipeFrame.style = "filter_scroll_pane_background_frame"

	-- Split Recipes by groups --
	local recipeTable = {}
	for _, r in pairs(player.force.recipes) do
		if r.enabled == true and r.hidden == false and not global.dataAssemblerBlacklist[r.category] then
			if recipeTable[r.group.name] == nil then
				recipeTable[r.group.name] = {}
			end
			if recipeTable[r.group.name][r.subgroup.name] == nil then
				recipeTable[r.group.name][r.subgroup.name] = {}
			end
			table.insert(recipeTable[r.group.name][r.subgroup.name], {obj=r})
			MFPlayer.ent.request_translation(Util.getLocRecipeName(r.name))
		end
	end

	-- Build indexed array, and sort it --
	local groupsArray = {}
	local function rsorter(a, b)
		local firstOrder = a.obj.order or ""
		local secondOrder = b.obj.order or ""

		if firstOrder ~= secondOrder then
			return firstOrder < secondOrder
		else
			return (a.obj.name or "") < (b.obj.name or "")
		end
		--can't reach here --
	end

	for groupName, subgroups in pairs(recipeTable) do
		local subgroupArray = {}
		for subgroupName, recipes in pairs(subgroups) do
			table.sort(recipes, rsorter)
			table.insert(subgroupArray, {obj=game.item_subgroup_prototypes[subgroupName], list=recipes})
		end
		table.sort(subgroupArray, rsorter)
		table.insert(groupsArray, {obj=game.item_group_prototypes[groupName], list=subgroupArray})
	end
	table.sort(groupsArray, rsorter)

	-- Draw Categories --
	for idx, group in ipairs(groupsArray) do
		local tab = GAPI.addButton(GUITable, "Rec.GUI.CategoryButton" .. idx, RSGroupTable, "item-group/" .. group.obj.name, "item-group/" .. group.obj.name, group.obj.localised_name, nil, true, true, nil, nil, {category=idx})
		tab.style = "filter_group_button_tab_selectable"
		if idx == 1 then tab.enabled = false end

	end

	GUITable.vars.sortedRecipes = groupsArray
	GUITable.vars.selectedCategory = 1
	GUITable.vars.lastSearch = GUITable.vars["Rec.GUI.SearchTextField"].text

	-- Update the GUI --
	GUI.updateMFRecipeGUI(GUITable, true)

	-- Return the GUI --
	return GUITable

end

-- Update the Recipe GUI --
function GUI.updateMFRecipeGUI(GUITable, force)

	-- Update only if the Search Textfield has changed or if forced --
	if GUITable.vars["Rec.GUI.SearchTextField"].text == GUITable.vars.lastSearch and force ~= true then return end

	-- Update the Last Search --
	GUITable.vars.lastSearch = GUITable.vars["Rec.GUI.SearchTextField"].text

	-- Clear the Frame --
	GUITable.vars.RSRecipeFrame.clear()

	-- Stop here if we have nothing to show --
	if #GUITable.vars.sortedRecipes < GUITable.vars.selectedCategory then return end

	-- Get Variables --
	local filter = string.lower(GUITable.vars.lastSearch) or ""
	local tmpLocal = GUITable.vars.tmpLocal

	-- Draw Recipes --
	for _, subgroups in ipairs(GUITable.vars.sortedRecipes[GUITable.vars.selectedCategory].list) do
		local RSRecipeTable = GAPI.addTable(GUITable, "", GUITable.vars.RSRecipeFrame, 10)
		for _, recipe in ipairs(subgroups.list) do
			local name = recipe.obj.name
			-- Check the Filter --
			if filter ~= "" and tmpLocal ~= nil and Util.getLocRecipeName(name)[1] ~= nil then
					local locName = tmpLocal[Util.getLocRecipeName(name)[1]]
					local n = Util.getLocRecipeName(name)[1]
					if locName ~= nil and string.match(string.lower(locName), filter) == nil then goto continue end
			end
			local button = GAPI.addFilter(GUITable, "Rec.GUI.RecipeButton," .. name, RSRecipeTable, nil, true, "recipe", nil, {name=name})
			button.style = "recipe_slot_button"
			button.elem_value = name
			button.locked = true
			::continue::
		end
	end

end

function GUI.recipeGUIInteraction(event, MFPlayer)

	-- Change Category --
	if string.match(event.element.name, "Rec.GUI.CategoryButton") then
		local GUITable = MFPlayer.GUI[_mfGUIName.RecipeGUI]
		local oldCategory = GUITable.vars.selectedCategory or 1
		local category = event.element.tags.category
		GUITable.vars.oldCategory = category
		GUITable.vars["Rec.GUI.CategoryButton" .. oldCategory].enabled = true
		event.element.enabled = false
		GUITable.vars.selectedCategory = category
		GUI.updateMFRecipeGUI(GUITable, true)
		return
	end

	-- Select a Recipe --
	if string.match(event.element.name, "Rec.GUI.RecipeButton") then
		local tGUI = MFPlayer.GUI[_mfGUIName.TooltipGUI]
		if tGUI ~= nil and tGUI.vars.DA ~= nil then
			tGUI.vars["D.A.RecipeFilter"].elem_value = event.element.tags.name
		end
		MFPlayer.GUI[_mfGUIName.RecipeGUI].gui.destroy()
		MFPlayer.GUI[_mfGUIName.RecipeGUI] = nil
		GUI.updateAllGUIs(true)
		return
	end

	-- Search Text changed (Used to Update all GUIs) --
	if string.match(event.element.name, "Rec.GUI.SearchTextField") then
		return
	end

end