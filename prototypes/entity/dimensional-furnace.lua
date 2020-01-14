-- Dimensional Furnace --

-- Entity --
local dfE = {}

dfE.type = "furnace"
dfE.name = "DimensionalFurnace"
dfE.icon = "__Mobile_Factory__/graphics/icones/DimensionalFurnace.png"
dfE.icon_size = 32
dfE.flags = {"placeable-neutral", "placeable-player", "player-creation"}
dfE.minable = {mining_time = 0.5, result = "DimensionalFurnace"}
dfE.max_health = 350
dfE.corpse = "medium-remnants"
dfE.dying_explosion = "medium-explosion"
dfE.resistances = {{type="fire",percent=80}}
dfE.collision_box = {{-1.2, -1.2}, {1.2, 1.2}}
dfE.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
dfE.module_specification = {module_slots=2,module_info_icon_shift={0, 0.8}}
dfE.allowed_effects = {"consumption", "speed", "productivity", "pollution"}
dfE.crafting_categories = {"DimensionalSmelting", "smelting"}
dfE.result_inventory_size = 1
dfE.crafting_speed = 2
dfE.energy_usage = "180kW"
dfE.source_inventory_size = 1
dfE.energy_source = {type="electric",usage_priority="secondary-input",emissions_per_minute=1}
dfE.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
dfE.fast_replaceable_group = nil
dfE.working_sound =
    {
      sound =
      {
        filename = "__base__/sound/electric-furnace.ogg",
        volume = 0.7
      },
      apparent_volume = 1.5
    }
dfE.animation =
    {
      layers =
      {
        {
            filename = "__Mobile_Factory__/graphics/entity/DimensionalFurnace.png",
            priority = "high",
            width = 239,
            height = 219,
            frame_count = 1,
            shift = util.by_pixel(0.75, 5.75),
            scale = 0.5
        },
        {
            filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-shadow.png",
            priority = "high",
            width = 227,
            height = 171,
            frame_count = 1,
            draw_as_shadow = true,
            shift = util.by_pixel(11.25, 7.75),
            scale = 0.5
        }
      }
    }
dfE.working_visualisations =
    {
      {
        animation =
        {
            filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-heater.png",
            priority = "high",
            width = 60,
            height = 56,
            frame_count = 12,
            animation_speed = 0.5,
            shift = util.by_pixel(1.75, 32.75),
            scale = 0.5
        },
        light = {intensity = 0.4, size = 6, shift = {0.0, 1.0}, color = {r = 1.0, g = 1.0, b = 1.0}}
      },
      {
        animation =
        {
            filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-propeller-1.png",
            priority = "high",
            width = 37,
            height = 25,
            frame_count = 4,
            animation_speed = 0.5,
            shift = util.by_pixel(-20.5, -18.5),
            scale = 0.5
        }
      },
      {
        animation =
        {
            filename = "__base__/graphics/entity/electric-furnace/hr-electric-furnace-propeller-2.png",
            priority = "high",
            width = 23,
            height = 15,
            frame_count = 4,
            animation_speed = 0.5,
            shift = util.by_pixel(3.5, -38),
            scale = 0.5
        }
      }
    }
data:extend{dfE}

-- Item --
local dfI = {}
dfI.type = "item"
dfI.name = "DimensionalFurnace"
dfI.icon = "__Mobile_Factory__/graphics/icones/DimensionalFurnace.png"
dfI.icon_size = 32
dfI.place_result = "DimensionalFurnace"
dfI.subgroup = "DimensionalStuff"
dfI.order = "a"
dfI.stack_size = 20
data:extend{dfI}

-- Recipe --
local dfR = {}
dfR.type = "recipe"
dfR.name = "DimensionalFurnace"
dfR.energy_required = 3
dfR.enabled = false
dfR.ingredients =
    {
		{"MachineFrame", 8}
    }
dfR.result = "DimensionalFurnace"
data:extend{dfR}

-- Technologie --
local dfT = {}
dfT.name = "DimensionalOreSmelting"
dfT.type = "technology"
dfT.icon = "__Mobile_Factory__/graphics/icones/DimensionalFurnace.png"
dfT.icon_size = 32
dfT.unit = {
	count=150,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
dfT.prerequisites = {"DimensionalOre"}
dfT.effects = {{type="unlock-recipe", recipe="DimensionalFurnace"},{type="unlock-recipe", recipe="DimensionalPlate"},{type="unlock-recipe", recipe="MachineFrame2"}}
data:extend{dfT}