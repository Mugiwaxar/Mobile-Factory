-- Called when something is placed --
function somethingWasPlaced(event, isRobot)
	-- script_raised_revive uses entity, and breaks every single save<Entity> function --
	local fakeEvent = {}
	for k, v in pairs(event) do
		fakeEvent[k] = v
	end
	if fakeEvent.entity and fakeEvent.created_entity == nil then
		fakeEvent.created_entity = fakeEvent.entity
	end
	event = fakeEvent

	-- Get the Entity
	local cent = event.created_entity

	-- This is a Player or not --
	local isPlayer = false
	-- Creator variable --
	local creator = nil
	-- Test if this is a Player or a Bot --
	if isRobot == true then
		creator = event.robot
	elseif event.player_index ~= nil then
		isPlayer = true
		creator = getPlayer(event.player_index)
	end

	local MF = nil
	if cent ~= nil and cent.last_user ~= nil then MF = getMF(cent.last_user.name) end
	if isPlayer == true then MF = getMF(creator.name) end

	-- Prevent to place Tiles inside the Control Center --
	if creator ~= nil and event.tiles ~= nil and string.match(creator.surface.name, _mfControlSurfaceName) then
		if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then 
			creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.CCNotPlaceable"}})
		end
		for k, tile in pairs(event.tiles) do
			createTilesAtPosition(tile.position, 1, creator.surface, tile.old_tile.name, true)
		end
	end
	
	-- Check if all are valid --
	if cent == nil or cent.valid == false then return end
	
	-- If a Mobile Factory is placed --
	if string.match(cent.name, "MobileFactory") then
		-- If the Mobile Factory already exist --
		if MF ~= nil and MF.ent ~= nil and MF.ent.valid == true then
			if isPlayer == true then creator.print({"", {"gui-description.MaxPlaced"}, " ", {"item-name." .. event.stack.name }}) end
			cent.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		-- Check if the Mobile Factory can be placed here --
		elseif string.match(creator.surface.name, _mfSurfaceName) or string.match(creator.surface.name, _mfControlSurfaceName) then
			if isPlayer == true then creator.print({"", {"gui-description.MFPlacedInsideFactory"}}) end
			cent.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		-- Factorissimo Check --
		elseif string.match(creator.surface.name, "Factory") then
			if isPlayer == true then creator.print({"", {"gui-description.MFPlacedInsideFactorissimo"}}) end
			cent.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		-- Else, create a new one --
		else
			newMobileFactory(cent)
		end
	end

	-- Prevent to place listed entities outside the Mobile Factory --
	if string.match(cent.surface.name, _mfSurfaceName) == nil then
		if canBePlacedOutside(cent.name) == false then
			if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheFactory"}}) end
			cent.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		end
	end
	
	-- Deep Storage Ghost --
	if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true and cent.name == "entity-ghost" and event.stack.name == "DeepStorage" then
		if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheCCCArea"}}) end
		cent.destroy()
		return
	end
	
	-- Deep Tank Ghost --
	if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true and cent.name == "entity-ghost" and event.stack.name == "DeepTank" then
		if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheCCCArea"}}) end
		cent.destroy()
		return
	end

	-- Ghost --
	if isPlayer == true and string.match(cent.surface.name, _mfSurfaceName) == nil and event.stack ~= nil and event.stack.valid_for_read == true and cent.name == "entity-ghost" then
		if canBePlacedOutside(event.stack.name) == false then
			if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheFactory"}}) end
			cent.destroy()
			return
		end
	end
	
	-- Blueprint --
	if isPlayer == true and string.match(cent.surface.name, _mfSurfaceName) == nil and event.stack ~= nil and event.stack.valid_for_read == true and event.stack.is_blueprint == true then
	if event.stack.name == "DeepStorage" or event.stack.name == "DeepTank" then
		if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheCCCArea"}}) end
			cent.destroy()
			return
		end
		if canBePlacedOutside(cent.name) == false then
			if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheFactory"}}) end
			cent.destroy()
			return
		end
	end
	
	-- Allow to place Deep Storage inside the Control Center --
	if cent.name == "DeepStorage" and string.match(cent.surface.name, _mfControlSurfaceName) then
		local tile = cent.surface.find_tiles_filtered{position=cent.position, radius=1, limit=1}
		if tile[1] ~= nil and tile[1].valid == true and tile[1].name == "BuildTile" then
			placedDeepStorage(event)
			if event.stack ~= nil and event.stack.valid_for_read == true then
				local tags = event.stack.get_tag("Infos")
				if tags ~= nil then
					global.deepStorageTable[cent.unit_number].inventoryItem = tags.inventoryItem
					global.deepStorageTable[cent.unit_number].inventoryCount = tags.inventoryCount
				end
			end
			return
		end
	end

	-- Allow to place Deep Tank inside the Control Center --
	if cent.name == "DeepTank" and string.match(cent.surface.name, _mfControlSurfaceName) then
		local tile = cent.surface.find_tiles_filtered{position=cent.position, radius=1, limit=1}
		if tile[1] ~= nil and tile[1].valid == true and tile[1].name == "BuildTile" then
			placedDeepTank(event)
			if event.stack ~= nil and event.stack.valid_for_read == true then
				local tags = event.stack.get_tag("Infos")
				if tags ~= nil then
					global.deepTankTable[cent.unit_number].inventoryFluid = tags.inventoryFluid
					global.deepTankTable[cent.unit_number].inventoryCount = tags.inventoryCount
				end
			end
			return
		end
	end
	
	-- Prevent to place things inside the Control Center --
	if string.match(cent.surface.name, _mfControlSurfaceName) then
		cent.destroy()
		if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
			creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.CCNotPlaceable"}})
			creator.get_main_inventory().insert(event.stack)
		end
		return
	end
	
	-- Prevent to place things out of the Control Center --
	if cent.name == "DeepStorage" or cent.name == "DeepTank" then
		cent.destroy()
		if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
			creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheCCCArea"}})
			creator.get_main_inventory().insert(event.stack)
		end
		return
	end

	-- Save the Ghost inside the Construction Table --
	if cent ~= nil and cent.valid == true and (cent.name == "entity-ghost" or cent.name == "tile-ghost") and
	MF ~= nil and MF.ent ~= nil and MF.ent.valid == true and cent.surface.name == MF.ent.surface.name then
		if table_size(global.constructionTable) >= MF.varTable.jets.cjTableSize then
			local player = getPlayer(MF.playerIndex)
			if player then
				player.print({"info.cjTooManyGhosts", MF.varTable.jets.cjTableSize})
			end
			--global.constructionTable = {}
		else
			table.insert(global.constructionTable,{ent=cent, item=cent.ghost_prototype.items_to_place_this[1].name, name=cent.ghost_name, position=cent.position, direction=cent.direction or 1, mission="Construct"})
		end
	end

	-- Clone the Entity if it is inside the Sync Area --
	if _mfSyncAreaAllowedTypes[cent.type] == true and MF ~= nil and MF.ent ~= nil and MF.ent.valid and MF.syncAreaEnabled == true and MF.ent.speed == 0 then
		-- Outside to Inside --
		if cent.surface == MF.ent.surface and Util.distance(cent.position, MF.ent.position) < _mfSyncAreaRadius
				and not MF.fS.entity_prototype_collides(cent.name, {_mfSyncAreaPosition.x + (cent.position.x - math.floor(MF.ent.position.x)), _mfSyncAreaPosition.y + (cent.position.y - math.floor(MF.ent.position.y))}, false)
			then
			MF:cloneEntity(cent, "in")
		end
		-- Inside to Outside --
		if cent.surface == MF.fS and Util.distance(cent.position, _mfSyncAreaPosition) < _mfSyncAreaRadius
				and not MF.ent.surface.entity_prototype_collides(cent.name, {math.floor(MF.ent.position.x) + (cent.position.x - _mfSyncAreaPosition.x), math.floor(MF.ent.position.y) + (cent.position.y - _mfSyncAreaPosition.y)}, false)
			then
			MF:cloneEntity(cent, "out")
		end
	end
	
	-- Save the Dimensional Accumulator --
	if cent.name == "DimensionalAccumulator" then
		placedDimensionalAccumulator(event)
		return
	end
	
	-- Save the Power Drain Pole --
	if cent.name == "PowerDrainPole" then
		placedPowerDrainPole(event)
		return
	end

	-- Save the Matter Interactor --
	if cent.name == "MatterInteractor" then
		placedMatterInteractor(event)
		return
	end

	-- Save the Fluid Interactor --
	if cent.name == "FluidInteractor" then
		placedFluidInteractor(event)
		return
	end
	
	-- Save the Data Center --
	if cent.name == "DataCenter" then
		placedDataCenter(event)
		if event.stack ~= nil and event.stack.valid_for_read == true then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				global.dataCenterTable[cent.unit_number].invObj.inventory = tags.inventory
			end
		end
		return
	end
	
	-- Save the Wireless Data Transmitter --
	if cent.name == "WirelessDataTransmitter" then
		placedWirelessDataTransmitter(event)
		return
	end
	
	-- Save the Wireless Data Receiver --
	if cent.name == "WirelessDataReceiver" then
		placedWirelessDataReceiver(event)
		return
	end
	
	-- Save the Energy Cube --
	if string.match(cent.name, "EnergyCube") then
		placedEnergyCube(event)
		if event.stack ~= nil and event.stack.valid_for_read == true then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				global.energyCubesTable[cent.unit_number].ent.energy = tags.energy
			end
		end
		return
	end
	
	-- Save the Data Center MF --
	if cent.name == "DataCenterMF" then
		if MF ~= nil and valid(MF.dataCenter) == true then
			cent.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.print({"", {"gui-description.MaxPlaced"}, " ", {"item-name." .. event.stack.name }})
				creator.get_main_inventory().insert(event.stack)
			end
			return
		else
			placedDataCenterMF(event, MF)
			return
		end
	end
	
	-- Save the Data Storage --
	if cent.name == "DataStorage" then
		placedDataStorage(event)
		return
	end
	
	-- Save the Ore Cleaner --
	if cent.name == "OreCleaner" then
		placedOreCleaner(event)
		if event.stack ~= nil and event.stack.valid_for_read == true then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				global.oreCleanerTable[cent.unit_number].purity = tags.purity
				global.oreCleanerTable[cent.unit_number].charge = tags.charge
				global.oreCleanerTable[cent.unit_number].totalCharge = tags.totalCharge
			end
		end
		return
	end
	
	-- Save the Fluid Extractor --
	if cent.name == "FluidExtractor" then
		placedFluidExtractor(event)
		if event.stack ~= nil and event.stack.valid_for_read == true then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				global.fluidExtractorTable[cent.unit_number].purity = tags.purity
				global.fluidExtractorTable[cent.unit_number].charge = tags.charge
				global.fluidExtractorTable[cent.unit_number].totalCharge = tags.totalCharge
			end
		end
		return
	end
	
	-- Save the Jet Flag --
	if string.match(cent.name, "Flag") then
		placedJetFlag(event)
		if event.stack ~= nil and event.stack.valid_for_read == true then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				global.jetFlagTable[cent.unit_number].inventory = tags.inventory
			end
		end
		return
	end

	-- Save the Erya Structure --
	if eryaSave(cent.name) then
		placedEryaStructure(event)
	end
end

-- When something is removed or destroyed --
function somethingWasRemoved(event)
	-- Check if the Entity is valid --
	if event.entity == nil or event.entity.valid == false then return end
	local removed_ent = event.entity
	-- Get the Player Mobile Factory --
	local MF = nil
--[[
	-- last user can change during online play
	if removed_ent.last_user ~= nil then
		log("removed_ent.last_user: "..removed_ent.last_user.name)
		MF = getMF(removed_ent.last_user.name)
	end
--]]
	-- The Mobile Factory was removed --
	if string.match(removed_ent.name, "MobileFactory") then
		MF = Util.valueToObj(removed_ent)
		if MF ~= nil then
			MF:remove(removed_ent)
		end
		return
	end
	-- Remove the Dimensional Accumulator --
	if removed_ent.name == "DimensionalAccumulator" then
		removedDimensionalAccumulator(event)
		return
	end
	-- Remove the Power Drain Pole --
	if removed_ent.name == "PowerDrainPole" then
		removedPowerDrainPole(event)
		return
	end
	-- Remove the Matter Interactor --
	if removed_ent.name == "MatterInteractor" then
		removedMatterInteractor(event)
		return
	end
	-- Remove the Fluid Interactor --
	if removed_ent.name == "FluidInteractor" then
		removedFluidInteractor(event)
		return
	end
	-- Remove the Data Center --
	if removed_ent.name == "DataCenter" then
		local obj = global.dataCenterTable[removed_ent.unit_number]
		if obj ~= nil and table_size(obj.invObj.inventory) > 0 and event.buffer ~= nil and event.buffer[1] ~= nil then
			obj.invObj:rescan()
			event.buffer[1].set_tag("Infos", {inventory=obj.invObj.inventory})
			event.buffer[1].custom_description = {"", {"item-description.DataCenter"}, {"item-description.DataCenterC", obj.invObj.usedCapacity}}
		end
		removedDataCenter(event)
		return
	end
	-- Remove the Data Storage --
	if removed_ent.name == "DataStorage" then
		removedDataStorage(event)
		return
	end
	-- Remove the Data Center MF --
	if removed_ent.name == "DataCenterMF" then
		MF = Util.valueToObj(global.MFTable, "dataCenter", removed_ent)
		if MF ~= nil then MF.dataCenter = nil end
		removedDataCenterMF(event)
		return
	end
	-- Remove the Wireless Data Transmitter --
	if removed_ent.name == "WirelessDataTransmitter" then
		removedWirelessDataTransmitter(event)
		return
	end
	-- Remove the Wireless Data Receiver --
	if removed_ent.name == "WirelessDataReceiver" then
		removedWirelessDataReceiver(event)
		return
	end
	-- Remove the Energy Cube --
	if string.match(removed_ent.name, "EnergyCube") then
		removedEnergyCube(event)
		local obj = global.energyCubesTable[removed_ent.unit_number]
		if obj ~= nil and obj.ent ~= nil and obj.ent.valid == true and obj.ent.energy > 0 and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {energy=obj.ent.energy})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.EnergyCubeC", Util.toRNumber(math.floor(obj.ent.energy))}, "J"}
		end
		return
	end
	-- Remove the Ore Cleaner --
	if removed_ent.name == "OreCleaner" then
		local obj = global.oreCleanerTable[removed_ent.unit_number]
		if obj ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {purity=obj.purity, charge=obj.charge, totalCharge=obj.totalCharge})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.OreCleanerC", obj.purity, obj.charge, obj.totalCharge}}
		end
		removedOreCleaner(event)
		return
	end
	-- Remove the Fluid Extractor --
	if removed_ent.name == "FluidExtractor" then
		local obj = global.fluidExtractorTable[removed_ent.unit_number]
		if obj ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {purity=obj.purity, charge=obj.charge, totalCharge=obj.totalCharge})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.FluidExtractorC", obj.purity, obj.charge, obj.totalCharge}}
		end
		removedFluidExtractor(event)
		return
	end
	-- Remove the Jet Flag --
	if string.match(removed_ent.name, "Flag") then
		local obj = global.jetFlagTable[removed_ent.unit_number]
		if obj ~= nil and table_size(obj.inventory) > 0 and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {inventory=obj.inventory})
			local total = 0
			for k, count in pairs(obj.inventory) do
				total = total + count
			end
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.MiningJetFlagC", total}}
		end
		removedJetFlag(event)
		return
	end
	-- Remove the Deep Storage --
	if removed_ent.name == "DeepStorage" then
		local obj = global.deepStorageTable[removed_ent.unit_number]
		if obj ~= nil and obj.inventoryItem ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {inventoryItem=obj.inventoryItem, inventoryCount=obj.inventoryCount})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.DeepStorageC", obj.inventoryItem, obj.inventoryCount}}
		end
		removedDeepStorage(event)
		return
	end
	-- Remove the Deep Tank --
	if removed_ent.name == "DeepTank" then
		local obj = global.deepTankTable[removed_ent.unit_number]
		if obj ~= nil and obj.inventoryFluid ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {inventoryFluid=obj.inventoryFluid, inventoryCount=obj.inventoryCount})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.DeepTankC", obj.inventoryFluid, obj.inventoryCount}}
		end
		removedDeepTank(event)
		return
	end
	-- Remove the Erya Structure --
	if eryaSave(removed_ent.name) then
		removedEryaStructure(event)
	end

	-- Return Sync Area Items from Chests --
	if removed_ent.type == "container" then
		for _, MFObj in pairs(global.MFTable) do
			if MFObj.ent ~= nil and MFObj.ent.valid and MFObj.syncAreaEnabled == true and MFObj.ent.speed == 0 
			and ((removed_ent.surface == MFObj.ent.surface and Util.distance(removed_ent.position, MFObj.ent.position) < _mfSyncAreaRadius)
					or (removed_ent.surface == MFObj.fS and Util.distance(removed_ent.position, _mfSyncAreaPosition) < _mfSyncAreaRadius))
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
			if removed_ent == ents.original or removed_ent == ents.cloned then
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
end

-- Return false if the item can't be placed outside the Mobile Factory --
function canBePlacedOutside(name)
	if name == "FactoryChest" then return false end
	if name == "FactoryTank" then return false end
	if name == "DimensionalAccumulator" then return false end
	return true
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

function eryaSave(entName)
	if entName == "EryaLamp" then return true end
	if entName == "EryaInserter1" then return true end
	if entName == "EryaMiningDrill1" then return true end
	if entName == "EryaPumpjack1" then return true end
	if entName == "EryaAssemblingMachine1" then return true end
	if entName == "EryaPump1" then return true end
	if entName == "EryaRadar1" then return true end
	if entName == "EryaFurnace1" then return true end
	if entName == "EryaRefinery1" then return true end
	if entName == "EryaChemicalPlant1" then return true end
	return false
end