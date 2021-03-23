-- Laser Fluid Drain tehcnology --
local lfT = {}
lfT.name = "FluidDrain1"
lfT.type = "technology"
lfT.icon = "__Mobile_Factory_Graphics__/graphics/icons/FluidLaserE.png"
lfT.icon_size = 256
lfT.unit = {
	count=800,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
lfT.prerequisites = {"DeepTank"}
lfT.effects = {{type="nothing", effect_description={"description.FluidDrain1"}}}
data:extend{lfT}