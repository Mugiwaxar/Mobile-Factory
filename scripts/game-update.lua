require("utils/players-teleportation.lua")
require("utils/surface")
require("utils/functions.lua")
require("scripts/update-system.lua")
require("utils/place-and-remove.lua")

-- One each game tick --
function onTick(event)
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

-- Update all entities --
function updateEntities(event)
	-- Update System --
	UpSys.update(event)
end

-- When a technology is finished --
function technologyFinished(event)
	local func = _MFResearches[event.research.name]
	if func == nil then return end
	for index, player in pairs(game.players) do
		if player.valid == true then -- should always be valid?
			local mfPlayer = getMFPlayer(player.name)
			if valid(mfPlayer) and valid(mfPlayer.MF) and event.research.force == player.force then
				_G[func](mfPlayer.MF)
			end
		end
	end
end

-- Check all Technologies of a Player Mobile Factory --
function checkTechnologies(MF)
	local force = getForce(MF.player)
	for research, func in pairs(_MFResearches) do
		if technologyUnlocked(research, force) == true and MF.varTable.tech[research] ~= true then _G[func](MF) end
	end
end

function selectedEntityChanged(event)
	-- Get the Player --
	local player = getPlayer(event.player_index)
	-- Check the Player and the Entity --
	if player == nil or player.selected == nil or player.selected.valid == false or player.selected.unit_number == nil then return end
	-- Check if the Tooltip GUI exist --
	if player.gui.screen.mfTooltipGUI == nil or player.gui.screen.mfTooltipGUI.valid == false then return end
	-- Check if the Tooltip GUI is not locked --
	if getPlayerVariable(player.name, "TTGUILocked") == true then return end
	-- Update the Tooltip GUI --
	GUI.updateTooltip(player, player.selected)
end

-- If player entered or living a vehicle --
function playerDriveStatChange(event)
	-- Teleport the player out of reach from Mobile Factoty teleport box --
	local player = getPlayer(event.player_index)
	local entity = event.entity
	if entity == nil or entity.valid == false or player == nil or player.valid == false or string.find(entity.name, "MobileFactory") == nil then return end
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

-- When a player join the game --
function initPlayer(event)
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
		Util.addMobileFactory(player)
		setPlayerVariable(player.name, "GotInventory", true)
		GUI.createMFMainGUI(player)
		
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

-- Watch damages --
function onEntityDamaged(event)
	if event.entity.force.name == "enemy" or event.entity.force.name == "neutral" then return end
	-- Check the Entity --
	if event.entity == nil or event.entity.valid == false then return end
	-- Test if this is in the Control Center --
	if string.match(event.entity.surface.name, _mfControlSurfaceName) then
		event.entity.health = event.entity.prototype.max_health
	end
end

-- Called after an Entity die --
function onGhostPlacedByDie(event)
	-- Raise event if a Blueprint is placed --
	if event.ghost ~= nil and event.ghost.valid == true then
		somethingWasPlaced({entity=event.ghost})
	end
end

-- Called when a Setting is pasted --
function settingsPasted(event)
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

-- Called when a GUI is Opened --
function guiOpened(event)
	-- Check the Entity --
	if event.entity == nil or event.entity.valid == false then return end
	local player = getPlayer(event.player_index)
	local MFPlayer = getMFPlayer(event.player_index)
	GUI.openTTGui(MFPlayer, player, player.selected)
end

-- Called when a Shortcut is pressed --
function onShortcut(event)
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

-- Damage all Players that aren't on a safe position --
function updateFloorIsLava()
	-- Take all Players --
	for k, player in pairs(game.players) do
		-- Check the Player --
		if player.character == nil then return end
		-- Check the Surface --
		if string.match(player.surface.name, _mfSurfaceName) or string.match(player.surface.name, _mfControlSurfaceName) or string.match(player.surface.name, "Factory") then return end
		-- Check the Tile --
		local tile = player.surface.get_tile(player.position.x, player.position.y)
		if tile ~= nil and tile.valid == true and tile.name ~= "DimensionalTile" then
			player.character.damage(50, "neutral", "fire")
		end
	end
end

-- Update all Mobile Factory Internal Lights --
function updateIndoorLights()
	for _, MF in pairs(global.MFTable) do
		if MF.internalEnergyObj:energy() > 0 then
			MF.fS.daytime = 0
			MF.ccS.daytime = 0
		else
			MF.fS.daytime = 0.5
			MF.ccS.daytime = 0.5
		end
	end
end

-- Called when a Entity is rotated --
function entityRotated(event)

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