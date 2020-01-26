-- WIRELESS DATA TRANSMITTER --

-- Create the Wireless Data Transmitter object --
WDT = {
	ent = nil,
	animID = 0,
	active = false,
	consumption = _mfWDTEnergyDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
	GCNID = 0,
	RCNID = 0,
	localCN = nil,
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
	
	-- Check if the Wireless Data Network is linked with a live Data Network --
	local active = false
	self.dataNetwork = nil
	for k, obj in pairs(global.dataNetworkTable) do
		if obj:isLinked(self) == true then
			self.dataNetwork = obj
			if obj:isLive() == true then
				active = true
			else
				active = false
			end
		end
	end
	
	self:setActive(active)
	if active == false then return end
	
	
	-- Add Wireless Data Network Signals --
	self.ent.get_control_behavior().parameters = nil
	if self.dataNetwork ~= nil and self.active == true then
		local wirelessNetwork = {}
		local localNetwork = {}
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
		
		for k, obj in pairs(self.dataNetwork.wirelessReceiverTable) do
			if obj ~= nil and obj:valid() == true then
				if obj.linkedTransmitter == self then
					if obj ~= nil and obj:valid() == true then
						for k, signal in pairs(obj.localCN) do
							wirelessNetwork[k] = signal
						end
					end
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
			if game.item_prototypes[k] ~= nil then
				self.ent.get_control_behavior().set_signal(i, {signal={type=signal.type, name=k}, count=signal.count})
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
		if self.animID == 0 then
			self.animID = rendering.draw_animation{animation="WirelessDataTransmitterA", target={self.ent.position.x,self.ent.position.y-0.9}, surface=self.ent.surface}
		end
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
	end
end

























