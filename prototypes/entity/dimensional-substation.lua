-- Dimensional Substation --

-- Entity --
local dS = {}
dS.type = "electric-pole"
dS.name = "DimensionalSubstation"
dS.icon = "__Mobile_Factory_Graphics__/graphics/icons/DimensionalSubstation.png"
dS.icon_size = 32
dS.flags = {"placeable-neutral", "player-creation"}
dS.minable = {mining_time = 1, result = "DimensionalSubstation"}
dS.max_health = 200
dS.corpse = "substation-remnants"
dS.track_coverage_during_build_by_moving = true
dS.resistances = {{type="fire",percent=90}}
dS.collision_box = {{-2, -0}, {2, 4}}
dS.selection_box = {{-2, -0}, {2, 4}}
dS.maximum_wire_distance = 64
dS.supply_area_distance = 64
dS.pictures =
    {
      layers =
      {

        {
            filename = "__Mobile_Factory_Graphics__/graphics/entity/DimensionalSubstation.png",
            priority = "high",
            width = 138,
            height = 270,
            direction_count = 4,
            shift = util.by_pixel(0, 0),
            scale = 1
        },
        {
            filename = "__base__/graphics/entity/substation/hr-substation-shadow.png",
            priority = "high",
            width = 370,
            height = 104,
            direction_count = 4,
            shift = util.by_pixel(62*2.3, 52),
            draw_as_shadow = true,
            scale = 1
        }
      }
    }
dS.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
dS.working_sound =
    {
      sound = { filename = "__base__/sound/substation.ogg" },
      apparent_volume = 1.5,
      audible_distance_modifier = 0.5,
      probability = 1 / (3 * 60) -- average pause between the sound is 3 seconds
    }
dS.connection_points =
    {
      {
        shadow =
        {
          copper = util.by_pixel(136, 8),
          green = util.by_pixel(124, 8),
          red = util.by_pixel(151, 9)
        },
        wire =
        {
          copper = util.by_pixel(0, -86),
          green = util.by_pixel(-21, -82),
          red = util.by_pixel(22, -81)
        }
      },
      {
        shadow =
        {
          copper = util.by_pixel(133, 9),
          green = util.by_pixel(144, 21),
          red = util.by_pixel(110, -3)
        },
        wire =
        {
          copper = util.by_pixel(0, -85),
          green = util.by_pixel(15, -70),
          red = util.by_pixel(-15, -92)
        }
      },
      {
        shadow =
        {
          copper = util.by_pixel(133, 9),
          green = util.by_pixel(127, 26),
          red = util.by_pixel(127, -8)
        },
        wire =
        {
          copper = util.by_pixel(0, -85),
          green = util.by_pixel(0, -66),
          red = util.by_pixel(0, -97)
        }
      },
      {
        shadow =
        {
          copper = util.by_pixel(133, 9),
          green = util.by_pixel(111, 20),
          red = util.by_pixel(144, -3)
        },
        wire =
        {
          copper = util.by_pixel(0, -86),
          green = util.by_pixel(-15, -71),
          red = util.by_pixel(15, -92)
        }
      }
    }
dS.radius_visualisation_picture =
    {
      filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
      width = 12,
      height = 12,
      priority = "extra-high-no-scale"
    }
data:extend{dS}

-- Item --
local dsI = {}
dsI.type = "item"
dsI.name = "DimensionalSubstation"
dsI.place_result = "DimensionalSubstation"
dsI.icon = "__Mobile_Factory_Graphics__/graphics/icons/DimensionalSubstation.png"
dsI.icon_size = 32
dsI.subgroup = "Energy"
dsI.order = "z"
dsI.stack_size = 1
data:extend{dsI}