---------------------------------- JUMP CHARGER ----------------------------------

-- Entity --
local jcE = {}
jcE.type = "container"
jcE.name = "JumpCharger"
jcE.icon = "__Mobile_Factory__/graphics/JumpChargerI.png"
jcE.icon_size = 128
jcE.flags = {"placeable-neutral", "player-creation"}
jcE.minable = {mining_time = 0.4, result = "JumpCharger"}
jcE.max_health = 300
jcE.corpse = "small-remnants"
jcE.render_not_in_network_icon = false
jcE.collision_box = {{-1.4, -1.4}, {1.4, 1.4}}
jcE.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
jcE.inventory_size = 0
jcE.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" }
jcE.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" }
jcE.vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 }
jcE.picture =
    {
      layers =
      {
        {
          filename = "__Mobile_Factory__/graphics/JumpChargerG.png",
          priority = "extra-high",
          width = 600,
          height = 600,
          shift = {0,-1.7},
          scale = 1/600*32*6.5,
          draw_as_glow = true
        },
        {
            filename = "__Mobile_Factory__/graphics/JumpChargerE.png",
            priority = "extra-high",
            width = 600,
            height = 600,
            shift = {0,-1.7},
            scale = 1/600*32*6.5
        },
        {
            filename = "__Mobile_Factory__/graphics/JumpChargerS.png",
            priority = "high",
            width = 600,
            height = 600,
            shift = {0,-1.7},
            draw_as_shadow = true,
            scale = 1/600*32*6.5
        }
      }
    }
    jcE.circuit_wire_connection_point =
{
	wire = {red={-0.05,-0.1}, green={0.05,-0.1}},
	shadow = {red={-0.05,0}, green={0.05,0}}
}
jcE.circuit_connector_sprites = nil
jcE.circuit_wire_max_distance = 20
data:extend{jcE}

-- Item --
local jcI = {}
jcI.type = "item"
jcI.name = "JumpCharger"
jcI.icon = "__Mobile_Factory__/graphics/JumpChargerI.png"
jcI.icon_size = 128
jcI.place_result = "JumpCharger"
jcI.subgroup = "MobileFactory"
jcI.order = "z"
jcI.stack_size = 10
data:extend{jcI}

-- Recipe --
local jcR = {}
jcR.type = "recipe"
jcR.name = "JumpCharger"
jcR.energy_required = 5
jcR.enabled = false
jcR.ingredients =
    {
      {"CrystalizedCircuit", 25},
      {"MachineFrame3", 3},
      {"EnergyCore", 5}
    }
jcR.result = "JumpCharger"
data:extend{jcR}

-- Technology --
local jcT = {}
jcT.name = "JumpCharger"
jcT.type = "technology"
jcT.icon = "__Mobile_Factory__/graphics/JumpChargerI.png"
jcT.icon_size = 128
jcT.unit = {
count=15,
time=100,
ingredients={
  {"DimensionalSample", 80},
  {"DimensionalCrystal", 1}
}}
jcT.prerequisites = {"EnergyCore", "JumpDrive"}
jcT.effects = {{type="unlock-recipe", recipe="JumpCharger"}}
data:extend{jcT}