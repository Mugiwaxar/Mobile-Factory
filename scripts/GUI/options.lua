-- Read changed Options from the Options GUI --
function GUI.readOptions(option, player, gui)
	local name = option.name

	-- Get the Mobile Factory --
	local MF = getMF(player.name)
	if MF == nil then return end

	------------------- MF -------------------
	if name == "MFShareOpt" then
		MF.varTable.shareStructures = option.state
	end
	if name == "MFUseShareOpt" then
		MF.varTable.useSharedStructures = option.state
	end
	if name == "MFShareSettingOpt" then
		MF.varTable.allowToModify = option.state
	end

	------------------- Main GUI -------------------
	if name == "GUIPosOpt" then
		player.gui.screen.mfGUI.mfGUICenterFrame.mfposition.visible = player.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab1Frame.mfOptTab1Pane.GUIPosOpt.state
	end
	if name == "GUIHealthOpt" then
		player.gui.screen.mfGUI.mfGUICenterFrame.mfHealth.visible = player.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab1Frame.mfOptTab1Pane.GUIHealthOpt.state
	end
	if name == "GUIHealthBarOpt" then
		player.gui.screen.mfGUI.mfGUICenterFrame.HealthBar.visible = player.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab1Frame.mfOptTab1Pane.GUIHealthBarOpt.state
	end
	if name == "GUIShieldOpt" then
		player.gui.screen.mfGUI.mfGUICenterFrame.mfShield.visible = player.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab1Frame.mfOptTab1Pane.GUIShieldOpt.state
	end
	if name == "GUIShieldBarOpt" then
		player.gui.screen.mfGUI.mfGUICenterFrame.ShieldBar.visible = player.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab1Frame.mfOptTab1Pane.GUIShieldBarOpt.state
	end
	if name == "GUIJumpDriveOpt" then
		player.gui.screen.mfGUI.mfGUICenterFrame.JumpCharge.visible = player.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab1Frame.mfOptTab1Pane.GUIJumpDriveOpt.state
	end
	if name == "GUIJumpDriveBarOpt" then
		player.gui.screen.mfGUI.mfGUICenterFrame.JumpChargeBar.visible = player.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab1Frame.mfOptTab1Pane.GUIJumpDriveBarOpt.state
	end
	if name == "GUIEnergyOpt" then
		player.gui.screen.mfGUI.mfGUICenterFrame.InernalEnergy.visible = player.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab1Frame.mfOptTab1Pane.GUIEnergyOpt.state
	end
	if name == "GUIEnergyBarOpt" then
		player.gui.screen.mfGUI.mfGUICenterFrame.InternalEnergyBar.visible = player.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab1Frame.mfOptTab1Pane.GUIEnergyBarOpt.state
	end

	------------------- Game -------------------
	if name == "MiningJetDistanceOptT" then
		MF.varTable.jets.mjMaxDistance = tonumber(option.text)
	end
	if name == "ConstructionJetDistanceOptT" then
		MF.varTable.jets.cjMaxDistance = tonumber(option.text)
	end
	if name == "RepairJetDistanceOptT" then
		MF.varTable.jets.rjMaxDistance = tonumber(option.text)
	end
	if name == "CombatJetDistanceOptT" then
		MF.varTable.jets.cbjMaxDistance = tonumber(option.text)
	end
	if name == "FloorIsLaveActiveOpt" then
		global.floorIsLavaActivated = option.state
		if global.floorIsLavaActivated == true then
			game.print({"gui-description.FloorIsLavaActivated"})
		else
			game.print({"gui-description.FloorIsLavaDeactivated"})
		end
		for k, player2 in pairs(game.players) do
			player2.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab3Frame.mfOptTab3Pane.FILActivatedF.FloorIsLaveActiveOpt.state = option.state
		end
	end
	
	------------------- Performances -------------------
	if name == "SystemPerfEntsPerTickT" then
		local number = tonumber(option.text)
		if number == nil then return end
		number = math.max(number, 10)
		number = math.min(number, 10000)
		global.entsUpPerTick = number
		game.print({"", {"gui-description.EntitiesUpdatePerTickNumber"}, " ", number})
		for k, player2 in pairs(game.players) do
			player2.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab2Frame.mfOptTab2Pane.SystemPerfEntsPerTickF.SystemPerfEntsPerTickT.text = option.text
		end
	end
end