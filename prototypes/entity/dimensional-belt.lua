---------------------------------------------------------- DIMENSIONAL BELT ----------------------------------------------------------

-- Tier 1 --
local dbE1 = {}
dbE1.type = "linked-belt"
dbE1.name = "DimensionalBelt1"
dbE1.icon = data.raw["underground-belt"]["underground-belt"].icon
dbE1.icon_size = data.raw["underground-belt"]["underground-belt"].icon_size
dbE1.minable = {mining_time = 0.5}
dbE1.collision_box = data.raw["underground-belt"]["underground-belt"].collision_box
dbE1.selection_box = data.raw["underground-belt"]["underground-belt"].selection_box
dbE1.belt_animation_set = data.raw["underground-belt"]["underground-belt"].belt_animation_set
dbE1.speed = data.raw["underground-belt"]["underground-belt"].speed
dbE1.structure = data.raw["underground-belt"]["underground-belt"].structure
dbE1.animation_speed_coefficient = data.raw["underground-belt"]["underground-belt"].animation_speed_coefficient
dbE1.allow_clone_connection = true
dbE1.allow_blueprint_connection = true
dbE1.allow_side_loading = false
data:extend{dbE1}

-- Tier 2 --
local dbE2 = table.deepcopy(dbE1)
dbE2.name = "DimensionalBelt2"
dbE2.icon = data.raw["underground-belt"]["fast-underground-belt"].icon
dbE2.icon_size = data.raw["underground-belt"]["fast-underground-belt"].icon_size
dbE2.belt_animation_set = data.raw["underground-belt"]["fast-underground-belt"].belt_animation_set
dbE2.speed = data.raw["underground-belt"]["fast-underground-belt"].speed
dbE2.structure = data.raw["underground-belt"]["fast-underground-belt"].structure
dbE2.animation_speed_coefficient = data.raw["underground-belt"]["fast-underground-belt"].animation_speed_coefficient
data:extend{dbE2}

local dbT2 = {}
dbT2.name = "DimensionalBelt2"
dbT2.type = "technology"
dbT2.icon = data.raw["underground-belt"]["fast-underground-belt"].icon
dbT2.icon_size = data.raw["underground-belt"]["fast-underground-belt"].icon_size
dbT2.unit = {
	count=1200,
	time=3,
	ingredients={
		{"DimensionalSample", 1}
	}
}
dbT2.prerequisites = {"MFDeploy"}
dbT2.effects =
{
	{type="nothing", effect_description={"description.DimensionalBelt2"}},
}
data:extend{dbT2}

-- Tier 3 --
local dbE3 = table.deepcopy(dbE2)
dbE3.name = "DimensionalBelt3"
dbE3.icon = data.raw["underground-belt"]["express-underground-belt"].icon
dbE3.icon_size = data.raw["underground-belt"]["express-underground-belt"].icon_size
dbE3.belt_animation_set = data.raw["underground-belt"]["express-underground-belt"].belt_animation_set
dbE3.speed = data.raw["underground-belt"]["express-underground-belt"].speed
dbE3.structure = data.raw["underground-belt"]["express-underground-belt"].structure
dbE3.animation_speed_coefficient = data.raw["underground-belt"]["express-underground-belt"].animation_speed_coefficient
data:extend{dbE3}

local dbT3 = {}
dbT3.name = "DimensionalBelt3"
dbT3.type = "technology"
dbT3.icon = data.raw["underground-belt"]["express-underground-belt"].icon
dbT3.icon_size = data.raw["underground-belt"]["express-underground-belt"].icon_size
dbT3.unit = {
	count=10,
	time=60,
	ingredients={
		{"DimensionalSample", 200},
        {"DimensionalCrystal", 1}
	}
}
dbT3.prerequisites = {"DimensionalBelt2"}
dbT3.effects =
{
	{type="nothing", effect_description={"description.DimensionalBelt3"}},
}
data:extend{dbT3}