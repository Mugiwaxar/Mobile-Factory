-- THE BASE MOBILE FACTORY PROTOTYPE --

-- Create Mobile Factory entity (Copy from base tank) --
local mf = table.deepcopy(data.raw.car.tank)
mf.name = "MobileFactory"
mf.order = "a"
mf.equipment_grid = "MFEquipmentGrid"
mf.minable = {mining_time = 1.5, result = "MobileFactory"}
mf.inventory_size = 20
mf.max_health = 100000
mf.consumption = "3MW"
mf.weight = 100000
mf.braking_power = "400kW"
mf.guns = {"mfTank-cannon","mfTank-flamethrower","mfTank-machine-gun"}
mf.animation =
{
	priority = "low",
	width = 269,
	height = 212,
	frame_count = 2,
	direction_count = 64,
	shift = util.by_pixel(-4.75, -10),
	animation_speed = 8,
	max_advance = 1,
	scale = 1.3,
	stripes =
	{
		{
		filename = "__Mobile_Factory__/graphics/mobileFactory/hr-tank-base-1.png",
		width_in_frames = 2,
		height_in_frames = 16
		},
		{
		filename = "__Mobile_Factory__/graphics/mobileFactory/hr-tank-base-2.png",
		width_in_frames = 2,
		height_in_frames = 16
		},
		{
		filename = "__Mobile_Factory__/graphics/mobileFactory/hr-tank-base-3.png",
		width_in_frames = 2,
		height_in_frames = 16
		},
		{
		filename = "__Mobile_Factory__/graphics/mobileFactory/hr-tank-base-4.png",
		width_in_frames = 2,
		height_in_frames = 16
		}
	}
}
mf.turret_animation =
{
	filename = "__Mobile_Factory__/graphics/mobileFactory/hr-tank-turret.png",
	priority = "low",
	line_length = 8,
	width = 179,
	height = 132,
	frame_count = 1,
	direction_count = 64,
	shift = util.by_pixel(-4.75, -50),
	animation_speed = 8,
	scale = 1.3
}
data:extend{mf}

-- Create Mobile Factory Item --
local mfI = {}
mfI.type = "item-with-entity-data"
mfI.name = "MobileFactory"
mfI.icon = "__Mobile_Factory__/graphics/mobileFactory/tank.png"
mfI.icon_size = 32
mfI.place_result = "MobileFactory"
mfI.subgroup = "MobileFactory"
mfI.order = "a"
mfI.stack_size = 1
data:extend{mfI}
