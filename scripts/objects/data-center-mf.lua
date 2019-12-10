-- DATA CENTER MF OBJECT --

-- Create the Data Center MF base object --
DCMF = {
	ent = nil,
	invObj = nil,
	animID = 0,
	active = false,
	dataStorages = nil,
	updateTick = 60,
	lastUpdate = 0
}

-- Contructor --
function DCMF:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DC
	t.ent = object
	t.invObj = global.MF.II
	t:setActive(true)
	t.dataStorages = {}
	return t
end

-- Reconstructor --
function DCMF:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = DCMF
	setmetatable(object, mt)
end

-- Destructor --
function DCMF:remove()
	-- Destroy the Inventory --
	self.invObj = nil
	-- Destroy the Animation --
	rendering.destroy(self.animID)
end

-- Is valid --
function DCMF:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function DCMF:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
end

-- Tooltip Infos --
function DCMF:getTooltipInfos(GUI)
end

-- Set Active --
function DCMF:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation --
		self.animID = rendering.draw_animation{animation="DataCenterA", target={self.ent.position.x,self.ent.position.y-1.35}, surface=self.ent.surface}
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
	end
end














