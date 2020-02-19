require("utils/functions.lua")
if global.controlSurface ~= nil then
	newTiles = global.controlSurface.find_tiles_filtered{area={{-100,-100},{100,100}}}
	for k, tile in pairs(newTiles) do
		if tile.name ~= "tutorial-grid" and tile.name ~= "refined-hazard-concrete-right" and tile.name ~= "out-of-map" then
			ents = global.controlSurface.find_entities_filtered{area={{tile.position.x,tile.position.y},{tile.position.x+1,tile.position.y+1}}}
			if table_size(ents) == 0 then
				global.controlSurface.set_tiles({{name="out-of-map", position=tile.position}})
			end
		end
	end
end

if technologyUnlocked("ControlCenter") then
	if global.controlSurface.find_entity("DimensionalSubstation", {-2,10}) == nil then
		createEntity(global.controlSurface, -2, 10, "DimensionalSubstation", "player").minable = nil
	end
	if global.controlSurface.find_entity("DimensionalAccumulator", {2,12}) == nil then
		createEntity(global.controlSurface, 2, 12, "DimensionalAccumulator", "player").minable = nil
	end
	createTilesSurface(global.controlSurface, -10, -10, 10, 10, "tutorial-grid")
	createTilesSurface(global.controlSurface, -3, 5, 2, 8, "refined-hazard-concrete-right")
	createTilesSurface(global.controlSurface, -4, 10, 3, 13, "tutorial-grid")
end
if technologyUnlocked("UpgradeModules") then
		createTilesSurface(global.controlSurface, -6, -20, 6, -10, "tutorial-grid")
	if global.controlSurface.find_entity("Equalizer", {1,-16}) == nil then
		createEntity(global.controlSurface, 1, -16, "Equalizer", "player").minable = nil
	end
end
if technologyUnlocked("StorageTankMK1_1") then
	local ModuleID1 = game.forces["player"].recipes["ModuleID1"]
	ModuleID1.enabled = true
	global.tankTable[1] = {name="StorageTank1MK1", position={-17,-9}}
	createLeftPassage1(global.controlSurface)
end
if technologyUnlocked("StorageTankMK1_2") then
	local ModuleID2 = game.forces["player"].recipes["ModuleID2"]
	ModuleID2.enabled = true
	global.tankTable[2] = {name="StorageTank2MK1", position={-35,-9}}
	createLeftPassage2(global.controlSurface)
end
if technologyUnlocked("StorageTankMK1_3") then
	local ModuleID3 = game.forces["player"].recipes["ModuleID3"]
	ModuleID3.enabled = true
	global.tankTable[3] = {name="StorageTank3MK1", position={-53,-9}}
	createLeftPassage3(global.controlSurface)
end