-- Read changed Options from the Options GUI --
function GUI.readOptions(option, player, gui)
	local name = option.name
	-- Main GUI --
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
	-- Game --
	if name == "MiningJetDistanceOpt" then
		global.mjMaxDistance = tonumber(option.text)
	end
	if name == "ConstructionJetDistanceOpt" then
		global.cjMaxDistance = tonumber(option.text)
	end
	if name == "RepairJetDistanceOpt" then
		global.rjMaxDistance = tonumber(option.text)
	end
	if name == "CombatJetDistanceOpt" then
		global.cbjMaxDistance = tonumber(option.text)
	end
	-- Performances --
	if name == "SystemPerfEntsPerTick" then
		local number = tonumber(option.text)
		if number == nil then return end
		number = math.max(number, 10)
		number = math.min(number, 10000)
		global.entsUpPerTick = number
	end
end