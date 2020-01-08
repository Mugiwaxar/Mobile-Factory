-- Create Big Chest entity (Copy from base Chest) --
-- Entity --
mfC = {} table.deepcopy("data.raw.container.iron-chest")
mfC.type = "container"
mfC.name = "FactoryChest"
mfC.icon = "__base__/graphics/icons/iron-chest.png"
mfC.order = "z"
mfC.icon_size = 32
mfC.flags = {"placeable-neutral", "player-creation"}
mfC.minable = {mining_time = 0.5, result = "FactoryChest"}
mfC.max_health = 200
mfC.corpse = "small-remnants"
mfC.open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 }
mfC.close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 }
mfC.resistances ={}
mfC.collision_box = {{-2, -2}, {2, 2}}
mfC.selection_box = {{-2, -2}, {2, 2}}
mfC.fast_replaceable_group = "container"
mfC.inventory_size = 20
mfC.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
mfC.picture =
    {
      layers =
      {
        {
            filename = "__Mobile_Factory__/graphics/entity/FactoryChest.png",
            priority = "extra-high",
            width = 66,
            height = 76,
            shift = util.by_pixel(-0.5, -0.5),
            scale = 2
        }
      }
    }
mfC.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
mfC.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
mfC.circuit_wire_max_distance = default_circuit_wire_max_distance
data:extend{mfC}

-- Item --
local fcI = {}
fcI.type = "item"
fcI.name = "FactoryChest"
fcI.icon = "__Mobile_Factory__/graphics/icones/FactoryChest.png"
fcI.icon_size = 32
fcI.subgroup = "DimensionalStuff"
fcI.order = "A"
fcI.place_result = "FactoryChest"
fcI.stack_size = 10
data:extend{fcI}

-- Recipe --
local fcR = {}
fcR.type = "recipe"
fcR.name = "FactoryChest"
fcR.energy_required = 5
fcR.ingredients =
    {
      {"MachineFrame", 5}
    }
fcR.result = "FactoryChest"
data:extend{fcR}