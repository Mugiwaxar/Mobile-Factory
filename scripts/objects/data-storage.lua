-- DATA STORAGE OBJECT --

-- Create the Data Storage base object --
DS = {
	ent = nil,
	animID = 0,
	active = false,
	linkedDC = nil,
	updateTick = nil,
	lastUpdate = 0
}

-- Constructor --
function DS:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DS
	t.ent = object
	return t
end

-- Reconstructor --
function DS:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = DS
	setmetatable(object, mt)
end

-- Destructor --
function DS:remove()
	-- Destroy the Animation --
	rendering.destroy(self.animID)
end

-- Is valid --
function DS:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function DS:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
end

-- Set Active --
function DS:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation --
		self.animID = rendering.draw_animation{animation="DataStorageA", target={self.ent.position.x,self.ent.position.y-1.2}, surface=self.ent.surface}
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
	end
end














