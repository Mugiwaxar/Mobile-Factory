---------------------------------- ERYA COLLECTOR ---------------------------

-- Entity --
ecE = {}
ecE.type = "assembling-machine"
ecE.name = "EryaCollector"
ecE.icon = "__Mobile_Factory_Graphics__/graphics/Erya/EryaCollectorI.png"
ecE.icon_size = 256
ecE.flags = {"placeable-neutral", "player-creation", "not-rotatable"}
ecE.minable = {mining_time = 0.2, result = "EryaCollector"}
ecE.max_health = 100
ecE.corpse = "small-remnants"
ecE.collision_box = {{-2.5, -2.35}, {2.5, 2.35}}
ecE.selection_box = ecE.collision_box
ecE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
ecE.energy_usage = "250kW"
ecE.crafting_speed = 1
ecE.crafting_categories = {"EryaPowder"}
ecE.collision_mask = {"ground-tile"}
ecE.fixed_recipe = "EryaPowder2"
ecE.energy_source =
{
    type="electric",
    buffer_capacity = "3MJ",
    usage_priority = "secondary-input",
    input_flow_limit = "500KW"

}
ecE.animation =
{
    layers =
    {
        {
        frame_count = 60,
        filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaCollectorE.png",
        size = 600,
        line_length = 10,
        animation_speed = 0.5,
        scale = 0.35
        },
        {
            frame_count = 1,
            line_length = 1,
            repeat_count = 60,
            filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaCollectorS.png",
            size = 600,
            scale = 0.35,
            shift = {0.3, 0.2},
            draw_as_shadow = true
        }
    }
}
data:extend{ecE}

-- Item --
local ecI = {}
ecI.type = "item"
ecI.name = "EryaCollector"
ecI.icon = "__Mobile_Factory_Graphics__/graphics/Erya/EryaCollectorI.png"
ecI.icon_size = 256
ecI.place_result = "EryaCollector"
ecI.subgroup = "DimensionalStuff"
ecI.order = "z"
ecI.stack_size = 10
data:extend{ecI}

-- Recipe --
local ecR = {}
ecR.type = "recipe"
ecR.name = "EryaCollector"
ecR.energy_required = 2
ecR.enabled = false
ecR.ingredients =
    {
      {"DimensionalCircuit", 10},
      {"MachineFrame2", 2}
    }
ecR.result = "EryaCollector"
data:extend{ecR}