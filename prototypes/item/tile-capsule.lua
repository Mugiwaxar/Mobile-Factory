-- Create tile Capsule --

-- Tile Capsule 1x1 --
local tc1 = {}
tc1.type = "capsule"
tc1.name = "TileCapsule1"
tc1.icon = "__Mobile_Factory__/graphics/icones/tileCapsule1.png"
tc1.icon_size = 32
tc1.subgroup = "Capsules"
tc1.order = "tc1"
tc1.stack_size = 1000
tc1.capsule_action = {
	type = "throw",
	attack_parameters = {
		type="projectile",
		ammo_category = "capsule",
		range=100,
		cooldown=5,
		ammo_type={
			category="capsule",
			target_type = "position",
			action=
			{
				type = "direct",
				action_delivery =
				{
				  type = "projectile",
				  projectile = "laser",
				  starting_speed = 5
				}
			}
		}
	}
}
data:extend{tc1}


-- Tile Capsule 5x5 --
local tc2 = {}
tc2.type = "capsule"
tc2.name = "TileCapsule2"
tc2.icon = "__Mobile_Factory__/graphics/icones/tileCapsule2.png"
tc2.icon_size = 32
tc2.subgroup = "Capsules"
tc2.order = "tc2"
tc2.stack_size = 1000
tc2.capsule_action = {
	type = "throw",
	attack_parameters = {
		type="projectile",
		ammo_category = "capsule",
		range=100,
		cooldown=10,
		ammo_type={
			category="capsule",
			target_type = "position",
			action=
			{
				type = "direct",
				action_delivery =
				{
				  type = "projectile",
				  projectile = "laser",
				  starting_speed = 5
				}
			}
		}
	}
}
data:extend{tc2}


-- Tile Capsule 9x9 --
local tc3 = {}
tc3.type = "capsule"
tc3.name = "TileCapsule3"
tc3.icon = "__Mobile_Factory__/graphics/icones/tileCapsule3.png"
tc3.icon_size = 32
tc3.subgroup = "Capsules"
tc3.order = "tc3"
tc3.stack_size = 1000
tc3.capsule_action = {
	type = "throw",
	attack_parameters = {
		type="projectile",
		ammo_category = "capsule",
		range=100,
		cooldown=15,
		ammo_type={
			category="capsule",
			target_type = "position",
			action=
			{
				type = "direct",
				action_delivery =
				{
				  type = "projectile",
				  projectile = "laser",
				  starting_speed = 5
				}
			}
		}
	}
}
data:extend{tc3}


-- Tile Capsule 1x1 Recipe --
local tc1R = {}
tc1R.type = "recipe"
tc1R.name = "TileCapsule1"
tc1R.energy_required = 1
tc1R.enabled = false
tc1R.ingredients =
    {
      {"DimensionalOre", 1}
    }
tc1R.result = "TileCapsule1"
data:extend{tc1R}

-- Tile Capsule 5x5 Recipe --
local tc2R = {}
tc2R.type = "recipe"
tc2R.name = "TileCapsule2"
tc2R.energy_required = 3
tc2R.enabled = false
tc2R.ingredients =
    {
      {"DimensionalOre", 25}
    }
tc2R.result = "TileCapsule2"
data:extend{tc2R}

-- Tile Capsule 9x9 Recipe --
local tc3R = {}
tc3R.type = "recipe"
tc3R.name = "TileCapsule3"
tc3R.energy_required = 5
tc3R.enabled = false
tc3R.ingredients =
    {
      {"DimensionalOre", 81}
    }
tc3R.result = "TileCapsule3"
data:extend{tc3R}



-- Tile Capsule 1x1 Technologie --
local tc1T = {}
tc1T.name = "AtomReconst1"
tc1T.type = "technology"
tc1T.icon = "__Mobile_Factory__/graphics/icones/tileCapsule1.png"
tc1T.icon_size = 32
tc1T.unit = {
	count=350,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
tc1T.prerequisites = {"DimensionalOre"}
tc1T.effects = {{type="unlock-recipe", recipe="TileCapsule1"}}
data:extend{tc1T}

-- Tile Capsule 5x5 Technologie --
local tc2T = {}
tc2T.name = "AtomReconst2"
tc2T.type = "technology"
tc2T.icon = "__Mobile_Factory__/graphics/icones/tileCapsule2.png"
tc2T.icon_size = 32
tc2T.unit = {
	count=1000,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
tc2T.prerequisites = {"AtomReconst1"}
tc2T.effects = {{type="unlock-recipe", recipe="TileCapsule2"}}
data:extend{tc2T}

-- Tile Capsule 9x9 Technologie --
local tc3T = {}
tc3T.name = "AtomReconst3"
tc3T.type = "technology"
tc3T.icon = "__Mobile_Factory__/graphics/icones/tileCapsule3.png"
tc3T.icon_size = 32
tc3T.unit = {
	count=2500,
	time=2,
	ingredients={
		{"DimensionalSample", 1}
	}
}
tc3T.prerequisites = {"AtomReconst2"}
tc3T.effects = {{type="unlock-recipe", recipe="TileCapsule3"}}
data:extend{tc3T}






