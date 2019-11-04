-- SHIELD TECHNOLOGY --
local shT = {}
shT.name = "MFShield"
shT.type = "technology"
shT.icon = "__Mobile_Factory__/graphics/icones/shield.png"
shT.icon_size = 64
shT.unit = {
	count = 800,
	time = 5,
	ingredients={
		{"DimensionalSample", 1}
	}
}
shT.prerequisites =  {"DimensionalOre"}
shT.effects = {{type="nothing", effect_description={"description.MFShield"}}}
data:extend{shT}