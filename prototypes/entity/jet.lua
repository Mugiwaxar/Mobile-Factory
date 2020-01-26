------------------------------- JET -----------------------------------------

-- Create a jet --
function createJet(name, order)

	-- Item --
	local jI = {}
	jI.type = "item"
	jI.name = name
	jI.icon = "__Mobile_Factory_Graphics__/graphics/jet/" .. name .. "I.png"
	jI.icon_size = 64
	jI.subgroup = "Jet"
    jI.order = order
	jI.stack_size = 20
	data:extend{jI}
	
	-- Recipe --
	local jR = {}
	jR.type = "recipe"
	jR.name = name
	jR.energy_required = 3
	jR.enabled = false
	jR.ingredients =
	{
      {"DimensionalCircuit", 15},
      {"MachineFrame2", 2},
      {"EnergyCore", 1}
    }
	jR.result = name
	data:extend{jR}
	
	-- Technology --
	local jT = {}
	jT.name = name
	jT.type = "technology"
	jT.icon = "__Mobile_Factory_Graphics__/graphics/jet/" .. name .. "T.png"
	jT.icon_size = 400
	jT.unit = {
	count=8,
	time=130,
	ingredients={
		{"DimensionalSample", 100},
		{"DimensionalCrystal", 1}
	}}
	jT.prerequisites = {"EnergyCore"}
	jT.effects = {{type="unlock-recipe", recipe=name}}
	data:extend{jT}
	
	-- Unit --
	local jU = {}
	jU.name = name
	jU.type = "unit"
	jU.icon = "__Mobile_Factory_Graphics__/graphics/jet/" .. name .. "I.png"
	jU.icon_size = 64
	jU.order = order
	jU.collision_box = nil
	jU.selection_box = {{-0.65, -0.65},{0.65, 0.65}}
	jU.collision_mask = {}
	jU.minable = {mining_time = 0.2, result = name}
	jU.flags = {"placeable-player", "player-creation", "not-blueprintable", "not-deconstructable"}
	jU.emissions_per_second = 0.008
	jU.max_health = 400
	jU.healing_per_tick = 1/20
	jU.movement_speed = 0.35
	jU.distance_per_frame = 1
	jU.pollution_to_join_attack = 1000000
	jU.distraction_cooldown = 0
	jU.vision_distance = 0
	jU.ai_settings = {}
	jU.max_pursue_distance = 0
	jU.render_layer = "air-object"
	jU.has_belt_immunity = true
	jU.selection_priority = 150
	jU.move_while_shooting = true
	jU.resistances =
    {
		{
			type = "physical",
			percent = 25
		},
		{
			type = "impact",
			percent = 10
		},
		{
			type = "fire",
			percent = 100
		},
		{
			type = "acid",
			percent = 40
		},
		{
			type = "poison",
			percent = 20
		},
		{
			type = "explosion",
			percent = 15
		},
		{
			type = "laser",
			percent = 30
		}
    }
	jU.run_animation =
	{
		layers =
		{
			{
				frame_count = 1,
				direction_count = 24,
				filename = "__Mobile_Factory_Graphics__/graphics/jet/" .. name .. "E.png",
				width = 400,
				height = 250,
				shift = {0,0},
				scale = 1/5,
				animation_speed = 1
			},
			{
				frame_count = 1,
				direction_count = 24,
				filename = "__Mobile_Factory_Graphics__/graphics/jet/JetS.png",
				width = 400,
				height = 250,
				draw_as_shadow = true,
				shift = {0.2,3},
				scale = 1/5,
				animation_speed = 1
			}
		}
	}
	jU.attack_parameters =
	{
		type = "beam",
		range = 1,
		cooldown = 1,
		animation = jU.run_animation,
		ammo_type =
		{
			category = "laser-turret"
		}
	}

	if name == "CombatJet" then
		jU.max_health = 1200
		jU.healing_per_tick = 1/15
		jU.vision_distance = 15
		jU.max_pursue_distance = 50
		jU.pollution_to_join_attack = 0
		jU.movement_speed = 0.4
		jU.attack_parameters =
		{
			type = "stream",
			range = 10,
			min_attack_distance = 3,
			movement_slow_down_factor = 0.7,
			cooldown = 0,
			animation = jU.run_animation,
			ammo_type =
			{
				category = "biological",
				action =
				{
					type = "direct",
					action_delivery =
					{
						type = "stream",
						stream = "flamethrower-fire-stream"
					}
				}
			}
		}
	end
	data:extend{jU}
	
end
	
	
createJet("MiningJet", "a")
createJet("ConstructionJet", "b")
createJet("RepairJet", "c")
createJet("CombatJet", "d")
	
	
	
	
	
	
	
	
	
	
	
	