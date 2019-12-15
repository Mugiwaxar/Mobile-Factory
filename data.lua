require("prototypes/entity/mobile-factory.lua")
require("prototypes/entity/factory-chest.lua")
require("prototypes/entity/dimensional-lab.lua")
require("prototypes/entity/dimensional-substation.lua")
require("prototypes/entity/dimensional-furnace.lua")
require("prototypes/entity/dimensional-accumulator.lua")
require("prototypes/entity/equalizer.lua")
require("prototypes/entity/power-drain-pole.lua")
require("prototypes/entity/logistic-fluid-pole.lua")
require("prototypes/entity/dimensional-tank-MK1.lua")
require("prototypes/entity/dimensional-tank-MK2.lua")
require("prototypes/entity/crystallizer.lua")
require("prototypes/entity/dimensional-plant.lua")
require("prototypes/entity/basic-solar-panel.lua")
require("prototypes/entity/data-center.lua")
require("prototypes/entity/matter-serializer.lua")
require("prototypes/entity/matter-printer.lua")
require("prototypes/entity/data-storage.lua")
require("prototypes/entity/energy-cube-mk1.lua")
require("prototypes/entity/ore-silot.lua")
require("prototypes/entity/ore-cleaner.lua")
require("prototypes/entity/fluid-extractor.lua")
require("prototypes/resource/dimensional-ore.lua")
require("prototypes/resource/dimensional-fluid.lua")
require("prototypes/item/dimensional-sample.lua")
require("prototypes/item/dimensional-plate.lua")
require("prototypes/item/dimmensional-crystal.lua")
require("prototypes/item/oxycoal.lua")
require("prototypes/item/elements.lua")
require("prototypes/item/quatron.lua")
require("prototypes/item/shield.lua")
require("prototypes/tile/lab-tile.lua")
require("prototypes/tile/void-tile.lua")
require("prototypes/module/energy-module.lua")
require("prototypes/module/fluid-module.lua")
require("prototypes/beam/RedBeam.lua")
require("prototypes/beam/BlueBeam.lua")
require("prototypes/beam/PurpleBeam.lua")
require("prototypes/beam/GreenBeam.lua")
require("prototypes/beam/BigGreenBeam.lua")
require("prototypes/beam/BigPurpleBeam.lua")
require("prototypes/beam/OCBeam.lua")
require("prototypes/technology/energy-laser.lua")
require("prototypes/technology/fluid-laser.lua")
require("prototypes/technology/control-center.lua")
require("prototypes/technology/matter-serialization.lua")
require("prototypes/gun/tank-guns.lua")
require("prototypes/animation/shield.lua")
require("prototypes/animation/red-energy-orb.lua")
if mods["omnimatter"] then require("utils/omnimatter.lua") end
		


------------------ ADD ITEM-GROUP CATEGORY ----------------
data:extend{
	{
		type="item-group",
		name="MobileFactory",
		icon="__Mobile_Factory__/graphics/icones/MFIcon.png",
		icon_size="32",
		order="y"
	},
	{
		type="item-group",
		name="Elements",
		icon="__Mobile_Factory__/graphics/icones/Elements.png",
		icon_size="32",
		order="z"
	}
}


----------------- ADD ITEM-SUBGROUP CATEGORY --------------
data:extend{
	{
		type="item-subgroup",
		name="MobileFactory",
		group="MobileFactory",
		order="a"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Equipments",
		group="MobileFactory",
		order="a2"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Resources",
		group="MobileFactory",
		order="a3"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="DimensionalStuff",
		group="MobileFactory",
		order="b"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Pad",
		group="MobileFactory",
		order="b2"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="DataSerialization",
		group="MobileFactory",
		order="b3"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Modules1",
		group="MobileFactory",
		order="c"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Modules2",
		group="MobileFactory",
		order="d"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Poles",
		group="MobileFactory",
		order="b3"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Capsules",
		group="MobileFactory",
		order="b4"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Molecules",
		group="Elements",
		order="a"
	}
}
	
data:extend{
	{
		type="item-subgroup",
		name="Elements",
		group="Elements",
		order="b"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="SciencePack",
		group="Elements",
		order="c"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Quatrons",
		group="Elements",
		order="z"
	}
}

-------------------- ADD RECIPE CATEGORY ------------------
data:extend{
	{
		type="recipe-category",
		name="DimensionalSmelting",
		order="a"
	}
}

data:extend{
	{
		type="recipe-category",
		name="DimensionalCrystallizaton",
		order="b"
	}
}	

data:extend{
	{
		type="recipe-category",
		name="Elements",
		order="c"
	}
}

------------------ ADD EQUIPMENT CATEGORY ----------------
data:extend{
	{
		type="equipment-category",
		name="mfEquipments",
		order="a"
	}
}

-------------------- ADD EQUIPMENT GRID ------------------
data:extend{
	{
		type="equipment-grid",
		equipment_categories={"armor", "mfEquipments"},
		name="MFEquipmentGrid",
		height=30,
		width=30
	}
}

data:extend{
	{
		type="equipment-grid",
		equipment_categories={"armor", "mfEquipments"},
		name="MFEquipmentGridGT",
		height=4,
		width=4
	}
}


----------------------- ADD SPRITES -----------------------
data:extend{
    {
        type = "sprite",
        name = "MoveIcon",
        filename = "__Mobile_Factory__/graphics/icones/moveIcon.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "MoveIconOv",
        filename = "__Mobile_Factory__/graphics/icones/moveIconOv.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "LockIcon",
        filename = "__Mobile_Factory__/graphics/icones/LockI.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "LockIconReed",
        filename = "__Mobile_Factory__/graphics/icones/LockIReed.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "ArrowIconDown",
        filename = "__Mobile_Factory__/graphics/icones/ArrowIconDown.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "ArrowIconDownOv",
        filename = "__Mobile_Factory__/graphics/icones/ArrowIconDownOv.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "ArrowIconUp",
        filename = "__Mobile_Factory__/graphics/icones/ArrowIconUp.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "ArrowIconUpOv",
        filename = "__Mobile_Factory__/graphics/icones/ArrowIconUpOv.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "OptionIcon",
        filename = "__Mobile_Factory__/graphics/icones/OptionIcon.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "CloseIcon",
        filename = "__Mobile_Factory__/graphics/icones/CloseIcon.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "MFIcon",
        filename = "__Mobile_Factory__/graphics/icones/MFIcon.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
	{
		type = "sprite",
		name = "MFIconExc",
		filename = "__Mobile_Factory__/graphics/icones/MFIconExc.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "MFTPIcon",
		filename = "__Mobile_Factory__/graphics/icones/MFTPIcon.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "MFTPIconDisabled",
		filename = "__Mobile_Factory__/graphics/icones/MFTPIconDisabled.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
    {
        type = "sprite",
        name = "MFIconI",
        filename = "__Mobile_Factory__/graphics/icones/MFIconI.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "InspectI",
        filename = "__Mobile_Factory__/graphics/icones/MGlass.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
	{
		type = "sprite",
		name = "PortIcon",
		filename = "__Mobile_Factory__/graphics/icones/PortIcon.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "EnergyDrainIcon",
		filename = "__Mobile_Factory__/graphics/icones/TecEnergyDrain1.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "EnergyDrainIconDisabled",
		filename = "__Mobile_Factory__/graphics/icones/EnergyDrainDisabled.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "FluidDrainIcon",
		filename = "__Mobile_Factory__/graphics/icones/TecFluidDrain1.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "FluidDrainIconDisabled",
		filename = "__Mobile_Factory__/graphics/icones/FluidDrainDisabled.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "EnergyDistributionIcon",
		filename = "__Mobile_Factory__/graphics/icones/TecEnergyDistribution1.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "EnergyDistributionIconDisabled",
		filename = "__Mobile_Factory__/graphics/icones/EnergyDistributionDisabled.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "ItemDrainIcon",
		filename = "__Mobile_Factory__/graphics/icones/TechItemDrain.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "ItemDrainIconDisabled",
		filename = "__Mobile_Factory__/graphics/icones/ItemDrainDisabled.png",
		size = 32,
		flags = {"icon"}
	}
}

------------------------- ADD FONTS -------------------
data:extend{
	{
    type = "font",
    name = "TitleFont",
	size = 18,
    from = "default-bold"
	}
}

data:extend{
	{
    type = "font",
    name = "LabelFont",
	size = 10,
    from = "default"
	}
}


------------------------- ADD SOUNDS ---------------------
data:extend{
	{
	type = "sound",
	name = "MFEnter",
	category = "game-effect",
	filename = "__Mobile_Factory__/sounds/EnterMF.ogg",
	preload = true
	}
}
data:extend{
	{
	type = "sound",
	name = "MFLeave",
	category = "game-effect",
	filename = "__Mobile_Factory__/sounds/LeaveMF.ogg",
	preload = true
	}
}


------------------------ ADD REDCROSS ----------------------
local RC = table.deepcopy(data.raw.fluid["crude-oil"])
RC.name = "RedCross"
RC.icon = "__Mobile_Factory__/graphics/icones/RedCross.png"
RC.subgroup = "Resources"
RC.order = "zzz"
RC.fuel_category = nil
RC.fuel_value = nil
RC.fuel_acceleration_multiplier = nil
RC.fuel_top_speed_multiplier = nil
RC.fuel_emissions_multiplier = nil
RC.fuel_glow_color = nil
data:extend{RC}


-------------------- SET ORES STACK TO 1000 --------------------
function setStackTo1000(itemName)
	local item = data.raw.item[itemName]
	item.stack_size = 1000
end

setStackTo1000("coal")
setStackTo1000("copper-ore")
setStackTo1000("iron-ore")
setStackTo1000("stone")
setStackTo1000("uranium-ore")