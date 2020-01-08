--------------------- DIMENSIONAL TANK MK2 ------------------------


--------- TANK 1 ----------
-- Entity --
local dmTE = table.deepcopy(data.raw["storage-tank"].StorageTank1MK1)
dmTE.name = "StorageTank1MK2"
dmTE.fluid_box =
    {
      base_area = 1000,
      height = 100,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
	  pipe_connections = {}
    }
data:extend{dmTE}




-- Technology --
local dmT = {}
dmT.name = "StorageTankMK2_1"
dmT.type = "technology"
dmT.icon = "__Mobile_Factory__/graphics/icones/DimensionalTank1.png"
dmT.icon_size = 32
dmT.unit = {
	count=5,
	time=60,
	ingredients={
		{"DimensionalCrystal", 1}
	}
}
dmT.prerequisites = {"StorageTankMK1_1", "DimensionalCrystal"}
dmT.effects = {{type="nothing", effect_description={"description.DimensionalTank1MK2"}}}
data:extend{dmT}


--------- TANK 2 ----------
-- Entity --
local dmT2 = table.deepcopy(data.raw["storage-tank"].StorageTank2MK1)
dmT2.name = "StorageTank2MK2"
dmT2.fluid_box =
    {
      base_area = 1000,
      height = 100,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
	  pipe_connections = {}
    }
data:extend{dmT2}

-- Technology MK2 --
local dt2T = {}
dt2T.name = "StorageTankMK2_2"
dt2T.type = "technology"
dt2T.icon = "__Mobile_Factory__/graphics/icones/DimensionalTank2.png"
dt2T.icon_size = 32
dt2T.unit = {
	count=5,
	time=60,
	ingredients={
		{"DimensionalCrystal", 1}
	}
}
dt2T.prerequisites = {"StorageTankMK1_1", "StorageTankMK1_2"}
dt2T.effects = {{type="nothing", effect_description={"description.DimensionalTank2MK2"}}}
data:extend{dt2T}


--------- TANK 3 ----------
-- Entity --
local dmT3 = table.deepcopy(data.raw["storage-tank"].StorageTank3MK1)
dmT3.name = "StorageTank3MK2"
dmT3.fluid_box =
    {
      base_area = 1000,
      height = 100,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
	  pipe_connections = {}
    }
data:extend{dmT3}

-- Technology MK3 --
local dt3T = {}
dt3T.name = "StorageTankMK2_3"
dt3T.type = "technology"
dt3T.icon = "__Mobile_Factory__/graphics/icones/DimensionalTank3.png"
dt3T.icon_size = 32
dt3T.unit = {
	count=5,
	time=60,
	ingredients={
		{"DimensionalCrystal", 1}
	}
}
dt3T.prerequisites = {"StorageTankMK1_2", "StorageTankMK1_3"}
dt3T.effects = {{type="nothing", effect_description={"description.DimensionalTank3MK2"}}}
data:extend{dt3T}


--------- TANK 4 ----------
-- Entity --
local dmT4 = table.deepcopy(data.raw["storage-tank"].StorageTank4MK1)
dmT4.name = "StorageTank4MK2"
dmT4.fluid_box =
    {
      base_area = 1000,
      height = 100,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
	  pipe_connections = {}
    }
data:extend{dmT4}

-- Technology MK3 --
local dt4T = {}
dt4T.name = "StorageTankMK2_4"
dt4T.type = "technology"
dt4T.icon = "__Mobile_Factory__/graphics/icones/DimensionalTank4.png"
dt4T.icon_size = 32
dt4T.unit = {
	count=5,
	time=60,
	ingredients={
		{"DimensionalCrystal", 1}
	}
}
dt4T.prerequisites = {"StorageTankMK1_3", "StorageTankMK1_4"}
dt4T.effects = {{type="nothing", effect_description={"description.DimensionalTank4MK2"}}}
data:extend{dt4T}


--------- TANK 5 ----------
-- Entity --
local dmT5 = table.deepcopy(data.raw["storage-tank"].StorageTank5MK1)
dmT5.name = "StorageTank5MK2"
dmT5.fluid_box =
    {
      base_area = 1000,
      height = 100,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
	  pipe_connections = {}
    }
data:extend{dmT5}

-- Technology MK3 --
local dt5T = {}
dt5T.name = "StorageTankMK2_5"
dt5T.type = "technology"
dt5T.icon = "__Mobile_Factory__/graphics/icones/DimensionalTank5.png"
dt5T.icon_size = 32
dt5T.unit = {
	count=5,
	time=60,
	ingredients={
		{"DimensionalCrystal", 1}
	}
}
dt5T.prerequisites = {"StorageTankMK1_4", "StorageTankMK1_5"}
dt5T.effects = {{type="nothing", effect_description={"description.DimensionalTank5MK2"}}}
data:extend{dt5T}