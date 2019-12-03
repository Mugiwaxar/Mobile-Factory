-- DATA STORAGE OBJECT --

-- Create the Data Storage base object --
DS = {
	ent = nil,
	animID = 0
}

-- Constructor --
function DS:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DS
	t.ent = object
	-- Create the Animation --
	t.animID = rendering.draw_animation{animation="DataStorageA", target={object.position.x,object.position.y-1.2}, surface=object.surface}
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