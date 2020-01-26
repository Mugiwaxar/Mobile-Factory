-- Unlock Matter Serialization recipes --
if technologyUnlocked("MatterSerialization") then
	game.forces["player"].recipes["DataCenter"].enabled = true
	game.forces["player"].recipes["DataCenterMF"].enabled = true
	game.forces["player"].recipes["DataStorage"].enabled = true
	game.forces["player"].recipes["MatterSerializer"].enabled = true
	game.forces["player"].recipes["MatterPrinter"].enabled = true
	game.forces["player"].recipes["EnergyCubeMK1"].enabled = true
end