-- MATTER PRINTER OBJECT --

-- Create the Matter Printer base object --
MP = {
	ent = nil,
	animID = 0,
	active = false,
	linkedDC = nil,
	updateTick = 60,
	lastUpdate = 0
}

-- Constructor --
function MP:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = MP
	t.ent = object
	return t
end

-- Reconstructor --
function MP:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = MP
	setmetatable(object, mt)
end

-- Destructor --
function MP:remove()
	-- Destroy the Animation --
	rendering.destroy(self.animID)
end

-- Is valid --
function MP:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function MP:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
end

-- Tooltip Infos --
function MP:getTooltipInfos(GUI)
end

-- Set Active --
function MP:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation --
		self.animID = rendering.draw_animation{animation="MatterPrinterA", target={self.ent.position.x,self.ent.position.y-0.45}, surface=self.ent.surface}
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
	end
end