-------------------- FLAG -------------------
require("utils/settings.lua")

-- Create a Flag --
function createFlag(name, order, MachineFrameCount, area, scale)

	-- Item --
	local fI = {}
	fI.type = "item-with-tags"
	fI.name = name
	fI.icon = "__Mobile_Factory_Graphics__/graphics/jet/" .. name .. "I.png"
	fI.icon_size = 64
	fI.subgroup = "Jet"
	fI.place_result = name
    fI.order = order
	fI.stack_size = 20
	data:extend{fI}
	
	-- Recipe --
	local fR = {}
	fR.type = "recipe"
	fR.name = name
	fR.energy_required = 1
	fR.enabled = false
	fR.ingredients =
	{
      {"MachineFrame", MachineFrameCount}
    }
	fR.result = name
	data:extend{fR}
	
	-- Technology --
	table.insert(data.raw.technology.MiningJet.effects, {type="unlock-recipe", recipe=name})
	
	-- Entity --
	local fE = {}
	fE.type = "beacon"
	fE.name = name
	fE.icon = "__Mobile_Factory_Graphics__/graphics/jet/" .. name .. "I.png"
	fE.icon_size = 64
	fE.max_health = 250
	fE.collision_box = {{-1*scale, -1*scale},{1*scale, 1*scale}}
	fE.selection_box = fE.collision_box
	fE.minable = {mining_time = 0.2, result = name}
	fE.flags = {"placeable-neutral", "player-creation"}
	fE.radius_visualisation_picture = data.raw.beacon.beacon.radius_visualisation_picture
	fE.radius_visualisation_picture.scale = 2
	fE.allowed_effects = {}
	fE.supply_area_distance = area
	fE.energy_usage = "1J"
	fE.base_picture =
	{
		layers =
		{
			{
				filename = "__Mobile_Factory_Graphics__/graphics/jet/" .. name .. "E.png",
				width = 450,
				height = 900,
				scale = scale/4,
				shift = {0.35*scale, -2*scale}
			},
			{
				filename = "__Mobile_Factory_Graphics__/graphics/jet/MiningJetFlagS.png",
				width = 200,
				height = 100,
				scale = scale,
				shift = {2*scale, 0.08*scale},
				draw_as_shadow = true
			}
		}
	}
	fE.animation =
	{
		filename = "__Mobile_Factory_Graphics__/graphics/Alpha.png",
		width = 1,
		height = 1,
		line_length = 1,
		frame_count = 1,
		animation_speed = 1
	}
	fE.animation_shadow =
	{
		filename = "__Mobile_Factory_Graphics__/graphics/Alpha.png",
		width = 1,
		height = 1,
		line_length = 1,
		frame_count = 1,
		animation_speed = 1,
	}
	fE.energy_source =
    {
		type = "electric",
		emissions_per_minute = 0,
		usage_priority = "secondary-input",
		render_no_power_icon = false,
		render_no_network_icon = false,
		buffer_capacity = "1J",
		input_flow_limit = "0J",
		output_flow_limit = "0J"

    }
	fE.distribution_effectivity = 1
	fE.module_specification =
	{
		module_slots = 0,
		module_info_icon_shift = {0, 0.5},
		module_info_multi_row_initial_height_modifier = -0.3
	}
	data:extend{fE}
	
end

createFlag("MiningJetFlagMK1", "z1", 1, _mfMiningJetFlagMK1Radius/2, 0.3)
createFlag("MiningJetFlagMK2", "z1", 3, _mfMiningJetFlagMK2Radius/2, 0.5)
createFlag("MiningJetFlagMK3", "z1", 5, _mfMiningJetFlagMK3Radius/2, 0.7)
createFlag("MiningJetFlagMK4", "z1", 7, _mfMiningJetFlagMK4Radius/2, 1)