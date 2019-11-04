require("utils/functions.lua")
if technologyUnlocked("EnergyPowerModule") then
	game.print("0.0.16 to 0.0.17 migration")
	local DistributionModule = game.forces["player"].recipes["DistributionModule"]
	DistributionModule.enabled = true
	local DrainModule = game.forces["player"].recipes["DrainModule"]
	DrainModule.enabled = true
end