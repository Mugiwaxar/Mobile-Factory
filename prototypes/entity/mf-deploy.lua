-- This is the fake Entity used to Deploy the Mobile Factory --

-- Entity --
local mfDE = {}
mfDE.type = "simple-entity"
mfDE.name = "MFDeploy"
mfDE.icone = "__Mobile_Factory__/graphics/MFDeployI.png"
mfDE.icon_size = 32
mfDE.picture = {
        filename = "__Mobile_Factory__/graphics/MFDeployE.png",
        priority = "high",
        width = 600,
        height = 800,
        -- shift = {0.5,-0.3},
        -- scale = 1/600*32*8.7
  }
data:extend{mfDE}

-- Item --
local mfdI = {}
mfdI.type = "item"
mfdI.name = "MFDeploy"
mfdI.icon = "__Mobile_Factory__/graphics/MFDeployI.png"
mfdI.icon_size = 32
mfdI.stack_size = 1
data:extend{mfdI}