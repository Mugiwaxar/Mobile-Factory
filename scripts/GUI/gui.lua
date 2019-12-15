require("scripts/GUI/main-gui.lua")
require("scripts/GUI/info-gui.lua")
require("scripts/GUI/option-gui.lua")
require("scripts/GUI/tooltip-gui.lua")
require("scripts/GUI/options.lua")
require("utils/functions.lua")

function GUI.createPlayerGui(player)
	-- Get the GUI --
	local gui = player.gui
	-- Create the Main GUI --
	GUI.createMainGUI(player, gui)
	-- Create the Info GUI --
	GUI.createInfoGui(gui, player)
	-- Create the Option GUI --
	GUI.createOptionGUI(gui, player)
	-- Create the Option GUI --
	GUI.createTooltipGUI(gui, player)
end

-- Update the GUI of all player --
function GUI.updateAllGUIs()
	-- List all player connected end update it GUI --
	for k, player in pairs(game.connected_players) do
		GUI.updatePlayerGUI(player)
	end
end

-- Update a Player GUI --
function GUI.updatePlayerGUI(player)
-- Test if a player got an updated GUI else create --
	if getPlayerVariable(player.name, "VisitedFactory") == true then
		if getPlayerVariable(player.name, "GUICreated") ~= true then
			GUI.createPlayerGui(player)
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
	
	-- Update the Main GUI --
	GUI.mainGUIUpdate(player)
	-- Update the Player Info GUI --
	GUI.updatePlayerInfoGUI(player)
	-- Update the Tooltip GUI --
	GUI.updateTooltip(player, getPlayerVariable(player.name, "lastEntitySelected"))
end


-- When a GUI Button is clicked --
function GUI.buttonClicked(event)
	
	local player = getPlayer(event.player_index)
	
	-- Disable the info GUI Tanks update when the player is choosing a filter --
	if event.element.type == "choose-elem-button" then
		setPlayerVariable(player.name, "GUIUpdateInfoGUI", false)
	end
	
	
	-- Move GUI Button --
	if event.element.name == "MoveButton" then
		if player.gui.screen.mfGUI.caption == "" then
			player.gui.screen.mfGUI.caption = "Mobile Factory"
			player.gui.screen.mfGUI.location.y = player.gui.screen.mfGUI.location.y + 10
		else
			player.gui.screen.mfGUI.caption = ""
			player.gui.screen.mfGUI.location.y = player.gui.screen.mfGUI.location.y - 10
		end
	end
	
	-- Reduce GUI Button --
	if event.element.name == "ReduceButton" then
		if player.gui.screen.mfGUI.mfGUICenterFrame.visible == false then
			player.gui.screen.mfGUI.mfGUICenterFrame.visible = true
			player.gui.screen.mfGUI.mfGUIMenuFrame.ReduceButton.sprite = "ArrowIconUp"
			player.gui.screen.mfGUI.mfGUIMenuFrame.ReduceButton.hovered_sprite = "ArrowIconUpOv"
		else
			player.gui.screen.mfGUI.mfGUICenterFrame.visible = false
			player.gui.screen.mfGUI.mfGUIMenuFrame.ReduceButton.sprite = "ArrowIconDown"
			player.gui.screen.mfGUI.mfGUIMenuFrame.ReduceButton.hovered_sprite = "ArrowIconDownOv"
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
	
	-- MFTPInside button --
	if event.element.name == "MFTPInside" then
		if global.MF.tpEnabled == true then global.MF.tpEnabled = false
		elseif global.MF.tpEnabled == false then global.MF.tpEnabled = true end
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
	
	-- Show/Hide the Tooltip GUI --
	if event.element.name == "MFInspect" then
		if player.gui.screen.mfTooltipGUI.visible == false then
			player.gui.screen.mfTooltipGUI.visible = true
			setPlayerVariable(player.name, "GUIUpdateTooltipGUI", true)
		else
			player.gui.screen.mfTooltipGUI.visible = false
			setPlayerVariable(player.name, "GUIUpdateTooltipGUI", false)
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
	
	-- Open Options GUI Button --
	if event.element.name == "optionButton" then
		player.gui.screen.mfOptionGUI.visible = true
	end
	
	-- Close Info GUI Button --
	if event.element.name == "CloseButton" then
		player.gui.screen.mfInfoGUI.visible = false
		setPlayerVariable(player.name, "GUIUpdateInfoGUI", false)
	end
	
	-- Close Options GUI Button --
	if event.element.name == "OptCloseButton" then
		player.gui.screen.mfOptionGUI.visible = false
	end
	
	-- Lock Tooltip GUI button --
	if event.element.name == "TTLockButton" then
		if player.gui.screen.mfTooltipGUI.mfTTGUIMenuBar.TTLockButton.sprite == "LockIcon" then
			player.gui.screen.mfTooltipGUI.mfTTGUIMenuBar.TTLockButton.sprite = "LockIconReed"
		else
			player.gui.screen.mfTooltipGUI.mfTTGUIMenuBar.TTLockButton.sprite = "LockIcon"
		end
	end
	
	-- Move Tooltip GUI Button --
	if event.element.name == "TTMoveButton" then
		if player.gui.screen.mfTooltipGUI.caption == "" then
			player.gui.screen.mfTooltipGUI.caption = {"gui-description.tooltipGUI"}
			player.gui.screen.mfTooltipGUI.location.y = player.gui.screen.mfTooltipGUI.location.y + 10
		else
			player.gui.screen.mfTooltipGUI.caption = ""
			player.gui.screen.mfTooltipGUI.location.y = player.gui.screen.mfTooltipGUI.location.y - 10
		end
	end
	
	-- Close Tooltip GUI Button --
	if event.element.name == "TTCloseButton" then
		player.gui.screen.mfTooltipGUI.visible = false
	end
	
	-- Update the GUI --
	GUI.updatePlayerGUI(player)
	
end

-- Called when a GUI Element have changed it's state --
function GUI.onGuiElemChanged(event)
	-- Return if this is not a Mobile Factory element -
	if event.element.get_mod() ~= "Mobile_Factory" then return end
	-- Get the Player --
	local player = getPlayer(event.player_index)
	-- Return if the Player is not valid --
	if player == nil then return end
	-- Read if the Element came from the Option GUI --
	GUI.readOptions(event.element, player, player.gui)
	-- Save the filter --
	if global.tankTable == nil or global.tankTable == {} or event.element == nil or event.element.valid == false then return end	
	if event.element.type == "choose-elem-button" then
		if event.element.elem_value ~= nil then
			local id = tonumber(event.element.name)
			if global.tankTable[id] == nil then return end
			global.tankTable[id].filter = event.element.elem_value
		end
		-- Re-enable the GUI --
		if player ~= nil then
			setPlayerVariable(player.name, "GUIUpdateInfoGUI", true)
		end
	end
end
