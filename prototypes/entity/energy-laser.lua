---------------------- ENERGY LASER ----------------------

-- Entity --
local el1E = {}
el1E.type = "assembling-machine"
el1E.name = "EnergyLaser1"
el1E.icon = "__Mobile_Factory__/graphics/EnergyLaser1I.png"
el1E.icon_size = 128
el1E.flags = {"placeable-neutral", "placeable-player", "player-creation"}
el1E.minable = {mining_time = 0.2, result = "EnergyLaser1"}
el1E.max_health = 350
el1E.dying_explosion = "medium-explosion"
el1E.corpse = "medium-remnants"
el1E.alert_icon_shift = util.by_pixel(-3, -12)
el1E.resistances =
{
    {
    type = "fire",
    percent = 70
    }
}
el1E.collision_box = {{-0.495, -0.49}, {0.495, 0.45}}
el1E.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
el1E.animation =
{
    north =
    {
        layers =
        {
            {
                filename = "__Mobile_Factory__/graphics/EnergyLaser1E.png",
                priority = "high",
                width = 600,
                height = 600,
                frame_count = 1,
                -- shift = {0,-0.3},
                scale = 1/18
            },
            {
                filename = "__Mobile_Factory__/graphics/EnergyLaser1S.png",
                priority = "high",
                width = 600,
                height = 600,
                frame_count = 1,
                draw_as_shadow = true,
                -- shift = {0,-0.3},
                scale = 1/18
            }
        }
    }
}
el1E.animation.east = table.deepcopy(el1E.animation.north)
el1E.animation.east.layers[1].x = 600
el1E.animation.south = table.deepcopy(el1E.animation.north)
el1E.animation.south.layers[1].x = 1200
el1E.animation.west = table.deepcopy(el1E.animation.north)
el1E.animation.west.layers[1].x = 1800
el1E.crafting_categories = {"Nothing"}
el1E.crafting_speed = 1
el1E.energy_source =
{
    type = "electric",
    usage_priority = "secondary-input",
    buffer_capacity = "1MJ",
    output_flow_limit = "0.0001W",
    input_flow_limit = "0.0001W",
    drain = "0J",
    render_no_power_icon = false,
    render_no_network_icon = false
}
el1E.energy_usage = "1MJ"
el1E.fluid_boxes = {
    {
        base_level = 1,
        pipe_connections = {
            {
                position = {
                    0,
                    -1
                }
            }
        },
        production_type = "output",
    }
}
data:extend{el1E}

-- Item --
local el1I = {}
el1I.type = "item"
el1I.name = "EnergyLaser1"
el1I.icon = "__Mobile_Factory__/graphics/EnergyLaser1I.png"
el1I.icon_size = 128
el1I.place_result = "EnergyLaser1"
el1I.subgroup = "Energy"
el1I.order = "a1"
el1I.stack_size = 20
data:extend{el1I}

-- Recipe --
local el1R = {}
el1R.type = "recipe"
el1R.name = "EnergyLaser1"
el1R.energy_required = 5
el1R.enabled = false
el1R.ingredients =
{
    {"MachineFrame2", 15},
    {"DimensionalCircuit", 3}
}
el1R.result = "EnergyLaser1"
data:extend{el1R}

---------------------- QUATRON LASER ----------------------

-- Entity --
local ql1E = {}
ql1E.type = "assembling-machine"
ql1E.name = "QuatronLaser1"
ql1E.icon = "__Mobile_Factory__/graphics/QuatronLaser1I.png"
ql1E.icon_size = 128
ql1E.flags = {"placeable-neutral", "placeable-player", "player-creation"}
ql1E.minable = {mining_time = 0.2, result = "QuatronLaser1"}
ql1E.max_health = 350
ql1E.dying_explosion = "medium-explosion"
ql1E.corpse = "medium-remnants"
ql1E.alert_icon_shift = util.by_pixel(-3, -12)
ql1E.resistances =
{
    {
    type = "fire",
    percent = 70
    }
}
ql1E.collision_box = {{-0.495, -0.49}, {0.495, 0.45}}
ql1E.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
ql1E.animation =
{
    north =
    {
        layers =
        {
            {
                filename = "__Mobile_Factory__/graphics/QuatronLaser1E.png",
                priority = "high",
                width = 600,
                height = 600,
                frame_count = 1,
                -- shift = {0,-0.3},
                scale = 1/18
            },
            {
                filename = "__Mobile_Factory__/graphics/EnergyLaser1S.png",
                priority = "high",
                width = 600,
                height = 600,
                frame_count = 1,
                draw_as_shadow = true,
                -- shift = {0,-0.3},
                scale = 1/18
            }
        }
    }
}
ql1E.animation.east = table.deepcopy(ql1E.animation.north)
ql1E.animation.east.layers[1].x = 600
ql1E.animation.south = table.deepcopy(ql1E.animation.north)
ql1E.animation.south.layers[1].x = 1200
ql1E.animation.west = table.deepcopy(ql1E.animation.north)
ql1E.animation.west.layers[1].x = 1800
ql1E.crafting_categories = {"Nothing"}
ql1E.crafting_speed = 1
ql1E.energy_source =
{
    type = "electric",
    usage_priority = "secondary-input",
    buffer_capacity = "1KJ",
    output_flow_limit = "0.0001W",
    input_flow_limit = "0.0001W",
    drain = "0J",
    render_no_power_icon = false,
    render_no_network_icon = false
}
ql1E.energy_usage = "1KJ"
ql1E.fluid_boxes = {
    {
        base_level = 1,
        pipe_connections = {
            {
                position = {
                    0,
                    -1
                }
            }
        },
        production_type = "output",
    }
}
data:extend{ql1E}

-- Item --
local ql1I = {}
ql1I.type = "item"
ql1I.name = "QuatronLaser1"
ql1I.icon = "__Mobile_Factory__/graphics/QuatronLaser1I.png"
ql1I.icon_size = 128
ql1I.place_result = "QuatronLaser1"
ql1I.subgroup = "QuatronLogistic"
ql1I.order = "a1"
ql1I.stack_size = 20
data:extend{ql1I}

-- Recipe --
local ql1R = {}
ql1R.type = "recipe"
ql1R.name = "QuatronLaser1"
ql1R.energy_required = 5
ql1R.enabled = false
ql1R.ingredients =
{
    {"MachineFrame2", 15},
    {"DimensionalCircuit", 3}
}
ql1R.result = "QuatronLaser1"
data:extend{ql1R}