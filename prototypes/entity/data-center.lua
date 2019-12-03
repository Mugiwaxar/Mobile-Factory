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
			filename = "__Mobile_Factory__/graphics/matter-serialization/DataCenterShadow.png",
			draw_as_shadow = true,
			width = 80,
			height = 80,
			scale = 2,
			shift = {1.8,0.4},
			frames = 1
		}
	}
dcE.vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
data:extend{dcE}

-- Item --
local dcI = {}
dcI.type = "item"
dcI.name = "DataCenter"
dcI.icon = "__Mobile_Factory__/graphics/matter-serialization/DataCenterI.png"
dcI.icon_size = 64
dcI.place_result = "DataCenter"
dcI.subgroup = "Pad"
dcI.order = "a"
dcI.stack_size = 10
data:extend{dcI}

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