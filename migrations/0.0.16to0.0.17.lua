require("utils/functions.lua")
if technologyUnlocked("EnergyPowerModule") then
	local DistributionModule = game.forces["player"].recipes["DistributionModule"]
	DistributionModule.enabled = true
	local DrainModule = game.forces["player"].recipes["DrainModule"]
	DrainModule.enabled = true
end