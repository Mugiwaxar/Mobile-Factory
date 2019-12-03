-- DATA CENTER OBJECT --

-- Create the Data Center base object --
DC = {
	ent = nil,
	invObj = nil,
	animID = 0
}

-- Contructor --
function DC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DC
	t.ent = object
	t.invObj = II:new("Inventory " .. tostring(object.unit_number))
	-- Create the Animation --
	t.animID = rendering.draw_animation{animation="DataCenterA", target={object.position.x,object.position.y-1.35}, surface=object.surface}
	return t
end

-- Reconstructor --
function DC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = DC
	setmetatable(object, mt)
	-- Recreate the Inventory Metatable --
	II:rebuild(object.invObj)
end

-- Destructor --
function DC:remove()
	-- Destroy the Inventory --
	self.invObj = nil
	-- Destroy the Animation --
	rendering.destroy(self.animID)
end

















