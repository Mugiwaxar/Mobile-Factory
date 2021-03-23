-- MOBILE FACTORY PROTOTYPE AND UPGRADE --
require("prototypes/entity/mobile-factory-base.lua")

-- Mobile Factory GT --
createNewMF("GTMobileFactory", {1,0.2,0.2}, 0.7, "b", "__Mobile_Factory_Graphics__/graphics/mobile-factory/QuickMF.png")
data.raw.car.GTMobileFactory.max_health = 1000
data.raw.car.GTMobileFactory.consumption = "800KW"
data.raw.car.GTMobileFactory.weight = 8000
data.raw.car.GTMobileFactory.rotation_speed = 0.75 / 60
data.raw.car.GTMobileFactory.effectivity = 2.3
data.raw.car.GTMobileFactory.braking_power = "4200kW"
data.raw.car.GTMobileFactory.turret_rotation_speed = 0.55 / 60
data.raw.car.GTMobileFactory.turret_return_timeout = 120
data.raw.car.GTMobileFactory.equipment_grid = "MFEquipmentGridGT"
data.raw.car.GTMobileFactory.inventory_size = 3
data.raw.recipe.GTMobileFactory.ingredients =
{
	{"car", 1},
    {"CrystalizedCircuit", 35},
    {"MachineFrame3", 15}
}
data.raw.technology.GTMobileFactory.unit =
{
	count=10,
		time=60,
		ingredients={
			{"DimensionalSample", 100},
			{"DimensionalCrystal", 1}
		}
}

-- Hovering Factory --
createNewMF("HMobileFactory", {49,92,255}, 0.9, "c",  "__Mobile_Factory_Graphics__/graphics/mobile-factory/HMF.png")
data.raw.car.HMobileFactory.max_health = 2000
data.raw.car.HMobileFactory.consumption = "550kW"
data.raw.car.HMobileFactory.weight = 30000
data.raw.car.HMobileFactory.braking_power = "400kW"
data.raw.car.HMobileFactory.rotation_speed = 0.15 / 60
data.raw.car.HMobileFactory.effectivity = 0.8
data.raw.car.HMobileFactory.equipment_grid = "MFEquipmentGridH"
data.raw.car.HMobileFactory.inventory_size = 8
data.raw.car.HMobileFactory.collision_mask = {}
data.raw.car.HMobileFactory.animation.layers[3].shift = util.by_pixel(17.75, 80)
data.raw.car.HMobileFactory.selection_priority = 120
data.raw.recipe.HMobileFactory.ingredients =
{
	{"MobileFactory", 1},
    {"CrystalizedCircuit", 20},
    {"MachineFrame3", 25},
	{"EnergyCore", 1}
}
data.raw.technology.HMobileFactory.unit =
{
	count=10,
		time=60,
		ingredients={
			{"DimensionalSample", 75},
			{"DimensionalCrystal", 2}
		}
}
