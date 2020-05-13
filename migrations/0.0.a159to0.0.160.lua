-- Add the Internal Energy Object to all Mobile Factory --
for k, MF in pairs(global.MFTable) do
    MF.internalEnergyObj = IEC:new(MF)
    -- Place the Internal Energy Cube inside the Control Center --
    createEntity(MF.ccS, 7, 6, "InternalEnergyCube", getMFPlayer(MF.playerIndex).ent.force)
end