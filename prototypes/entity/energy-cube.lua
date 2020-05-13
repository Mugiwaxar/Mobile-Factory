---------------------------------- Energy Cube MK1 ----------------------------------

-- Entity --
local ec1E = {}
ec1E.type = "accumulator"
ec1E.name = "EnergyCubeMK1"
ec1E.icon = "__Mobile_Factory__/graphics/EnergyCubeMK1I.png"
ec1E.icon_size = 128
ec1E.flags = {"placeable-neutral", "player-creation"}
ec1E.minable = {mining_time = 0.5, result = "EnergyCubeMK1"}
ec1E.max_health = 150
ec1E.corpse = "accumulator-remnants"
ec1E.collision_box = {{-0.9, -0.9}, {0.9, 0.9}}
ec1E.selection_box = {{-1, -1}, {1, 1}}
-- ec1E.drawing_box = {{-1, -1.5}, {1, 1}}
ec1E.circuit_wire_connection_point =
{
    wire = {red={0,-1.2}, green={0,-1.2}},
    shadow = {red={-0.05,-1.2}, green={-0.05,-1.2}}
}
ec1E.circuit_connector_sprites = nil
ec1E.circuit_wire_max_distance = 20
ec1E.default_output_signal = {type = "virtual", name = "signal-A"}
ec1E.energy_source =
    {
      type = "electric",
      buffer_capacity = "100MJ",
      usage_priority = "tertiary",
      input_flow_limit = "5MW",
      output_flow_limit = "5MW"
    }
ec1E.charge_cooldown = 0
ec1E.charge_light = nil
ec1E.discharge_animation = nil
ec1E.discharge_cooldown = 0
ec1E.discharge_light = nil
ec1E.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
ec1E.working_sound = nil
ec1E.charge_animation = nil
ec1E.picture = {
    layers =
    {
      {
          filename = "__Mobile_Factory__/graphics/EnergyCubeMK1E.png",
          priority = "high",
          width = 600,
          height = 600,
          repeat_count = repeat_count,
          shift = {0,-0.3},
		  scale = 1/7
      },
      {
          filename = "__Mobile_Factory__/graphics/EnergyCubeS.png",
          priority = "high",
          width = 600,
          height = 600,
          repeat_count = repeat_count,
          shift = {0,-0.3},
          draw_as_shadow = true,
          scale = 1/7
      }
    }
  }
data:extend{ec1E}

-- Item --
local ec1I = {}
ec1I.type = "item-with-tags"
ec1I.name = "EnergyCubeMK1"
ec1I.place_result = "EnergyCubeMK1"
ec1I.icon = "__Mobile_Factory__/graphics/EnergyCubeMK1I.png"
ec1I.icon_size = 128
ec1I.subgroup = "DataSerialization"
ec1I.order = "z"
ec1I.stack_size = 10
data:extend{ec1I}

-- Recipe --
local ec1R = {}
ec1R.type = "recipe"
ec1R.name = "EnergyCubeMK1"
ec1R.energy_required = 5
ec1R.enabled = false
ec1R.ingredients =
    {
      {"DimensionalCircuit", 25},
      {"MachineFrame2", 4}
    }
ec1R.result = "EnergyCubeMK1"
data:extend{ec1R}

-- Create all Sprite --
for i = 0, 10 do
	local ec1S = {}
	ec1S.type = "sprite"
	ec1S.name = "EnergyCubeMK1Sprite" .. i
	ec1S.filename = "__Mobile_Factory__/graphics/EnergyCubeSprite.png"
	ec1S.size = 600
  ec1S.x = 600 * i
	data:extend{ec1S}
end


---------------------------------- Internal Energy Cube ----------------------------------

-- Entity --
local iecE = table.deepcopy(ec1E)
iecE.name = "InternalEnergyCube"
iecE.icon = "__Mobile_Factory__/graphics/InternalEnergyCubeE.png"
iecE.minable = {mining_time = 1.5, result = "InternalEnergyCube"}
iecE.max_health = 1500
iecE.collision_box = {{-2.9, -2.1}, {2.9, 3.7}}
iecE.selection_box = {{-3, -2.2}, {3, 3.8}}
iecE.circuit_wire_connection_point =
{
    wire = {red={0,-2.2}, green={0,-2.2}},
    shadow = {red={-0.05,-2.2}, green={-0.05,-2.2}}
}
iecE.energy_source =
    {
      type = "electric",
      buffer_capacity = "3GJ",
      usage_priority = "tertiary",
      input_flow_limit = "500MW",
      output_flow_limit = "500MW"
    }
    iecE.picture = {
    layers =
    {
      {
          filename = "__Mobile_Factory__/graphics/InternalEnergyCubeE.png",
          priority = "high",
          width = 600,
          height = 600,
          repeat_count = repeat_count,
          scale = 1/2.25
      },
      {
          filename = "__Mobile_Factory__/graphics/EnergyCubeS.png",
          priority = "high",
          width = 600,
          height = 600,
          repeat_count = repeat_count,
          draw_as_shadow = true,
          scale = 1/2.25
      }
    }
  }
data:extend{iecE}

-- Item --
local iecI = table.deepcopy(ec1I)
iecI.name = "InternalEnergyCube"
iecI.place_result = "InternalEnergyCube"
iecI.icon = "__Mobile_Factory__/graphics/InternalEnergyCubeI.png"
iecI.order = "z2"
iecI.stack_size = 1
data:extend{iecI}