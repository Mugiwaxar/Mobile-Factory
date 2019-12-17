require("utils/functions.lua")

-- Update System: Scan Entities --
function UpSys.scanEnts()
	-- Clear the Entities Table --
	global.entsTable = {}
		
	-- Add Entities --
	UpSys.addEntity(global.MF)
	if UpSys.addEntity(global.MF.dataCenter) == false then global.MF.dataCenter = nil end
	UpSys.addEntity(global.oreCleaner)
	
	-- Add Array --
	UpSys.addTable(global.dataCenterTable)
	UpSys.addTable(global.matterSerializerTable)
	UpSys.addTable(global.matterPrinterTable)
	UpSys.addTable(global.dataStorageTable)
	UpSys.addTable(global.energyCubesTable)
	
	-- Shuffle the MF Entities Table --
	UpSys.shuffle(global.entsTable)
end

-- Update System: Add an Entity to the MF Entities Table --
function UpSys.addEntity(entity)
	-- Check if the Entity is not null --
	if entity ~= nil then
		if entity:valid() ~= true then
			-- Delete the Entity --
			entity:remove()
			return false
		else
			table.insert(global.entsTable, entity)
		end
	end
	return true
end

-- Update System: Add a Table to the MF Entities Table --
function UpSys.addTable(array)
	-- Itinerate the Table --
	for k, ent in pairs(array) do
		-- Add the Entity --
		if UpSys.addEntity(ent) == false then array[k] = nil end
	end
end

-- Update System: Randomize Table --
function UpSys.shuffle(array)
	math.randomseed(game.tick)
	for i = table_size(array), 2, -1 do
		local j = math.random(i)
		array[i], array[j] = array[j], array[i]
	end
	return array
end

-- Update System: Update Entities --
function UpSys.update(event)
	-- Check the Entities Table --
	if global.entsTable == nil then global.entsTable = {} end
	-- Check the Index --
	if global.upSysIndex == nil then global.upSysIndex = 1 end
	-- Check the last Entities scan --
	if global.upSysLastScan == nil then global.upSysLastScan = 0 end
	-- Create the updated Index --
	local updated = 1
	
	-- Get the Entities Table size --
	local maxIndex = table_size(global.entsTable)
	-- Begin the Update of Entities --
	while updated <= global.entsUpPerTick and global.upSysIndex <= maxIndex do
		-- Check if the Entity is valid --
		if getmetatable(global.entsTable[global.upSysIndex]) ~= nil and global.entsTable[global.upSysIndex]:valid() == true then
			-- Check if the Entity need an update --
			if global.entsTable[global.upSysIndex].updateTick > 0 and game.tick - global.entsTable[global.upSysIndex].lastUpdate >= global.entsTable[global.upSysIndex].updateTick then
				-- Update the Entity --
				global.entsTable[global.upSysIndex]:update(event)
				-- Increment the number of Entities updated --
				updated = updated + 1
			end
		end
		
		-- Increment the Global Index --
		global.upSysIndex = global.upSysIndex + 1
		
	end
	
	-- Scan all the Entities if needed --
	if global.upSysIndex > maxIndex and game.tick - global.upSysLastScan >= 100 then
		-- Reinitialize the index --
		global.upSysIndex = 1
		-- Save the last scan tick --
		global.upSysLastScan = game.tick
		-- Rescan all Entities --
		UpSys.scanEnts()
	elseif global.upSysIndex > maxIndex then
		global.upSysIndex = 1
	end
	
end


-- Recharge inroom Dimensional Accumulator --
function updateAccumulators()
	-- Factory --
	if global.MF.fS ~= nil and global.MF.fS.valid == true and technologyUnlocked("EnergyDistribution1") and global.MF.internalEnergyDistributionActivated and global.MF.internalEnergy > 0 then
		for k, entity in pairs(global.accTable) do
			if entity == nil or entity.valid == false then global.accTable[k] = nil return end
			if global.MF.internalEnergy > _mfBaseEnergyAccSend and entity.energy < entity.electric_buffer_size then
				entity.energy = entity.energy + _mfBaseEnergyAccSend
				global.MF.internalEnergy = global.MF.internalEnergy - _mfBaseEnergyAccSend
			end
		end
	end
	-- Control Center --
	if global.MF.ccS ~= nil then
		local accumulator = global.MF.ccS.find_entity("DimensionalAccumulator", {2,12})
		if accumulator == nil or accumulator.valid == false then
			game.print("Unable to charge the Control Center accumulator")
		else
			accumulator.energy = accumulator.electric_buffer_size
		end
	end
end

-- Fill/Empty tank --
function updateLogisticFluidPoles()
	if technologyUnlocked("LogisticFluidPole") == false then return end
	for k, entity in pairs(global.lfpTable) do
		if entity == nil or entity.valid == false then global.lfpTable[k] = nil return end
		local powerMD = 0
		local efficiencyMD = 0
		local focusMD = 0
		local methodMD
		local tankMDS
		local tankMD
		for name, count in pairs(entity.get_inventory(defines.inventory.beacon_modules).get_contents()) do
			if name == "EnergyPowerModule" then powerMD = powerMD + count end
			if name == "EnergyEfficiencyModule" then efficiencyMD = efficiencyMD + count end
			if name == "EnergyFocusModule" then focusMD = focusMD + count end
			if name == "DistributionModule" then methodMD = "DistributionModule" end
			if name == "DrainModule" then methodMD = "DrainModule" end
			if string.match(name, "ModuleID") then tankMDS = name end
		end
		if tankMDS ~= nil then
			tankMD = split(tankMDS, "D")[2]
			tankMD = tonumber(tankMD)
		end
		if methodMD ~= nil and tankMD ~= nil and tankMD > 0 then
			local lfpRadius = _lfpFluidRadius + powerMD
			local lfpDrain = _lfpFluidDrain * (efficiencyMD + 1)
			local lfpLaser = _lfpFluidLaser + focusMD
			local entities = entity.surface.find_entities_filtered{position=entity.position, radius=lfpRadius}
			i = 1
			for k, pTank in pairs(entities) do
				if pTank ~= nil and pTank.valid == true then
					if i > lfpLaser then break end
					if pTank.type == "storage-tank" then
						if pTank.fluidbox.get_capacity(1) > 1000 then
							local ccTank
							local filter
							if global.tankTable ~= nil and global.tankTable[tankMD] ~= nil then 
								filter = global.tankTable[tankMD].filter
								ccTank = global.tankTable[tankMD].ent
							end
							if filter ~= nil and ccTank ~= nil then
								if methodMD == "DistributionModule" then
									local name
									local amount
									for k, i in pairs(ccTank.get_fluid_contents()) do
										name = k
										amount = i
									end
									if name ~= nil and global.MF.internalEnergy > _lfpFluidConsomption * math.min(amount, lfpDrain) then
									
										local amountRm = pTank.insert_fluid({name=name, amount=math.min(amount, lfpDrain)})
										ccTank.remove_fluid{name=name, amount = amountRm}
										if amountRm > 0 then
											entity.surface.create_entity{name="PurpleBeam", duration=60, position=entity.position, target=pTank.position, source={entity.position.x, entity.position.y-4.5}}
											global.MF.internalEnergy = global.MF.internalEnergy - (_lfpFluidConsomption*amountRm)
											i = i + 1
										end
									end
								end
								if methodMD == "DrainModule" then
									local name
									local amount
									for k, i in pairs(pTank.get_fluid_contents()) do
										name = k
										amount = i
									end
									if name ~= nil and name == filter and global.MF.internalEnergy > _lfpFluidConsomption * math.min(amount, lfpDrain) then
										local amountRm = ccTank.insert_fluid({name=name, amount=math.min(amount, lfpDrain)})
										pTank.remove_fluid{name=name, amount=amountRm}
										if amountRm > 0 then
											entity.surface.create_entity{name="PurpleBeam", duration=60, position=entity.position, target=pTank.position, source={entity.position.x, entity.position.y-4.5}}
											global.MF.internalEnergy = global.MF.internalEnergy - (_lfpFluidConsomption*amountRm)
											i = i + 1
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Update the Power Drain Pole --
function updatePowerDrainPole(event)
	-- Test if the technology is unlocked, if the PDP table is not empty and if the Mobile Factory need energy --
	if technologyUnlocked("PowerDrainPole") and table_size(global.pdpTable) > 0 and global.MF.internalEnergy < global.MF.maxInternalEnergy then
		-- Create updated variable --
		local updated = 0
		-- Itinerate all Power Drain Pole --
		for k, pdp in pairs(global.pdpTable) do
			-- Test if the Power Drain Pole still exist else remove it from the table --
			if pdp.ent == nil or pdp.ent.valid == false then 
				global.pdpTable[k] = nil
			else
				-- Initialise a new Power Drain Pole --
				if pdp.lastUpdate == 0 then
					pdp.lastUpdate = event.tick
				-- Try to update a Power Drain Pole --
				elseif pdp.lastUpdate + 60 <= event.tick then
					-- If there are less than 10 updates --
					if updated < 10 then
						-- Update the Power Drain Pole and add 1 update --
						pdp:update(event)
						updated = updated + 1
					-- If there are 10 or more updates and the Power Drain Pole need to update --
					elseif updated >= 10 and event.tick - pdp.lastUpdate == 61 then
						-- Update the Power Drain Pole and add 1 update --
						pdp:update(event)
						updated = updated + 1
					-- If there are more than 20 updates and the Power Drain Pole realy need to update --
					elseif updated >= 20 and event.tick - pdp.lastUpdate == 62 then
						-- Update the Power Drain Pole and add 1 update --
						pdp:update(event)
						updated = updated + 1
					-- If the Power Drain Pole update is mandatory --
					elseif event.tick - pdp.lastUpdate >= 63 then
						-- Update the Power Drain Pole and add 1 update --
						pdp:update(event)
						updated = updated + 1
					end
				end
			end
		end
	end
end

-- Update All Provider Chest --
function updateProvidersPad()	
	if global.providerPadTable == nil or global.MF.internalEnergy <= 0 then return end
	-- Look for all Chest --
	for k, chest in pairs(global.providerPadTable) do
		-- Remove it from the table if it doesn't longer exist --
		if chest == nil or chest.valid == false then global.providerPadTable[k] = nil return end
		-- Get Inventory --
		local inv = chest.get_inventory(defines.inventory.chest)
		-- Look for all ItemStack --
		for i=1, #inv do
			-- Take ItemStack --
			local itemStack = inv[i]
			if itemStack ~= nil and itemStack.valid == true and itemStack.valid_for_read == true then
				-- Inser itemStack into the Internal Inventory and retreive the amount inserted --
				local amount = addItemStackToII(itemStack)
				-- If amount equal to ItemStack amount --
				if amount == itemStack.count then
					-- Remove the stack --
					inv.remove(itemStack)
				-- If there are items left --
				elseif amount > 0 then
					-- Modify the stack
					local name = itemStack.name
					local count = itemStack.count - amount
					-- Remove the old Stack --
					inv.remove(itemStack)
					-- Put the new Stack --
					inv.insert({name=name, count=count})
				end	
			end
		end			
	end
end

-- Update all Requester Chest --
function updateRequesterPad()
	if global.requesterPadTable == nil or global.MF.internalEnergy <= 0 then return end
	-- Look for all Chest 
	for k, chest in pairs(global.requesterPadTable) do
		-- Remove it from the table if it doesn't longer exist --
		if chest == nil or chest.valid == false then global.requesterPadTable[k] = nil return end
		-- Get the Filter --
		local filter = chest.get_request_slot(1)
		-- Return if there are no filter --
		if filter ~= nil then
			-- get the Chest Inventory --
			local inv = chest.get_inventory(defines.inventory.chest)
			-- For each slots --
			for i = 1, #inv do
				-- Get Items --
				removeItemsFromII(filter.name, inv)
			end
		end
	end	
end

-- Update Ore Silot Pads --
function updateOreSilotPad()
	if global.oreSilotTable == nil then return end
	if global.oreSilotPadTable == nil or table_size(global.oreSilotPadTable) < 1 then return end
	if global.currentSilotPadChestUpdate == nil then global.currentSilotPadChestUpdate = 1 end
	if global.currentSilotPadChestUpdate > table_size(global.oreSilotPadTable) then global.currentSilotPadChestUpdate = 1 end
	-- Look for a Pad --
	local index = 0
	local i = 1
	for k, j in pairs(global.oreSilotPadTable) do
		if global.currentSilotPadChestUpdate == i then
			index = k
			break
		end
		i = i + 1
	end
	global.currentSilotPadChestUpdate = global.currentSilotPadChestUpdate + 1
	if index == 0 then return end
	local chest = global.oreSilotPadTable[index]
	-- Remove it from the table if it doesn't longer exist --
	if chest == nil or chest.valid == false then global.oreSilotPadTable[index] = nil return end
	-- Get the id --
	local id = string.sub(chest.name, -1)
	id = tonumber(id)
	-- Get the associated Ore Silot --
	local oreSilot = global.oreSilotTable[id]
	-- Test if Ore Silot Exist --
	if oreSilot ~= nil and oreSilot.valid == true then
		-- Get Inventories --
		local oreSiloInv = oreSilot.get_inventory(defines.inventory.chest)
		local padInv = chest.get_inventory(defines.inventory.chest)
		-- Test if Inventory exist --
		if oreSiloInv ~= nil and oreSiloInv.valid == true and padInv ~= nil and padInv.valid == true then
		-- Get the Filter set --
		local filter = chest.get_request_slot(1)
		if filter == nil then 
			filter = " " 
		else
			filter = filter.name
		end
			-- Synchronize Inventories --
			synchronizeInventory(oreSiloInv, padInv, filter)
		end
	end
end

-- Update the Fluid Extractor --
function updateFluidExtractor()
	if global.fluidExtractor == nil or global.MF == nil then return end
	if global.fluidExtractor.valid == false then global.fluidExtractor = nil return end
	-- Send Quatron Charge to the Fluid Extractor --
	if global.fluidExtractorCharge <= _mfFEMaxCharge - 100 then
		-- Create the Level variable --
		local level = 0
		-- Look for Quatron Charge in the Internal Inventory --
		for i = 100, 0, -1 do
			local amount = global.MF.II:hasItem("Quatron" .. i)
			if amount > 0 then
			level = i
			-- Remove the Charge from the Internal Inventory --
			global.MF.II:getItem("Quatron" .. i, 1)
			-- Create the Laser --
			global.MF.ent.surface.create_entity{name="GreenBeam", duration=30, position=global.MF.ent.position, target=global.fluidExtractor.position, source=global.MF.ent}
			break
			end
		end
		-- Add the Quatron --
		if level > 0 then
			-- Add the Charge --
			global.fluidExtractorCharge = global.fluidExtractorCharge + 100
			-- Calcule the Purity --
			if global.fluidExtractorPurity == 0 then
				global.fluidExtractorPurity = level
			else
				global.fluidExtractorPurity = ((global.fluidExtractorPurity * 10) + level) / 11
			end
		end
	end
	-- Get the Module ID --
	if global.fluidExtractor.get_inventory == nil then return end
	local moduleID
	-- Look for Modules --
	for name, count in pairs(global.fluidExtractor.get_inventory(defines.inventory.mining_drill_modules).get_contents()) do
		-- Look for the ID --
		if string.match(name, "ModuleID") then
			moduleID = tonumber(string.sub(name, -1))
		end
	end
	if moduleID == nil then return end
	-- Test if there are enought Quatron Charge --
	if global.fluidExtractorCharge <= 0 then return end
	-- Get the Fluid Path --
	local resource = global.fluidExtractor.surface.find_entities_filtered{position=global.fluidExtractor.position, radius=1, type="resource", limit=1}
	resource = resource[1]
	if resource == nil or resource.valid == false then return end
	-- Calcule the amount that can be extracted --
	local amount = math.min(resource.amount, global.fluidExtractorPurity*_mfFEFluidPerExtraction)
	amount = math.min(amount, global.fluidExtractorCharge*10)
	-- Find the Focused Tank and filter --
	if global.tankTable == nil or global.tankTable[moduleID] == nil then return end
	local filter = global.tankTable[moduleID].filter
	local tank = global.tankTable[moduleID].ent
	if filter == nil or tank == nil then return end
	-- Test if the Filter accept this Fluid --
	if resource.name ~= filter then return end
	-- Send the Fluid to the Tank --
	local amountAdded = tank.insert_fluid({name=resource.name, amount=amount})
	-- Test if Fluid was sended --
	if amountAdded > 0 then
		-- Remove Quatron Charges --
		global.fluidExtractorCharge = global.fluidExtractorCharge - math.floor(global.fluidExtractorPurity)
		-- Make a Beam --
		global.fluidExtractor.surface.create_entity{name="BigPurpleBeam", duration=59, position=global.fluidExtractor.position, target=global.MF.ent.position, source=global.fluidExtractor.position}
		-- Remove amount from the FluidPath --
		resource.amount = math.max(resource.amount - amountAdded, 1)
		-- Remove the FluidPath if amount == 0 --
		if resource.amount < 2 then
		resource.destroy()
		end
	end
end














