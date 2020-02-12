-- WIRELESS DATA TRANSMITTER --

-- Create the Wireless Data Transmitter object --
WDT = {
	ent = nil,
	entID = 0,
	animID = 0,
	active = false,
	consumption = _mfWDTEnergyDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
	inConflict = false,
	lastSignal = nil
}

-- Constructor --
function WDT:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = WDT
	t.ent = object
	t.entID = object.unit_number
	t.localCN = {}
	t.lastSignal = {}
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function WDT:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = WDT
	setmetatable(object, mt)
end

-- Destructor --
function WDT:remove()
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
function WDT:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function WDT:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if self:valid() == false then
		self:remove()
		return
	end

	-- Try to find a connected Data Network --
	local obj = Util.getConnectedDN(self)
	if obj ~= nil then
		self.dataNetwork = obj.dataNetwork
		self.dataNetwork:addObject(self)
	else
		if self.dataNetwork ~= nil then
			self.dataNetwork:removeObject(self)
		end
		self.dataNetwork = nil
	end

	-- Check if the Data Center is inside the same Circuit Network --
	if self.dataNetwork ~= nil and self.dataNetwork:valid() == true then
		if Util.greenCNID(self) ~= Util.greenCNID(self.dataNetwork.dataCenter) and Util.redCNID(self) ~= Util.redCNID(self.dataNetwork.dataCenter) then
			self.dataNetwork = nil
		end
	end

	-- Check if there are any other Wireless Transmitter --
	if self.dataNetwork ~= nil and self.dataNetwork.wirelessDataTransmitter ~= nil and self.dataNetwork.wirelessDataTransmitter:valid() == true and self.dataNetwork.wirelessDataTransmitter ~= self and Util.getConnectedDN( self.dataNetwork.wirelessDataTransmitter) ~= nil then
		self.dataNetwork = nil
		self.inConflict = true
	else
		self.inConflict = false
	end

	-- Register the Transmitter --
	if self.dataNetwork ~= nil and self.dataNetwork:valid() == true then
		self.dataNetwork.wirelessDataTransmitter = self
	end

	-- Set Active or Not --
	if self.dataNetwork ~= nil and self.dataNetwork:isLive() == true then
		self:setActive(true)
	else
		self:setActive(false)
		return
	end

	-- Send Signals --
	self.ent.get_control_behavior().parameters = nil
	local i = 1
	for k, item in pairs(self.dataNetwork.signalsTable) do
		if item.obj ~= self and item.signal ~= nil then
			if item.signal.type == "virtual" then
				self.ent.get_control_behavior().set_signal(i, {signal={type=item.signal.type, name=item.signal.name}, count=item.count})
				if self.lastSignal[item.signal.name] ~= nil then
					self.lastSignal[item.signal.name].count = self.lastSignal[item.signal.name].count + item.count
				else
					self.lastSignal[item.signal.name] = item
				end
				-- Increament the Slot --
				i = i + 1
				-- Stop if there are to much Items --
				if i > 999 then break end
			elseif item.signal.name ~= nil and game.item_prototypes[item.signal.name] ~= nil then
				self.ent.get_control_behavior().set_signal(i, {signal={type=item.signal.type, name=item.signal.name}, count=item.count})
				if self.lastSignal[item.signal.name] ~= nil then
					self.lastSignal[item.signal.name].count = self.lastSignal[item.signal.name].count + item.count
				else
					self.lastSignal[item.signal.name] = item
				end
				-- Increament the Slot --
				i = i + 1
				-- Stop if there are to much Items --
				if i > 999 then break end
			end
		end
	end

end

-- Tooltip Info --
function WDT:getTooltipInfos(GUI)
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
		dataNetworConflict.caption = {"", {"gui-description.WirelessTransmitterConflict"}}
		dataNetworConflict.style.font_color = {231, 5, 5}
	end
	
	-- Create the ID label --
	local IDL = GUI.add{type="label"}
	IDL.style.font = "LabelFont"
	IDL.caption = {"", {"gui-description.TransmitterID"}, ": ", tostring(self.ent.unit_number)}
	IDL.style.font_color = {92, 232, 54}
end

-- Set Active --
function WDT:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation if it doesn't exist --
		if self.animID == 0 or rendering.is_valid(self.animID) == false then
			self.animID = rendering.draw_animation{animation="WirelessDataTransmitterA", target={self.ent.position.x,self.ent.position.y-0.9}, surface=self.ent.surface, render_layer=131}
		end
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
	end
end

-- Get Signals --
function WDT:getSignals(t)
	if self:valid() == false then return end
	-- Get GREEN Signals from this Network --
	if self.ent.get_circuit_network(defines.wire_type.green) ~= nil then
		local Gsignals = self.ent.get_circuit_network(defines.wire_type.green).signals
		for k, signal in pairs(Gsignals or {}) do
			signal.obj = self
			if self.lastSignal[signal.signal.name] ~= nil then
				signal.count = signal.count - self.lastSignal[signal.signal.name].count
			end
			if signal.count > 0 then table.insert(t, signal) end
		end
	end
	-- Get RED Signals from this Network --
	if self.ent.get_circuit_network(defines.wire_type.red) ~= nil then
		local Rsignals = self.ent.get_circuit_network(defines.wire_type.red).signals
		for k, signal in pairs(Rsignals or {}) do
			signal.obj = self
			if self.lastSignal[signal.signal.name] ~= nil then
				signal.count = signal.count - self.lastSignal[signal.signal.name].count
			end
			if signal.count > 0 then table.insert(t, signal) end
		end
	end
end