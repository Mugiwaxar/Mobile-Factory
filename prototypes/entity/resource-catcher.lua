---------------------------------- RESOURCE CATCHER ----------------------------------

-- Entity --
local rcE = {}
rcE.name = "ResourceCatcher"
rcE.type = "simple-entity-with-force"
rcE.flags = {"placeable-neutral", "player-creation"}
rcE.icon = "__Mobile_Factory__/graphics/ResourceCatcherI.png"
rcE.icon_size = 128
rcE.minable = {mining_time = 0.2, result = "ResourceCatcher"}
rcE.max_health = 30
rcE.collision_mask = {"object-layer"}
rcE.corpse = "land-mine-remnants"
rcE.collision_box = {{-0.49, -0.49}, {0.49, 0.49}}
rcE.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
rcE.picture = {
    layers = {
        {
            filename = "__Mobile_Factory__/graphics/ResourceCatcherRedE.png",
            priority = "high",
            width = 200,
            height = 200,
            scale = 1/6
        },
        {
            filename = "__Mobile_Factory__/graphics/ResourceCatcherS.png",
            priority = "high",
            width = 200,
            height = 200,
            draw_as_shadow = true,
            scale = 1/6
        }
    }
}
data:extend{rcE}

-- Item --
local rcI = {}
rcI.type = "item"
rcI.name = "ResourceCatcher"
rcI.place_result = "ResourceCatcher"
rcI.icon = "__Mobile_Factory__/graphics/ResourceCatcherI.png"
rcI.icon_size = 128
rcI.subgroup = "DimensionalStuff"
rcI.order = "A1"
rcI.stack_size = 30
data:extend{rcI}

-- Filled Item --
local frcI = {}
frcI.type = "item-with-tags"
frcI.name = "FilledResourceCatcher"
frcI.localised_name = {"item-name.FilledResourceCatcher"}
frcI.place_result = "ResourceCatcher"
frcI.icon = "__Mobile_Factory__/graphics/FilledResourceCatcherI.png"
frcI.icon_size = 128
frcI.subgroup = "DimensionalStuff"
frcI.order = "A2"
frcI.stack_size = 1
data:extend{frcI}

-- Recipe --
local rcR = {}
rcR.type = "recipe"
rcR.name = "ResourceCatcher"
rcR.energy_required = 5
rcR.enabled = false
rcR.ingredients =
{
    {"DimensionalCircuit", 3},
    {"MachineFrame2", 1}
}
rcR.result = "ResourceCatcher"
data:extend{rcR}

-- Technology --
local rcT = {}
rcT.name = "ResourceCatcher"
rcT.type = "technology"
rcT.icon = "__Mobile_Factory__/graphics/ResourceCatcherI.png"
rcT.icon_size = 128
rcT.unit = {
	count=175,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
rcT.prerequisites = {"DimensionalElectronic"}
rcT.effects = {{type="unlock-recipe", recipe="ResourceCatcher"}}
data:extend{rcT}

-- Green Sprite --
local rcS = {}
rcS.type = "sprite"
rcS.name = "ResourceCatcher"
rcS.filename = "__Mobile_Factory__/graphics/ResourceCatcherE.png"
rcS.width = 200
rcS.height = 200
rcS.scale = 1/6
data:extend{rcS}