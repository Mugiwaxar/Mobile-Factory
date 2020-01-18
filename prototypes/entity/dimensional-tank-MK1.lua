--------------------- DIMENSIONAL TANK MK1 ------------------------

--------- TANK 1 ----------
-- Entity --
dmE = {}
dmE.type = "storage-tank"
dmE.name = "StorageTank1MK1"
dmE.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalTank1.png"
dmE.icon_size = 32
dmE.flags = {"placeable-player", "player-creation"}
dmE.minable = nil
dmE.max_health = 500
dmE.corpse = "medium-remnants"
dmE.collision_box = {{-5.9, -6.6}, {6.2, 5.5}}
dmE.selection_box = {{-5.9, -6.6}, {6.2, 5.5}}
dmE.flags = {"not-rotatable"}
dmE.order = "a"
dmE.fluid_box =
    {
      base_area = 100,
      height = 100,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
	  pipe_connections = {}
    }
dmE.two_direction_only = true
dmE.window_bounding_box = {{-0.125, 0.6875}, {0.1875, 1.1875}}
dmE.pictures =
    {
      picture =
      {
        sheets =
        {
          {
			  filename = "__Mobile_Factory_Graphics__/graphics/entity/DimensionalTank.png",
			  priority = "extra-high",
			  frames = 2,
			  width = 219,
			  height = 215,
			  shift = util.by_pixel(10, -3),
			  scale = 2
          },
          {
              filename = "__base__/graphics/entity/storage-tank/hr-storage-tank-shadow.png",
              priority = "extra-high",
              frames = 2,
              width = 291,
              height = 153,
              shift = util.by_pixel(29.75, 22.25),
              scale = 2,
              draw_as_shadow = true
          }
        }
      },
      fluid_background =
      {
        filename = "__base__/graphics/entity/storage-tank/fluid-background.png",
        priority = "extra-high",
        width = 32,
        height = 15,
      },
      window_background =
      {
        filename = "__base__/graphics/entity/storage-tank/window-background.png",
        priority = "extra-high",
        width = 17,
        height = 24,
		scale = 3.5,
		shift = {0.3,2.0}
      },
      flow_sprite =
      {
        filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
        priority = "extra-high",
        width = 160,
        height = 20,
		scale=3,
		shift = {0.3,2.2}
      },
      gas_flow =
      {
        filename = "__base__/graphics/entity/pipe/steam.png",
        priority = "extra-high",
        line_length = 10,
        width = 24,
        height = 15,
        frame_count = 60,
        axially_symmetrical = false,
        direction_count = 1,
        animation_speed = 0.25,
        hr_version =
        {
          filename = "__base__/graphics/entity/pipe/hr-steam.png",
          priority = "extra-high",
          line_length = 10,
          width = 48,
          height = 30,
          frame_count = 60,
          axially_symmetrical = false,
          animation_speed = 0.25,
          direction_count = 1,
          scale = 0.5
        }
      }
    }
dmE.flow_length_in_ticks = 360
dmE.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
dmE.working_sound =
    {
      sound =
      {
          filename = "__base__/sound/storage-tank.ogg",
          volume = 0.8
      },
      match_volume_to_activity = true,
      apparent_volume = 1.5,
      max_sounds_per_type = 3
    }
dmE.circuit_wire_connection_points = circuit_connector_definitions["storage-tank"].points
dmE.circuit_connector_sprites = circuit_connector_definitions["storage-tank"].sprites
dmE.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{dmE}

-- Technology --
local dmT = {}
dmT.name = "StorageTankMK1_1"
dmT.type = "technology"
dmT.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalTank1.png"
dmT.icon_size = 32
dmT.unit = {
	count=450,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
dmT.prerequisites = {"ControlCenter"}
dmT.effects = {{type="nothing", effect_description={"description.DimensionalTank1"}}, {type="unlock-recipe", recipe="ModuleID1"}}
data:extend{dmT}


--------- TANK 2 ----------
-- Entity --
dt2 = {}
dt2.type = "storage-tank"
dt2.name = "StorageTank2MK1"
dt2.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalTank2.png"
dt2.icon_size = 32
dt2.flags = {"placeable-player", "player-creation"}
dt2.minable = nil
dt2.max_health = 500
dt2.corpse = "medium-remnants"
dt2.collision_box = {{-5.9, -6.6}, {6.2, 5.5}}
dt2.selection_box = {{-5.9, -6.6}, {6.2, 5.5}}
dt2.flags = {"not-rotatable"}
dt2.order = "a"
dt2.fluid_box =
    {
      base_area = 100,
      height = 100,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
	  pipe_connections = {}
    }
dt2.two_direction_only = true
dt2.window_bounding_box = {{-0.125, 0.6875}, {0.1875, 1.1875}}
dt2.pictures =
    {
      picture =
      {
        sheets =
        {
          {
			  filename = "__Mobile_Factory_Graphics__/graphics/entity/DimensionalTank2.png",
			  priority = "extra-high",
			  frames = 2,
			  width = 219,
			  height = 215,
			  shift = util.by_pixel(10, -3),
			  scale = 2
          },
          {
              filename = "__base__/graphics/entity/storage-tank/hr-storage-tank-shadow.png",
              priority = "extra-high",
              frames = 2,
              width = 291,
              height = 153,
              shift = util.by_pixel(29.75, 22.25),
              scale = 2,
              draw_as_shadow = true
          }
        }
      },
      fluid_background =
      {
        filename = "__base__/graphics/entity/storage-tank/fluid-background.png",
        priority = "extra-high",
        width = 32,
        height = 15,
      },
      window_background =
      {
        filename = "__base__/graphics/entity/storage-tank/window-background.png",
        priority = "extra-high",
        width = 17,
        height = 24,
		scale = 3.5,
		shift = {0.3,2.0}
      },
      flow_sprite =
      {
        filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
        priority = "extra-high",
        width = 160,
        height = 20,
		scale=3,
		shift = {0.3,2.2}
      },
      gas_flow =
      {
        filename = "__base__/graphics/entity/pipe/steam.png",
        priority = "extra-high",
        line_length = 10,
        width = 24,
        height = 15,
        frame_count = 60,
        axially_symmetrical = false,
        direction_count = 1,
        animation_speed = 0.25,
        hr_version =
        {
          filename = "__base__/graphics/entity/pipe/hr-steam.png",
          priority = "extra-high",
          line_length = 10,
          width = 48,
          height = 30,
          frame_count = 60,
          axially_symmetrical = false,
          animation_speed = 0.25,
          direction_count = 1,
          scale = 0.5
        }
      }
    }
dt2.flow_length_in_ticks = 360
dt2.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
dt2.working_sound =
    {
      sound =
      {
          filename = "__base__/sound/storage-tank.ogg",
          volume = 0.8
      },
      match_volume_to_activity = true,
      apparent_volume = 1.5,
      max_sounds_per_type = 3
    }
dt2.circuit_wire_connection_points = circuit_connector_definitions["storage-tank"].points
dt2.circuit_connector_sprites = circuit_connector_definitions["storage-tank"].sprites
dt2.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{dt2}

-- Technology --
local dt2T = {}
dt2T.name = "StorageTankMK1_2"
dt2T.type = "technology"
dt2T.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalTank2.png"
dt2T.icon_size = 32
dt2T.unit = {
	count=650,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
dt2T.prerequisites = {"StorageTankMK1_1"}
dt2T.effects = {{type="nothing", effect_description={"description.DimensionalTank2"}}, {type="unlock-recipe", recipe="ModuleID2"}}
data:extend{dt2T}


--------- TANK 3 ----------
-- Entity --
dt3 = {}
dt3.type = "storage-tank"
dt3.name = "StorageTank3MK1"
dt3.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalTank3.png"
dt3.icon_size = 32
dt3.flags = {"placeable-player", "player-creation"}
dt3.minable = nil
dt3.max_health = 500
dt3.corpse = "medium-remnants"
dt3.collision_box = {{-5.9, -6.6}, {6.2, 5.5}}
dt3.selection_box = {{-5.9, -6.6}, {6.2, 5.5}}
dt3.flags = {"not-rotatable"}
dt3.order = "a"
dt3.fluid_box =
    {
      base_area = 100,
      height = 100,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
	  pipe_connections = {}
    }
dt3.two_direction_only = true
dt3.window_bounding_box = {{-0.125, 0.6875}, {0.1875, 1.1875}}
dt3.pictures =
    {
      picture =
      {
        sheets =
        {
          {
			  filename = "__Mobile_Factory_Graphics__/graphics/entity/DimensionalTank3.png",
			  priority = "extra-high",
			  frames = 2,
			  width = 219,
			  height = 215,
			  shift = util.by_pixel(10, -3),
			  scale = 2
          },
          {
              filename = "__base__/graphics/entity/storage-tank/hr-storage-tank-shadow.png",
              priority = "extra-high",
              frames = 2,
              width = 291,
              height = 153,
              shift = util.by_pixel(29.75, 22.25),
              scale = 2,
              draw_as_shadow = true
          }
        }
      },
      fluid_background =
      {
        filename = "__base__/graphics/entity/storage-tank/fluid-background.png",
        priority = "extra-high",
        width = 32,
        height = 15,
      },
      window_background =
      {
        filename = "__base__/graphics/entity/storage-tank/window-background.png",
        priority = "extra-high",
        width = 17,
        height = 24,
		scale = 3.5,
		shift = {0.3,2.0}
      },
      flow_sprite =
      {
        filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
        priority = "extra-high",
        width = 160,
        height = 20,
		scale=3,
		shift = {0.3,2.2}
      },
      gas_flow =
      {
        filename = "__base__/graphics/entity/pipe/steam.png",
        priority = "extra-high",
        line_length = 10,
        width = 24,
        height = 15,
        frame_count = 60,
        axially_symmetrical = false,
        direction_count = 1,
        animation_speed = 0.25,
        hr_version =
        {
          filename = "__base__/graphics/entity/pipe/hr-steam.png",
          priority = "extra-high",
          line_length = 10,
          width = 48,
          height = 30,
          frame_count = 60,
          axially_symmetrical = false,
          animation_speed = 0.25,
          direction_count = 1,
          scale = 0.5
        }
      }
    }
dt3.flow_length_in_ticks = 360
dt3.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
dt3.working_sound =
    {
      sound =
      {
          filename = "__base__/sound/storage-tank.ogg",
          volume = 0.8
      },
      match_volume_to_activity = true,
      apparent_volume = 1.5,
      max_sounds_per_type = 3
    }
dt3.circuit_wire_connection_points = circuit_connector_definitions["storage-tank"].points
dt3.circuit_connector_sprites = circuit_connector_definitions["storage-tank"].sprites
dt3.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{dt3}

-- Technology --
local dt3T = {}
dt3T.name = "StorageTankMK1_3"
dt3T.type = "technology"
dt3T.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalTank3.png"
dt3T.icon_size = 32
dt3T.unit = {
	count=800,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
dt3T.prerequisites = {"StorageTankMK1_2"}
dt3T.effects = {{type="nothing", effect_description={"description.DimensionalTank3"}}, {type="unlock-recipe", recipe="ModuleID3"}}
data:extend{dt3T}



--------- TANK 4 ----------
-- Entity --
dt4 = {}
dt4.type = "storage-tank"
dt4.name = "StorageTank4MK1"
dt4.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalTank4.png"
dt4.icon_size = 32
dt4.flags = {"placeable-player", "player-creation"}
dt4.minable = nil
dt4.max_health = 500
dt4.corpse = "medium-remnants"
dt4.collision_box = {{-5.9, -6.6}, {6.2, 5.5}}
dt4.selection_box = {{-5.9, -6.6}, {6.2, 5.5}}
dt4.flags = {"not-rotatable"}
dt4.order = "a"
dt4.fluid_box =
    {
      base_area = 100,
      height = 100,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
	  pipe_connections = {}
    }
dt4.two_direction_only = true
dt4.window_bounding_box = {{-0.125, 0.6875}, {0.1875, 1.1875}}
dt4.pictures =
    {
      picture =
      {
        sheets =
        {
          {
			  filename = "__Mobile_Factory_Graphics__/graphics/entity/DimensionalTank4.png",
			  priority = "extra-high",
			  frames = 2,
			  width = 219,
			  height = 215,
			  shift = util.by_pixel(10, -3),
			  scale = 2
          },
          {
              filename = "__base__/graphics/entity/storage-tank/hr-storage-tank-shadow.png",
              priority = "extra-high",
              frames = 2,
              width = 291,
              height = 153,
              shift = util.by_pixel(29.75, 22.25),
              scale = 2,
              draw_as_shadow = true
          }
        }
      },
      fluid_background =
      {
        filename = "__base__/graphics/entity/storage-tank/fluid-background.png",
        priority = "extra-high",
        width = 32,
        height = 15,
      },
      window_background =
      {
        filename = "__base__/graphics/entity/storage-tank/window-background.png",
        priority = "extra-high",
        width = 17,
        height = 24,
		scale = 3.5,
		shift = {0.3,2.0}
      },
      flow_sprite =
      {
        filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
        priority = "extra-high",
        width = 160,
        height = 20,
		scale=3,
		shift = {0.3,2.2}
      },
      gas_flow =
      {
        filename = "__base__/graphics/entity/pipe/steam.png",
        priority = "extra-high",
        line_length = 10,
        width = 24,
        height = 15,
        frame_count = 60,
        axially_symmetrical = false,
        direction_count = 1,
        animation_speed = 0.25,
        hr_version =
        {
          filename = "__base__/graphics/entity/pipe/hr-steam.png",
          priority = "extra-high",
          line_length = 10,
          width = 48,
          height = 30,
          frame_count = 60,
          axially_symmetrical = false,
          animation_speed = 0.25,
          direction_count = 1,
          scale = 0.5
        }
      }
    }
dt4.flow_length_in_ticks = 360
dt4.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
dt4.working_sound =
    {
      sound =
      {
          filename = "__base__/sound/storage-tank.ogg",
          volume = 0.8
      },
      match_volume_to_activity = true,
      apparent_volume = 1.5,
      max_sounds_per_type = 3
    }
dt4.circuit_wire_connection_points = circuit_connector_definitions["storage-tank"].points
dt4.circuit_connector_sprites = circuit_connector_definitions["storage-tank"].sprites
dt4.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{dt4}

-- Technology --
local dt4T = {}
dt4T.name = "StorageTankMK1_4"
dt4T.type = "technology"
dt4T.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalTank4.png"
dt4T.icon_size = 32
dt4T.unit = {
	count=1100,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
dt4T.prerequisites = {"StorageTankMK1_3"}
dt4T.effects = {{type="nothing", effect_description={"description.DimensionalTank4"}}, {type="unlock-recipe", recipe="ModuleID4"}}
data:extend{dt4T}


--------- TANK 5 ----------
-- Entity --
dt5T = {}
dt5T.type = "storage-tank"
dt5T.name = "StorageTank5MK1"
dt5T.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalTank5.png"
dt5T.icon_size = 32
dt5T.flags = {"placeable-player", "player-creation"}
dt5T.minable = nil
dt5T.max_health = 500
dt5T.corpse = "medium-remnants"
dt5T.collision_box = {{-5.9, -6.6}, {6.2, 5.5}}
dt5T.selection_box = {{-5.9, -6.6}, {6.2, 5.5}}
dt5T.flags = {"not-rotatable"}
dt5T.order = "a"
dt5T.fluid_box =
    {
      base_area = 100,
      height = 100,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
	  pipe_connections = {}
    }
dt5T.two_direction_only = true
dt5T.window_bounding_box = {{-0.125, 0.6875}, {0.1875, 1.1875}}
dt5T.pictures =
    {
      picture =
      {
        sheets =
        {
          {
			  filename = "__Mobile_Factory_Graphics__/graphics/entity/DimensionalTank5.png",
			  priority = "extra-high",
			  frames = 2,
			  width = 219,
			  height = 215,
			  shift = util.by_pixel(10, -3),
			  scale = 2
          },
          {
              filename = "__base__/graphics/entity/storage-tank/hr-storage-tank-shadow.png",
              priority = "extra-high",
              frames = 2,
              width = 291,
              height = 153,
              shift = util.by_pixel(29.75, 22.25),
              scale = 2,
              draw_as_shadow = true
          }
        }
      },
      fluid_background =
      {
        filename = "__base__/graphics/entity/storage-tank/fluid-background.png",
        priority = "extra-high",
        width = 32,
        height = 15,
      },
      window_background =
      {
        filename = "__base__/graphics/entity/storage-tank/window-background.png",
        priority = "extra-high",
        width = 17,
        height = 24,
		scale = 3.5,
		shift = {0.3,2.0}
      },
      flow_sprite =
      {
        filename = "__base__/graphics/entity/pipe/fluid-flow-low-temperature.png",
        priority = "extra-high",
        width = 160,
        height = 20,
		scale=3,
		shift = {0.3,2.2}
      },
      gas_flow =
      {
        filename = "__base__/graphics/entity/pipe/steam.png",
        priority = "extra-high",
        line_length = 10,
        width = 24,
        height = 15,
        frame_count = 60,
        axially_symmetrical = false,
        direction_count = 1,
        animation_speed = 0.25,
        hr_version =
        {
          filename = "__base__/graphics/entity/pipe/hr-steam.png",
          priority = "extra-high",
          line_length = 10,
          width = 48,
          height = 30,
          frame_count = 60,
          axially_symmetrical = false,
          animation_speed = 0.25,
          direction_count = 1,
          scale = 0.5
        }
      }
    }
dt5T.flow_length_in_ticks = 360
dt5T.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
dt5T.working_sound =
    {
      sound =
      {
          filename = "__base__/sound/storage-tank.ogg",
          volume = 0.8
      },
      match_volume_to_activity = true,
      apparent_volume = 1.5,
      max_sounds_per_type = 3
    }
dt5T.circuit_wire_connection_points = circuit_connector_definitions["storage-tank"].points
dt5T.circuit_connector_sprites = circuit_connector_definitions["storage-tank"].sprites
dt5T.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{dt5T}

-- Technology --
local dt5T = {}
dt5T.name = "StorageTankMK1_5"
dt5T.type = "technology"
dt5T.icon = "__Mobile_Factory_Graphics__/graphics/icones/DimensionalTank5.png"
dt5T.icon_size = 32
dt5T.unit = {
	count=1350,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
dt5T.prerequisites = {"StorageTankMK1_4"}
dt5T.effects = {{type="nothing", effect_description={"description.DimensionalTank5"}}, {type="unlock-recipe", recipe="ModuleID5"}}
data:extend{dt5T}