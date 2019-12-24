require("utils/functions.lua")
if technologyUnlocked("StorageTankMK1-1") then
	game.print("Mobile Factory: Storage Tank FIX")
	local ModuleID1 = game.forces["player"].recipes["ModuleID1"]
	ModuleID1.enabled = true
	if game.forces["player"].recipes["Tank1Module"] ~= nil then
		game.forces["player"].recipes["Tank1Module"] = nil
	end
	global.tankTable = nil
	global.tankTable = {}
	global.tankTable[1] = {name="StorageTankMK1", position={-17,-9}}
end

game.forces["player"].technologies["DimensionalOre"].researched = true