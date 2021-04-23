if global.allowMigration == false then return end
-- Fix all Resources Collectors --
for _, rcl in pairs(global.ResourceCollectorTable or {}) do
    rcl.resourcesTable = {}
end
-- Rebuild the Resources Collectors Table --
local tmpTable = {}
for _, rcl in pairs(global.ResourceCollectorTable or {}) do
    table.insert(tmpTable, rcl)
end
global.ResourceCollectorTable = tmpTable