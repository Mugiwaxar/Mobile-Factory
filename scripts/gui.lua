---------------------------------------------------------------------------------------------------------
---------------------------------------------------- MAIN GUI -------------------------------------------
---------------------------------------------------------------------------------------------------------
function createPlayerGui(player)

	-- Get the GUI --
	local gui = player.gui
	
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
	
	-- Verify if the Info GUI exist, save the positions and destroy it --
	if gui.screen.mfInfoGUI ~= nil and gui.screen.mfInfoGUI.valid == true then
		iPosX = gui.screen.mfInfoGUI.location.x
		iPosY = gui.screen.mfInfoGUI.location.y
		gui.screen.mfInfoGUI.destroy()
	end
	
	-- Verify if the Option GUI exist, else destroy it --
	if gui.screen.mfOptionGUI ~= nil and gui.screen.mfOptionGUI.valid == true then
		gui.screen.mfOptionGUI.destroy()
	end

	-- Create the GUI --
	local mfGUI = gui.screen.add{type="frame", name="mfGUI", direction="vertical"}
	-- Set the GUI position end style --
	mfGUI.location = {posX, posY}
	mfGUI.style.padding = 0
	mfGUI.style.horizontal_align = "center"
	
	createInfosWindows(gui, iPosX, iPosY)
	createOptionGUI(gui, player)
	
	---------------------------------------------------- TOP FLOW ---------------------------------------------------
	
	-- Create the top Flow --
	local mfGUITopFrame = mfGUI.add{type="flow", name="mfGUITopFrame", direction="horizontal"}
	-- Set Style --
	mfGUITopFrame.style.padding = 0
	mfGUITopFrame.style.margin = 0
	
	-- Add Title to top Flow  --
	mfGUITopFrame.add{
		type="label",
		name="guiTitle",
		caption={"gui-description.MobileFactoryTitle"}
	}
	-- Set style --
	mfGUITopFrame.guiTitle.style.font = "TitleFont"
	mfGUITopFrame.guiTitle.style.padding = 0
	mfGUITopFrame.guiTitle.style.right_margin = 0
	mfGUITopFrame.guiTitle.style.top_margin = 0
	--mfGUITopFrame.guiTitle.style.font_color = {135,25,20}

	-- Add the move Button to top Flow --
	mfGUITopFrame.add{
		type="sprite-button",
		name="MoveButton",
		sprite="MoveIcon",
		hovered_sprite="MoveIconOv",
		resize_to_sprite=false,
		tooltip={"gui-description.moveGuiFrameButton"}
	}
	-- Set style --
	mfGUITopFrame.MoveButton.style.maximal_width = 15
	mfGUITopFrame.MoveButton.style.maximal_height = 15
	mfGUITopFrame.MoveButton.style.padding = 0
	
	-- Add the reduce Button to top Flow --
	mfGUITopFrame.add{
		type="sprite-button",
		name="ReduceButton",
		sprite="ArrowIconDown",
		hovered_sprite="ArrowIconDownOv",
		resize_to_sprite=false,
		tooltip={"gui-description.reduceButton"}
	}
	-- Set style --
	mfGUITopFrame.ReduceButton.style.maximal_width = 15
	mfGUITopFrame.ReduceButton.style.maximal_height = 15
	mfGUITopFrame.ReduceButton.style.right_margin = 0
	mfGUITopFrame.ReduceButton.style.padding = 0


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
	
	-- Add MFInfos Button --
	mfGUIExtFF1.add{
		type="sprite-button",
		name="MFInfos",
		sprite="MFIconI",
		hovered_sprite="MFIconI",
		resize_to_sprite=false,
		tooltip={"gui-description.MFInfosButton"}
	}
	-- Set Style --
	mfGUIExtFF1.MFInfos.style.maximal_height = _GUIButtonsSize
	mfGUIExtFF1.MFInfos.style.maximal_width = _GUIButtonsSize
	
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
	
end

---------------------------------------------------------------------------------------------------------
----------------------------------------------- INFORMATIONS GUI ----------------------------------------
---------------------------------------------------------------------------------------------------------
function createInfosWindows(gui, posX, posY)
	-- Create the GUI --
	local mfInfoGUI = gui.screen.add{type="frame", name="mfInfoGUI", direction="vertical"}
	
	-- Set the GUI position end style --
	mfInfoGUI.caption = "Mobile Factory"
	mfInfoGUI.location = {posX, posY}
	mfInfoGUI.style.padding = 5
	mfInfoGUI.visible = false
	
	-- Create the Menu Bar --
	local mfGUIMenuBar = mfInfoGUI.add{type="flow", name="mfGUIMenuBar", direction="horizontal"}
	-- Set Style --
	mfGUIMenuBar.style.width = 1173
	mfGUIMenuBar.style.padding = 0
	mfGUIMenuBar.style.margin = 0
	mfGUIMenuBar.style.horizontal_align = "right"
	mfGUIMenuBar.style.vertical_align = "top"
	
	-- Add the Option Button to top Flow --
	mfGUIMenuBar.add{
		type="sprite-button",
		name="optionButton",
		sprite="OptionIcon",
		resize_to_sprite=false,
		tooltip={"gui-description.optionButton"}
	}
	-- Set style --
	mfGUIMenuBar.optionButton.style.maximal_width = 15
	mfGUIMenuBar.optionButton.style.maximal_height = 15
	mfGUIMenuBar.optionButton.style.padding = 0
	mfGUIMenuBar.optionButton.style.margin = 0
	
	-- Add the close Button to top Flow --
	mfGUIMenuBar.add{
		type="sprite-button",
		name="CloseButton",
		sprite="CloseIcon",
		resize_to_sprite=false,
		tooltip={"gui-description.closeButton"}
	}
	-- Set style --
	mfGUIMenuBar.CloseButton.style.maximal_width = 15
	mfGUIMenuBar.CloseButton.style.maximal_height = 15
	mfGUIMenuBar.CloseButton.style.padding = 0
	mfGUIMenuBar.CloseButton.style.margin = 0
	
	-- Create the Main Flow --
	local mfInfoMainFlow = gui.screen.mfInfoGUI.add{type="frame", name="mfInfoMainFlow", direction="horizontal"}
	mfInfoMainFlow.style.width = 1173
	mfInfoMainFlow.style.height = 750
	
	------------------------------------------ FLOW 1 -------------------------------------
	
	-- Create First Flow --
	local mfInfoFlow1 = mfInfoMainFlow.add{type="frame", name="mfInfoFlow1", direction="vertical"}
	mfInfoFlow1.style.height = 732
	
	-- Create Infos Title Label --
	mfInfoFlow1.add{type="label", name="mfInfosTitle"}
	mfInfoFlow1.mfInfosTitle.style.font = "TitleFont"
	mfInfoFlow1.mfInfosTitle.caption = {"gui-description.mfInfosTitle"}

	-- Create position Labels --
	mfInfoFlow1.add{type="label", name="mfposition"}
	mfInfoFlow1.mfposition.style.font = "LabelFont"
	mfInfoFlow1.mfposition.style.font_color = {108, 114, 229}
	mfInfoFlow1.mfposition.style.margin = 0
	mfInfoFlow1.mfposition.style.padding = 0
	
	-- Create health Labels --
	mfInfoFlow1.add{type="label", name="mfHealth"}
	mfInfoFlow1.mfHealth.style.font = "LabelFont"
	mfInfoFlow1.mfHealth.style.font_color = {255,0,0}
	mfInfoFlow1.mfHealth.style.margin = 0
	mfInfoFlow1.mfHealth.style.padding = 0
	
	-- Create health ProgressBar -
	mfInfoFlow1.add{type="progressbar", name="HealthBar"}
	mfInfoFlow1.HealthBar.style.maximal_width = 250
	mfInfoFlow1.HealthBar.style.color = {255, 0, 0}
	
	-- Create shield Labels --
	mfInfoFlow1.add{type="label", name="mfShield"}
	mfInfoFlow1.mfShield.style.font = "LabelFont"
	mfInfoFlow1.mfShield.style.font_color = {0,80,255}
	mfInfoFlow1.mfShield.style.margin = 0
	mfInfoFlow1.mfShield.style.padding = 0
	mfInfoFlow1.mfShield.visible = false
	
	-- Create shield ProgressBar -
	mfInfoFlow1.add{type="progressbar", name="ShieldBar"}
	mfInfoFlow1.ShieldBar.style.maximal_width = 250
	mfInfoFlow1.ShieldBar.style.color = {0,80,255}
	mfInfoFlow1.ShieldBar.visible = false
	
	-- Create JumpCharge Labels --
	mfInfoFlow1.add{type="label", name="JumpCharge"}
	mfInfoFlow1.JumpCharge.style.font = "LabelFont"
	mfInfoFlow1.JumpCharge.style.font_color = {211,84,0}
	mfInfoFlow1.JumpCharge.style.margin = 0
	mfInfoFlow1.JumpCharge.style.padding = 0
	
	-- Create health ProgressBar -
	mfInfoFlow1.add{type="progressbar", name="JumpChargeBar"}
	mfInfoFlow1.JumpChargeBar.style.maximal_width = 250
	mfInfoFlow1.JumpChargeBar.style.color = {211, 84, 0}
	
	-- Create Internal Energy Labels --
	mfInfoFlow1.add{type="label", name="InernalEnergy"}
	mfInfoFlow1.InernalEnergy.style.font = "LabelFont"
	mfInfoFlow1.InernalEnergy.style.font_color = {230, 233, 37}
	mfInfoFlow1.InernalEnergy.style.margin = 0
	mfInfoFlow1.InernalEnergy.style.padding = 0
	
	-- Create Internal Energy ProgressBar -
	mfInfoFlow1.add{type="progressbar", name="InternalEnergyBar"}
	mfInfoFlow1.InternalEnergyBar.style.maximal_width = 250
	mfInfoFlow1.InternalEnergyBar.style.color = {230, 233, 37}
	
	-- Create Energy Radius Label --
	mfInfoFlow1.add{type="label", name="EnergyRadiusLabel"}
	mfInfoFlow1.EnergyRadiusLabel.style.font = "LabelFont"
	mfInfoFlow1.EnergyRadiusLabel.visible = false
	mfInfoFlow1.EnergyRadiusLabel.style.top_margin = 25
	mfInfoFlow1.EnergyRadiusLabel.style.font_color = {230, 233, 37}
	
	-- Create Energy Radius Multiplier Label --
	mfInfoFlow1.add{type="label", name="EnergyRadiusMLabel"}
	mfInfoFlow1.EnergyRadiusMLabel.style.font = "LabelFont"
	mfInfoFlow1.EnergyRadiusMLabel.visible = false
	mfInfoFlow1.EnergyRadiusMLabel.style.font_color = {230, 233, 37}
	
	-- Create Energy Laser Label --
	mfInfoFlow1.add{type="label", name="EnergyLaserLabel"}
	mfInfoFlow1.EnergyLaserLabel.style.font = "LabelFont"
	mfInfoFlow1.EnergyLaserLabel.visible = false
	mfInfoFlow1.EnergyLaserLabel.style.font_color = {230, 233, 37}
	
	-- Create Energy Laser Multiplier Label --
	mfInfoFlow1.add{type="label", name="EnergyLaserMLabel"}
	mfInfoFlow1.EnergyLaserMLabel.style.font = "LabelFont"
	mfInfoFlow1.EnergyLaserMLabel.visible = false
	mfInfoFlow1.EnergyLaserMLabel.style.font_color = {230, 233, 37}
	
	-- Create Energy Drain Label --
	mfInfoFlow1.add{type="label", name="EnergyDrainLabel"}
	mfInfoFlow1.EnergyDrainLabel.style.font = "LabelFont"
	mfInfoFlow1.EnergyDrainLabel.visible = false
	mfInfoFlow1.EnergyDrainLabel.style.top_margin = 25
	mfInfoFlow1.EnergyDrainLabel.style.font_color = {92, 250, 243}
	
	-- Create Energy Drain Multiplier Label --
	mfInfoFlow1.add{type="label", name="EnergyDrainMLabel"}
	mfInfoFlow1.EnergyDrainMLabel.style.font = "LabelFont"
	mfInfoFlow1.EnergyDrainMLabel.visible = false
	mfInfoFlow1.EnergyDrainMLabel.style.font_color = {92, 250, 243}
	
	-- Create Fluid Laser Drain Label --
	mfInfoFlow1.add{type="label", name="FluidDrainLabel"}
	mfInfoFlow1.FluidDrainLabel.style.font = "LabelFont"
	mfInfoFlow1.FluidDrainLabel.visible = false
	mfInfoFlow1.FluidDrainLabel.style.top_margin = 25
	mfInfoFlow1.FluidDrainLabel.style.font_color = {214, 3, 220}
	
	-- Create Fluid Laser Drain multiplier Label --
	mfInfoFlow1.add{type="label", name="FluidDrainMLabel"}
	mfInfoFlow1.FluidDrainMLabel.style.font = "LabelFont"
	mfInfoFlow1.FluidDrainMLabel.visible = false
	mfInfoFlow1.FluidDrainMLabel.style.font_color = {214, 3, 220}
	
	-- Create Fluid Laser Consumption Label --
	mfInfoFlow1.add{type="label", name="FluidConsumptionLabel"}
	mfInfoFlow1.FluidConsumptionLabel.style.font = "LabelFont"
	mfInfoFlow1.FluidConsumptionLabel.visible = false
	mfInfoFlow1.FluidConsumptionLabel.style.font_color = {214, 3, 220}
	
	-- Create Item Laser Drain Label --
	mfInfoFlow1.add{type="label", name="ItemDrainLabel"}
	mfInfoFlow1.ItemDrainLabel.style.font = "LabelFont"
	mfInfoFlow1.ItemDrainLabel.visible = false
	mfInfoFlow1.ItemDrainLabel.style.top_margin = 25
	mfInfoFlow1.ItemDrainLabel.style.font_color = {39,239,0}
	
	-- Create Item Laser Drain multiplier Label --
	mfInfoFlow1.add{type="label", name="ItemDrainMLabel"}
	mfInfoFlow1.ItemDrainMLabel.style.font = "LabelFont"
	mfInfoFlow1.ItemDrainMLabel.visible = false
	mfInfoFlow1.ItemDrainMLabel.style.font_color = {39,239,0}
	
	-- Create Item Laser Consumption Label --
	mfInfoFlow1.add{type="label", name="ItemConsumptionLabel"}
	mfInfoFlow1.ItemConsumptionLabel.style.font = "LabelFont"
	mfInfoFlow1.ItemConsumptionLabel.visible = false
	mfInfoFlow1.ItemConsumptionLabel.style.font_color = {39,239,0}
	mfInfoFlow1.ItemConsumptionLabel.style.bottom_margin = 25
	
	-- Create Actual Tank ID Label --
	mfInfoFlow1.add{type="label", name="TankIDLabel"}
	mfInfoFlow1.TankIDLabel.style.font = "LabelFont"
	mfInfoFlow1.TankIDLabel.visible = false
	mfInfoFlow1.TankIDLabel.style.bottom_margin = 25
	mfInfoFlow1.TankIDLabel.style.font_color = {214, 3, 220}
	
	-- Create Accumulator amount Label --
	mfInfoFlow1.add{type="label", name="AccAmountLabel"}
	mfInfoFlow1.AccAmountLabel.style.font = "LabelFont"
	mfInfoFlow1.AccAmountLabel.visible = false
	mfInfoFlow1.AccAmountLabel.style.font_color = {108, 114, 229}
	
	-- Create Power Drain Pole amount Label --
	mfInfoFlow1.add{type="label", name="PDPAmountLabel"}
	mfInfoFlow1.PDPAmountLabel.style.font = "LabelFont"
	mfInfoFlow1.PDPAmountLabel.visible = false
	mfInfoFlow1.PDPAmountLabel.style.font_color = {108, 114, 229}
	
	-- Create Logistic Fluid Pole amount Label --
	mfInfoFlow1.add{type="label", name="LFPAmountLabel"}
	mfInfoFlow1.LFPAmountLabel.style.font = "LabelFont"
	mfInfoFlow1.LFPAmountLabel.visible = false
	mfInfoFlow1.LFPAmountLabel.style.font_color = {108, 114, 229}
	
	-- Create Tank amount Label --
	mfInfoFlow1.add{type="label", name="TankAmountLabel"}
	mfInfoFlow1.TankAmountLabel.style.font = "LabelFont"
	mfInfoFlow1.TankAmountLabel.visible = false
	mfInfoFlow1.TankAmountLabel.style.font_color = {108, 114, 229}
	
	-- Create Ore Silo amount Label --
	mfInfoFlow1.add{type="label", name="OreSiloAmountLabel"}
	mfInfoFlow1.OreSiloAmountLabel.style.font = "LabelFont"
	mfInfoFlow1.OreSiloAmountLabel.visible = false
	mfInfoFlow1.OreSiloAmountLabel.style.font_color = {108, 114, 229}
	
	------------------------------------------ FLOW 2 -------------------------------------
		
	-- Create Second Flow --
	local mfInfoFlow2 = mfInfoMainFlow.add{type="frame", name="mfInfoFlow2", direction="vertical"}
	mfInfoFlow2.style.height = 732
	mfInfoFlow2.visible = false
	
	-- Create Tank Title Label --
	mfInfoFlow2.add{type="label", name="mfTanksTitle"}
	mfInfoFlow2.mfTanksTitle.style.font = "TitleFont"
	mfInfoFlow2.mfTanksTitle.caption = {"gui-description.mfTanksTitle"}
	
	-- Create the Tank Flow --
	local mfTankFlow = mfInfoFlow2.add{type="flow", name = "mfTankFlow", direction="vertical"}
	mfTankFlow.style.width = 255
	
	------------------------------------------ FLOW 5 -------------------------------------
		
	-- Create fifth Flow --
	local mfInfoFlow5 = mfInfoMainFlow.add{type="frame", name="mfInfoFlow5", direction="vertical"}
	mfInfoFlow5.style.height = 732
	mfInfoFlow5.visible = false
	
	-- Create OreSilos Title Label --
	mfInfoFlow5.add{type="label", name="mfOreSilosTitle"}
	mfInfoFlow5.mfOreSilosTitle.style.font = "TitleFont"
	mfInfoFlow5.mfOreSilosTitle.caption = {"gui-description.mfOreSilosTitle"}
	
	-- Create the OreSilos Flow --
	local mfOreSilosFlow = mfInfoFlow5.add{type="flow", name = "mfOreSilosFlow", direction="vertical"}
	mfOreSilosFlow.style.width = 225
	
	---------------------------------------- FLOW 3 -------------------------------------
		
	-- Create Third Flow --
	local mfInfoFlow3 = mfInfoMainFlow.add{type="frame", name="mfInfoFlow3", direction="vertical"}
	mfInfoFlow3.style.height = 732
	mfInfoFlow3.style.width = 150
	mfInfoFlow3.visible = false
	
	-- Create Inventory Title Label --
	mfInfoFlow3.add{type="label", name="mfInventoryTitle"}
	mfInfoFlow3.mfInventoryTitle.style.font = "TitleFont"
	mfInfoFlow3.mfInventoryTitle.caption = {"gui-description.mfInventoryTitle"}
	
	-- Create Inventory Amount Label --
	mfInfoFlow3.add{type="label", name="mfInventoryAmountLabel"}
	mfInfoFlow3.mfInventoryAmountLabel.style.font = "LabelFont"
	mfInfoFlow3.mfInventoryAmountLabel.caption = {"gui-description.mfInventoryAmount"}
	mfInfoFlow3.mfInventoryAmountLabel.style.font_color = {108, 114, 229}
	
	-- Create Inventory Type Label --
	mfInfoFlow3.add{type="label", name="mfInventoryTypeLabel"}
	mfInfoFlow3.mfInventoryTypeLabel.style.font = "LabelFont"
	mfInfoFlow3.mfInventoryTypeLabel.caption = {"gui-description.mfInventoryType"}
	mfInfoFlow3.mfInventoryTypeLabel.style.font_color = {108, 114, 229}
	
	-- Create Inventory Pad Label --
	mfInfoFlow3.add{type="label", name="mfInventoryPadLabel"}
	mfInfoFlow3.mfInventoryPadLabel.style.font = "LabelFont"
	mfInfoFlow3.mfInventoryPadLabel.caption = {"gui-description.mfInventoryPadLabel"}
	mfInfoFlow3.mfInventoryPadLabel.style.font_color = {108, 114, 229}
	mfInfoFlow3.mfInventoryPadLabel.style.bottom_margin = 7
	
	-- Create Inventory ScrollPane --
	local InventoryPane = mfInfoFlow3.add{type="scroll-pane", name="InventoryPane"}
	InventoryPane.style.width = 130
	
	------------------------------------------ FLOW 4 -------------------------------------
		
	-- Create fourth Flow --
	local mfInfoFlow4 = mfInfoMainFlow.add{type="frame", name="mfInfoFlow4", direction="vertical"}
	mfInfoFlow4.style.height = 732
	mfInfoFlow4.style.width = 230
	mfInfoFlow4.visible = false
	
	-- Create Structures Title Label --
	mfInfoFlow4.add{type="label", name="mfStructureTitle"}
	mfInfoFlow4.mfStructureTitle.style.font = "TitleFont"
	mfInfoFlow4.mfStructureTitle.caption = {"gui-description.mfStructureTitle"}
	
	-- Create the Structures Flow --
	local mfStructureFlow = mfInfoFlow4.add{type="flow", name = "mfStructureFlow", direction="vertical"}
	mfStructureFlow.style.width = 205
end

---------------------------------------------------------------------------------------------------------
-------------------------------------------------- OPTIONS GUI ------------------------------------------
---------------------------------------------------------------------------------------------------------
function createOptionGUI(gui, player)
	-- Create the GUI --
	local mfOptionGUI = gui.screen.add{type="frame", name="mfOptionGUI", direction="vertical"}
	
	-- Calcule the position --
	local resolutionWidth = player.display_resolution.width  / player.display_scale
	local resolutionHeight = player.display_resolution.height  / player.display_scale
	local posX = resolutionWidth / 100 * 45
	local posY = resolutionHeight / 100 * 18
	local width = 350
	local height = 600
	dprint(player.display_scale)
	
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
	createOptTab1(mfOptTab1Pane)
end

---------------------- OPTIONS GUI TAB 1 --------------------------
function createOptTab1(tab)
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















