-- DEEP STORAGE OBJECT --

-- Create the Deep Storage base object --
DSR = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
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
	t.MF = getMFBySurface(object.surface)
	t.entID = object.unit_number
	t.ID = getEntID(global.deepStorageTable)
	t.MF.dataNetwork.DSRTable[object.unit_number] = t
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
	-- Remove from the Update System --
	UpSys.removeObj(self)
	-- Remove from the MF Object --
	self.MF.dataNetwork.DSRTable[self.ent.unit_number] = nil
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

-- Item Tags to Content --
function DSR:itemTagsToContent(tags)
	self.inventoryItem = tags.inventoryItem or nil
	self.inventoryCount = tags.inventoryCount or 0
	self.filter = tags.filter or nil
end

-- Content to Item Tags --
function DSR:contentToItemTags(tags)
	if self.inventoryItem ~= nil or self.filter ~= nil then
		tags.set_tag("Infos", {inventoryItem=self.inventoryItem, inventoryCount=self.inventoryCount, filter=self.filter})
		tags.custom_description = {"", tags.prototype.localised_description, {"item-description.DeepStorageC", self.inventoryItem or self.filter, self.inventoryCount or 0}}
	end
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

	-- Display the Item Icon --
	if self.inventoryItem == nil and self.filter == nil then return true end
	local sprite = "item/" .. (self.inventoryItem or self.filter)
	rendering.draw_sprite{sprite=sprite, target=self.ent, surface=self.ent.surface, time_to_live=self.updateTick + 1, target_offset={0,-0.35}, render_layer=131}
end

-- Tooltip Infos --
function DSR:getTooltipInfos(GUITable, mainFrame, justCreated)


	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"", {"gui-description.DeepStorage"}, " ", self.ID}

		-- Create the Inventory Frame --
		local inventoryFrame = GAPI.addFrame(GUITable, "InventoryFrame", mainFrame, "vertical", true)
		inventoryFrame.style = "MFFrame1"
		inventoryFrame.style.vertically_stretchable = true
		inventoryFrame.style.left_padding = 3
		inventoryFrame.style.right_padding = 3
		inventoryFrame.style.left_margin = 3
		inventoryFrame.style.right_margin = 3

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", inventoryFrame, {"gui-description.Inventory"})

		-- Create the Inventory Table --
		GAPI.addTable(GUITable, "InventoryTable", inventoryFrame, 1, true)

		-- Create the Settings Frame --
		local settingsFrame = GAPI.addFrame(GUITable, "SettingsFrame", mainFrame, "vertical", true)
		settingsFrame.style = "MFFrame1"
		settingsFrame.style.vertically_stretchable = true
		settingsFrame.style.left_padding = 3
		settingsFrame.style.right_padding = 3
		settingsFrame.style.right_margin = 3

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", settingsFrame, {"gui-description.Settings"})

		-- Create the Filter Selection --
		GAPI.addLabel(GUITable, "", settingsFrame, {"", {"gui-description.FilterSelect"}, ":"}, nil, {"gui-description.TargetedStorage"}, false, nil, _mfLabelType.yellowTitle)
		local filter = GAPI.addFilter(GUITable, "D.S.R.Filter", settingsFrame, nil, true, "item", 40, {ID=self.ent.unit_number})
		GUITable.vars.filter = filter

	end

	-- Get the Table --
	local inventoryTable = GUITable.vars.InventoryTable

	-- Clear the Table --
	inventoryTable.clear()

	-- Get the Item Name --
	local itemName = nil
	if self.inventoryItem ~= nil then
		itemName = Util.getLocItemName(self.inventoryItem)
	elseif self.filter ~= nil then
		itemName = Util.getLocItemName(self.filter)
	else
		itemName = {"gui-description.Empty"}
	end

	-- Create the Item Name Label --
	GAPI.addLabel(GUITable, "", inventoryTable, {"gui-description.DSDTItemName", itemName}, _mfOrange)

	-- Create the Item Amount Label --
	GAPI.addLabel(GUITable, "", inventoryTable, {"gui-description.DSDTAmount", Util.toRNumber(self.inventoryCount or 0)}, _mfOrange)

	-- Create the Filter Label --
	local filterName = self.filter ~= nil and Util.getLocItemName(self.filter) or {"gui-description.None"}
	GAPI.addLabel(GUITable, "", inventoryTable, {"gui-description.DSDTFilter", filterName}, _mfOrange)

	-- Update the Filter --
	GUITable.vars.filter.elem_value = self.filter

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
		return removed
	end
	return 0
end

-- Settings To Blueprint Tags --
function DSR:settingsToBlueprintTags()
	local tags = {}
	tags["selfFilter"] = self.filter
	return tags
end

-- Blueprint Tags To Settings --
function DSR:blueprintTagsToSettings(tags)
	self.filter = tags["selfFilter"]
end

-- Check stored data, and remove invalid record
function DSR:validate()
	-- Remove the Item if it doesn't exist anymore --
	if self.inventoryItem ~= nil and game.item_prototypes[self.inventoryItem] == nil then
		self.inventoryItem = nil
		self.inventoryCount = 0
	end

	-- Remove the Item Filter if it doesn't exist anymore --
	if self.filter ~= nil and game.item_prototypes[self.filter] == nil then
		self.filter = nil
	end
end

-- Called if the Player interacted with the GUI --
function DSR.interaction(event)
	-- If this is a Deep Storage Filter --
	if string.match(event.element.name, "D.S.R.Filter") then
		local id = event.element.tags.ID
		if global.deepStorageTable[id] == nil then return end
		if event.element.elem_value ~= nil then
			global.deepStorageTable[id].filter = event.element.elem_value
		else
			global.deepStorageTable[id].filter = nil
		end
		GUI.updateAllGUIs(true)
		return
	end
end