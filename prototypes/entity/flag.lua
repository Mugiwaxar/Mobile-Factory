-------------------- FLAG -------------------

-- Create a Flag --
function createFlag(name, order)

	-- Item --
	local fI = {}
	fI.type = "item"
	fI.name = name
	fI.icon = "__Mobile_Factory__/graphics/Jet/" .. name .. "I.png"
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
      {"MachineFrame", 3}
    }
	fR.result = name
	data:extend{fR}
	
	-- Entity --
	local fE = {}
	fE.type = "beacon"
	fE.name = name
	fE.icon = "__Mobile_Factory__/graphics/Jet/" .. name .. "I.png"
	fE.icon_size = 64
	fE.max_health = 250
	fE.collision_box = {{-1, -1},{1, 1}}
	fE.selection_box = fE.collision_box
	fE.minable = {mining_time = 0.2, result = name}
	fE.radius_visualisation_picture = data.raw.beacon.beacon.radius_visualisation_picture
	fE.radius_visualisation_picture.scale = 2
	fE.allowed_effects = {}
	fE.supply_area_distance = 50
	fE.energy_usage = "1J"
	fE.base_picture =
	{
		layers =
		{
			{
				filename = "__Mobile_Factory__/graphics/Jet/" .. name .. "E.png",
				width = 450,
				height = 900,
				scale = 1/4,
				shift = {0.35, -2}
			},
			{
				filename = "__Mobile_Factory__/graphics/Jet/" .. name .. "S.png",
				width = 200,
				height = 100,
				scale = 1,
				shift = {2, 0.08},
				draw_as_shadow = true
			}
		}
	}
	fE.animation =
	{
		filename = "__Mobile_Factory__/graphics/Alpha.png",
		width = 1,
		height = 1,
		line_length = 1,
		frame_count = 1,
		animation_speed = 1
	}
	fE.animation_shadow =
	{
		filename = "__Mobile_Factory__/graphics/Alpha.png",
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

createFlag("MiningJetFlag", "za")