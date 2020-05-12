-- Re-create the Share Table (was not inited previous version) --
for k, MF in pairs(global.MFTable) do
    MF.varTable.allowedPlayers = MF.varTable.allowedPlayers or {}
end
