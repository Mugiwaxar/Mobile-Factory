---------------------------- Basic Solar Panel --------------------

-- Entity --
bspE = {}
bspE.type = "solar-panel"
bspE.name = "BasicSolarPanel"
bspE.icon = "__base__/graphics/icons/solar-panel.png"
bspE.icon_size = 32
bspE.flags = {"placeable-neutral", "player-creation"}
bspE.minable = {mining_time = 0.1, result = "BasicSolarPanel"}
bspE.max_health = 200
bspE.corpse = "solar-panel-remnants"
bspE.collision_box = {{-0.4, -0.4}, {0.4, 0.4}}
bspE.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
bspE.energy_source =
    {
      type = "electric",
      usage_priority = "solar"
    }
bspE.picture =
    {
      layers =
      {
        {
            filename = "__base__/graphics/entity/solar-panel/hr-solar-panel.png",
            priority = "high",
            width = 230,
            height = 224,
            shift = util.by_pixel(-3, 0),
            scale = 0.5/3
        },
        {
            filename = "__base__/graphics/entity/solar-panel/hr-solar-panel-shadow.png",
            priority = "high",
            width = 220,
            height = 180,
            shift = util.by_pixel(2.5, 6),
            draw_as_shadow = true,
            scale = 0.5/3,
        }
      }
    }
bspE.overlay =
    {
      layers =
      {
        {
            filename = "__base__/graphics/entity/solar-panel/hr-solar-panel-shadow-overlay.png",
            priority = "high",
            width = 214,
            height = 180,
            shift = util.by_pixel(10.5, 6),
            scale = 0.5/3
        }
      }
    }
bspE.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
bspE.production = "5kW"
data:extend{bspE}

-- Item --
bspI = {}
bspI.type = "item"
bspI.name = "BasicSolarPanel"
bspI.icon = "__base__/graphics/icons/solar-panel.png"
bspI.icon_size = 32
bspI.subgroup = "DimensionalStuff"
bspI.order = "B"
bspI.place_result = "BasicSolarPanel"
bspI.stack_size = 50
data:extend{bspI}

-- Recipe --
bspR = {}
bspR.type = "recipe"
bspR.name = "BasicSolarPanel"
bspR.energy_required = 10
bspR.ingredients =
    {
      {"DimensionalOre", 4},
      {"copper-plate", 8},
      {"iron-plate", 15}
    }
bspR.result = "BasicSolarPanel"
data:extend{bspR}