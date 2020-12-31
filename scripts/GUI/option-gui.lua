-- Create the Option GUI --
function GUI.createOptionGUI(player)

	-- Get the MFPlayer --
	local MFPlayer = getMFPlayer(player.name)

	-- Create the GUI --
	local table = GAPI.createBaseWindows(_mfGUIName.OptionGUI, {"gui-description.MFOptionGUITitle"}, MFPlayer, true, true, false, "vertical", "horizontal")
	local mainFrame = table.vars.MainFrame
	
	-- Add the Close Button --
    GAPI.addCloseButton(table)
	
	-- Create the Main Tabbed Pane --
	local mainTabbedPane = GAPI.addTabbedPane(table, "Opt.GUI.MainTabbedPane", mainFrame, "", "", true, 1)
	mainTabbedPane.style = "MF_Options_Tabbed_Pane"
	mainTabbedPane.style.top_margin = 15

	-- Create all Tabs --
	local MFTab = GAPI.addTab(table, "MFTab", mainTabbedPane, {"gui-description.MFTab"}, {"gui-description.MFTabTT"}, true)
	local GUITab = GAPI.addTab(table, "GUITab", mainTabbedPane, {"gui-description.GUITab"}, {"gui-description.GUITabTT"}, true)
	local GameTab = GAPI.addTab(table, "GameTab", mainTabbedPane, {"gui-description.GameTab"}, {"gui-description.GameTabTT"}, true)
	local SystemTab = GAPI.addTab(table, "SystemTab", mainTabbedPane, {"gui-description.SystemTab"}, {"gui-description.SystemTabTT"}, true)

	-- Create all ScrollPanes --
	local MFTabSP = GAPI.addScrollPane(table, "MFTabScrollPane", MFTab, 500, true)
	local GUITabSP = GAPI.addScrollPane(table, "GUITabScrollPane", GUITab, 500, true)
	local GameTabSP = GAPI.addScrollPane(table, "GameTabScrollPane", GameTab, 500, true)
	local SystemTabSP = GAPI.addScrollPane(table, "SystemTabScrollPane", SystemTab, 500, true)


	MFTabSP.style = "MF_Options_scroll_pan"
	MFTabSP.style.minimal_height  = 500
	GUITabSP.style = "MF_Options_scroll_pan"
	GUITabSP.style.minimal_height  = 500
	GameTabSP.style = "MF_Options_scroll_pan"
	GameTabSP.style.minimal_height  = 500
	SystemTabSP.style = "MF_Options_scroll_pan"
	SystemTabSP.style.minimal_height  = 500

	-- Create all Flows --
	local MFTabFlow = GAPI.addFrame(table, "MFTabFlow", MFTabSP, "vertical", true)
	local GUITabFlow = GAPI.addFrame(table, "GUITabFlow", GUITabSP, "vertical", true)
	local GameTabFlow = GAPI.addFrame(table, "GameTabFlow", GameTabSP, "vertical", true)
	local SystemTabFlow = GAPI.addFrame(table, "SystemTabFlow", SystemTabSP, "vertical", true)

	MFTabFlow.style = "MF_Options_Frame"
	MFTabFlow.style.padding = 5
	MFTabFlow.style.vertically_stretchable = true
	GUITabFlow.style = "MF_Options_Frame"
	GUITabFlow.style.padding = 5
	GUITabFlow.style.vertically_stretchable = true
	GameTabFlow.style = "MF_Options_Frame"
	GameTabFlow.style.padding = 5
	GameTabFlow.style.vertically_stretchable = true
	SystemTabFlow.style = "MF_Options_Frame"
	SystemTabFlow.style.padding = 5
	SystemTabFlow.style.vertically_stretchable = true

	-- Update the GUI --
	GUI.updateOptionGUI(table, 1)

	-- Return the GUI --
	return table

end

-- Update the GUI --
function GUI.updateOptionGUI(GUITable, tabI)

	-- Get the current Tab --
	local tabIndex = tabI or GUITable.vars["Opt.GUI.MainTabbedPane"].selected_tab_index
	local tab = GUITable.vars["Opt.GUI.MainTabbedPane"].tabs[tabIndex]
	if tab == nil then return end
	local tabName = string.gsub(tab.tab.name, "tab", "")

	-- Call the Function --
	if GUI["updateOptionGUI" .. tabName] ~= nil then
		GUI["updateOptionGUI" .. tabName](GUITable)
	end

end

-- Update the MFTab --
function GUI.updateOptionGUIMFTab(GUITable)

	-- Get the Variables --
	local playerIndex = GUITable.MFPlayer.index
	local flow = GUITable.vars.MFTabFlow

	-- Clear the Flow --
	flow.clear()

	-- Create the Players List --
	local playersList = {}
	for k, player in pairs(game.players) do
		if k ~= playerIndex then
			playersList[k] = player.name
		end
	end

	-- Add the Allowed Player Option --
	GAPI.addSubtitle(GUITable, "", flow, {"gui-description.MFTabCoreSetting"})
	local modSettingLabel = GAPI.addLabel(GUITable, "", flow, {"gui-description.OtpGUIModSettingLabel"}, _mfWhite)
	modSettingLabel.style.maximal_width = 340
	modSettingLabel.style.single_line = false
	GAPI.addSubtitle(GUITable, "", flow, {"gui-description.MFOpt"})
	GAPI.addLabel(GUITable, "", flow, {"gui-description.MFPAllowedPlayersLabel"}, nil, {"gui-description.MFPAllowedPlayersLabelTT"}, false, nil, _mfLabelType.yellowTitle)
	local playersPermissionsFlow = GAPI.addFlow(GUITable, "", flow, "horizontal")
	local addAllowedPlayerDD = GAPI.addDropDown(GUITable, "AllowedPlayersDD", playersPermissionsFlow, playersList, nil, true)
	addAllowedPlayerDD.style.horizontally_stretchable = true
	local addAllowedPlayerButton = GAPI.addSimpleButton(GUITable, "Opt.GUI.AddAllowedPlayer", playersPermissionsFlow, {"gui-description.MFOptAddButton"})
	addAllowedPlayerButton.style.maximal_width = 75
	local removeAllowedPlayerButton = GAPI.addSimpleButton(GUITable, "Opt.GUI.RemoveAllowedPlayer", playersPermissionsFlow, {"gui-description.MFOptRemoveButton"})
	removeAllowedPlayerButton.style.maximal_width = 75

	-- Add the Allowed Player list --
	local allowedPlayersText = ""
	for index, allowed in pairs(GUITable.MFPlayer.MF.varTable.allowedPlayers) do
		if allowed == true then
			allowedPlayersText = allowedPlayersText .. " - " .. getMFPlayer(index).name
		end
	end
	local allowedPlayersLabel = GAPI.addLabel(GUITable, "", flow, allowedPlayersText, _mfGreen)
	allowedPlayersLabel.style.maximal_width = 340
	allowedPlayersLabel.style.single_line = false

end

-- Update the GUITab --
function GUI.updateOptionGUIGUITab(GUITable)

	-- Get the Variables --
	local playerIndex = GUITable.MFPlayer.index
	local MFPlayer = getMFPlayer(playerIndex)
	local flow = GUITable.vars.GUITabFlow

	-- Clear the Flow --
	flow.clear()

	-- Add Buttons on Main GUI Options --
	GAPI.addSubtitle(GUITable, "", flow, {"gui-description.MainGUIOpt"})

	-- Add a CheckBox for every Buttons --
	GAPI.addLabel(GUITable, "", flow, {"gui-description.MainGUIButtonsTitle"}, nil, nil, false, nil, _mfLabelType.yellowTitle)
	for _, button in pairs(MFPlayer.GUI["MFMainGUI"].vars.buttonsTable) do
		local state = true
		if MFPlayer.varTable["Show" .. button.name] == false then state = false end
		GAPI.addCheckBox(GUITable, "Opt.GUI.MainGUIButtonsVisible" .. button.name, flow, {"", {"gui-description.MainGUIButtons"}, "", button.name}, "", state, false, {name=button.name})
	end

	-- Add the Main Buttons size Selector --
	GAPI.addLabel(GUITable, "", flow, {"gui-description.MainButtonSizeTitle"}, nil, {"gui-description.MainButtonSizeSelectorTT"}, false, nil, _mfLabelType.yellowTitle)
	GAPI.addDropDown(GUITable, "Opt.GUI.MainButtonsSize", flow, {1,2,3,4,5,6,7,8,9,10}, MFPlayer.varTable.MainButtonsSize or 5, true)

	-- Add the Buttons per Line Selector --
	GAPI.addLabel(GUITable, "", flow, {"gui-description.MainGUIButtonsLineTitle"}, nil, {"gui-description.MainGUIButtonsPerLineTT"}, false, nil, _mfLabelType.yellowTitle)
	GAPI.addDropDown(GUITable, "Opt.GUI.MainGUIButtonsPerLine", flow, {1,2,3,4,5,6,7,8,9,10}, MFPlayer.varTable.mainGUIButtonsPerLine or 5, true)

	-- Add a CheckBox for every Information --
	GAPI.addLabel(GUITable, "", flow, {"gui-description.MainGUIInformationTitle"}, nil, nil, false, nil, _mfLabelType.yellowTitle)
	GAPI.addCheckBox(GUITable, "Opt.GUI.MainGUIShowPositions", flow, {"gui-description.MainGUIShowPositions"}, "", MFPlayer.varTable.MainGUIShowPositions == nil and true or MFPlayer.varTable.MainGUIShowPositions)
	GAPI.addCheckBox(GUITable, "Opt.GUI.MainGUIShowTime", flow, {"gui-description.MainGUIShowTime"}, "", MFPlayer.varTable.MainGUIShowTime == nil and false or MFPlayer.varTable.MainGUIShowTime)
	local eryaTemp = GAPI.addCheckBox(GUITable, "Opt.GUI.MainGUIShowTemperature", flow, {"gui-description.MainGUIShowTemperature"}, {"gui-description.MainGUIShowTemperatureTT"}, MFPlayer.varTable.MainGUIShowTemperature == nil and false or MFPlayer.varTable.MainGUIShowTemperature)

	-- Enable or Disable the Erya Temperature Checkbox --
	if script.active_mods["Mobile_Factory-Erya"] ~= nil and script.active_mods["Mobile_Factory-Erya"] >= "0.1.8" then
		eryaTemp.enabled = true
	else
		eryaTemp.enabled = false
		MFPlayer.varTable.MainGUIShowTemperature = false
		eryaTemp.state = false
	end

	-- Add a CheckBox for every Progress Bars --
	GAPI.addLabel(GUITable, "", flow, {"gui-description.MainGUIBarsTitle"}, nil, nil, false, nil, _mfLabelType.yellowTitle)
	GAPI.addCheckBox(GUITable, "Opt.GUI.MainGUIShowHealthBar", flow, {"gui-description.MainGUIShowHealthBar"}, "", MFPlayer.varTable.MainGUIShowHealthBar == nil and true or MFPlayer.varTable.MainGUIShowHealthBar)
	GAPI.addCheckBox(GUITable, "Opt.GUI.MainGUIShowShieldBar", flow, {"gui-description.MainGUIShowShieldBar"}, "", MFPlayer.varTable.MainGUIShowShieldBar == nil and true or MFPlayer.varTable.MainGUIShowShieldBar)
	GAPI.addCheckBox(GUITable, "Opt.GUI.MainGUIShowEnergyBar", flow, {"gui-description.MainGUIShowEnergyBar"}, "", MFPlayer.varTable.MainGUIShowEnergyBar == nil and true or MFPlayer.varTable.MainGUIShowEnergyBar)
	GAPI.addCheckBox(GUITable, "Opt.GUI.MainGUIShowQuatronBar", flow, {"gui-description.MainGUIShowQuatronBar"}, "", MFPlayer.varTable.MainGUIShowQuatronBar == nil and true or MFPlayer.varTable.MainGUIShowQuatronBar)
	GAPI.addCheckBox(GUITable, "Opt.GUI.MainGUIShowJumpCharge", flow, {"gui-description.MainGUIShowJumpCharge"}, "", MFPlayer.varTable.MainGUIShowJumpCharge == nil and true or MFPlayer.varTable.MainGUIShowJumpCharge)

end

-- Update the GameTab --
function GUI.updateOptionGUIGameTab(GUITable)

	-- Get the Variables --
	local playerIndex = GUITable.MFPlayer.index
	local MFPlayer = getMFPlayer(playerIndex)
	local flow = GUITable.vars.GameTabFlow

	-- Clear the Flow --
	flow.clear()

	-- Add Floor Is Lava Option --
	GAPI.addSubtitle(GUITable, "", flow, {"gui-description.GameTabGeneral"})
	local FILOption = GAPI.addCheckBox(GUITable, "Opt.GUI.FloorIsLavaOpt", flow, {"gui-description.FloorIsLavaOpt"}, {"gui-description.FloorIsLavaOptTT"}, global.floorIsLavaActivated or false)
	FILOption.enabled = MFPlayer.ent.admin

	-- Create the Category List --
	local categoryList = {}
	for _, recipe in pairs(game.recipe_prototypes) do
		categoryList[recipe.category] = recipe.category
	end

	-- Add Data Network Options --
	GAPI.addSubtitle(GUITable, "", flow, {"gui-description.DataNetwork"})
	GAPI.addLabel(GUITable, "", flow, {"gui-description.DABlacklistLabel"}, nil, {"gui-description.DABlacklistLabelTT"}, false, nil, _mfLabelType.yellowTitle)
	local blacklistFlow = GAPI.addFlow(GUITable, "", flow, "horizontal")
	local blackListRecipeDD = GAPI.addDropDown(GUITable, "blacklistDAList", blacklistFlow, categoryList, nil, true)
	blackListRecipeDD.style.horizontally_stretchable = true
	local add = GAPI.addSimpleButton(GUITable, "Opt.GUI.AddDARecipeToBlackList", blacklistFlow, {"gui-description.MFOptAddButton"})
	add.style.maximal_width = 75
	add.enabled = MFPlayer.ent.admin
	local rem = GAPI.addSimpleButton(GUITable, "Opt.GUI.RemoveDARecipeFromBlackList", blacklistFlow, {"gui-description.MFOptRemoveButton"})
	rem.style.maximal_width = 75
	rem.enabled = MFPlayer.ent.admin

	-- Add the Blacklisted Categories list --
	local blackListText = ""
	for category, _ in pairs(global.dataAssemblerBlacklist) do
		blackListText = blackListText .. " - " .. category
	end
	local blackListLable = GAPI.addLabel(GUITable, "", flow, blackListText, _mfRed)
	blackListLable.style.maximal_width = 340
	blackListLable.style.single_line = false

end

-- Update the SystemTab --
function GUI.updateOptionGUISystemTab(GUITable)

	-- Get the Variables --
	local playerIndex = GUITable.MFPlayer.index
	local MFPlayer = getMFPlayer(playerIndex)
	local flow = GUITable.vars.SystemTabFlow

	-- Clear the Flow --
	flow.clear()

	-- Add Performances Options --
	GAPI.addSubtitle(GUITable, "", flow, {"gui-description.PerfOpt"})
	GAPI.addLabel(GUITable, "", flow, {"gui-description.SystemPerfEntsPerTick"}, nil, {"gui-description.SystemPerfEntsPerTickTT"}, false, nil, _mfLabelType.yellowTitle)
	local tickTextField = GAPI.addTextField(GUITable, "Opt.GUI.UpdatePerTickOpt", flow, global.entsUpPerTick or 100, nil, true, true, false, false)
	tickTextField.enabled = MFPlayer.ent.admin

	-- Ad the Option to use the Vanilla Recipe Selector inside the Data Assembler --
	GAPI.addLabel(GUITable, "", flow, {"gui-description.UseVanillaRecipeLabel"}, nil, "", false, nil, _mfLabelType.yellowTitle)
	local DAcheckbox = GAPI.addCheckBox(GUITable, "Opt.GUI.UseVanillaRecipeSelector", flow, {"gui-description.UseVanillaChooseElem"}, {"gui-description.UseVanillaChooseElemTT"}, global.useVanillaChooseElem)
	DAcheckbox.enabled = MFPlayer.ent.admin

	-- Add the Erya Tech Debug Option --
	GAPI.addLabel(GUITable, "", flow, {"gui-description.EryaTech"}, nil, "", false, nil, _mfLabelType.yellowTitle)
	local EryaDebugCheckbox = GAPI.addCheckBox(GUITable, "Opt.GUI.EryaDebugOption", flow, {"gui-description.EryaDebugOption"}, {"gui-description.EryaDebugOptionTT"}, MFPlayer.varTable.EryaDebug)
	if script.active_mods["Mobile_Factory-Erya"] == nil or script.active_mods["Mobile_Factory-Erya"] < "0.4.0" or MFPlayer.ent.admin == false then
		EryaDebugCheckbox.enabled = false
	end

end