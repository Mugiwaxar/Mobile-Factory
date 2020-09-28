if not global.allowMigration then return end
-- Remove old MF Variables and create the Share Table --
for k, MF in pairs(global.MFTable or {}) do
    MF.varTable.shareStructures = nil
    MF.varTable.useSharedStructures = nil
    MF.varTable.allowToModify = nil
    MF.varTable.allowedPlayers = {}
end

-- Change entsTable index to Entity Unit Number --
local tempTable = {}
for k, obj in pairs(global.entsTable or {}) do
    if obj.ent ~= nil and obj.ent.valid == true then
        tempTable[obj.ent.unit_number] = obj
    end
end
global.entsTable = {}
for k, obj in pairs(tempTable) do
    global.entsTable[k] = obj
end
tempTable = nil