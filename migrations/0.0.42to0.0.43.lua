-- Power Drain Pole Migration --
require("scripts/objects/power-drain-pole.lua")

if global.pdpTable ~= nil and table_size(global.pdpTable) > 0 then
	for k, pdp in pairs(global.pdpTable) do
		global.pdpTable[k] = PDP:new(pdp)
	end
end

if global.MF ~= nil then
	global.MF.__index = nil
	global.MF.new = nil
	global.MF.rebuild = nil
	global.MF.syncFChest = nil
	global.MF.getLaserRadius = nil
	global.MF.getLaserEnergyDrain = nil
	global.MF.getLaserFluidDrain = nil
	global.MF.getLaserItemDrain = nil
	global.MF.getLaserNumber = nil
	global.MF.updateLasers = nil
end
