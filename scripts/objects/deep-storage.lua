-- DEEP STORAGE OBJECT --

-- Create the Deep Storage base object --
DSR = {
	ent = nil,
	player = "",
	MF = nil,
	updateTick = 80,
	lastUpdate = 0,
	inventoryItem = nil,
	inventoryCount = 0,
	ID = 0,
	filter = nil
}

-- Constructor --
function DSR:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DSR
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.ID = Util.getEntID(global.deepStorageTable)
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function DSR:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = DSR
	setmetatable(object, mt)
end

-- Destructor --
function DSR:remove()
end

-- Is valid --
function DSR:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Copy Settings --
function DSR:copySettings(obj)
	self.filter = obj.filter
end

-- Update --
function DSR:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end
	
	-- Remove the Item if it doesn't exist anymore --
	if self.inventoryItem ~= nil and game.item_prototypes[self.inventoryItem] == nil then
		self.inventoryItem = nil
		self.inventoryCount = 0
		return
	end

	-- Remove the Item Filter if it doesn't exist anymore --
	if self.filter ~= nil and game.item_prototypes[self.filter] == nil then
		self.filter = nil
		return
	end
	
	-- Display the Item Icon --
	if self.inventoryItem == nil and self.filter == nil then return true end
	local sprite = "item/" .. (self.inventoryItem or self.filter)
	rendering.draw_sprite{sprite=sprite, target=self.ent, surface=self.ent.surface, time_to_live=self.updateTick + 1, target_offset={0,-0.35}, render_layer=131}
end

-- Tooltip Infos --
function DSR:getTooltipInfos(GUIObj, gui, justCreated)

	-- Create the Title --
	local frame = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Inventory"}, _mfOrange)

	-- Create the Item Frame --
	if self.inventoryItem ~= nil or self.filter ~= nil then
		Util.itemToFrame(self.inventoryItem or self.filter, self.inventoryCount or 0, GUIObj, frame)
	end

	-- Create the Item Name Label --
	local itemName = Util.getLocItemName(self.inventoryItem) or Util.getLocItemName(self.filter) or {"gui-description.Empty"}
	GUIObj:addDualLabel(frame, {"", {"gui-description.ItemName"}, ":"}, itemName, _mfOrange, _mfGreen)

	-- Create the Item Amount Label --
	local itemAmount = self.inventoryCount or 0
	GUIObj:addDualLabel(frame, {"", {"gui-description.Amount"}, ":"}, Util.toRNumber(itemAmount), _mfOrange, _mfGreen, nil, nil, itemAmount)

	-- Create the Filter Label --
	local filterName = Util.getLocItemName(self.filter) or {"gui-description.None"}
	GUIObj:addDualLabel(frame, {"", {"gui-description.Filter"}, ":"}, filterName, _mfOrange, _mfGreen)

	-- Create the Filter Selection --
	if justCreated == true and canModify(getPlayer(gui.player_index).name, self.ent) == true then
		GUIObj.SettingsFrame.visible = true
		local titleFrame = GUIObj:addTitledFrame("", GUIObj.SettingsFrame, "vertical", {"gui-description.Settings"}, _mfOrange)
		GUIObj:addLabel("", titleFrame, {"gui-description.ChangeFilter"}, _mfOrange)
		GUIObj:addFilter("DSRF" .. tostring(self.ent.unit_number), titleFrame, {"gui-description.FilterSelect"}, true, "item", 40)
	end

	-- Update the Filter --
	if game.item_prototypes[self.filter] ~= nil and GUIObj["DSRF" .. tostring(self.ent.unit_number)] ~= nil then
		GUIObj["DSRF" .. tostring(self.ent.unit_number)].elem_value = self.filter
	end

end

-- Return the number of item present inside the Inventory --
function DSR:hasItem(name)
	if self.inventoryItem ~= nil and self.inventoryItem == name then
		return self.inventoryCount
	end
	return 0
end

-- Return if the Item can be accepted --
function DSR:canAccept(name)
	if self.filter == nil then return false end
	if self.filter ~= nil and self.filter ~= name then return false end
	if self.inventoryItem ~= nil and self.inventoryItem ~= name then return false end
	return true
end

-- Add Items --
function DSR:addItem(name, count)
	if self:canAccept(name) == true then
		self.inventoryItem = name
		self.inventoryCount = self.inventoryCount + count
		return count
	end
	return 0
end

-- Remove Items --
function DSR:getItem(name, count)
	if self.inventoryItem ~= nil and self.inventoryItem == name then
		local removed = math.min(count, self.inventoryCount)
		self.inventoryCount = self.inventoryCount - removed
		if self.inventoryCount == 0 then self.inventoryItem = nil end
	end
	return 0
end