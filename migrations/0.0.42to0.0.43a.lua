-- Ore Cleaner Migration --
require("scripts/objects/ore-cleaner.lua")

if global.oreCleaner ~= nil then
	game.print("Update Ore Cleaner")
	global.oreCleaner = OC:new(global.oreCleaner)
	global.oreCleaner.oreTable = global.oreTable
	global.oreTable = nil
	global.oreCleanerCharge = nil
	global.oreCleanerPurity = nil
end
