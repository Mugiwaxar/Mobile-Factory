-- Called when something is placed --
function somethingWasPlaced(event)

	-- If Tiles was placed --
	if event.tile ~= nil or event.created_entity ~= nil and event.created_entity.name == "tile-ghost" then
		tilesWasPlaced(event)
		return
	end

	-- Get Values --
	local entity = event.created_entity or event.entity or event.destination
	if entity == nil or entity.last_user == nil then return end
	local MFPlayer = getMFPlayer(event.player_index or entity.last_user.index)
	local MF = getMF(event.player_index or entity.last_user.index)

	-- Check the Values --
	if entity == nil or MFPlayer == nil or MF == nil then return end

	-- If a Mobile Factory was placed --
	if string.match(entity.name, "MobileFactory") then
		placedMobileFactory(event, entity, MFPlayer, MF)
		return
	end

	-- Check if the Entity is inside the objTable --
	local type = entity.type
	local entName = type == "entity-ghost" and entity.ghost_name or entity.name
	local locName = type == "entity-ghost" and entity.ghost_localised_name or entity.localised_name
	local objInfo = global.objTable[entName]
	local destroyEntity = false

	-- Check if the Entity is allowed to be placed --
	if objInfo ~= nil then
		-- Prevent to place Outside --
		if objInfo.noOutside == true and string.match(entity.surface.name, _mfSurfaceName) == nil then
			MFPlayer.ent.print({"", locName, " ", {"gui-description.PlaceableInsideTheFactory"}})
			destroyEntity = true
		-- Prevent to place Inside --
		elseif objInfo.noInside == true and string.match(entity.surface.name, _mfSurfaceName) then
			MFPlayer.ent.print({"", locName, " ", {"gui-description.PlaceableOutsideTheFactory"}})
			destroyEntity = true
		-- Prevent to place inside the Control Center --
		elseif objInfo.canInCC ~= true and objInfo.canInCCAnywhere ~= true and string.match(entity.surface.name, _mfControlSurfaceName) then
			MFPlayer.ent.print({"", locName, " ", {"gui-description.CCNotPlaceable"}})
			destroyEntity = true
		-- Allow to place inside the Constructible Area --
		elseif objInfo.canInCC == true and objInfo.canInCCAnywhere ~= true and checkCCTile(entity) == false then
			MFPlayer.ent.print({"", locName, " ", {"gui-description.PlaceableInsideTheCCCArea"}})
			destroyEntity = true
		end
	else
		-- Prevent to place inside the Control Center --
		if string.match(entity.surface.name, _mfControlSurfaceName) then
			MFPlayer.ent.print({"", locName, " ", {"gui-description.CCNotPlaceable"}})
			destroyEntity = true
		end
	end

	-- Save the Ghost inside the Construction Table and Stop --
	if type == "entity-ghost" then
		if MF.ent ~= nil and MF.ent.valid == true and MF.ent.surface == entity.surface then
			if table_size(global.constructionTable) >= MF.varTable.jets.cjTableSize then
				MFPlayer.ent.print({"info.cjTooManyGhosts", MF.varTable.jets.cjTableSize})
			else
				table.insert(global.constructionTable,{ent=entity, item=entity.ghost_prototype.items_to_place_this[1].name, name=entity.ghost_name, position=entity.position, direction=entity.direction or 1, mission="Construct"})
			end
		end
		return
	end

	-- Save the Internal Energy Cube --
	if entity.name == "InternalEnergyCube" then
		if MF.internalEnergyObj.ent ~= nil and MF.internalEnergyObj.ent.valid == true then
			if event.stack ~= nil and event.stack.valid_for_read == true then
				MFPlayer.ent.print({"", {"gui-description.MaxPlaced"}, " ", {"item-name." .. event.stack.name }})
			end
			destroyEntity = true
		else
			MF.internalEnergyObj:setEnt(entity)
			if event.stack ~= nil and event.stack.valid_for_read == true then
				local tags = event.stack.get_tag("Infos")
				if tags ~= nil then
					MF.internalEnergyObj:tagToSettings(tags)
				end
			end
			return
		end
	end

	-- Save the Internal Quatron Cube --
	if entity.name == "InternalQuatronCube" then
		if MF.internalQuatronObj.ent ~= nil and MF.internalQuatronObj.ent.valid == true then
			if event.stack ~= nil and event.stack.valid_for_read == true then
				MFPlayer.ent.print({"", {"gui-description.MaxPlaced"}, " ", {"item-name." .. event.stack.name }})
			end
			destroyEntity = true
		else
			MF.internalQuatronObj:setEnt(entity)
			if event.stack ~= nil and event.stack.valid_for_read == true then
				local tags = event.stack.get_tag("Infos")
				if tags ~= nil then
					MF.internalQuatronObj:tagToSettings(tags)
				end
			end
			return
		end
	end

	-- Return the Item to the Player if the Entity was destroyed and stop --
	if destroyEntity == true then
		entity.destroy()
		if event.stack ~= nil and event.stack.valid_for_read == true then
			MFPlayer.ent.get_main_inventory().insert(event.stack)
		end
		return
	end

	-- If a SyncArea Entity was placed --
	if _mfSyncAreaAllowedTypes[entity.type] == true then
		placedEntityInSyncArea(MF, entity)
	end

	-- If a Erya Structure was placed --
	if _mfEryaFreezeStructures[entity.name] == true then
		placedEryaStructure(event)
	end

	-- Create the Object --
	if objInfo ~= nil and objInfo.noPlaced ~= true and objInfo.tag ~= nil then
		local obj = _G[objInfo.tag]:new(entity)
		if objInfo.tableName ~= nil then
			global[objInfo.tableName][entity.unit_number] = obj
		end
		-- Check if there are Tags --
		if event.stack ~= nil and event.stack.valid_for_read == true and event.stack.type == "item-with-tags" then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				obj:tagToSettings(tags)
			end
		end
	end

end

-- When something is removed or destroyed --
function somethingWasRemoved(event)

	-- Get and Check the Entity --
	local removedEnt = event.entity
	if removedEnt == nil or removedEnt.valid == false then return end

	-- Return Sync Area Items from Chests --
	if removedEnt == "container" then
		returnSyncChestsItems(event)
	end

	-- Remove the Erya Structure --
	if _mfEryaFreezeStructures[removedEnt.name] == true then
		removedEryaStructure(event)
	end

	-- Get and Check the Values --
	local obj = global.entsTable[removedEnt.unit_number]
	if obj == nil then return end
	local MF = obj.MF
	if MF == nil then return end

	-- If the Mobile Factory was removed --
	if string.match(removedEnt.name, "MobileFactory") then
		MF:remove()
		return
	end

	-- If the Internal Energy Cube was removed --
	if string.match(removedEnt.name, "InternalEnergyCube") then
		if event.buffer ~= nil and event.buffer[1] ~= nil then
			MF.internalEnergyObj:settingsToTags(event.buffer[1])
		end
		MF.internalEnergyObj:remove()
		return
	end

	-- If the Internal Quatron Cube was removed --
	if string.match(removedEnt.name, "InternalQuatronCube") then
		if event.buffer ~= nil and event.buffer[1] ~= nil then
			MF.internalQuatronObj:settingsToTags(event.buffer[1])
		end
		MF.internalQuatronObj:remove()
		return
	end

	-- Save the Settings --
	if obj.settingsToTags ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
		obj:settingsToTags(event.buffer[1])
	end

	-- Remove the Object --
	obj:remove()
	
	-- Remove the Object from its Table --
	local objInfo = global.objTable[removedEnt.name]
	if objInfo == nil then return end
	if objInfo.tableName == nil then return end
	global[objInfo.tableName][removedEnt.unit_number] = nil

end

-- Called when a Structure is marked for deconstruction --
function markedForDeconstruction(event)
	if event.entity == nil or event.entity.valid == false or event.player_index == nil then return end
	local player = getPlayer(event.player_index)
	if player == nil then return end
	local MF = getMF(player.name)
	if MF == nil then return end
	if MF.ent == nil or MF.ent.valid == false or event.entity.surface.name ~= MF.ent.surface.name then return end
	table.insert(global.constructionTable,{ent=event.entity, name=event.entity.name, position=event.entity.position, direction=event.entity.direction or 1, mission="Deconstruct"})
end

-- Called when Tiles are placed --
function tilesWasPlaced(event)
	-- Get the Values --
	local MFPlayer = getMFPlayer(event.player_index)
	local MF = nil
	if MFPlayer ~= nil then
		MF = MFPlayer.MF
	end
	local surface = game.get_surface(event.surface_index or event.created_entity.surface.index)
	-- Prevent to place Tiles inside the Control Center --
	if event.tiles ~= nil and string.match(surface.name, _mfControlSurfaceName) then
		-- Remove the Tiles --
		for k, tile in pairs(event.tiles) do
			createTilesAtPosition(tile.position, 1, surface, tile.old_tile.name, true)
		end
		-- Try to send a message to the Player --
		if MFPlayer ~= nil and event.stack ~= nil and event.stack.valid_for_read == true then
			MFPlayer.ent.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.CCNotPlaceable"}})
		end
		return
	end
	-- Prevent to place a Ghost --
	if event.created_entity ~= nil and string.match(surface.name, _mfControlSurfaceName) then
		-- Destroy the Ghost --
		event.created_entity.destroy()
		-- Try to send a message to the Player --
		if MFPlayer ~= nil and event.stack ~= nil and event.stack.valid_for_read == true then
			MFPlayer.ent.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.CCNotPlaceable"}})
		end
		return
	end
	-- Save the Ghost inside the Construction Table and Stop --
	if event.created_entity ~= nil and MF ~= nil then
		if MF.ent ~= nil and MF.ent.valid == true and MF.ent.surface == event.created_entity.surface then
			if table_size(global.constructionTable) >= MF.varTable.jets.cjTableSize then
				MFPlayer.ent.print({"info.cjTooManyGhosts", MF.varTable.jets.cjTableSize})
			else
				table.insert(global.constructionTable,{ent=event.created_entity, item=event.created_entity.ghost_prototype.items_to_place_this[1].name, name=event.created_entity.ghost_name, position=event.created_entity.position, direction=event.created_entity.direction or 1, mission="Construct"})
			end
		return
		end
	end
end

-- Called when a Mobile Factory is placed --
function placedMobileFactory(event, entity, MFPlayer, MF)
	-- If the Mobile Factory already exist for this Player --
	if MF ~= nil and MF.ent ~= nil and MF.ent.valid == true then
		MFPlayer.ent.print({"", {"gui-description.MaxPlaced"}, " ", {"item-name." .. event.stack.name }})
		entity.destroy()
	-- If the Mobile Factory is placed inside the Mobile Factory --
	elseif string.match(entity.surface.name, _mfSurfaceName) or string.match(entity.surface.name, _mfControlSurfaceName) then
		MFPlayer.ent.print({"", {"gui-description.MFPlacedInsideFactory"}})
		entity.destroy()
	-- If the Mobile Factory is placed inside a Factorissimo Building --
	elseif string.match(entity.surface.name, "Factory") then
		MFPlayer.ent.print({"", {"gui-description.MFPlacedInsideFactorissimo"}})
		entity.destroy()
	-- If everything is OK --
	else
		newMobileFactory(entity)
	end
	-- Get the Item back to the Player if the Entity was destroyed --
	if entity.valid == false then
		MFPlayer.ent.get_main_inventory().insert(event.stack)
	end
end

-- Called when an Entity is placed inside the SyncArea --
function placedEntityInSyncArea(MF, entity)
	-- Check the Mobile Factory --
	if MF.ent == nil or MF.ent.valid == false or MF.syncAreaEnabled ~= true or  MF.ent.speed ~= 0 then return end
	-- Outside to Inside --
	if entity.surface == MF.ent.surface and Util.distance(entity.position, MF.ent.position) < _mfSyncAreaRadius
			and not MF.fS.entity_prototype_collides(entity.name, {_mfSyncAreaPosition.x + (entity.position.x - math.floor(MF.ent.position.x)), _mfSyncAreaPosition.y + (entity.position.y - math.floor(MF.ent.position.y))}, false)
		then
		MF:cloneEntity(entity, "in")
	end
	-- Inside to Outside --
	if entity.surface == MF.fS and Util.distance(entity.position, _mfSyncAreaPosition) < _mfSyncAreaRadius
			and not MF.ent.surface.entity_prototype_collides(entity.name, {math.floor(MF.ent.position.x) + (entity.position.x - _mfSyncAreaPosition.x), math.floor(MF.ent.position.y) + (entity.position.y - _mfSyncAreaPosition.y)}, false)
		then
		MF:cloneEntity(entity, "out")
	end
end

-- Called to know if the Entity is above a Constructible Area --
function checkCCTile(entity)
	local tile = entity.surface.find_tiles_filtered{position=entity.position, radius=1, limit=1}
	if tile[1] ~= nil and tile[1].valid == true and tile[1].name == "BuildTile" then return true end
	return false
end

-- Return all Items of all Chest to its original one if the SyncArea is stoped --
function returnSyncChestsItems(event)
	local removedEnt = event.entity
	local MF = nil
	for _, MFObj in pairs(global.MFTable) do
		if MFObj.ent ~= nil and MFObj.ent.valid and MFObj.syncAreaEnabled == true and MFObj.ent.speed == 0 
		and ((removedEnt.surface == MFObj.ent.surface and Util.distance(removedEnt.position, MFObj.ent.position) < _mfSyncAreaRadius)
				or (removedEnt.surface == MFObj.fS and Util.distance(removedEnt.position, _mfSyncAreaPosition) < _mfSyncAreaRadius))
			then
			MF = MFObj
			break
		end
	end
	if MF == nil then return end

	local taker = nil
	local inserted = 0

	if event.robot then taker = event.robot end
	if event.player_index then taker = getPlayer(event.player_index) end
	if not taker then return end -- should not be possible

	local invOriginal = nil
	local invCloned = nil

	for i, ents in pairs(MF.clonedResourcesTable) do
		if removedEnt == ents.original or removedEnt == ents.cloned then
			local items = {}
			invOriginal = ents.original.get_inventory(defines.inventory.chest)
			for itemName, itemCount in pairs(invOriginal.get_contents()) do
				if not items[itemName] then items[itemName] = 0 end
				items[itemName] = items[itemName] + itemCount
			end
			invOriginal.clear()

			invCloned = ents.cloned.get_inventory(defines.inventory.chest)
			for itemName, itemCount in pairs(invCloned.get_contents()) do
				if not items[itemName] then items[itemName] = 0 end
				items[itemName] = items[itemName] + itemCount
			end
			invCloned.clear()

			for itemName, itemCount in pairs(items) do
				inserted = taker.insert({name = itemName, count = itemCount})
				if inserted ~= itemCount then taker.surface.spill_item_stack(taker.position, {name = itemName, count = itemCount - inserted}, true, nil, false) end
			end
		end
	end
end

-- An Erya Structure is placed --
function placedEryaStructure(event)
	if global.eryaTable == nil then global.eryaTable  = {} end
	global.eryaTable[event.created_entity.unit_number] = ES:new(event.created_entity)
end

-- An Erya Structure is removed --
function removedEryaStructure(event)
	if global.eryaTable == nil then global.eryaTable = {} return end
	if global.eryaTable[event.entity.unit_number] ~= nil then global.eryaTable[event.entity.unit_number]:remove() end
	global.eryaTable[event.entity.unit_number] = nil
end