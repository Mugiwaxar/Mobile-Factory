-- Laser Fluid Drain tehcnology --
local lfT = {}
lfT.name = "FluidDrain1"
lfT.type = "technology"
lfT.icon = "__Mobile_Factory_Graphics__/graphics/icons/TecFluidDrain1.png"
lfT.icon_size = 32
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