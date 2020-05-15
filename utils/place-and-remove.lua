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

	-- Allow to place the Internal Energy Cube inside the Control Center and the Factory Surface --
	if cent.name == "InternalEnergyCube" and (string.match(cent.surface.name, _mfControlSurfaceName) or string.match(cent.surface.name, _mfSurfaceName) ) then
		if MF.internalEnergyObj.ent ~= nil and MF.internalEnergyObj.ent.valid == true then
			cent.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlacedOnce"}})
				creator.get_main_inventory().insert(event.stack)
			end
			return
		end
		-- Save the Internal Energy Cube --
		MF.internalEnergyObj:setEnt(cent)
		if event.stack ~= nil and event.stack.valid_for_read == true then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				MF.internalEnergyObj:addEnergy(tags.energy)
			end
		end
		return
	end

	-- Allow to place the Internal Quatron Cube inside the Control Center and the Factory Surface --
	if cent.name == "InternalQuatronCube" and (string.match(cent.surface.name, _mfControlSurfaceName) or string.match(cent.surface.name, _mfSurfaceName) ) then
		if MF.internalQuatronObj.ent ~= nil and MF.internalQuatronObj.ent.valid == true then
			cent.destroy()
			if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true then
				creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlacedOnce"}})
				creator.get_main_inventory().insert(event.stack)
			end
			return
		end
		-- Save the Internal Quatron Cube --
		MF.internalQuatronObj:setEnt(cent)
		if event.stack ~= nil and event.stack.valid_for_read == true then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				MF.internalQuatronObj:addEnergy(tags.energy)
			end
		end
		return
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

	-- Internal Energy Cube Ghost --
	if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true and cent.name == "entity-ghost" and event.stack.name == "InternalEnergyCube" then
		if isPlayer == true then creator.print({"", {"item-name." .. event.stack.name }, " ", {"gui-description.PlaceableInsideTheCCCArea"}}) end
		cent.destroy()
		return
	end

	-- Internal Quatron Cube Ghost --
	if isPlayer == true and event.stack ~= nil and event.stack.valid_for_read == true and cent.name == "entity-ghost" and event.stack.name == "InternalQuatronCube" then
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

	-- Save the Data Assembler --
	if cent.name == "DataAssembler" then
		placedDataAssembler(event)
		return
	end

	-- Save the Network Explorer --
	if cent.name == "NetworkExplorer" then
		placedNetworkExplorer(event)
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
	if cent.name == "EnergyCubeMK1" then
		placedEnergyCube(event)
		if event.stack ~= nil and event.stack.valid_for_read == true then
			local tags = event.stack.get_tag("Infos")
			if tags ~= nil then
				global.energyCubesTable[cent.unit_number].ent.energy = tags.energy
			end
		end
		return
	end

	-- Save the Energy Laser --
	if cent.name == "EnergyLaser1" then
		placedEnergyLaser(event)
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
	local removedEnt = event.entity

	-- Get the Player Mobile Factory --
	local MF = nil

	-- The Mobile Factory was removed --
	if string.match(removedEnt.name, "MobileFactory") then
		MF = Util.valueToObj(global.MFTable, "ent", removedEnt)
		if MF ~= nil then
			MF:remove()
		end
		return
	end

	-- Remove the Matter Interactor --
	if removedEnt.name == "MatterInteractor" then
		removedMatterInteractor(event)
		return
	end

	-- Remove the Fluid Interactor --
	if removedEnt.name == "FluidInteractor" then
		removedFluidInteractor(event)
		return
	end

	-- Remove the Data Assembler --
	if removedEnt.name == "DataAssembler" then
		removedDataAssembler(event)
		return
	end

	-- Remove the Network Explorer --
	if removedEnt.name == "NetworkExplorer" then
		removedNetworkExplorer(event)
		return
	end

	-- Remove the Data Center --
	if removedEnt.name == "DataCenter" then
		local obj = global.dataCenterTable[removedEnt.unit_number]
		if obj ~= nil and table_size(obj.invObj.inventory) > 0 and event.buffer ~= nil and event.buffer[1] ~= nil then
			obj.invObj:rescan()
			event.buffer[1].set_tag("Infos", {inventory=obj.invObj.inventory})
			event.buffer[1].custom_description = {"", {"item-description.DataCenter"}, {"item-description.DataCenterC", obj.invObj.usedCapacity}}
		end
		removedDataCenter(event)
		return
	end

	-- Remove the Data Storage --
	if removedEnt.name == "DataStorage" then
		removedDataStorage(event)
		return
	end

	-- Remove the Data Center MF --
	if removedEnt.name == "DataCenterMF" then
		MF = Util.valueToObj(global.MFTable, "dataCenter", removedEnt)
		if MF ~= nil then MF.dataCenter = nil end
		removedDataCenterMF(event)
		return
	end

	-- Remove the Wireless Data Transmitter --
	if removedEnt.name == "WirelessDataTransmitter" then
		removedWirelessDataTransmitter(event)
		return
	end

	-- Remove the Wireless Data Receiver --
	if removedEnt.name == "WirelessDataReceiver" then
		removedWirelessDataReceiver(event)
		return
	end

	-- Remove the Internal Energy Cube --
	if removedEnt.name == "InternalEnergyCube" then
		for k, MFObj in pairs(global.MFTable) do
			if MFObj.internalEnergyObj.ent ~= nil and MFObj.internalEnergyObj.ent.valid == true and removedEnt == MFObj.internalEnergyObj.ent then
				event.buffer[1].set_tag("Infos", {energy=MFObj.internalEnergyObj:energy()})
				event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.EnergyCubeC", Util.toRNumber(math.floor(MFObj.internalEnergyObj:energy()))}}
				MFObj.internalEnergyObj:remove()
			end
		end
		return
	end

	-- Remove the Internal Quatron Cube --
	if removedEnt.name == "InternalQuatronCube" then
		for k, MFObj in pairs(global.MFTable) do
			if MFObj.internalQuatronObj.ent ~= nil and MFObj.internalQuatronObj.ent.valid == true and removedEnt == MFObj.internalQuatronObj.ent then
				event.buffer[1].set_tag("Infos", {energy=MFObj.internalQuatronObj:energy()})
				event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.EnergyCubeC", Util.toRNumber(math.floor(MFObj.internalQuatronObj:energy()))}}
				MFObj.internalQuatronObj:remove()
			end
		end
		return
	end

	-- Remove the Energy Cube --
	if removedEnt.name == "EnergyCubeMK1" then
		local obj = global.energyCubesTable[removedEnt.unit_number]
		if obj ~= nil and obj.ent ~= nil and obj.ent.valid == true and obj.ent.energy > 0 and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {energy=obj.ent.energy})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.EnergyCubeC", Util.toRNumber(math.floor(obj.ent.energy))}, "J"}
		end
		removedEnergyCube(event)
		return
	end

	-- Remove the Energy Laser --
	if removedEnt.name == "EnergyLaser1" then
		removedEnergyLaser(event)
		return
	end

	-- Remove the Ore Cleaner --
	if removedEnt.name == "OreCleaner" then
		local obj = global.oreCleanerTable[removedEnt.unit_number]
		if obj ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {purity=obj.purity, charge=obj.charge, totalCharge=obj.totalCharge})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.OreCleanerC", obj.purity, obj.charge, obj.totalCharge}}
		end
		removedOreCleaner(event)
		return
	end

	-- Remove the Fluid Extractor --
	if removedEnt.name == "FluidExtractor" then
		local obj = global.fluidExtractorTable[removedEnt.unit_number]
		if obj ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {purity=obj.purity, charge=obj.charge, totalCharge=obj.totalCharge})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.FluidExtractorC", obj.purity, obj.charge, obj.totalCharge}}
		end
		removedFluidExtractor(event)
		return
	end

	-- Remove the Jet Flag --
	if string.match(removedEnt.name, "Flag") then
		local obj = global.jetFlagTable[removedEnt.unit_number]
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
	if removedEnt.name == "DeepStorage" then
		local obj = global.deepStorageTable[removedEnt.unit_number]
		if obj ~= nil and obj.inventoryItem ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {inventoryItem=obj.inventoryItem, inventoryCount=obj.inventoryCount})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.DeepStorageC", obj.inventoryItem, obj.inventoryCount}}
		end
		removedDeepStorage(event)
		return
	end
	
	-- Remove the Deep Tank --
	if removedEnt.name == "DeepTank" then
		local obj = global.deepTankTable[removedEnt.unit_number]
		if obj ~= nil and obj.inventoryFluid ~= nil and event.buffer ~= nil and event.buffer[1] ~= nil then
			event.buffer[1].set_tag("Infos", {inventoryFluid=obj.inventoryFluid, inventoryCount=obj.inventoryCount})
			event.buffer[1].custom_description = {"", event.buffer[1].prototype.localised_description, {"item-description.DeepTankC", obj.inventoryFluid, obj.inventoryCount}}
		end
		removedDeepTank(event)
		return
	end

	-- Remove the Erya Structure --
	if eryaSave(removedEnt.name) then
		removedEryaStructure(event)
	end

	-- Return Sync Area Items from Chests --
	if removedEnt.type == "container" then
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
end

-- Return false if the item can't be placed outside the Mobile Factory --
function canBePlacedOutside(name)
	if name == "InternalEnergyCube" then return false end
	if name == "InternalQuatronCube" then return false end
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