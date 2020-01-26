-- Set the Mobile Factory Internal Inventory to II --
if global.MF.II ~= nil then
	global.MF.II.isII = true
	global.MF.II.CCInventory = {}
end

-- Display the Ore Silo Pad Message --
if table_size(global.oreSilotPadTable or {}) > 0 then
	game.print("##################################################################################################################")
	game.print("Mobile Factory: The Ore Silo Pad Item was removed from the mod, and replaced by Iron Chest if placed on the Map")
	game.print("Now, you have to use the Internal Storage Data Center to access the Ore Silos inside the Control Center")
	game.print("################################################################################################################## ")
	game.print(" ")
	game.print("  ")
end

-- Remove the Ore Silo Pad Table --
	global.oreSilotPadTable = nil