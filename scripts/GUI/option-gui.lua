-- Create the Option GUI --
function GUI.createOptionGUI(player)

	-- Create the GUI --
	local GUIObj = GUI.createGUI("MFOptionGUI", getMFPlayer(player.name), "vertical", true)

	-- Create the top Bar --
	GUI.createTopBar(GUIObj, 100)

	-- Create the Main Tabbed Pane --
	local mainTabbedPane = GUIObj:addTabbedPane("MainTabbedPane", GUIObj.gui, true)

	-- Create all Tabs --
	GUIObj:addTab("MFTab", mainTabbedPane, {"gui-description.MFTab"}, {"gui-description.MFTabTT"}, true, true)
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

	-- Get the GUI Object --
	local GUIObj = global.GUITable["MFOptionGUI"..playerIndex]

	-- If this is a Title --
	if type == "title" then
		GUIObj:addLine(name, gui, "horizontal")
		local flow = GUIObj:addFlow("", gui, "vertical")
		local label = GUIObj:addLabel("Label", flow, table.text, _mfOrange, "", false, "TitleFont")
		GUIObj:addLine(name, gui, "horizontal")
		flow.style.horizontal_align = "center"
		return flow
	end
	
	-- If this is a CheckBox --
	if type == "checkbox" then
		return GUIObj:addCheckBox(name, gui, table.text, table.tooltip, table.state, save)
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
	local playerIndex = GUIObj.MFTab.player_index
	-- Create the Scroll Pane --
	local scrollPane = GUIObj:addScrollPane("MFTabScrollPane", GUIObj.MFTab, 500)
	scrollPane.style.minimal_height  = 500

	-- Add all Options --
	GUI.addOption("", scrollPane, "title", false, {text={"gui-description.MFOpt"}}, playerIndex)
	GUI.addOption("MFShareOpt", scrollPane, "checkbox", false, {text={"gui-description.MFShareSettingOpt"}, tooltip={"gui-description.MFShareSettingOptTT"}, state=GUIObj.MF.varTable.shareStructures or false}, playerIndex)
	GUI.addOption("MFUseShareOpt", scrollPane, "checkbox", false, {text={"gui-description.MFUseShareOpt"}, tooltip={"gui-description.MFUseShareOptTT"}, state=GUIObj.MF.varTable.useSharedStructures or false}, playerIndex)
	GUI.addOption("MFShareSettingOpt", scrollPane, "checkbox", false, {text={"gui-description.MFShareSettingOpt"}, tooltip={"gui-description.MFShareSettingOptTT"}, state=GUIObj.MF.varTable.allowToModify or false}, playerIndex)

end

-- Update the MFTab --
function GUI.updateOptionGUIGUITab(GUIObj)

	local playerIndex = GUIObj.GUITab.player_index

	-- Create the Scroll Pane --
	local scrollPane = GUIObj:addScrollPane("MFTabScrollPane", GUIObj.GUITab, 500)
	scrollPane.style.minimal_height  = 500

	-- Add all Options --
	GUI.addOption("", scrollPane, "title", false, {text={"gui-description.MainGUIOpt"}}, playerIndex)
	GUI.addOption("MainGuiDirectionSwitch", scrollPane, "switch", false, {text={"gui-description.Left"}, text2={"gui-description.Right"}, text3={"gui-description.MainGUIDirection"}, tooltip3={"gui-description.MainGUIDirectionTT"}, state=GUIObj.MFplayer.varTable.MainGUIDirection or "right"}, playerIndex)

	-- Add a CheckBox for each Buttons --
	for k, button in pairs(global.GUITable["MFMainGUI"..playerIndex].buttonsTable) do
		local state = true
		if GUIObj.MFplayer.varTable["Show" .. button.name] == false then state = false end
		GUI.addOption("MGS," .. button.name, scrollPane, "checkbox", false, {text={"", {"gui-description.MainGUIButtons"}, " ", button.name}, state=state}, playerIndex)
	end

end

-- Update the GameTab --
function GUI.updateOptionGUIGameTab(GUIObj)
	
	local playerIndex = GUIObj.GameTab.player_index

	-- Create the Scroll Pane --
	local scrollPane = GUIObj:addScrollPane("MFTabScrollPane", GUIObj.GameTab, 500)
	scrollPane.style.minimal_height  = 500

	-- Get Jets variable --
	local jets = GUIObj.MF.varTable.jets

	-- Add Jets Options --
	GUI.addOption("", scrollPane, "title", false, {text={"gui-description.JetOptions"}}, playerIndex)
	GUI.addOption("MiningJetDistanceOpt", scrollPane, "numberfield", false, {text=jets.mjMaxDistance or _MFMiningJetDefaultMaxDistance, text2={"gui-description.MiningJetDistanceOpt"}, tooltip={"gui-description.MiningJetDistanceOptTT"}}, playerIndex)
	GUI.addOption("ConstructionJetDistanceOpt", scrollPane, "numberfield", false, {text=jets.cjMaxDistance or _MFConstructionJetDefaultMaxDistance, text2={"gui-description.ConstructionJetDistanceOpt"}, tooltip={"gui-description.ConstructionJetDistanceOptTT"}}, playerIndex)
	GUI.addOption("RepairJetDistanceOpt", scrollPane, "numberfield", false, {text=jets.rjMaxDistance or _MFRepairJetDefaultMaxDistance, text2={"gui-description.RepairJetDistanceOpt"}, tooltip={"gui-description.RepairJetDistanceOptTT"}}, playerIndex)
	GUI.addOption("CombatJetDistanceOpt", scrollPane, "numberfield", false, {text=jets.cbjMaxDistance or _MFCombatJetDefaultMaxDistance, text2={"gui-description.CombatJetDistanceOpt"}, tooltip={"gui-description.CombatJetDistanceOptTT"}}, playerIndex)

	-- Add Floor Is Lava Option --
	GUI.addOption("", scrollPane, "title", false, {text={"gui-description.FloorIsLavaTitle"}}, playerIndex)
	local FILOption = GUI.addOption("FloorIsLavaOpt", scrollPane, "checkbox", false, {text={"gui-description.FloorIsLavaOpt"}, tooltip={"gui-description.FloorIsLavaOptTT"}, state=global.floorIsLavaActivated or false}, playerIndex)
	FILOption.enabled = GUIObj.MFplayer.ent.admin
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
	tickOpt.UpdatePerTickOpt.enabled = GUIObj.MFplayer.ent.admin
end