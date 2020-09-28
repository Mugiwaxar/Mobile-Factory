if not global.allowMigration then return end
-- Create Signals Tables --
for k, DN in pairs(global.dataNetworkTable or {}) do
	DN.signalsTable = {}
end