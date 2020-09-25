-- Create the Recipe GUI --
function GUI.createRecipeGUI(player)
	-- Create the GUI
	local GUIObj = GUI.createGUI("RecipeGUI", getMFPlayer(player.name), "vertical")

	GUI.createTopBar(GUIObj, nil, {"gui-assembling-machine.choose-recipe"})

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
		if r.enabled == true and r.hidden == false then
			if recipeTable[r.group.name] == nil then
				recipeTable[r.group.name] = {}
			end
			if recipeTable[r.group.name][r.subgroup.name] == nil then
				recipeTable[r.group.name][r.subgroup.name] = {}
			end
			table.insert(recipeTable[r.group.name][r.subgroup.name], {obj=r})
		end
	end

	-- Build indexed array, and sort it
	local groupsArray = {}
	for groupName, subgroups in pairs(recipeTable) do
		local subgroupArray = {}
		for subgroupName, recipes in pairs(subgroups) do
			table.sort(recipes, lexicSorter)
			table.insert(subgroupArray, {obj=game.item_subgroup_prototypes[subgroupName], list=recipes})
		end
	  table.sort(subgroupArray, lexicSorter)
		table.insert(groupsArray, {obj=game.item_group_prototypes[groupName], list=subgroupArray})
	end
	table.sort(groupsArray, lexicSorter)

	-- Draw Categories
	for idx, group in ipairs(groupsArray) do
		local name = "RSCat," .. idx
		local g = RSGroupTable.add({type="sprite-button", name=name, style="filter_group_button_tab"})
		GUIObj[name] = g
		if idx == 1 then g.enabled = false end
		g.tooltip = group.obj.localised_name
		g.sprite = "item-group/" .. group.obj.name
	end

	GUIObj.sortedRecipes = groupsArray
	GUIObj.selectedCategory = 1

	GUI.doUpdateRecipeGUI(GUIObj)

	-- Center the GUI --
	GUIObj.force_auto_center()

	-- Return the GUI --
	return GUIObj
end



function GUI.updateRecipeGUI(GUIObj)
	--Auto-update can be slow with huge list of recipes. No need to. Nothing changes here without player input.
end

function GUI.doUpdateRecipeGUI(GUIObj)
	-- Clear
	GUIObj.RSRecipeFrame.clear()

	--Draw Recipes
	for _, subgroups in ipairs(GUIObj.sortedRecipes[GUIObj.selectedCategory].list) do
		local RSRecipeTable = GUIObj:addTable("", GUIObj.RSRecipeFrame, 10)
		for _, recipe in ipairs(subgroups.list) do
			local r = RSRecipeTable.add({type="choose-elem-button", name="RSSel,"..recipe.obj.name, elem_type="recipe", style="recipe_slot_button"})
			r.elem_value = recipe.obj.name
			r.locked = true
		end
	end
end


function lexicSorter(a, b)
	local first_order = a.obj.order or ""
	local second_order = b.obj.order or ""

	if first_order < second_order then
		return true
	elseif first_order > second_order then
		return false
	else
		local first_name = a.obj.name or ""
		local second_name = b.obj.name or ""
		if first_name < second_name then
			return true
		else
			return false
		end
	end
	return false
end