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

-- Update the Mobile Factory Info GUI --
function GUI.updatePlayerInfoGUI(player)

	if global.MF.ent == nil or global.MF.ent.valid == false then return end
	
	-- Check if info GUI is valid --
	if player.gui.screen.mfInfoGUI == nil or player.gui.screen.mfInfoGUI.visible == false then
		return
	end

	-- Energy Laser Radius --
	if technologyUnlocked("EnergyDrain1") then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyRadiusLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyRadiusLabel.caption = {"", {"gui-description.EnergyRadiusLabel"}, ": ", global.MF:getLaserRadius(), " tiles"}
	end
	
	-- Energy Laser Radius Multiplier --
	if technologyUnlocked("EnergyDrain1") then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyRadiusMLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyRadiusMLabel.caption = {"", {"gui-description.EnergyRadiusMLabel"}, ": ", global.MF.laserRadiusMultiplier}
	end
	
	-- Energy Laser Drain --
	if technologyUnlocked("EnergyDrain1") then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyDrainLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyDrainLabel.caption = {"", {"gui-description.EnergyDrainLabel"}, ": ", global.MF:getLaserEnergyDrain()/1000000, " MW"}
	end
	
	-- Energy Laser Drain Multiplier --
	if technologyUnlocked("EnergyDrain1") then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyDrainMLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyDrainMLabel.caption = {"", {"gui-description.EnergyDrainMLabel"}, ": ", global.MF.laserDrainMultiplier}
	end
	
	-- Energy Laser Laser --
	if technologyUnlocked("EnergyDrain1") then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyLaserLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyLaserLabel.caption = {"", {"gui-description.EnergyLaserLabel"}, ": ", global.MF:getLaserNumber()}
	end
	
	-- Energy Laser Drain Multiplier --
	if technologyUnlocked("EnergyDrain1") then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyLaserMLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.EnergyLaserMLabel.caption = {"", {"gui-description.EnergyLaserMLabel"}, ": ", global.MF.laserNumberMultiplier}
	end
	
	-- Fluid Laser Drain --
	if technologyUnlocked("FluidDrain1") then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.FluidDrainLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.FluidDrainLabel.caption = {"", {"gui-description.FluidDrainLabel"}, ": ", global.MF:getLaserFluidDrain(), "u/s"}
	end
	
	-- Fluid Laser Drain Multiplier --
	if technologyUnlocked("FluidDrain1") then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.FluidDrainMLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.FluidDrainMLabel.caption = {"", {"gui-description.FluidDrainMLabel"}, ": ", global.MF.laserDrainMultiplier}
	end
	
	-- Fluid Laser Consomption --
	if technologyUnlocked("FluidDrain1") then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.FluidConsumptionLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.FluidConsumptionLabel.caption = {"", {"gui-description.FluidConsumptionLabel"}, ": ", global.MF:getLaserFluidDrain()*_lfpFluidConsomption/1000, " kW"}
	end
	
	-- Item Laser Drain --
	if technologyUnlocked("TechItemDrain") then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ItemDrainLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ItemDrainLabel.caption = {"", {"gui-description.ItemDrainLabel"}, ": ", global.MF:getLaserItemDrain(), "i/s"}
	end
	
	-- Item Laser Drain Multiplier --
	if technologyUnlocked("TechItemDrain") then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ItemDrainMLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ItemDrainMLabel.caption = {"", {"gui-description.ItemDrainMLabel"}, ": ", global.MF.laserDrainMultiplier}
	end
	
	-- Item Laser Consomption --
	if technologyUnlocked("TechItemDrain") then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ItemConsumptionLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ItemConsumptionLabel.caption = {"", {"gui-description.ItemConsumptionLabel"}, ": ", _mfItemsDrain*global.MF:getLaserItemDrain()/1000, " kW"}
	end
	
	-- Tank ID --
	if global.IDModule ~= nil and global.IDModule > 0 then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.TankIDLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.TankIDLabel.caption = {"", {"gui-description.TankIDLabel"}, ": ", global.IDModule}
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.TankIDLabel.visible = false
	end
	
	-- Number of Accumulator --
	if global.accTable ~= nil and table_size(global.accTable) > 0 then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.AccAmountLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.AccAmountLabel.caption = {"", {"gui-description.AccAmountLabel"}, ": ", table_size(global.accTable)}
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.AccAmountLabel.visible = false
	end
	
	-- Number of Power Drain Poles --
	if global.pdpTable ~= nil and table_size(global.pdpTable) > 0 then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.PDPAmountLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.PDPAmountLabel.caption = {"", {"gui-description.PDPAmountLabel"}, ": ", table_size(global.pdpTable)}
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.PDPAmountLabel.visible = false
	end
	
	-- Number of Logistic Fluid Pole --
	if global.lfpTable ~= nil and table_size(global.lfpTable) > 0 then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.LFPAmountLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.LFPAmountLabel.caption = {"", {"gui-description.LFPAmountLabel"}, ": ", table_size(global.lfpTable)}
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.LFPAmountLabel.visible = false
	end
	
	-- Number of Tank --
	if global.tankTable ~= nil and table_size(global.tankTable) > 0 then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.TankAmountLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.TankAmountLabel.caption = {"", {"gui-description.TankAmountLabel"}, ": ", table_size(global.tankTable)}
	end
	
	-- Number of Ore Silo --
	if global.oreSilotTable ~= nil and table_size(global.oreSilotTable) > 0 then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.OreSiloAmountLabel.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.OreSiloAmountLabel.caption = {"", {"gui-description.OreSiloAmountLabel"}, ": ", table_size(global.oreSilotTable)}
	end
	
	-- Update Tank Frame --
	GUI.updateTankFrame(player)
	
	-- Update OreSilos Frame --
	GUI.updateOreSiloFrame(player.gui)
	
	-- Update Inventory frame --
	GUI.updateInventoryFrame(player.gui)
	
	-- Update Structures Frame --
	GUI.updateStructuresFrame(player.gui)
	
end
	
	
-- Update Tank Frame --
function GUI.updateTankFrame(player)
	-- Get the GUI --
	gui = player.gui
	if global.MF.ccS == nil or global.tankTable == nil or getPlayerVariable(player.name, "GUIUpdateInfoGUI") ~= true then return end
	-- Make the frame visible if there are at least one Tank in the table --
	if table_size(global.tankTable) > 0 then
		gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow2.visible = true
	end
	-- Get the Tank Flow --
	local tankFlow = gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow2.mfTankFlow
	-- Clear the Tank Flow --
	tankFlow.clear()
	-- Look for all Tanks --
	for k, id in pairs(global.tankTable) do
		-- Get the Tank --
		local tank = id.ent
		if tank ~= nil then
			-- Get the Tank capacity --
			local tCapacity = math.floor(tank.fluidbox.get_capacity(1))
			local fName
			local fAmount
			for k, i in pairs(tank.get_fluid_contents()) do
				-- Get the fluid name --
				fName = k
				-- Get the Fluid amount --
				fAmount = math.floor(i)
			end
			-- Set Fluid to unknow 0 if the Tank is empty --
			if fName == nil then fName = "Empty" end
			if fAmount == nil then fAmount = 0 end
			-- Create the Frame --
			luaGuiElement = gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow2.mfTankFlow
			local TankFrame = luaGuiElement.add{type="frame", direction="horizontal"}
			-- Create the Flow --
			local TankFlow = TankFrame.add{type="flow", direction="vertical"}
			-- Create Tank Labels --
			local TankLabel = TankFlow.add{type="label"}
			TankLabel.caption = {"", {"gui-description.Tank" .. k .. "Label"}, ": ", fName, " ", fAmount, "/", tCapacity}
			TankLabel.style.font = "LabelFont"
			TankLabel.style.font_color = {214, 3, 220}
			-- Create Tank ProgressBar -
			local TankBar = TankFlow.add{type="progressbar"}
			TankBar.value = fAmount/tCapacity
			TankBar.style.maximal_width = 200
			TankBar.style.color = {214, 3, 220}
			-- Create Tank Filter --
			local TankFilter = TankFrame.add{type="choose-elem-button", elem_type="fluid", name=k}
			TankFilter.style.maximal_height = 25
			TankFilter.style.maximal_width = 25
			if TankFilter.elem_value == nil and global.tankTable[k].filter ~= nil then
					TankFilter.elem_value = global.tankTable[k].filter
			end
			global.tankTable[k].filter = TankFilter.elem_value
		end
	end
end


-- Update OreSilo Frame --
function GUI.updateOreSiloFrame(gui)
	if global.MF.ccS == nil or global.oreSilotTable == nil then return end
	-- Make the frame visible if there are at least one Ore Silo in the table --
	if table_size(global.oreSilotTable) > 0 then
		gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow5.visible = true
	end
	-- Get the Ore Silo Flow --
	local oreSiloFlow = gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow5.mfOreSilosFlow
	-- Clear the Ore Silo Flow --
	oreSiloFlow.clear()
	-- Look for all Ore Silos --
	for k, oreSilo in pairs(global.oreSilotTable) do
		-- Get the Ore Silo inventory --
		local inv = oreSilo.get_inventory(defines.inventory.chest)
		-- Get the Ore Silo capacity --
		local capacity = #inv
		local usedCapacity = 0
		for i=1, capacity do
			if inv[i].valid_for_read then
				usedCapacity = usedCapacity + 1
			end
		end
		-- Create the Frame --
		luaGuiElement = gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow5.mfOreSilosFlow
		local OreSiloFrame = luaGuiElement.add{type="frame", direction="horizontal"}
		-- Create the Flow --
		local OreSiloFlow = OreSiloFrame.add{type="flow", direction="vertical"}
		-- Create Ore Silo Labels --
		local OreSiloLabel = OreSiloFlow.add{type="label"}
		OreSiloLabel.caption = {"", {"gui-description.OreSilo" .. k .. "Label"}, ": ", usedCapacity, "/", capacity}
		OreSiloLabel.style.font = "LabelFont"
		OreSiloLabel.style.font_color = {39,239,0}
		-- Create Ore Silo ProgressBar -
		local OreSiloBar = OreSiloFlow.add{type="progressbar"}
		OreSiloBar.value = usedCapacity/capacity
		OreSiloBar.style.maximal_width = 200
		OreSiloBar.style.color = {39,239,0}
	end
end

	
-- Update the Inventory GUI Frame --
function GUI.updateInventoryFrame(gui)
	if global.MF.II == nil then return end
	-- Make the frame visible if the technology is unlocked --
	if technologyUnlocked("MatterSerialization") == false then return end
	gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow3.visible = true
	-- Clear the frame --
	gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow3.clear()
	-- Add the Inventory Frame --
	global.MF.II:getFrame(gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow3)
end
	
	
-- Update the Structure Frame --
function GUI.updateStructuresFrame(gui)
	-- Return if OreCleaner Technology is not unlocked --
	if technologyUnlocked("OreCleaner") == false then return end
	-- Clear the Frame --
	gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow4.mfStructureFlow.clear()
	
	-- Make the frame visible --
	gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow4.visible = true
	
	--------------- Make the Ore Cleaner Frame ----------------
	local ocFrame = gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow4.mfStructureFlow.add{type="frame", direction="vertical"}
	ocFrame.visible = false
	ocFrame.style.width = 205
	-- Make the Ore Cleaner Frame visible if Ore Cleaner is placed --
	if global.oreCleaner ~= nil and global.oreCleaner.ent ~= nil then
		ocFrame.visible = true
		
		-- Create Labels and Bares --
		local nameLabel = ocFrame.add{type="label", caption={"", {"gui-description.OreCleaner"}}}
		local SpeedLabel = ocFrame.add{type="label", caption={"", {"gui-description.Speed"}, ": ", global.oreCleaner:orePerExtraction() * (60/_mfOreCleanerExtractionTicks), " ores/s"}}
		local ChargeLabel = ocFrame.add{type="label", caption={"", {"gui-description.Charge"}, ": ", global.oreCleaner.charge}}
		local ChargeBar = ocFrame.add{type="progressbar", value=global.oreCleaner.charge/_mfOreCleanerMaxCharge}
		local PurityLabel = ocFrame.add{type="label", caption={"", {"gui-description.Purity"}, ": ", math.floor(global.oreCleaner.purity*100)/100}}
		local PurityBar = ocFrame.add{type="progressbar", value=global.oreCleaner.purity/100}
		
		-- Update Style --
		nameLabel.style.font = "LabelFont"
		nameLabel.style.bottom_margin = 7
		SpeedLabel.style.font = "LabelFont"
		ChargeLabel.style.font = "LabelFont"
		PurityLabel.style.font = "LabelFont"
		nameLabel.style.font_color = {108, 114, 229}
		SpeedLabel.style.font_color = {39,239,0}
		ChargeLabel.style.font_color = {39,239,0}
		ChargeBar.style.color = {176,50,176}
		PurityLabel.style.font_color = {39,239,0}
		PurityBar.style.color = {255, 255, 255}
	end
	
	--------------- Make the Fluid Extractor Frame ----------------
	local feFrame = gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow4.mfStructureFlow.add{type="frame", direction="vertical"}
	feFrame.visible = false
	feFrame.style.width = 205
	-- Make the Fluid Extractor Frame visible if Fluid Extractor is placed --
	if global.fluidExtractor ~= nil then
		feFrame.visible = true
		
		-- Create Labels and Bares --
		local nameLabel = feFrame.add{type="label", caption={"", {"gui-description.FluidExtractor"}}}
		local SpeedLabel = feFrame.add{type="label", caption={"", {"gui-description.Speed"}, ": ", _mfFEFluidPerExtraction*global.fluidExtractorPurity, " u/s"}}
		local ChargeLabel = feFrame.add{type="label", caption={"", {"gui-description.Charge"}, ": ", global.fluidExtractorCharge}}
		local ChargeBar = feFrame.add{type="progressbar", value=global.fluidExtractorCharge/_mfFEMaxCharge}
		local PurityLabel = feFrame.add{type="label", caption={"", {"gui-description.Purity"}, ": ", math.floor(global.fluidExtractorPurity*100)/100}}
		local PurityBar = feFrame.add{type="progressbar", value=global.fluidExtractorPurity/100}
	
		-- Update Style --
		nameLabel.style.font = "LabelFont"
		nameLabel.style.bottom_margin = 7
		SpeedLabel.style.font = "LabelFont"
		ChargeLabel.style.font = "LabelFont"
		PurityLabel.style.font = "LabelFont"
		nameLabel.style.font_color = {108, 114, 229}
		SpeedLabel.style.font_color = {39,239,0}
		ChargeLabel.style.font_color = {39,239,0}
		ChargeBar.style.color = {176,50,176}
		PurityLabel.style.font_color = {39,239,0}
		PurityBar.style.color = {255, 255, 255}
	end
end