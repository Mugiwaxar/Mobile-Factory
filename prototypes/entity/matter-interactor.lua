----------------------------------- FLUID INTERACTOR -----------------------------------

-- Entity --
miE = table.deepcopy(data.raw.container["iron-chest"])
miE.name = "MatterInteractor"
miE.minable = {mining_time = 0.2, result = "MatterInteractor"}
miE.inventory_size = 1
-- miE.flags = {"not-rotatable"}
-- miE.collision_box = {{-1.5, -1.5}, {1.5, 1.5}}
-- miE.selection_box = fiE.collision_box
miE.fast_replaceable_group = nil
miE.next_upgrade = nil
miE.picture =
    {
      layers =
      {
        {
            filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/MatterInteractorE.png",
            priority = "extra-high",
            width = 300,
            height = 300,
            shift = {0,-0.2},
            scale = 1/6.20
        },
        {
            filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/MatterInteractorS.png",
            priority = "high",
            width = 300,
            height = 300,
            shift = {0,-0.2},
            scale = 1/6.20,
            draw_as_shadow = true
        }
      }
    }
miE.circuit_connector_sprites = nil
miE.circuit_wire_max_distance = 20
data:extend{miE}

-- Item --
local miI = {}
miI.type = "item"
miI.name = "MatterInteractor"
miI.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/MatterInteractorI.png"
miI.icon_size = 128
miI.place_result = "MatterInteractor"
miI.subgroup = "DataSerialization"
miI.order = "e1"
miI.stack_size = 30
data:extend{miI}

-- Recipe --
local miR = {}
miR.type = "recipe"
miR.name = "MatterInteractor"
miR.energy_required = 4
miR.enabled = false
miR.ingredients =
    {
        {"CrystalizedCircuit", 8},
        {"MachineFrame3", 2}
    }
miR.result = "MatterInteractor"
data:extend{miR}

-- Create all Sprite --
local miS1 = {}
miS1.type = "sprite"
miS1.name = "MatterInteractorSprite1"
miS1.filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/MatterInteractorSprite1.png"
miS1.size = 300
miS1.shift = {0,-0.2}
miS1.scale = 1/6.20
data:extend{miS1}

local miS2 = {}
miS2.type = "sprite"
miS2.name = "MatterInteractorSprite2"
miS2.filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/MatterInteractorSprite2.png"
miS2.size = 300
miS2.shift = {0,-0.2}
miS2.scale = 1/6.20
data:extend{miS2}