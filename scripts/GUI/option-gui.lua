-- Create the Option GUI --
function GUI.createOptionGUI(player)

	-- Create the GUI --
	local GUIObj = GUI.createGUI("MFOptionGUI", getMFPlayer(player.name), "vertical", true)

	-- Create the top Bar --
	GUI.createTopBar(GUIObj, 100)

	-- Create the Main Tabbed Pane --
	local mainTabbedPane = GUIObj:addTabbedPane("MainTabbedPane", GUIObj.gui, true, 1)

	-- Create all Tabs --
	GUIObj:addTab("MFTab", mainTabbedPane, {"gui-description.MFTab"}, {"gui-description.MFTabTT"}, true)
	GUIObj:addTab("GUITab", mainTabbedPane, {"gui-description.GUITab"}, {"gui-description.GUITab"}, true)
	GUIObj:addTab("GameTab", mainTabbedPane, {"gui-description.GameTab"}, {"gui-description.GameTab"}, true)
	GUIObj:addTab("SystemTab", mainTabbedPane, {"gui-description.SystemTab"}, {"gui-description.SystemTab"}, true)

	-- Update the GUI --
	GUI.updateOptionGUI(GUIObj, 1)

	-- Center the GUI --
	GUIObj.force_auto_center()

	-- Return the GUI --
	return GUIObj

end

-- Add an Option to a Tab --
function GUI.addOption(name, gui, type, save, table, playerIndex) -- table{text, text2, text3, tooltip, tooltip2, tooltip3, state}

	-- Get the MFPlayer and the GUI Object --
	local MFPlayer = getMFPlayer(playerIndex)
	local GUIObj = MFPlayer.GUI["MFOptionGUI"]

	-- If this is a Title --
	if type == "title" then
		GUIObj:addLine(name, gui, "horizontal")
		local flow = GUIObj:addFlow("", gui, "vertical")
		local label = GUIObj:addLabel("Label", flow, table.text, _mfOrange, "", false, "TitleFont")
		GUIObj:addLine(name, gui, "horizontal")
		flow.style.horizontal_align = "center"
		return flow
	end

	-- If this is a Switch --
	if type == "switch" then
		local flow = GUIObj:addFlow("", gui, "horizontal")
		GUIObj:addSwitch(name, flow, table.text, table.text2, table.tooltip, table.tooltip2, table.state)
		local label = GUIObj:addLabel("Label", flow, table.text3, _mfWhite, table.tooltip3, save, "LabelFont2")
		flow.style.vertical_align = "center"
		label.style.left_margin = 5
		return flow
	end

	-- If this is a Number Field --
	if type == "numberfield" then
		local flow = GUIObj:addFlow("", gui, "horizontal")
		GUIObj:addTextField(name, flow, table.text, table.tooltip, save, true, false, false, false)
		GUIObj:addLabel("Label", flow, table.text2, _mfWhite, table.tooltip, false, "LabelFont2")
		flow.style.vertical_align = "center"
		flow[name].style.maximal_width = 100
		return flow
	end

end

-- Update the GUI --
function GUI.updateOptionGUI(GUIObj, tabI)

	-- Get the current Tab --
	local tabIndex = tabI or GUIObj.MainTabbedPane.selected_tab_index
	local tab = GUIObj.MainTabbedPane.tabs[tabIndex]
	if tab == nil then return end
	local tabName = string.gsub(tab.tab.name, "tab", "")

	-- Call the Function --
	if GUI["updateOptionGUI" .. tabName] ~= nil then
		GUI["updateOptionGUI" .. tabName](GUIObj)
	end
end

-- Update the MFTab --
function GUI.updateOptionGUIMFTab(GUIObj)

	-- Need player_index so we know for whom we update GUI options --
	local playerIndex = GUIObj.MFPlayer.index
	
	-- Create the Scroll Pane --
	local scrollPane = GUIObj:addScrollPane("MFTabScrollPane", GUIObj.MFTab, 500)
	scrollPane.style.minimal_height  = 500

	-- Create the Players List --
	local playersList = {}
	for k, player in pairs(game.players) do
		if k ~= playerIndex then
			playersList[k] = player.name
		end
	end

	-- Add all Options --
	GUI.addOption("", scrollPane, "title", false, {text={"gui-description.MFOpt"}}, playerIndex)
	GUIObj:addLabel("", scrollPane, {"gui-description.MFPAllowedPlayersLabel"}, nil, {"gui-description.MFPAllowedPlayersLabelTT"}, false, "LabelFont2")
	local playersPermissionsFlow = GUIObj:addFlow("", scrollPane, "horizontal")
	GUIObj:addDropDown("POptPlayersList", playersPermissionsFlow, playersList, nil, true)
	GUIObj:addSimpleButton("PermOtpAdd", playersPermissionsFlow, {"gui-description.MFOptAddButton"})
	GUIObj:addSimpleButton("PermOtpRemove", playersPermissionsFlow, {"gui-description.MFOptRemoveButton"})

	-- Add the Allowed Player list --
	for index, allowed in pairs(GUIObj.MF.varTable.allowedPlayers) do
		if allowed == true then
			GUIObj:addLabel("", scrollPane, getMFPlayer(index).name, _mfGreen)
		end
	end
end

-- Update the GUITab --
function GUI.updateOptionGUIGUITab(GUIObj)

	local playerIndex = GUIObj.GUITab.player_index
	local MFPlayer = getMFPlayer(playerIndex)

	-- Create the Scroll Pane --
	local scrollPane = GUIObj:addScrollPane("MFTabScrollPane", GUIObj.GUITab, 500)
	scrollPane.style.minimal_height  = 500

	-- Add all Options --
	GUI.addOption("", scrollPane, "title", false, {text={"gui-description.MainGUIOpt"}}, playerIndex)
	GUIObj:addLabel("", scrollPane, {"gui-description.MainGUIGeneralTitle"}, nil, nil, false, "LabelFont2")

	-- Add a CheckBox every Buttons --
	GUIObj:addLabel("", scrollPane, {"gui-description.MainGUIButtonsTitle"}, nil, nil, false, "LabelFont2")
	for _, button in pairs(MFPlayer.GUI["MFMainGUI"].vars.buttonsTable) do
		local state = true
		if GUIObj.MFPlayer.varTable["Show" .. button.name] == false then state = false end
		GUIObj:addCheckBox("MGS," .. button.name, scrollPane, {"", {"gui-description.MainGUIButtons"}, "", button.name}, "", state)
	end

	-- Add the Main Buttons size Selector --
	GUIObj:addLabel("", scrollPane, {"gui-description.MainButtonSizeTitle"}, nil, nil, false, "LabelFont2")
	GUIObj:addDropDown("MainButtonsSize", scrollPane, {1,2,3,4,5,6,7,8,9,10}, GUIObj.MFPlayer.varTable.MainButtonsSize or 5, true, {"gui-description.MainButtonSizeSelectorTT"})

	-- Add the Buttons per Line Selector --
	GUIObj:addLabel("", scrollPane, {"gui-description.MainGUIButtonsLineTitle"}, nil, nil, false, "LabelFont2")
	GUIObj:addDropDown("MainGUIButtonsPerLine", scrollPane, {1,2,3,4,5,6,7,8,9,10}, GUIObj.MFPlayer.varTable.mainGUIButtonsPerLine or 5, true, {"gui-description.MainGUIButtonsPerLineTT"})

	-- Add a CheckBox for every Information --
	GUIObj:addLabel("", scrollPane, {"gui-description.MainGUIInformationTitle"}, nil, nil, false, "LabelFont2")
	GUIObj:addCheckBox("MainGUIShowPositions", scrollPane, {"gui-description.MainGUIShowPositions"}, "", GUIObj.MFPlayer.varTable.MainGUIShowPositions == nil and true or GUIObj.MFPlayer.varTable.MainGUIShowPositions)
	GUIObj:addCheckBox("MainGUIShowTime", scrollPane, {"gui-description.MainGUIShowTime"}, "", GUIObj.MFPlayer.varTable.MainGUIShowTime == nil and false or GUIObj.MFPlayer.varTable.MainGUIShowTime)
	local eryaTemp = GUIObj:addCheckBox("MainGUIShowTemperature", scrollPane, {"gui-description.MainGUIShowTemperature"}, {"gui-description.MainGUIShowTemperatureTT"}, GUIObj.MFPlayer.varTable.MainGUIShowTemperature == nil and false or GUIObj.MFPlayer.varTable.MainGUIShowTemperature)

	-- Enable or Disable the Erya Temperature Checkbox --
	if script.active_mods["Mobile_Factory-Erya"] ~= nil and script.active_mods["Mobile_Factory-Erya"] > "0.1.7" then
		eryaTemp.enabled = true
	else
		eryaTemp.enabled = false
		GUIObj.MFPlayer.varTable.MainGUIShowTemperature = false
		eryaTemp.state = false
	end

	-- Add a CheckBox for every Progress Bars --
	GUIObj:addLabel("", scrollPane, {"gui-description.MainGUIBarsTitle"}, nil, nil, false, "LabelFont2")
	GUIObj:addCheckBox("MainGUIShowHealthBar", scrollPane, {"gui-description.MainGUIShowHealthBar"}, "", GUIObj.MFPlayer.varTable.MainGUIShowHealthBar == nil and true or GUIObj.MFPlayer.varTable.MainGUIShowHealthBar)
	GUIObj:addCheckBox("MainGUIShowShieldBar", scrollPane, {"gui-description.MainGUIShowShieldBar"}, "", GUIObj.MFPlayer.varTable.MainGUIShowShieldBar == nil and true or GUIObj.MFPlayer.varTable.MainGUIShowShieldBar)
	GUIObj:addCheckBox("MainGUIShowEnergyBar", scrollPane, {"gui-description.MainGUIShowEnergyBar"}, "", GUIObj.MFPlayer.varTable.MainGUIShowEnergyBar == nil and true or GUIObj.MFPlayer.varTable.MainGUIShowEnergyBar)
	GUIObj:addCheckBox("MainGUIShowQuatronBar", scrollPane, {"gui-description.MainGUIShowQuatronBar"}, "", GUIObj.MFPlayer.varTable.MainGUIShowQuatronBar == nil and true or GUIObj.MFPlayer.varTable.MainGUIShowQuatronBar)
	GUIObj:addCheckBox("MainGUIShowJumpCharge", scrollPane, {"gui-description.MainGUIShowJumpCharge"}, "", GUIObj.MFPlayer.varTable.MainGUIShowJumpCharge == nil and true or GUIObj.MFPlayer.varTable.MainGUIShowJumpCharge)

end

-- Update the GameTab --
function GUI.updateOptionGUIGameTab(GUIObj)
	
	local playerIndex = GUIObj.GameTab.player_index

	-- Create the Scroll Pane --
	local scrollPane = GUIObj:addScrollPane("MFTabScrollPane", GUIObj.GameTab, 500)
	scrollPane.style.minimal_height  = 500

	-- Get Jets variable --
	-- local jets = GUIObj.MF.varTable.jets

	-- Add Jets Options --
	-- GUI.addOption("", scrollPane, "title", false, {text={"gui-description.JetOptions"}}, playerIndex)
	-- GUI.addOption("MiningJetDistanceOpt", scrollPane, "numberfield", false, {text=jets.mjMaxDistance or _MFMiningJetDefaultMaxDistance, text2={"gui-description.MiningJetDistanceOpt"}, tooltip={"gui-description.MiningJetDistanceOptTT"}}, playerIndex)
	-- GUI.addOption("ConstructionJetDistanceOpt", scrollPane, "numberfield", false, {text=jets.cjMaxDistance or _MFConstructionJetDefaultMaxDistance, text2={"gui-description.ConstructionJetDistanceOpt"}, tooltip={"gui-description.ConstructionJetDistanceOptTT"}}, playerIndex)
	-- GUI.addOption("RepairJetDistanceOpt", scrollPane, "numberfield", false, {text=jets.rjMaxDistance or _MFRepairJetDefaultMaxDistance, text2={"gui-description.RepairJetDistanceOpt"}, tooltip={"gui-description.RepairJetDistanceOptTT"}}, playerIndex)
	-- GUI.addOption("CombatJetDistanceOpt", scrollPane, "numberfield", false, {text=jets.cbjMaxDistance or _MFCombatJetDefaultMaxDistance, text2={"gui-description.CombatJetDistanceOpt"}, tooltip={"gui-description.CombatJetDistanceOptTT"}}, playerIndex)
	-- GUI.addOption("ConstructionJetTableSizeOpt", scrollPane, "numberfield", false, {text=jets.cjTableSize or _MFConstructionJetDefaultTableSize, text2={"gui-description.ConstructionJetTableSizeOpt"}, tooltip={"gui-description.ConstructionJetTableSizeOptTT"}}, playerIndex)

	-- Add Floor Is Lava Option --
	GUI.addOption("", scrollPane, "title", false, {text={"gui-description.FloorIsLavaTitle"}}, playerIndex)
	local FILOption = GUIObj:addCheckBox("FloorIsLavaOpt", scrollPane, {"gui-description.FloorIsLavaOpt"}, {"gui-description.FloorIsLavaOptTT"}, global.floorIsLavaActivated or false)
	FILOption.enabled = GUIObj.MFPlayer.ent.admin

	-- Create the Category List --
	local categoryList = {}
	for _, recipe in pairs(game.recipe_prototypes) do
		categoryList[recipe.category] = recipe.category
	end

	-- Add all Options --
	GUI.addOption("", scrollPane, "title", false, {text={"gui-description.DataNetwork"}}, playerIndex)
	GUIObj:addLabel("", scrollPane, {"gui-description.DABlacklistLabel"}, nil, {"gui-description.DABlacklistLabelTT"}, false, "LabelFont2")
	local blacklistFlow = GUIObj:addFlow("", scrollPane, "horizontal")
	GUIObj:addDropDown("blacklistDAList", blacklistFlow, categoryList, nil, true)
	local add = GUIObj:addSimpleButton("blacklistDAAdd", blacklistFlow, {"gui-description.MFOptAddButton"})
	local rem = GUIObj:addSimpleButton("blacklistDARem", blacklistFlow, {"gui-description.MFOptRemoveButton"})
	add.enabled = GUIObj.MFPlayer.ent.admin
	rem.enabled = GUIObj.MFPlayer.ent.admin

	-- Add the Blacklisted Categories list --
	for category, _ in pairs(global.dataAssemblerBlacklist) do
		GUIObj:addLabel("", scrollPane, category, _mfRed)
	end
end

-- Update the SystemTab --
function GUI.updateOptionGUISystemTab(GUIObj)

	local playerIndex = GUIObj.SystemTab.player_index

	-- Create the Scroll Pane --
	local scrollPane = GUIObj:addScrollPane("MFTabScrollPane", GUIObj.SystemTab, 500)
	scrollPane.style.minimal_height  = 500

	-- Add Performances Options --
	GUI.addOption("", scrollPane, "title", false, {text={"gui-description.PerfOpt"}}, playerIndex)
	local tickOpt = GUI.addOption("UpdatePerTickOpt", scrollPane, "numberfield", false, {text=global.entsUpPerTick or 100, text2={"gui-description.SystemPerfEntsPerTick"}, tooltip={"gui-description.SystemPerfEntsPerTickTT"}}, playerIndex)
	tickOpt.UpdatePerTickOpt.enabled = GUIObj.MFPlayer.ent.admin

	local checkbox = GUIObj:addCheckBox("useVanillaChooseElem", scrollPane, {"gui-description.UseVanillaChooseElem"}, {"gui-description.UseVanillaChooseElemTT"}, global.useVanillaChooseElem)
	checkbox.enabled = GUIObj.MFPlayer.ent.admin
end