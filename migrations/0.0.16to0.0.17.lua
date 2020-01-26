require("utils/functions.lua")
if technologyUnlocked("EnergyPowerModule") then
	game.print("Mobile Factory: Unlocked all Modules")
	local DistributionModule = game.forces["player"].recipes["DistributionModule"]
	DistributionModule.enabled = true
	local DrainModule = game.forces["player"].recipes["DrainModule"]
	DrainModule.enabled = true
end