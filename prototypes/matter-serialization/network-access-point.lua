----------------------------------------------------- NETWORK ACCESS POINT -----------------------------------------------------
-- Entity --
local napE = {}
napE.flags = {"placeable-neutral", "player-creation", "not-rotatable"}
napE.type = "constant-combinator"
napE.name = "NetworkAccessPoint"
napE.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/NetworkAccessPointI.png"
napE.icon_size = 64
napE.minable = {mining_time = 0.8, result = "NetworkAccessPoint"}
napE.max_health = 300
napE.corpse = "big-remnants"
napE.collision_box = {{-1.8, -1.8}, {1.8, 1.8}}
napE.selection_box = napE.collision_box
napE.item_slot_count = 999
napE.circuit_wire_max_distance = 100
napE.circuit_connector_sprites = nil
napE.activity_led_sprites = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"]).activity_led_sprites
napE.activity_led_light_offsets = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"]).activity_led_light_offsets
napE.sprites =
{
    sheets =
    {
        {
            filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/NetworkAccessPointE.png",
            width = 400,
            height = 400,
            shift = {0,-0.2},
            scale = 1/10 * 3.2,
            frames = 1
        },
        {
            filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/NetworkAccessPointS.png",
            width = 400,
            height = 400,
            shift = {1.8,0.4},
            draw_as_shadow = true,
            scale = 1/10 * 3.2,
            frames = 1
        }
    }
}
napE.circuit_wire_connection_points =
{
	{
        wire = {green={-0.05,0.82}, red={0.05,0.82}},
        shadow = {green={-0.05,0.85}, red={0.05,0.85}}
    },
    {
        wire = {green={-0.05,0.82}, red={0.05,0.82}},
        shadow = {green={-0.05,0.85}, red={0.05,0.85}}
    },
    {
        wire = {green={-0.05,0.82}, red={0.05,0.82}},
        shadow = {green={-0.05,0.85}, red={0.05,0.85}}
    },
    {
        wire = {green={-0.05,0.82}, red={0.05,0.82}},
        shadow = {green={-0.05,0.85}, red={0.05,0.85}}
    }
}
data:extend{napE}

-- Item --
local napI = {}
napI.type = "item"
napI.name = "NetworkAccessPoint"
napI.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/NetworkAccessPointI.png"
napI.icon_size = 64
napI.place_result = "NetworkAccessPoint"
napI.subgroup = "DataSerialization"
napI.order = "a"
napI.stack_size = 10
data:extend{napI}

-- Recipe --
local napR = {}
napR.type = "recipe"
napR.name = "NetworkAccessPoint"
napR.energy_required = 6
napR.enabled = true
napR.ingredients =
    {
      {"CrystalizedCircuit", 18},
      {"MachineFrame3", 6}
    }
    napR.result = "NetworkAccessPoint"
data:extend{napR}

-- Animation --
local napA = {}
napA.name = "NetworkAccessPointA"
napA.type = "animation"
napA.frame_count = 60
napA.filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/NetworkAccessPointA.png"
napA.size = 500
napA.line_length = 10
napA.animation_speed = 1/6
napA.scale = 1/8 * 3.2
napA.flags = {"terrain"}
data:extend{napA}