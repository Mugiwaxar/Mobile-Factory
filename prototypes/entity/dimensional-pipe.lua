---------------------------------------------------------- PIPE FUNCTIONS ------------------------------------------------------------
local function tintPipeCovers(pipe_covers, tint)
	--SHOULD NOT HAVE TO DO THIS - hr_version IS ONLY MISSING WHEN A MOD EDITS THE PIPE IN DATA REEEEEEEEEEEE
	--like Industrial Revolution 2 version 2.1.2
	if not pipe_covers then return end
	local directions = {
		"north",
		"east",
		"south",
		"west",
	}
	for _, direction in pairs(directions) do
		local directionLayer1 = pipe_covers[direction].layers[1]
		directionLayer1.tint = tint
		if directionLayer1.hr_version then directionLayer1.hr_version.tint = tint end
	end
end

local function tintPictures(pictures, tint)
	--SHOULD NOT HAVE TO DO THIS - hr_version IS ONLY MISSING WHEN A MOD EDITS THE PIPE IN DATA REEEEEEEEEEEE
	--like Industrial Revolution 2 version 2.1.2
	if not pictures then return end
	local directions = {
		"up",
		"right",
		"down",
		"left",
	}
	for _, direction in pairs(directions) do
		local pictureDirection = pictures[direction]
		if pictureDirection then
			local tableToTint = (pictureDirection.layers and pictureDirection.layers[1]) or pictures[direction]
			tableToTint.tint = tint
			if tableToTint.hr_version then pictureDirection.hr_version.tint = tint end
		end
	end
end

---------------------------------------------------------- DIMENSIONAL PIPE ----------------------------------------------------------

-- Tier 1 --
local tint1 = {1,1,0.4}
local dpE1 = table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"])
dpE1.name = "DimensionalPipe1"
dpE1.icons = {{icon=dpE1.icon, tint=tint1}}
dpE1.minable = {mining_time = 0.5}
dpE1.flags = {}
dpE1.fast_replaceable_group = nil
dpE1.fluid_box.pipe_connections[2].max_underground_distance = 1
tintPipeCovers(dpE1.fluid_box.pipe_covers, tint1)
tintPictures(dpE1.pictures, tint1)
data:extend{dpE1}

-- Tier 2 --
local tint2 = {1,0.4,0.4}
local dpE2 = table.deepcopy(dpE1)
dpE2.name = "DimensionalPipe2"
dpE2.icons = {{icon=dpE1.icon, tint=tint2}}
dpE2.fluid_box.base_area = 10
tintPipeCovers(dpE2.fluid_box.pipe_covers, tint2)
tintPictures(dpE2.pictures, tint2)
data:extend{dpE2}

local dpT2 = {}
dpT2.name = "DimensionalPipe2"
dpT2.type = "technology"
dpT2.icons = dpE2.icons
dpT2.icon_size = data.raw["pipe-to-ground"]["pipe-to-ground"].icon_size
dpT2.unit = {
	count=1200,
	time=3,
	ingredients={
		{"DimensionalSample", 1}
	}
}
dpT2.prerequisites = {"MFDeploy"}
dpT2.effects =
{
	{type="nothing", effect_description={"description.DimensionalPipe2"}},
}
data:extend{dpT2}

-- Tier 3 --
local tint3 = {0.4,0.6,1}
local dpE3 = table.deepcopy(dpE2)
dpE3.name = "DimensionalPipe3"
dpE3.icons = {{icon=dpE1.icon, tint=tint3}}
dpE3.fluid_box.base_area = 50
tintPipeCovers(dpE3.fluid_box.pipe_covers, tint3)
tintPictures(dpE3.pictures, tint3)
data:extend{dpE3}

local dpT3 = {}
dpT3.name = "DimensionalPipe3"
dpT3.type = "technology"
dpT3.icons = dpE3.icons
dpT3.icon_size = data.raw["pipe-to-ground"]["pipe-to-ground"].icon_size
dpT3.unit = {
	count=10,
	time=60,
	ingredients={
		{"DimensionalSample", 200},
        {"DimensionalCrystal", 1}
	}
}
dpT3.prerequisites = {"DimensionalPipe2"}
dpT3.effects =
{
	{type="nothing", effect_description={"description.DimensionalPipe3"}},
}
data:extend{dpT3}