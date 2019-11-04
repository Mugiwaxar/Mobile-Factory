-- Power Drain Pole Migration --
require("scripts/power-drain-pole.lua")

if table_size(global.pdpTable) > 0 then
	game.print("Updating all Power Drain Poles")
	for k, pdp in pairs(global.pdpTable) do
		global.pdpTable[k] = PDP:new(pdp)
	end
end