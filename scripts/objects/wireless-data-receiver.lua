-- WIRELESS DATA RECEIVER --

-- Create the Wireless Data Receiver object --
WDR = {
	ent = nil,
	animID = 0,
	active = false,
	consumption = _mfWDREnergyDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
	GCNID = 0,
	RCNID = 0,
	linkedTransmitter = nil,
	localCN = nil,
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
	t.localCN = {}
	t.lastSignal = {}
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
	
	-- Check if the Entity is valid --
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
	
	-- Check the Transmitter --
	if self.linkedTransmitter ~= nil and self.linkedTransmitter:valid() == true and self.linkedTransmitter.dataNetwork ~= nil and self.linkedTransmitter.dataNetwork:isLive() == true then
		self.dataNetwork = self.linkedTransmitter.dataNetwork
	else
		self.dataNetwork = nil
	end
	
	-- Check the Connected Data Network --
	local active = false
	if self.dataNetwork ~= nil and self.dataNetwork:isLive() then
		active = true
	else
		active = false
	end
	self:setActive(active)
	
	if self.dataNetwork ~= nil then
		-- Add both Circuit Network to the Data Network --
		if self.active == true then
			self.dataNetwork.GCNTable[self.GCNID] = self
			self.dataNetwork.RCNTable[self.RCNID] = self
		-- Remove both Circuit Network to the Data Network --
		else
			self.dataNetwork.GCNTable[self.GCNID] = nil
			self.dataNetwork.RCNTable[self.RCNID] = nil
		end
	end
	
	-- Add Wireless Data Network Signals --
	self.ent.get_control_behavior().parameters = nil
	if self.dataNetwork ~= nil and self.active == true and self.linkedTransmitter ~= nil and self.linkedTransmitter.active then
		-- Create Signals --
		local obj = self.linkedTransmitter
		local localNetwork = {}
		local wirelessNetwork = {}
		if self.localCN == nil then self.localCN = {} end
		if self.lastSignal == nil then self.lastSignal = {} end
		
		-- Get GREEN Signals from this Network --
		if self.ent.get_circuit_network(defines.wire_type.green) ~= nil then
			local Gsignals = self.ent.get_circuit_network(defines.wire_type.green).signals
			for k, signal in pairs(Gsignals or {}) do
				localNetwork[signal.signal.name] = {type=signal.signal.type, count=signal.count}
			end
		end
		-- Get RED Signals from this Network --
		if self.ent.get_circuit_network(defines.wire_type.red) ~= nil then
			local Rsignals = self.ent.get_circuit_network(defines.wire_type.red).signals
			for k, signal in pairs(Rsignals or {}) do
				localNetwork[signal.signal.name] = {type=signal.signal.type, count=signal.count}
			end
		end
		
		if obj ~= nil and obj:valid() == true then
			-- Create GREEN Signals from this Wireless Network --
			if obj.ent.get_circuit_network(defines.wire_type.green) ~= nil then
				local Gsignals = obj.ent.get_circuit_network(defines.wire_type.green).signals
				for k, signal in pairs(Gsignals or {}) do
					wirelessNetwork[signal.signal.name] = {type=signal.signal.type, count=signal.count}
				end
			end
			-- Create RED Signals from this Wireless Network --
			if obj.ent.get_circuit_network(defines.wire_type.red) ~= nil then
				local Rsignals = obj.ent.get_circuit_network(defines.wire_type.red).signals
				for k, signal in pairs(Rsignals or {}) do
					wirelessNetwork[signal.signal.name] = {type=signal.signal.type, count=signal.count}
				end
			end
		end
		
		-- Calcul Local Signal --
		for k, signal in pairs(localNetwork) do
			if self.lastSignal[k] ~= nil then
				localNetwork[k].count = localNetwork[k].count - signal.count
				if localNetwork[k].count <= 0 then
					localNetwork[k] = nil
				end
			end
		end
		
		-- Remove Local from Wireless --
		for k, signal in pairs(wirelessNetwork) do
			if localNetwork[k] ~= nil then
				wirelessNetwork[k].count = wirelessNetwork[k].count - signal.count
				if wirelessNetwork[k].count <= 0 then
					wirelessNetwork[k] = nil
				end
			end
		end
		
		-- Save the Local Network and the Signal --
		self.localCN = localNetwork
		self.lastSignal = wirelessNetwork
		
		-- Send Signals --
		local i = 1
		for k, signal in pairs(wirelessNetwork) do
			self.ent.get_control_behavior().set_signal(i, {signal={type=signal.type, name=k}, count=signal.count})
			-- Increament the Slot --
			i = i + 1
			-- Stop if there are to much Items --
			if i > 999 then break end
		end
	end
	
end

-- Tooltip Info --
function WDR:getTooltipInfos(GUI)
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
	
	-- Create the Connected label --
	local connectedText = {"", {"gui-description.NoLink"}}
	if self.linkedTransmitter ~= nil then
		if self.linkedTransmitter ~= nil and self.linkedTransmitter:valid() == true then
			connectedText = {"", {"gui-description.Connected"}, " ", tostring(self.linkedTransmitter.ent.unit_number)}
		else
			connectedText = {"", {"gui-description.NoWDTFound"}}
		end
	end
	local connectedL = GUI.add{type="label"}
	connectedL.style.font = "LabelFont"
	connectedL.caption = connectedText
	connectedL.style.font_color = {92, 232, 54}
	
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
	networkSelection.style.width = 50
end

-- Set Active --
function WDR:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation if it doesn't exist --
		if self.animID == 0 then
			self.animID = rendering.draw_animation{animation="WirelessDataReceiverA", target={self.ent.position.x,self.ent.position.y-2.18}, surface=self.ent.surface}
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


















