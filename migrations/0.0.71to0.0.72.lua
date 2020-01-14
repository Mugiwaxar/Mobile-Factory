-- Ore Silo to Deep Storage Update --
if table_size(global.oreSilotTable or {}) > 0 then
	game.print("###############################################")
	game.print("Mobile Factory: Because of performances issue, the Ore Silo was removed and its content was transferred inside a big chest.")
	game.print("You can now use the Deep Storage that is a lot better (Unlimited amount of one item, placeable)")
	game.print("############################################### ")
	game.print(" ")
	game.print("  ")
	game.print("   ")
	-- Unlock the Deep Storage Technology --
	createDeepStorageArea()
	game.forces["player"].recipes["DeepStorage"].enabled = true
	-- Remove the Ore Silo table --
	global.oreSilotTable = {}
end

