if global.allowMigration == false then return end
-- Add the Data Network to all Data Assemblers --
for k, ds in pairs(global.dataStorageTable or {}) do
    ds.dataNetwork = ds.MF.dataNetwork
end