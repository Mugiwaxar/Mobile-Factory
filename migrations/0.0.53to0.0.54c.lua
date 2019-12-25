require("scripts/objects/fluid-extractor.lua")
game.print("#######################################################################################")
game.print("Mobile Factory: The Fluid Extractor can now be placed multiple time")
game.print("Ore Cleaner and Fluid Extractor informations are now visible througt the Tooltip GUI")
game.print("####################################################################################### ")
game.print(" ")
game.print("  ")

-- Remove the RedCross Fluid --
for k, tank in pairs(global.tankTable or {}) do
	if tank.filter == "RedCross" then tank.filter = nil end
end

-- Create the Fluid Extractor Object and add it to a table --
global.fluidExtractorTable = {}
if global.fluidExtractor ~= nil then
	local fluidExtractor = FE:new(global.fluidExtractor)
	fluidExtractor.purity = global.fluidExtractorPurity
	fluidExtractor.charge = global.fluidExtractorCharge
	global.fluidExtractorTable[global.fluidExtractor.unit_number] = fluidExtractor
end

global.fluidExtractorCharge = nil
global.fluidExtractorPurity = nil
global.fluidExtractor = nil