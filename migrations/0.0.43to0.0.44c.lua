-- Unlock Shield recipe --
if technologyUnlocked("MFShield") then
	game.forces["player"].recipes["mfShieldEquipment"].enabled = true
	game.print("Unlocked Shield recipe")
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