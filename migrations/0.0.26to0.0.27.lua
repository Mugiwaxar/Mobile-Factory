require("utils/cc-extension.lua")
if global.factorySurface ~= nil then
	createTilesSurface(global.factorySurface, -3, -3, 3, 3, "refined-concrete")
	createTilesSurface(global.factorySurface, -1, -1, 1, 1, "refined-hazard-concrete-left")
end