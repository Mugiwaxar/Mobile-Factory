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
	RCNID = 0
}

-- Constructor --
function WDR:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = WDR
	t.ent = object
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
	
	-- Check if the Wireless Data Storage is linked with a live Data Network --
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
end

-- Tooltip Info --
function WDR:getTooltipInfos(GUI)
	-- Create the Data Network label --
	local DNText = {"", {"gui-description.DataNetwork"}, ": Unknow"}
	if self.dataNetwork ~= nil then
		if self.dataNetwork:isLive() == true then
			DNText = {"", {"gui-description.DataNetwork"}, ": ", self.dataNetwork.ID}
		else
			DNText = {"", {"gui-description.DataNetwork"}, ": Invalid"}
		end
	end
	local dataNetworkL = GUI.add{type="label"}
	dataNetworkL.style.font = "LabelFont"
	dataNetworkL.caption = DNText
	dataNetworkL.style.font_color = {155, 0, 168}
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




















