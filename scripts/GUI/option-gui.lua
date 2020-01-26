-- Create the Option GUI --
function GUI.createOptionGUI(gui, player)

	-- Verify if the Option GUI exist, else destroy it --
	if gui.screen.mfOptionGUI ~= nil and gui.screen.mfOptionGUI.valid == true then
		gui.screen.mfOptionGUI.destroy()
	end
	
	-- Create the GUI --
	local mfOptionGUI = gui.screen.add{type="frame", name="mfOptionGUI", direction="vertical"}
	
	-- Calcule the position --
	local resolutionWidth = player.display_resolution.width  / player.display_scale
	local resolutionHeight = player.display_resolution.height  / player.display_scale
	local posX = resolutionWidth / 100 * 45
	local posY = resolutionHeight / 100 * 18
	local width = 350
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
	GUI.createOptTab3(mfOptTab3Pane)
	
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
	GUI.createOptTab2(mfOptTab2Pane)

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
function GUI.createOptTab3(tab)
	local GUIMainGuiOpt = tab.add{type="label", name="GUIMainGuiOpt", caption={"gui-description.JetOpt"}}
	GUIMainGuiOpt.style.font = "TitleFont"
	tab.add{type="label", caption={"gui-description.JetMaximalDistance"}}
	GUI.createDTextField(tab, "MiningJetDistanceOpt", "MiningJetDistanceOpt", "MiningJetDistanceOptTT", global.mjMaxDistance)
	GUI.createDTextField(tab, "ConstructionJetDistanceOpt", "ConstructionJetMaximalDistance", "ConstructionJetMaximalDistanceTT", global.cjMaxDistance)
	GUI.createDTextField(tab, "RepairJetDistanceOpt", "RepairJetDistanceOpt", "RepairJetDistanceOptTT", global.rjMaxDistance)
	GUI.createDTextField(tab, "CombatJetDistanceOpt", "CombatJetDistanceOpt", "CombatJetDistanceOpt", global.cbjMaxDistance)
end


---------------------- OPTIONS GUI TAB 2 --------------------------
function GUI.createOptTab2(tab)
	local SystemPerfGuiOpt = tab.add{type="label", name="SystemPerfGuiOpt", caption={"gui-description.GUIPerfGuiOpt"}}
	SystemPerfGuiOpt.style.font = "TitleFont"
	GUI.createDTextField(tab, "SystemPerfEntsPerTick", "SystemPerfEntsPerTick", "SystemPerfEntsPerTickTT", global.entsUpPerTick)
end

-- Create an option with decimal Textfield --
function GUI.createDTextField(GUI, name, caption, tooltip, text)
	local flow = GUI.add{type="flow", direction="horizontal"}
	flow.add{type="textfield", name=name, tooltip={"gui-description." .. tooltip}, text=text, numeric=true, allow_decimal=false, allow_negative=false}	
	flow.add{type="label", caption={"gui-description." .. caption}, tooltip={"gui-description." .. tooltip}}
	flow[name].style.width = 100
	flow[name].style.left_margin = 5
end























