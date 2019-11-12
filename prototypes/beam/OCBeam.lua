ocB = {}
ocB.name = "OCBeam"
ocB.type = "beam"
ocB.flags = {"not-on-map"}
ocB.damage_interval = 20
ocB.random_target_offset = false
ocB.action_triggered_automatically = false
ocB.width = 1
ocB.direction_count = 1

ocB.head =
    {
      filename = "__Mobile_Factory__/graphics/Alpha.png",
      width = 1,
      height = 1,
	  line_length = 1,
      frame_count = 20,
	  animation_speed = 1/5
    }
ocB.tail =
    {
      filename = "__Mobile_Factory__/graphics/Alpha.png",
      width = 1,
      height = 1,
	  line_length = 1,
      frame_count = 20,
	  animation_speed = 1/5
    }
ocB.body =
    {
      {
      filename = "__Mobile_Factory__/graphics/beams/beam.png",
      width = 200,
      height = 10,
	  line_length = 1,
      frame_count = 20,
	  animation_speed = 1/5
      }
    }
data:extend{ocB}
