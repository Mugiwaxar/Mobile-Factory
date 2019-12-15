----------------------- DATA CENTER --------------------

-- Entity --
dcE = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
dcE.type = "constant-combinator"
dcE.name = "DataCenter"
dcE.icon = "__Mobile_Factory__/graphics/matter-serialization/DataCenterI.png"
dcE.icon_size = 32
dcE.minable = {mining_time = 0.5, result = "DataCenter"}
dcE.max_health = 200
dcE.corpse = "big-remnants"
dcE.dying_explosion = "medium-explosion"
dcE.collision_box = {{-2.35, -2.2}, {2.35, 2.2}}
dcE.selection_box = dcE.collision_box
dcE.item_slot_count = 0
dcE.circuit_wire_max_distance = 20
dcE.sprites.sheets =
	{	{
			filename = "__Mobile_Factory__/graphics/matter-serialization/DataCenterE.png",
			width = 600,
			height = 600,
			scale = 1/4,
			frames = 4
		},
		{
			filename = "__Mobile_Factory__/graphics/matter-serialization/DataCenterS.png",
			draw_as_shadow = true,
			width = 400,
			height = 400,
			scale = 1/3,
			shift = {2,0.8},
			frames = 1
		}
	}
dcE.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
dcE.circuit_wire_connection_points =
{
	{
		wire = {red={-0.2,0.2}, green={0.1,0.2}},
		shadow = {red={-0.2,0.3}, green={0.1,0.3}}
	},
	{
		wire = {red={-2.1,-0.9}, green={-2.1,-0.8}},
		shadow = {red={-2.1,-0.8}, green={-2.1,-0.7}}
	},
		{
		wire = {red={0.1,-1.9}, green={-0.2,-1.9}},
		shadow = {red={0.1,-1.8}, green={-0.2,-1.8}}
	},
	{
		wire = {red={2.1,-0.8}, green={2.1,-0.9}},
		shadow = {red={2.1,-0.7}, green={2.1,-0.8}}
	}
}
data:extend{dcE}

-- Entity MF --
dcEMF = table.deepcopy(data.raw["constant-combinator"].DataCenter)
dcEMF.name = "DataCenterMF"
dcEMF.icon = "__Mobile_Factory__/graphics/matter-serialization/DataCenterMFI.png"
dcEMF.minable = {mining_time = 0.5, result = "DataCenterMF"}
dcEMF.sprites.sheets =
	{	{
			filename = "__Mobile_Factory__/graphics/matter-serialization/DataCenterMFE.png",
			width = 600,
			height = 600,
			scale = 1/4,
			shift = {0,-0.1},
			frames = 4
		},
		{
			filename = "__Mobile_Factory__/graphics/matter-serialization/DataCenterS.png",
			draw_as_shadow = true,
			width = 400,
			height = 400,
			scale = 1/3,
			shift = {2,0.8},
			frames = 1
		}
	}
data:extend{dcEMF}

-- Item --
local dcI = {}
dcI.type = "item"
dcI.name = "DataCenter"
dcI.icon = "__Mobile_Factory__/graphics/matter-serialization/DataCenterI.png"
dcI.icon_size = 64
dcI.place_result = "DataCenter"
dcI.subgroup = "DataSerialization"
dcI.order = "a2"
dcI.stack_size = 10
data:extend{dcI}

-- Item MF --
dcIMF = table.deepcopy(data.raw.item.DataCenter)
dcIMF.name = "DataCenterMF"
dcIMF.icon = "__Mobile_Factory__/graphics/matter-serialization/DataCenterMFI.png"
dcIMF.place_result = "DataCenterMF"
dcIMF.order = "a"
data:extend{dcIMF}

-- Recipe --
dcR = {}
dcR.type = "recipe"
dcR.name = "DataCenter"
dcR.energy_required = 30
dcR.enabled = false
dcR.ingredients =
    {
      {"DimensionalPlate", 20},
      {"DimensionalCrystal", 10},
      {"electronic-circuit", 10}
    }
dcR.result = "DataCenter"
data:extend{dcR}

-- Recipe MF --
dcRMF = table.deepcopy(data.raw.recipe.DataCenter)
dcRMF.name = "DataCenterMF"
dcRMF.result = "DataCenterMF"
data:extend{dcRMF}

-- Animation --
dcA = {}
dcA.name = "DataCenterA"
dcA.type = "animation"
dcA.frame_count = 120
dcA.filename = "__Mobile_Factory__/graphics/matter-serialization/DataCenterAn.png"
dcA.size = 400
dcA.line_length = 10
dcA.animation_speed = 1/4
dcA.scale = 1/4
dcA.flags = {"terrain"}
data:extend{dcA}