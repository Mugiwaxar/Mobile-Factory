if global.allowMigration == false then return end
-- Add Cell to Quatron recipe --
unlockRecipeForAll("CellToLiquidQuatron1", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron2", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron3", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron4", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron5", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron6", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron7", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron8", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron9", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron10", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron11", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron12", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron13", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron14", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron15", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron16", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron17", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron18", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron19", "Quatron")
unlockRecipeForAll("CellToLiquidQuatron20", "Quatron")

-- Create the DeepTank and the DeepStorage Table inside the MF Object --
for k, MF in pairs(global.MFTable or {}) do
    MF.DTKTable = {}
    MF.DSRTable = {}
end

-- Move the Deep Tanks inside the MF Object --
for k, dtk in pairs(global.deepTankTable or {}) do
    if dtk.ent ~= nil and dtk.ent.valid == true then
        dtk.MF.DTKTable[dtk.ent.unit_number] = dtk
    end
end

-- Move the Deep Storage inside the MF Object --
for k, dsr in pairs(global.deepStorageTable or {}) do
    if dsr.ent ~= nil and dsr.ent.valid == true then
        dsr.MF.DSRTable[dsr.ent.unit_number] = dsr
    end
end

-- Added the MF Object and the PlayerIndex to all Data Network --
for k, DN in pairs(global.dataNetworkTable or {}) do
    if DN.dataCenter ~= nil and DN.dataCenter.MF ~= nil then
        DN.MF = DN.dataCenter.MF
        DN.playerIndex = DN.MF.playerIndex
    end
end

-- Remove the DataCenterMF from the Data Center Table --
for k, DC in pairs(global.dataCenterTable or {}) do
    if DC.ent ~= nil and DC.ent.valid == true and DC.ent.name == "DataCenterMF" then
        global.dataCenterTable[k] = nil
    end
end

-- Create the Objects Table --
Util.createTableList()

-- Create all Table --
for k, obj in pairs(global.objTable) do
    if obj.tableName ~= nil and global[obj.tableName] == nil then
        global[obj.tableName] = {}
    end
end

-- Add new Values --
if global.upSysLastScan == nil then global.upSysLastScan = 0 end
if global.entsUpPerTick == nil then global.entsUpPerTick = _mfBaseUpdatePerTick end
if global.entsTable == nil then global.entsTable = {} end
if global.upsysTickTable == nil then global.upsysTickTable = {} end
if global.updateEryaIndex == nil then global.updateEryaIndex = 1 end
if global.eryaIndexedTable == nil then global.eryaIndexedTable = {} end
if global.floorIsLavaActivated == nil then global.floorIsLavaActivated = false end
if global.dataNetworkID == nil then global.dataNetworkID = 0 end
if global.constructionTable == nil then global.constructionTable = {} end
if global.repairTable == nil then global.repairTable = {} end