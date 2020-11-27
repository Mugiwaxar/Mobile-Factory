-- Added the Name field to all Mobile Factories --
for _, MF in pairs(global.MFTable or {}) do
    MF.name = MF.player .. "'s Mobile Factory"
end

-- Add the Data Network to all Ore Cleaners --
for _, OC in pairs(global.oreCleanerTable) do
    OC.dataNetwork = OC.MF.dataNetwork
end

-- Add the Data Network to all Fluid Extractor --
for _, FE in pairs(global.fluidExtractorTable) do
    FE.dataNetwork = FE.MF.dataNetwork
end