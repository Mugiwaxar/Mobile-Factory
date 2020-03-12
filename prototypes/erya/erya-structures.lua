function createEryaItem(name, iconSize, subgroup, order, stackSize, REnergy, RIngredients, TUnit, prerequisites, resultCount)
    local erI = {}
    erI.type = "item"
    erI.name = name
    erI.icon = "__Mobile_Factory_Graphics__/graphics/Erya/" .. name .. "I.png"
    erI.icon_size = iconSize
    erI.place_result = name
    erI.subgroup = subgroup
    erI.order = order
    erI.stack_size = stackSize
    data:extend{erI}

    local erR = {}
    erR.name = name
    erR.type = "recipe"
    erR.energy_required = REnergy
    erR.enabled = false
    erR.ingredients = RIngredients
    erR.result = name
    erR.result_count = resultCount
    data:extend{erR}

    local erT = {}
    erT.name = name
    erT.type = "technology"
    erT.icon = "__Mobile_Factory_Graphics__/graphics/Erya/" .. name .. "I.png"
    erT.icon_size = iconSize
    erT.unit = TUnit
    erT.prerequisites = {prerequisites}
    erT.effects =
    {
        {type="unlock-recipe", recipe=name}
    }
    data:extend{erT}

end

-- Frozen Mist Animation --
local fmA = {}
fmA.name = "FrozenMistA"
fmA.type = "animation"
fmA.frame_count = 1
fmA.filename = "__Mobile_Factory_Graphics__/graphics/Erya/FrozenMistA.png"
fmA.priority = "high"
fmA.flags = {"smoke"}
fmA.size = 200
fmA.line_length = 1
fmA.blend_mode = "normal"
-- fmA.tint = {r=1, g=1, b=1, a=0.1}
-- fmA.animation_speed = 1/45
fmA.scale = 0.1
data:extend{fmA}

-- Erya Lamp --
erlE = table.deepcopy(data.raw.lamp["small-lamp"])
erlE.name = "EryaLamp"
erlE.energy_source = {type="void"}
erlE.minable = {mining_time = 0.1, result = "EryaLamp"}
erlE.glow_size=10
erlE.light.intensity = 0.5
erlE.always_on = true
erlE.picture_off.layers[1] = erlE.picture_off.layers[1].hr_version
erlE.picture_off.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaLampE.png"
erlE.picture_off.layers[2] = erlE.picture_off.layers[2].hr_version
data:extend{erlE}

createEryaItem
(
    "EryaLamp",
    64,
    "EryaLogistic",
    "a",
    50,
    0.5,
    {{"EryaMachineFrame1",1},{"EryaCircuit",1}},
    {count=120,time=1,ingredients={{"EryaSample", 1}}},
    "Erya"
)


-- Erya Chest --
local ercE = table.deepcopy(data.raw.container["steel-chest"])
ercE.name = "EryaChest1"
ercE.minable = {mining_time = 0.2, result = "EryaChest1"}
ercE.picture =
{
    filename="__Mobile_Factory_Graphics__/graphics/Erya/EryaChest1E.png",
    width=64,
    height=80,
    scale=0.5
}
ercE.inventory_size = 35
data:extend{ercE}

createEryaItem
(
    "EryaChest1",
    64,
    "EryaLogistic",
    "b",
    50,
    0.5,
    {{"EryaMachineFrame1",1},{"EryaPlate",3}},
    {count=100,time=1,ingredients={{"EryaSample", 1}}},
    "Erya"
)

-- Erya Tank --
local erTE = table.deepcopy(data.raw["storage-tank"]["storage-tank"])
erTE.name = "EryaTank1"
erTE.minable = {mining_time = 0.3, result = "EryaTank1"}
erTE.pictures.picture.sheets[1] = erTE.pictures.picture.sheets[1].hr_version
erTE.pictures.picture.sheets[1].filename = "__Mobile_Factory__/graphics/EryaTank1E.png"
erTE.pictures.picture.sheets[1].hr_version = nil
erTE.fluid_box.base_area = 400
data:extend{erTE}

createEryaItem
(
    "EryaTank1",
    64,
    "EryaLogistic",
    "c",
    20,
    0.5,
    {{"EryaMachineFrame1",2},{"EryaPlate",5}},
    {count=120,time=1,ingredients={{"EryaSample", 1}}},
    "Erya"
)
data.raw.item.EryaTank1.icon = "__Mobile_Factory__/graphics/EryaTank1I.png"
data.raw.technology.EryaTank1.icon = "__Mobile_Factory__/graphics/EryaTank1I.png"


-- Erya Belt MK1 --
local erbE = table.deepcopy(data.raw["transport-belt"]["transport-belt"])
erbE.name = "EryaBelt1"
erbE.minable = {mining_time = 0.1, result = "EryaBelt1"}
erbE.speed = 0.04
erbE.belt_animation_set.animation_set = erbE.belt_animation_set.animation_set.hr_version
erbE.belt_animation_set.animation_set.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaBelt1E.png"
erbE.belt_animation_set.animation_set.hr_version = nil
data:extend{erbE}

createEryaItem
(
    "EryaBelt1",
    64,
    "EryaLogistic",
    "d",
    200,
    0.2,
    {{"EryaPlate",2}},
    {count=80,time=1,ingredients={{"EryaSample", 1}}},
    "Erya",
    5
)

-- Erya Item Mover --
local eimE = table.deepcopy(data.raw["transport-belt"]["EryaBelt1"])
eimE.name = "EryaItemMover"
eimE.minable = {mining_time = 0.15, result = "EryaBelt1"}
eimE.speed = 0.4
eimE.belt_animation_set.animation_set.filename = "__Mobile_Factory__/graphics/EryaItemMoverE.png"
eimE.belt_animation_set.animation_set.frame_count = 1
eimE.belt_animation_set.animation_set.scale = 0.25
data:extend{eimE}

createEryaItem
(
    "EryaItemMover",
    128,
    "EryaLogistic",
    "d2",
    200,
    0.2,
    {{"EryaPlate",20},{"DimensionalCrystal", 1}},
    {count=280,time=1,ingredients={{"EryaSample", 1}}},
    "EryaBelt1",
    10
)
data.raw.item.EryaItemMover.icon = "__Mobile_Factory__/graphics/EryaItemMoverI.png"
data.raw.technology.EryaItemMover.icon = "__Mobile_Factory__/graphics/EryaItemMoverI.png"


-- Erya Underground Belt MK1 --
local erubE = table.deepcopy(data.raw["underground-belt"]["underground-belt"])
erubE.name = "EryaUndergroundBelt1"
erubE.minable = {mining_time = 0.15, result = "EryaUndergroundBelt1"}
erubE.speed = 0.04
erubE.max_distance = 8
erubE.belt_animation_set = erbE.belt_animation_set
erubE.structure.direction_in.sheet = erubE.structure.direction_in.sheet.hr_version
erubE.structure.direction_in.sheet.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaUndergroundBelt1E.png"
erubE.structure.direction_in.sheet.hr_version = nil
erubE.structure.direction_out.sheet = erubE.structure.direction_out.sheet.hr_version
erubE.structure.direction_out.sheet.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaUndergroundBelt1E.png"
erubE.structure.direction_out.sheet.hr_version = nil
erubE.structure.direction_in_side_loading.sheet = erubE.structure.direction_in_side_loading.sheet.hr_version
erubE.structure.direction_in_side_loading.sheet.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaUndergroundBelt1E.png"
erubE.structure.direction_in_side_loading.sheet.hr_version = nil
erubE.structure.direction_out_side_loading.sheet = erubE.structure.direction_out_side_loading.sheet.hr_version
erubE.structure.direction_out_side_loading.sheet.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaUndergroundBelt1E.png"
erubE.structure.direction_out_side_loading.sheet.hr_version = nil
data:extend{erubE}

createEryaItem
(
    "EryaUndergroundBelt1",
    64,
    "EryaLogistic",
    "e",
    100,
    0.3,
    {{"EryaPlate",10}},
    {count=130,time=1,ingredients={{"EryaSample", 1}}},
    "EryaBelt1",
    2
)

-- Erya Extrem Underground Belt --
local erxubE = table.deepcopy(data.raw["underground-belt"].EryaUndergroundBelt1)
erxubE.name = "EryaUndergroundBelt2"
erxubE.minable = {mining_time = 0.15, result = "EryaUndergroundBelt2"}
erxubE.speed = 0.4
erxubE.max_distance = 30
erxubE.belt_animation_set = eimE.belt_animation_set
erxubE.structure.direction_in.sheet.filename = "__Mobile_Factory__/graphics/EryaUndergroundBelt2E.png"
erxubE.structure.direction_out.sheet.filename = "__Mobile_Factory__/graphics/EryaUndergroundBelt2E.png"
erxubE.structure.direction_in_side_loading.sheet.filename = "__Mobile_Factory__/graphics/EryaUndergroundBelt2E.png"
erxubE.structure.direction_out_side_loading.sheet.filename = "__Mobile_Factory__/graphics/EryaUndergroundBelt2E.png"
data:extend{erxubE}

createEryaItem
(
    "EryaUndergroundBelt2",
    64,
    "EryaLogistic",
    "e",
    100,
    0.5,
    {{"EryaPlate",30},{"DimensionalCrystal",1}},
    {count=10,time=60,ingredients={{"EryaSample", 10},{"DimensionalCrystal",1}}},
    "EryaUndergroundBelt1",
    6
)
data.raw.item.EryaUndergroundBelt2.icon = "__Mobile_Factory__/graphics/EryaUndergroundBelt2I.png"
data.raw.technology.EryaUndergroundBelt2.icon = "__Mobile_Factory__/graphics/EryaUndergroundBelt2I.png"

-- Erya Splitter MK1 --
local erSE = table.deepcopy(data.raw.splitter.splitter)
erSE.name = "EryaSplitter1"
erSE.minable = {mining_time = 0.2, result = "EryaSplitter1"}
erSE.speed = 0.04
erSE.belt_animation_set = erbE.belt_animation_set
erSE.structure.north = erSE.structure.north.hr_version
erSE.structure.north.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaSplitter1NorthE.png"
erSE.structure.north.hr_version = nil
erSE.structure.east = erSE.structure.east.hr_version
erSE.structure.east.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaSplitter1EastE.png"
erSE.structure.east.hr_version = nil
erSE.structure.south = erSE.structure.south.hr_version
erSE.structure.south.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaSplitter1SouthE.png"
erSE.structure.south.hr_version = nil
erSE.structure.west = erSE.structure.west.hr_version
erSE.structure.west.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaSplitter1WestE.png"
erSE.structure.west.hr_version = nil
erSE.structure_patch.east = erSE.structure_patch.east.hr_version
erSE.structure_patch.east.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaSplitter1EastOPE.png"
erSE.structure_patch.east.hr_version = nil
erSE.structure_patch.west = erSE.structure_patch.west.hr_version
erSE.structure_patch.west.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaSplitter1WestEOP.png"
erSE.structure_patch.west.hr_version = nil
data:extend{erSE}

createEryaItem
(
    "EryaSplitter1",
    64,
    "EryaLogistic",
    "f",
    100,
    0.3,
    {{"EryaPlate",12}, {"EryaCircuit",2}},
    {count=150,time=1,ingredients={{"EryaSample", 1}}},
    "EryaBelt1"
)

-- Erya Loader --
local erlE = table.deepcopy(data.raw["loader-1x1"]["loader-1x1"])
erlE.name = "EryaLoader1"
erlE.minable = {mining_time = 0.2, result = "EryaLoader1"}
erlE.speed = 0.04
erlE.belt_animation_set = erbE.belt_animation_set
erlE.structure.direction_in.sheet = nil
erlE.structure.direction_in.sheets =
{
    {
        filename = "__Mobile_Factory__/graphics/loader/EryaLoader1E.png",
        width = 300,
        height = 300,
        scale = 64/375
    }
    -- },
    -- {
    --     filename = "__Mobile_Factory__/graphics/loader/EryaLoader1S.png",
    --     width = 300,
    --     height = 300,
    --     scale = 64/300,
    --     frames = 1,
    --     draw_as_shadow = true,
    --     priority = "low"
    -- }
}
erlE.structure.direction_out.sheet = nil
erlE.structure.direction_out.sheets =
{
    {
        filename = "__Mobile_Factory__/graphics/loader/EryaLoader1E.png",
        width = 300,
        height = 300,
        scale = 64/375,
        y = 300
    }
    -- },
    -- {
    --     filename = "__Mobile_Factory__/graphics/loader/EryaLoader1S.png",
    --     width = 300,
    --     height = 300,
    --     scale = 64/300,
    --     frames = 1,
    --     draw_as_shadow = true,
    --     priority = "low"
    -- }
}
data:extend{erlE}

createEryaItem
(
    "EryaLoader1",
    128,
    "EryaLogistic",
    "g",
    100,
    0.2,
    {{"EryaPlate",10}, {"EryaCircuit",4}},
    {count=130,time=1,ingredients={{"EryaSample", 1}}},
    "EryaBelt1"
)
data.raw.item.EryaLoader1.icon = "__Mobile_Factory__/graphics/loader/EryaLoader1I.png"
data.raw.technology.EryaLoader1.icon = "__Mobile_Factory__/graphics/loader/EryaLoader1I.png"

-- Erya Extrem Loader --
local erxlE = table.deepcopy(data.raw["loader-1x1"].EryaLoader1)
erxlE.name = "EryaLoader2"
erxlE.minable = {mining_time = 0.2, result = "EryaLoader2"}
erxlE.speed = 0.4
erxlE.belt_animation_set = eimE.belt_animation_set
erxlE.structure.direction_in.sheet = nil
erxlE.structure.direction_in.sheets =
{
    {
        filename = "__Mobile_Factory__/graphics/loader/EryaLoader2E.png",
        width = 300,
        height = 300,
        scale = 64/375
    }
    -- },
    -- {
    --     filename = "__Mobile_Factory__/graphics/loader/EryaLoader1S.png",
    --     width = 300,
    --     height = 300,
    --     scale = 64/300,
    --     frames = 1,
    --     draw_as_shadow = true,
    --     priority = "low"
    -- }
}
erxlE.structure.direction_out.sheet = nil
erxlE.structure.direction_out.sheets =
{
    {
        filename = "__Mobile_Factory__/graphics/loader/EryaLoader2E.png",
        width = 300,
        height = 300,
        scale = 64/375,
        y = 300
    }
    -- },
    -- {
    --     filename = "__Mobile_Factory__/graphics/loader/EryaLoader1S.png",
    --     width = 300,
    --     height = 300,
    --     scale = 64/300,
    --     frames = 1,
    --     draw_as_shadow = true,
    --     priority = "low"
    -- }
}
data:extend{erxlE}

createEryaItem
(
    "EryaLoader2",
    128,
    "EryaLogistic",
    "g2",
    100,
    0.4,
    {{"EryaPlate",50}, {"EryaCircuit",20},{"DimensionalCrystal",1}},
    {count=15,time=60,ingredients={{"EryaSample", 12},{"DimensionalCrystal",1}}},
    "EryaLoader1",
    5
)
data.raw.item.EryaLoader2.icon = "__Mobile_Factory__/graphics/loader/EryaLoader2I.png"
data.raw.technology.EryaLoader2.icon = "__Mobile_Factory__/graphics/loader/EryaLoader2I.png"

-- Erya Inserter MK1 --
local eriE = table.deepcopy(data.raw.inserter.inserter)
eriE.name = "EryaInserter1"
eriE.minable = {mining_time = 0.2, result = "EryaInserter1"}
eriE.energy_per_movement = "1J"
eriE.energy_per_rotation = "1J"
eriE.energy_source = {type="void"}
eriE.extension_speed = 0.025
eriE.rotation_speed = 0.012
eriE.hand_base_picture = eriE.hand_base_picture.hr_version
eriE.hand_base_picture.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaInserter1HandE.png"
eriE.hand_base_picture.hr_version = nil
eriE.hand_closed_picture = eriE.hand_closed_picture.hr_version
eriE.hand_closed_picture.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaInserter1HandClosedE.png"
eriE.hand_closed_picture.hr_version = nil
eriE.hand_open_picture = eriE.hand_open_picture.hr_version
eriE.hand_open_picture.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaInserter1HandOpenE.png"
eriE.hand_open_picture.hr_version = nil
eriE.platform_picture.sheet = eriE.platform_picture.sheet.hr_version
eriE.platform_picture.sheet.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaInserter1E.png"
eriE.platform_picture.sheet.hr_version = nil
data:extend{eriE}

createEryaItem
(
    "EryaInserter1",
    64,
    "EryaLogistic",
    "h",
    30,
    0.5,
    {{"EryaMachineFrame1",1}, {"EryaCircuit",4}},
    {count=170,time=1,ingredients={{"EryaSample", 1}}},
    "Erya"
)


-- Erya Mining Drill --
local ermdE = table.deepcopy(data.raw["mining-drill"]["electric-mining-drill"])
ermdE.name = "EryaMiningDrill1"
ermdE.minable = {mining_time = 0.2, result = "EryaMiningDrill1"}
ermdE.mining_speed = 0.2
ermdE.resource_searching_radius = 2.49/2
ermdE.vector_to_place_result = {0, -1.85}
ermdE.energy_usage = "1W"
ermdE.energy_source = {type="void"}
ermdE.animations.north.scale = 1/2
ermdE.animations.north.hr_version.scale = 1/4
ermdE.animations.east.scale = 1/2
ermdE.animations.east.hr_version.scale = 1/4
ermdE.animations.south.scale = 1/2
ermdE.animations.south.hr_version.scale = 1/4
ermdE.animations.west.scale = 1/2
ermdE.animations.west.hr_version.scale = 1/4
ermdE.shadow_animations.north.scale = 1/2
ermdE.shadow_animations.north.hr_version.scale = 1/4
ermdE.shadow_animations.east.scale = 1/2
ermdE.shadow_animations.east.hr_version.scale = 1/4
ermdE.shadow_animations.south.scale = 1/2
ermdE.shadow_animations.south.hr_version.scale = 1/4
ermdE.shadow_animations.west.scale = 1/2
ermdE.shadow_animations.west.hr_version.scale = 1/4
ermdE.collision_box = {{ -1.4/2, -1.4/2}, {1.4/2, 1.4/2}}
ermdE.selection_box = {{ -1.5/2, -1.5/2}, {1.5/2, 1.5/2}}
ermdE.input_fluid_box = nil
data:extend{ermdE}

createEryaItem
(
    "EryaMiningDrill1",
    64,
    "EryaProduction",
    "a",
    30,
    0.7,
    {{"EryaMachineFrame1",2}, {"EryaCircuit",6}, {"EryaPlate",12}},
    {count=230,time=1,ingredients={{"EryaSample", 1}}},
    "Erya"
)

-- Erya Pumpjack MK1 --
local erpE = table.deepcopy(data.raw["mining-drill"].pumpjack)
erpE.name = "EryaPumpjack1"
erpE.minable = {mining_time = 0.2, result = "EryaPumpjack1"}
erpE.energy_usage = "1W"
erpE.energy_source = {type="void"}
erpE.mining_speed = 0.7
erpE.animations.north.layers[1] = erpE.animations.north.layers[1].hr_version
erpE.animations.north.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaPumpjack1E.png"
erpE.animations.north.layers[1].hr_version = nil
erpE.fast_replaceable_group = nil
erpE.next_upgrade = nil
data:extend{erpE}

createEryaItem
(
    "EryaPumpjack1",
    64,
    "EryaProduction",
    "b",
    10,
    0.7,
    {{"EryaMachineFrame1",3}, {"EryaCircuit",2}, {"EryaPlate",15}},
    {count=260,time=1,ingredients={{"EryaSample", 1}}},
    "Erya"
)

-- Erya Assembling Machine MK1 --
local eramE = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-1"])
eramE.name = "EryaAssemblingMachine1"
eramE.minable = {mining_time = 0.2, result = "EryaAssemblingMachine1"}
eramE.energy_usage = "1W"
eramE.energy_source = {type="void"}
eramE.animation.layers[1] = eramE.animation.layers[1].hr_version
eramE.animation.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaAssemblingMachine1E.png"
eramE.animation.layers[1].scale = 0.25
eramE.animation.layers[1].hr_version = nil
eramE.animation.layers[2] = eramE.animation.layers[2].hr_version
eramE.animation.layers[2].scale = 0.25
eramE.animation.layers[2].hr_version = nil
eramE.collision_box = {{-1.2/2, -1.2/2}, {1.2/2, 1.2/2}}
eramE.selection_box = {{-1.5/2, -1.5/2}, {1.5/2, 1.5/2}}
eramE.crafting_speed = 0.3
eramE.fast_replaceable_group = nil
eramE.next_upgrade = nil
data:extend{eramE}

createEryaItem
(
    "EryaAssemblingMachine1",
    64,
    "EryaProduction",
    "c",
    20,
    0.5,
    {{"EryaMachineFrame1",4}, {"EryaCircuit",5}, {"EryaPlate",10}},
    {count=220,time=1,ingredients={{"EryaSample", 1}}},
    "Erya"
)


-- Erya Pipe --
local eramE = table.deepcopy(data.raw.pipe.pipe)
eramE.name = "EryaPipe1"
eramE.minable = {mining_time = 0.1, result = "EryaPipe1"}

eramE.pictures.straight_vertical_single = eramE.pictures.straight_vertical_single.hr_version
eramE.pictures.straight_vertical_single.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-straight-vertical-single.png"
eramE.pictures.straight_vertical_single.hr_version = nil

eramE.pictures.straight_vertical = eramE.pictures.straight_vertical.hr_version
eramE.pictures.straight_vertical.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-straight-vertical.png"
eramE.pictures.straight_vertical.hr_version = nil

eramE.pictures.straight_vertical_window = eramE.pictures.straight_vertical_window.hr_version
eramE.pictures.straight_vertical_window.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-straight-vertical-window.png"
eramE.pictures.straight_vertical_window.hr_version = nil

eramE.pictures.straight_horizontal_window = eramE.pictures.straight_horizontal_window.hr_version
eramE.pictures.straight_horizontal_window.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-straight-horizontal-window.png"
eramE.pictures.straight_horizontal_window.hr_version = nil

eramE.pictures.straight_horizontal = eramE.pictures.straight_horizontal.hr_version
eramE.pictures.straight_horizontal.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-straight-horizontal.png"
eramE.pictures.straight_horizontal.hr_version = nil

eramE.pictures.corner_up_right = eramE.pictures.corner_up_right.hr_version
eramE.pictures.corner_up_right.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-corner-up-right.png"
eramE.pictures.corner_up_right.hr_version = nil

eramE.pictures.corner_up_left = eramE.pictures.corner_up_left.hr_version
eramE.pictures.corner_up_left.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-corner-up-left.png"
eramE.pictures.corner_up_left.hr_version = nil

eramE.pictures.corner_down_right = eramE.pictures.corner_down_right.hr_version
eramE.pictures.corner_down_right.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-corner-down-right.png"
eramE.pictures.corner_down_right.hr_version = nil

eramE.pictures.corner_down_left = eramE.pictures.corner_down_left.hr_version
eramE.pictures.corner_down_left.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-corner-down-left.png"
eramE.pictures.corner_down_left.hr_version = nil

eramE.pictures.t_up = eramE.pictures.t_up.hr_version
eramE.pictures.t_up.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-t-up.png"
eramE.pictures.t_up.hr_version = nil

eramE.pictures.t_down = eramE.pictures.t_down.hr_version
eramE.pictures.t_down.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-t-down.png"
eramE.pictures.t_down.hr_version = nil

eramE.pictures.t_right = eramE.pictures.t_right.hr_version
eramE.pictures.t_right.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-t-right.png"
eramE.pictures.t_right.hr_version = nil

eramE.pictures.t_left = eramE.pictures.t_left.hr_version
eramE.pictures.t_left.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-t-left.png"
eramE.pictures.t_left.hr_version = nil

eramE.pictures.cross = eramE.pictures.cross.hr_version
eramE.pictures.cross.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-cross.png"
eramE.pictures.cross.hr_version = nil

eramE.pictures.ending_up = eramE.pictures.ending_up.hr_version
eramE.pictures.ending_up.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-ending-up.png"
eramE.pictures.ending_up.hr_version = nil

eramE.pictures.ending_down = eramE.pictures.ending_down.hr_version
eramE.pictures.ending_down.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-ending-down.png"
eramE.pictures.ending_down.hr_version = nil

eramE.pictures.ending_right = eramE.pictures.ending_right.hr_version
eramE.pictures.ending_right.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-ending-right.png"
eramE.pictures.ending_right.hr_version = nil

eramE.pictures.ending_left = eramE.pictures.ending_left.hr_version
eramE.pictures.ending_left.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-ending-left.png"
eramE.pictures.ending_left.hr_version = nil

eramE.pictures.horizontal_window_background = eramE.pictures.horizontal_window_background.hr_version
eramE.pictures.horizontal_window_background.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-horizontal-window-background.png"
eramE.pictures.horizontal_window_background.hr_version = nil

eramE.pictures.vertical_window_background = eramE.pictures.vertical_window_background.hr_version
eramE.pictures.vertical_window_background.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-vertical-window-background.png"
eramE.pictures.vertical_window_background.hr_version = nil

data:extend{eramE}

createEryaItem
(
    "EryaPipe1",
    64,
    "EryaLogistic",
    "i",
    100,
    0.5,
    {{"EryaPlate",4}},
    {count=130,time=1,ingredients={{"EryaSample", 1}}},
    "Erya"
)


-- Erya Pipe To Ground --
local erptgE = table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
erptgE.name = "EryaPipeToGround1"
erptgE.minable = {mining_time = 0.2, result = "EryaPipeToGround1"}
erptgE.fluid_box.pipe_connections[2].max_underground_distance = 20

erptgE.pictures.up = erptgE.pictures.up.hr_version
erptgE.pictures.up.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-to-ground-up.png"
erptgE.pictures.up.hr_version = nil

erptgE.pictures.down = erptgE.pictures.down.hr_version
erptgE.pictures.down.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-to-ground-down.png"
erptgE.pictures.down.hr_version = nil

erptgE.pictures.left = erptgE.pictures.left.hr_version
erptgE.pictures.left.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-to-ground-left.png"
erptgE.pictures.left.hr_version = nil

erptgE.pictures.right = erptgE.pictures.right.hr_version
erptgE.pictures.right.filename = "__Mobile_Factory_Graphics__/graphics/Erya/pipes/hr-pipe-to-ground-right.png"
erptgE.pictures.right.hr_version = nil

data:extend{erptgE}

createEryaItem
(
    "EryaPipeToGround1",
    64,
    "EryaLogistic",
    "j",
    20,
    0.5,
    {{"EryaPlate",16}},
    {count=150,time=1,ingredients={{"EryaSample", 1}}},
    "EryaPipe1"
)


-- Erya Pump MK1 --
local erp1E = table.deepcopy(data.raw.pump.pump)
erp1E.name = "EryaPump1"
erp1E.minable = {mining_time = 0.3, result = "EryaPump1"}
erp1E.energy_usage = "1W"
erp1E.energy_source = {type="void"}
erp1E.pumping_speed = 100

erp1E.animations.north = erp1E.animations.north.hr_version
erp1E.animations.north.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaPump1NorthE.png"
erp1E.animations.north.hr_version = nil

erp1E.animations.east = erp1E.animations.east.hr_version
erp1E.animations.east.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaPump1EastE.png"
erp1E.animations.east.hr_version = nil

erp1E.animations.south = erp1E.animations.south.hr_version
erp1E.animations.south.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaPump1SouthE.png"
erp1E.animations.south.hr_version = nil

erp1E.animations.west = erp1E.animations.west.hr_version
erp1E.animations.west.filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaPump1WestE.png"
erp1E.animations.west.hr_version = nil

data:extend{erp1E}

createEryaItem
(
    "EryaPump1",
    64,
    "EryaLogistic",
    "k",
    20,
    0.5,
    {{"EryaMachineFrame1",1},{"EryaCircuit",4}},
    {count=170,time=1,ingredients={{"EryaSample", 1}}},
    "EryaPipe1"
)


-- Erya Wall MK1 --
local erwE = table.deepcopy(data.raw.wall["stone-wall"])
erwE.name = "EryaWall1"
erwE.minable = {mining_time = 0.1, result = "EryaWall1"}
erwE.max_health = 200

erwE.pictures.single.layers[1] = erwE.pictures.single.layers[1].hr_version
erwE.pictures.single.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/walls/hr-wall-single.png"
erwE.pictures.single.layers[1].hr_version = nil

erwE.pictures.straight_vertical.layers[1] = erwE.pictures.straight_vertical.layers[1].hr_version
erwE.pictures.straight_vertical.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/walls/hr-wall-vertical.png"
erwE.pictures.straight_vertical.layers[1].hr_version = nil

erwE.pictures.straight_horizontal.layers[1] = erwE.pictures.straight_horizontal.layers[1].hr_version
erwE.pictures.straight_horizontal.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/walls/hr-wall-horizontal.png"
erwE.pictures.straight_horizontal.layers[1].hr_version = nil

erwE.pictures.corner_right_down.layers[1] = erwE.pictures.corner_right_down.layers[1].hr_version
erwE.pictures.corner_right_down.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/walls/hr-wall-corner-right.png"
erwE.pictures.corner_right_down.layers[1].hr_version = nil

erwE.pictures.corner_left_down.layers[1] = erwE.pictures.corner_left_down.layers[1].hr_version
erwE.pictures.corner_left_down.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/walls/hr-wall-corner-left.png"
erwE.pictures.corner_left_down.layers[1].hr_version = nil

erwE.pictures.t_up.layers[1] = erwE.pictures.t_up.layers[1].hr_version
erwE.pictures.t_up.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/walls/hr-wall-t.png"
erwE.pictures.t_up.layers[1].hr_version = nil

erwE.pictures.ending_right.layers[1] = erwE.pictures.ending_right.layers[1].hr_version
erwE.pictures.ending_right.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/walls/hr-wall-ending-right.png"
erwE.pictures.ending_right.layers[1].hr_version = nil

erwE.pictures.ending_left.layers[1] = erwE.pictures.ending_left.layers[1].hr_version
erwE.pictures.ending_left.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/walls/hr-wall-ending-left.png"
erwE.pictures.ending_left.layers[1].hr_version = nil

erwE.pictures.filling = erwE.pictures.filling.hr_version
erwE.pictures.filling.filename = "__Mobile_Factory_Graphics__/graphics/Erya/walls/hr-wall-filling.png"
erwE.pictures.filling.hr_version = nil

data:extend{erwE}

createEryaItem
(
    "EryaWall1",
    64,
    "EryaWar",
    "a",
    300,
    0.2,
    {{"EryaPlate",6}},
    {count=150,time=1,ingredients={{"EryaSample", 1}}},
    "Erya"
)


-- Erya Gate MK1 --
local ergE = table.deepcopy(data.raw.gate.gate)
ergE.name = "EryaGate1"
ergE.minable = {mining_time = 0.2, result = "EryaGate1"}
ergE.max_health = 200

ergE.vertical_animation.layers[1] = ergE.vertical_animation.layers[1].hr_version
ergE.vertical_animation.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/gates/hr-gate-vertical.png"
ergE.vertical_animation.layers[1].hr_version = nil

ergE.horizontal_animation.layers[1] = ergE.horizontal_animation.layers[1].hr_version
ergE.horizontal_animation.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/gates/hr-gate-horizontal.png"
ergE.horizontal_animation.layers[1].hr_version = nil

ergE.horizontal_rail_animation_left.layers[1] = ergE.horizontal_rail_animation_left.layers[1].hr_version
ergE.horizontal_rail_animation_left.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/gates/hr-gate-rail-horizontal-left.png"
ergE.horizontal_rail_animation_left.layers[1].hr_version = nil

ergE.horizontal_rail_animation_right.layers[1] = ergE.horizontal_rail_animation_right.layers[1].hr_version
ergE.horizontal_rail_animation_right.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/gates/hr-gate-rail-horizontal-right.png"
ergE.horizontal_rail_animation_right.layers[1].hr_version = nil

ergE.vertical_rail_animation_left.layers[1] = ergE.vertical_rail_animation_left.layers[1].hr_version
ergE.vertical_rail_animation_left.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/gates/hr-gate-rail-vertical-left.png"
ergE.vertical_rail_animation_left.layers[1].hr_version = nil

ergE.vertical_rail_animation_right.layers[1] = ergE.vertical_rail_animation_right.layers[1].hr_version
ergE.vertical_rail_animation_right.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/gates/hr-gate-rail-vertical-right.png"
ergE.vertical_rail_animation_right.layers[1].hr_version = nil

ergE.vertical_rail_base = ergE.vertical_rail_base.hr_version
ergE.vertical_rail_base.filename = "__Mobile_Factory_Graphics__/graphics/Erya/gates/hr-gate-rail-base-vertical.png"
ergE.vertical_rail_base.hr_version = nil

ergE.horizontal_rail_base = ergE.horizontal_rail_base.hr_version
ergE.horizontal_rail_base.filename = "__Mobile_Factory_Graphics__/graphics/Erya/gates/hr-gate-rail-base-horizontal.png"
ergE.horizontal_rail_base.hr_version = nil

data:extend{ergE}

createEryaItem
(
    "EryaGate1",
    64,
    "EryaWar",
    "b",
    50,
    0.3,
    {{"EryaPlate",5},{"EryaCircuit",2}},
    {count=180,time=1,ingredients={{"EryaSample", 1}}},
    "EryaWall1"
)


-- Erya Radar MK1 --
local errE = table.deepcopy(data.raw.radar.radar)
errE.name = "EryaRadar1"
errE.minable = {mining_time = 0.5, result = "EryaRadar1"}
errE.energy_usage = "1W"
errE.energy_source = {type="void"}
errE.pictures.layers[1] = errE.pictures.layers[1].hr_version
errE.pictures.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaRadar1E.png"
errE.pictures.layers[1].hr_version = nil
data:extend{errE}

createEryaItem
(
    "EryaRadar1",
    64,
    "EryaWar",
    "c",
    10,
    0.8,
    {{"EryaMachineFrame1",4},{"EryaCircuit",8}},
    {count=180,time=1,ingredients={{"EryaSample", 1}}},
    "EryaWall1"
)

-- Erya Furnace MK1 --
local erfE = table.deepcopy(data.raw.furnace["electric-furnace"])
erfE.name = "EryaFurnace1"
erfE.minable = {mining_time = 0.5, result = "EryaFurnace1"}
erfE.crafting_speed = 1
erfE.energy_usage = "1W"
erfE.energy_source = {type="void"}
erfE.animation.layers[1] = erfE.animation.layers[1].hr_version
erfE.animation.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaFurnace1E.png"
erfE.animation.layers[1].hr_version = nil
data:extend{erfE}

createEryaItem
(
    "EryaFurnace1",
    64,
    "EryaProduction",
    "d",
    15,
    0.7,
    {{"EryaMachineFrame1",3},{"EryaCircuit",5}},
    {count=130,time=1,ingredients={{"EryaSample", 1}}},
    "Erya"
)


-- Erya Refinery MK1 --
local errfE = table.deepcopy(data.raw["assembling-machine"]["oil-refinery"])
errfE.name = "EryaRefinery1"
errfE.minable = {mining_time = 0.5, result = "EryaRefinery1"}
errfE.crafting_speed = 0.7
errfE.energy_usage = "1W"
errfE.energy_source = {type="void"}

errfE.animation.north.layers[1] = errfE.animation.north.layers[1].hr_version
errfE.animation.north.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaRefinery1E.png"
errfE.animation.north.layers[1].hr_version = nil

errfE.animation.east.layers[1] = errfE.animation.east.layers[1].hr_version
errfE.animation.east.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaRefinery1E.png"
errfE.animation.east.layers[1].hr_version = nil

errfE.animation.south.layers[1] = errfE.animation.south.layers[1].hr_version
errfE.animation.south.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaRefinery1E.png"
errfE.animation.south.layers[1].hr_version = nil

errfE.animation.west.layers[1] = errfE.animation.west.layers[1].hr_version
errfE.animation.west.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaRefinery1E.png"
errfE.animation.west.layers[1].hr_version = nil

data:extend{errfE}

createEryaItem
(
    "EryaRefinery1",
    64,
    "EryaProduction",
    "e",
    10,
    1,
    {{"EryaMachineFrame1",5},{"EryaCircuit",7},{"EryaPlate",12}},
    {count=170,time=1,ingredients={{"EryaSample", 1}}},
    "Erya"
)


-- Erya Chemical Plant MK1 --
local ercpE = table.deepcopy(data.raw["assembling-machine"]["chemical-plant"])
ercpE.name = "EryaChemicalPlant1"
ercpE.minable = {mining_time = 0.8, result = "EryaChemicalPlant1"}
ercpE.crafting_speed = 0.7
ercpE.energy_usage = "1W"
ercpE.energy_source = {type="void"}

ercpE.animation.north.layers[1] = ercpE.animation.north.layers[1].hr_version
ercpE.animation.north.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaChemicalPlant1E.png"
ercpE.animation.north.layers[1].hr_version = nil

ercpE.animation.east.layers[1] = ercpE.animation.east.layers[1].hr_version
ercpE.animation.east.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaChemicalPlant1E.png"
ercpE.animation.east.layers[1].hr_version = nil

ercpE.animation.south.layers[1] = ercpE.animation.south.layers[1].hr_version
ercpE.animation.south.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaChemicalPlant1E.png"
ercpE.animation.south.layers[1].hr_version = nil

ercpE.animation.west.layers[1] = ercpE.animation.west.layers[1].hr_version
ercpE.animation.west.layers[1].filename = "__Mobile_Factory_Graphics__/graphics/Erya/EryaChemicalPlant1E.png"
ercpE.animation.west.layers[1].hr_version = nil

data:extend{ercpE}

createEryaItem
(
    "EryaChemicalPlant1",
    64,
    "EryaProduction",
    "f",
    10,
    1.5,
    {{"EryaMachineFrame1",7},{"EryaCircuit",7},{"EryaPlate",15}},
    {count=200,time=1,ingredients={{"EryaSample", 1}}},
    "Erya"
)