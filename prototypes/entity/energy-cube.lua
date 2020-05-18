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
  output_flow_limit = "5MW",
  render_no_power_icon = false,
  render_no_network_icon = false
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
ec1I.subgroup = "Energy"
ec1I.order = "b1"
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

---------------------------------- Quatron Cube MK1 ----------------------------------

-- Entity --
local qc1E = {}
qc1E.type = "accumulator"
qc1E.name = "QuatronCubeMK1"
qc1E.icon = "__Mobile_Factory__/graphics/QuatronCubeMK1I.png"
qc1E.icon_size = 128
qc1E.flags = {"placeable-neutral", "player-creation"}
qc1E.minable = {mining_time = 0.5, result = "QuatronCubeMK1"}
qc1E.max_health = 150
qc1E.corpse = "accumulator-remnants"
qc1E.collision_box = {{-0.9, -0.9}, {0.9, 0.9}}
qc1E.selection_box = {{-1, -1}, {1, 1}}
qc1E.circuit_wire_connection_point =
{
    wire = {red={0,-1.2}, green={0,-1.2}},
    shadow = {red={-0.05,-1.2}, green={-0.05,-1.2}}
}
qc1E.circuit_connector_sprites = nil
qc1E.circuit_wire_max_distance = 20
qc1E.default_output_signal = {type = "virtual", name = "signal-A"}
qc1E.energy_source =
{
  type = "electric",
  buffer_capacity = "10KJ",
  usage_priority = "tertiary",
  input_flow_limit = "0J",
  output_flow_limit = "0J",
  render_no_power_icon = false,
  render_no_network_icon = false
}
qc1E.charge_cooldown = 0
qc1E.charge_light = nil
qc1E.discharge_animation = nil
qc1E.discharge_cooldown = 0
qc1E.discharge_light = nil
qc1E.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
qc1E.working_sound = nil
qc1E.charge_animation = nil
qc1E.picture = {
    layers =
    {
      {
          filename = "__Mobile_Factory__/graphics/QuatronCubeMK1E.png",
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
data:extend{qc1E}

-- Item --
local qc1I = {}
qc1I.type = "item-with-tags"
qc1I.name = "QuatronCubeMK1"
qc1I.place_result = "QuatronCubeMK1"
qc1I.icon = "__Mobile_Factory__/graphics/QuatronCubeMK1I.png"
qc1I.icon_size = 128
qc1I.subgroup = "Energy"
qc1I.order = "e1"
qc1I.stack_size = 10
data:extend{qc1I}

-- Recipe --
local qc1R = {}
qc1R.type = "recipe"
qc1R.name = "QuatronCubeMK1"
qc1R.energy_required = 5
qc1R.enabled = true
qc1R.ingredients =
{
    {"DimensionalCircuit", 25},
    {"MachineFrame2", 4}
}
qc1R.result = "QuatronCubeMK1"
data:extend{qc1R}

-- Create all Sprite --
for i = 0, 10 do
	local iqcS = {}
	iqcS.type = "sprite"
	iqcS.name = "QuatronCubeSprite" .. i
	iqcS.filename = "__Mobile_Factory__/graphics/QuatronCubeSprite.png"
	iqcS.size = 600
  iqcS.x = 600 * i
	data:extend{iqcS}
end

---------------------------------- Internal Energy Cube ----------------------------------

-- Entity --
local iecE = table.deepcopy(ec1E)
iecE.name = "InternalEnergyCube"
iecE.icon = "__Mobile_Factory__/graphics/InternalEnergyCubeI.png"
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
      output_flow_limit = "500MW",
      render_no_power_icon = false,
      render_no_network_icon = false
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
iecI.order = "c"
iecI.stack_size = 1
data:extend{iecI}

-- Recipe --
local iecR = {}
iecR.type = "recipe"
iecR.name = "InternalEnergyCube"
iecR.energy_required = 15
iecR.enabled = false
iecR.ingredients =
{
    {"EnergyCubeMK1", 4},
    {"DimensionalCircuit", 15},
    {"MachineFrame2", 10}
}
iecR.result = "InternalEnergyCube"
data:extend{iecR}

---------------------------------- Internal Quatron Cube ----------------------------------
-- Entity --
local iqcE = table.deepcopy(iecE)
iqcE.name = "InternalQuatronCube"
iqcE.icon = "__Mobile_Factory__/graphics/InternalQuatronCubeI.png"
iqcE.minable = {mining_time = 1.5, result = "InternalQuatronCube"}
iqcE.energy_source =
    {
      type = "electric",
      buffer_capacity = "1MJ",
      usage_priority = "tertiary",
      input_flow_limit = "0J",
      output_flow_limit = "0J",
      render_no_power_icon = false,
      render_no_network_icon = false
    }
    iqcE.picture = {
    layers =
    {
      {
          filename = "__Mobile_Factory__/graphics/InternalQuatronCubeE.png",
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
data:extend{iqcE}

-- Item --
local iqcI = table.deepcopy(iecI)
iqcI.name = "InternalQuatronCube"
iqcI.place_result = "InternalQuatronCube"
iqcI.icon = "__Mobile_Factory__/graphics/InternalQuatronCubeI.png"
iqcI.order = "f"
iqcI.stack_size = 1
data:extend{iqcI}

-- Recipe --
local iecR = {}
iecR.type = "recipe"
iecR.name = "InternalQuatronCube"
iecR.energy_required = 15
iecR.enabled = false
iecR.ingredients =
{
    {"EnergyCubeMK1", 4},
    {"DimensionalCircuit", 15},
    {"MachineFrame2", 10}
}
iecR.result = "InternalQuatronCube"
data:extend{iecR}