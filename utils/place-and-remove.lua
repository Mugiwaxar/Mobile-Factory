-- Called when something is placed --
function Event.somethingWasPlaced(event)

	-- If Tiles was placed --
	if event.tile ~= nil or event.created_entity ~= nil and event.created_entity.name == "tile-ghost" then
		tilesWasPlaced(event)
		return
	end

	-- Get Values --
	local entity = event.created_entity or event.entity or event.destination
	if entity == nil or entity.last_user == nil then return end
	local MFPlayer = getMFPlayer(event.player_index or entity.last_user.index)
	local playerMF = getCurrentMF(event.player_index or entity.last_user.index)

	-- Find Mobile Factory Floor and MFPlayerName from Surface --
	local entitySurface = entity.surface
	local entitySurfaceName = entitySurface.name
	local MFFloor, surfacePlayer = getMFFloor(entitySurfaceName)

	-- Check the Values --
	if entity == nil or MFPlayer == nil or playerMF == nil then return end

	-- Adjust Entity to Expected Place --
	event.created_entity = event.created_entity or event.entity or event.destination

	-- If a Mobile Factory was placed --
	if string.match(entity.name, "MobileFactory") then
		placedMobileFactory(event, entity, MFPlayer, playerMF)
		return
	end

	-- If a Deploy Entity is placed --
	if entity.name == "MFDeploy" then
		placedDeploy(entity, MFPlayer, playerMF)
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
		if objInfo.noOutside == true and MFFloor == nil then
			MFPlayer.ent.print({"", locName, " ", {"gui-description.PlaceableInsideTheFactory"}})
			destroyEntity = true
		-- Prevent to place Inside --
		elseif objInfo.noInside == true and MFFloor == _mfSurfaceName then
			MFPlayer.ent.print({"", locName, " ", {"gui-description.PlaceableOutsideTheFactory"}})
			destroyEntity = true
		-- Prevent to place inside the Control Center --
		elseif objInfo.canInCC ~= true and objInfo.canInCCAnywhere ~= true and MFFloor == _mfControlSurfaceName then
			MFPlayer.ent.print({"", locName, " ", {"gui-description.CCNotPlaceable"}})
			destroyEntity = true
		-- Allow to place inside the Constructible Area --
		elseif objInfo.canInCC == true and objInfo.canInCCAnywhere ~= true and checkCCTile(entity) == false then
			MFPlayer.ent.print({"", locName, " ", {"gui-description.PlaceableInsideTheCCCArea"}})
			destroyEntity = true
		end
	else
		-- Prevent to place inside the Control Center --
		if MFFloor == _mfControlSurfaceName then
			MFPlayer.ent.print({"", locName, " ", {"gui-description.CCNotPlaceable"}})
			destroyEntity = true
		end
	end

	-- Save the Internal Energy Cube --
	if type ~= "entity-ghost" and entity.name == "InternalEnergyCube" then
		local surfaceMF = getMF(surfacePlayer)
		local MF = surfaceMF or playerMF
		if MF.internalEnergyObj.ent ~= nil and MF.internalEnergyObj.ent.valid == true then
			if event.stack ~= nil and event.stack.valid_for_read == true then
				MFPlayer.ent.print({"", {"gui-description.MaxPlaced"}, " ", {"item-name." .. event.stack.name }})
			end
			destroyEntity = true
		elseif destroyEntity == false then
			MF.internalEnergyObj:setEnt(entity)
			if event.stack ~= nil and event.stack.valid_for_read == true then
				local tags = event.stack.get_tag("Infos")
				if tags ~= nil then
					MF.internalEnergyObj:itemTagsToContent(tags)
				end
			end
			return
		end
	end

	-- Save the Internal Quatron Cube --
	if type ~= "entity-ghost" and entity.name == "InternalQuatronCube" then
		local surfaceMF = getMF(surfacePlayer)
		local MF = surfaceMF or playerMF

		if MF.internalQuatronObj.ent ~= nil and MF.internalQuatronObj.ent.valid == true then
			if event.stack ~= nil and event.stack.valid_for_read == true then
				MFPlayer.ent.print({"", {"gui-description.MaxPlaced"}, " ", {"item-name." .. event.stack.name }})
			end
			destroyEntity = true
		elseif destroyEntity == false then
			MF.internalQuatronObj:setEnt(entity)
			if event.stack ~= nil and event.stack.valid_for_read == true then
				local tags = event.stack.get_tag("Infos")
				if tags ~= nil then
					MF.internalQuatronObj:itemTagsToContent(tags)
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

	-- Stop if this is a Ghost --
	if type == "entity-ghost" then return end

	-- If a SyncArea Entity was placed --
	-- if _mfSyncAreaAllowedTypes[entity.type] == true and event.destination == nil then
	-- 	local nearestMF = getMF(surfacePlayer) or findNearestMF(entity.surface, entity.position)
	-- 	if nearestMF ~= nil then
	-- 		placedEntityInSyncArea(nearestMF, entity)
	-- 	end
	-- end

	-- -- If a Erya Structure was placed --
	-- if _mfEryaFreezeStructures[entity.name] == true then
	-- 	placedEryaStructure(event)
	-- end

	-- Create the Object --
	if objInfo ~= nil and objInfo.noPlaced ~= true and objInfo.tag ~= nil then
		local obj = _G[objInfo.tag]:new(entity)
		if objInfo.tableName ~= nil then
			global[objInfo.tableName][entity.unit_number] = obj
		end
		-- Check if there are Blueprint Tags --
		if event.tags and obj.blueprintTagsToSettings then
			obj:blueprintTagsToSettings(event.tags)
		end
		-- Check if there are Item Tags --
		if event.stack ~= nil and event.stack.valid_for_read == true and event.stack.type == "item-with-tags" then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				obj:itemTagsToContent(tags)
			end
		end
		-- Validate properties taken from Blueprint or Item Tags
		if obj.validate then
			obj:validate()
		end
	end
	
end

-- When something is cloned --
function Event.somethingWasCloned(event)
	-- If a Mobile Factory was cloned --
	if event.source  ~= nil and event.source.valid == true and event.destination ~= nil and event.destination.valid == true and string.match(event.source.name, "MobileFactory") then
		-- Find the Mobile Factory --
		for _, mf in pairs(global.MFTable) do
			if mf.ent ~= nil and mf.ent.valid == true and mf.ent == event.source then
				-- Teleport the Mobile Factory --
				mf.ent.teleport(event.destination.position, event.destination.surface)
				-- Destory the Clone --
				event.destination.destroy()
				-- Show the Message --
				game.print({"gui-description.DPGUIClone"})
				return
			end
		end
	end
	-- Else call the normal Event --
	Event.somethingWasPlaced(event)
end

-- When something is removed or destroyed --
function Event.somethingWasRemoved(event)
	-- Get and Check the Entity --
	local removedEnt = event.entity
	if removedEnt == nil or removedEnt.valid == false then return end

	-- Unclone SyncArea --
	-- if _mfSyncAreaAllowedTypes[removedEnt.type] then
	-- 	removedSyncEntity(event)
	-- end

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
			MF.internalEnergyObj:contentToItemTags(event.buffer[1])
		end
		MF.internalEnergyObj:remove()
		return
	end

	-- If the Internal Quatron Cube was removed --
	if string.match(removedEnt.name, "InternalQuatronCube") then
		if event.buffer ~= nil and event.buffer[1] ~= nil then
			MF.internalQuatronObj:contentToItemTags(event.buffer[1])
		end
		MF.internalQuatronObj:remove()
		return
	end

	-- If a Resoure Catcher was removed --
	if removedEnt.name == "ResourceCatcher" and obj.filled == true then
		if event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer.clear()
			event.buffer.insert("FilledResourceCatcher")
			obj:contentToItemTags(event.buffer[1])
		end
		obj:remove()
		return
	end

	-- Save the Settings --
	if obj.contentToItemTags ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
		obj:contentToItemTags(event.buffer[1])
	end

	-- Remove the Object --
	obj:remove()
	
	-- Remove the Object from its Table --
	local objInfo = global.objTable[removedEnt.name]
	if objInfo == nil then return end
	if objInfo.tableName == nil then return end
	global[objInfo.tableName][removedEnt.unit_number] = nil

end

-- Called when Tiles are placed --
function tilesWasPlaced(event)
	-- Get the Values --
	local MFPlayer = getMFPlayer(event.player_index)
	local surface = game.get_surface(event.surface_index or event.created_entity.surface.index)
	local MFFloor = getMFFloor(surface.name)

	-- Prevent to place Tiles inside the Control Center --
	if event.tiles ~= nil and MFFloor == _mfControlSurfaceName then
		-- Remove the Tiles --
		for k, tile in pairs(event.tiles) do
			Util.createTilesAtPosition(tile.position, 1, surface, tile.old_tile.name, true)
		end
		-- Try to send a message to the Player --
		if MFPlayer ~= nil and event.stack ~= nil and event.stack.valid_for_read == true then
			MFPlayer.ent.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.CCNotPlaceable"}})
		end
		return
	end
	-- Prevent to place a Ghost --
	if event.created_entity ~= nil and MFFloor == _mfControlSurfaceName then
		-- Destroy the Ghost --
		event.created_entity.destroy()
		-- Try to send a message to the Player --
		if MFPlayer ~= nil and event.stack ~= nil and event.stack.valid_for_read == true then
			MFPlayer.ent.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.CCNotPlaceable"}})
		end
		return
	end
end

-- Called when a Mobile Factory is placed --
function placedMobileFactory(event, entity, MFPlayer, MF)
	local MFFloor = getMFFloor(entity.surface.name)
	-- If the Mobile Factory already exist for this Player --
	if MF ~= nil and MF.ent ~= nil and MF.ent.valid == true then
		if event.stack ~= nil and event.stack.valid_for_read == true then
			MFPlayer.ent.print({"", {"gui-description.MaxPlaced"}, " ", {"item-name." .. event.stack.name }})
		end
		entity.destroy()
	-- If the Mobile Factory is placed inside the Mobile Factory --
	elseif MFFloor then
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
	if entity.valid == false and event.stack ~= nil and event.stack.valid_for_read == true then
		MFPlayer.ent.get_main_inventory().insert(event.stack)
	end
end

-- Called when a Deploy Entity is placed --
function placedDeploy(ent, MFPlayer, mf)
	-- Check if the Mobile Factory is here --
	local ents = ent.surface.find_entities_filtered{type="car", position=ent.position, radius=7}
	if ents[1] ~= nil and ents[1].valid == true and ents[1].last_user ~= nil and string.match(ents[1].name, "MobileFactory") and getMF(ents[1].last_user.name) ~= nil and getMF(ents[1].last_user.name) == mf then
		-- Check if the Mobile Factory is not Moving --
		if ents[1].speed ~= 0 then
			MFPlayer.ent.create_local_flying_text{text={"gui-description.DPGUIMFMoving"}, position=ent.position}
			MFPlayer.ent.cursor_stack.set_stack({name="MFDeploy", count=1})
		else
			-- Move the Mobile Factory --
			mf.ent.teleport({ent.position.x, ent.position.y + 0.5})
			mf.ent.orientation = 0
			-- Check if the Mobile Factory have to be Repacked first --
			if mf.deployed == true then
				mf:repack()
			end
			-- Deploy the Mobile Factory --
			mf:deploy()
		end
	else
		-- None or wrong Mobile Factory --
		MFPlayer.ent.create_local_flying_text{text={"gui-description.DPGUINoMF", MF.name}, position=ent.position}
		MFPlayer.ent.cursor_stack.set_stack({name="MFDeploy", count=1})
	end
	-- Destroy the Entity --
	ent.destroy()
end

-- Called when an Entity is placed inside the SyncArea --
-- function placedEntityInSyncArea(MF, entity)
-- 	-- Check the Mobile Factory --
-- 	if MF.ent == nil or MF.ent.valid == false or MF.syncAreaEnabled ~= true or MF.ent.speed ~= 0 then return end
-- 	-- Outside to Inside --
-- 	if entity.surface == MF.ent.surface and Util.distance(entity.position, MF.ent.position) < _mfSyncAreaRadius
-- 			and not MF.fS.entity_prototype_collides(entity.name, {_mfSyncAreaPosition.x + (entity.position.x - math.floor(MF.ent.position.x)), _mfSyncAreaPosition.y + (entity.position.y - math.floor(MF.ent.position.y))}, false)
-- 		then
-- 		MF:cloneEntity(entity, "in")
-- 	end
-- 	-- Inside to Outside --
-- 	if entity.surface == MF.fS and Util.distance(entity.position, _mfSyncAreaPosition) < _mfSyncAreaRadius
-- 			and not MF.ent.surface.entity_prototype_collides(entity.name, {math.floor(MF.ent.position.x) + (entity.position.x - _mfSyncAreaPosition.x), math.floor(MF.ent.position.y) + (entity.position.y - _mfSyncAreaPosition.y)}, false)
-- 		then
-- 		MF:cloneEntity(entity, "out")
-- 	end
-- end

-- Called to know if the Entity is above a Constructible Area --
function checkCCTile(entity)
	local tile = entity.surface.find_tiles_filtered{position=entity.position, radius=1, limit=1}
	if tile[1] ~= nil and tile[1].valid == true and tile[1].name == "BuildTile" then return true end
	return false
end

-- Return all Items of all Chest to its original one if the SyncArea is stoped --
-- function removedSyncEntity(event)
-- 	local removedEnt = event.entity
-- 	local MF = nil
-- 	for _, MFObj in pairs(global.MFTable) do
-- 		if MFObj.ent ~= nil and MFObj.ent.valid and MFObj.syncAreaEnabled == true and MFObj.ent.speed == 0
-- 		and ((removedEnt.surface == MFObj.ent.surface and Util.distance(removedEnt.position, MFObj.ent.position) < _mfSyncAreaRadius)
-- 				or (removedEnt.surface == MFObj.fS and Util.distance(removedEnt.position, _mfSyncAreaPosition) < _mfSyncAreaRadius))
-- 			then
-- 			MF = MFObj
-- 			break
-- 		end
-- 	end
-- 	if MF == nil then return end

-- 	for i, ents in pairs(MF.clonedResourcesTable) do
-- 		-- Removed entity always treated as original, adjust if needed
-- 		if removedEnt == ents.cloned then
-- 			ents.original, ents.cloned = ents.cloned, ents.original
-- 		end
-- 		if removedEnt == ents.original then
-- 			-- Move chest content to buffer
-- 			if event.buffer ~= nil and removedEnt.type == "container" or removedEnt.type == "logistic-container" then
-- 				local inv = ents.cloned.get_inventory(defines.inventory.chest)
-- 				for i = 1, #inv do
-- 					local stack = inv[i]
-- 					if stack.valid_for_read == true then
-- 						event.buffer.insert(stack)
-- 					end
-- 				end
-- 				inv.clear()
-- 			end
-- 			-- Remove from table before unclone, to avoid recursion caused by script_raised_destroy
-- 			MF.clonedResourcesTable[i] = nil
-- 			MF:uncloneEntity(ents.original, ents.cloned)
-- 		end
-- 	end
-- end