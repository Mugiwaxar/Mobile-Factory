---------------------------------- NETWORK EXPLORER ---------------------------

-- Entity --
local neE = {}
neE.type = "container"
neE.name = "NetworkExplorer"
neE.icon = "__Mobile_Factory__/graphics/NetworkExplorerI.png"
neE.icon_size = 64
neE.flags = {"placeable-neutral", "player-creation"}
neE.minable = {mining_time = 0.2, result = "NetworkExplorer"}
neE.max_health = 100
neE.corpse = "small-remnants"
neE.render_not_in_network_icon = false
neE.collision_box = {{-0.7, -0.5}, {0.7, 0.9}}
neE.selection_box = neE.collision_box
neE.inventory_size = 0
neE.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" }
neE.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" }
neE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
neE.picture =
    {
      layers =
      {
        {
            filename = "__Mobile_Factory__/graphics/NetworkExplorerE.png",
            priority = "extra-high",
            width = 600,
            height = 600,
            shift = {0,-0.2},
            scale = 1/9
        },
        {
            filename = "__Mobile_Factory__/graphics/NetworkExplorerS.png",
            priority = "high",
            width = 600,
            height = 600,
            shift = {0,-0.2},
            draw_as_shadow = true,
            scale = 1/9
        }
      }
    }
    neE.circuit_wire_connection_point =
{
	wire = {red={0,-1.2}, green={0,-1.2}},
	shadow = {red={-0.05,-1.2}, green={-0.05,-1.2}}
}
neE.circuit_connector_sprites = nil
neE.circuit_wire_max_distance = 20
data:extend{neE}

-- Item --
local neI = {}
neI.type = "item"
neI.name = "NetworkExplorer"
neI.icon = "__Mobile_Factory__/graphics/NetworkExplorerI.png"
neI.icon_size = 128
neI.place_result = "NetworkExplorer"
neI.subgroup = "DataSerialization"
neI.order = "g"
neI.stack_size = 5
data:extend{neI}


-- Recipe --
local neR = {}
neR.type = "recipe"
neR.name = "NetworkExplorer"
neR.energy_required = 4
neR.enabled = false
neR.ingredients =
    {
      {"CrystalizedCircuit", 16},
      {"MachineFrame3", 6}
    }
    neR.result = "NetworkExplorer"
data:extend{neR}

-- Technologie --
local neT = {}
neT.name = "NetworkExplorer"
neT.type = "technology"
neT.icon = "__Mobile_Factory__/graphics/NetworkExplorerI.png"
neT.icon_size = 128
neT.unit = {
	count=12,
	time=60,
	ingredients={
		{"DimensionalSample", 110},
		{"DimensionalCrystal", 1}
	}
}
neT.prerequisites = {"MatterSerialization"}
neT.effects = {{type="unlock-recipe", recipe="NetworkExplorer"}}
data:extend{neT}

-- Create all Sprites --
local neS1 = {}
neS1.type = "sprite"
neS1.name = "NetworkExplorerSprite1"
neS1.filename = "__Mobile_Factory__/graphics/NetworkExplorerSprite1.png"
neS1.size = 600
neS1.shift = {0,-0.2}
neS1.scale = 1/9
data:extend{neS1}

local neS2 = {}
neS2.type = "sprite"
neS2.name = "NetworkExplorerSprite2"
neS2.filename = "__Mobile_Factory__/graphics/NetworkExplorerSprite2.png"
neS2.size = 600
neS2.shift = {0,-0.2}
neS2.scale = 1/9
data:extend{neS2}