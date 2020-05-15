----------------- ENERGY LASER BEAM -----------------

-- General Iddle Beam --
local iddleBeam = {}
iddleBeam.type = "beam"
iddleBeam.name = "IddleBeam"
iddleBeam.flags = {"not-on-map"}
iddleBeam.width = 1
iddleBeam.damage_interval = 20
iddleBeam.random_target_offset = true
iddleBeam.action_triggered_automatically = false
iddleBeam.action = nil
iddleBeam.head =
{
    filename = "__Mobile_Factory__/graphics/IddleBeam.png",
    flags = beam_non_light_flags,
    line_length = 2,
    width = 30,
    height = 30,
    frame_count = 2,
    scale = 1.0,
    animation_speed = 0.025,
    blend_mode = laser_beam_blend_mode
}
iddleBeam.tail = iddleBeam.head
iddleBeam.body = iddleBeam.head
data:extend{iddleBeam}


-- Energy Laser MK1 --

-- Connected Beam --
local mk1ConnectedBeam = {}
mk1ConnectedBeam.type = "beam"
mk1ConnectedBeam.name = "MK1ConnectedBeam"
mk1ConnectedBeam.flags = {"not-on-map"}
mk1ConnectedBeam.width = 1
mk1ConnectedBeam.damage_interval = 20
mk1ConnectedBeam.random_target_offset = true
mk1ConnectedBeam.action_triggered_automatically = false
mk1ConnectedBeam.action = nil
mk1ConnectedBeam.head =
{
    filename = "__Mobile_Factory__/graphics/MK1ConnectedBeam.png",
    flags = beam_non_light_flags,
    line_length = 2,
    width = 90,
    height = 90,
    frame_count = 2,
    scale = 1/2.7,
    animation_speed = 0.025,
    blend_mode = laser_beam_blend_mode
}
mk1ConnectedBeam.tail = mk1ConnectedBeam.head
mk1ConnectedBeam.body = mk1ConnectedBeam.head
data:extend{mk1ConnectedBeam}

-- Send Beam --
local mk1SendBeam = {}
mk1SendBeam.type = "beam"
mk1SendBeam.name = "MK1SendBeam"
mk1SendBeam.flags = {"not-on-map"}
mk1SendBeam.width = 1
mk1SendBeam.damage_interval = 20
mk1SendBeam.random_target_offset = true
mk1SendBeam.action_triggered_automatically = false
mk1SendBeam.action = nil
mk1SendBeam.head =
{
    filename = "__Mobile_Factory__/graphics/MK1SendBeam.png",
    flags = beam_non_light_flags,
    line_length = 4,
    width = 90,
    height = 90,
    frame_count = 4,
    scale = 1/2.7,
    animation_speed = 0.4,
    blend_mode = laser_beam_blend_mode
}
mk1SendBeam.tail = mk1SendBeam.head
mk1SendBeam.body = mk1SendBeam.head
data:extend{mk1SendBeam}