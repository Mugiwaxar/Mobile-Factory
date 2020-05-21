---------------------------------- NETWORK EXPLORER ---------------------------

-- Entity --
local daE = {}
daE.type = "container"
daE.name = "DataAssembler"
daE.icon = "__Mobile_Factory__/graphics/DataAssemblerI.png"
daE.icon_size = 64
daE.flags = {"placeable-neutral", "player-creation"}
daE.minable = {mining_time = 0.2, result = "DataAssembler"}
daE.max_health = 100
daE.corpse = "small-remnants"
daE.render_not_in_network_icon = false
daE.collision_box = {{-1.4, -1.2}, {1.4, 1.3}}
daE.selection_box = daE.collision_box
daE.inventory_size = 0
daE.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" }
daE.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" }
daE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
daE.picture =
    {
      layers =
      {
        {
            filename = "__Mobile_Factory__/graphics/DataAssemblerE.png",
            priority = "extra-high",
            width = 600,
            height = 600,
            shift = {0,-0.1},
            scale = 1/6
        },
        {
            filename = "__Mobile_Factory__/graphics/DataAssemblerS.png",
            priority = "high",
            width = 600,
            height = 600,
            shift = {0,-0.1},
            draw_as_shadow = true,
            scale = 1/6
        }
      }
    }
    daE.circuit_wire_connection_point =
{
	wire = {red={0,-1.2}, green={0,-1.2}},
	shadow = {red={-0.05,-1.2}, green={-0.05,-1.2}}
}
daE.circuit_connector_sprites = nil
daE.circuit_wire_max_distance = 20
data:extend{daE}

-- Item --
local daI = {}
daI.type = "item"
daI.name = "DataAssembler"
daI.icon = "__Mobile_Factory__/graphics/DataAssemblerI.png"
daI.icon_size = 128
daI.place_result = "DataAssembler"
daI.subgroup = "DataSerialization"
daI.order = "g"
daI.stack_size = 5
data:extend{daI}


-- Recipe --
local daR = {}
daR.type = "recipe"
daR.name = "DataAssembler"
daR.energy_required = 4
daR.enabled = false
daR.ingredients =
    {
      {"CrystalizedCircuit", 10},
      {"MachineFrame3", 5}
    }
    daR.result = "DataAssembler"
data:extend{daR}

-- Technologie --
local daT = {}
daT.name = "DataAssembler"
daT.type = "technology"
daT.icon = "__Mobile_Factory__/graphics/DataAssemblerI.png"
daT.icon_size = 128
daT.unit = {
	count=16,
	time=60,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}
}
daT.prerequisites = {"MatterSerialization"}
daT.effects = {{type="unlock-recipe", recipe="DataAssembler"}}
data:extend{daT}

-- Create all Sprites --
local daS1 = {}
daS1.type = "sprite"
daS1.name = "DataAssemblerSprite1"
daS1.filename = "__Mobile_Factory__/graphics/DataAssemblerSprite1.png"
daS1.size = 600
daS1.shift = {0,-0.1}
daS1.scale = 1/6
data:extend{daS1}

local daS2 = {}
daS2.type = "sprite"
daS2.name = "DataAssemblerSprite2"
daS2.filename = "__Mobile_Factory__/graphics/DataAssemblerSprite2.png"
daS2.size = 600
daS2.shift = {0,-0.1}
daS2.scale = 1/6
data:extend{daS2}