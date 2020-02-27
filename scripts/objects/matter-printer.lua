-- MATTER PRINTER OBJECT --

-- Create the Matter Printer base object --
MP = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	animID = 0,
	active = false,
	consumption = _mfMPEnergyDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
	selectedInv = 0
}

-- Constructor --
function MP:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = MP
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	UpSys.addObj(t)
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
	-- Remove from the Update System --
	UpSys.removeObj(self)
	-- Remove from the Data Network --
	if self.dataNetwork ~= nil and getmetatable(self.dataNetwork) ~= nil then
		self.dataNetwork:removeObject(self)
	end
end

-- Is valid --
function MP:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Copy Settings --
function MP:copySettings(obj)
	if obj.selectedInv ~= nil then
		self.selectedInv = obj.selectedInv
	end
end

-- Update --
function MP:update()
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

	-- Set Active or Not --
	if self.dataNetwork ~= nil and self.dataNetwork:isLive() == true then
		self:setActive(true)
	else
		self:setActive(false)
	end
	
	-- Update the Inventory --
	if self.active == true then
		self:updateInv()
	end
end

function MP:updateInv()
	-- Get the Linked Inventory --
	local dataInv = self.selectedInv
	if self.selectedInv == 0 then
		dataInv = self.dataNetwork.dataCenter.invObj
	end
	
	-- Check the Data Inventory --
	if dataInv == nil or getmetatable(dataInv) == nil then return end
	
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
	returnedItems = math.floor(math.min(returnedItems, filter.count - (currentItems or 0)))

	-- Stop if they are any Item --
	if returnedItems <= 0 then return end

	-- Insert requested Item inside the local Inventory --
	local addedItems = inv.insert({name=filter.name, count=returnedItems})
	
	-- Remove Item from the Data Inventory --
	dataInv:getItem(filter.name, addedItems)
	
end

-- Tooltip Infos --
function MP:getTooltipInfos(GUI)

	-- Create the Belongs to Label --
	local belongsToL = GUI.add{type="label", caption={"", {"gui-description.BelongsTo"}, ": ", self.player}}
	belongsToL.style.font = "LabelFont"
	belongsToL.style.font_color = _mfOrange

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
	
	-- Create the text and style variables --
	local text = ""
	local style = {}
	-- Check if the Data Storage is linked with a Data Center --
	if valid(self.dataNetwork) == true and valid(self.dataNetwork.dataCenter) == true then
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
	
	if canModify(getPlayer(GUI.player_index).name, self.ent) == false then return end

	-- Create the Inventory Selection --
	if valid(self.dataNetwork) == true and valid(self.dataNetwork.dataCenter) == true and self.dataNetwork.dataCenter.invObj.isII == true then
		-- Create the targeted Inventory label --
		local targetLabel = GUI.add{type="label", caption={"", {"gui-description.MSTarget"}, ":"}}
		targetLabel.style.top_margin = 7
		targetLabel.style.font = "LabelFont"
		targetLabel.style.font_color = {108, 114, 229}
	
		local invs = {self.dataNetwork.dataCenter.invObj.name or {"gui-description.Any"}}
		local selectedIndex = 1
		local i = 1
		for k, deepStorage in pairs(global.deepStorageTable) do
			if deepStorage ~= nil and deepStorage.ent ~= nil and Util.canUse(self.player, deepStorage.ent) then
				i = i + 1
				local itemText = ""
				if deepStorage.filter ~= nil and game.item_prototypes[deepStorage.filter] ~= nil then
					itemText = {"", " (", game.item_prototypes[deepStorage.filter].localised_name, " - ", deepStorage.player, ")"}
				else
					itemText = {"", " - ",deepStorage.player}
                end
				invs[k+1] = {"", {"gui-description.DS"}, " ", tostring(deepStorage.ID), itemText}
				if self.selectedInv == deepStorage then
					selectedIndex = i
				end
			end
		end
		if selectedIndex ~= nil and selectedIndex > table_size(invs) then selectedIndex = nil end
		local invSelection = GUI.add{type="list-box", name="MP" .. self.ent.unit_number, items=invs, selected_index=selectedIndex}
		invSelection.style.width = 140
	end
end

-- Change the Targeted Inventory --
function MP:changeInventory(ID)
	-- Check the ID --
	if ID == nil then self.selectedInv = nil end
	-- Select the Inventory --
	self.selectedInv = nil
	for k, deepStorage in pairs(global.deepStorageTable) do
		if valid(deepStorage) then
			if ID == deepStorage.ID then
				self.selectedInv = deepStorage
			end
		end
	end
end

-- Set Active --
function MP:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation if it doesn't exist --
		if self.animID == 0 or rendering.is_valid(self.animID) == false then
			self.animID = rendering.draw_animation{animation="MatterPrinterA", target={self.ent.position.x,self.ent.position.y-0.45}, surface=self.ent.surface, render_layer=131}
		end
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
	end
end