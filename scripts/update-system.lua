require("utils/functions.lua")

-- Add an Object to the Update System --
function UpSys.addObj(obj)
  if valid(obj) == false then return end
  -- Add the Object --
  UpSys.addObject(obj)
end

-- Remove an Object from the Update System --
function UpSys.removeObj(obj)
  -- Remove the Object --
  for k, object in pairs(global.entsTable) do
    if object == obj then
      global.entsTable[k] = nil
    end
  end
end

-- Update System: Scan Entities --
function UpSys.scanObjs()
  -- Clear the Entities Table --
  global.entsTable = {}
  -- Clear the Tick Table --
  for k, j in pairs(global.upsysTickTable) do
    if k < game.tick then
      global.upsysTickTable[k] = nil
    end
  end
		
  -- Add Object --
  UpSys.addObject(global.MF)
  if UpSys.addObject(global.MF.dataCenter) == false then global.MF.dataCenter = nil end
	
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
  UpSys.addTable(global.miningJetTable)
  UpSys.addTable(global.jetFlagTable)
  UpSys.addTable(global.constructionJetTable)
  UpSys.addTable(global.repairJetTable)
  UpSys.addTable(global.combatJetTable)
  UpSys.addTable(global.deepStorageTable)

  -- Save the last scan tick --
  global.upSysLastScan = game.tick
end

-- Update System: Add an Object to the MF Entities Table --
function UpSys.addObject(obj)
  -- Check the size of the UpSys Table --
  if table_size(global.upsysTickTable) > 300 then
    game.print("Mobile Factory - Upsys Error: table size too hight, unable to update Entities")
	global.upsysTickTable = {}
    return
  end
  -- Check if the Object is not null --
  if obj ~= nil and getmetatable(obj) ~= nil then
    if obj:valid() ~= true then
      -- Delete the Entity --
      obj:remove()
    else
      -- Add the Object to the Entity Table --
      table.insert(global.entsTable, obj)
      -- Check if the Object have to be updated --
	  if obj.updateTick > 0 then
        -- Set Update --
        local nextUpdate = game.tick + (game.tick - obj.lastUpdate)
        if obj.lastUpdate == 0 or game.tick - obj.lastUpdate > obj.updateTick*2 then
          -- Look for the best Tick to update --
          local bestTick = 1
          for i = 1, 60 do
            if table_size(global.upsysTickTable[game.tick+i] or {}) < table_size(global.upsysTickTable[game.tick+bestTick] or {}) then
              bestTick = i
              if global.upsysTickTable[game.tick+i] == nil then
                break
              end
            end
          end
          nextUpdate = game.tick + bestTick 
          if global.upsysTickTable[nextUpdate] == nil then global.upsysTickTable[nextUpdate] = {} end
          table.insert(global.upsysTickTable[nextUpdate], obj)
          obj.lastUpdate = 1
        end
      end
      return true
    end
  end
return false
end

-- Update System: Add a Table to the MF Entities Table --
function UpSys.addTable(array)
  -- Create the Table if needed --
  if array == nil then array = {} end
  -- Itinerate the Table --
    for k, obj in pairs(array) do
      -- Add the Object --
      if UpSys.addObject(obj) == false then
      array[k] = nil
    end
  end
end

-- Update System: Update Entities --
function UpSys.update(event)
  -- Check all Object --
  if game.tick - global.upSysLastScan > _mfScanTicks * 10 then
    UpSys.scanObjs()
  end
  -- if true then return end
  -- Check if there are something to update --
  if global.upsysTickTable[game.tick] == nil then return end
  -- Create the updated Index --
  local updated = 1
  -- Update Object --
  for k, obj in pairs(global.upsysTickTable[game.tick]) do
    -- If more objects can be updated --
	if valid(obj) == true then
      if updated <= global.entsUpPerTick then
        obj:update(event)
        updated = updated + 1
        if global.upsysTickTable[game.tick + obj.updateTick] == nil then
          global.upsysTickTable[game.tick + obj.updateTick] = {}
        end
        table.insert(global.upsysTickTable[game.tick + obj.updateTick], obj)
      -- Else if there are no more update available --
      else
        if global.upsysTickTable[game.tick+1] == nil then
          global.upsysTickTable[game.tick+1] = {}
        end
        table.insert(global.upsysTickTable[game.tick+1], obj)
      end
    end
  end
  -- Delete the Table --
  global.upsysTickTable[game.tick] = nil
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

















