require("utils/functions.lua")
require("utils/cc-extension.lua")
if global.factorySurface ~= nil then
	game.print("Migration 0.0.24 to 0.0.25")
	createTilesSurface(global.factorySurface, -2, -2, 2, 2, "refined-hazard-concrete-left")
end