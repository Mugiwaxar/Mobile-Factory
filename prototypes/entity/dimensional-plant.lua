---------------------- DIMENSIONAL PLANT ----------------------

-- Entity --
dpE = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
dpE.name = "DimensionalPlant"
dpE.icon = "__Mobile_Factory__/graphics/icones/DimensionalPlant.png"
dpE.minable = {mining_time = 0.3, result = "DimensionalPlant"}
dpE.crafting_categories = {"Elements"}
dpE.animation = make_4way_animation_from_spritesheet({ 
	layers =
		{
		{
          filename = "__Mobile_Factory__/graphics/entity/DimensionalPlant.png",
          width = 220,
          height = 292,
          frame_count = 24,
          line_length = 12,
          shift = util.by_pixel(0.5, -9),
          scale = 0.5
		},
		{
          filename = "__base__/graphics/entity/chemical-plant/hr-chemical-plant-shadow.png",
          width = 312,
          height = 222,
          repeat_count = 24,
          frame_count = 1,
          shift = util.by_pixel(27, 6),
          draw_as_shadow = true,
          scale = 0.5
		}
	}})
data:extend{dpE}

-- Item --
local dpI = {}
dpI.type = "item"
dpI.name = "DimensionalPlant"
dpI.icon = "__Mobile_Factory__/graphics/icones/DimensionalPlant.png"
dpI.icon_size = 32
dpI.place_result = "DimensionalPlant"
dpI.subgroup = "DimensionalStuff"
dpI.order = "f"
dpI.stack_size = 5
data:extend{dpI}

-- Recipe --
local dpR = {}
dpR.type = "recipe"
dpR.name = "DimensionalPlant"
dpR.energy_required = 5
dpR.enabled = false
dpR.ingredients =
    {
      {"chemical-plant", 1},
      {"DimensionalPlate", 60},
    }
dpR.result = "DimensionalPlant"
data:extend{dpR}

-- Technologie --
local dpT = {}
dpT.name = "DimensionalPlant"
dpT.type = "technology"
dpT.icon = "__Mobile_Factory__/graphics/icones/DimensionalPlant.png"
dpT.icon_size = 32
dpT.unit = {
	count=1200,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
dpT.prerequisites = {"DimensionalOreSmelting"}
dpT.effects = {{type="unlock-recipe", recipe="DimensionalPlant"}}
data:extend{dpT}