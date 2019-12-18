require("utils/cc-extension.lua")
if global.factorySurface ~= nil then
	game.print("Migration 0.0.26 to 0.0.27")
	createTilesSurface(global.factorySurface, -3, -3, 3, 3, "refined-concrete")
	createTilesSurface(global.factorySurface, -1, -1, 1, 1, "refined-hazard-concrete-left")
end