-- Called when something is placed --
function somethingWasPlaced(event, isRobot)
	-- Get the Entity if needed
	if event.created_entity == nil and event.entity ~= nil then
		event.created_entity = event.entity
	end
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
	
	-- Prevent to place Tiles inside the Control Center --
	if creator ~= nil and event.tiles ~= nil and creator.surface.name == _mfControlSurfaceName  then
		if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then 
			creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.CCNotPlaceable"}})
		end
		for k, tile in pairs(event.tiles) do
			createTilesAtPosition(tile.position, 1, creator.surface, tile.old_tile.name, true)
		end
	end
	
	-- Check if all are valid --
	if event.created_entity == nil or event.created_entity.valid == false then return end
	
	-- If the Mobile Factory is placed --
	if string.match(event.created_entity.name, "MobileFactory") then
		-- If the Mobile Factory already exist --
		if global.MF.ent ~= nil and global.MF.ent.valid == true then
			if isPlayer == true then creator.print({"", {"gui-description.MaxPlaced"}, " ", {"item-name." .. event.stack.name }}) end
			event.created_entity.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		-- Check if the Mobile Factory can be placed here --
		elseif creator.surface.name == _mfSurfaceName or creator.surface.name == _mfControlSurfaceName then
			if isPlayer == true then creator.print({"", {"gui-description.MFPlacedInsideFactory"}}) end
			event.created_entity.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		-- Factorissimo Check --
		elseif string.match(creator.surface.name, "Factory") then
			if isPlayer == true then creator.print({"", {"gui-description.MFPlacedInsideFactorissimo"}}) end
			event.created_entity.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		-- Else, create a new one --
		else
			newMobileFactory(event.created_entity)
		end
	end
	
	-- Prevent to place listed entities outside the Mobile Factory --
	if event.created_entity.surface.name ~= _mfSurfaceName then
		if canBePlacedOutside(event.created_entity.name) == false then
			if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheFactory"}}) end
			event.created_entity.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		end
	end
	
	-- Deep Storage Ghost --
	if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true and event.created_entity.name == "entity-ghost" and event.stack.name == "DeepStorage" then
		if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheCCCArea"}}) end
		event.created_entity.destroy()
		return
	end
	
	-- Ghost --
	if isPlayer == true and event.created_entity.surface.name ~= _mfSurfaceName and event.stack ~= nil and event.stack.valid_for_read == true and event.created_entity.name == "entity-ghost" then
		if canBePlacedOutside(event.stack.name) == false then
			if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheFactory"}}) end
			event.created_entity.destroy()
			return
		end
	end
	
	-- Blueprint --
	if isPlayer == true and creator.surface.name ~= _mfSurfaceName and event.stack ~= nil and event.stack.valid_for_read == true and event.stack.is_blueprint == true then
	if event.stack.name == "DeepStorage" then
		if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheCCCArea"}}) end
			event.created_entity.destroy()
			return
		end
		if canBePlacedOutside(event.created_entity.name) == false then
			if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheFactory"}}) end
			event.created_entity.destroy()
			return
		end
	end
	
	-- Allow to place things in the Control Center --
	if event.created_entity.name == "DeepStorage" and event.created_entity.surface.name == _mfControlSurfaceName then
		local tile = event.created_entity.surface.find_tiles_filtered{position=event.created_entity.position, radius=1, limit=1}
		if tile[1] ~= nil and tile[1].valid == true and tile[1].name == "BuildTile" then
			placedDeepStorage(event)
			if event.stack ~= nil then
				local tags = event.stack.get_tag("Infos")
				if tags ~= nil then
					global.deepStorageTable[event.created_entity.unit_number].inventoryItem = tags.inventoryItem
					global.deepStorageTable[event.created_entity.unit_number].inventoryCount = tags.inventoryCount
				end
			end
			return
		end
	end
	
	-- Prevent to place things inside the Control Center --
	if event.created_entity.surface.name == _mfControlSurfaceName then
		if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.CCNotPlaceable"}}) end
		event.created_entity.destroy()
		if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
			creator.get_main_inventory().insert(event.stack)
		end
		return
	end
	
	-- Prevent to place things out of the Control Center --
	if event.created_entity.name == "DeepStorage" then
		if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheCCCArea"}}) end
		event.created_entity.destroy()
		if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
			creator.get_main_inventory().insert(event.stack)
		end
		return
	end
	
	-- Save the Factory Chest --
	if event.created_entity.name == "FactoryChest" then
		if global.MF.fChest ~= nil and global.MF.fChest.valid == true then
			if isPlayer == true then creator.print({"", {"gui-description.MaxPlaced"}, " ", {"item-name." .. event.stack.name }}) end
			event.created_entity.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		else
			global.MF.fChest = event.created_entity
		end
	end
	
	-- Save the Ghost inside the Construction Table --
	if event.created_entity ~= nil and event.created_entity.valid == true and event.created_entity.name == "entity-ghost" and global.MF.ent ~= nil and global.MF.ent.valid == true and event.created_entity.surface.name == global.MF.ent.surface.name then
		if table_size(global.constructionTable) > 1000 then
			game.print("Mobile Factory: To many Blueprint inside the Construction Table")
			global.constructionTable = {}
		end
		table.insert(global.constructionTable,{ent=event.created_entity, item=event.created_entity.ghost_prototype.items_to_place_this[1].name, name=event.created_entity.ghost_name, position=event.created_entity.position, direction=event.created_entity.direction or 1, mission="Construct"})
	end
	
	-- Save the Dimensional Accumulator --
	if event.created_entity.name == "DimensionalAccumulator" then
		placedDimensionalAccumulator(event)
		return
	end
	
	-- Save the Power Drain Pole --
	if event.created_entity.name == "PowerDrainPole" then
		placedPowerDrainPole(event)
		return
	end
	
	-- Save the Logistic Fluid Pole --
	if event.created_entity.name == "LogisticFluidPole" then
		placedLogisticPowerPole(event)
		return
	end
	
	-- Save the Matter Serializer --
	if event.created_entity.name == "MatterSerializer" then
		placedMatterSerializer(event)
		return
	end
	
	-- Save the Matter Printer --
	if event.created_entity.name == "MatterPrinter" then
		placedMatterPrinter(event)
		return
	end
	
	-- Save the Data Center --
	if event.created_entity.name == "DataCenter" then
		placedDataCenter(event)
		if event.stack ~= nil then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				global.dataCenterTable[event.created_entity.unit_number].invObj.inventory = tags.inventory
			end
		end
		return
	end
	
	-- Save the Wireless Data Transmitter --
	if event.created_entity.name == "WirelessDataTransmitter" then
		placedWirelessDataTransmitter(event)
		return
	end
	
	-- Save the Wireless Data Receiver --
	if event.created_entity.name == "WirelessDataReceiver" then
		placedWirelessDataReceiver(event)
		return
	end
	
	-- Save the Energy Cube --
	if string.match(event.created_entity.name, "EnergyCube") then
		placedEnergyCube(event)
		if event.stack ~= nil then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				global.energyCubesTable[event.created_entity.unit_number].ent.energy = tags.energy
			end
		end
		return
	end
	
	-- Save the Data Center MF --
	if event.created_entity.name == "DataCenterMF" then
		if valid(global.MF.dataCenter) == true then
			if isPlayer == true then creator.print({"", {"gui-description.MaxPlaced"}, " ", {"item-name." .. event.stack.name }}) end
			event.created_entity.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		else
			placedDataCenterMF(event)
			return
		end
	end
	
	-- Save the Data Storage --
	if event.created_entity.name == "DataStorage" then
		placedDataStorage(event)
		return
	end
	
	-- Save the Ore Cleaner --
	if event.created_entity.name == "OreCleaner" then
		placedOreCleaner(event)
		if event.stack ~= nil then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				global.oreCleanerTable[event.created_entity.unit_number].purity = tags.purity
				global.oreCleanerTable[event.created_entity.unit_number].charge = tags.charge
				global.oreCleanerTable[event.created_entity.unit_number].totalCharge = tags.totalCharge
			end
		end
		return
	end
	
	-- Save the Fluid Extractor --
	if event.created_entity.name == "FluidExtractor" then
		placedFluidExtractor(event)
		if event.stack ~= nil then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				global.fluidExtractorTable[event.created_entity.unit_number].purity = tags.purity
				global.fluidExtractorTable[event.created_entity.unit_number].charge = tags.charge
				global.fluidExtractorTable[event.created_entity.unit_number].totalCharge = tags.totalCharge
			end
		end
		return
	end
	
	-- Save the Jet Flag --
	if string.match(event.created_entity.name, "Flag") then
		placedJetFlag(event)
		if event.stack ~= nil then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				global.jetFlagTable[event.created_entity.unit_number].inventory = tags.inventory
			end
		end
		return
	end
end

-- When something is removed or destroyed --
function somethingWasRemoved(event)
	-- Check if the Entity is valid --
	if event.entity == nil or event.entity.valid == false then return end
	-- The Mobile Factory was removed --
	if string.match(event.entity.name, "MobileFactory") then
		global.MF:remove(event.entity)
		return
	end
	-- Remove the Factory Chest --
	if event.entity.name == "FactoryChest" then
		global.MF.fChest = nil
		return
	end
	-- Remove the Dimensional Accumulator --
	if event.entity.name == "DimensionalAccumulator" then
		removedDimensionalAccumulator(event)
		return
	end
	-- Remove the Power Drain Pole --
	if event.entity.name == "PowerDrainPole" then
		removedPowerDrainPole(event)
		return
	end
	-- Remove the Logistic Fluid Pole --
	if event.entity.name == "LogisticFluidPole" then
		removedLogisticPowerPole(event)
		return
	end
	-- Remove the Matter Serializer --
	if event.entity.name == "MatterSerializer" then
		removedMatterSerializer(event)
		return
	end
	-- Remove the Matter Printer --
	if event.entity.name == "MatterPrinter" then
		removedMatterPrinter(event)
		return
	end
	-- Remove the Data Center --
	if event.entity.name == "DataCenter" then
		local obj = global.dataCenterTable[event.entity.unit_number]
		if obj ~= nil and table_size(obj.invObj.inventory) > 0 and event.buffer ~= nil and event.buffer[1] ~= nil then
			obj.invObj:rescan()
			event.buffer[1].set_tag("Infos", {inventory=obj.invObj.inventory})
			event.buffer[1].custom_description = {"", {"item-description.DataCenter"}, {"item-description.DataCenterC", obj.invObj.usedCapacity}}
		end
		removedDataCenter(event)
		return
	end
	-- Remove the Data Storage --
	if event.entity.name == "DataStorage" then
		removedDataStorage(event)
		return
	end
	-- Remove the Data Center MF --
	if event.entity.name == "DataCenterMF" then
		removedDataCenterMF(event)
		return
	end
	-- Remove the Wireless Data Transmitter --
	if event.entity.name == "WirelessDataTransmitter" then
		removedWirelessDataTransmitter(event)
		return
	end
	-- Remove the Wireless Data Receiver --
	if event.entity.name == "WirelessDataReceiver" then
		removedWirelessDataReceiver(event)
		return
	end
	-- Remove the Energy Cube --
	if string.match(event.entity.name, "EnergyCube") then
		removedEnergyCube(event)
		local obj = global.energyCubesTable[event.entity.unit_number]
		if obj ~= nil and obj.ent ~= nil and obj.ent.valid == true and obj.ent.energy > 0 and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {energy=obj.ent.energy})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.EnergyCubeC", Util.toRNumber(math.floor(obj.ent.energy))}, "J"}
		end
		return
	end
	-- Remove the Ore Cleaner --
	if event.entity.name == "OreCleaner" then
		local obj = global.oreCleanerTable[event.entity.unit_number]
		if obj ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {purity=obj.purity, charge=obj.charge, totalCharge=obj.totalCharge})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.OreCleanerC", obj.purity, obj.charge, obj.totalCharge}}
		end
		removedOreCleaner(event)
		return
	end
	-- Remove the Fluid Extractor --
	if event.entity.name == "FluidExtractor" then
		local obj = global.fluidExtractorTable[event.entity.unit_number]
		if obj ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {purity=obj.purity, charge=obj.charge, totalCharge=obj.totalCharge})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.FluidExtractorC", obj.purity, obj.charge, obj.totalCharge}}
		end
		removedFluidExtractor(event)
		return
	end
	-- Remove the Jet Flag --
	if string.match(event.entity.name, "Flag") then
		local obj = global.jetFlagTable[event.entity.unit_number]
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
	if event.entity.name == "DeepStorage" then
		local obj = global.deepStorageTable[event.entity.unit_number]
		if obj ~= nil and obj.inventoryItem ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {inventoryItem=obj.inventoryItem, inventoryCount=obj.inventoryCount})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.DeepStorageC", obj.inventoryItem, obj.inventoryCount}}
		end
		removedDeepStorage(event)
		return
	end
end

-- Return false if the item can't be placed outside the Mobile Factory --
function canBePlacedOutside(name)
	if name == "FactoryChest" then return false end
	if name == "DimensionalAccumulator" then return false end
	return true
end

-- Called when a Structure is marked for deconstruction --
function markedForDeconstruction(event)
	if event.entity == nil or event.entity.valid == false then return end
	if global.MF.ent == nil or global.MF.ent.valid == false or event.entity.surface.name ~= global.MF.ent.surface.name then return end
	table.insert(global.constructionTable,{ent=event.entity, name=event.entity.name, position=event.entity.position, direction=event.entity.direction or 1, mission="Deconstruct"})
end