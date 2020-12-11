-- Create the MFPlayer Object --
MFP = {
	ent = nil,
	index = nil,
	name = nil,
	MF = nil,
	currentMF = nil,
	GUI = nil,
	varTable = nil
}

-- Constructor --
function MFP:new(player)
	if player == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = MFP
	t.ent = player
	t.index = player.index
	t.name = player.name
	t.GUI = {}
    t.varTable = {}
	return t
end

-- Reconstructor --
function MFP:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = MFP
	setmetatable(object, mt)
end

-- Destructor --
function MFP:remove()
end

-- Is valid --
function MFP:valid()
	return true
end

-- Tooltip Infos --
function MFP:getTooltipInfos(GUI)
end