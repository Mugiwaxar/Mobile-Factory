------------------------- YELLOW BEAM ---------------------------
beam_tint = {r=255, g=255, b=255}
light_tint = {r=255, g=255, b=255}

ylE = {}
ylE.name = "BlueBeam"
ylE.type = "beam"
ylE.flags = {"not-on-map"}
ylE.damage_interval = 20
ylE.random_target_offset = true
ylE.action_triggered_automatically = false
ylE.width = 0.5
ylE.frame_count = 16
ylE.direction_count = 1
ylE.shift = {-0.03125, 0}

ylE.ending =
    {
        filename = "__base__/graphics/entity/beam/hr-tileable-beam-END.png",
        flags = beam_flags or beam_non_light_flags,
        line_length = 4,
        width = 91,
        height = 93,
        frame_count = 16,
        direction_count = 1,
        shift = {-0.078125, -0.046875},
        tint = beam_tint,
        scale = 0.5
    }
ylE.head =
    {
      filename = "__base__/graphics/entity/beam/beam-head.png",
      flags = beam_flags or beam_non_light_flags,
      line_length = 16,
      width = 45 - 7,
      height = 39,
      frame_count = 16,
      shift = util.by_pixel(-7/2, 0),
      tint = beam_tint,
      blend_mode = blend_mode or beam_blend_mode
    }
ylE.tail =
    {
      filename = "__base__/graphics/entity/beam/beam-tail.png",
      flags = beam_flags or beam_non_light_flags,
      line_length = 16,
      width = 45 - 6,
      height = 39,
      frame_count = 16,
      shift = util.by_pixel(6/2, 0),
      tint = beam_tint,
      blend_mode = blend_mode or beam_blend_mode
    }
ylE.body =
    {
      {
        filename = "__base__/graphics/entity/beam/beam-body-1.png",
        flags = beam_flags or beam_non_light_flags,
        line_length = 16,
        width = 32,
        height = 39,
        frame_count = 16,
        tint = beam_tint,
        blend_mode = blend_mode or beam_blend_mode
      },
      {
        filename = "__base__/graphics/entity/beam/beam-body-2.png",
        flags = beam_flags or beam_non_light_flags,
        line_length = 16,
        width = 32,
        height = 39,
        frame_count = 16,
		tint = beam_tint,
        blend_mode = blend_mode or beam_blend_mode
      },
      {
        filename = "__base__/graphics/entity/beam/beam-body-3.png",
        flags = beam_flags or beam_non_light_flags,
        line_length = 16,
        width = 32,
        height = 39,
        frame_count = 16,
		tint = beam_tint,
        blend_mode = blend_mode or beam_blend_mode
      },
      {
        filename = "__base__/graphics/entity/beam/beam-body-4.png",
        flags = beam_flags or beam_non_light_flags,
        line_length = 16,
        width = 32,
        height = 39,
        frame_count = 16,
		tint = beam_tint,
        blend_mode = blend_mode or beam_blend_mode
      },
      {
        filename = "__base__/graphics/entity/beam/beam-body-5.png",
        flags = beam_flags or beam_non_light_flags,
        line_length = 16,
        width = 32,
        height = 39,
        frame_count = 16,
		tint = beam_tint,
        blend_mode = blend_mode or beam_blend_mode
      },
      {
        filename = "__base__/graphics/entity/beam/beam-body-6.png",
        flags = beam_flags or beam_non_light_flags,
        line_length = 16,
        width = 32,
        height = 39,
        frame_count = 16,
		tint = beam_tint,
        blend_mode = blend_mode or beam_blend_mode
      }
    }
ylE.light_animations =
    {
      start =
      {
        filename = "__base__/graphics/entity/beam/hr-tileable-beam-START-light.png",
        line_length = 4,
        width = 94,
        height = 66,
        frame_count = 16,
        direction_count = 1,
        shift = {0.53125, 0},
        scale = 0.5,
        tint = light_tint
      },

      ending =
      {
        filename = "__base__/graphics/entity/beam/hr-tileable-beam-END-light.png",
        line_length = 4,
        width = 91,
        height = 93,
        frame_count = 16,
        direction_count = 1,
        shift = {-0.078125, -0.046875},
        scale = 0.5,
        tint = light_tint
      },

      head =
      {
        filename = "__base__/graphics/entity/beam/beam-head-light.png",
        line_length = 16,
        width = 45 - 7,
        height = 39,
        frame_count = 16,
        shift = util.by_pixel(-7/2, 0),
        tint = light_tint
      },

      tail =
      {
        filename = "__base__/graphics/entity/beam/beam-tail-light.png",
        line_length = 16,
        width = 45 - 6,
        height = 39,
        shift = util.by_pixel(6/2, 0),
        frame_count = 16,
        tint = light_tint
      },

      body =
      {
        {
          filename = "__base__/graphics/entity/beam/beam-body-1-light.png",
          line_length = 16,
          width = 32,
          height = 39,
          frame_count = 16,
          tint = light_tint
        },
        {
          filename = "__base__/graphics/entity/beam/beam-body-2-light.png",
          line_length = 16,
          width = 32,
          height = 39,
          frame_count = 16,
          tint = light_tint
        },
        {
          filename = "__base__/graphics/entity/beam/beam-body-3-light.png",
          line_length = 16,
          width = 32,
          height = 39,
          frame_count = 16,
          tint = light_tint
        },
        {
          filename = "__base__/graphics/entity/beam/beam-body-4-light.png",
          line_length = 16,
          width = 32,
          height = 39,
          frame_count = 16,
          tint = light_tint
        },
        {
          filename = "__base__/graphics/entity/beam/beam-body-5-light.png",
          line_length = 16,
          width = 32,
          height = 39,
          frame_count = 16,
          tint = light_tint
        },
        {
          filename = "__base__/graphics/entity/beam/beam-body-6-light.png",
          line_length = 16,
          width = 32,
          height = 39,
          frame_count = 16,
          tint = light_tint
        }
      }
    }
ylE.working_sound =
    {
      sound =
      {
        filename = "__base__/sound/fight/electric-beam.ogg",
        volume = 1
      },
      max_sounds_per_type = 4
    }
data:extend{ylE}