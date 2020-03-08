---------------------------- FACTORY TANK ----------------------------

-- Entity --
local ftE = table.deepcopy(data.raw["storage-tank"]["storage-tank"])
ftE.name = "FactoryTank"
ftE.minable = {mining_time = 0.5, result = "FactoryTank"}
ftE.fast_replaceable_group = nil
ftE.next_upgrade = nil
ftE.fluid_box.base_area = 10000
ftE.pictures.picture.sheets[1] = ftE.pictures.picture.sheets[1].hr_version
ftE.pictures.picture.sheets[1].filename = "__Mobile_Factory__/graphics/FactoryTankE.png"
ftE.pictures.picture.sheets[1].hr_version = nil
data:extend{ftE}

-- Item --
local ftI = {}
ftI.type = "item"
ftI.name = "FactoryTank"
ftI.icon = "__Mobile_Factory__/graphics/FactoryTankI.png"
ftI.icon_size = 64
ftI.subgroup = "DimensionalStuff"
ftI.order = "A2"
ftI.place_result = "FactoryTank"
ftI.stack_size = 1
data:extend{ftI}

-- Recipe --
local ftR = {}
ftR.type = "recipe"
ftR.name = "FactoryTank"
ftR.energy_required = 5
ftR.ingredients =
    {
      {"MachineFrame", 5}
    }
ftR.result = "FactoryTank"
data:extend{ftR}