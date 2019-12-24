require("utils/functions.lua")
require("utils/cc-extension.lua")
if global.factorySurface ~= nil then
	createTilesSurface(global.factorySurface, -2, -2, 2, 2, "refined-hazard-concrete-left")
end