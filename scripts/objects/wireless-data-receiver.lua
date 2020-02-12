-- WIRELESS DATA RECEIVER --

-- Create the Wireless Data Receiver object --
WDR = {
	ent = nil,
	entID = 0,
	animID = 0,
	active = false,
	consumption = _mfWDREnergyDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
	inConflict = false,
	linkedTransmitter = nil,
	lastSignal = nil
}

-- Constructor --
function WDR:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = WDR
	t.ent = object
	t.entID = object.unit_number
	t.lastSignal = {}
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function WDR:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = WDR
	setmetatable(object, mt)
end

-- Destructor --
function WDR:remove()
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
function WDR:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function WDR:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick

	-- Check the Validity --
	if self:valid() == false then
		self:remove()
		return
	end

	-- Check the Transmitter --
	if getmetatable(self.linkedTransmitter) == nil then
		self.linkedTransmitter = nil
	end
	if self.linkedTransmitter ~= nil and self.linkedTransmitter:valid() == true and self.linkedTransmitter.dataNetwork ~= nil and self.linkedTransmitter.dataNetwork:isLive() == true then
		self.dataNetwork = self.linkedTransmitter.dataNetwork
	elseif self.dataNetwork ~= nil then
		-- Remove the Receiver --
		self.dataNetwork:removeObject(self)
		self.dataNetwork = nil
	end

	-- Get Circuit Network IDs --
	local greenID = Util.greenCNID(self)
	local redID = Util.redCNID(self)

	-- Check if there are any other Wireless Receiver --
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

	-- Check the Connected Data Network --
	if self.dataNetwork ~= nil then
		-- Register the Receiver --
		self.dataNetwork:addObject(self)
		-- Add the Wireless Receiver to the ID Table --
		if greenID ~= nil then global.dataNetworkIDGreenTable[greenID] = self end
		if redID ~= nil then global.dataNetworkIDRedTable[redID] = self end
		self:setActive(true)
	else
		-- Remove the Wireless Receiver from the ID Table --
		if greenID ~= nil then global.dataNetworkIDGreenTable[greenID] = nil end
		if redID ~= nil then global.dataNetworkIDRedTable[redID] = nil end
		self:setActive(false)
		return
	end

	-- Send Signals --
	self.lastSignal = {}
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
function WDR:getTooltipInfos(GUI)
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
		dataNetworConflict.caption = {"", {"gui-description.WirelessReceiverConflict"}}
		dataNetworConflict.style.font_color = {231, 5, 5}
	end

	-- Create the Connected label --
	local connectedText = {"", {"gui-description.NoLink"}}
	local connectedL = GUI.add{type="label"}
	if self.linkedTransmitter ~= nil then
		if self.linkedTransmitter ~= nil and self.linkedTransmitter:valid() == true then
			connectedText = {"", {"gui-description.Connected"}, " ", tostring(self.linkedTransmitter.ent.unit_number)}
			connectedL.style.font_color = {92, 232, 54}
		else
			connectedText = {"", {"gui-description.NoWDTFound"}}
			connectedL.style.font_color = {231, 5, 5}
		end
	end
	connectedL.style.font = "LabelFont"
	connectedL.caption = connectedText
	
	-- Create the Transmitter Selection --
	local transmitters = {{"gui-description.Any"}}
	local selectedIndex = 1
	local i = 1
	for k, transmitter in pairs(global.wirelessDataTransmitterTable) do
		if transmitter ~= nil then
			i = i + 1
			transmitters[transmitter.ent.unit_number] = tostring(transmitter.ent.unit_number)
			if self.linkedTransmitter == transmitter then
				selectedIndex = i
			end
		end
	end
	if selectedIndex ~= nil and selectedIndex > table_size(transmitters) then selectedIndex = nil end
	local networkSelection = GUI.add{type="list-box", name="WDR" .. self.ent.unit_number, items=transmitters, selected_index=selectedIndex}
	networkSelection.style.margin = 5
	networkSelection.style.width = 70
end

-- Set Active --
function WDR:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation if it doesn't exist --
		if self.animID == 0 or rendering.is_valid(self.animID) == false then
			self.animID = rendering.draw_animation{animation="WirelessDataReceiverA", target={self.ent.position.x,self.ent.position.y-2.18}, surface=self.ent.surface, render_layer=131}
		end
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
	end
end

-- Change the Data Transmitter --
function WDR:changeTransmitter(ID)
	-- Check the ID --
	if ID == nil then self.linkedTransmitter = nil end
	-- Select the Transmitter --
	self.linkedTransmitter = nil
	for k, transmitter in pairs(global.wirelessDataTransmitterTable) do
		if transmitter ~= nil and transmitter:valid() == true then
			if ID == transmitter.ent.unit_number then
				self.linkedTransmitter = transmitter
			end
		end
	end
end

-- Get Signals --
function WDR:getSignals(t)
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