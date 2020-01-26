-- Add the Ore Cleaner to a table --
global.oreCleanerTable = {}
if global.oreCleaner ~= nil and global.oreCleaner.ent ~= nil and global.oreCleaner.ent.valid == true then
	game.print("Mobile Factory: The Ore Cleaner can now be placed multiple time")
	global.oreCleanerTable[global.oreCleaner.ent.unit_number] = OC:new(global.oreCleaner.ent)
	global.oreCleanerTable[global.oreCleaner.ent.unit_number].purity = global.oreCleaner.purity
	global.oreCleanerTable[global.oreCleaner.ent.unit_number].charge = global.oreCleaner.charge
	global.oreCleanerTable[global.oreCleaner.ent.unit_number].totalCharge = global.oreCleaner.totalCharge
	global.oreCleanerTable[global.oreCleaner.ent.unit_number].oreTable = global.oreCleaner.oreTable
	global.oreCleanerTable[global.oreCleaner.ent.unit_number].inventory = global.oreCleaner.inventory
	global.oreCleanerTable[global.oreCleaner.ent.unit_number].animID = global.oreCleaner.animID
	global.oreCleanerTable[global.oreCleaner.ent.unit_number].animTick = global.oreCleaner.animTick
	global.oreCleanerTable[global.oreCleaner.ent.unit_number].lastUpdate = global.oreCleaner.lastUpdate
	global.oreCleanerTable[global.oreCleaner.ent.unit_number].lastExtraction = global.oreCleaner.lastExtraction
	global.oreCleaner = nil
end