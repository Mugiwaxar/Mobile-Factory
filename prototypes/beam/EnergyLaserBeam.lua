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
iddleBeam.light_animations =
{
    head =
    {
        filename = "__Mobile_Factory__/graphics/IddleBeamLight.png",
        line_length = 2,
        width = 30,
        height = 30,
        scale = 1.0,
        animation_speed = 0.025,
        frame_count = 2
    }
}
iddleBeam.light_animations.tail = iddleBeam.light_animations.head
iddleBeam.light_animations.body = iddleBeam.light_animations.head
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
mk1ConnectedBeam.light_animations =
{
    head =
    {
        filename = "__Mobile_Factory__/graphics/MK1ConnectedBeamLight.png",
        line_length = 2,
        width = 90,
        height = 90,
        scale = 1/2.7,
        animation_speed = 0.025,
        frame_count = 2
    }
}
mk1ConnectedBeam.light_animations.tail = mk1ConnectedBeam.light_animations.head
mk1ConnectedBeam.light_animations.body = mk1ConnectedBeam.light_animations.head
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
mk1SendBeam.light_animations =
{
    head =
    {
        filename = "__Mobile_Factory__/graphics/MK1SendBeamLight.png",
        line_length = 4,
        width = 90,
        height = 90,
        scale = 1/2.7,
        animation_speed = 0.4,
        frame_count = 4
    }
}
mk1SendBeam.light_animations.tail = mk1SendBeam.light_animations.head
mk1SendBeam.light_animations.body = mk1SendBeam.light_animations.head
data:extend{mk1SendBeam}

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
iddleBeam.light_animations =
{
    head =
    {
        filename = "__Mobile_Factory__/graphics/IddleBeamLight.png",
        line_length = 2,
        width = 30,
        height = 30,
        scale = 1.0,
        animation_speed = 0.025,
        frame_count = 2
    }
}
iddleBeam.light_animations.tail = iddleBeam.light_animations.head
iddleBeam.light_animations.body = iddleBeam.light_animations.head
data:extend{iddleBeam}


-- Quatron Laser MK1 --

-- Connected Beam --
local mk1QuatronConnectedBeam = {}
mk1QuatronConnectedBeam.type = "beam"
mk1QuatronConnectedBeam.name = "MK1QuatronConnectedBeam"
mk1QuatronConnectedBeam.flags = {"not-on-map"}
mk1QuatronConnectedBeam.width = 1
mk1QuatronConnectedBeam.damage_interval = 20   
mk1QuatronConnectedBeam.random_target_offset = true
mk1QuatronConnectedBeam.action_triggered_automatically = false
mk1QuatronConnectedBeam.action = nil
mk1QuatronConnectedBeam.head =
{
    filename = "__Mobile_Factory__/graphics/mk1QuatronConnectedBeam.png",
    flags = beam_non_light_flags,
    line_length = 2,
    width = 90,
    height = 90,
    frame_count = 2,
    scale = 1/2.7,
    animation_speed = 0.025,
    blend_mode = laser_beam_blend_mode
}
mk1QuatronConnectedBeam.tail = mk1QuatronConnectedBeam.head
mk1QuatronConnectedBeam.body = mk1QuatronConnectedBeam.head
mk1QuatronConnectedBeam.light_animations =
{
    head =
    {
        filename = "__Mobile_Factory__/graphics/MK1ConnectedBeamLight.png",
        line_length = 2,
        width = 90,
        height = 90,
        scale = 1/2.7,
        animation_speed = 0.025,
        frame_count = 2
    }
}
mk1QuatronConnectedBeam.light_animations.tail = mk1QuatronConnectedBeam.light_animations.head
mk1QuatronConnectedBeam.light_animations.body = mk1QuatronConnectedBeam.light_animations.head
data:extend{mk1QuatronConnectedBeam}

-- Send Beam --
local mk1QuatronSendBeam = {}
mk1QuatronSendBeam.type = "beam"
mk1QuatronSendBeam.name = "MK1QuatronSendBeam"
mk1QuatronSendBeam.flags = {"not-on-map"}
mk1QuatronSendBeam.width = 1
mk1QuatronSendBeam.damage_interval = 20
mk1QuatronSendBeam.random_target_offset = true
mk1QuatronSendBeam.action_triggered_automatically = false
mk1QuatronSendBeam.action = nil
mk1QuatronSendBeam.head =
{
    filename = "__Mobile_Factory__/graphics/MK1QuatronSendBeam.png",
    flags = beam_non_light_flags,
    line_length = 4,
    width = 90,
    height = 90,
    frame_count = 4,
    scale = 1/2.7,
    animation_speed = 0.4,
    blend_mode = laser_beam_blend_mode
}
mk1QuatronSendBeam.tail = mk1QuatronSendBeam.head
mk1QuatronSendBeam.body = mk1QuatronSendBeam.head
mk1QuatronSendBeam.light_animations =
{
    head =
    {
        filename = "__Mobile_Factory__/graphics/MK1SendBeamLight.png",
        line_length = 4,
        width = 90,
        height = 90,
        scale = 1/2.7,
        animation_speed = 0.4,
        frame_count = 4
    }
}
mk1QuatronSendBeam.light_animations.tail = mk1QuatronSendBeam.light_animations.head
mk1QuatronSendBeam.light_animations.body = mk1QuatronSendBeam.light_animations.head
data:extend{mk1QuatronSendBeam}