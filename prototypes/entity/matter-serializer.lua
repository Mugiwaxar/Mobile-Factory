---------------------------------- MATTER SERIALIZER ---------------------------

-- Entity --
msE = {}
msE.type = "logistic-container"
msE.name = "MatterSerializer"
msE.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/MatterSerializerI.png"
msE.icon_size = 64
msE.flags = {"placeable-neutral", "player-creation"}
msE.minable = {mining_time = 0.5, result = "MatterSerializer"}
msE.max_health = 100
msE.corpse = "small-remnants"
msE.logistic_mode = "requester"
msE.logistic_slots_count = 1
msE.render_not_in_network_icon = false
msE.collision_box = {{-0.35, -0.35}, {0.35, 0.35}}
msE.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
msE.inventory_size = 1
msE.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" }
msE.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" }
msE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
msE.picture =
    {
      layers =
      {
        {
            filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/MatterSerializerE.png",
            priority = "extra-high",
            width = 400,
            height = 400,
            shift = {0,0},
            scale = 1/400*33
        },
        {
            filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/MatterSerializerS.png",
            priority = "high",
            width = 400,
            height = 400,
            shift = {0.4,0},
            draw_as_shadow = true,
            scale = 1/400*38
        }
      }
    }
msE.circuit_wire_connection_point =
{
	wire = {red={0,0.08}, green={0,0.08}},
	shadow = {red={0,0.08}, green={0,0.08}}
}
msE.circuit_connector_sprites = nil
msE.circuit_wire_max_distance = 20
data:extend{msE}

-- Item --
local msI = {}
msI.type = "item"
msI.name = "MatterSerializer"
msI.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/MatterSerializerI.png"
msI.icon_size = 64
msI.place_result = "MatterSerializer"
msI.subgroup = "DataSerialization"
msI.order = "c"
msI.stack_size = 20
data:extend{msI}


-- Recipe --
local msR = {}
msR.type = "recipe"
msR.name = "MatterSerializer"
msR.energy_required = 2
msR.enabled = false
msR.ingredients =
    {
      {"CrystalizedCircuit", 8},
      {"MachineFrame3", 2}
    }
msR.result = "MatterSerializer"
data:extend{msR}

-- Animation --
mpA = {}
mpA.name = "MatterSerializerA"
mpA.type = "animation"
mpA.frame_count = 80
mpA.filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/MatterSerializerAn.png"
mpA.width = 400
mpA.height = 300
mpA.line_length = 10
mpA.animation_speed = 1/4
mpA.scale = 1/400*33
mpA.flags = {"terrain"}
data:extend{mpA}