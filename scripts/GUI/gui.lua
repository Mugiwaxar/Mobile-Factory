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
	
	-- Get the Player --
	local player = getPlayer(event.player_index)
	if player == nil then return end

	-- Get the Mobile Factory --
	local MF = getMF(player.name)
	if MF == nil then return end
	
	-- Disable the info GUI Tanks update when the player is choosing a filter --
	if event.element.type == "choose-elem-button" and event.element.get_mod() == "Mobile_Factory" then
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

	-- PortOutside button --
	if event.element.name == "PortOutside" then
		teleportPlayerOutside(player)
	end
	
	-- MFTPInside button --
	if event.element.name == "MFTPInside" then
		if MF.tpEnabled == true then MF.tpEnabled = false
		elseif MF.tpEnabled == false then MF.tpEnabled = true end
	end

	-- MFLock button --
	if event.element.name == "MFLock" then
		if MF.locked == true then
			MF.locked = false
			player.print({"gui-description.MFUnlocked"})
		else
			MF.locked = true
			player.print({"gui-description.MFLocked"})
		end
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
	
	-- EnergyDrain button --
	if event.element.name == "EnergyDrain" then
		if MF.energyLaserActivated == true then MF.energyLaserActivated = false
		elseif MF.energyLaserActivated == false then MF.energyLaserActivated = true end
	end
	
	-- FluidDrain button --
	if event.element.name == "FluidDrain" then
		if MF.fluidLaserActivated == true then MF.fluidLaserActivated = false
		elseif MF.fluidLaserActivated == false then MF.fluidLaserActivated = true end
	end
	
	-- ItemDrain button --
	if event.element.name == "ItemDrain" then
		if MF.itemLaserActivated == true then MF.itemLaserActivated = false
		elseif MF.itemLaserActivated == false then MF.itemLaserActivated = true end
	end
	
	-- EnergyDistribution button --
	if event.element.name == "EnergyDistribution" then
		if MF.internalEnergyDistributionActivated == true then MF.internalEnergyDistributionActivated = false
		elseif MF.internalEnergyDistributionActivated == false then MF.internalEnergyDistributionActivated = true end
	end
	
	-- Send Quatron button --
	if event.element.name == "SendQuatron" then
		if MF.sendQuatronActivated == true then MF.sendQuatronActivated = false
		elseif MF.sendQuatronActivated == false then MF.sendQuatronActivated = true end
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
			setPlayerVariable(player.name, "TTGUILocked", true)
		else
			player.gui.screen.mfTooltipGUI.mfTTGUIMenuBar.TTLockButton.sprite = "LockIcon"
			setPlayerVariable(player.name, "TTGUILocked", false)
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
	-- Return if the Element is not valid --
	if event.element == nil or event.element.valid == false then return end	
	-- Get the Player --
	local player = getPlayer(event.player_index)
	-- Return if the Player is not valid --
	if player == nil then return end
	-- Get the Mobile Factory --
	local MF = getMF(player.name)
	if MF == nil then return end
	
	------- Read if the Element came from the Option GUI -------
	GUI.readOptions(event.element, player, player.gui)
	
	------- Save the filter -------
	if event.element.type == "choose-elem-button" and event.element.get_mod() == "Mobile_Factory" then
		local id = event.element.name

		-- If this is a Dimensional Tank --
		if string.match(id, "TF") then
			-- Get
			id = tonumber(split(id, "TF")[1])
			if MF.varTable.tanks[id] == nil then return end
			if event.element.elem_value ~= nil then
				MF.varTable.tanks[id].filter = event.element.elem_value
			else
				MF.varTable.tanks[id].filter = nil
			end
		end

		-- If this is a Deep Storage --
		if string.match(id, "DSRF") then
			id = tonumber(split(id, "DSRF")[1])
			if global.deepStorageTable[id] == nil then return end
			if event.element.elem_value ~= nil then
				global.deepStorageTable[id].filter = event.element.elem_value
			else
				global.deepStorageTable[id].filter = nil
			end
		end

		-- Re-enable the GUI --
		if player ~= nil then
			setPlayerVariable(player.name, "GUIUpdateInfoGUI", true)
		end
	end
	
	------- Read if the Element comes from an Wireless Data Receiver -------
	if string.match(event.element.name, "WDR") then
		-- Find the Receiver ID --
		local ID = split(event.element.name, "WDR")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Receiver --
		local receiver = nil
		for k, wdr in pairs(global.wirelessDataReceiverTable) do
			if valid(wdr) == true and wdr.ent.unit_number == ID then
				receiver = wdr
			end
		end
		-- Check if a Receiver was found --
		if receiver == nil then return end
		-- Change the Receiver Data Network --
		receiver:changeTransmitter(tonumber(event.element.items[event.element.selected_index]))
	end
	
	------- Read if the Element comes from an Ore Cleaner -------
	if string.match(event.element.name, "OC") then
		-- Find the Ore Cleaner ID --
		local ID = split(event.element.name, "OC")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Ore Cleaner --
		local oreCleaner = nil
		for k, oc in pairs(global.oreCleanerTable) do
			if valid(oc) == true and oc.ent.unit_number == ID then
				oreCleaner = oc
			end
		end
		-- Check if a Ore Cleaner was found --
		if oreCleaner == nil then return end
		-- Change the Ore Cleaner targeted Deep Storage --
		oreCleaner:changeInventory(tonumber(event.element.items[event.element.selected_index][4]))
	end
	
	------- Read if the Element comes from an Fluid Extractor -------
	if string.match(event.element.name, "FE") then
		-- Find the Fluid Extractor ID --
		local ID = split(event.element.name, "FE")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Fluid Extractor --
		local fluidExtractor = nil
		for k, fe in pairs(global.fluidExtractorTable) do
			if valid(fe) == true and fe.ent.unit_number == ID then
				fluidExtractor = fe
			end
		end
		-- Check if a Fluid Extractor was found --
		if fluidExtractor == nil then return end
		-- Change the Fluid Extractor targeted Dimensional Tank --
		fluidExtractor:changeDimTank(tonumber(event.element.items[event.element.selected_index]))
	end
	
	------- Read if the Element comes from an Matter Serializer -------
	if string.match(event.element.name, "MS") then
		-- Find the Matter Serializer ID --
		local ID = split(event.element.name, "MS")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Matter Serializer --
		local matterS = nil
		for k, ms in pairs(global.matterSerializerTable) do
			if valid(ms) == true and ms.ent.unit_number == ID then
				matterS = ms
			end
		end
		-- Check if a Matter Serializer was found --
		if matterS == nil then return end
		-- Change the Matter Serializer targeted Inventory --
		matterS:changeInventory(tonumber(event.element.items[event.element.selected_index][4]))
	end
	------- Read if the Element comes from an Matter Printer -------
	if string.match(event.element.name, "MP") then
		-- Find the Matter Printer ID --
		local ID = split(event.element.name, "MP")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Matter Printer --
		local matterP = nil
		for k, mp in pairs(global.matterPrinterTable) do
			if valid(mp) == true and mp.ent.unit_number == ID then
				matterP = mp
			end
		end
		-- Check if a Matter Printer was found --
		if matterP == nil then return end
		-- Change the Matter Printer targeted Inventory --
		matterP:changeInventory(tonumber(event.element.items[event.element.selected_index][4]))
	end
	------- Read if the Element comes from The Mobile Factory Power Laser -------
	if string.match(event.element.name, "MFPL") then
		-- Change the Matter Serializer targeted Inventory --
		MF:changePowerLaserMode(event.element.selected_index)
	end
	
	------- Read if the Element comes from a Mining Jet Flag -------
	if string.match(event.element.name, "MJF") then
		-- Find the Mining Jet Flag ID --
		local ID = split(event.element.name, "MJF")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Mining Jet Flag --
		local mjFlag = nil
		for k, mjf in pairs(global.jetFlagTable) do
			if valid(mjf) == true and mjf.ent.unit_number == ID then
				mjFlag = mjf
			end
		end
		-- Check if a Mining Jet Flag was found --
		if mjFlag == nil then return end
		-- Change the Mining Jet Flag targeted Inventory --
		mjFlag:changeInventory(tonumber(event.element.items[event.element.selected_index][4]))
	end
end