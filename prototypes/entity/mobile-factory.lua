-- MOBILE FACTORY PROTOTYPE AND UPGRADE --
require("prototypes/entity/mobile-factory-base.lua")

-- Mobile Factory GT --
createNewMF("GTMobileFactory", {1,0.2,0.2}, 0.7, "b", "__Mobile_Factory__/graphics/mobileFactory/QuickMF.png")
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
      {"DimensionalCrystal", 5},
      {"DimensionalPlate", 10},
      {"speed-module", 3},
	  {"car", 1}
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