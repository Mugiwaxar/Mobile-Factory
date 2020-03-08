-- Dimensional Accumulator --

-- Entity --
local daE = {}
daE.type = "accumulator"
daE.name = "DimensionalAccumulator"
daE.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalAccumulator.png"
daE.icon_size = 32
daE.flags = {"placeable-neutral", "player-creation"}
daE.minable = {mining_time = 0.5, result = "DimensionalAccumulator"}
daE.max_health = 150
daE.corpse = "accumulator-remnants"
daE.collision_box = {{-0.9, -0.9}, {0.9, 0.9}}
daE.selection_box = {{-1, -1}, {1, 1}}
daE.drawing_box = {{-1, -1.5}, {1, 1}}
daE.circuit_wire_connection_point = circuit_connector_definitions["accumulator"].points
daE.circuit_connector_sprites = circuit_connector_definitions["accumulator"].sprites
daE.circuit_wire_max_distance = default_circuit_wire_max_distance
daE.default_output_signal = {type = "virtual", name = "signal-A"}
daE.energy_source =
    {
      type = "electric",
      buffer_capacity = "5MJ",
      usage_priority = "tertiary",
      input_flow_limit = "1MW",
      output_flow_limit = "1MW"
    }
daE.charge_cooldown = 30
daE.charge_light = {intensity = 0.3, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}}
daE.discharge_animation = accumulator_discharge()
daE.discharge_cooldown = 60
daE.discharge_light = {intensity = 0.7, size = 7, color = {r = 1.0, g = 1.0, b = 1.0}}
daE.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
daE.working_sound =
    {
      sound =
      {
        filename = "__base__/sound/accumulator-working.ogg",
        volume = 1
      },
      idle_sound =
      {
        filename = "__base__/sound/accumulator-idle.ogg",
        volume = 0.4
      },
      max_sounds_per_type = 5
    }
 daE.picture = {
    layers =
    {
      {
          filename = "__Mobile_Factory_Graphics__/graphics/entity/DimensionalAccumulator.png",
          priority = "high",
          width = 130,
          height = 189,
          repeat_count = repeat_count,
          shift = util.by_pixel(0, -11),
          -- tint = tint,
          animation_speed = 0.5,
          scale = 0.5
      },
      {
          filename = "__base__/graphics/entity/accumulator/hr-accumulator-shadow.png",
          priority = "high",
          width = 234,
          height = 106,
          repeat_count = repeat_count,
          shift = util.by_pixel(29, 6),
          draw_as_shadow = true,
          scale = 0.5
      }
    }
  }
 daE.charge_animation = {
    layers =
    {
      accumulator_picture({ r=1, g=1, b=1, a=1 } , 24),
      {
          filename = "__base__/graphics/entity/accumulator/hr-accumulator-charge.png",
          priority = "high",
          width = 178,
          height = 206,
          line_length = 6,
          frame_count = 24,
          blend_mode = "additive",
          shift = util.by_pixel(0, -22),
          scale = 0.5
      }
    }
  }
data:extend{daE}

-- Item --
local daI = {}
daI.type = "item"
daI.name = "DimensionalAccumulator"
daI.place_result = "DimensionalAccumulator"
daI.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalAccumulator.png"
daI.icon_size = 32
daI.subgroup = "DimensionalStuff"
daI.order = "c"
daI.stack_size = 5
data:extend{daI}

-- Crafting --
local daC = {}
daC.type = "recipe"
daC.name = "DimensionalAccumulator"
daC.energy_required = 5
daC.enabled = false
daC.ingredients =
    {
		{"MachineFrame2", 3},
		{"DimensionalCircuit", 15}
    }
daC.result = "DimensionalAccumulator"
data:extend{daC}

-- Technology --
local daT = {}
daT.name = "ElectricityCompression"
daT.type = "technology"
daT.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalAccumulator.png"
daT.icon_size = 32
daT.unit = {
	count=450,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
daT.prerequisites = {"DimensionalElectronic"}
daT.effects = {{type="unlock-recipe", recipe="DimensionalAccumulator"}}
data:extend{daT}
