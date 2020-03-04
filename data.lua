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
require("prototypes/entity/wireless-data-transmitter.lua")
require("prototypes/entity/wireless-data-receiver.lua")
require("prototypes/entity/energy-cube.lua")
require("prototypes/entity/deep-storage.lua")
require("prototypes/entity/ore-cleaner.lua")
require("prototypes/entity/fluid-extractor.lua")
require("prototypes/entity/jet.lua")
require("prototypes/entity/flag.lua")
require("prototypes/entity/temp-chest.lua")
require("prototypes/resource/dimensional-ore.lua")
require("prototypes/resource/dimensional-fluid.lua")
require("prototypes/item/dimensional-sample.lua")
require("prototypes/item/dimensional-plate.lua")
require("prototypes/item/dimensional-crystal.lua")
require("prototypes/item/dimensional-electronic.lua")
require("prototypes/item/machine-frame.lua")
require("prototypes/item/oxycoal.lua")
require("prototypes/item/hydrocoal.lua")
require("prototypes/item/elements.lua")
require("prototypes/item/quatron.lua")
require("prototypes/item/shield.lua")
require("prototypes/item/energy-core.lua")
require("prototypes/tile/lab-tile.lua")
require("prototypes/tile/void-tile.lua")
require("prototypes/tile/dimensional-tile.lua")
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
require("prototypes/erya/erya-intermediates.lua")
require("prototypes/erya/erya-collector.lua")
require("prototypes/erya/erya-structures.lua")
require("prototypes/winter/snow-tiles.lua")
if mods["omnimatter"] then require("utils/omnimatter.lua") end


------------------ ADD ITEM-GROUP CATEGORY ----------------
data:extend{
	{
		type="item-group",
		name="MobileFactory",
		icon="__Mobile_Factory_Graphics__/graphics/icones/MFIcon.png",
		icon_size="32",
		order="x"
	},
	{
		type="item-group",
		name="Erya",
		icon="__Mobile_Factory_Graphics__/graphics/Erya/EryaPowder.png",
		icon_size="256",
		order="y"
	},
	{
		type="item-group",
		name="Elements",
		icon="__Mobile_Factory_Graphics__/graphics/icones/Elements.png",
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
		name="Resources",
		group="MobileFactory",
		order="b"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Intermediate",
		group="MobileFactory",
		order="c"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="DimensionalStuff",
		group="MobileFactory",
		order="d"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="DataSerialization",
		group="MobileFactory",
		order="e"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Jet",
		group="MobileFactory",
		order="e2"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Equipments",
		group="MobileFactory",
		order="f"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Poles",
		group="MobileFactory",
		order="g"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Tiles",
		group="MobileFactory",
		order="h"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Modules1",
		group="MobileFactory",
		order="i"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Modules2",
		group="MobileFactory",
		order="j"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="EryaRessources",
		group="Erya",
		order="a"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="EryaIntermediates",
		group="Erya",
		order="b"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="EryaLogistic",
		group="Erya",
		order="c"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="EryaProduction",
		group="Erya",
		order="d"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="EryaWar",
		group="Erya",
		order="e"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Molecules",
		group="Elements",
		order="f"
	}
}
	
data:extend{
	{
		type="item-subgroup",
		name="Elements",
		group="Elements",
		order="a"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="SciencePack",
		group="Elements",
		order="b"
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

data:extend{
	{
		type="recipe-category",
		name="EryaPowder",
		order="d"
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
local equipments = {"armor", "mfEquipments"}
if mods["SchallGunPod"] then
	table.insert(equipments, "vehicle")
	table.insert(equipments, "armoured-vehicle")
	table.insert(equipments, "tank")
	table.insert(equipments, "tank-M")
	table.insert(equipments, "tank-H")
end
if mods["bobvehicleequipment"] then
	table.insert(equipments, "armoured-vehicle")
	table.insert(equipments, "vehicle")
	table.insert(equipments, "car")
	table.insert(equipments, "tank")
end
data:extend{
	{
		type="equipment-grid",
		equipment_categories=equipments,
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

data:extend{
	{
		type="equipment-grid",
		equipment_categories={"armor", "mfEquipments"},
		name="MFEquipmentGridH",
		height=12,
		width=12
	}
}


----------------------- ADD SPRITES -----------------------
data:extend{
    {
        type = "sprite",
        name = "MoveIcon",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/moveIcon.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "MoveIconOv",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/moveIconOv.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "LockIcon",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/LockI.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "LockIconReed",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/LockIReed.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "ArrowIconDown",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/ArrowIconDown.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "ArrowIconDownOv",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/ArrowIconDownOv.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "ArrowIconUp",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/ArrowIconUp.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "ArrowIconUpOv",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/ArrowIconUpOv.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "OptionIcon",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/OptionIcon.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "CloseIcon",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/CloseIcon.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "MFIcon",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/MFIcon.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
	{
		type = "sprite",
		name = "MFIconExc",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/MFIconExc.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "MFTPIcon",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/MFTPIcon.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "MFTPIconDisabled",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/MFTPIconDisabled.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
    {
        type = "sprite",
        name = "MFIconI",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/MFIconI.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "InspectI",
        filename = "__Mobile_Factory_Graphics__/graphics/icones/MGlass.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
	{
		type = "sprite",
		name = "PortIcon",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/PortIcon.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "LockMFCIcon",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/LockMFC.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "LockMFOIcon",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/LockMFO.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "EnergyDrainIcon",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/TecEnergyDrain1.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "EnergyDrainIconDisabled",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/EnergyDrainDisabled.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "FluidDrainIcon",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/TecFluidDrain1.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "FluidDrainIconDisabled",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/FluidDrainDisabled.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "EnergyDistributionIcon",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/TecEnergyDistribution1.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "EnergyDistributionIconDisabled",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/EnergyDistributionDisabled.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "ItemDrainIcon",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/TechItemDrain.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "ItemDrainIconDisabled",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/ItemDrainDisabled.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "QuatronIcon",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/Quatron.png",
		size = 32,
		flags = {"icon"}
	}
}

data:extend{
	{
		type = "sprite",
		name = "QuatronIconDisabled",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/QuatronDisabled.png",
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
	filename = "__Mobile_Factory_Graphics__/sounds/EnterMF.ogg",
	preload = true
	}
}
data:extend{
	{
	type = "sound",
	name = "MFLeave",
	category = "game-effect",
	filename = "__Mobile_Factory_Graphics__/sounds/LeaveMF.ogg",
	preload = true
	}
}


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


-------------------- SHORTCUTS --------------------
data:extend{
	{
	type = "custom-input",
	name = "TTGUIKey",
	key_sequence = "mouse-button-3"
	}
}