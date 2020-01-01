-- MATTER PRINTER OBJECT --

-- Create the Matter Printer base object --
MP = {
	ent = nil,
	animID = 0,
	active = false,
	consumption = _mfMPEnergyDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
	GCNID = 0,
	RCNID = 0
}

-- Constructor --
function MP:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = MP
	t.ent = object
	return t
end

-- Reconstructor --
function MP:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = MP
	setmetatable(object, mt)
end

-- Destructor --
function MP:remove()
	-- Destroy the Animation --
	rendering.destroy(self.animID)
end

-- Is valid --
function MP:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function MP:update()
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
	
	-- Check if the Matter Serializer is linked with a live Data Network --
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
	
	-- Update the Inventory --
	if self.active == true then
		self:updateInv()
	end
end

function MP:updateInv()
	-- Get the Linked Inventory --
	local dataInv = self.dataNetwork.dataCenter.invObj
	
	-- Get the Local Inventory --
	local inv = self.ent.get_inventory(defines.inventory.chest)
	
	-- Get the Filter --
	local filter = self.ent.get_request_slot(1)
	
	-- Return if there are no filter --
	if filter == nil then return end
	
	-- Get Items count from the Data Inventory --
	local returnedItems = dataInv:hasItem(filter.name)
	
	-- Get the number of Items present inside the local Inventory --
	local currentItems = inv.get_contents()[filter.name]
	
	-- Calcule the number of Items that must be requested --	
	returnedItems = math.min(returnedItems, filter.count - (currentItems or 0))
	
	-- Stop if they are any Item --
	if returnedItems <= 0 then return end
	
	-- Insert requested Item inside the local Inventory --
	local addedItems = inv.insert({name=filter.name, count=returnedItems})
	
	-- Remove Item from the Data Inventory --
	dataInv:getItem(filter.name, addedItems)
	
end

-- Tooltip Infos --
function MP:getTooltipInfos(GUI)
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
	
	-- Create the text and style variables --
	local text = ""
	local style = {}
	-- Check if the Data Storage is linked with a Data Center --
	if self.dataNetwork ~= nil and getmetatable(self.dataNetwork) ~= nil and self.dataNetwork.dataCenter ~= nil then
		text = {"", {"gui-description.LinkedTo"}, ": ", self.dataNetwork.dataCenter.invObj.name}
		style = {92, 232, 54}
	else
		text = {"gui-description.Unlinked"}
		style = {231, 5, 5}
	end
	-- Create the Link label --
	local link = GUI.add{type="label"}
	link.style.font = "LabelFont"
	link.caption = text
	link.style.font_color = style
end

-- Set Active --
function MP:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation if it doesn't exist --
		if self.animID == 0 then
			self.animID = rendering.draw_animation{animation="MatterPrinterA", target={self.ent.position.x,self.ent.position.y-0.45}, surface=self.ent.surface}
		end
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
	end
end