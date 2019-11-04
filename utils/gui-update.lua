require("utils/functions.lua")
require("utils/gui.lua")

-- Update the GUI of all player --
function updateAllGUIs()
	-- List all player connected end update it GUI --
	for k, player in pairs(game.connected_players) do
		updatePlayerGUI(player)
	end
end

-- Update a player GUI --
function updatePlayerGUI(player)
	-- Test if a player got an updated GUI else create --
	if getPlayerVariable(player.name, "VisitedFactory") == true then
		if getPlayerVariable(player.name, "GUICreated") ~= true then
			createPlayerGui(player)
			dprint("GUI Recreated")
			setPlayerVariable(player.name, "GUICreated", true)
		end
	else
		if player.gui.screen.mfGUI ~= nil then
			player.gui.screen.mfGUI.destroy()
		end
		if player.surface.name == _mfSurfaceName or player.surface.name == _mfControlSurfaceName then
			setPlayerVariable(player.name, "VisitedFactory", true)
		end
	end
	
	-- Test if player got his GUI else return
	if player.gui.screen.mfGUI == nil or player.gui.screen.mfGUI.valid == false then return end
	
	-- Test if info GUI is valid and update it --
	if player.gui.screen.mfInfoGUI ~= nil and player.gui.screen.mfInfoGUI.visible == true then
		updatePlayerInfoGUI(player)
	end
	
	-- Update the Mobile Factory positions --
	if global.MF ~= nil and global.MF.ent.valid then
		player.gui.screen.mfGUI.mfGUICenterFrame.mfposition.caption = {"", {"gui-description.mfPosition"}, ": (", math.floor(global.MF.ent.position.x), " ; ", math.floor(global.MF.ent.position.y), ")  ", global.MF.ent.surface.name}
	else
		player.gui.screen.mfGUI.mfGUICenterFrame.mfposition.caption = {"", {"gui-description.mfPosition"}, ": Unknow"}
	end
	if global.MF ~= nil and global.MF.ent.valid then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfposition.caption = {"", {"gui-description.mfPosition"}, ": (", math.floor(global.MF.ent.position.x), " ; ", math.floor(global.MF.ent.position.y), ")  ", global.MF.ent.surface.name}
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.caption = {"", {"gui-description.mfPosition"}, ": Unknow"}
	end

	-- Update the Mobile Factory health --
	if global.MF ~= nil and global.MF.ent.valid then
		player.gui.screen.mfGUI.mfGUICenterFrame.mfHealth.caption = {"", {"gui-description.mfHealth"}, ": ", math.floor(global.MF.ent.health), "/", global.MF.ent.prototype.max_health}
		player.gui.screen.mfGUI.mfGUICenterFrame.HealthBar.value = global.MF.ent.health / global.MF.ent.prototype.max_health
	else
		player.gui.screen.mfGUI.mfGUICenterFrame.mfHealth.caption = {"", {"gui-description.mfHealth"}, ": Unknow"}
	end
	if global.MF ~= nil and global.MF.ent.valid then
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfHealth.caption = {"", {"gui-description.mfHealth"}, ": ", math.floor(global.MF.ent.health), "/", global.MF.ent.prototype.max_health}
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.HealthBar.value = global.MF.ent.health / global.MF.ent.prototype.max_health
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfHealth.caption = {"", {"gui-description.mfHealth"}, ": Unknow"}
	end
	
	-- Update the Mobile Factory Shield --
	if technologyUnlocked("MFShield") == true then
		player.gui.screen.mfGUI.mfGUICenterFrame.mfShield.visible = true
		player.gui.screen.mfGUI.mfGUICenterFrame.ShieldBar.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfShield.visible = true
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ShieldBar.visible = true
		if global.MF ~= nil and global.MF.ent.valid then
			player.gui.screen.mfGUI.mfGUICenterFrame.mfShield.caption = {"", {"gui-description.mfShield"}, ": ", math.floor(global.MF.shield), "/", global.MF.maxShield}
			player.gui.screen.mfGUI.mfGUICenterFrame.ShieldBar.value = global.MF.shield / global.MF.maxShield
		else
			player.gui.screen.mfGUI.mfGUICenterFrame.mfShield.caption = {"", {"gui-description.mfShield"}, ": Unknow"}
		end
		if global.MF ~= nil and global.MF.ent.valid then
			player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfShield.caption = {"", {"gui-description.mfShield"}, ": ", math.floor(global.MF.shield), "/", global.MF.maxShield}
			player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.ShieldBar.value = global.MF.shield / global.MF.maxShield
		else
			player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.mfShield.caption = {"", {"gui-description.mfShield"}, ": Unknow"}
		end
	end
	
	-- Update the Mobile Factory Jump Charge --
	if global.MF ~= nil and global.MF.ent.valid then
		local chargePercent = math.floor(100 - global.MF.jumpTimer / global.MF.baseJumpTimer * 100)
		player.gui.screen.mfGUI.mfGUICenterFrame.JumpCharge.caption = {"", {"gui-description.mfJumpTimer"}, ": ", chargePercent, "% (", global.MF.jumpTimer, "s)"}
		player.gui.screen.mfGUI.mfGUICenterFrame.JumpChargeBar.value = chargePercent / 100
	else
		player.gui.screen.mfGUI.mfGUICenterFrame.JumpCharge.caption = {"", {"gui-description.mfJumpTimer"}, ": Unknow"}
	end
	if global.MF ~= nil and global.MF.ent.valid then
		local chargePercent = math.floor(100 - global.MF.jumpTimer / global.MF.baseJumpTimer * 100)
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.JumpCharge.caption = {"", {"gui-description.mfJumpTimer"}, ": ", chargePercent, "% (", global.MF.jumpTimer, "s)"}
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.JumpChargeBar.value = chargePercent / 100
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.JumpCharge.caption = {"", {"gui-description.mfJumpTimer"}, ": Unknow"}
	end
	
	-- Update the Mobile Factory Internal Energy Charge --
	if global.MF ~= nil and global.MF.ent.valid then
		local chargePercent = math.floor(100 - global.MF.internalEnergy / global.MF.maxInternalEnergy * 100)
		player.gui.screen.mfGUI.mfGUICenterFrame.InernalEnergy.caption = {"", {"gui-description.mfEnergyCharge"}, ": ", math.floor(global.MF.internalEnergy/1000000), "/", math.floor(global.MF.maxInternalEnergy/100000), "MJ"}
		player.gui.screen.mfGUI.mfGUICenterFrame.InternalEnergyBar.value = 1 - chargePercent / 100
	else
		player.gui.screen.mfGUI.mfGUICenterFrame.InernalEnergy.caption = {"", {"gui-description.mfEnergyCharge"}, ": Unknow"}
	end
	if global.MF ~= nil and global.MF.ent.valid then
		local chargePercent = math.floor(100 - global.MF.internalEnergy / global.MF.maxInternalEnergy * 100)
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.InernalEnergy.caption = {"", {"gui-description.mfEnergyCharge"}, ": ", math.floor(global.MF.internalEnergy/1000000), "/", math.floor(global.MF.maxInternalEnergy/100000), "MJ"}
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.InternalEnergyBar.value = 1 - chargePercent / 100
	else
		player.gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow1.InernalEnergy.caption = {"", {"gui-description.mfEnergyCharge"}, ": Unknow"}
	end
	
	-- Update the CallMF Button --
	if player.surface.name == _mfSurfaceName or player.surface.name == _mfControlSurfaceName then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.CallMF.visible = false
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.CallMF.visible = true
	end
	
	-- Update the PortOutside button --
	if player.surface.name == _mfSurfaceName or player.surface.name == _mfControlSurfaceName then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.PortOutside.visible = true
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.PortOutside.visible = false
	end
	
	-- Update the FindMF Button --
	player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.FindMF.visible = false
	
	if global.MF == nil or global.MF.ent.valid == false then player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.FindMF.visible = true end
	if global.MF.fS == nil or global.MF.fS.valid == false then player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.FindMF.visible = true end
	if (global.MF.ccS == nil or global.MF.ccS.valid == false) and technologyUnlocked("ControlCenter") then player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF1.FindMF.visible = true end

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

	-- Update the Energy Drain Icone --
	if global.MF.energyLaserActivated == true then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDrain.sprite = "EnergyDrainIcon"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDrain.hovered_sprite = "EnergyDrainIconDisabled"
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDrain.sprite = "EnergyDrainIconDisabled"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDrain.hovered_sprite = "EnergyDrainIcon"
	end
	
	-- Update the Fluid Drain Icone --
	if global.MF.fluidLaserActivated == true then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.FluidDrain.sprite = "FluidDrainIcon"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.FluidDrain.hovered_sprite = "FluidDrainIconDisabled"
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.FluidDrain.sprite = "FluidDrainIconDisabled"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.FluidDrain.hovered_sprite = "FluidDrainIcon"
	end
	
	-- Update the Item Drain Icone --
	if global.MF.itemLaserActivated == true then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.ItemDrain.sprite = "ItemDrainIcon"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.ItemDrain.hovered_sprite = "ItemDrainIconDisabled"
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.ItemDrain.sprite = "ItemDrainIconDisabled"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.ItemDrain.hovered_sprite = "ItemDrainIcon"
	end
	
	-- Update Energy Distribution Icon --
	if global.MF.internalEnergyDistributionActivated == true then
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDistribution.sprite = "EnergyDistributionIcon"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDistribution.hovered_sprite = "EnergyDistributionIconDisabled"
	else
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDistribution.sprite = "EnergyDistributionIconDisabled"
		player.gui.screen.mfGUI.mfGUIExtendedFrame.mfGUIExtFF2.EnergyDistribution.hovered_sprite = "EnergyDistributionIcon"
	end
end

-- When a GUI Button is clicked --
function buttonClicked(event)
	
	local player = getPlayer(event.player_index)
	
	-- Disable the info GUI Tanks update when the player is choosing a filter --
	if event.element.type == "choose-elem-button" then
		setPlayerVariable(player.name, "GUIUpdateInfoGUI", false)
	end
	
	
	-- Move GUI Button --
	if event.element.name == "MoveButton" then
		if player.gui.screen.mfGUI.caption == "" then
			player.gui.screen.mfGUI.caption = " "
			player.gui.screen.mfGUI.location.y = player.gui.screen.mfGUI.location.y + 10
		else
			player.gui.screen.mfGUI.caption = ""
			player.gui.screen.mfGUI.location.y = player.gui.screen.mfGUI.location.y -10
		end
	end
	
	-- Extend GUI Button --
	if event.element.name == "ArrowButton" then
		if player.gui.screen.mfGUI.mfGUIExtendedFrame.visible == false then
			player.gui.screen.mfGUI.mfGUIExtendedFrame.visible = true
			player.gui.screen.mfGUI.mfGUIbottomFrame.ArrowButton.sprite = "ArrowIconUp"
			player.gui.screen.mfGUI.mfGUIbottomFrame.ArrowButton.hovered_sprite = "ArrowIconUpOv"
		else
			player.gui.screen.mfGUI.mfGUIExtendedFrame.visible = false
			player.gui.screen.mfGUI.mfGUIbottomFrame.ArrowButton.sprite = "ArrowIconDown"
			player.gui.screen.mfGUI.mfGUIbottomFrame.ArrowButton.hovered_sprite = "ArrowIconDownOv"
		end
	end
	
	-- CallMF Button --
	if event.element.name == "CallMF" then
		callMobileFactory(player)
	end
	
	-- Fix Mobile Factory Button --
	if event.element.name == "FindMF" then
		fixMB(event)
	end
	
	-- Show/Hide the Mobile Factory Info GUI --
	if event.element.name == "MFInfos" then
		if player.gui.screen.mfInfoGUI.visible == false then
			player.gui.screen.mfInfoGUI.visible = true
			setPlayerVariable(player.name, "GUIUpdateInfoGUI", true)
		else
			player.gui.screen.mfInfoGUI.visible = false
			setPlayerVariable(player.name, "GUIUpdateInfoGUI", false)
		end
	end
	
	-- PortOutside button --
	if event.element.name == "PortOutside" then
		teleportPlayerOutside(player)
	end
	
	-- EnergyDrain button --
	if event.element.name == "EnergyDrain" then
		if global.MF.energyLaserActivated == true then global.MF.energyLaserActivated = false
		elseif global.MF.energyLaserActivated == false then global.MF.energyLaserActivated = true end
	end
	
	-- FluidDrain button --
	if event.element.name == "FluidDrain" then
		if global.MF.fluidLaserActivated == true then global.MF.fluidLaserActivated = false
		elseif global.MF.fluidLaserActivated == false then global.MF.fluidLaserActivated = true end
	end
	
	-- ItemDrain button --
	if event.element.name == "ItemDrain" then
		if global.MF.itemLaserActivated == true then global.MF.itemLaserActivated = false
		elseif global.MF.itemLaserActivated == false then global.MF.itemLaserActivated = true end
	end
	
	-- EnergyDistribution button --
	if event.element.name == "EnergyDistribution" then
		if global.MF.internalEnergyDistributionActivated == true then global.MF.internalEnergyDistributionActivated = false
		elseif global.MF.internalEnergyDistributionActivated == false then global.MF.internalEnergyDistributionActivated = true end
	end
	
	updatePlayerGUI(player)
end

-- Enable the Info GUI Tanks Update if a player have chose a filter --
function onGuiElemChanged(event)
	if global.tankTable == nil or global.tankTable == {} or event.element == nil or event.element.valid == false then return end	
	if event.element.get_mod() ~= "Mobile_Factory" then return end
	if event.element.type == "choose-elem-button" then
		if event.element.elem_value ~= nil then
			local id = tonumber(event.element.name)
			if global.tankTable[id] == nil or global.tankTable[id].valid == false then return end
			global.tankTable[id].filter = event.element.elem_value
		end
		local player = getPlayer(event.player_index)
		if player ~= nil then
			setPlayerVariable(player.name, "GUIUpdateInfoGUI", true)
		end
	end
end

-- Update the Mobile Factory Info GUI --
function updatePlayerInfoGUI(player)

	if global.MF == nil or global.MF.ent.valid == false then return end

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
	updateTankFrame(player)
	
	-- Update OreSilos Frame --
	updateOreSiloFrame(player.gui)
	
	-- Update Inventory frame --
	updateInventoryFrame(player.gui)
	
	-- Update Structures Frame --
	updateStructuresFrame(player.gui)
	
end
	
	
-- Update Tank Frame --
function updateTankFrame(player)
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
		local tank = global.MF.ccS.find_entity(id.name, id.position)
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
function updateOreSiloFrame(gui)
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
function updateInventoryFrame(gui)
	if global.inventoryTable == nil then return end
	-- Make the frame visible if the technology is unlocked --
	if technologyUnlocked("DimensionalLogistic") == false then return end
	gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow3.visible = true
	
	-- Clear all the frames --
	gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow3.InventoryPane.clear()
	-- Set the number of Items and type of Items text --
	gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow3.mfInventoryAmountLabel.caption = {"", {"gui-description.mfInventoryAmount"}, ": ", global.mfInventoryItems, "/", global.mfInventoryMaxItem}
	gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow3.mfInventoryTypeLabel.caption = {"", {"gui-description.mfInventoryType"}, ": ", global.mfInventoryTypes, "/" , global.mfInventoryMaxTypes}
	gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow3.mfInventoryPadLabel.caption = {"", {"gui-description.mfInventoryPadLabel"}, ": ", table_size(global.inventoryPadTable)}
	-- Create a Table with all Items --
	local allItemsTable = {}
	-- Insert all Items from the Internal Inventory --
	for k, item in pairs(global.inventoryTable) do
		allItemsTable[item.name] = item.amount
	end
	-- Insert all Items from Inventory Pad --
	for k, chest in pairs(global.inventoryPadTable) do
		-- Get the Inventory --
		local inv = chest.get_inventory(defines.inventory.chest)
		-- Test if the Inventory is valid --
		if inv ~= nil and inv.valid == true then
			-- Get Inventory content --
			local items = inv.get_contents()
			-- Test if items is valid --
			if items ~= nil then
				-- Look for ItemStack --
				for item, amount in pairs(items) do
					-- Test if the item is valid --
					if item ~= nil and amount > 1 then
						-- Look if the Item Already exist --
						if allItemsTable[item] ~= nil then
							-- Change the item amount --
							allItemsTable[item] = allItemsTable[item] + amount
						else
							-- Add the Item to the Table --
							allItemsTable[item] = amount
						end
					end
				end
			end
		end
	end
	-- Look for all Items --
	for item, amount in pairs(allItemsTable) do
			-- Test if Item is valid --
			if item ~= nil and amount ~= nil then
			-- Create the Frame --
			local frame = gui.screen.mfInfoGUI.mfInfoMainFlow.mfInfoFlow3.InventoryPane.add{type="frame", direction="horizontal"}
			frame.style.minimal_width = 100
			frame.style.margin = 0
			frame.style.padding = 0
			-- Add the Icon and the Tooltip to the frame --
			local sprite = frame.add{type="sprite", tooltip=item, sprite="item/" .. item}
			sprite.style.padding = 0
			sprite.style.margin = 0
			-- Add the amount label --
			local label = frame.add{type="label", caption=tonumber(amount)}
			label.style.padding = 0
			label.style.margin = 0
		end
	end
end
	
	
-- Update the Structure Frame --
function updateStructuresFrame(gui)
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
	if global.oreCleaner ~= nil then
		ocFrame.visible = true
		
		-- Create Labels and Bares --
		local nameLabel = ocFrame.add{type="label", caption={"", {"gui-description.OreCleaner"}}}
		local SpeedLabel = ocFrame.add{type="label", caption={"", {"gui-description.Speed"}, ": ", math.floor((_mfOCMinLasers + global.oreCleanerPurity) * (_mfOCOrePerLaser * global.oreCleanerPurity)), " ores/s"}}
		local ChargeLabel = ocFrame.add{type="label", caption={"", {"gui-description.Charge"}, ": ", global.oreCleanerCharge}}
		local ChargeBar = ocFrame.add{type="progressbar", value=global.oreCleanerCharge/_mfOreCleanerMaxCharge}
		local PurityLabel = ocFrame.add{type="label", caption={"", {"gui-description.Purity"}, ": ", math.floor(global.oreCleanerPurity*100)/100}}
		local PurityBar = ocFrame.add{type="progressbar", value=global.oreCleanerPurity/100}
		
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
	
	