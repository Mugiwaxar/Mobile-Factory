-- Called when something is placed --
function somethingWasPlaced(event, isRobot)
	-- This is a Player or not --
	local isPlayer = false
	-- Creator variable --
	local creator = nil
	-- Test if this is a Player or a Bot --
	if isRobot ~= true then 
		isPlayer = true
		creator = getPlayer(event.player_index)
	else
		creator = event.robot
	end
	-- Prevent to place Lab/Void Tiles inside the Control Center --
	if event.tiles ~= nil and (event.tile.name == "tutorial-grid" or event.tile.name == "out-of-map") and creator.surface.name == _mfControlSurfaceName  then
		if isPlayer == true then creator.print({"", "Unable to place ", {"item-name." .. event.stack.name }, " outside the Factory"}) end
		for k, tile in pairs(event.tiles) do
			createTilesAtPosition(tile.position, 1, creator.surface, tile.old_tile.name)
		end
	end
	-- Check if all are valid --
	if event.created_entity == nil or event.created_entity.valid == false or creator == nil or creator.valid == false then return end
	-- If the Mobile Factory is placed --
	if string.match(event.created_entity.name, "MobileFactory") then
		-- If the Mobile Factory already exist --
		if global.MF.ent ~= nil and global.MF.ent.valid == true then
			if isPlayer == true then creator.print({"", "Unable to place more than one ", {"item-name." .. event.stack.name }}) end
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
	-- Item --
	if creator.surface.name ~= _mfSurfaceName then
		if canBePlacedOutside(event.created_entity.name) == false then
			if isPlayer == true then creator.print({"", "You can only place the ", {"item-name." .. event.stack.name }, " inside the Factory"}) end
			event.created_entity.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		end
	end
	-- Ghost --
	if isPlayer == true and creator.surface.name ~= _mfSurfaceName and event.stack ~= nil and event.stack.valid_for_read == true and event.created_entity.name == "entity-ghost" then
		if canBePlacedOutside(event.stack.name) == false then
			creator.print({"", "You can only place the ", {"item-name." .. event.stack.name }, " inside the Factory"})
			event.created_entity.destroy()
			return
		end
	end
	-- Blueprint --
	if isPlayer == true and creator.surface.name ~= _mfSurfaceName and event.stack ~= nil and event.stack.valid_for_read == true and event.stack.is_blueprint then
		if canBePlacedOutside(event.created_entity.ghost_name) == false then
			creator.print({"", "You can only place the ", {"item-name." .. event.stack.name }, " inside the Factory"})
			event.created_entity.destroy()
			return
		end
	end
	-- Allow to place things in the Control Center --
	if event.created_entity.name == "DataStorage" and creator.surface.name == _mfControlSurfaceName then
		local tile = creator.surface.find_tiles_filtered{position=event.created_entity.position, radius=1, limit=1}
		if tile[1] ~= nil and tile[1].valid == true and tile[1].name == "BuildTile" then
			placedDataStorage(event)
			return
		end
	end
	-- Prevent to place DataStorage --
	-- if event.created_entity.name == "DataStorage" then
		-- if isPlayer == true then creator.print("You can only place the " .. event.created_entity.name .. " inside the Control Center Constructible area") end
		-- event.created_entity.destroy()
		-- if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
			-- creator.get_main_inventory().insert(event.stack)
		-- end
		-- return
	-- end
	-- Prevent to place things in the Control Center --
	if creator.surface.name == _mfControlSurfaceName then
		if isPlayer == true then creator.print("You can't build inside the Control Center") end
		event.created_entity.destroy()
		if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
			creator.get_main_inventory().insert(event.stack)
		end
		return
	end
	-- Save the Factory Chest --
	if event.created_entity.name == "FactoryChest" then
		if global.MF.fChest ~= nil and global.MF.fChest.valid == true then
			if isPlayer == true then creator.print({"", "Unable to place more than one ", {"item-name." .. event.stack.name }}) end
			event.created_entity.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		else
			global.MF.fChest = event.created_entity
		end
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
		return
	end
	-- Save the Wireless Data Transmitter --
	if event.created_entity.name == "WirelessDataTransmitter" then
		placedWirelessDataTransmitter(event)
		return
	end
	-- Save the Energy Cube --
	if string.match(event.created_entity.name, "EnergyCube") then
		placedEnergyCube(event)
		return
	end
	-- Save the Data Center MF --
	if event.created_entity.name == "DataCenterMF" then
		if global.MF.dataCenter ~= nil and global.MF.dataCenter:valid() == true then
			if isPlayer == true then creator.print({"", "Unable to place more than one ", {"item-name." .. event.stack.name }}) end
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
	-- Save the Ore Silot Pad --
	-- if string.match(event.created_entity.name, "OreSilotPad") then
		-- placedOreSilotPad(event)
		-- return
	-- end
	-- Save the Ore Cleaner --
	if event.created_entity.name == "OreCleaner" then
		if global.oreCleaner ~= nil and global.oreCleaner.ent ~= nil then
			if isPlayer== true then creator.print({"", "Unable to place more than one ", {"item-name." .. event.stack.name }}) end
			event.created_entity.destroy()
			if isPlayer== true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.get_main_inventory().insert(event.stack)
			end
			return
		else
			if global.oreCleaner == nil then global.oreCleaner = OC:new(event.created_entity)
			else global.oreCleaner.ent = event.created_entity end
			global.oreCleaner:scanOres(event.created_entity)
			return
		end
	end
	-- Save the Fluid Extractor --
	if event.created_entity.name == "FluidExtractor" then
		placedFluidExtractor(event)
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
		removedDataCenter(event)
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
	-- Remove the Energy Cube --
	if string.match(event.entity.name, "EnergyCube") then
		removedEnergyCube(event)
		return
	end
	-- Remove the Ore Silot Pad --
	-- if string.match(event.entity.name, "OreSilotPad") then
		-- removedOreSilotPad(event)
		-- return
	-- end
	-- Remove the Inventory Pad --
	-- if event.entity.name == "DataStorage" then
		-- removedDataStorage(event)
		-- return
	-- end
	-- Remove the Ore Cleaner --
	if event.entity.name == "OreCleaner" then
		global.oreCleaner:remove()
		return
	end
	-- Remove the Fluid Extractor --
	if event.entity.name == "FluidExtractor" then
		removedFluidExtractor(event)
		return
	end
end

-- Return false if the item can't be placed outside the Mobile Factory --
function canBePlacedOutside(name)
	if name == "FactoryChest" then return false end
	if name == "DimensionalAccumulator" then return false end
	return true
end