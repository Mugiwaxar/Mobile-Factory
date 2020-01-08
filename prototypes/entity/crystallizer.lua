---------------------- Crystallizer ----------------------
  
-- Entity --
cE = {}
cE.type = "assembling-machine"
cE.name = "Crystallizer"
cE.icon = "__Mobile_Factory__/graphics/icones/Crystallizer.png"
cE.icon_size = 32
cE.flags = {"placeable-neutral", "placeable-player", "player-creation"}
cE.minable = {mining_time = 0.2, result = "Crystallizer"}
cE.max_health = 350
cE.dying_explosion = "medium-explosion"
cE.corpse = "medium-remnants"
cE.alert_icon_shift = util.by_pixel(-3, -12)
cE.resistances =
    {
      {
        type = "fire",
        percent = 70
      }
    }
cE.fluid_boxes =
    {
      {
        production_type = "input",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {0, -2} }},
        secondary_draw_orders = { north = -1 }
      },
      {
        production_type = "output",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = 1,
        pipe_connections = {{ type="output", position = {0, 2} }},
        secondary_draw_orders = { north = -1 }
      },
      off_when_no_fluid_recipe = true
    }
cE.collision_box = {{-1.2, -1.2}, {1.2, 1.2}}
cE.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
cE.animation =
    {
      layers =
      {
        {
            filename = "__Mobile_Factory__/graphics/entity/Crystallizer.png",
            priority = "high",
            width = 214,
            height = 218,
            frame_count = 32,
            line_length = 8,
            shift = util.by_pixel(0, 4),
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-shadow.png",
            priority = "high",
            width = 196,
            height = 163,
            frame_count = 32,
            line_length = 8,
            draw_as_shadow = true,
            shift = util.by_pixel(12, 4.75),
            scale = 0.5
        }
      }
    }
cE.open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 }
cE.close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 }
cE.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
cE.working_sound =
    {
      sound =
      {
        {
          filename = "__base__/sound/assembling-machine-t2-1.ogg",
          volume = 0.8
        },
        {
          filename = "__base__/sound/assembling-machine-t2-2.ogg",
          volume = 0.8
        }
      },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5
    }
cE.crafting_categories = {"DimensionalCrystallizaton"}

cE.crafting_speed = 1
cE.energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = 3
    }
cE.energy_usage = "800kW"
cE.module_specification =
    {
      module_slots = 2
    }
cE.allowed_effects = {"consumption", "speed", "productivity", "pollution"}
data:extend{cE}

-- Item --
local cI = {}
cI.type = "item"
cI.name = "Crystallizer"
cI.icon = "__Mobile_Factory__/graphics/icones/Crystallizer.png"
cI.icon_size = 32
cI.place_result = "Crystallizer"
cI.subgroup = "DimensionalStuff"
cI.order = "e"
cI.stack_size = 5
data:extend{cI}

-- Recipe --
local cR = {}
cR.type = "recipe"
cR.name = "Crystallizer"
cR.energy_required = 5
cR.enabled = false
cR.ingredients =
    {
      {"DimensionalPlate", 45},
      {"DimensionalCircuit", 35}
    }
cR.result = "Crystallizer"
data:extend{cR}

-- Technologie --
local cT = {}
cT.name = "Crystallizer"
cT.type = "technology"
cT.icon = "__Mobile_Factory__/graphics/icones/Crystallizer.png"
cT.icon_size = 32
cT.unit = {
	count=1000,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
cT.prerequisites = {"DimensionalOreSmelting"}
cT.effects = {{type="unlock-recipe", recipe="Crystallizer"}}
data:extend{cT}