---------------------------------------------------------- DIMENSIONAL PIPE ----------------------------------------------------------

-- Tier 1 --
local tint1 = {1,1,0.4}
local dpE1 = table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
dpE1.name = "DimensionalPipe1"
dpE1.icons = {{icon=dpE1.icon, tint=tint1}}
dpE1.minable = {mining_time = 0.5}
dpE1.flags = {}
dpE1.fluid_box.pipe_connections[2].max_underground_distance = 1
dpE1.fluid_box.pipe_covers.north.layers[1].tint = tint1
dpE1.fluid_box.pipe_covers.north.layers[1].hr_version.tint = tint1
dpE1.fluid_box.pipe_covers.east.layers[1].tint = tint1
dpE1.fluid_box.pipe_covers.east.layers[1].hr_version.tint = tint1
dpE1.fluid_box.pipe_covers.south.layers[1].tint = tint1
dpE1.fluid_box.pipe_covers.south.layers[1].hr_version.tint = tint1
dpE1.fluid_box.pipe_covers.west.layers[1].tint = tint1
dpE1.fluid_box.pipe_covers.west.layers[1].hr_version.tint = tint1
dpE1.pictures.up.tint = tint1
dpE1.pictures.up.hr_version.tint = tint1
dpE1.pictures.down.tint = tint1
dpE1.pictures.down.hr_version.tint = tint1
dpE1.pictures.left.tint = tint1
dpE1.pictures.left.hr_version.tint = tint1
dpE1.pictures.right.tint = tint1
dpE1.pictures.right.hr_version.tint = tint1
data:extend{dpE1}

-- Tier 2 --
local tint2 = {1,0.4,0.4}
local dpE2 = table.deepcopy(dpE1)
dpE2.name = "DimensionalPipe2"
dpE2.icons = {{icon=dpE1.icon, tint=tint2}}
dpE2.fluid_box.pipe_covers.north.layers[1].tint = tint2
dpE2.fluid_box.pipe_covers.north.layers[1].hr_version.tint = tint2
dpE2.fluid_box.pipe_covers.east.layers[1].tint = tint2
dpE2.fluid_box.pipe_covers.east.layers[1].hr_version.tint = tint2
dpE2.fluid_box.pipe_covers.south.layers[1].tint = tint2
dpE2.fluid_box.pipe_covers.south.layers[1].hr_version.tint = tint2
dpE2.fluid_box.pipe_covers.west.layers[1].tint = tint2
dpE2.fluid_box.pipe_covers.west.layers[1].hr_version.tint = tint2
dpE2.pictures.up.tint = tint2
dpE2.pictures.up.hr_version.tint = tint2
dpE2.pictures.down.tint = tint2
dpE2.pictures.down.hr_version.tint = tint2
dpE2.pictures.left.tint = tint2
dpE2.pictures.left.hr_version.tint = tint2
dpE2.pictures.right.tint = tint2
dpE2.pictures.right.hr_version.tint = tint2
data:extend{dpE2}

local dpT2 = {}
dpT2.name = "DimensionalPipe2"
dpT2.type = "technology"
dpT2.icons = dpE2.icons
dpT2.icon_size = data.raw["pipe-to-ground"]["pipe-to-ground"].icon_size
dpT2.unit = {
	count=1200,
	time=3,
	ingredients={
		{"DimensionalSample", 1}
	}
}
dpT2.prerequisites = {"MFDeploy"}
dpT2.effects =
{
	{type="nothing", effect_description={"description.DimensionalPipe2"}},
}
data:extend{dpT2}

-- Tier 3 --
local tint3 = {0.4,0.6,1}
local dpE3 = table.deepcopy(dpE2)
dpE3.name = "DimensionalPipe3"
dpE3.icons = {{icon=dpE1.icon, tint=tint3}}
dpE3.fluid_box.pipe_covers.north.layers[1].tint = tint3
dpE3.fluid_box.pipe_covers.north.layers[1].hr_version.tint = tint3
dpE3.fluid_box.pipe_covers.east.layers[1].tint = tint3
dpE3.fluid_box.pipe_covers.east.layers[1].hr_version.tint = tint3
dpE3.fluid_box.pipe_covers.south.layers[1].tint = tint3
dpE3.fluid_box.pipe_covers.south.layers[1].hr_version.tint = tint3
dpE3.fluid_box.pipe_covers.west.layers[1].tint = tint3
dpE3.fluid_box.pipe_covers.west.layers[1].hr_version.tint = tint3
dpE3.pictures.up.tint = tint3
dpE3.pictures.up.hr_version.tint = tint3
dpE3.pictures.down.tint = tint3
dpE3.pictures.down.hr_version.tint = tint3
dpE3.pictures.left.tint = tint3
dpE3.pictures.left.hr_version.tint = tint3
dpE3.pictures.right.tint = tint3
dpE3.pictures.right.hr_version.tint = tint3
data:extend{dpE3}

local dpT3 = {}
dpT3.name = "DimensionalPipe3"
dpT3.type = "technology"
dpT3.icons = dpE3.icons
dpT3.icon_size = data.raw["pipe-to-ground"]["pipe-to-ground"].icon_size
dpT3.unit = {
	count=10,
	time=60,
	ingredients={
		{"DimensionalSample", 200},
        {"DimensionalCrystal", 1}
	}
}
dpT3.prerequisites = {"DimensionalPipe2"}
dpT3.effects =
{
	{type="nothing", effect_description={"description.DimensionalPipe3"}},
}
data:extend{dpT3}