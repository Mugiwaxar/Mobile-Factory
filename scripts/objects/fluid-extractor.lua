-- FLUID EXTRACTEUR OBJECT --

FE = {
	ent = nil,
	purity = 0,
	charge = 0,
	totalCharge = 0,
	updateTick = 0,
	lastUpdate = 0
}

-- Constructor --
function FE:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = FE
	t.ent = object
	return t
end

-- Reconstructor --
function FE:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = FE
	setmetatable(object, mt)
end

-- Destructor --
function FE:remove()
end

-- Is valid --
function FE:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function FE:update(event)
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
end

-- Tooltip Infos --
function FE:getTooltipInfos(GUI)

end










