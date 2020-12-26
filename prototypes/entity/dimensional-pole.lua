---------------------------------------------------------- DIMENSIONAL POLE ----------------------------------------------------------

-- Tier 1 --
local tint1 = {1,1,0.4}
local dpE1 = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
dpE1.name = "DimensionalPole1"
dpE1.icons = {{icon=dpE1.icon, tint=tint1}}
dpE1.minable = {mining_time = 0.5}
dpE1.maximum_wire_distance = 4
dpE1.supply_area_distance = 1
dpE1.flags = {}
dpE1.fast_replaceable_group = nil
dpE1.pictures.layers[1].hr_version.scale = 0.40
dpE1.pictures.layers[1].hr_version.shift = {-0.15,-1}
dpE1.pictures.layers[1].hr_version.tint = tint1
dpE1.pictures.layers[1] = dpE1.pictures.layers[1].hr_version
dpE1.pictures.layers[2].hr_version.scale = 0.40
dpE1.pictures.layers[2].hr_version.shift = {1.35,0.1}
dpE1.pictures.layers[2] = dpE1.pictures.layers[2].hr_version
dpE1.connection_points =
    {
      {
        shadow =
        {
          copper = util.by_pixel(78.5, 3.5),
          red = util.by_pixel(91.0, 4.5),
          green = util.by_pixel(68.5, 4.0)
        },
        wire =
        {
          copper = util.by_pixel(-6.0, -64),
          red = util.by_pixel(4, -63),
          green = util.by_pixel(-16.5, -63)
        }
      },
      {
        shadow =
        {
          copper = util.by_pixel(83, 4),
          red = util.by_pixel(92, 8),
          green = util.by_pixel(77, -3)
        },
        wire =
        {
          copper = util.by_pixel(-5, -64),
          red = util.by_pixel(3, -59),
          green = util.by_pixel(-11, -71)
        }
      },
      {
        shadow =
        {
          copper = util.by_pixel(83, 6),
          red = util.by_pixel(85, 14),
          green = util.by_pixel(85, -1)
        },
        wire =
        {
          copper = util.by_pixel(-4.5, -59),
          red = util.by_pixel(-2.5, -52),
          green = util.by_pixel(-2.5, -68)
        }
      },
      {
        shadow =
        {
          copper = util.by_pixel(82, 0),
          red = util.by_pixel(72, 4),
          green = util.by_pixel(89, -5.0)
        },
        wire =
        {
          copper = util.by_pixel(-5, -67),
          red = util.by_pixel(-15.5, -63),
          green = util.by_pixel(0, -72)
        }
      }
    }
data:extend{dpE1}

-- Tier 2 --
local tint2 = {1,0.4,0.4}
local dpE2 = table.deepcopy(dpE1)
dpE2.name = "DimensionalPole2"
dpE2.icons = {{icon=dpE1.icon, tint=tint2}}
dpE2.maximum_wire_distance = 10
dpE2.supply_area_distance = 5
dpE2.pictures.layers[1].tint = tint2
data:extend{dpE2}

local dpT2 = {}
dpT2.name = "DimensionalPole2"
dpT2.type = "technology"
dpT2.icons = dpE2.icons
dpT2.icon_size = data.raw["electric-pole"]["small-electric-pole"].icon_size
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
	{type="nothing", effect_description={"description.DimensionalPole2"}},
}
data:extend{dpT2}

-- Tier 3 --
local tint3 = {0.4,0.6,1}
local dpE3 = table.deepcopy(dpE2)
dpE3.name = "DimensionalPole3"
dpE3.icons = {{icon=dpE1.icon, tint=tint3}}
dpE3.maximum_wire_distance = 20
dpE3.supply_area_distance = 15
dpE3.pictures.layers[1].tint = tint3
data:extend{dpE3}

local dpT3 = {}
dpT3.name = "DimensionalPole3"
dpT3.type = "technology"
dpT3.icons = dpE2.icons
dpT3.icon_size = data.raw["electric-pole"]["small-electric-pole"].icon_size
dpT3.unit = {
	count=1200,
	time=3,
	ingredients={
		{"DimensionalSample", 1}
	}
}
dpT3.prerequisites = {"DimensionalPole2"}
dpT3.effects =
{
	{type="nothing", effect_description={"description.DimensionalPole3"}},
}
data:extend{dpT3}