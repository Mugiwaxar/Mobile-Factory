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
  UpSys.addTable(global.matterInteractorTable)
  UpSys.addTable(global.fluidInteractorTable)
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
  UpSys.addTable(global.deepTankTable)
  UpSys.addTable(global.networkExplorerTable)
  UpSys.addTable(global.dataAssemblerTable)

  -- Add all Internal Energy Cubes and Internal Quatron Cubes --
  for k, MF in pairs(global.MFTable) do
    UpSys.addObject(MF.internalEnergyObj)
    UpSys.addObject(MF.internalQuatronObj)
  end

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
      if obj.ent ~= nil and obj.ent.valid == true then
        global.entsTable[obj.ent.unit_number] = obj
      else
        table.insert(global.entsTable, obj)
      end
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