-- WIRELESS DATA TRANSMITTER --

-- Create the Wireless Data Transmitter object --
WDT = {
	ent = nil,
	player = "",
	MF = nil,
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
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
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

	-- Check if the Data Center is inside the same Circuit Network --
	if valid(self.dataNetwork) == true then
		if Util.greenCNID(self) ~= Util.greenCNID(self.dataNetwork.dataCenter) and Util.redCNID(self) ~= Util.redCNID(self.dataNetwork.dataCenter) then
			self.dataNetwork = nil
		end
	end

	-- Check if there are any other Wireless Transmitter --
	if valid(self.dataNetwork) == true and valid(self.dataNetwork.wirelessDataTransmitter) == true and self.dataNetwork.wirelessDataTransmitter ~= self and Util.getConnectedDN( self.dataNetwork.wirelessDataTransmitter) ~= nil then
		self.dataNetwork = nil
		self.inConflict = true
	else
		self.inConflict = false
	end

	-- Register the Transmitter --
	if valid(self.dataNetwork) == true then
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
					self.lastSignal[item.signal.name] = Util.copyTable(item)
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
					self.lastSignal[item.signal.name] = Util.copyTable(item)
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
function WDT:getTooltipInfos(GUIObj, gui)

	-- Create the Data Network Frame --
	local DNFrame = GUIObj:addDataNetworkFrame(gui, self)

	-- Check the Connected state --
	if DNFrame == false then return end

	-- Create the Connected Receivers Label --
	local connectedLabel = GUIObj:addLabel("", DNFrame, {"", {"gui-description.ConnectedReceiver"}}, _mfOrange)
	connectedLabel.visible = false

	-- List all Receivers --
	for k, wdr in pairs(global.wirelessDataReceiverTable) do
		if wdr.linkedTransmitter == self then
			connectedLabel.visible = true
			GUIObj:addSimpleButton("WDTCam," .. wdr.ent.unit_number, DNFrame, wdr.entID, {"gui-description.ShowWDR"})
		end
	end


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
	if valid(self) == false then return end
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