require("prototypes/entity/mobile-factory.lua")
require("prototypes/entity/dimensional-substation.lua")
require("prototypes/entity/dimensional-plant.lua")
require("prototypes/entity/basic-solar-panel.lua")
require("prototypes/entity/jump-drive.lua")
require("prototypes/entity/jump-charger.lua")
require("prototypes/entity/energy-cube.lua")
require("prototypes/entity/energy-laser.lua")
require("prototypes/entity/quatron-reactor.lua")
require("prototypes/entity/ore-cleaner.lua")
require("prototypes/entity/fluid-extractor.lua")
require("prototypes/entity/resource-catcher.lua")
require("prototypes/entity/temp-chest.lua")
require("prototypes/entity/temp-tank.lua")
require("prototypes/entity/mf-deploy.lua")
require("prototypes/entity/dimensional-belt.lua")
require("prototypes/entity/dimensional-pipe.lua")
require("prototypes/entity/dimensional-pole.lua")
require("prototypes/matter-serialization/network-controller.lua")
require("prototypes/matter-serialization/network-access-point.lua")
require("prototypes/matter-serialization/data-storage.lua")
require("prototypes/matter-serialization/deep-storage.lua")
require("prototypes/matter-serialization/deep-tank.lua")
require("prototypes/matter-serialization/fluid-interactor.lua")
require("prototypes/matter-serialization/matter-interactor.lua")
require("prototypes/matter-serialization/data-assembler.lua")
require("prototypes/matter-serialization/network-explorer.lua")
require("prototypes/item/oxycoal.lua")
require("prototypes/item/hydrocoal.lua")
require("prototypes/item/elements.lua")
require("prototypes/item/quatron.lua")
require("prototypes/item/shield.lua")
require("prototypes/tile/lab-tile.lua")
require("prototypes/tile/void-tile.lua")
require("prototypes/tile/dimensional-tile.lua")
require("prototypes/module/energy-module.lua")
require("prototypes/beam/RedBeam.lua")
require("prototypes/beam/BlueBeam.lua")
require("prototypes/beam/BlueBeam2.lua")
require("prototypes/beam/PurpleBeam.lua")
require("prototypes/beam/GreenBeam.lua")
require("prototypes/beam/BigGreenBeam.lua")
require("prototypes/beam/BigPurpleBeam.lua")
require("prototypes/beam/OCBeam.lua")
require("prototypes/beam/EnergyLaserBeam.lua")
require("prototypes/beam/PurpleQuatronBeam.lua")
require("prototypes/technology/energy.lua")
require("prototypes/technology/fluid-laser.lua")
require("prototypes/technology/control-center.lua")
require("prototypes/technology/matter-serialization.lua")
require("prototypes/gun/tank-guns.lua")
require("prototypes/animation/shield.lua")
require("prototypes/animation/red-energy-orb.lua")
require("prototypes/animation/MFTP.lua")
if mods["omnimatter"] then require("utils/omnimatter.lua") end


------------------ ADD ITEM-GROUP CATEGORY ----------------
data:extend{
	{
		type="item-group",
		name="MobileFactory",
		icon="__Mobile_Factory_Graphics__/graphics/icones/MFIcon.png",
		icon_size="32",
		order="x"
	}
}

data:extend{
	{
		type="item-group",
		name="Elements",
		icon="__Mobile_Factory_Graphics__/graphics/icones/Elements.png",
		icon_size="32",
		order="z"
	}
}

-- if settings.startup["MF-enable-erya"].value == true then
-- 	data:extend{
-- 		{
-- 			type="item-group",
-- 			name="Erya",
-- 			icon="__Mobile_Factory_Graphics__/graphics/Erya/EryaPowder.png",
-- 			icon_size="256",
-- 			order="y"
-- 		}
-- 	}
-- end

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
		name="Energy",
		group="MobileFactory",
		order="f"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="QuatronLogistic",
		group="MobileFactory",
		order="g"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Tiles",
		group="MobileFactory",
		order="i"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="Modules1",
		group="MobileFactory",
		order="j"
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
		order="x"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="QuatronsToCell",
		group="Elements",
		order="y"
	}
}

data:extend{
	{
		type="item-subgroup",
		name="CellToQuatrons",
		group="Elements",
		order="z"
	}
}

-------------------- ADD RECIPE CATEGORY ------------------

data:extend{
	{
		type="recipe-category",
		name="Elements",
		order="a"
	}
}

data:extend{
	{
		type="recipe-category",
		name="Nothing",
		order="z"
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
		equipment_categories=equipments,
		name="MFEquipmentGridGT",
		height=4,
		width=4
	}
}

data:extend{
	{
		type="equipment-grid",
		equipment_categories=equipments,
		name="MFEquipmentGridH",
		height=12,
		width=12
	}
}


----------------------- ADD SPRITES -----------------------

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
        name = "ArrowIconUp",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/ArrowIconUp.png",
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
        name = "PlusIcon",
		filename = "__Mobile_Factory_Graphics__/graphics/icones/PlusIcon.png",
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
        name = "SwitchIcon",
        filename = "__Mobile_Factory__/graphics/SwtichArrows.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "MFJDIcon",
        filename = "__Mobile_Factory__/graphics/JumpDriveI.png",
        size = 128,
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
        name = "MFDeploy",
        filename = "__Mobile_Factory__/graphics/MFDeployI.png",
        size = 32,
        flags = {"icon"}
    }
}

data:extend{
    {
        type = "sprite",
        name = "MFDeployE",
        filename = "__Mobile_Factory__/graphics/MobileFactoryE.png",
        width = 400,
		height = 600,
        flags = {"icon"}
    }
}

-- data:extend{
--     {
--         type = "sprite",
--         name = "SyncAreaIcon",
--         filename = "__Mobile_Factory_Graphics__/graphics/icones/MFIconSyncArea.png",
--         size = 32,
--         flags = {"icon"}
--     }
-- }

-- data:extend{
-- 	{
-- 		type = "sprite",
-- 		name = "SyncAreaIconDisabled",
-- 		filename = "__Mobile_Factory_Graphics__/graphics/icones/MFIconSyncAreaDisabled.png",
-- 		size = 32,
-- 		flags = {"icon"}
-- 	}
-- }

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
data:extend{
	{
	type = "sound",
	name = "MFSimpleTP",
	category = "game-effect",
	filename = "__Mobile_Factory__/graphics/SimpleTP.ogg",
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
	name = "OpenTTGUI",
	key_sequence = "mouse-button-1"
	}
}

data:extend{
	{
	type = "custom-input",
	name = "CloseGUI",
	key_sequence = "ESCAPE"
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
	size = 12,
    from = "default"
	}
}

data:extend{
	{
    type = "font",
    name = "LabelFont2",
	size = 14,
    from = "default"
	}
}

-------------------- STYLES --------------------
local outer_frame_light = outer_frame_light()
outer_frame_light.base.center = {position = {42,8}, size=1}
data.raw["gui-style"].default.MF_Inventory_scroll_pan =
{
	type = 'scroll_pane_style',
	padding = 0,
	extra_padding_when_activated = 0,
	extra_right_padding_when_activated = -12,
	graphical_set = outer_frame_light,
	background_graphical_set = {
		base = {
			position = {282, 17},
			corner_size = 8,
			overall_tiling_horizontal_padding = 0,
			overall_tiling_horizontal_size = 37,
			overall_tiling_horizontal_spacing = 0,
			overall_tiling_vertical_padding = 0,
			overall_tiling_vertical_size = 37,
			overall_tiling_vertical_spacing = 0
	  	}
	  }
}

data.raw["gui-style"].default.MF_Options_scroll_pan =
{
	type = "scroll_pane_style",
	extra_padding_when_activated = 0,
	graphical_set = 
	{
		position = {136, 0},
		corner_size = 8,
		shadow = {}
	},
	background_graphical_set =
	{
		position = {136, 0},
        corner_size = 8,
	},
	vertical_scrollbar_style =
      {
        type = "vertical_scrollbar_style",
        -- background_graphical_set = {position = {136, 0}, corner_size = 8, opacity = 0.7, blend_mode = "multiplicative-with-alpha"}
      }
}

data.raw["gui-style"].default.MF_DeepTank_scroll_pan =
{
	type = "scroll_pane_style",
	graphical_set =
	{
		base =
		{
		position = {17, 0},
		corner_size = 8,
		center = {position = {42, 8}, size = 1},
		draw_type = "outer"
		},
		shadow = default_inner_glow(hard_shadow_color, 0.5)
	},
	background_graphical_set =
	{
		position = {282, 17},
		corner_size = 8,
		overall_tiling_vertical_size = 58,
		overall_tiling_vertical_spacing = 0,
		overall_tiling_vertical_padding = 0,
		overall_tiling_horizontal_padding = 0
	}
}

data.raw["gui-style"].default.MF_DeepStorage_scroll_pan =
{
	type = "scroll_pane_style",
	graphical_set =
	{
		base =
		{
		position = {17, 0},
		corner_size = 8,
		center = {position = {42, 8}, size = 1},
		draw_type = "outer"
		},
		shadow = default_inner_glow(hard_shadow_color, 0.5)
	},
	background_graphical_set =
	{
		position = {282, 17},
		corner_size = 8,
		overall_tiling_vertical_size = 58,
		overall_tiling_vertical_spacing = 0,
		overall_tiling_vertical_padding = 0,
		overall_tiling_horizontal_padding = 0
	}
}

data.raw["gui-style"].default.MF_SwtichGUI_scroll_pan =
{
	type = "scroll_pane_style",
	graphical_set =
	{
		base =
		{
		position = {17, 0},
		corner_size = 8,
		center = {position = {42, 8}, size = 1},
		draw_type = "outer"
		},
		shadow = default_inner_glow(hard_shadow_color, 0.5)
	},
	background_graphical_set =
	{
		position = {282, 17},
		corner_size = 8,
		overall_tiling_vertical_size = 58,
		overall_tiling_vertical_spacing = 0,
		overall_tiling_vertical_padding = 0,
		overall_tiling_horizontal_padding = 0
	}
}

data.raw["gui-style"].default.MF_TPGUI_scroll_pan =
{
	type = "scroll_pane_style",
	graphical_set =
	{
		base =
		{
		position = {17, 0},
		corner_size = 8,
		center = {position = {42, 8}, size = 1},
		draw_type = "outer"
		},
		shadow = default_inner_glow(hard_shadow_color, 0.5)
	},
	background_graphical_set =
	{
		position = {282, 17},
		corner_size = 8,
		overall_tiling_vertical_size = 72,
		overall_tiling_vertical_spacing = 0,
		overall_tiling_vertical_padding = 0,
		overall_tiling_horizontal_padding = 0
	}
}

data.raw["gui-style"].default.MF_DA_scroll_pan =
{
	type = "scroll_pane_style",
	graphical_set =
	{
		base =
		{
		position = {17, 0},
		corner_size = 8,
		center = {position = {42, 8}, size = 1},
		draw_type = "outer"
		},
		shadow = default_inner_glow(hard_shadow_color, 0.5)
	},
	background_graphical_set =
	{
		position = {282, 17},
		corner_size = 8,
		overall_tiling_vertical_size = 58,
		overall_tiling_vertical_spacing = 0,
		overall_tiling_vertical_padding = 0,
		overall_tiling_horizontal_padding = 0
	}
}

data.raw["gui-style"].default.MF_JD_scroll_pan =
{
	type = "scroll_pane_style",
	graphical_set =
	{
		base =
		{
		position = {17, 0},
		corner_size = 8,
		center = {position = {42, 8}, size = 1},
		draw_type = "outer"
		},
		shadow = default_inner_glow(hard_shadow_color, 0.5)
	},
	background_graphical_set =
	{
		position = {282, 17},
		corner_size = 8,
		overall_tiling_vertical_size = 84,
		overall_tiling_vertical_spacing = 0,
		overall_tiling_vertical_padding = 0,
		overall_tiling_horizontal_padding = 0
	}
}

local purpleTint = {150, 50, 160}
local lightPurpleTint = {200, 120, 220}
data.raw["gui-style"].default.MF_Button_Purple =
{
	type = "button_style",
	parent = "shortcut_bar_button",
	default_graphical_set =
	{
		base = {position = {346, 759}, corner_size = 8, tint=purpleTint},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	hovered_graphical_set =
	{
		base = {position = {346, 759}, corner_size = 8, tint=lightPurpleTint},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5),
		glow = offset_by_2_default_glow({132, 177, 198, 127}, 0.5)
	},
	clicked_graphical_set =
	{
		base = {position = {363, 759}, corner_size = 8, tint=lightPurpleTint},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	}
}

data.raw["gui-style"].default.MF_Fake_Button_invisible =
{
	type = "button_style",
	parent = "slot_sized_button",
	default_graphical_set =
	{
		base = {position = {312, 744}, corner_size = 8, tint={0,0,0,0,}},
        shadow = {}
	},
	disabled_graphical_set =
	{
		base = {position = {312, 744}, corner_size = 8, tint={0,0,0,0,}},
        shadow = {}
	},
	hovered_graphical_set =
	{
		base = {position = {312, 744}, corner_size = 8, tint={0,0,0,0,}},
        shadow = {}
	},
	clicked_graphical_set =
	{
		base = {position = {312, 744}, corner_size = 8, tint={0,0,0,0,}},
        shadow = {}
	}
}

data.raw["gui-style"].default.MF_Button_Blue_GrayWhenDisabled =
{
	type = "button_style",
	parent = "slot_sized_button",
	default_graphical_set =
	{
		base = {position = {312, 760}, corner_size = 8},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	disabled_graphical_set =
	{
		base = {position = {329, 744}, corner_size = 8},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	hovered_graphical_set =
	{
		base = {position = {346, 760}, corner_size = 8},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5),
		glow = offset_by_2_default_glow({132, 177, 198, 127}, 0.5)
	},
	clicked_graphical_set =
	{
		base = {position = {363, 760}, corner_size = 8},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	}
}

data.raw["gui-style"].default.MF_Fake_Button_Light_Blue =
{
	type = "button_style",
	parent = "slot_sized_button",
	default_graphical_set =
	{
		base = {position = {363, 760}, corner_size = 8},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	disabled_graphical_set =
	{
		base = {position = {329, 744}, corner_size = 8},
        shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	hovered_graphical_set =
	{
		base = {position = {363, 760}, corner_size = 8},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	clicked_graphical_set =
	{
		base = {position = {363, 760}, corner_size = 8},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	}
}

data.raw["gui-style"].default.MF_Fake_Button_Blue =
{
	type = "button_style",
	parent = "shortcut_bar_button",
	default_graphical_set =
	{
		base = {position = {312, 759}, corner_size = 8},
        shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	hovered_graphical_set =
	{
		base = {position = {312, 759}, corner_size = 8},
        shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	clicked_graphical_set =
	{
		base = {position = {312, 759}, corner_size = 8},
        shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	}
}

data.raw["gui-style"].default.MF_Fake_Button_Green =
{
	type = "button_style",
	parent = "shortcut_bar_button",
	default_graphical_set =
	{
		base = {position = {312, 792}, corner_size = 8},
        shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	hovered_graphical_set =
	{
		base = {position = {312, 792}, corner_size = 8},
        shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	clicked_graphical_set =
	{
		base = {position = {312, 792}, corner_size = 8},
        shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	}
}

data.raw["gui-style"].default.MF_Fake_Button_Red =
{
	type = "button_style",
	parent = "shortcut_bar_button",
	default_graphical_set =
	{
		base = {position = {312, 776}, corner_size = 8},
        shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	hovered_graphical_set =
	{
		base = {position = {312, 776}, corner_size = 8},
        shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	clicked_graphical_set =
	{
		base = {position = {312, 776}, corner_size = 8},
        shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	}
}

data.raw["gui-style"].default.MF_Fake_Button_Purple =
{
	type = "button_style",
	parent = "shortcut_bar_button",
	default_graphical_set =
	{
		base = {position = {346, 759}, corner_size = 8, tint=purpleTint},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	hovered_graphical_set =
	{
		base = {position = {346, 759}, corner_size = 8, tint=purpleTint},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	},
	clicked_graphical_set =
	{
		base = {position = {346, 759}, corner_size = 8, tint=purpleTint},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	}
}

data.raw["gui-style"].default.filter_group_button_tab_selectable =
{
	type = "button_style",
	parent = "filter_group_button_tab",
	disabled_graphical_set =
	{
		base = {position = {363, 744}, corner_size = 8},
		shadow = offset_by_2_default_glow(default_dirt_color, 0.5)
	}
}

data.raw["gui-style"].default.MFFrame1 =
{
	type = "frame_style",
	graphical_set = {},
	border = border_image_set(),
	right_padding = 4,
	use_header_filler = false,
	title_style =
	{
	  type="label_style",
	  parent = "caption_label"
	}
}

data.raw["gui-style"].default.MFFrame2 =
{
  type = "frame_style",
  graphical_set =
  {
	base = {position = {17, 0}, corner_size = 8, draw_type = "outer", shadow = {}},
	shadow = default_inner_shadow
  }
}

data.raw["gui-style"].default.MF_Options_Frame =
{
	type = "frame_style",
	graphical_set =
	{
	  base = {position = {136, 0}, corner_size = 8, draw_type = "outer", shadow = {}},
	  shadow = default_inner_shadow
	},
	border = border_image_set(),
	right_padding = 4,
	use_header_filler = false,
	title_style =
	{
	  type="label_style",
	  parent = "caption_label"
	}
}

data.raw["gui-style"].default.MF_Options_Tabbed_Pane =
{
	type = "tabbed_pane_style",
	vertical_spacing = 0,
	padding = 0,
	tab_content_frame =
	{
		type = "frame_style",
		parent = "invisible_frame"
	},
	tab_container =
	{
		type = "horizontal_flow_style",
		left_padding = 12,
		right_padding = 12,
		horizontal_spacing = 0
	}
}