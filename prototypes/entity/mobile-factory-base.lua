-- THE BASE MOBILE FACTORY PROTOTYPE --

-- Create Mobile Factory entity (Copy from base tank) --
local mf = table.deepcopy(data.raw.car.tank)
mf.name = "MobileFactory"
mf.order = "a"
mf.equipment_grid = "MFEquipmentGrid"
mf.minable = {mining_time = 1.5, result = "MobileFactory"}
mf.inventory_size = 10
mf.max_health = 2500
mf.consumption = "700KW"
mf.weight = 25000
mf.braking_power = "600kW"
mf.rotation_speed = 0.30 / 60
mf.guns = {"mfTank-machine-gun"}
mf.collision_box = {{-1.4, -2.5}, {1.1, 1.7}}
mf.selection_box = mf.collision_box
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
	scale = 0.7,
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
	scale = 0.7
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

-- Create the Mobile Factory Recipe --
local mfR = {}
mfR.type = "recipe"
mfR.name = "MobileFactory"
mfR.energy_required = 10
mfR.ingredients =
    {
      {"copper-plate", 10},
      {"iron-plate", 10},
    }
mfR.result = "MobileFactory"
data:extend{mfR}