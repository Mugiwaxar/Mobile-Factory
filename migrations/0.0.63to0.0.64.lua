-- Unlock Machine Frame 2 recipes --
if technologyUnlocked("DimensionalOreSmelting") then
	game.forces["player"].recipes["MachineFrame2"].enabled = true
end

-- Unlock Machine Frame 3 recipes --
if technologyUnlocked("DimensionalCrystal") then
	game.forces["player"].recipes["MachineFrame3"].enabled = true
	game.forces["player"].recipes["CrystalizedCircuit"].enabled = true
end