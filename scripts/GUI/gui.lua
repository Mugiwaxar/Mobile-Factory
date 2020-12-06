require("scripts/GUI/main-gui.lua")
require("scripts/GUI/info-gui.lua")
require("scripts/GUI/option-gui.lua")
require("scripts/GUI/tooltip-gui.lua")
require("scripts/GUI/options.lua")
require("scripts/GUI/tp-gui.lua")
require("scripts/GUI/switchMF-gui.lua")
require("scripts/GUI/recipe-gui.lua")
require("utils/functions.lua")

-- Create a Camera Frame --
-- function GUI.createCamera(MFPlayer, name, ent, size, zoom)

-- 	-- Create the Frame --
-- 	local frameObj = GUI.createGUI("Camera" .. name, MFPlayer, "vertical", true)
-- 	frameObj.style.width = size
-- 	frameObj.style.height = size
	
-- 	-- Add the Top Bar --
-- 	GUI.createTopBar(frameObj, nil, name)
	
-- 	-- Create the Camera --
--     local camera = frameObj.gui.add{type="camera", position=ent.position, surface=ent.surface, zoom=zoom or 1}
--     camera.style.vertically_stretchable = true
-- 	camera.style.horizontally_stretchable = true

-- 	-- Center the Frame --
-- 	frameObj.force_auto_center()

-- 	-- Return the Frame --
-- 	return frameObj
	
-- end

-- Update all GUIs --
function GUI.updateAllGUIs(force)
	
		for _, player in pairs(game.connected_players) do
			
			-- Get the MFPlayer --
			local MFPlayer = getMFPlayer(player.name)

			-- Check the MFPlayer --
			if MFPlayer ~= nil then

				-- Update all Progress Bars of the Data Assembler  --
				if game.tick%_eventTick7 == 0 or force then
					if MFPlayer.GUI ~= nil and MFPlayer.GUI.MFTooltipGUI ~= nil and MFPlayer.GUI.MFTooltipGUI.DA ~= nil then
						MFPlayer.GUI.MFTooltipGUI.DA:updatePBars(MFPlayer.GUI.MFTooltipGUI)
					end
				end

				-- Update all GUIs --
				if game.tick%_eventTick55 == 0 or force then
				for _, GUItable in pairs(MFPlayer.GUI or {}) do
					if valid(GUItable) then GUItable:update() end
					if GUItable.gui ~= nil and GUItable.gui.valid == true and GUI["update" .. GUItable.gui.name] ~= nil then GUI["update" .. GUItable.gui.name](GUItable) end
				end

			end

		end
	end
end

-- A GUI was oppened --
function GUI.guiOpened(event)
	
	-- Check the Entity --
	if event.entity == nil or event.entity.valid == false then return end

	-- Get the Player --
	local player = getPlayer(event.player_index)

	-- Check the Player --
	if player == nil or player.valid == false then return end

	-- Get the MFPlayer --
	local MFPlayer = getMFPlayer(player.index)

	-- Do not open custom GUI if player is connecting wires --
	local cursorStack = player.cursor_stack
	if cursorStack and cursorStack.valid_for_read then
		if cursorStack.name == "green-wire" or cursorStack.name == "red-wire" or cursorStack.type == "repair-tool" then return end
	end

	-- Check the Bypass --
	if MFPlayer.varTable.bypassGUI == true then
		MFPlayer.varTable.bypassGUI = false
		return
	end

	-- Check if a GUI exist --
	local obj = global.entsTable[event.entity.unit_number]
	
	-- Check the Object --
	if valid(obj) == false or obj.getTooltipInfos == nil then return end

	-- Check Permissions --
	if Util.canUse(MFPlayer, obj) == false then return end

	-- Create and save the Tooltip gui --
	local GUITable = GUI.createTooltipGUI(player, obj)
	player.opened = GUITable.gui
	MFPlayer.GUI[_mfGUIName.TooltipGUI] = GUITable

end

-- A GUI was closed --
function GUI.guiClosed(event)

	-- Check the Element --
	if event.element == nil or event.element.valid ~= true then return end

	-- Get the Player --
	local playerIndex = event.player_index
	local MFPlayer = getMFPlayer(playerIndex)

	-- Close the Info GUI --
	if event.element.name == _mfGUIName.InfoGUI then
		MFPlayer.GUI[_mfGUIName.InfoGUI].gui.destroy()
		MFPlayer.GUI[_mfGUIName.InfoGUI] = nil
		return
	end

	-- Close the Option GUI --
	if event.element.name == _mfGUIName.OptionGUI then
		MFPlayer.GUI[_mfGUIName.OptionGUI].gui.destroy()
		MFPlayer.GUI[_mfGUIName.OptionGUI] = nil
		return
	end

	-- Close the Tootip GUI --
	if event.element.name == _mfGUIName.TooltipGUI then
		MFPlayer.GUI[_mfGUIName.TooltipGUI].gui.destroy()
		MFPlayer.GUI[_mfGUIName.TooltipGUI] = nil
		return
	end

	-- Close the TP GUI --
	if event.element.name == _mfGUIName.TPGUI then
		MFPlayer.GUI[_mfGUIName.TPGUI].gui.destroy()
		MFPlayer.GUI[_mfGUIName.TPGUI] = nil
		return
	end

	-- Close the SwitchMF GUI --
	if event.element.name == _mfGUIName.SwitchMF then
		MFPlayer.GUI[_mfGUIName.SwitchMF].gui.destroy()
		MFPlayer.GUI[_mfGUIName.SwitchMF] = nil
		return
	end

	-- Close Camera GUI --
	if string.match(event.element.name, "Camera") then
		local cameraName = event.element.name
		if MFPlayer.GUI[cameraName] ~= nil then
			MFPlayer.GUI[cameraName].destroy()
			MFPlayer.GUI[cameraName] = nil
		end
		return
	end

end

-- When a GUI Button is clicked --
function GUI.buttonClicked(event)
	-- Get the Player --
	local playerIndex = event.player_index
	local player = getPlayer(playerIndex)
	local MFPlayer = getMFPlayer(playerIndex)

	-- Get the Mobile Factory --
	local MF = getMF(player.name)
	if MF == nil then return end

	-- Get the Current Mobile Factory --
	local currentMF = getCurrentMF(player.name) or MF

	-- Get the Main GUI Object --
	local mainGUI = MFPlayer.GUI["MFMainGUI"]

	------- Read if the Element came from the Option GUI -------
	GUI.readOptions(event.element, player)
	if event.element == nil or event.element.valid == false then return end

	-- Open Info GUI Button --
	if event.element.name == "MainGUIInfosButton" then
		if MFPlayer.GUI[_mfGUIName.InfoGUI] == nil then
			local GUITable = GUI.createInfoGui(player)
			MFPlayer.GUI[_mfGUIName.InfoGUI] = GUITable
			player.opened = GUITable.gui
		else
			MFPlayer.GUI[_mfGUIName.InfoGUI].gui.destroy()
			MFPlayer.GUI[_mfGUIName.InfoGUI] = nil
		end
		return
	end

	-- Open Options GUI Button --
	if event.element.name == "MainGUIOptionButton" then
		if MFPlayer.GUI[_mfGUIName.OptionGUI] == nil then
			local GUITable = GUI.createOptionGUI(player)
			MFPlayer.GUI[_mfGUIName.OptionGUI] = GUITable
			player.opened = GUITable.gui
		else
			MFPlayer.GUI[_mfGUIName.OptionGUI].gui.destroy()
			MFPlayer.GUI[_mfGUIName.OptionGUI] = nil
		end
		return
	end

	-- Open the SwitchMF Button --
	if event.element.name == "SwitchMFButton" then
		if MFPlayer.GUI[_mfGUIName.SwitchMF] == nil then
			local GUITable = GUI.createSwitchMFGUI(player)
			MFPlayer.GUI[_mfGUIName.SwitchMF] = GUITable
			player.opened = GUITable.gui
		else
			MFPlayer.GUI[_mfGUIName.SwitchMF].gui.destroy()
			MFPlayer.GUI[_mfGUIName.SwitchMF] = nil
		end
		return
	end

	-- Jump Drive Button --
	if event.element.name == "JumpDriveButton" then
		if MFPlayer.GUI[_mfGUIName.TPGUI] == nil then
			local GUITable = GUI.createTPGui(player)
			MFPlayer.GUI[_mfGUIName.TPGUI] = GUITable
			player.opened = GUITable.gui
		else
			MFPlayer.GUI[_mfGUIName.TPGUI].gui.destroy()
			MFPlayer.GUI[_mfGUIName.TPGUI] = nil
		end
		return
	end

	-- If this is a Info GUI Deep Tank Filter --
	if string.match(event.element.name, "DTF") then
		if MFPlayer.GUI[_mfGUIName.InfoGUI] ~= nil then
			MFPlayer.GUI[_mfGUIName.InfoGUI].vars.freezeTankGUI = true
		end
	end

	-- If this is a Info GUI Deep Storage Filter --
	if string.match(event.element.name, "DSRF") then
		if MFPlayer.GUI[_mfGUIName.InfoGUI] ~= nil then
			MFPlayer.GUI[_mfGUIName.InfoGUI].vars.freezeStorageGUI = true
		end
	end

	-- Close Info GUI Button --
	if event.element.name == _mfGUIName.InfoGUI .. "CloseButton" then
		if MFPlayer.GUI[_mfGUIName.InfoGUI] ~= nil then
			MFPlayer.GUI[_mfGUIName.InfoGUI].gui.destroy()
			MFPlayer.GUI[_mfGUIName.InfoGUI] = nil
		end
		return
	end

	-- Close Option GUI Button --
	if event.element.name == _mfGUIName.OptionGUI .. "CloseButton" then
		if MFPlayer.GUI[_mfGUIName.OptionGUI] ~= nil then
			MFPlayer.GUI[_mfGUIName.OptionGUI].gui.destroy()
			MFPlayer.GUI[_mfGUIName.OptionGUI] = nil
		end
		return
	end

	-- Close Tooltip GUI Button --
	if event.element.name == _mfGUIName.TooltipGUI .. "CloseButton" then
		if MFPlayer.GUI[_mfGUIName.TooltipGUI] ~= nil then
			MFPlayer.GUI[_mfGUIName.TooltipGUI].gui.destroy()
			MFPlayer.GUI[_mfGUIName.TooltipGUI] = nil
		end
		return
	end

	-- Close TP GUI Button --
	if event.element.name == _mfGUIName.TPGUI .. "CloseButton" then
		if MFPlayer.GUI[_mfGUIName.TPGUI] ~= nil then
			MFPlayer.GUI[_mfGUIName.TPGUI].gui.destroy()
			MFPlayer.GUI[_mfGUIName.TPGUI] = nil
		end
		return
	end

	-- Close the SwitchMF GUI --
	if event.element.name == _mfGUIName.SwitchMF .. "CloseButton" then
		if MFPlayer.GUI[_mfGUIName.SwitchMF] ~= nil then
			MFPlayer.GUI[_mfGUIName.SwitchMF].gui.destroy()
			MFPlayer.GUI[_mfGUIName.SwitchMF] = nil
		end
		return
	end

	-- Close the Recipe GUI --
	if event.element.name == _mfGUIName.RecipeGUI .. "CloseButton" then
		if MFPlayer.GUI[_mfGUIName.RecipeGUI] ~= nil then
			MFPlayer.GUI[_mfGUIName.RecipeGUI].gui.destroy()
			MFPlayer.GUI[_mfGUIName.RecipeGUI] = nil
		end
		return
	end

	-- Close the Recipe Information GUI --
	if event.element.name == _mfGUIName.RecipeInfoGUI .. "CloseButton" then
		if MFPlayer.GUI[_mfGUIName.RecipeInfoGUI] ~= nil then
			MFPlayer.GUI[_mfGUIName.RecipeInfoGUI].gui.destroy()
			MFPlayer.GUI[_mfGUIName.RecipeInfoGUI] = nil
		end
		return
	end

	-- Close Camera Button --
	if string.match(event.element.name, "Camera") then
		local text = string.gsub(event.element.name, "CloseButton", "")
		if MFPlayer.GUI[text] ~= nil then
			MFPlayer.GUI[text].destroy()
			MFPlayer.GUI[text] = nil
		end
		return
	end

	-- Open the Main GUI --
	if event.element.name == "MainGUIOpen" then
		mainGUI.MFPlayer.varTable.MainGUIOpen = true
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
		return
	end

	-- Close the Main GUI --
	if event.element.name == "MainGUIClose" then
		mainGUI.MFPlayer.varTable.MainGUIOpen = false
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
		return
	end

	-- PortOutside button --
	if event.element.name == "PortOutsideButton" then
		teleportPlayerOutside(player)
		return
	end

	-- SyncArea button --
	if event.element.name == "SyncAreaButton" then
		if currentMF.syncAreaEnabled == true then currentMF.syncAreaEnabled = false
		elseif currentMF.syncAreaEnabled == false then currentMF.syncAreaEnabled = true end
		GUI.updateAllGUIs(true)
		return
	end

	-- Fix Mobile Factory Button --
	if event.element.name == "FindMFButton" then
		fixMB(event, currentMF)
		return
	end

	-- MFTPInside button --
	if event.element.name == "TPInsideButton" then
		if currentMF.tpEnabled == true then currentMF.tpEnabled = false
		elseif currentMF.tpEnabled == false then currentMF.tpEnabled = true end
		GUI.updateAllGUIs(true)
		return
	end

	-- MFLock button --
	if event.element.name == "LockMFButton" then
		if currentMF.locked == true then currentMF.locked = false
		else currentMF.locked = true end
		GUI.updateAllGUIs(true)
		return
	end

	-- EnergyDrain button --
	if event.element.name == "EnergyDrainButton" then
		if currentMF.energyLaserActivated == true then currentMF.energyLaserActivated = false
		elseif currentMF.energyLaserActivated == false then currentMF.energyLaserActivated = true end
		GUI.updateAllGUIs(true)
		return
	end

	-- FluidDrain button --
	if event.element.name == "FluidDrainButton" then
		if currentMF.fluidLaserActivated == true then currentMF.fluidLaserActivated = false
		elseif currentMF.fluidLaserActivated == false then currentMF.fluidLaserActivated = true end
		GUI.updateAllGUIs(true)
		return
	end

	-- ItemDrain button --
	if event.element.name == "ItemDrainButton" then
		if currentMF.itemLaserActivated == true then currentMF.itemLaserActivated = false
		elseif currentMF.itemLaserActivated == false then currentMF.itemLaserActivated = true end
		GUI.updateAllGUIs(true)
		return
	end

	-- Send Quatron button --
	if event.element.name == "QuatronDrainButton" then
		if currentMF.quatronLaserActivated == true then currentMF.quatronLaserActivated = false
		elseif currentMF.quatronLaserActivated == false then currentMF.quatronLaserActivated = true end
		GUI.updateAllGUIs(true)
		return
	end

	-- SwitchMF GUI Change Name Button --
	if string.match(event.element.name, "SwitchMFChangeNameButton") then
		if MFPlayer.GUI[_mfGUIName.SwitchMF].vars.SwitchMFChangeNameTextField ~= nil then
			-- Get the Name --
			local text = MFPlayer.GUI[_mfGUIName.SwitchMF].vars.SwitchMFChangeNameTextField.text
			-- Check if the Name is not the same Name --
			if text == MF.name then
				player.print({"gui-description.ChangeNameSameName"})
				return
			end
			-- Check if the Name is more than three Characters and less than 30 Characters --
			if string.len(text) < 3 or string.len(text) > 30 then
				player.print({"gui-description.ChangeNameCharNumberError"})
				return
			end
			-- Check if the Name is not already used --
			for _, MF2 in pairs(global.MFTable) do
				if MF2.name == text then
					player.print({"gui-description.ChangeNameAlreadyUsed"})
					return
				end
			end
			-- Change the Name --
			MF.name = text
			player.print({"", {"gui-description.ChangeNameChanged"}, " ", text})
		end
	end

	-- SwitchMF GUI Change Mobile Factory --
	if string.match(event.element.name, "SwitchMFSwitchButton") then
		-- Get the Mobile Factory ID --
		local ID = split(event.element.name, ",")
		-- Check the ID --
		if ID[2] == nil then return end
		-- Check if the Player is allowed to use this Mobile Factory --
		if Util.canUse(MFPlayer, global.MFTable[ID[2]]) == false then
			player.print({"gui-description.NotAllowedMF"})
			return
		end
		-- Change the Current Mobile Factory --
		MFPlayer.currentMF = global.MFTable[ID[2]]
		-- Display the Message --
		player.print({"", {"gui-description.CurrentMFChanged"}, " ", MFPlayer.currentMF.name})
	end

	-- If this is a Mobile Factory Button -> Open Inventory --
	if string.match(event.element.name, "MFOpenI") then
		-- Get the Object --
		local objId = split(event.element.name, ",")[2] or ""
		local ent = global.MFTable[objId].ent
		if ent ~= nil and ent.valid == true then
			getMFPlayer(player.name).varTable.bypassGUI = true
			player.opened = ent
		end
		return
	end

	-- If this is a Mater Interactor Button -> Open Inventory --
	if string.match(event.element.name, "MIOpenI") then
		-- Get the Object --
		local objId = tonumber(split(event.element.name, ",")[2])
		local obj = global.matterInteractorTable[objId]
		local ent = (obj and obj.ent) or nil
		if ent ~= nil and ent.valid == true then
			getMFPlayer(player.name).varTable.bypassGUI = true
			player.opened = ent
		end
		return
	end

	-- Recipe Selector Category Button --
	if string.match(event.element.name, "RSCategoryButton") then
		local GUITable = MFPlayer.GUI[_mfGUIName.RecipeGUI]
		local Category = tonumber(split(event.element.name, ",")[2]) or 1
		GUITable.vars["RSCategoryButton," .. GUITable.vars.selectedCategory].enabled = true
		GUITable.vars["RSCategoryButton," .. Category].enabled = false
		GUITable.vars.selectedCategory = Category
		GUI.updateMFRecipeGUI(GUITable, true)
		return
	end

	-- Recipe Selector Recipe Button --
	if string.match(event.element.name, "RSRecipeButton") then
		local tGUI = MFPlayer.GUI[_mfGUIName.TooltipGUI]
		if tGUI ~= nil and tGUI.vars.DA ~= nil then
			tGUI.vars["D.A.RecipeFilter"].elem_value = split(event.element.name, ",")[2]
		end
		MFPlayer.GUI[_mfGUIName.RecipeGUI].gui.destroy()
		MFPlayer.GUI[_mfGUIName.RecipeGUI] = nil
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Data Assembler --
	if string.match(event.element.name, "D.A.") then
		DA.interaction(event, MFPlayer)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Network Explorer --
	if string.match(event.element.name, "N.E.") then
		NE.interaction(event, playerIndex)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Network Access Point Area Switch --
	if string.match(event.element.name, "NAPAreaSwitch") then
		-- Get the Object --
		local objID = tonumber(split(event.element.name, ",")[2])
		local obj = global.networkAccessPointTable[objID]
		if valid(obj) == false then return end
		if event.element.switch_state == "left" then
			obj.showArea = false
		else
			obj.showArea = true
		end
		return
	end

	-- If this is The Jump Drive GUI --
	if string.match(event.element.name, "TPGUI") and event.element.type == "sprite-button" then
		-- If a location is added --
		if string.match(event.element.name, "TPGUIAddLoc") then
			local GUITable = MFPlayer.GUI["MFTPGUI"]
			if GUITable.vars.AddLocName ~= nil and GUITable.vars.AddLocName ~= "" then
				local jumpDrive = currentMF.jumpDriveObj
				jumpDrive:addLocation(GUITable.vars.AddLocName.text, GUITable.vars.AddLocFilter.elem_value)
			end
		end
		if string.match(event.element.name, "TPGUILoc") then
			local jumpDrive = currentMF.jumpDriveObj
			local location = string.sub(event.element.name, string.len("TPGUILoc,")+1 )
			-- Start the Jump --
			if event.button == defines.mouse_button_type.left then
				jumpDrive:jump(location)
			end
			-- Remove a Location --
			if event.button == defines.mouse_button_type.right then
				jumpDrive:removeLocation(location)
			end
		end
		-- Update all GUIs --
		GUI.updateAllGUIs(true)
		return
	end

end

-- Called when a GUI Element have changed it's state --
function GUI.onGuiElemChanged(event)
	-- Return if this is not a Mobile Factory element -
	if event.element.get_mod() ~= "Mobile_Factory" then return end
	-- Return if the Element is not valid --
	if event.element == nil or event.element.valid == false then return end
	-- Get the Player --
	local playerIndex = event.player_index
	local player = getPlayer(playerIndex)
	local MFPlayer = getMFPlayer(playerIndex)
	-- Return if the Player is not valid --
	if player == nil then return end
	-- Get the Mobile Factory --
	local MF = getMF(player.name)
	if MF == nil then return end
	-- Get the Current Mobile Factory --
	local currentMF = getCurrentMF(player.name) or MF
	
	------- Read if the Element came from the Option GUI -------
	GUI.readOptions(event.element, player)
	if event.element == nil or event.element.valid == false then return end

	-- If this is a Deep Storage --
	if string.match(event.element.name, "D.S.R.") then
		DSR.interaction(event)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Deep Tank --
	if string.match(event.element.name, "D.T.") then
		DSR.interaction(event)
		GUI.updateAllGUIs(true)
		return
	end
	
	------- Save the filter -------
	if event.element.type == "choose-elem-button" and event.element.get_mod() == "Mobile_Factory" then
		local id = event.element.name
		-- If this is a Matter Interactor --
		if string.match(id, "MIFilter") then
			id = tonumber(split(id, "MIFilter")[1])
			if global.matterInteractorTable[id] == nil then return end
			if event.element.elem_value ~= nil then
				global.matterInteractorTable[id].selectedFilter = event.element.elem_value
			else
				global.matterInteractorTable[id].selectedFilter = nil
			end
			GUI.updateAllGUIs(true)
			return
		end
	end

	----- Read if the Element comes from a Data Network Drop Down -------
	if string.match(event.element.name, "DNSelect") then
		-- Get the Object --
		local ID = tonumber(split(event.element.name, ",")[2])
		if ID == nil then return end
		local obj = global.entsTable[ID]
		if obj == nil then return end
		-- Get the Mobile Factory --
		local selectedMF = getMF(event.element.items[event.element.selected_index])
		if selectedMF == nil then return end
		-- Set the New Data Network --
		obj.dataNetwork = selectedMF.dataNetwork
		-- Update the Tooltip GUI --
		GUI.updateMFTooltipGUI(MFPlayer.GUI["MFTooltipGUI"], true)
		return
	end
	
	------- Read if the Element comes from an Ore Cleaner -------
	-- Select Data Network --
	if string.match(event.element.name, "DNOCSelect") then
		-- Find the Ore Cleaner ID --
		local ID = split(event.element.name, "DNOCSelect")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Ore Cleaner --
		local obj = global.entsTable[ID]
		-- Check if a Ore Cleaner was found --
		if obj == nil then return end
		-- Get the Mobile Factory --
		local selectedMF = getMF(event.element.items[event.element.selected_index])
		if selectedMF == nil then return end
		-- Set the New Data Network --
		obj.dataNetwork = selectedMF.dataNetwork
		-- Remove the Selected Inventory --
		obj.selectedInv = nil
		-- Update the Tooltip GUI --
		GUI.updateMFTooltipGUI(MFPlayer.GUI["MFTooltipGUI"], true)
		return
	end
	-- Select Targed --
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
	
	------- Read if the Element comes from a Fluid Extractor -------
	-- Select Data Network --
	if string.match(event.element.name, "DNFESelect") then
		-- Find the Fluid Extractor ID --
		local ID = split(event.element.name, "DNFESelect")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Fluid Extractor --
		local obj = global.entsTable[ID]
		-- Check if a Fluid Extractor was found --
		if obj == nil then return end
		-- Get the Mobile Factory --
		local selectedMF = getMF(event.element.items[event.element.selected_index])
		if selectedMF == nil then return end
		-- Set the New Data Network --
		obj.dataNetwork = selectedMF.dataNetwork
		-- Remove the Selected Inventory --
		obj.selectedInv = nil
		-- Update the Tooltip GUI --
		GUI.updateMFTooltipGUI(MFPlayer.GUI["MFTooltipGUI"], true)
		return
	end
	-- Select the Target --
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
		fluidExtractor:changeDimTank(tonumber(event.element.items[event.element.selected_index][4]))
	end
	
	------- Read if the Element comes from a Matter Serializer -------
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
	
	------- Read if the Element comes from a Matter Printer -------
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

	------- Read if the Element comes from a Matter Interactor Mode -------
	if string.match(event.element.name, "MIMode") then
		local ID = split(event.element.name, "MIMode")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Matter Manipulator --
		local matterI = nil
		for k, mi in pairs(global.matterInteractorTable) do
			if valid(mi) == true and mi.ent.unit_number == ID then
				matterI = mi
			end
		end
		-- Check if a Fluid Interactor was found --
		if matterI == nil then return end
		-- Change the Mode --
		matterI:changeMode(event.element.switch_state)
	end

	------- Read if the Element comes from a Matter Interactor Player Target -------
	if string.match(event.element.name, "MIPlayerTarget") then
		local ID = split(event.element.name, "MIPlayerTarget")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Matter Interactor --
		local matterI = nil
		for k, mi in pairs(global.matterInteractorTable) do
			if valid(mi) == true and mi.ent.unit_number == ID then
				matterI = mi
			end
		end
		-- Check if a Matter Interactor was found --
		if matterI == nil then return end
		-- Change the Matter Interactor Player Target --
		matterI:changePlayer(event.element.items[event.element.selected_index][2])
	end

	------- Read if the Element comes from a Matter Interactor Target -------
	if string.match(event.element.name, "MITarget") then
		local ID = split(event.element.name, "MITarget")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Matter Interactor --
		local matterI = nil
		for k, mi in pairs(global.matterInteractorTable) do
			if valid(mi) == true and mi.ent.unit_number == ID then
				matterI = mi
			end
		end
		-- Check if a Matter Interactor was found --
		if matterI == nil then return end
		-- Change the Matter Interactor Target --
		matterI:changeInventory(tonumber(event.element.items[event.element.selected_index][5]))
	end

	------- Read if the Element comes from a Fluid Interactor Mode -------
	if string.match(event.element.name, "FIMode") then
		local ID = split(event.element.name, "FIMode")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Fluid Manipulator --
		local fluidI = nil
		for k, fi in pairs(global.fluidInteractorTable) do
			if valid(fi) == true and fi.ent.unit_number == ID then
				fluidI = fi
			end
		end
		-- Check if a Fluid Interactor was found --
		if fluidI == nil then return end
		-- Change the Mode --
		fluidI:changeMode(event.element.switch_state)
	end

	------- Read if the Element comes from a Fluid Interactor Target -------
	if string.match(event.element.name, "FITarget") then
		local ID = split(event.element.name, "FITarget")
		ID = tonumber(ID[1])
		-- Check the ID --
		if ID == nil then return end
		-- Find the Fluid Manipulator --
		local fluidI = nil
		for k, fi in pairs(global.fluidInteractorTable) do
			if valid(fi) == true and fi.ent.unit_number == ID then
				fluidI = fi
			end
		end
		-- Check if a Fluid Interactor was found --
		if fluidI == nil then return end
		-- Change the Fluid Interactor Target --
		fluidI:changeInventory(tonumber(event.element.items[event.element.selected_index][5]))
	end

	------- Read if the Element comes from The Mobile Factory Energy Laser -------
	if string.match(event.element.name, "MFPL") then
		-- Look for the Mobile Factory ID --
		local ID = split(event.element.name, "MFPL")
		ID = tonumber(ID[1])
		if ID == nil then return end
		local MF2 = getMF(ID)
		-- Change the Energy Laser to Drain/Send --
		if event.element.switch_state == "left" then
			MF2.selectedEnergyLaserMode = "input"
		else
			MF2.selectedEnergyLaserMode = "output"
		end
	end

	------- Read if the Element comes from The Mobile Factory Quatron Laser -------
	if string.match(event.element.name, "MFQL") then
		-- Look for the Mobile Factory ID --
		local ID = split(event.element.name, "MFQL")
		ID = tonumber(ID[1])
		if ID == nil then return end
		local MF2 = getMF(ID)
		-- Change the Matter Serializer targeted Inventory --
		if event.element.switch_state == "left" then
			MF2.selectedQuatronLaserMode = "input"
		else
			MF2.selectedQuatronLaserMode = "output"
		end
	end

	------- Read if the Element comes from the Mobile Factory Fluid Laser mode -------
	if string.match(event.element.name, "MFFMode") then
		-- Look for the Mobile Factory ID --
		local ID = split(event.element.name, "MFFMode")
		ID = tonumber(ID[1])
		if ID == nil then return end
		local MF2 = getMF(ID)
		-- Change the Mode --
		if event.element.switch_state == "left" then
			MF2.selectedFluidLaserMode = "input"
		else
			MF2.selectedFluidLaserMode = "output"
		end
	end

	------- Read if the Element comes from the Mobile Factory Fluid Laser Target -------
	if string.match(event.element.name, "MFFTarget") then
		-- Look for the Mobile Factory ID --
		local ID = split(event.element.name, "MFFTarget")
		ID = tonumber(ID[1])
		if ID == nil then return end
		local MF2 = getMF(ID)
		-- Change the Fluid Interactor Target --
		MF2:fluidLaserTarget(tonumber(event.element.items[event.element.selected_index][4]))
	end

end

-- Called when a Localized Name is requested --
function onStringTranslated(event)
	-- Get the Tooltip GUI --
	local GUITable = getMFPlayer(event.player_index).GUI[_mfGUIName.TooltipGUI]
	-- Check the GUI --
	if GUITable == nil or GUITable.gui == nil or GUITable.gui.valid == false then return end
	-- Check the Localised String --
	if event.localised_string[1] == nil then return end
	-- Add the Localised String --
	GUITable.vars.tmpLocal[event.localised_string[1]] = event.result
end
