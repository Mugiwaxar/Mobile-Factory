-- Create the Recipe GUI --
function GUI.createRecipeGUI(player)
	-- Create the GUI
	local GUIObj = GUI.createGUI("RecipeGUI", getMFPlayer(player.name), "vertical")

	-- Create the Menu Bar --
	local topBarFlow = GUIObj:addFlow("", GUIObj.gui, "horizontal")
	topBarFlow.style.vertical_align = "center"
	GUIObj:addLabel("", topBarFlow, {"gui-assembling-machine.choose-recipe"}, _mfOrange, nil, false, "TitleFont")
	GUIObj:addEmptyWidget("", topBarFlow, GUIObj.gui, 20, nil)
	textField = GUIObj:addTextField("RSSearchTextField", topBarFlow, "", {"gui-description.ItemSearchTextTT"}, true, false, false, false, false)
	textField.style.maximal_width = 100
	GUIObj:addButton("RecipeGUICloseButton", topBarFlow, "CloseIcon", "CloseIcon", {"gui-description.closeButton"}, 15)

	-- Cerate Main Frame
	local RSMainFrame = GUIObj:addFrame("RSMainFrame", GUIObj.gui, "vertical")
	RSMainFrame.style = "filter_scroll_pane_background_frame_no_background"

	local RSGroupTable = GUIObj:addTable("RSGroupTable", RSMainFrame, 6)
	RSGroupTable.style = "filter_group_table"

	local RSScrollPane = GUIObj:addScrollPane("RSScrollPane", RSMainFrame, 445)
	RSScrollPane.style.minimal_height = 445
	local RSRecipeFrame = GUIObj:addFrame("RSRecipeFrame", RSScrollPane, "vertical", true)
	RSRecipeFrame.style = "filter_scroll_pane_background_frame"

	-- Split recipes by groups
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
			GUIObj.MFPlayer.ent.request_translation(Util.getLocRecipeName(r.name))
		end
	end

	-- Build indexed array, and sort it
	local groupsArray = {}
	local function rsorter(a, b)
		local firstOrder = a.obj.order or ""
		local secondOrder = b.obj.order or ""

		if firstOrder ~= secondOrder then
			return firstOrder < secondOrder
		else
			return (a.obj.name or "") < (b.obj.name or "")
		end
		--can't reach here
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

	-- Draw Categories
	for idx, group in ipairs(groupsArray) do
		local name = "RSCat," .. idx
		local tab = RSGroupTable.add({type="sprite-button", name=name, style="filter_group_button_tab_selectable"})
		GUIObj[name] = tab
		if idx == 1 then tab.enabled = false end
		tab.tooltip = group.obj.localised_name
		tab.sprite = "item-group/" .. group.obj.name

	end

	GUIObj.sortedRecipes = groupsArray
	GUIObj.selectedCategory = 1
	GUIObj.lastSearch = GUIObj.RSSearchTextField.text

	GUI.doUpdateRecipeGUI(GUIObj)

	-- Center the GUI --
	GUIObj.force_auto_center()

	-- Return the GUI --
	return GUIObj
end



function GUI.updateRecipeGUI(GUIObj)
	--Auto-update can be slow with huge list of recipes. No need to. Nothing changes here without player input.
	if GUIObj.RSSearchTextField.text ~= GUIObj.lastSearch then
		GUIObj.lastSearch = GUIObj.RSSearchTextField.text
		GUI.doUpdateRecipeGUI(GUIObj)
	end
end

function GUI.doUpdateRecipeGUI(GUIObj)
	-- Clear
	GUIObj.RSRecipeFrame.clear()

	local filter = string.lower(GUIObj.lastSearch) or ""
	local tmpLocal = GUIObj.MFPlayer.varTable.tmpLocal
	-- Draw Recipes
	for _, subgroups in ipairs(GUIObj.sortedRecipes[GUIObj.selectedCategory].list) do
		local RSRecipeTable = GUIObj:addTable("", GUIObj.RSRecipeFrame, 10)
		for _, recipe in ipairs(subgroups.list) do
			local name = recipe.obj.name
			-- Check the Filter --
			if filter ~= "" and tmpLocal ~= nil and Util.getLocRecipeName(name)[1] ~= nil then
					local locName = tmpLocal[Util.getLocRecipeName(name)[1]]
					if locName ~= nil and string.match(string.lower(locName), filter) == nil then goto continue end
			end
			local button = RSRecipeTable.add({type="choose-elem-button", elem_type="recipe", name="RSSel,"..name, style="recipe_slot_button"})
			button.elem_value = name
			button.locked = true
			::continue::
		end
	end
end