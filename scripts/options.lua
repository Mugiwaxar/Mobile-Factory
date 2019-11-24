-- Read changed Options from the Options GUI --
function readOptions(option, player, gui)
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
end