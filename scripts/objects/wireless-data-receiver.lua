-- WIRELESS DATA RECEIVER --

-- Create the Wireless Data Receiver object --
WDR = {
	ent = nil,
	player = "",
	MF = nil,
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
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
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

-- Copy Settings --
function WDR:copySettings(obj)
	self.linkedTransmitter = obj.linkedTransmitter
end

-- Update --
function WDR:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick

	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end

	-- Check the Transmitter --
	if getmetatable(self.linkedTransmitter) == nil then
		self.linkedTransmitter = nil
	end
	if valid(self.linkedTransmitter) == true and valid(self.linkedTransmitter.dataNetwork) == true and self.linkedTransmitter.dataNetwork:isLive() == true then
		self.dataNetwork = self.linkedTransmitter.dataNetwork
	elseif valid(self.dataNetwork) then
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
	if valid(self.dataNetwork) then
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
function WDR:getTooltipInfos(GUIObj, gui, justCreated)

	-- Create the Data Network Frame --
	local DNFrame = GUIObj:addDataNetworkFrame(gui, self)

	-- Create the Connected Label --
	if self.linkedTransmitter ~= nil and DNFrame ~= false and valid(self.linkedTransmitter) == true  then
		GUIObj:addLabel("", DNFrame, {"", {"gui-description.ConnectedTransmitter"}}, _mfGreen)
	end
	
	-- Check if the Parameters can be modified --
	if canModify(getPlayer(gui.player_index).name, self.ent) == false or justCreated ~= true then return end

	-- Create the Parameters Title --
	local titleFrame = GUIObj:addTitledFrame("", GUIObj.SettingsFrame, "vertical", {"gui-description.Settings"}, _mfOrange)
	GUIObj.SettingsFrame.visible = true

	-- Create the Transmitter Selection --
	local transmitters = {{"gui-description.None"}}
	local selectedIndex = 1
	local i = 1
	for k, transmitter in pairs(global.wirelessDataTransmitterTable) do
		if transmitter ~= nil and transmitter.ent ~= nil and Util.canUse(self.player, transmitter.ent) then
			i = i + 1
			transmitters[transmitter.ent.unit_number] = tostring(transmitter.ent.unit_number)
			if self.linkedTransmitter == transmitter then
				selectedIndex = i
			end
		end
	end
	if selectedIndex ~= nil and selectedIndex > table_size(transmitters) then selectedIndex = nil end
	GUIObj:addDropDown("WDR" .. self.ent.unit_number, titleFrame, transmitters, selectedIndex)
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
		if valid(transmitter) == true then
			if ID == transmitter.ent.unit_number then
				self.linkedTransmitter = transmitter
			end
		end
	end
end

-- Get Signals --
function WDR:getSignals(t)
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