---------------------- NETWORK CONTROLLER ----------------------

-- Entity --
local ncE = {}
ncE.type = "assembling-machine"
ncE.name = "NetworkController"
ncE.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/NetworkControllerI.png"
ncE.icon_size = 128
ncE.order = "zzz"
ncE.flags = {"placeable-neutral", "placeable-player", "player-creation"}
ncE.minable = nil
ncE.max_health = 350
ncE.dying_explosion = "medium-explosion"
ncE.corpse = "medium-remnants"
ncE.alert_icon_shift = util.by_pixel(-3, -12)
ncE.resistances =
{
    {
    type = "fire",
    percent = 70
    }
}
ncE.collision_box = {{-3.8, -3.5}, {3.8, 3.4}}
ncE.selection_box = ncE.collision_box
ncE.animation =
{
    north =
    {
        layers =
        {
            {
                filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/NetworkControllerE.png",
                priority = "high",
                width = 600,
                height = 600,
                frame_count = 120,
                line_length = 12,
                animation_speed = 0.35,
                shift = {0,-0.3},
                scale = 1/2
            },
            {
                filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/NetworkControllerS.png",
                priority = "high",
                width = 600,
                height = 600,
                frame_count = 1,
                repeat_count = 120,
                animation_speed = 0.35,
                draw_as_shadow = true,
                shift = {0,-0.3},
                scale = 1/2
            }
        }
    }
}
ncE.idle_animation = ncE.animation
ncE.always_draw_idle_animation = true
ncE.match_animation_speed_to_activity = false
ncE.animation = nil
ncE.crafting_categories = {"Nothing"}
ncE.crafting_speed = 1
ncE.energy_source =
{
    type = "void",
    usage_priority = "secondary-input",
    buffer_capacity = "1J",
    output_flow_limit = "1W",
    input_flow_limit = "1W",
    render_no_power_icon = false,
    render_no_network_icon = false
}
ncE.energy_usage = "1J"
data:extend{ncE}

-- Animation --

ncAn =  {}
ncAn.name = "NetworkControllerAn"
ncAn.type = "animation"
ncAn.frame_count = 120
ncAn.filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/NetworkControllerE.png"
ncAn.width = 600
ncAn.height = 600
ncAn.line_length = 12
ncAn.animation_speed = 1/4
ncAn.scale = 1/2
ncAn.shift = {0,-0.3}
ncAn.flags = {"terrain"}
data:extend{ncAn}