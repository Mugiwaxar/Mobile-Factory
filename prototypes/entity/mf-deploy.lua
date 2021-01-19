-- This is the fake Entity used to Deploy the Mobile Factory --

-- Entity --
local mfDE = {}
mfDE.type = "simple-entity-with-owner"
mfDE.name = "MFDeploy"
mfDE.icone = "__Mobile_Factory_Graphics__/graphics/icons/MFDeployI.png"
mfDE.icon_size = 32
mfDE.minable = {mining_time=1}
mfDE.collision_mask = {"player-layer", "train-layer", "consider-tile-transitions", "layer-52", "not-colliding-with-itself"}
mfDE.collision_box = {{-3.5, -3.5}, {2.5, 4.5}}
mfDE.selection_box = mfDE.collision_box
mfDE.flags = {"not-rotatable"}
mfDE.picture = {
        filename = "__Mobile_Factory_Graphics__/graphics/icons/MFDeployE.png",
        priority = "high",
        width = 600,
        height = 800,
        scale = 1/3
  }
data:extend{mfDE}

-- Item --
local mfdI = {}
mfdI.type = "item"
mfdI.name = "MFDeploy"
mfdI.icon = "__Mobile_Factory_Graphics__/graphics/icons/MFDeployI.png"
mfdI.place_result = "MFDeploy"
mfdI.icon_size = 32
mfdI.stack_size = 1
mfdI.flags = {"hidden", "only-in-cursor"}
data:extend{mfdI}

-- Technology --
local mfDT = {}
mfDT.name = "MFDeploy"
mfDT.type = "technology"
mfDT.icon = "__Mobile_Factory_Graphics__/graphics/icons/MFDeployT.png"
mfDT.icon_size = 600
mfDT.unit = {
	count=1,
	time=3,
	ingredients={
		{"DimensionalSample", 350}
	}
}
mfDT.prerequisites = {"DimensionalOre"}
mfDT.effects = {{type="nothing", effect_description={"description.Deploy"}}}
data:extend{mfDT}

-- Slot Technologies --
for i = 5, 20 do
  local mfDTS = {}
  mfDTS.name = "MFDSlot" .. i
  mfDTS.type = "technology"
  mfDTS.icon = "__Mobile_Factory_Graphics__/graphics/icons/DPSlotT.png"
  mfDTS.icon_size = 64
  mfDTS.unit = {
    count=1*i,
    time=i,
    ingredients={
      {"DimensionalSample", 100}
    }
  }
  if i > 13 then
    table.insert(mfDTS.unit.ingredients, {"DimensionalCrystal", 1})
  end
  if i == 5 then
    mfDTS.prerequisites = {"MFDeploy"}
  else
    mfDTS.prerequisites = {"MFDSlot" .. i-1}
  end
  mfDTS.effects = {{type="nothing", effect_description={"description.MFDSlot" .. i}}}
  data:extend{mfDTS}
end

