---------------------------------- Energy Cube MK1 ----------------------------------

-- Entity --
local ec1E = {}
ec1E.type = "accumulator"
ec1E.name = "EnergyCubeMK1"
ec1E.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK1I.png"
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
  buffer_capacity = "2MJ",
  usage_priority = "tertiary",
  input_flow_limit = "200KW",
  output_flow_limit = "200KW",
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
          filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK1G.png",
          priority = "high",
          width = 600,
          height = 600,
          shift = {0,-0.3},
          draw_as_glow = true,
          scale = 1/7
      },
      {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK1E.png",
          priority = "high",
          width = 600,
          height = 600,
          shift = {0,-0.3},
		      scale = 1/7
      },
      {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeS.png",
          priority = "high",
          width = 600,
          height = 600,
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
ec1I.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK1I.png"
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

---------------------------------- Energy Cube MK2 ----------------------------------
local ec2E = table.deepcopy(ec1E)
ec2E.name = "EnergyCubeMK2"
ec2E.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK2I.png"
ec2E.minable = {mining_time = 0.5, result = "EnergyCubeMK2"}
ec2E.energy_source =
{
  type = "electric",
  buffer_capacity = "15MJ",
  usage_priority = "tertiary",
  input_flow_limit = "1500KW",
  output_flow_limit = "1500KW",
  render_no_power_icon = false,
  render_no_network_icon = false
}
ec2E.picture = {
  layers =
  {
      {
        filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK2G.png",
        priority = "high",
        width = 600,
        height = 600,
        shift = {0,-0.3},
        draw_as_glow = true,
        scale = 1/7
    },
    {
        filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK2E.png",
        priority = "high",
        width = 600,
        height = 600,
        shift = {0,-0.3},
        scale = 1/7
    },
    {
        filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeS.png",
        priority = "high",
        width = 600,
        height = 600,
        shift = {0,-0.3},
        draw_as_shadow = true,
        scale = 1/7
    }
  }
}
data:extend{ec2E}

-- Item --
local ec2I = {}
ec2I.type = "item-with-tags"
ec2I.name = "EnergyCubeMK2"
ec2I.place_result = "EnergyCubeMK2"
ec2I.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK2I.png"
ec2I.icon_size = 128
ec2I.subgroup = "Energy"
ec2I.order = "b2"
ec2I.stack_size = 10
data:extend{ec2I}

-- Recipe --
local ec2R = {}
ec2R.type = "recipe"
ec2R.name = "EnergyCubeMK2"
ec2R.energy_required = 10
ec2R.enabled = false
ec2R.ingredients =
{
    {"CrystalizedCircuit", 4},
    {"MachineFrame3", 4}
}
ec2R.result = "EnergyCubeMK2"
data:extend{ec2R}

---------------------------------- Energy Cube MK3 ----------------------------------
local ec3E = table.deepcopy(ec2E)
ec3E.name = "EnergyCubeMK3"
ec3E.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK3I.png"
ec3E.minable = {mining_time = 0.5, result = "EnergyCubeMK3"}
ec3E.energy_source =
{
  type = "electric",
  buffer_capacity = "50MJ",
  usage_priority = "tertiary",
  input_flow_limit = "5MW",
  output_flow_limit = "5MW",
  render_no_power_icon = false,
  render_no_network_icon = false
}
ec3E.picture = {
  layers =
  {
      {
        filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK3G.png",
        priority = "high",
        width = 600,
        height = 600,
        shift = {0,-0.3},
        draw_as_glow = true,
        scale = 1/7
    },
    {
        filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK3E.png",
        priority = "high",
        width = 600,
        height = 600,
        shift = {0,-0.3},
        scale = 1/7
    },
    {
        filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeS.png",
        priority = "high",
        width = 600,
        height = 600,
        shift = {0,-0.3},
        draw_as_shadow = true,
        scale = 1/7
    }
  }
}
data:extend{ec3E}

-- Item --
local ec3I = {}
ec3I.type = "item-with-tags"
ec3I.name = "EnergyCubeMK3"
ec3I.place_result = "EnergyCubeMK3"
ec3I.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeMK3I.png"
ec3I.icon_size = 128
ec3I.subgroup = "Energy"
ec3I.order = "b3"
ec3I.stack_size = 10
data:extend{ec3I}

-- Recipe --
local ec3R = {}
ec3R.type = "recipe"
ec3R.name = "EnergyCubeMK3"
ec3R.energy_required = 10
ec3R.enabled = false
ec3R.ingredients =
{
    {"EnergyCore", 1},
    {"MachineFrame3", 4}
}
ec3R.result = "EnergyCubeMK3"
data:extend{ec3R}


---------------------------------- Quatron Cube MK1 ----------------------------------

-- Entity --
local qc1E = {}
qc1E.type = "accumulator"
qc1E.name = "QuatronCubeMK1"
qc1E.icon = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK1I.png"
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
qc1E.default_output_signal = {type = "virtual", name = "signal-Q"}
qc1E.energy_source =
{
  type = "electric",
  buffer_capacity = "2KJ",
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
          filename = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK1G.png",
          priority = "high",
          width = 600,
          height = 600,
          shift = {0,-0.3},
          draw_as_glow = true,
          scale = 1/7
      },
      {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK1E.png",
          priority = "high",
          width = 600,
          height = 600,
          repeat_count = repeat_count,
          shift = {0,-0.3},
		      scale = 1/7
      },
      {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeS.png",
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
qc1I.icon = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK1I.png"
qc1I.icon_size = 128
qc1I.subgroup = "QuatronLogistic"
qc1I.order = "b1"
qc1I.stack_size = 10
data:extend{qc1I}

-- Recipe --
local qc1R = {}
qc1R.type = "recipe"
qc1R.name = "QuatronCubeMK1"
qc1R.energy_required = 5
qc1R.enabled = false
qc1R.ingredients =
{
    {"DimensionalCircuit", 25},
    {"MachineFrame2", 4}
}
qc1R.result = "QuatronCubeMK1"
data:extend{qc1R}


---------------------------------- Quatron Cube MK2 ----------------------------------

-- Entity --
local qc2E = table.deepcopy(qc1E)
qc2E.name = "QuatronCubeMK2"
qc2E.icon = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK2I.png"
qc2E.minable = {mining_time = 0.5, result = "QuatronCubeMK2"}
qc2E.energy_source =
{
  type = "electric",
  buffer_capacity = "15KJ",
  usage_priority = "tertiary",
  input_flow_limit = "0J",
  output_flow_limit = "0J",
  render_no_power_icon = false,
  render_no_network_icon = false
}
qc2E.picture = {
    layers =
    {
        {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK2G.png",
          priority = "high",
          width = 600,
          height = 600,
          shift = {0,-0.3},
          draw_as_glow = true,
          scale = 1/7
      },
      {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK2E.png",
          priority = "high",
          width = 600,
          height = 600,
          shift = {0,-0.3},
		      scale = 1/7
      },
      {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeS.png",
          priority = "high",
          width = 600,
          height = 600,
          shift = {0,-0.3},
          draw_as_shadow = true,
          scale = 1/7
      }
    }
  }
data:extend{qc2E}

-- Item --
local qc2I = {}
qc2I.type = "item-with-tags"
qc2I.name = "QuatronCubeMK2"
qc2I.place_result = "QuatronCubeMK2"
qc2I.icon = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK2I.png"
qc2I.icon_size = 128
qc2I.subgroup = "QuatronLogistic"
qc2I.order = "b2"
qc2I.stack_size = 10
data:extend{qc2I}

-- Recipe --
local qc2R = {}
qc2R.type = "recipe"
qc2R.name = "QuatronCubeMK2"
qc2R.energy_required = 5
qc2R.enabled = false
qc2R.ingredients =
{
  {"CrystalizedCircuit", 4},
  {"MachineFrame3", 4}
}
qc2R.result = "QuatronCubeMK2"
data:extend{qc2R}


---------------------------------- Quatron Cube MK3 ----------------------------------

-- Entity --
local qc3E = table.deepcopy(qc2E)
qc3E.name = "QuatronCubeMK3"
qc3E.icon = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK3I.png"
qc3E.minable = {mining_time = 0.5, result = "QuatronCubeMK3"}
qc3E.energy_source =
{
  type = "electric",
  buffer_capacity = "50KJ",
  usage_priority = "tertiary",
  input_flow_limit = "0J",
  output_flow_limit = "0J",
  render_no_power_icon = false,
  render_no_network_icon = false
}
qc3E.picture = {
    layers =
    {
        {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK3G.png",
          priority = "high",
          width = 600,
          height = 600,
          shift = {0,-0.3},
          draw_as_glow = true,
          scale = 1/7
      },
      {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK3E.png",
          priority = "high",
          width = 600,
          height = 600,
          shift = {0,-0.3},
		      scale = 1/7
      },
      {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeS.png",
          priority = "high",
          width = 600,
          height = 600,
          shift = {0,-0.3},
          draw_as_shadow = true,
          scale = 1/7
      }
    }
  }
data:extend{qc3E}

-- Item --
local qc3I = {}
qc3I.type = "item-with-tags"
qc3I.name = "QuatronCubeMK3"
qc3I.place_result = "QuatronCubeMK3"
qc3I.icon = "__Mobile_Factory_Graphics__/graphics/energy/QuatronCubeMK3I.png"
qc3I.icon_size = 128
qc3I.subgroup = "QuatronLogistic"
qc3I.order = "b3"
qc3I.stack_size = 10
data:extend{qc3I}

-- Recipe --
local qc3R = {}
qc3R.type = "recipe"
qc3R.name = "QuatronCubeMK3"
qc3R.energy_required = 5
qc3R.enabled = false
qc3R.ingredients =
{
  {"EnergyCore", 1},
  {"MachineFrame3", 4}
}
qc3R.result = "QuatronCubeMK3"
data:extend{qc3R}


---------------------------------- Internal Energy Cube ----------------------------------

-- Entity --
local iecE = table.deepcopy(ec1E)
iecE.name = "InternalEnergyCube"
iecE.icon = "__Mobile_Factory_Graphics__/graphics/energy/InternalEnergyCubeI.png"
iecE.minable = {mining_time = 1.5, result = "InternalEnergyCube"}
iecE.default_output_signal = {type = "virtual", name = "signal-A"}
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
          filename = "__Mobile_Factory_Graphics__/graphics/energy/InternalEnergyCubeG.png",
          priority = "high",
          width = 600,
          height = 600,
          draw_as_glow = true,
          scale = 1/2.25
      },
      {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/InternalEnergyCubeE.png",
          priority = "high",
          width = 600,
          height = 600,
          scale = 1/2.25
      },
      {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeS.png",
          priority = "high",
          width = 600,
          height = 600,
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
iecI.icon = "__Mobile_Factory_Graphics__/graphics/energy/InternalEnergyCubeI.png"
iecI.order = "c"
iecI.subgroup = "Energy"
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
iqcE.icon = "__Mobile_Factory_Graphics__/graphics/energy/InternalQuatronCubeI.png"
iqcE.minable = {mining_time = 1.5, result = "InternalQuatronCube"}
iqcE.default_output_signal = {type = "virtual", name = "signal-Q"}
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
          filename = "__Mobile_Factory_Graphics__/graphics/energy/InternalQuatronCubeG.png",
          priority = "high",
          width = 600,
          height = 600,
          draw_as_glow = true,
          scale = 1/2.25
      },
      {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/InternalQuatronCubeE.png",
          priority = "high",
          width = 600,
          height = 600,
          scale = 1/2.25
      },
      {
          filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyCubeS.png",
          priority = "high",
          width = 600,
          height = 600,
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
iqcI.icon = "__Mobile_Factory_Graphics__/graphics/energy/InternalQuatronCubeI.png"
iqcI.order = "c"
iqcI.subgroup = "QuatronLogistic"
iqcI.stack_size = 1
data:extend{iqcI}

-- Recipe --
local iqcR = {}
iqcR.type = "recipe"
iqcR.name = "InternalQuatronCube"
iqcR.energy_required = 15
iqcR.enabled = false
iqcR.ingredients =
{
    {"QuatronCubeMK1", 4},
    {"DimensionalCircuit", 15},
    {"MachineFrame2", 10}
}
iqcR.result = "InternalQuatronCube"
data:extend{iqcR}




-- Create Cubes Charge Sprites --
local x = 0
local y = 0
for i = 0, 16 do
	local chargeS = {}
	chargeS.type = "sprite"
	chargeS.name = "CubeChargeSprite" .. i
	chargeS.filename = "__Mobile_Factory_Graphics__/graphics/energy/ChargeLevel.png"
  chargeS.size = 600
  chargeS.draw_as_glow = true
  chargeS.x = x
  chargeS.y = y
    x = x + 600
    if i == 8 then
        x = 0
        y = 600
    end
	data:extend{chargeS}
end