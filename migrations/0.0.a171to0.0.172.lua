if not global.allowMigration then return end
-- Fix all Energy Cubes Energy --
for k, cube in pairs(global.energyCubesTable or {}) do
    if cube.ent ~= nil and cube.ent.valid == true and cube.ent.energy > cube.ent.electric_buffer_size then
        cube.ent.energy = cube.ent.electric_buffer_size
    end
end

-- Fix all Energy Lasers Energy --
for k, laser in pairs(global.energyLaserTable or {}) do
    if laser.ent ~= nil and laser.ent.valid == true and laser.ent.energy > laser.ent.electric_buffer_size then
        laser.ent.energy = laser.ent.electric_buffer_size
    end
end

-- Unlock Internal Energy/Quatron Cube Recipe --
unlockRecipeForAll("InternalEnergyCube", "ControlCenter")
unlockRecipeForAll("InternalQuatronCube", "ControlCenter")

-- Modify all MF Object --
for k, MF in pairs(global.MFTable or {}) do
    -- Create the new Data Network --
    MF.dataNetwork = DN:new(MF)
    MF.dataNetwork.MF = MF
    MF.dataNetwork.invObj = MF.II
    MF.dataCenter = nil
    MF.II.MF = MF
    MF.II.dataNetwork = MF.dataNetwork
    -- Create the new Network Controller --
    if technologyUnlocked("MatterSerialization", getForce(MF.player)) then createNetworkControllerArea(MF) end
    -- Move DTKTable and DSRTable to the Data Network --
    MF.dataNetwork.DTKTable = MF.DTKTable
    MF.dataNetwork.DSRTable = MF.DSRTable
    MF.DTKTable = nil
    MF.DSRTable = nil
end

-- Add the Data Network to all Fluid Interactors --
for k, fi in pairs(global.fluidInteractorTable or {}) do
    fi.dataNetwork = fi.MF.dataNetwork
end

-- Add the Data Network to all Matter Interactors --
for k, mi in pairs(global.matterInteractorTable or {}) do
    mi.dataNetwork = mi.MF.dataNetwork
end

-- Add the Data Network to all Network Explorers --
for k, ne in pairs(global.networkExplorerTable or {}) do
    ne.dataNetwork = ne.MF.dataNetwork
end

-- Add the Data Network to all Data Assemblers --
for k, da in pairs(global.dataAssemblerTable or {}) do
    da.dataNetwork = da.MF.dataNetwork
end

-- Send all Data Centers Items to the Internal Inventory --
for k, dc in pairs(global.dataCenterTable or {}) do
    local inv = dc.MF.II.inventory
    for name, count in pairs(dc.invObj.inventory or {}) do
        if inv[name] ~= nil then
            inv[name] = inv[name] + count
        else
            inv[name] = count
        end
    end
end

-- Remove the old Tables --
global.dataCenterTable = nil
global.wirelessDataReceiverTable = nil
global.wirelessDataTransmitterTable = nil
global.dataNetworkTable = nil
global.dataNetworkIDGreenTable = nil
global.dataNetworkIDRedTable = nil