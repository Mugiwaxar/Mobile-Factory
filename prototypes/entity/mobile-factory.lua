-- Size of the Mobile Factory --
mfSize = 3

-- Create Mobile Factory entity (Copy from base tank) --
local mf = table.deepcopy(data.raw.car.tank)
mf.name = "MobileFactory"
mf.order = "a"
mf.equipment_grid = "MFEquipmentGrid"
mf.minable = nil
mf.inventory_size = 20
mf.max_health = 100000
mf.consumption = "3MW"
mf.weight = 100000
mf.braking_power = "400kW"
mf.guns = {"mfTank-cannon","mfTank-flamethrower","mfTank-machine-gun"}
local function ResizePics(tv,z)
	for k,v in pairs(tv)do if(v.filename)then
		v.scale=(v.scale or 1)*mfSize
		if(v.hr_version)then v.hr_version.scale=(v.hr_version.scale or 1)*mfSize end
		if(v.shift)then v.shift[1]=v.shift[1]*mfSize v.shift[2]=v.shift[2]*mfSize end
		if(v.hr_version.shift)then v.hr_version.shift[1]=v.hr_version.shift[1]*mfSize v.hr_version.shift[2]=v.hr_version.shift[2]*mfSize end
	end end
end


local function ResizePics(tv) for k,v in pairs(tv)do if(v.shift)then v.scale=(v.scale or 1)*mfSize if(v.hr_version)then v.hr_version.scale=(v.hr_version.scale or 1)*mfSize end end end end
ResizePics(mf.animation.layers)
ResizePics(mf.turret_animation.layers)

local function ResizeBox(tv) for k,v in pairs(tv)do tv[k][1]=tv[k][1]*mfSize tv[k][2]=tv[k][2]*mfSize end end
ResizeBox(mf.collision_box)
ResizeBox(mf.selection_box)

data:extend{mf}

-- Create Mobile Factory Item --
local mfI = table.deepcopy(data.raw["item-with-entity-data"]["tank"])
mfI.name = "MobileFactory"
mfI.place_result = "MobileFactory"
data:extend{mfI}