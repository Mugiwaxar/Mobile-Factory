-- Create the Option GUI --
function GUI.createOptionGUI(gui, player)

	-- Verify if the Option GUI exist, else destroy it --
	if gui.screen.mfOptionGUI ~= nil and gui.screen.mfOptionGUI.valid == true then
		gui.screen.mfOptionGUI.destroy()
	end
	
	-- Create the GUI --
	local mfOptionGUI = gui.screen.add{type="frame", name="mfOptionGUI", direction="vertical"}

	-- Get the MF --
	local MF = getMF(player.name)
	if MF == nil then return end
	
	-- Calcule the position --
	local resolutionWidth = player.display_resolution.width  / player.display_scale
	local resolutionHeight = player.display_resolution.height  / player.display_scale
	local posX = resolutionWidth / 100 * 45
	local posY = resolutionHeight / 100 * 18
	local width = 400
	local height = 600
	
	-- Set the GUI position end style --
	mfOptionGUI.caption = {"gui-description.options"}
	mfOptionGUI.location = {posX, posY}
	mfOptionGUI.style.padding = 5
	mfOptionGUI.style.width = width
	mfOptionGUI.style.height = height
	mfOptionGUI.style.padding = 0
	mfOptionGUI.style.margin = 0
	mfOptionGUI.visible = false
	
	-- Create the Menu Bar --
	local mfOptGUIMenuBar = mfOptionGUI.add{type="flow", name="mfOptGUIMenuBar", direction="horizontal"}
	-- Set Style --
	mfOptGUIMenuBar.style.width = width - 15
	mfOptGUIMenuBar.style.padding = 0
	mfOptGUIMenuBar.style.margin = 0
	mfOptGUIMenuBar.style.horizontal_align = "right"
	mfOptGUIMenuBar.style.vertical_align = "top"
	
	-- Add the close Button to top Flow --
	mfOptGUIMenuBar.add{
		type="sprite-button",
		name="OptCloseButton",
		sprite="CloseIcon",
		resize_to_sprite=false,
		tooltip={"gui-description.closeButton"}
	}
	-- Set style --
	mfOptGUIMenuBar.OptCloseButton.style.maximal_width = 15
	mfOptGUIMenuBar.OptCloseButton.style.maximal_height = 15
	mfOptGUIMenuBar.OptCloseButton.style.padding = 0
	mfOptGUIMenuBar.OptCloseButton.style.margin = 0
	
	-- Create the Tabbed-pane --
	local mfOptTabbedPane = mfOptionGUI.add{type="tabbed-pane", name="mfOptTabbedPane"}
	mfOptTabbedPane.style.width = width - 8
	mfOptTabbedPane.style.height = height - 62
	mfOptTabbedPane.style.padding = 0
	mfOptTabbedPane.style.margin = 0

	------------------------------------------- TAB 4 --------------------------------
	-- Create the Tab --
	local mfOptTab4 = mfOptTabbedPane.add{type="tab", name="mfOptTab4"}
	mfOptTab4.caption = {"gui-description.tab4"}
	mfOptTab4.style.padding = 0
	mfOptTab4.style.margin = 0
	
	-- Create the Frame --
	local mfOptTab4Frame = mfOptTabbedPane.add{type="frame", name="mfOptTab4Frame"}
	mfOptTab4Frame.style.width = width - 16
	mfOptTab4Frame.style.height = height - 100
	mfOptTab4Frame.style.padding = 0
	mfOptTab4Frame.style.margin = 0
	
	-- Create the Scroll-pane --
	local mfOptTab4Pane = mfOptTab4Frame.add{type="frame", name="mfOptTab4Pane", direction="vertical"}
	mfOptTab4Pane.style.width = width - 24
	mfOptTab4Pane.style.height = height - 107
	mfOptTab4Pane.style.padding = 0
	mfOptTab4Pane.style.margin = 0
	mfOptTab4Pane.style.horizontal_align = "left"
	mfOptTab4Pane.style.vertical_align = "top"
	
	-- Add all Tabs to the Tabbed-pane --
	mfOptTabbedPane.add_tab(mfOptTab4, mfOptTab4Frame)
	mfOptTabbedPane.selected_tab_index = mfOptTab4.index
	
	-- Create the Tab 4 --
	GUI.createOptTab4(mfOptTab4Pane)
	
	------------------------------------------- TAB 1 --------------------------------
	-- Create the Tab --
	local mfOptTab1 = mfOptTabbedPane.add{type="tab", name="mfOptTab1"}
	mfOptTab1.caption = {"gui-description.tab1"}
	mfOptTab1.style.padding = 0
	mfOptTab1.style.margin = 0
	
	-- Create the Frame --
	local mfOptTab1Frame = mfOptTabbedPane.add{type="frame", name="mfOptTab1Frame"}
	mfOptTab1Frame.style.width = width - 16
	mfOptTab1Frame.style.height = height - 100
	mfOptTab1Frame.style.padding = 0
	mfOptTab1Frame.style.margin = 0
	
	-- Create the Scroll-pane --
	local mfOptTab1Pane = mfOptTab1Frame.add{type="frame", name="mfOptTab1Pane", direction="vertical"}
	mfOptTab1Pane.style.width = width - 24
	mfOptTab1Pane.style.height = height - 107
	mfOptTab1Pane.style.padding = 0
	mfOptTab1Pane.style.margin = 0
	mfOptTab1Pane.style.horizontal_align = "left"
	mfOptTab1Pane.style.vertical_align = "top"
	
	-- Add all Tabs to the Tabbed-pane --
	mfOptTabbedPane.add_tab(mfOptTab1, mfOptTab1Frame)
	mfOptTabbedPane.selected_tab_index = mfOptTab1.index
	
	-- Create the Tab 1 --
	GUI.createOptTab1(mfOptTab1Pane)
	
	------------------------------------------- TAB 3 --------------------------------
	-- Create the Tab --
	local mfOptTab3 = mfOptTabbedPane.add{type="tab", name="mfOptTab3"}
	mfOptTab3.caption = {"gui-description.tab3"}
	mfOptTab3.style.padding = 0
	mfOptTab3.style.margin = 0
	
	-- Create the Frame --
	local mfOptTab3Frame = mfOptTabbedPane.add{type="frame", name="mfOptTab3Frame"}
	mfOptTab3Frame.style.width = width - 16
	mfOptTab3Frame.style.height = height - 100
	mfOptTab3Frame.style.padding = 0
	mfOptTab3Frame.style.margin = 0
	
	-- Create the Scroll-pane --
	local mfOptTab3Pane = mfOptTab3Frame.add{type="frame", name="mfOptTab3Pane", direction="vertical"}
	mfOptTab3Pane.style.width = width - 24
	mfOptTab3Pane.style.height = height - 107
	mfOptTab3Pane.style.padding = 0
	mfOptTab3Pane.style.margin = 0
	mfOptTab3Pane.style.horizontal_align = "left"
	mfOptTab3Pane.style.vertical_align = "top"
	
	-- Add all Tabs to the Tabbed-pane --
	mfOptTabbedPane.add_tab(mfOptTab3, mfOptTab3Frame)
	
	-- Create the Tab 3 --
	GUI.createOptTab3(mfOptTab3Pane, player, MF)
	
	------------------------------------------- TAB 2 --------------------------------
	-- Create the Tab --
	local mfOptTab2 = mfOptTabbedPane.add{type="tab", name="mfOptTab2"}
	mfOptTab2.caption = {"gui-description.tab2"}
	mfOptTab2.style.padding = 0
	mfOptTab2.style.margin = 0
	
	-- Create the Frame --
	local mfOptTab2Frame = mfOptTabbedPane.add{type="frame", name="mfOptTab2Frame"}
	mfOptTab2Frame.style.width = width - 16
	mfOptTab2Frame.style.height = height - 100
	mfOptTab2Frame.style.padding = 0
	mfOptTab2Frame.style.margin = 0
	
	-- Create the Scroll-pane --
	local mfOptTab2Pane = mfOptTab2Frame.add{type="frame", name="mfOptTab2Pane", direction="vertical"}
	mfOptTab2Pane.style.width = width - 24
	mfOptTab2Pane.style.height = height - 107
	mfOptTab2Pane.style.padding = 0
	mfOptTab2Pane.style.margin = 0
	mfOptTab2Pane.style.horizontal_align = "left"
	mfOptTab2Pane.style.vertical_align = "top"
	
	-- Add all Tabs to the Tabbed-pane --
	mfOptTabbedPane.add_tab(mfOptTab2, mfOptTab2Frame)
	
	-- Create the Tab 2 --
	GUI.createOptTab2(mfOptTab2Pane, player)

end

---------------------- OPTIONS GUI TAB 4 --------------------------
function GUI.createOptTab4(tab)
	local GUIMainGuiOpt = tab.add{type="label", name="MFOpt", caption={"gui-description.MFOpt"}}
	GUIMainGuiOpt.style.font = "TitleFont"
	tab.add{type="checkbox", name="MFShareOpt", caption={"gui-description.MFShareOpt"}, tooltip={"gui-description.MFShareOptTT"}, state=false}
	tab.add{type="checkbox", name="MFUseShareOpt", caption={"gui-description.MFUseShareOpt"}, tooltip={"gui-description.MFUseShareOptTT"}, state=false}
	tab.add{type="checkbox", name="MFShareSettingOpt", caption={"gui-description.MFShareSettingOpt"}, tooltip={"gui-description.MFShareSettingOptTT"}, state=false}
end

---------------------- OPTIONS GUI TAB 1 --------------------------
function GUI.createOptTab1(tab)
	local GUIMainGuiOpt = tab.add{type="label", name="GUIMainGuiOpt", caption={"gui-description.GUIMainGuiOpt"}}
	GUIMainGuiOpt.style.font = "TitleFont"
	tab.add{type="checkbox", name="GUIPosOpt", caption={"gui-description.GUIPosOpt"}, state=true}
	tab.add{type="checkbox", name="GUIHealthOpt", caption={"gui-description.GUIHealthOpt"}, state=true}
	tab.add{type="checkbox", name="GUIHealthBarOpt", caption={"gui-description.GUIHealthBarOpt"}, state=true}
	tab.add{type="checkbox", name="GUIShieldOpt", caption={"gui-description.GUIShieldOpt"}, state=true}
	tab.add{type="checkbox", name="GUIShieldBarOpt", caption={"gui-description.GUIShieldBarOpt"}, state=true}
	tab.add{type="checkbox", name="GUIJumpDriveOpt", caption={"gui-description.GUIJumpDriveOpt"}, state=true}
	tab.add{type="checkbox", name="GUIJumpDriveBarOpt", caption={"gui-description.GUIJumpDriveBarOpt"}, state=true}
	tab.add{type="checkbox", name="GUIEnergyOpt", caption={"gui-description.GUIEnergyOpt"}, state=true}
	tab.add{type="checkbox", name="GUIEnergyBarOpt", caption={"gui-description.GUIEnergyBarOpt"}, state=true}
end

---------------------- OPTIONS GUI TAB 3 --------------------------
function GUI.createOptTab3(tab, player, MF)
	-- Jets --
	local JetSettingsL = tab.add{type="label", name="JetSettingsL", caption={"gui-description.JetOpt"}}
	JetSettingsL.style.font = "TitleFont"
	tab.add{type="label", caption={"gui-description.JetMaximalDistance"}}
	if MF.varTable.jets.mjMaxDistance == nil then MF.varTable.jets.mjMaxDistance = _MFMiningJetDefaultMaxDistance end
	if MF.varTable.jets.cjMaxDistance == nil then MF.varTable.jets.cjMaxDistance = _MFConstructionJetDefaultMaxDistance end
	if MF.varTable.jets.rjMaxDistance == nil then MF.varTable.jets.rjMaxDistance = _MFRepairJetDefaultMaxDistance end
	if MF.varTable.jets.cbjMaxDistance == nil then MF.varTable.jets.cbjMaxDistance = _MFCombatJetDefaultMaxDistance end
	GUI.createDTextField(tab, "MiningJetDistanceOpt", "MiningJetDistanceOpt", "MiningJetDistanceOptTT", MF.varTable.jets.mjMaxDistance)
	GUI.createDTextField(tab, "ConstructionJetDistanceOpt", "ConstructionJetMaximalDistance", "ConstructionJetMaximalDistanceTT", MF.varTable.jets.cjMaxDistance)
	GUI.createDTextField(tab, "RepairJetDistanceOpt", "RepairJetDistanceOpt", "RepairJetDistanceOptTT", MF.varTable.jets.rjMaxDistance)
	GUI.createDTextField(tab, "CombatJetDistanceOpt", "CombatJetDistanceOpt", "CombatJetDistanceOpt", MF.varTable.jets.cbjMaxDistance)

	-- Floor Is Lava --
	local FILSettingsL = tab.add{type="label", name="FILSettingsL", caption={"gui-description.FILOptTitle"}}
	FILSettingsL.style.font = "TitleFont"
	FILSettingsL.style.top_margin = 20
	local FILActivatedF = tab.add{type="flow", name="FILActivatedF", direction="horizontal"}
	FILActivatedF.add{type="checkbox", name="FloorIsLaveActiveOpt", tooltip={"gui-description.FloorIsLavaOptTT"}, state=global.floorIsLavaActivated, enabled=player.admin}
	FILActivatedF.add{type="label", caption={"gui-description.FloorIsLavaActOpt"}, tooltip={"gui-description.FloorIsLavaOptTT"}, enabled=player.admin}
	
end


---------------------- OPTIONS GUI TAB 2 --------------------------
function GUI.createOptTab2(tab, player)
	local SystemPerfGuiOpt = tab.add{type="label", name="SystemPerfGuiOpt", caption={"gui-description.PerfGuiOpt"}}
	SystemPerfGuiOpt.style.font = "TitleFont"
	GUI.createDTextField(tab, "SystemPerfEntsPerTick", "SystemPerfEntsPerTick", "SystemPerfEntsPerTickTT", global.entsUpPerTick, player.admin)
end

-- Create an option with decimal Textfield --
function GUI.createDTextField(GUI, name, caption, tooltip, text, enabled)
	if enabled == nil then enabled = true end
	local flow = GUI.add{type="flow", name=name .. "F", direction="horizontal"}
	flow.add{type="textfield", name=name .. "T", tooltip={"gui-description." .. tooltip}, text=text, numeric=true, allow_decimal=false, allow_negative=false, enabled=enabled}
	flow.add{type="label", name=name .. "L", caption={"gui-description." .. caption}, tooltip={"gui-description." .. tooltip}, enabled=enabled}
	flow[name .. "T"].style.width = 100
	flow[name .. "T"].style.left_margin = 5
end