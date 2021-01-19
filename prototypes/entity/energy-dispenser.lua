------------------------- ENERGY DISPENSER -------------------------

-- Entity --
local edE = {}
edE.type = "electric-pole"
edE.name = "EnergyDispenser"
edE.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyDispenserI.png"
edE.icon_size = 128
edE.flags = {"placeable-neutral", "player-creation"}
edE.minable = {mining_time = 1, result = "EnergyDispenser"}
edE.track_coverage_during_build_by_moving = true
edE.collision_box = {{0, 0}, {0, 0}}
edE.selection_box = {{-1, -1}, {1, 1}}
edE.selection_priority = 51
edE.collision_mask = {"item-layer", "object-layer", "player-layer", "water-tile", "layer-37", "not-colliding-with-itself"}
edE.maximum_wire_distance = 0
edE.supply_area_distance = 64
edE.draw_copper_wires = false
edE.draw_circuit_wires = false
edE.connection_points = {{wire={}, shadow={}}}
edE.radius_visualisation_picture =
{
    filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
    width = 12,
    height = 12,
    priority = "extra-high-no-scale"
}
edE.pictures =
{
    layers =
    {
        {
            filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyDispenserG.png",
            priority = "high",
            width = 400,
            height = 1000,
            direction_count = 1,
            shift = util.by_pixel(0, -100),
            scale = 0.33,
            draw_as_light = true
        },
        {
            filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyDispenserE.png",
            priority = "high",
            width = 400,
            height = 1000,
            direction_count = 1,
            shift = util.by_pixel(0, -100),
            scale = 0.33
        },
        {
            filename = "__Mobile_Factory_Graphics__/graphics/energy/EnergyDispenserS.png",
            priority = "high",
            width = 1000,
            height = 400,
            direction_count = 1,
            shift = util.by_pixel(95, 17),
            draw_as_shadow = true,
            scale = 0.33
        }
    }
}
data:extend{edE}

-- Item --
local edI = {}
edI.type = "item"
edI.name = "EnergyDispenser"
edI.place_result = "EnergyDispenser"
edI.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyDispenserI.png"
edI.icon_size = 128
edI.subgroup = "Energy"
edI.order = "d"
edI.stack_size = 10
data:extend{edI}

-- Crafting --
local edC = {}
edC.type = "recipe"
edC.name = "EnergyDispenser"
edC.energy_required = 5
edC.enabled = false
edC.ingredients =
    {
		{"CrystalizedCircuit", 6},
		{"MachineFrame3", 5}
    }
edC.result = "EnergyDispenser"
data:extend{edC}

-- Technologie --
local edt = {}
edt.name = "EnergyDispenser"
edt.type = "technology"
edt.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyDispenserI.png"
edt.icon_size = 128
edt.unit = {
	count=25,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
edt.prerequisites = {"EnergyLogistic"}
edt.effects = {{type="unlock-recipe", recipe="EnergyDispenser"}}
data:extend{edt}

-- Fake Accumulator Entity --
local fedE = {}
fedE.type = "accumulator"
fedE.name = "EnergyDispenserAcc"
fedE.icon = "__Mobile_Factory_Graphics__/graphics/energy/EnergyDispenserI.png"
fedE.icon_size = 128
fedE.minable = {mining_time = 1, result = "EnergyDispenser"}
fedE.max_health = 150
fedE.corpse = "accumulator-remnants"
fedE.collision_box = {{-2, -2}, {2, 2}}
fedE.selection_box = {{-2, -2}, {2, 2}}
fedE.collision_mask = {"item-layer", "object-layer", "player-layer", "water-tile", "layer-37", "not-colliding-with-itself"}
fedE.circuit_wire_max_distance = 0
fedE.energy_source =
{
  type = "electric",
  buffer_capacity = "10MJ",
  usage_priority = "tertiary",
  input_flow_limit = "0J",
  output_flow_limit = "10MW",
  render_no_power_icon = false,
  render_no_network_icon = false
}
fedE.charge_cooldown = 0
fedE.charge_light = nil
fedE.discharge_animation = nil
fedE.discharge_cooldown = 0
fedE.discharge_light = nil
fedE.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
fedE.working_sound = nil
fedE.charge_animation = nil
fedE.picture = {
    layers =
    {
      {
          filename = "__Mobile_Factory_Graphics__/graphics/alpha.png",
          priority = "high",
          width = 132,
          height = 132,
        --   shift = {-0.5, -0.5}
      }
  }
}
data:extend{fedE}