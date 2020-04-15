-- Create the MFPlayer Object --
MFP = {
    ent = nil,
	index = nil,
    name = nil,
    MF = nil,
    varTable = nil
}

-- Constructor --
function MFP:new(player)
    if player == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
    mt.__index = MF
    t.ent = player
	t.index = player.index
    t.name = player.name
    t.varTable = {}
	return t
end

-- Reconstructor --
function MFP:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = MF
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