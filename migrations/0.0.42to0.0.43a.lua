-- Ore Cleaner Migration --
require("scripts/objects/ore-cleaner.lua")

if global.oreCleaner ~= nil then
	game.print("Mobile Factory: Update Ore Cleaner to OOP")
	global.oreCleaner = OC:new(global.oreCleaner)
	global.oreCleaner.oreTable = global.oreTable
	global.oreTable = nil
	global.oreCleanerCharge = nil
	global.oreCleanerPurity = nil
end
