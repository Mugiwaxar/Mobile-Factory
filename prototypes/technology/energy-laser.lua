---------------- Lasers Technology -------------------


-- Laser Energy Drain tehcnology --
local ldT = {}
ldT.name = "EnergyDrain1"
ldT.type = "technology"
ldT.icon = "__Mobile_Factory_Graphics__/graphics/icones/TecEnergyDrain1.png"
ldT.icon_size = 32
ldT.unit = {
	count=600,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
ldT.prerequisites = {"DimensionalOre"}
ldT.effects = {{type="nothing", effect_description={"description.EnergyDrain1"}}}
data:extend{ldT}

-- Energy Distribution tehcnology --
local etT = {}
etT.name = "EnergyDistribution1"
etT.type = "technology"
etT.icon = "__Mobile_Factory_Graphics__/graphics/icones/TecEnergyDistribution1.png"
etT.icon_size = 32
etT.unit = {
	count=600,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
etT.prerequisites = {"ElectricityCompression"}
etT.effects = {{type="nothing", effect_description={"description.EnergyDistribution1"}}}
data:extend{etT}