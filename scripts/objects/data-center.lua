-- DATA CENTER OBJECT --

-- Create the Data Center base object --
DC = {
	ent = nil,
	invObj = nil,
	animID = 0,
	active = false,
	dataStorages = nil,
	updateTick = 60,
	lastUpdate = 0
}

-- Contructor --
function DC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DC
	t.ent = object
	t.invObj = INV:new("Inventory " .. tostring(object.unit_number))
	t:setActive(true)
	t.dataStorages = {}
	return t
end

-- Reconstructor --
function DC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = DC
	setmetatable(object, mt)
	-- Recreate the Inventory Metatable --
	INV:rebuild(object.invObj)
end

-- Destructor --
function DC:remove()
	-- Destroy the Inventory --
	self.invObj = nil
	-- Destroy the Animation --
	rendering.destroy(self.animID)
end

-- Is valid --
function DC:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function DC:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
end

-- Set Active --
function DC:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation --
		self.animID = rendering.draw_animation{animation="DataCenterA", target={self.ent.position.x,self.ent.position.y-1.35}, surface=self.ent.surface}
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
	end
end















