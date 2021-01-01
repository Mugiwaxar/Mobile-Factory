-- When a player join the game --
function Event.initPlayer(event)
	local player = getPlayer(event.player_index)
	if player == nil then return end
	if player.controller_type == defines.controllers.cutscene then return end
	--player.force.technologies["DimensionalOre"].researched = true
	if getMFPlayer(player.name) == nil then
		global.playersTable[player.name] = MFP:new(player)
		-- Mobile Factory Object --
		local MF = MF:new({player = player})
		createMFSurface(MF)
		createControlRoom(MF)
		global.playersTable[player.name].MF = MF
		------------------- Can't get the Player Inventory when the Mod Init since the Factorio 1.0 Version -------------------
		if mfCall(addMobileFactory, player) == true then
			player.print({"gui-description.initPlayer_AddMFFailed"})
		end
		setPlayerVariable(player.name, "GotInventory", true)
		if mfCall(GUI.createMFMainGUI, player) == true then
			player.print({"gui-description.initPlayer_CreateMainGUIFailed"})
			if global.playersTable[player.name].GUI[_mfGUIName.MainGUI] ~= nil then global.playersTable[player.name].GUI[_mfGUIName.MainGUI] = nil end
			if player.gui.screen[_mfGUIName.MainGUI] ~= nil and player.gui.screen[_mfGUIName.MainGUI].valid == true then
				player.gui.screen[_mfGUIName.MainGUI].destroy()
			end
		end
		if remote.interfaces["dangOreus"] then
			remote.call("dangOreus","toggle",MF.fS)
			remote.call("dangOreus","toggle",MF.ccS)
		end
		if remote.interfaces["RSO"] then
			remote.call("RSO","ignoreSurface",MF.fS.name)
			remote.call("RSO","ignoreSurface",MF.ccS.name)
		end
	end
end

-- If player entered or living a vehicle --
function Event.playerDriveStatChange(event)
	-- Teleport the player out of reach from Mobile Factoty teleport box --
	local player = getPlayer(event.player_index)
	local entity = event.entity
	if entity == nil or entity.valid == false or player == nil or player.valid == false or string.find(entity.name, "MobileFactory") == nil then return end
	if player.vehicle ~= nil then return end
	if entity.surface.can_place_entity{name="character", position = {entity.position.x + 5, entity.position.y}} then
		player.teleport({entity.position.x + 5, entity.position.y}, entity.surface)
	elseif entity.surface.can_place_entity{name="character", position = {entity.position.x -5, entity.position.y}} then
		player.teleport({entity.position.x - 5, entity.position.y}, entity.surface)
	elseif entity.surface.can_place_entity{name="character", position = {entity.position.x, entity.position.y - 7}} then
		player.teleport({entity.position.x, entity.position.y - 7}, entity.surface)
	else
		player.teleport({entity.position.x, entity.position.y + 7}, entity.surface)
	end
end

-- On every Tick --
function Event.tick(event)
	-- Update all entities --
	updateEntities(event)
	-- Update all Erya Structures --
	-- Erya.updateEryaStructures(event)
	-- Update all GUI --
	GUI.updateAllGUIs()
	-- Updates Mobile Factory Lights --
	if event.tick%_eventTick49 == 0 then updateIndoorLights() end
	-- Update the Floor Is Lava --
	if event.tick%_eventTick150 == 0 and global.floorIsLavaActivated == true then updateFloorIsLava() end
end

-- Watch damages --
function Event.entityDamaged(event)
	if event.entity.force.name == "enemy" or event.entity.force.name == "neutral" then return end
	-- Check the Entity --
	if event.entity == nil or event.entity.valid == false then return end
	-- Test if this is in the Control Center --
	if string.match(event.entity.surface.name, _mfControlSurfaceName) then
		event.entity.health = event.entity.prototype.max_health
	end
end

-- When a technology is finished --
function Event.technologyFinished(event)
	local func = _MFResearches[event.research.name]
	if func == nil then return end
	for _, player in pairs(game.players) do
		if player.valid == true then -- should always be valid?
			local mfPlayer = getMFPlayer(player.name)
			if valid(mfPlayer) and valid(mfPlayer.MF) and event.research.force == player.force then
				_G[func](mfPlayer.MF)
			end
		end
	end
end

-- Called when a Player select an Entity -- Not used anymore ? --
function Event.selectedEntityChanged(event)
	-- -- Get the Player --
	-- local player = getPlayer(event.player_index)
	-- -- Check the Player and the Entity --
	-- if player == nil or player.selected == nil or player.selected.valid == false or player.selected.unit_number == nil then return end
	-- -- Check if the Tooltip GUI exist --
	-- if player.gui.screen.mfTooltipGUI == nil or player.gui.screen.mfTooltipGUI.valid == false then return end
	-- -- Check if the Tooltip GUI is not locked --
	-- if getPlayerVariable(player.name, "TTGUILocked") == true then return end
	-- -- Update the Tooltip GUI --
	-- GUI.updateTooltip(player, player.selected)
end

-- Called when a Setting is pasted --
function Event.settingsPasted(event)
	-- Check the Entities --
	if event.source == nil or event.source.valid == false then return end
	if event.destination == nil or event.destination.valid == false then return end

	-- Get the Objects --
	local o1 = nil
	local o2 = nil
	for k, obj in pairs(global.entsTable) do
		if valid(obj) == true and obj.ent ~= nil and obj.ent.valid == true then
			if obj.ent.unit_number == event.source.unit_number then o1 = obj end
			if obj.ent.unit_number == event.destination.unit_number then o2 = obj end
		end
	end

	-- Check the Objects --
	if o1 == nil then return end
	if o2 == nil then return end
	if o1.ent.name ~= o2.ent.name then return end

	-- Copy the Settings --
	if o2.copySettings ~= nil then
		o2:copySettings(o1)
	end
end

-- Called when a new Force is created --
function Event.forceCreated(event)
    local force = event.force

    if force.valid and settings.startup["MF-initial-research-complete"] and settings.startup["MF-initial-research-complete"].value == true then
    force.technologies["DimensionalOre"].researched = true
    end
end

-- Called when a Player changed his team --
function Event.playerChangedForce(event)
    local player = getPlayer(event.player_index)
    if not (player and player.valid) then return end

    local MFPlayer = getMFPlayer(player.name)
    if not (MFPlayer and MFPlayer:valid()) then return end

    local MF = getMF(player.name)
    if not (MF and MF:valid()) then return end

    if MF.ent and MF.ent.valid then MF.ent.force = player.force end
    if MF.fS and MF.fS.valid then
      local oldForceEntities = MF.fS.find_entities_filtered{force = event.force}
      local newForce = player.force
      for _, ent in pairs(oldForceEntities) do
        ent.force = newForce
      end
    end

    if MF.ccS and MF.ccS.valid then
      local oldForceEntities = MF.ccS.find_entities_filtered{force = event.force}
      local newForce = player.force
      for _, ent in pairs(oldForceEntities) do
        ent.force = newForce
      end
    end
end

-- Called when a Player settup a Blueprint --
function Event.playerSetupBlueprint(event)
	local player = game.players[event.player_index]
	local mapping = event.mapping.get()
	local bp = player.blueprint_to_setup
	if bp.valid_for_read == false then
		local cursor = player.cursor_stack
		if cursor and cursor.valid_for_read and cursor.name == "blueprint" then
			bp = cursor
			--return
		end
	end
	if bp == nil or bp.valid_for_read == false then return end

	for index, ent in pairs(mapping) do
		if global.objTable[ent.name] ~= nil then
			local saveTable = global.objTable[ent.name].tableName
			if ent.valid == true and saveTable ~= nil then
				if global[saveTable] == nil then
					-- Create Table If Nothing Was Ever Placed --
					global[saveTable] = {}
				end
				saveTable = global[saveTable]
				local tags = entityToBlueprintTags(ent, saveTable)
				if tags ~= nil then
					for tag, value in pairs(tags) do
						bp.set_blueprint_entity_tag(index, tag, value)
					end
				end
			end
		end
	end
end

-- Called when a Entity is rotated --
function Event.entityRotated(event)

	-- Get the Values --
	local player = getPlayer(event.player_index)
	local ent = event.entity

	-- Check the Entity --
	if ent == nil or ent.valid == false then return end

	-- Check if this is a Deployed Entity --
	if string.match(ent.name, "DimensionalBelt") or string.match(ent.name, "DimensionalPipe") then

		-- Find the Entity --
		local dpMF = nil
		local slotID = nil
		local slot = nil
		local dpEnts = nil
		for _, mf in pairs(global.MFTable) do
			for ID, aDPEnts in pairs(mf.deployedEnts) do
				if aDPEnts.inEntity == ent or aDPEnts.outEntity == ent then
					dpMF = mf
					dpEnts = aDPEnts
					slotID = ID
					slot = mf.slots[slotID]
				end
			end
		end

		-- Check if the Entity was Found --
		if dpMF ~= nil and dpEnts ~= nil and dpEnts.outEntity ~= nil and dpEnts.inEntity ~= nil and dpEnts.outEntity.valid == true and dpEnts.inEntity.valid == true then

			-- If this is a Belt --
			if string.match(ent.name, "DimensionalBelt") then
				if dpEnts.way == "input" then
					dpEnts.way = "output"
					dpEnts.outEntity.disconnect_linked_belts()
					dpEnts.inEntity.linked_belt_type = "input"
					dpEnts.outEntity.linked_belt_type = "output"
					dpEnts.inEntity.connect_linked_belts(dpEnts.outEntity)
					player.create_local_flying_text{text={"gui-description.SendOutside"}, position=ent.position}
					if slot ~= nil then slot.way = "output" end
				elseif dpEnts.way == "output" then
					dpEnts.way = "input"
					dpEnts.outEntity.disconnect_linked_belts()
					dpEnts.inEntity.linked_belt_type = "output"
					dpEnts.outEntity.linked_belt_type = "input"
					player.create_local_flying_text{text={"gui-description.SendInside"}, position=ent.position}
					dpEnts.inEntity.connect_linked_belts(dpEnts.outEntity)
					if slot ~= nil then slot.way = "input" end
				end
				ent.direction = (event.previous_direction + 4) % 8
				return
			end

			-- If this is a Pipe --
			if string.match(ent.name, "DimensionalPipe") then
				if dpEnts.way == "input" then
					dpEnts.way = "output"
					player.create_local_flying_text{text={"gui-description.SendOutside"}, position=ent.position}
					if slot ~= nil then slot.way = "output" end
				elseif dpEnts.way == "output" then
					dpEnts.way = "input"
					player.create_local_flying_text{text={"gui-description.SendInside"}, position=ent.position}
					if slot ~= nil then slot.way = "input" end
				end
				ent.direction = event.previous_direction
				return
			end

		end
	end
end

-- Called when a Shortcut is pressed --
function Event.onShortcut(event)
	local player = getPlayer(event.player_index)
	local MFPlayer = getMFPlayer(event.player_index)
	-- Tooltip GUI Key --
	if event.input_name == "OpenTTGUI" and player.selected ~= nil and player.selected.valid == true and _mfShortcutGUI[player.selected.name] == true then
		if player.can_reach_entity(player.selected) then
			-- Open the GUI --
			GUI.openTTGui(MFPlayer, player, player.selected)
			return
		else
			player.create_local_flying_text{text={"gui-description.CannnotReach"}, position=player.selected.position}
		end
	end
	-- Close GUIs --
	if event.input_name == "CloseGUI" then
		-- Close Recipe GUI --
		if MFPlayer.GUI[_mfGUIName.RecipeGUI] ~= nil then
			if MFPlayer.GUI[_mfGUIName.RecipeGUI].gui ~= nil then MFPlayer.GUI[_mfGUIName.RecipeGUI].gui.destroy() end
			MFPlayer.GUI[_mfGUIName.RecipeGUI] = nil
		end
		-- Close Recipe Info GUI --
		if MFPlayer.GUI[_mfGUIName.RecipeInfoGUI] ~= nil then
			if MFPlayer.GUI[_mfGUIName.RecipeInfoGUI].gui ~= nil then MFPlayer.GUI[_mfGUIName.RecipeInfoGUI].gui.destroy() end
			MFPlayer.GUI[_mfGUIName.RecipeInfoGUI] = nil
		end
		-- Close Slot GUI --
		if MFPlayer.GUI[_mfGUIName.SlotGUI] ~= nil then
			if MFPlayer.GUI[_mfGUIName.SlotGUI].gui ~= nil then MFPlayer.GUI[_mfGUIName.SlotGUI].gui.destroy() end
			MFPlayer.GUI[_mfGUIName.SlotGUI] = nil
		end
		return
	end
end

-- Called when the MFCleanGUI is sent --
function Event.clearGUI(event)

	-- Get the Player --
	local player = getPlayer(event.player_index)

	-- Clean all Mobile Factory GUI --
	for _, gui in pairs(player.gui.screen.children) do
		if gui ~= nil and gui.valid == true and gui.get_mod() == "Mobile_Factory" and gui.name ~= "MFBaseErrorWindows" then
			gui.destroy()
		end
	end

	-- Clear the GUITable --
	getMFPlayer(event.player_index).GUI = nil

	-- Clear the Opened GUI --
	player.opened = nil

	-- Recreate the Main GUI --
	GUI.createMFMainGUI(player)

end