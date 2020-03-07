---------------------------- FACTORY CHEST ----------------------------

-- Entity --
local mfC = table.deepcopy(data.raw.container["compilatron-chest"])
mfC.name = "FactoryChest"
mfC.icon_size = 40
mfC.minable = {mining_time = 0.5, result = "FactoryChest"}
mfC.collision_box = {{-2, -2}, {2, 2}}
mfC.selection_box = {{-2, -2}, {2, 2}}
mfC.fast_replaceable_group = nil
mfC.inventory_size = 20
mfC.picture.layers[1].scale = 4
mfC.picture.layers[1].hr_version.scale = 2
data:extend{mfC}

-- Item --
local fcI = {}
fcI.type = "item"
fcI.name = "FactoryChest"
fcI.icon = "__Mobile_Factory__/graphics/FactoryChestI.png"
fcI.icon_size = 40
fcI.subgroup = "DimensionalStuff"
fcI.order = "A"
fcI.place_result = "FactoryChest"
fcI.stack_size = 1
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