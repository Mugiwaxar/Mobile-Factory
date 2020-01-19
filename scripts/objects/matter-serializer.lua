-- MATTER SERIALIZER OBJECT --

-- Create the Matter Serializer base object --
MS = {
	ent = nil,
	animID = 0,
	active = false,
	consumption = _mfMSEnergyDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
	GCNID = 0,
	RCNID = 0,
	selectedInv = 0
}

-- Constructor --
function MS:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = MS
	t.ent = object
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function MS:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = MS
	setmetatable(object, mt)
end

-- Destructor --
function MS:remove()
	-- Destroy the Animation --
	rendering.destroy(self.animID)
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function MS:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function MS:update()
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

function MS:updateInv()
	-- Get the Local Inventory --
	local inv = self.ent.get_inventory(defines.inventory.chest)
	
	-- Itinerate the Inventory --
	for item, count in pairs(inv.get_contents()) do
		-- Check the targeted Inventory --
		local dataInv = self.selectedInv
		if self.selectedInv == 0 then
			dataInv = self.dataNetwork.dataCenter.invObj
		end
		-- Check the Data Inventory --
		if dataInv == nil or getmetatable(dataInv) == nil then return end
		-- Add Items to the Data Inventory --
		local amountAdded = dataInv:addItem(item, count)
		-- Remove Items from the local Inventory --
		if amountAdded > 0 then
			inv.remove({name=item, count=amountAdded})
		end
	end
	
end

-- Tooltip Infos --
function MS:getTooltipInfos(GUI)
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
	
	-- Create the text and style variables --
	local text = ""
	local style = {}
	-- Check if the Data Storage is linked with a Data Center --
	if self.dataNetwork ~= nil and getmetatable(self.dataNetwork) ~= nil and self.dataNetwork.dataCenter ~= nil and self.dataNetwork.dataCenter:valid() == true then
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
	

	
	-- Create the Inventory Selection --
	if self.dataNetwork ~= nil and self.dataNetwork.dataCenter ~= nil and self.dataNetwork.dataCenter:valid() == true and self.dataNetwork.dataCenter.invObj.isII == true then
		-- Create the targeted Inventory label --
		local targetLabel = GUI.add{type="label", caption={"", {"gui-description.MSTarget"}, ":"}}
		targetLabel.style.top_margin = 7
		targetLabel.style.font = "LabelFont"
		targetLabel.style.font_color = {108, 114, 229}
	
		local invs = {self.dataNetwork.dataCenter.invObj.name or {"gui-description.Any"}}
		local selectedIndex = 1
		local i = 1
		for k, deepStorage in pairs(global.deepStorageTable) do
			if deepStorage ~= nil then
				i = i + 1
				invs[k+1] = {"", {"gui-description.DS"}, " ", tostring(deepStorage.ID)}
				if self.selectedInv == deepStorage then
					selectedIndex = i
				end
			end
		end
		if selectedIndex ~= nil and selectedIndex > table_size(invs) then selectedIndex = nil end
		local invSelection = GUI.add{type="list-box", name="MS" .. self.ent.unit_number, items=invs, selected_index=selectedIndex}
		invSelection.style.width = 70
	end
end

-- Change the Targeted Inventory --
function MS:changeInventory(ID)
	-- Check the ID --
	if ID == nil then self.selectedInv = nil end
	-- Select the Inventory --
	self.selectedInv = nil
	for k, deepStorage in pairs(global.deepStorageTable) do
		if deepStorage ~= nil and deepStorage:valid() == true then
			if ID == deepStorage.ID then
				self.selectedInv = deepStorage
			end
		end
	end
end

-- Set Active --
function MS:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation if it doesn't exist --
		if self.animID == 0 then
			self.animID = rendering.draw_animation{animation="MatterSerializerA", target={self.ent.position.x,self.ent.position.y-0.35}, surface=self.ent.surface}
		end
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
	end
end























