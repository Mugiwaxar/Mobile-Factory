-- DATA STORAGE OBJECT --

-- Create the Data Storage base object --
DS = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	animID = 0,
	active = false,
	consumption = _mfDSEnergyDrainPerUpdate,
	updateTick = 80,
	lastUpdate = 0,
	dataNetwork = nil
}

-- Constructor --
function DS:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DS
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	UpSys.addObj(t)
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
	-- Remove from the Update System --
	UpSys.removeObj(self)
	-- Remove from the Data Network --
	if self.dataNetwork ~= nil and getmetatable(self.dataNetwork) ~= nil then
		self.dataNetwork:removeObject(self)
	end
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
	
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end

	-- Try to find a connected Data Network --
	local obj = Util.getConnectedDN(self)
	if obj ~= nil and valid(obj.dataNetwork) then
		self.dataNetwork = obj.dataNetwork
		self.dataNetwork:addObject(self)
	else
		if valid(self.dataNetwork) then
			self.dataNetwork:removeObject(self)
		end
		self.dataNetwork = nil
	end

	-- Set Active or Not --
	if self.dataNetwork ~= nil and self.dataNetwork:isLive() == true then
		self:setActive(true)
	else
		self:setActive(false)
	end
	
end

-- Tooltip Infos --
function DS:getTooltipInfos(GUIObj, gui)
	-- Create the Data Network Frame --
	GUIObj:addDataNetworkFrame(gui, self)
end

-- Set Active --
function DS:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation if it doesn't exist --
		if self.animID == 0 or rendering.is_valid(self.animID) == false then
			self.animID = rendering.draw_animation{animation="DataStorageA", target={self.ent.position.x,self.ent.position.y-1.2}, surface=self.ent.surface, render_layer=131}
		end
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
	end
end