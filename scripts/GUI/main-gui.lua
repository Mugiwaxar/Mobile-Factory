-- Create the Main GUI --
function GUI.createMainGUI(player, gui)
	
	-- Determine the GUI location with the screen resolution --
	local resolutionWidth = player.display_resolution.width -- / player.display_scale
	local resolutionHeight = player.display_resolution.height -- / player.display_scale
	local posX = resolutionWidth / 100 * 77.5
	local posY = 0 -- resolutionHeight / 100 * 35
	local iPosX = 200
	local iPosY = 200

	-- Verify if the Main GUI exist, save the positions and destroy it --
	if gui.screen.mfGUI ~= nil and gui.screen.mfGUI.valid == true then
		posX = gui.screen.mfGUI.location.x
		posY = gui.screen.mfGUI.location.y
		gui.screen.mfGUI.destroy()
	end

	-- Create the GUI --
	local mfGUI = gui.screen.add{type="frame", name="mfGUI", direction="vertical"}
	-- Set the GUI position end style --
	mfGUI.location = {posX, posY}
	mfGUI.style.padding = 0
	mfGUI.style.horizontal_align = "center"
	
	---------------------------------------------------- TOP FLOW ---------------------------------------------------
	
	-- Create the Menu Flow --
	local mfGUIMenuFrame = mfGUI.add{type="flow", name="mfGUIMenuFrame", direction="horizontal"}
	-- Set Style --
	mfGUIMenuFrame.style.padding = 0
	mfGUIMenuFrame.style.margin = 0
	mfGUIMenuFrame.style.horizontal_align = "right"
	mfGUIMenuFrame.style.minimal_width = 150

	-- Add MFInfos Button to top Flow --
	mfGUIMenuFrame.add{
		type="sprite-button",
		name="MFInfos",
		sprite="MFIconI",
		hovered_sprite="MFIconI",
		resize_to_sprite=false,
		tooltip={"gui-description.MFInfosButton"}
	}
	-- Set Style --
	mfGUIMenuFrame.MFInfos.style.maximal_width = 15
	mfGUIMenuFrame.MFInfos.style.maximal_height = 15
	mfGUIMenuFrame.MFInfos.style.padding = 0
	mfGUIMenuFrame.MFInfos.style.margin = 0
	
	-- Add MFInspect Button to top Flow --
	mfGUIMenuFrame.add{
		type="sprite-button",
		name="MFInspect",
		sprite="InspectI",
		resize_to_sprite=false,
		tooltip={"gui-description.MFInspectButton"}
	}
	-- Set Style --
	mfGUIMenuFrame.MFInspect.style.maximal_width = 15
	mfGUIMenuFrame.MFInspect.style.maximal_height = 15
	mfGUIMenuFrame.MFInspect.style.padding = 0
	mfGUIMenuFrame.MFInspect.style.margin = 0

	-- Add the Option Button to top Flow --
	mfGUIMenuFrame.add{
		type="sprite-button",
		name="optionButton",
		sprite="OptionIcon",
		resize_to_sprite=false,
		tooltip={"gui-description.optionButton"}
	}
	-- Set style --
	mfGUIMenuFrame.optionButton.style.maximal_width = 15
	mfGUIMenuFrame.optionButton.style.maximal_height = 15
	mfGUIMenuFrame.optionButton.style.padding = 0
	mfGUIMenuFrame.optionButton.style.margin = 0

	-- Add the move Button to top Flow --
	mfGUIMenuFrame.add{
		type="sprite-button",
		name="MoveButton",
		sprite="MoveIcon",
		hovered_sprite="MoveIconOv",
		resize_to_sprite=false,
		tooltip={"gui-description.moveGuiFrameButton"}
	}
	-- Set style --
	mfGUIMenuFrame.MoveButton.style.maximal_width = 15
	mfGUIMenuFrame.MoveButton.style.maximal_height = 15
	mfGUIMenuFrame.MoveButton.style.padding = 0
	
	-- Add the reduce Button to top Flow --
	mfGUIMenuFrame.add{
		type="sprite-button",
		name="ReduceButton",
		sprite="ArrowIconDown",
		hovered_sprite="ArrowIconDownOv",
		resize_to_sprite=false,
		tooltip={"gui-description.reduceButton"}
	}
	-- Set style --
	mfGUIMenuFrame.ReduceButton.style.maximal_width = 15
	mfGUIMenuFrame.ReduceButton.style.maximal_height = 15
	mfGUIMenuFrame.ReduceButton.style.right_margin = 0
	mfGUIMenuFrame.ReduceButton.style.padding = 0

---------------------------------------------- CENTER FLOW --------------------------------------------
	-- Create the center Flow --
	local mfGUICenterFrame = mfGUI.add{type="flow", name="mfGUICenterFrame", direction="vertical"}
	-- Set Style --
	mfGUICenterFrame.style.padding = 0
	mfGUICenterFrame.style.vertical_align = "top"
	
	
	-- Create position Labels --
	mfGUICenterFrame.add{type="label", name="mfposition"}
	mfGUICenterFrame.mfposition.style.font = "LabelFont"
	mfGUICenterFrame.mfposition.style.font_color = {39,239,0}
	mfGUICenterFrame.mfposition.style.margin = 0
	mfGUICenterFrame.mfposition.style.padding = 0
	
	-- Create health Labels --
	mfGUICenterFrame.add{type="label", name="mfHealth"}
	mfGUICenterFrame.mfHealth.style.font = "LabelFont"
	mfGUICenterFrame.mfHealth.style.font_color = {255,0,0}
	mfGUICenterFrame.mfHealth.style.margin = 0
	mfGUICenterFrame.mfHealth.style.padding = 0
	
	-- Create health ProgressBar -
	mfGUICenterFrame.add{type="progressbar", name="HealthBar"}
	mfGUICenterFrame.HealthBar.style.maximal_width = 150
	mfGUICenterFrame.HealthBar.style.color = {255, 0, 0}
	
	-- Create Shield Labels --
	mfGUICenterFrame.add{type="label", name="mfShield"}
	mfGUICenterFrame.mfShield.style.font = "LabelFont"
	mfGUICenterFrame.mfShield.style.font_color = {0,80,255}
	mfGUICenterFrame.mfShield.style.margin = 0
	mfGUICenterFrame.mfShield.style.padding = 0
	mfGUICenterFrame.mfShield.visible = false
	
	-- Create Shield ProgressBar -
	mfGUICenterFrame.add{type="progressbar", name="ShieldBar"}
	mfGUICenterFrame.ShieldBar.style.maximal_width = 150
	mfGUICenterFrame.ShieldBar.style.color = {0, 80, 255}
	mfGUICenterFrame.ShieldBar.visible = false
	
	-- Create JumpCharge Labels --
	mfGUICenterFrame.add{type="label", name="JumpCharge"}
	mfGUICenterFrame.JumpCharge.style.font = "LabelFont"
	mfGUICenterFrame.JumpCharge.style.font_color = {211,84,0}
	mfGUICenterFrame.JumpCharge.style.margin = 0
	mfGUICenterFrame.JumpCharge.style.padding = 0
	
	-- Create health ProgressBar -
	mfGUICenterFrame.add{type="progressbar", name="JumpChargeBar"}
	mfGUICenterFrame.JumpChargeBar.style.maximal_width = 150
	mfGUICenterFrame.JumpChargeBar.style.color = {211, 84, 0}
	
	-- Create Internal Energy Labels --
	mfGUICenterFrame.add{type="label", name="InernalEnergy"}
	mfGUICenterFrame.InernalEnergy.style.font = "LabelFont"
	mfGUICenterFrame.InernalEnergy.style.font_color = {230, 233, 37}
	mfGUICenterFrame.InernalEnergy.style.margin = 0
	mfGUICenterFrame.InernalEnergy.style.padding = 0
	
	-- Create Internal Energy ProgressBar -
	mfGUICenterFrame.add{type="progressbar", name="InternalEnergyBar"}
	mfGUICenterFrame.InternalEnergyBar.style.maximal_width = 150
	mfGUICenterFrame.InternalEnergyBar.style.color = {230, 233, 37}


	-- Create the bottom Flow --
	local mfGUIbottomFrame = mfGUI.add{type="flow", name="mfGUIbottomFrame", direction="vertical"}
	-- Set Style --
	mfGUIbottomFrame.style.horizontal_align = "center"
	mfGUIbottomFrame.style.horizontally_stretchable = true

	-- Create the bottom arrow --
	mfGUIbottomFrame.add{
		type="sprite-button",
		name="ArrowButton",
		sprite="ArrowIconDown",
		hovered_sprite="ArrowIconDownOv",
		resize_to_sprite=false,
		tooltip={"gui-description.openExtendedGui"}
	}
	mfGUIbottomFrame.ArrowButton.style.maximal_width = 100
	mfGUIbottomFrame.ArrowButton.style.maximal_height = 15
	
	
	--------------------------------- EXTENDED FRAME -------------------------------
	
	-- Create the extended frame --
	local mfGUIExtendedFrame = mfGUI.add{type="frame", name="mfGUIExtendedFrame", direction="vertical"}
	-- Set Visibility --
	mfGUIExtendedFrame.visible = false
	mfGUIExtendedFrame.style.padding = 0
	mfGUIExtendedFrame.style.margin = 0
	-- Set Style --
	mfGUIExtendedFrame.style.horizontally_stretchable = true
	
	----------- FLOWS ------------
	
	-- Create the extended frame first flow --
	local mfGUIExtFF1 = mfGUIExtendedFrame.add{type="flow", name="mfGUIExtFF1", direction="horizontal"}
	-- Set Style --
	mfGUIExtFF1.style.padding = 0
	mfGUIExtFF1.style.margin = 0
	mfGUIExtFF1.style.horizontal_align = "left"
	mfGUIExtFF1.style.vertical_align = "top"
	
	-- Create the extended frame second flow --
	local mfGUIExtFF2 = mfGUIExtendedFrame.add{type="flow", name="mfGUIExtFF2", direction="horizontal"}
	-- Set Style --
	mfGUIExtFF2.style.padding = 0
	mfGUIExtFF2.style.margin = 0
	mfGUIExtFF2.style.horizontal_align = "left"
	mfGUIExtFF2.style.vertical_align = "top"
	
	-- Create the extended frame third flow --
	-- local mfGUIExtFF3 = mfGUIExtendedFrame.add{type="flow", name="mfGUIExtFF3", direction="horizontal"}
	-- Set Style --
	-- mfGUIExtFF3.style.padding = 0
	-- mfGUIExtFF3.style.margin = 0
	-- mfGUIExtFF3.style.horizontal_align = "left"
	-- mfGUIExtFF3.style.vertical_align = "top"
	
	
	------------ BUTTONS ---------
	
	
	-- Add CallMF Button --
	mfGUIExtFF1.add{
		type="sprite-button",
		name="CallMF",
		sprite="MFIcon",
		hovered_sprite="MFIcon",
		resize_to_sprite=false,
		tooltip={"gui-description.callMFButton"}
	}
	-- Set Style --
	mfGUIExtFF1.CallMF.style.maximal_height = _GUIButtonsSize
	mfGUIExtFF1.CallMF.style.maximal_width = _GUIButtonsSize
	
	-- Add PortOutside Button --
	mfGUIExtFF1.add{
		type="sprite-button",
		name="PortOutside",
		sprite="PortIcon",
		hovered_sprite="PortIcon",
		resize_to_sprite=false,
		tooltip={"gui-description.teleportOutsideButton"},
		visible=false
	}
	-- Set Style --
	mfGUIExtFF1.PortOutside.style.maximal_height = _GUIButtonsSize
	mfGUIExtFF1.PortOutside.style.maximal_width = _GUIButtonsSize
	
	-- Add FindMF Button --
	mfGUIExtFF1.add{
		type="sprite-button",
		name="FindMF",
		sprite="MFIconExc",
		hovered_sprite="MFIconExc",
		resize_to_sprite=false,
		visible = false,
		tooltip={"gui-description.fixMFButton"}
	}
	-- Set Style --
	mfGUIExtFF1.FindMF.style.maximal_height = _GUIButtonsSize
	mfGUIExtFF1.FindMF.style.maximal_width = _GUIButtonsSize
	
	-- Add MFTPInside Button --
	mfGUIExtFF1.add{
		type="sprite-button",
		name="MFTPInside",
		sprite="MFTPIcon",
		hovered_sprite="MFTPIcon",
		resize_to_sprite=false,
		tooltip={"gui-description.MFTPInside"}
	}
	-- Set Style --
	mfGUIExtFF1.MFTPInside.style.maximal_height = _GUIButtonsSize
	mfGUIExtFF1.MFTPInside.style.maximal_width = _GUIButtonsSize

	-- Add MFLock Button --
	mfGUIExtFF1.add{
		type="sprite-button",
		name="MFLock",
		sprite="LockMFCIcon",
		hovered_sprite="LockMFOIcon",
		resize_to_sprite=false,
		tooltip={"gui-description.LockMF"}
	}
	-- Set Style --
	mfGUIExtFF1.MFLock.style.maximal_height = _GUIButtonsSize
	mfGUIExtFF1.MFLock.style.maximal_width = _GUIButtonsSize
	
	-- Add EnergyDrain Button --
	mfGUIExtFF2.add{
		type="sprite-button",
		name="EnergyDrain",
		sprite="EnergyDrainIcon",
		hovered_sprite="EnergyDrainIconDisabled",
		resize_to_sprite=false,
		tooltip={"gui-description.mfEnergyDrainButton"},
		visible=false
	}
	-- Set Style --
	mfGUIExtFF2.EnergyDrain.style.maximal_height = _GUIButtonsSize
	mfGUIExtFF2.EnergyDrain.style.maximal_width = _GUIButtonsSize
	
	-- Add FluidDrain Button --
	mfGUIExtFF2.add{
		type="sprite-button",
		name="FluidDrain",
		sprite="FluidDrainIcon",
		hovered_sprite="FluidDrainIconDisabled",
		resize_to_sprite=false,
		tooltip={"gui-description.mfFluidDrainButton"},
		visible=false
	}
	-- Set Style --
	mfGUIExtFF2.FluidDrain.style.maximal_height = _GUIButtonsSize
	mfGUIExtFF2.FluidDrain.style.maximal_width = _GUIButtonsSize
	
	-- Add Item Drain Button --
	mfGUIExtFF2.add{
		type="sprite-button",
		name="ItemDrain",
		sprite="ItemDrainIcon",
		hovered_sprite="ItemDrainIconDisabled",
		resize_to_sprite=false,
		tooltip={"gui-description.mfItemDrainButton"},
		visible=false
	}
	-- Set Style --
	mfGUIExtFF2.ItemDrain.style.maximal_height = _GUIButtonsSize
	mfGUIExtFF2.ItemDrain.style.maximal_width = _GUIButtonsSize
	
	-- Add EnergyDistribution Button --
	mfGUIExtFF2.add{
		type="sprite-button",
		name="EnergyDistribution",
		sprite="EnergyDistributionIcon",
		hovered_sprite="EnergyDistributionIconDisabled",
		resize_to_sprite=false,
		tooltip={"gui-description.mfDistribute"},
		visible=false
	}
	-- Set Style --
	mfGUIExtFF2.EnergyDistribution.style.maximal_height = _GUIButtonsSize
	mfGUIExtFF2.EnergyDistribution.style.maximal_width = _GUIButtonsSize
	
	-- Add Send Quatron Button --
	mfGUIExtFF2.add{
		type="sprite-button",
		name="SendQuatron",
		sprite="QuatronIcon",
		hovered_sprite="QuatronIconDisabled",
		resize_to_sprite=false,
		tooltip={"gui-description.mfSendQuatron"},
		visible=false
	}
	-- Set Style --
	mfGUIExtFF2.SendQuatron.style.maximal_height = _GUIButtonsSize
	mfGUIExtFF2.SendQuatron.style.maximal_width = _GUIButtonsSize

end

function GUI.mainGUIUpdate(player)

	-- Get the Mobile Factory --
	local MF = getMF(player.name)
	if MF == nil then return end

-- Update the Mobile Factory positions --
	if MF ~= nil and MF.ent ~= nil and MF.ent.valid then
		player.gui.screen.mfGUI.mfGUICenterFrame.mfposition.caption = {"", {"gui-description.mfPosition"}, ": (", math.floor(MF.ent.position.x), " ; ", math.floor(MF.ent.position.y), ")  ", MF.ent.surface.name}
	else
		player.gui.screen.mfGUI.mfGUICenterFrame.mfposition.caption = {"", {"gui-description.mfPosition"}, ": ", {"gui-description.Unknow"}}
	end
	if MF ~= nil and MF.ent ~= nil and MF.ent.valid then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfposition.caption = {"", {"gui-description.mfPosition"}, ": (", math.floor(MF.ent.position.x), " ; ", math.floor(MF.ent.position.y), ")  ", MF.ent.surface.name}
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfposition.caption = {"", {"gui-description.mfPosition"}, ": ", {"gui-description.Unknow"}}
	end

	-- Update the Mobile Factory health --
	if MF ~= nil and MF.ent ~= nil and MF.ent.valid then
		player.gui.screen.mfGUI.mfGUICenterFrame.mfHealth.caption = {"", {"gui-description.mfHealth"}, ": ", math.floor(MF.ent.health), "/", MF.ent.prototype.max_health}
		player.gui.screen.mfGUI.mfGUICenterFrame.HealthBar.value = MF.ent.health / MF.ent.prototype.max_health
	else
		player.gui.screen.mfGUI.mfGUICenterFrame.mfHealth.caption = {"", {"gui-description.mfHealth"}, ": ", {"gui-description.Unknow"}}
	end
	if MF ~= nil and MF.ent ~= nil and MF.ent.valid then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfHealth.caption = {"", {"gui-description.mfHealth"}, ": ", math.floor(MF.ent.health), "/", MF.ent.prototype.max_health}
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.HealthBar.value = MF.ent.health / MF.ent.prototype.max_health
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfHealth.caption = {"", {"gui-description.mfHealth"}, ": ", {"gui-description.Unknow"}}
	end
	
	-- Update the Mobile Factory Shield --
	if MF:maxShield() > 0 then
		if player.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab1Frame.mfOptTab1Pane.GUIShieldOpt.state == true then
			player.gui.screen.mfGUI.mfGUICenterFrame.mfShield.visible = true
		end
		if player.gui.screen.mfOptionGUI.mfOptTabbedPane.mfOptTab1Frame.mfOptTab1Pane.GUIShieldBarOpt.state == true then
			player.gui.screen.mfGUI.mfGUICenterFrame.ShieldBar.visible = true
		end
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfShield.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ShieldBar.visible = true
		if MF ~= nil and MF.ent ~= nil and MF.ent.valid then
			player.gui.screen.mfGUI.mfGUICenterFrame.mfShield.caption = {"", {"gui-description.mfShield"}, ": ", math.floor(MF:shield()), "/", MF:maxShield()}
			player.gui.screen.mfGUI.mfGUICenterFrame.ShieldBar.value = MF:shield() / MF:maxShield()
		else
			player.gui.screen.mfGUI.mfGUICenterFrame.mfShield.caption = {"", {"gui-description.mfShield"}, ": ", {"gui-description.Unknow"}}
		end
		if MF ~= nil and MF.ent ~= nil and MF.ent.valid then
			player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfShield.caption = {"", {"gui-description.mfShield"}, ": ", math.floor(MF:shield()), "/", MF:maxShield()}
			player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ShieldBar.value = MF:shield() / MF:maxShield()
		else
			player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfShield.caption = {"", {"gui-description.mfShield"}, ": ", {"gui-description.Unknow"}}
		end
	else
		player.gui.screen.mfGUI.mfGUICenterFrame.mfShield.visible = false
		player.gui.screen.mfGUI.mfGUICenterFrame.ShieldBar.visible = false
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfShield.visible = false
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ShieldBar.visible = false
	end
	
	-- Update the Mobile Factory Jump Charge --
	if MF ~= nil and MF.ent ~= nil and MF.ent.valid then
		local chargePercent = math.floor(100 - MF.jumpTimer / MF.baseJumpTimer * 100)
		player.gui.screen.mfGUI.mfGUICenterFrame.JumpCharge.caption = {"", {"gui-description.mfJumpTimer"}, ": ", chargePercent, "% (", MF.jumpTimer, "s)"}
		player.gui.screen.mfGUI.mfGUICenterFrame.JumpChargeBar.value = chargePercent / 100
	else
		player.gui.screen.mfGUI.mfGUICenterFrame.JumpCharge.caption = {"", {"gui-description.mfJumpTimer"}, ": ", {"gui-description.Unknow"}}
	end
	if MF ~= nil and MF.ent ~= nil and MF.ent.valid then
		local chargePercent = math.floor(100 - MF.jumpTimer / MF.baseJumpTimer * 100)
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.JumpCharge.caption = {"", {"gui-description.mfJumpTimer"}, ": ", chargePercent, "% (", MF.jumpTimer, "s)"}
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.JumpChargeBar.value = chargePercent / 100
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.JumpCharge.caption = {"", {"gui-description.mfJumpTimer"}, ": ", {"gui-description.Unknow"}}
	end
	
	-- Update the Mobile Factory Internal Energy Charge --
	if MF ~= nil and MF.ent ~= nil and MF.ent.valid then
		local chargePercent = math.floor(100 - MF.internalEnergy / MF.maxInternalEnergy * 100)
		player.gui.screen.mfGUI.mfGUICenterFrame.InernalEnergy.caption = {"", {"gui-description.mfEnergyCharge"}, ": ", Util.toRNumber(MF.internalEnergy), "J/", Util.toRNumber(MF.maxInternalEnergy), "J"}
		player.gui.screen.mfGUI.mfGUICenterFrame.InternalEnergyBar.value = 1 - chargePercent / 100
	else
		player.gui.screen.mfGUI.mfGUICenterFrame.InernalEnergy.caption = {"", {"gui-description.mfEnergyCharge"}, ": ", {"gui-description.Unknow"}}
	end
	if MF ~= nil and MF.ent ~= nil and MF.ent.valid then
		local chargePercent = math.floor(100 - MF.internalEnergy / MF.maxInternalEnergy * 100)
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.InernalEnergy.caption = {"", {"gui-description.mfEnergyCharge"}, ": ", Util.toRNumber(MF.internalEnergy), "J/", Util.toRNumber(MF.maxInternalEnergy), "J"}
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.InternalEnergyBar.value = 1 - chargePercent / 100
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.InernalEnergy.caption = {"", {"gui-description.mfEnergyCharge"}, ": ", {"gui-description.Unknow"}}
	end
	
	-- Update the CallMF Button --
	if Util.isOutside(player) == false then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.CallMF.visible = false
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.CallMF.visible = true
	end
	
	-- Update the PortOutside button --
	if Util.isOutside(player) == false then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.PortOutside.visible = true
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.PortOutside.visible = false
	end
	
	-- Update the FindMF Button --
	player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.FindMF.visible = false
	
	if MF == nil or MF.ent == nil then player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.FindMF.visible = true end
	if MF.ent ~= nil and MF.ent.valid == false then player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.FindMF.visible = true end
	if MF.fS == nil or MF.fS.valid == false then player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.FindMF.visible = true end
	if (MF.ccS == nil or MF.ccS.valid == false) and technologyUnlocked("ControlCenter") then player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.FindMF.visible = true end
	
	-- Update the MFTPInside Icone --
	if MF.tpEnabled == true then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.MFTPInside.sprite = "MFTPIcon"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.MFTPInside.hovered_sprite = "MFTPIconDisabled"
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.MFTPInside.sprite = "MFTPIconDisabled"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.MFTPInside.hovered_sprite = "MFTPIcon"
	end

	-- Update the MFLock Icone --
	if MF.locked == true then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.MFLock.sprite = "LockMFCIcon"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.MFLock.hovered_sprite = "LockMFOIcon"
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.MFLock.sprite = "LockMFOIcon"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.MFLock.hovered_sprite = "LockMFCIcon"
	end

	-- Update Energy Drain Button --
	if technologyUnlocked("EnergyDrain1") then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDrain.visible = true
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDrain.visible = false 
	end
	
	-- Update Fluid Drain Button --
	if technologyUnlocked("FluidDrain1") then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.FluidDrain.visible = true
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.FluidDrain.visible = false 
	end
	
	-- Update Item Drain Button --
	if technologyUnlocked("TechItemDrain") then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.ItemDrain.visible = true
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.ItemDrain.visible = false 
	end
	
	-- Update Energy Distribution Button --
	if technologyUnlocked("EnergyDistribution1") then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDistribution.visible = true
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDistribution.visible = false 
	end
	
	-- Update Send Quatron Button --
	if technologyUnlocked("OreCleaner") or technologyUnlocked("FluidExtractor") then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.SendQuatron.visible = true
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.SendQuatron.visible = false 
	end

	-- Update the Energy Drain Icon --
	if MF.energyLaserActivated == true then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDrain.sprite = "EnergyDrainIcon"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDrain.hovered_sprite = "EnergyDrainIconDisabled"
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDrain.sprite = "EnergyDrainIconDisabled"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDrain.hovered_sprite = "EnergyDrainIcon"
	end
	
	-- Update the Fluid Drain Icon --
	if MF.fluidLaserActivated == true then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.FluidDrain.sprite = "FluidDrainIcon"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.FluidDrain.hovered_sprite = "FluidDrainIconDisabled"
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.FluidDrain.sprite = "FluidDrainIconDisabled"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.FluidDrain.hovered_sprite = "FluidDrainIcon"
	end
	
	-- Update the Item Drain Icon --
	if MF.itemLaserActivated == true then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.ItemDrain.sprite = "ItemDrainIcon"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.ItemDrain.hovered_sprite = "ItemDrainIconDisabled"
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.ItemDrain.sprite = "ItemDrainIconDisabled"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.ItemDrain.hovered_sprite = "ItemDrainIcon"
	end
	
	-- Update Energy Distribution Icon --
	if MF.internalEnergyDistributionActivated == true then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDistribution.sprite = "EnergyDistributionIcon"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDistribution.hovered_sprite = "EnergyDistributionIconDisabled"
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDistribution.sprite = "EnergyDistributionIconDisabled"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDistribution.hovered_sprite = "EnergyDistributionIcon"
	end
	
	-- Update Send Quatron Icon --
	if MF.sendQuatronActivated == true then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.SendQuatron.sprite = "QuatronIcon"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.SendQuatron.hovered_sprite = "QuatronIconDisabled"
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.SendQuatron.sprite = "QuatronIconDisabled"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.SendQuatron.hovered_sprite = "QuatronIcon"
	end
end