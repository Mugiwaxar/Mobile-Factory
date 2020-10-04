if not global.allowMigration then return end
-- Place the Internal Energy/Quatron Cube inside the Control Center --
for k, MF in pairs(global.MFTable or {}) do
    if MF.ccS == nil then
        createControlRoom(MF)
    else
        local iec = createEntity(MF.ccS, 7, 6, "InternalEnergyCube", getMFPlayer(MF.playerIndex).ent.force)
        iec.last_user = MF.player
        MF.internalEnergyObj = IEC:new(MF)
        MF.internalEnergyObj:setEnt(iec)
        MF.internalEnergyObj:addEnergy(MF.internalEnergy or 0)
        MF.internalEnergy = nil
        -- Place the Internal Quatron Cube inside the Control Center --
        local iqc = createEntity(MF.ccS, -7, 6, "InternalQuatronCube", getMFPlayer(MF.playerIndex).ent.force)
        iqc.last_user = MF.player
        MF.internalQuatronObj = IQC:new(MF)
        MF.internalQuatronObj:setEnt(iqc)
    end
end

-- Remove the Dimensional Accumulator Table --
global.accTable = nil

-- Remove the Power Drain Pole Table --
global.pdpTable = nil

-- Unlock Energy/Quatron Cubes if needed --
unlockRecipeForAll("EnergyCubeMK1", "DimensionalElectronic")
unlockRecipeForAll("InternalEnergyCube", "DimensionalElectronic")
unlockRecipeForAll("InternalQuatronCube", "DimensionalElectronic")