require("utils/functions.lua")

-- Update System: Scan Entities --
function UpSys.scanEnts()
	-- Clear the Entities Table --
	global.entsTable = {}
		
	-- Add Object --
	UpSys.addObj(global.MF)
	if UpSys.addObj(global.MF.dataCenter) == false then global.MF.dataCenter = nil end
	
	-- Add Array --
	UpSys.addTable(global.dataCenterTable)
	UpSys.addTable(global.matterSerializerTable)
	UpSys.addTable(global.matterPrinterTable)
	UpSys.addTable(global.dataStorageTable)
	UpSys.addTable(global.energyCubesTable)
	UpSys.addTable(global.oreCleanerTable)
	UpSys.addTable(global.fluidExtractorTable)
	UpSys.addTable(global.dataNetworkTable)
	UpSys.addTable(global.wirelessDataTransmitterTable)
	UpSys.addTable(global.wirelessDataReceiverTable)
	
	-- Shuffle the MF Entities Table --
	UpSys.shuffle(global.entsTable)
end

-- Update System: Add an Object to the MF Entities Table --
function UpSys.addObj(obj)
	-- Check if the Object is not null --
	if obj ~= nil then
		if obj:valid() ~= true then
			-- Delete the Entity --
			obj:remove()
		else
			table.insert(global.entsTable, obj)
			return true
		end
	end
	return false
end

-- Update System: Add a Table to the MF Entities Table --
function UpSys.addTable(array)
	-- Itinerate the Table --
	for k, obj in pairs(array or {}) do
		-- Add the Object --
		if UpSys.addObj(obj) == false then table.remove(array, k) end
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

















