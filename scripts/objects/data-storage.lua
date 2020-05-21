-- DATA STORAGE OBJECT --

-- Create the Data Storage base object --
DS = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	animID = 0,
	updateTick = 150,
	lastUpdate = 0,
	dataNetwork = nil
}

-- Constructor --
function DS:new(ent)
	if ent == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DS
	t.ent = ent
	if ent.last_user == nil then return end
	t.player = ent.last_user.name
	t.MF = getMF(t.player)
	t.dataNetwork = t.MF.dataNetwork
	t.dataNetwork.dataStorageTable[ent.unit_number] = t
	t.entID = ent.unit_number
	UpSys.addObj(t)
	t.animID = rendering.draw_animation{animation="DataStorageA", target={ent.position.x,ent.position.y-1.2}, surface=ent.surface, render_layer=131}
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
	self.dataNetwork.dataStorageTable[self.ent.unit_number] = nil
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

	-- Check the Animation --
	if rendering.is_valid(self.animID) == false then
		self.animID = rendering.draw_animation{animation="DataStorageA", target={self.ent.position.x,self.ent.position.y-1.2}, surface=self.ent.surface, render_layer=131}
	end
	
end

-- Tooltip Infos --
function DS:getTooltipInfos(GUIObj, gui)
	-- -- Create the Data Network Frame --
	-- GUIObj:addDataNetworkFrame(gui, self)
end