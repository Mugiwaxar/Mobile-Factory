---------------------------------- JUMP DRIVE ----------------------------------

-- Entity --
local jdE = {}
jdE.type = "accumulator"
jdE.name = "JumpDrive"
jdE.icon = "__Mobile_Factory__/graphics/JumpDriveI.png"
jdE.order = "JumpDrive"
jdE.icon_size = 128
-- jdE.flags = {"placeable-neutral", "player-creation"}
-- jdE.minable = {mining_time = 0.5, result = "EnergyCubeMK1"}
jdE.max_health = 10000
jdE.corpse = "accumulator-remnants"
jdE.collision_box = {{-2.9, -2.1}, {2.9, 3.7}}
jdE.selection_box = {{-3, -2.2}, {3, 3.8}}
jdE.circuit_wire_connection_point =
{
    wire = {red={0,-1.2}, green={0,-1.2}},
    shadow = {red={-0.05,-1.2}, green={-0.05,-1.2}}
}
jdE.circuit_connector_sprites = nil
jdE.circuit_wire_max_distance = 20
jdE.default_output_signal = {type = "virtual", name = "signal-J"}
jdE.energy_source =
{
  type = "electric",
  buffer_capacity = "100J",
  usage_priority = "tertiary",
  input_flow_limit = "0W",
  output_flow_limit = "0W",
  render_no_power_icon = false,
  render_no_network_icon = false
}
jdE.charge_cooldown = 0
jdE.charge_light = nil
jdE.discharge_animation = nil
jdE.discharge_cooldown = 0
jdE.discharge_light = nil
jdE.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
jdE.working_sound = nil
jdE.charge_animation = nil
jdE.picture = {
    layers =
    {
      {
        filename = "__Mobile_Factory__/graphics/JumpDriveG.png",
        priority = "high",
        width = 600,
        height = 600,
        -- shift = {0.5,-0.3},
        scale = 1/2.25,
        draw_as_glow = true
      },
      {
        filename = "__Mobile_Factory__/graphics/JumpDriveE.png",
        priority = "high",
        width = 600,
        height = 600,
        -- shift = {0.5,-0.3},
        scale = 1/2.25
      },
      {
          filename = "__Mobile_Factory__/graphics/JumpDriveS.png",
          priority = "high",
          width = 600,
          height = 600,
          -- shift = {0.5,-0.3},
          draw_as_shadow = true,
          scale = 1/2.25
      }
    }
  }
data:extend{jdE}

-- Technology --
local jdT = {}
jdT.name = "JumpDrive"
jdT.type = "technology"
jdT.icon = "__Mobile_Factory__/graphics/JumpDriveI.png"
jdT.icon_size = 128
jdT.unit = {
	count=10,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
jdT.prerequisites = {"DimensionalCrystal"}
jdT.effects =
{
	{type="nothing", effect_description={"description.JumpDrive"}},
}
data:extend{jdT}