----------------------------------- FLUID INTERACTOR -----------------------------------

-- Entity --
fiE = table.deepcopy(data.raw["storage-tank"]["storage-tank"])
fiE.type = "storage-tank"
fiE.name = "FluidInteractor"
fiE.minable = {mining_time = 0.2, result = "FluidInteractor"}
fiE.flags = {"not-rotatable"}
fiE.collision_box = {{-1.5, -1.5}, {1.5, 1.5}}
fiE.selection_box = fiE.collision_box
fiE.fluid_box =
    {
      base_area = 100,
      height = 1,
      base_level = 0,
      pipe_covers = nil,
      pipe_connections =
      {
          {position={-1.6,0}},
          {position={1.6,0}},
          {position={0,-1.6}},
          {position={0,1.6}}
      }
    }
fiE.pictures.picture =
{
    layers =
    {
        {
        filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/FluidInteractorE.png",
        frames = 1,
        width = 600,
        height = 600,
        shift = {0,-0.5},
        scale = 1/3
        },
        {
            filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/FluidInteractorS.png",
            frames = 1,
            width = 600,
            height = 600,
            shift = {0,-0.5},
            scale = 1/3,
            draw_as_shadow = true
        }
    }
    
}
data:extend{fiE}

-- Item --
local fiI = {}
fiI.type = "item"
fiI.name = "FluidInteractor"
fiI.icon = "__Mobile_Factory_Graphics__/graphics/matter-serialization/FluidInteractorI.png"
fiI.icon_size = 128
fiI.place_result = "FluidInteractor"
fiI.subgroup = "DataSerialization"
fiI.order = "f1"
fiI.stack_size = 10
data:extend{fiI}

-- Recipe --
local fiR = {}
fiR.type = "recipe"
fiR.name = "FluidInteractor"
fiR.energy_required = 4
fiR.enabled = false
fiR.ingredients =
    {
      {"CrystalizedCircuit", 13},
      {"MachineFrame3", 4}
    }
fiR.result = "FluidInteractor"
data:extend{fiR}

-- Create all Sprite --
local fiS1 = {}
fiS1.type = "sprite"
fiS1.name = "FluidInteractorSprite1"
fiS1.filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/FluidInteractorSprite1.png"
fiS1.size = 600
fiS1.scale = 1/3
fiS1.shift = {0,-0.5}
data:extend{fiS1}

local fiS2 = {}
fiS2.type = "sprite"
fiS2.name = "FluidInteractorSprite2"
fiS2.filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/FluidInteractorSprite2.png"
fiS2.size = 600
fiS2.scale = 1/3
fiS2.shift = {0,-0.5}
data:extend{fiS2}

for i = 0, 9 do
	local fiS3 = {}
	fiS3.type = "sprite"
	fiS3.name = "FluidInteractorSprite3" .. i+1
	fiS3.filename = "__Mobile_Factory_Graphics__/graphics/matter-serialization/FluidInteractorSprites3.png"
	fiS3.size = 600
    fiS3.x = 600 * i
    fiS3.scale = 1/3
    fiS3.shift = {0,-0.5}
	data:extend{fiS3}
end