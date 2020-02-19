-- Ore Silo to Deep Storage Update --
if table_size(global.oreSilotTable or {}) > 0 then
	-- Unlock the Deep Storage Technology --
	-- createDeepStorageArea()
	game.forces["player"].recipes["DeepStorage"].enabled = true
	-- Remove the Ore Silo table --
	global.oreSilotTable = {}
end

