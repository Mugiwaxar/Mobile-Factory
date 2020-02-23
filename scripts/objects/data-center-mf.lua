-- DATA CENTER MF OBJECT --

-- Create the Data Center MF base object --
DCMF = {
	ent = nil,
	player = "",
	MF = nil,
	invObj = nil,
	animID = 0,
	active = false,
	consumption = _mfDCEnergyDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil
}

-- Constructor --
function DCMF:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DCMF
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.invObj = t.MF.II
	t.dataNetwork = DN:new(t)
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function DCMF:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = DCMF
	setmetatable(object, mt)
	-- Recreate the DataNetwork Metatable --
	DN:rebuild(object.dataNetwork)
end

-- Destructor --
function DCMF:remove()
	-- Destroy the Data Network --
	self.dataNetwork = nil
	-- Destroy the Animation --
	rendering.destroy(self.animID)
	-- Remove from the Update System --
	UpSys.removeObj(self)
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
	
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end

	-- Get Data Center Circuit Network IDs --
	local greenID = Util.greenCNID(self)
	local redID = Util.redCNID(self)

	-- Check if another Data Center is not Already inside this Data Netwowk --
	if global.dataNetworkIDGreenTable[greenID] ~= nil and global.dataNetworkIDGreenTable[greenID] ~= self then
		self.inConflict = true
		return
	else
		self.inConflict = false
	end
	if global.dataNetworkIDRedTable[redID] ~= nil and global.dataNetworkIDRedTable[redID] ~= self then
		self.inConflict = true
		return
	else
		self.inConflict = false
	end

	-- Add the Data Center to the ID Table --
	if greenID ~= nil then global.dataNetworkIDGreenTable[greenID] = self end
	if redID ~= nil then global.dataNetworkIDRedTable[redID] = self end

	-- Check if the Data Network is live --
	if self.dataNetwork:isLive() == true then
		self:setActive(true)
	else
		self:setActive(false)
		return
	end

	-- Create the Inventory Signal --
	self.ent.get_control_behavior().parameters = nil
	local i = 1
	for name, count in pairs(self.invObj.inventory) do
		-- Create and send the Signal --
		if game.item_prototypes[name] ~= nil then
			local signal = {signal={type="item", name=name},count=count}
			self.ent.get_control_behavior().set_signal(i, signal)
			-- Increament the Slot --
			i = i + 1
			-- Stop if there are to much Items --
			if i > 999 then break end
		end
	end
	
	-- Create the Deep Storages Signals --
	for k, ds in pairs(global.deepStorageTable) do
		-- Create and send the Signal --
		if Util.canUse(self.player, ds.ent) then
			if ds.inventoryItem ~= nil and game.item_prototypes[ds.inventoryItem] ~= nil then
				local signal = {signal={type="item", name=ds.inventoryItem} ,count=ds.inventoryCount}
				self.ent.get_control_behavior().set_signal(i, signal)
				-- Increament the Slot --
				i = i + 1
				-- Stop if there are to much Items --
				if i > 999 then break end
			end
		end
	end
	
end
-- Tooltip Infos --
function DCMF:getTooltipInfos(GUI)

	-- Create the Belongs to Label --
	local belongsToL = GUI.add{type="label", caption={"", {"gui-description.BelongsTo"}, ": ", self.player}}
	belongsToL.style.font = "LabelFont"
	belongsToL.style.font_color = _mfOrange
	
	-- Create the Data Network label --
	local DNText = {"", {"gui-description.DataNetwork"}, ": ", {"gui-description.Unknow"}}
	if self.dataNetwork ~= nil then
		DNText = {"", {"gui-description.DataNetwork"}, ": ", self.dataNetwork.ID}
	end
	local dataNetworkL = GUI.add{type="label"}
	dataNetworkL.style.font = "LabelFont"
	dataNetworkL.caption = DNText
	dataNetworkL.style.font_color = {155, 0, 168}
	
	-- Create the Out Of Power Label --
	if self.dataNetwork ~= nil then
		if self.dataNetwork.outOfPower == true then
			local dataNetworOOPower = GUI.add{type="label"}
			dataNetworOOPower.style.font = "LabelFont"
			dataNetworOOPower.caption = {"", {"gui-description.OutOfPower"}}
			dataNetworOOPower.style.font_color = {231, 5, 5}
		end
	end

	-- Create the in conflict Label --
	if self.inConflict == true then
		local dataNetworConflict = GUI.add{type="label"}
		dataNetworConflict.style.font = "LabelFont"
		dataNetworConflict.caption = {"", {"gui-description.DataCenterConflict"}}
		dataNetworConflict.style.font_color = {231, 5, 5}
	end

	-- Create the Total Energy label --
	local totalEnergy = GUI.add{type="label"}
	totalEnergy.style.font = "LabelFont"
	totalEnergy.caption = {"", {"gui-description.CNTotalEnergy"}, ": ", math.floor(self.dataNetwork:availablePower()/10000) / 100, " MJ"}
	totalEnergy.style.font_color = {92, 232, 54}
	
	-- Create the Consumption label --
	local consumption = GUI.add{type="label"}
	consumption.style.font = "LabelFont"
	consumption.caption = {"", {"gui-description.CNConsumption"}, ": ", self.dataNetwork:powerConsumption()/1000, " kW"}
	consumption.style.font_color = {231, 5, 5}
	
	-- Return Inventory Frame --
	self.invObj:getFrame(GUI)
end

-- Set Active --
function DCMF:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation if it doesn't exist --
		if self.animID == 0 or rendering.is_valid(self.animID) == false then
			self.animID = rendering.draw_animation{animation="DataCenterA", target={self.ent.position.x,self.ent.position.y-1.22}, surface=self.ent.surface, render_layer=131}
		end
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
	end
end