require("scripts/GUI/main-gui.lua")
require("scripts/GUI/info-gui.lua")
require("scripts/GUI/option-gui.lua")
require("scripts/GUI/tooltip-gui.lua")
require("scripts/GUI/options.lua")
require("scripts/GUI/deploy-gui.lua")
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
					if GUItable.gui ~= nil and GUItable.gui.valid == true and GUI["update" .. GUItable.gui.name] ~= nil then GUI["update" .. GUItable.gui.name](GUItable) end
				end

			end

		end
	end
end

-- Open the Tooltip GUI --
function GUI.openTTGui(MFPlayer, player, entity)

	-- Check the Entity --
	if entity == nil or entity.valid == false then return end

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
	local obj = global.entsTable[entity.unit_number]

	-- Check the Object --
	if valid(obj) == false or obj.getTooltipInfos == nil then return end

	-- Check Permissions --
	if canUse(MFPlayer, obj) == false then player.opened = nil return end

	-- Create and save the Tooltip gui --
	local GUITable = GUI.createTooltipGUI(player, obj)
	player.opened = GUITable.gui
	MFPlayer.GUI[_mfGUIName.TooltipGUI] = GUITable

end

-- A GUI is Opened --
function GUI.guiOpened(event)
	-- Check the Entity --
	if event.entity == nil or event.entity.valid == false then return end
	local player = getPlayer(event.player_index)
	local MFPlayer = getMFPlayer(event.player_index)
	if mfCall(GUI.openTTGui, MFPlayer, player, player.selected) == true then
		getPlayer(event.player_index).print({"gui-description.openTTGui_Failled"})
		Event.clearGUI(event)
	end
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

	-- Close the Deploy GUI --
	if event.element.name == _mfGUIName.DeployGUI then
		MFPlayer.GUI[_mfGUIName.DeployGUI].gui.destroy()
		MFPlayer.GUI[_mfGUIName.DeployGUI] = nil
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
	local mainGUI = MFPlayer.GUI[_mfGUIName.MainGUI]

	-- Unfreeze the Info GUI --
	if MFPlayer.GUI[_mfGUIName.InfoGUI] ~= nil then
		MFPlayer.GUI[_mfGUIName.InfoGUI].vars.freezeTankGUI = false
		MFPlayer.GUI[_mfGUIName.InfoGUI].vars.freezeStorageGUI = false
	end

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

	-- Deploy Button --
	if event.element.name == "MFDeployButton" then
		if event.button == defines.mouse_button_type.right then
			player.clear_cursor()
			player.cursor_stack.set_stack({name="MFDeploy", count=1})
			return
		end
		if MFPlayer.GUI[_mfGUIName.DeployGUI] == nil then
			local GUITable = GUI.createDeployGUI(player)
			MFPlayer.GUI[_mfGUIName.DeployGUI] = GUITable
			player.opened = GUITable.gui
		else
			MFPlayer.GUI[_mfGUIName.DeployGUI].gui.destroy()
			MFPlayer.GUI[_mfGUIName.DeployGUI] = nil
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

	-- Close Deploy GUI Button --
	if event.element.name == _mfGUIName.DeployGUI .. "CloseButton" then
		if MFPlayer.GUI[_mfGUIName.DeployGUI] ~= nil then
			MFPlayer.GUI[_mfGUIName.DeployGUI].gui.destroy()
			MFPlayer.GUI[_mfGUIName.DeployGUI] = nil
		end
		return
	end

	-- Close Slot GUI Button --
	if event.element.name == _mfGUIName.SlotGUI .. "CloseButton" then
		if MFPlayer.GUI[_mfGUIName.SlotGUI] ~= nil then
			MFPlayer.GUI[_mfGUIName.SlotGUI].gui.destroy()
			MFPlayer.GUI[_mfGUIName.SlotGUI] = nil
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

	-- If this is for the Information GUI --
	if string.match(event.element.name, "Inf.GUI.") then
		GUI.infoGUIInteraction(event, player, MFPlayer)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is for the Option GUI --
	if string.match(event.element.name, "Opt.GUI.") then
		GUI.readOptions(event.element, player)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is for the Switch MF GUI --
	if string.match(event.element.name, "Swi.GUI.") then
		GUI.switchMFGUIInteraction(event, player, MFPlayer)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is for the TP GUI --
	if string.match(event.element.name, "TP.GUI.") then
		GUI.TPMFGUIInteraction(event, MFPlayer, currentMF)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is for the Deploy GUI --
	if string.match(event.element.name, "DP.GUI.") then
		GUI.MFDPGUIInteraction(event, MFPlayer, currentMF)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is for the Recipe GUI --
	if string.match(event.element.name, "Rec.GUI.") then
		GUI.recipeGUIInteraction(event, MFPlayer)
		GUI.updateAllGUIs(true)
		return
	end

	-- PortOutside button --
	if event.element.name == "PortOutsideButton" then
		teleportPlayerOutside(player)
		return
	end

	-- -- SyncArea button --
	-- if event.element.name == "SyncAreaButton" then
	-- 	if currentMF.syncAreaEnabled == true then currentMF.syncAreaEnabled = false
	-- 	elseif currentMF.syncAreaEnabled == false then currentMF.syncAreaEnabled = true end
	-- 	GUI.updateAllGUIs(true)
	-- 	return
	-- end

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

	-- If this is a Mobile Factory --
	if string.match(event.element.name, "M.F.") then
		MF.interaction(event, player, MFPlayer)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Network Explorer --
	if string.match(event.element.name, "N.A.P.") then
		NAP.interaction(event)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Mater Interactor Button --
	if string.match(event.element.name, "M.I.") then
		MI.interaction(event, player)
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

end

-- When a GUI Element changed --
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
	
	-- If this is for the Option GUI --
	if string.match(event.element.name, "Opt.GUI.") then
		GUI.readOptions(event.element, player)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is for the Information GUI --
	if string.match(event.element.name, "Inf.GUI.") then
		GUI.infoGUIInteraction(event, player, MFPlayer)
		GUI.updateAllGUIs(true)
		-- Unfreeze the Info GUI --
		if MFPlayer.GUI[_mfGUIName.InfoGUI] ~= nil then
			MFPlayer.GUI[_mfGUIName.InfoGUI].vars.freezeTankGUI = false
			MFPlayer.GUI[_mfGUIName.InfoGUI].vars.freezeStorageGUI = false
		end
		return
	end

	-- If this is for the Recipe GUI --
	if string.match(event.element.name, "Rec.GUI.") then
		GUI.recipeGUIInteraction(event, player)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Mobile Factory --
	if string.match(event.element.name, "M.F.") then
		MF.interaction(event)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Data Network --
	if string.match(event.element.name, "D.N.") then
		DN.interaction(event, MFPlayer)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Deep Storage --
	if string.match(event.element.name, "D.S.R.") then
		DSR.interaction(event)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Deep Tank --
	if string.match(event.element.name, "D.T.") then
		DTK.interaction(event)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Matter Interactor --
	if string.match(event.element.name, "M.I.") then
		MI.interaction(event, player)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Fluid Interactor --
	if string.match(event.element.name, "F.I.") then
		FI.interaction(event)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Fluid Extractor --
	if string.match(event.element.name, "F.E.") then
		FE.interaction(event, MFPlayer)
		GUI.updateAllGUIs(true)
		return
	end

	-- If this is a Ore Cleaner --
	if string.match(event.element.name, "O.C.") then
		OC.interaction(event, MFPlayer)
		GUI.updateAllGUIs(true)
		return
	end



end

-- Called when a Localized Name is requested --
function GUI.onStringTranslated(event)
	-- Get the MFPlayer --
	local MFPlayer = getMFPlayer(event.player_index)
	-- Check the MFPlayer --
	if MFPlayer == nil then return end
	-- Get the Tooltip GUI --
	local GUITable = MFPlayer.GUI[_mfGUIName.RecipeGUI] or MFPlayer.GUI[_mfGUIName.TooltipGUI]
	-- Check the GUI --
	if GUITable == nil or GUITable.gui == nil or GUITable.gui.valid == false then return end
	-- Check the Localised String --
	if event.localised_string[1] == nil then return end
	-- Add the Localised String --
	GUITable.vars.tmpLocal = GUITable.vars.tmpLocal or {}
	GUITable.vars.tmpLocal[event.localised_string[1]] = event.result
end
