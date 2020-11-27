-- Added the Name field to all Mobile Factories --
for _, MF in pairs(global.MFTable or {}) do
    MF.name = MF.player .. "'s Mobile Factory"
end