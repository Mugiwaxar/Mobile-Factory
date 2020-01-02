---- Recreate the Data Network Table --
global.dataNetworkTable = {}

---- Create all Data Network ----
if table_size(global.dataCenterTable) > 0 or global.MF.dataCenter ~= nil then
	-- Print the Message --
	game.print("Try to fix all Data Network")
end
-- Check all Data Center --
for k, obj in pairs(global.dataCenterTable) do
	-- Create the new Data Network --
	obj.dataNetwork = DN:new(obj)
end
-- Check the Data Center MF --
if global.MF.dataCenter ~= nil then
	-- Create the new Data Network --
	global.MF.dataCenter.dataNetwork = DN:new(global.MF.dataCenter)
end
