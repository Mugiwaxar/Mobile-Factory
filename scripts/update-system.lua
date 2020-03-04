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

  -- Add Array --
  UpSys.addTable(global.MFTable)
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
  UpSys.addTable(global.pdpTable)

  -- Save the last scan tick --
  global.upSysLastScan = game.tick
end

-- Update System: Add an Object to the MF Entities Table --
function UpSys.addObject(obj)
  if global.upsysTickTable == nil then global.upsysTickTable = {} end
  if global.entsTable == nil then global.entsTable = {} end
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

-- Index all Erya Structures --
function Erya.indexEryaStructures()
  global.eryaIndexedTable = {}
  local i = 0
  for k, es in pairs(global.eryaTable) do
    i = i + 1
    if valid(es) then
      global.eryaIndexedTable[i] = es
    else
      global.eryaTable[k] = nil
    end
  end
end

function Erya.updateEryaStructures(event)
  for i=0, 10 do
    if global.updateEryaIndex > table_size(global.eryaIndexedTable) then
      global.updateEryaIndex = 1
      Erya.indexEryaStructures()
      return
    end
    local es = global.eryaIndexedTable[global.updateEryaIndex]
    if valid(es) == true and es.lastUpdate + es.updateTick < event.tick then
      es:update()
    end
    global.updateEryaIndex = global.updateEryaIndex + 1
  end
end

-- Fill/Empty tank --
function updateLogisticFluidPoles()
	for k, entity in pairs(global.lfpTable) do
    if entity == nil or entity.valid == false or entity.last_user == nil then
      global.lfpTable[k] = nil
      goto continue
    end
    local MF = getMF(entity.last_user.name)
    if MF == nil then
      global.lfpTable[k] = nil
      goto continue
    end
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
			for k2, pTank in pairs(entities) do
				if pTank == nil or pTank.valid ~= true or Util.canUse(MF.player, pTank) == false then goto continue2 end
        if i > lfpLaser then break end
        if pTank.type ~= "storage-tank" then goto continue2 end
        if pTank.fluidbox.get_capacity(1) < 1000 then goto continue2 end
        local ccTank
        local filter
        if MF.varTable.tanks ~= nil and MF.varTable.tanks[tankMD] ~= nil then
          filter = MF.varTable.tanks[tankMD].filter
          ccTank = MF.varTable.tanks[tankMD].ent
        end
        if filter == nil or ccTank == nil then goto continue2 end

        if methodMD == "DistributionModule" then
          local name
          local amount
          for k3, i in pairs(ccTank.get_fluid_contents()) do
            name = k3
            amount = i
          end
          if name ~= nil and MF.internalEnergy > _lfpFluidConsomption * math.min(amount, lfpDrain) then
            local amountRm = pTank.insert_fluid({name=name, amount=math.min(amount, lfpDrain)})
            ccTank.remove_fluid{name=name, amount = amountRm}
            if amountRm > 0 then
              entity.surface.create_entity{name="PurpleBeam", duration=60, position=entity.position, target=pTank.position, source={entity.position.x, entity.position.y-4.5}}
              MF.internalEnergy = MF.internalEnergy - (_lfpFluidConsomption*amountRm)
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
          if name ~= nil and name == filter and MF.internalEnergy > _lfpFluidConsomption * math.min(amount, lfpDrain) then
            local amountRm = ccTank.insert_fluid({name=name, amount=math.min(amount, lfpDrain)})
            pTank.remove_fluid{name=name, amount=amountRm}
            if amountRm > 0 then
              entity.surface.create_entity{name="PurpleBeam", duration=60, position=entity.position, target=pTank.position, source={entity.position.x, entity.position.y-4.5}}
              MF.internalEnergy = MF.internalEnergy - (_lfpFluidConsomption*amountRm)
              i = i + 1
            end
          end
        end
        ::continue2::
			end
    end
    ::continue::
	end
end