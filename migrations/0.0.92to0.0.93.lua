if global.allowMigration == false then return end
-- Create Signals Tables --
for k, DN in pairs(global.dataNetworkTable or {}) do
	DN.signalsTable = {}
end