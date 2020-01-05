-- DATA CENTER MF OBJECT --

-- Create the Data Center MF base object --
DCMF = {
	ent = nil,
	invObj = nil,
	animID = 0,
	active = false,
	consumption = _mfDCEnergyDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
	GCNID = 0,
	RCNID = 0
}

-- Contructor --
function DCMF:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DCMF
	t.ent = object
	t.invObj = global.MF.II
	t.dataNetwork = DN:new(t)
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
	
	-- Check the Entity --
	if self.ent == nil or self.ent.valid == false then return end
	
	-- Check if the Entity is inside a Green Circuit Network --
	if self.ent.get_circuit_network(defines.wire_type.green) ~= nil and self.ent.get_circuit_network(defines.wire_type.green).valid == true then
		self.GCNID = self.ent.get_circuit_network(defines.wire_type.green).network_id
	else
		self.GCNID = 0
	end
	
	-- Check if the Entity is inside a Red Circuit Network --
	if self.ent.get_circuit_network(defines.wire_type.red) ~= nil and self.ent.get_circuit_network(defines.wire_type.red).valid == true then
		self.RCNID = self.ent.get_circuit_network(defines.wire_type.red).network_id
	else
		self.RCNID = 0
	end
	
	-- Check if the Data Network is live --
	if self.dataNetwork:isLive() == true then
		self:setActive(true)
	else
		self:setActive(false)
	end
	
	-- Save the Data Storage count --
	self.invObj.dataStoragesCount = self.dataNetwork:dataStoragesCount()
	
	-- Add both Circuit Network to the Data Network --
	self.dataNetwork.GCNTable[self.GCNID] = self
	self.dataNetwork.RCNTable[self.RCNID] = self
	
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
	
end
-- Tooltip Infos --
function DCMF:getTooltipInfos(GUI)
	-- Create the Data Network label --
	local DNText = {"", {"gui-description.DataNetwork"}, ": ", {"gui-description.Unknow"}}
	if self.dataNetwork ~= nil then
		if self.dataNetwork:isLive() == true then
			DNText = {"", {"gui-description.DataNetwork"}, ": ", self.dataNetwork.ID}
		else
			DNText = {"", {"gui-description.DataNetwork"}, ": ", {"gui-description.Invalid"}}
		end
	end
	local dataNetworkL = GUI.add{type="label"}
	dataNetworkL.style.font = "LabelFont"
	dataNetworkL.caption = DNText
	dataNetworkL.style.font_color = {155, 0, 168}
	
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
		if self.animID == 0 then
			self.animID = rendering.draw_animation{animation="DataCenterA", target={self.ent.position.x,self.ent.position.y-1.22}, surface=self.ent.surface}
		end
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
	end
end















