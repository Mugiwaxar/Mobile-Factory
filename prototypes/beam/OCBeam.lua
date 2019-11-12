ocB = {}
ocB.name = "OCBeam"
ocB.type = "beam"
ocB.flags = {"not-on-map"}
ocB.damage_interval = 20
ocB.random_target_offset = false
ocB.action_triggered_automatically = false
ocB.width = 2
ocB.direction_count = 1

ocB.head =
    {
      filename = "__Mobile_Factory__/graphics/Alpha.png",
      width = 1,
      height = 1,
	  line_length = 10,
      frame_count = 10,
	  animation_speed = 1/15,
	  scale = 2
    }
ocB.tail =
    {
      filename = "__Mobile_Factory__/graphics/Alpha.png",
      width = 1,
      height = 1,
	  line_length = 10,
      frame_count = 10,
	  animation_speed = 1/15,
	  scale = 2
    }
ocB.body =
    {
      {
      filename = "__Mobile_Factory__/graphics/beams/beam.png",
      width = 10,
      height = 10,
	  line_length = 10,
      frame_count = 10,
	  animation_speed = 1/15,
	  scale = 2
      }
    }
data:extend{ocB}
