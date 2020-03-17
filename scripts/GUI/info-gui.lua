-- Create the Info GUI --
function GUI.createInfoGui(gui, player)

	-- Calcule the position --
	local resolutionWidth = player.display_resolution.width  / player.display_scale
	local resolutionHeight = player.display_resolution.height  / player.display_scale
	local posX = resolutionWidth / 100 * 10
	local posY = resolutionHeight / 100 * 10

	-- Verify if the Info GUI exist, save the positions and destroy it --
	if gui.screen.mfInfoGUI ~= nil and gui.screen.mfInfoGUI.valid == true then
		posX = gui.screen.mfInfoGUI.location.x
		posY = gui.screen.mfInfoGUI.location.y
		gui.screen.mfInfoGUI.destroy()
	end
	
	-- Create the GUI --
	local mfInfoGUI = gui.screen.add{type="frame", name="mfInfoGUI", direction="vertical"}
	
	-- Set the GUI position end style --
	mfInfoGUI.caption = "Mobile Factory"
	mfInfoGUI.location = {posX, posY}
	mfInfoGUI.style.padding = 5
	-- mfInfoGUI.style.width = 1300
	mfInfoGUI.style.horizontal_align = "center"
	mfInfoGUI.visible = false
	
	-- Create the Menu Bar --
	local mfGUIMenuBar = mfInfoGUI.add{type="flow", name="mfGUIMenuBar", direction="horizontal"}
	-- Set Style --
	mfGUIMenuBar.style.padding = 0
	mfGUIMenuBar.style.margin = 0
	mfGUIMenuBar.style.width = 860
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
	local mfInfoMainFlow = mfInfoGUI.add{type="frame", name="mfInfoMainFlow", direction="horizontal"}
	-- mfInfoMainFlow.style.width = 856
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
	local mfTankFlow = mfInfoFlow2.add{type="scroll-pane", name = "mfTankFlow", direction="vertical"}
	mfTankFlow.style.width = 255
	
	------------------------------------------ FLOW 5 -------------------------------------
		
	-- Create fifth Flow --
	local mfInfoFlow5 = mfInfoMainFlow.add{type="frame", name="mfInfoFlow5", direction="vertical"}
	mfInfoFlow5.style.height = 732
	mfInfoFlow5.visible = false
	-- mfInfoFlow5.style.width = 175
	
	-- Create Deep Storage Title Label --
	mfInfoFlow5.add{type="label", name="mfDeepStorageTitle"}
	mfInfoFlow5.mfDeepStorageTitle.style.font = "TitleFont"
	mfInfoFlow5.mfDeepStorageTitle.caption = {"gui-description.mfDeepStorageTitle"}
	
	-- Create the Deep Storage Flow --
	local mfDeepStorageFlow = mfInfoFlow5.add{type="scroll-pane", name="mfDeepStorageFlow", horizontal_scroll_policy="never"}
	-- mfDeepStorageFlow.style.width = 150
	
	---------------------------------------- FLOW 3 -------------------------------------
		
	-- Create Third Flow --
	local mfInfoFlow3 = mfInfoMainFlow.add{type="frame", name="mfInfoFlow3", direction="vertical"}
	mfInfoFlow3.style.height = 732
	mfInfoFlow3.style.natural_width = 180
	mfInfoFlow3.visible = false
	
	-- Create Scrool Pane --
	local mfInfoFlow3SP = mfInfoFlow3.add{type="scroll-pane", name="mfInfoFlow3SP", horizontal_scroll_policy="never"}
	mfInfoFlow3SP.style.height = 715
	mfInfoFlow3SP.style.natural_width = 178
	
end

-- Update the Mobile Factory Info GUI --
function GUI.updatePlayerInfoGUI(player)

	-- Get the Mobile Factory --
	local MF = getMF(player.name)
	if MF == nil then return end

	if MF.ent == nil or MF.ent.valid == false then return end
	
	-- Check if info GUI is valid --
	if player.gui.screen.mfInfoGUI == nil or player.gui.screen.mfInfoGUI.visible == false then
		return
	end

	-- Energy Laser Radius --
	if technologyUnlocked("EnergyDrain1", getForce(player.name)) then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyRadiusLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyRadiusLabel.caption = {"", {"gui-description.EnergyRadiusLabel"}, ": ", MF:getLaserRadius(), " tiles"}
	end
	
	-- Energy Laser Radius Multiplier --
	if technologyUnlocked("EnergyDrain1", getForce(player.name)) then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyRadiusMLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyRadiusMLabel.caption = {"", {"gui-description.EnergyRadiusMLabel"}, ": ", MF.laserRadiusMultiplier}
	end
	
	-- Energy Laser Drain --
	if technologyUnlocked("EnergyDrain1", getForce(player.name)) then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyDrainLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyDrainLabel.caption = {"", {"gui-description.EnergyDrainLabel"}, ": ", Util.toRNumber(MF:getLaserEnergyDrain()), "W"}
	end
	
	-- Energy Laser Drain Multiplier --
	if technologyUnlocked("EnergyDrain1", getForce(player.name)) then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyDrainMLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyDrainMLabel.caption = {"", {"gui-description.EnergyDrainMLabel"}, ": ", MF.laserDrainMultiplier}
	end
	
	-- Energy Laser Laser --
	if technologyUnlocked("EnergyDrain1", getForce(player.name)) then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyLaserLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyLaserLabel.caption = {"", {"gui-description.EnergyLaserLabel"}, ": ", MF:getLaserNumber()}
	end
	
	-- Energy Laser Drain Multiplier --
	if technologyUnlocked("EnergyDrain1", getForce(player.name)) then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyLaserMLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyLaserMLabel.caption = {"", {"gui-description.EnergyLaserMLabel"}, ": ", MF.laserNumberMultiplier}
	end
	
	-- Fluid Laser Drain --
	if technologyUnlocked("FluidDrain1", getForce(player.name)) then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.FluidDrainLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.FluidDrainLabel.caption = {"", {"gui-description.FluidDrainLabel"}, ": ", Util.toRNumber(MF:getLaserFluidDrain()), "u/s"}
	end
	
	-- Fluid Laser Drain Multiplier --
	if technologyUnlocked("FluidDrain1", getForce(player.name)) then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.FluidDrainMLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.FluidDrainMLabel.caption = {"", {"gui-description.FluidDrainMLabel"}, ": ", MF.laserDrainMultiplier}
	end
	
	-- Fluid Laser Consomption --
	if technologyUnlocked("FluidDrain1", getForce(player.name)) then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.FluidConsumptionLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.FluidConsumptionLabel.caption = {"", {"gui-description.FluidConsumptionLabel"}, ": ", Util.toRNumber(MF:getLaserFluidDrain()*_lfpFluidConsomption), "W"}
	end
	
	-- Item Laser Drain --
	if technologyUnlocked("TechItemDrain", getForce(player.name)) then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ItemDrainLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ItemDrainLabel.caption = {"", {"gui-description.ItemDrainLabel"}, ": ", Util.toRNumber(MF:getLaserItemDrain()), "i/s"}
	end
	
	-- Item Laser Drain Multiplier --
	if technologyUnlocked("TechItemDrain", getForce(player.name)) then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ItemDrainMLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ItemDrainMLabel.caption = {"", {"gui-description.ItemDrainMLabel"}, ": ", MF.laserDrainMultiplier}
	end
	
	-- Item Laser Consomption --
	if technologyUnlocked("TechItemDrain", getForce(player.name)) then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ItemConsumptionLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ItemConsumptionLabel.caption = {"", {"gui-description.ItemConsumptionLabel"}, ": ", Util.toRNumber(_mfItemsDrain*MF:getLaserItemDrain()), "W"}
	end
	
	-- Tank ID --
	if MF.IDModule ~= nil and MF.IDModule > 0 then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.TankIDLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.TankIDLabel.caption = {"", {"gui-description.TankIDLabel"}, ": ", MF.IDModule}
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.TankIDLabel.visible = false
	end
	
	-- -- Number of Accumulator --
	-- if global.accTable ~= nil and table_size(global.accTable) > 0 then
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.AccAmountLabel.visible = true
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.AccAmountLabel.caption = {"", {"gui-description.AccAmountLabel"}, ": ", table_size(global.accTable)}
	-- else
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.AccAmountLabel.visible = false
	-- end
	
	-- -- Number of Power Drain Poles --
	-- if global.pdpTable ~= nil and table_size(global.pdpTable) > 0 then
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.PDPAmountLabel.visible = true
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.PDPAmountLabel.caption = {"", {"gui-description.PDPAmountLabel"}, ": ", table_size(global.pdpTable)}
	-- else
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.PDPAmountLabel.visible = false
	-- end
	
	-- -- Number of Logistic Fluid Pole --
	-- if global.lfpTable ~= nil and table_size(global.lfpTable) > 0 then
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.LFPAmountLabel.visible = true
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.LFPAmountLabel.caption = {"", {"gui-description.LFPAmountLabel"}, ": ", table_size(global.lfpTable)}
	-- else
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.LFPAmountLabel.visible = false
	-- end
	
	-- -- Number of Tank --
	-- if MF.varTable.tanks ~= nil and table_size(MF.varTable.tanks) > 0 then
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.TankAmountLabel.visible = true
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.TankAmountLabel.caption = {"", {"gui-description.TankAmountLabel"}, ": ", table_size(MF.varTable.tanks)}
	-- end
	
	-- -- Number of Ore Silo --
	-- if global.oreSilotTable ~= nil and table_size(global.oreSilotTable) > 0 then
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.OreSiloAmountLabel.visible = true
	-- 	player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.OreSiloAmountLabel.caption = {"", {"gui-description.OreSiloAmountLabel"}, ": ", table_size(global.oreSilotTable)}
	-- end
	
	-- Update Tank Frame --
	GUI.updateTankFrame(player, MF)
	
	-- Update Deep Storage Frame --
	GUI.updateDeepStorageFrame(player, MF)
	
	-- Update Inventory frame --
	GUI.updateInventoryFrame(player.gui, MF)
	
end
	
	
-- Update Tank Frame --
function GUI.updateTankFrame(player, MF)
	-- Get the GUI --
	gui = player.gui
	if MF.ccS == nil or getPlayerVariable(player.name, "GUIUpdateInfoGUI") ~= true then return end
	-- Get the Tank Flow --
	local tankFlow = gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow2.mfTankFlow
	-- Clear the Tank Flow --
	tankFlow.clear()
	-- Look for all Tanks --
	for k, deepTank in pairs(global.deepTankTable) do
		-- Ckeck if the Deep Storage belong to this Player --
		if deepTank.player ~= player.name then goto continue end
		-- Create the Fluid Variables --
		local fName = deepTank.inventoryFluid
		local fAmount = deepTank.inventoryCount
		local tCapacity = _dtMaxFluid
		-- Set Fluid to 0 if the Tank is empty --
		if fName == nil then fName = "Empty" end
		if fAmount == nil then fAmount = 0 end
		-- Create the Frame --
		luaGuiElement = gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow2.mfTankFlow
		local TankFrame = luaGuiElement.add{type="frame", direction="horizontal"}
		-- Create the Flow --
		local TankFlow = TankFrame.add{type="flow", direction="vertical"}
		-- Create Tank Labels --
		local TankLabel = TankFlow.add{type="label"}
		TankLabel.caption = {"", {"gui-description.DeepTank"}, " ", deepTank.ID, ": ", fName, " ", Util.toRNumber(fAmount), "/", Util.toRNumber(tCapacity)}
		TankLabel.style.font = "LabelFont"
		TankLabel.style.font_color = {214, 3, 220}
		-- Create Tank ProgressBar -
		local TankBar = TankFlow.add{type="progressbar"}
		TankBar.value = fAmount/tCapacity
		TankBar.style.maximal_width = 200
		TankBar.style.color = {214, 3, 220}
		-- Create Tank Filter --
		local TankFilter = TankFrame.add{type="choose-elem-button", elem_type="fluid", name="TF" .. tostring(k)}
		TankFilter.style.maximal_height = 25
		TankFilter.style.maximal_width = 25
		if TankFilter.elem_value == nil and deepTank.filter ~= nil then
				TankFilter.elem_value = deepTank.filter
		end
		deepTank.filter = TankFilter.elem_value
		-- Make the Frame visible --
		gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow2.visible = true
	::continue::
	end
end


-- Update Deep Storage Frame --
function GUI.updateDeepStorageFrame(player, MF)
	if MF.ccS == nil or global.deepStorageTable == nil or getPlayerVariable(player.name, "GUIUpdateInfoGUI") ~= true then return end
	local gui = player.gui
	-- Make the frame invisible --
	gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow5.visible = false
	-- Get the Deep Storage Flow --
	local deepStorageFlow = gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow5.mfDeepStorageFlow
	-- Clear the Deep Storage Flow --
	deepStorageFlow.clear()
	-- Look for all Deep Storage --
	for k, deepStorage in pairs(global.deepStorageTable) do
		-- Ckeck if the Deep Storage belong to this Player --
		if deepStorage.player ~= player.name then goto continue end
		-- Create the Frame --
		luaGuiElement = gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow5.mfDeepStorageFlow
		local deepStorageFrame = luaGuiElement.add{type="frame", direction="horizontal"}
		-- deepStorageFrame.style.width = 130
		-- Create the Flow --
		local deepStorageFlow = deepStorageFrame.add{type="flow", direction="vertical"}
		deepStorageFlow.style.margin = 0
		deepStorageFlow.style.padding = 0
		-- Create Deep Storage Labels --
		local deepStorageLabel = deepStorageFlow.add{type="label"}
		deepStorageLabel.caption = {"", {"gui-description.DeepStorage"}, " ", deepStorage.ID}
		deepStorageLabel.style.font = "LabelFont"
		deepStorageLabel.style.font_color = {39,239,0}
		deepStorageLabel.style.margin = 0
		deepStorageLabel.style.padding = 0
		deepStorageLabel.style.width = 80
		if deepStorage.inventoryItem ~= nil then
			Util.itemToLabel(deepStorage.inventoryItem, deepStorage.inventoryCount, deepStorageFlow)
		end
		-- Create Deep Storage Filter --
		local deepStorageFilter = deepStorageFrame.add{type="choose-elem-button", elem_type="item", name="DSRF" .. tostring(k)}
		deepStorageFilter.style.maximal_height = 25
		deepStorageFilter.style.maximal_width = 25
		deepStorageFilter.style.margin = 0
		deepStorageFilter.style.padding = 0
		if deepStorageFilter.elem_value == nil and global.deepStorageTable[k].filter ~= nil and game.item_prototypes[global.deepStorageTable[k].filter] ~= nil then
			deepStorageFilter.elem_value = global.deepStorageTable[k].filter
		end
		global.deepStorageTable[k].filter = deepStorageFilter.elem_value
		-- Make the Frame Visible --
		gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow5.visible = true
		::continue::
	end
end

	
-- Update the Inventory GUI Frame --
function GUI.updateInventoryFrame(gui, MF)
	if MF.II == nil then return end
	-- Make the frame visible if the technology is unlocked --
	if technologyUnlocked("MatterSerialization", getForce(MF.player)) == false then return end
	gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow3.visible = true
	-- Clear the frame --
	gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow3.mfInfoFlow3SP.clear()
	-- Add the Inventory Frame --
	MF.II:getFrame(gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow3.mfInfoFlow3SP)
end