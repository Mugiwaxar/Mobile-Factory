---------------------- ENERGY LASER ----------------------

-- Entity --
local elE = {}
elE.type = "assembling-machine"
elE.name = "EnergyLaser1"
elE.icon = "__Mobile_Factory__/graphics/EnergyLaser1I.png"
elE.icon_size = 128
elE.flags = {"placeable-neutral", "placeable-player", "player-creation"}
elE.minable = {mining_time = 0.2, result = "EnergyLaser1"}
elE.max_health = 350
elE.dying_explosion = "medium-explosion"
elE.corpse = "medium-remnants"
elE.alert_icon_shift = util.by_pixel(-3, -12)
elE.resistances =
{
    {
    type = "fire",
    percent = 70
    }
}
elE.collision_box = {{-0.495, -0.49}, {0.495, 0.45}}
elE.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
elE.animation =
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
elE.animation.east = table.deepcopy(elE.animation.north)
elE.animation.east.layers[1].x = 600
elE.animation.south = table.deepcopy(elE.animation.north)
elE.animation.south.layers[1].x = 1200
elE.animation.west = table.deepcopy(elE.animation.north)
elE.animation.west.layers[1].x = 1800
elE.crafting_categories = {"Nothing"}
elE.crafting_speed = 1
elE.energy_source =
{
    type = "electric",
    usage_priority = "secondary-input",
    buffer_capacity = "5MJ",
    output_flow_limit = "0.0001W",
    input_flow_limit = "0.0001W",
    drain = "0J",
    render_no_power_icon = false,
    render_no_network_icon = false
}
elE.energy_usage = "5MJ"
elE.fluid_boxes = {
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
data:extend{elE}

-- Item --
local elI = {}
elI.type = "item"
elI.name = "EnergyLaser1"
elI.icon = "__Mobile_Factory__/graphics/EnergyLaser1I.png"
elI.icon_size = 128
elI.place_result = "EnergyLaser1"
elI.subgroup = "Energy"
elI.order = "a1"
elI.stack_size = 20
data:extend{elI}

-- Recipe --
local elR = {}
elR.type = "recipe"
elR.name = "EnergyLaser1"
elR.energy_required = 5
elR.enabled = true
elR.ingredients =
{
    {"MachineFrame2", 15},
    {"DimensionalCircuit", 3}
}
elR.result = "EnergyLaser1"
data:extend{elR}