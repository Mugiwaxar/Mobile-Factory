-- Added the Name field to all Mobile Factories --
for k, MF in pairs(global.MFTable) do
    MF.name = MF.player .. "'s Mobile Factory"
end