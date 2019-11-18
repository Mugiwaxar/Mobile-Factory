-- Unlock Shield recipe --
if technologyUnlocked("MFShield") then
	game.forces["player"].recipes["mfShieldEquipment"].enabled = true
	game.print("Unlocked Shield recipe")
end
