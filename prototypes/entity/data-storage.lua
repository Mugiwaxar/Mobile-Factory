---------------------------------- DATA STORAGE ---------------------------

-- Entity --
dsE = {}
dsE.type = "container"
dsE.name = "DataStorage"
dsE.icon = "__Mobile_Factory__/graphics/matter-serialization/DataStorageI.png"
dsE.icon_size = 64
dsE.flags = {"placeable-neutral", "player-creation"}
dsE.minable = {mining_time = 0.2, result = "DataStorage"}
dsE.max_health = 100
dsE.corpse = "small-remnants"
dsE.render_not_in_network_icon = false
dsE.collision_box = {{-0.8, -0.5}, {0.8, 0.9}}
dsE.selection_box = {{-0.8, -0.5}, {0.8, 1}}
dsE.inventory_size = 0
dsE.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" }
dsE.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" }
dsE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
dsE.picture =
    {
      layers =
      {
        {
            filename = "__Mobile_Factory__/graphics/matter-serialization/DataStorageE.png",
            priority = "extra-high",
            width = 400,
            height = 400,
            -- shift = {-0.5,-1},
            scale = 1/200*30
        },
        {
            filename = "__Mobile_Factory__/graphics/matter-serialization/DataStorageS.png",
            priority = "high",
            width = 400,
            height = 400,
            shift = {0.5,0.7},
            draw_as_shadow = true,
            scale = 1/200*45
        }
      }
    }
dsE.circuit_wire_connection_point =
{
	wire = {red={-0.05,-0.1}, green={0.05,-0.1}},
	shadow = {red={-0.05,0}, green={0.05,0}}
}
dsE.circuit_connector_sprites = nil
dsE.circuit_wire_max_distance = 20
data:extend{dsE}

-- Item --
local dsI = {}
dsI.type = "item"
dsI.name = "DataStorage"
dsI.icon = "__Mobile_Factory__/graphics/matter-serialization/DataStorageI.png"
dsI.icon_size = 64
dsI.place_result = "DataStorage"
dsI.subgroup = "DataSerialization"
dsI.order = "b"
dsI.stack_size = 20
data:extend{dsI}


-- Recipe --
local dsR = {}
dsR.type = "recipe"
dsR.name = "DataStorage"
dsR.energy_required = 4
dsR.enabled = false
dsR.ingredients =
    {
      {"CrystalizedCircuit", 20},
      {"MachineFrame3", 5}
    }
dsR.result = "DataStorage"
data:extend{dsR}

-- Animation --
sdA = {}
sdA.name = "DataStorageA"
sdA.type = "animation"
sdA.frame_count = 120
sdA.filename = "__Mobile_Factory__/graphics/matter-serialization/DataStorageAn.png"
sdA.size = 200
sdA.line_length = 10
sdA.animation_speed = 1/4
sdA.scale = 1/5
sdA.flags = {"terrain"}
data:extend{sdA}