-- DEEP STORAGE OBJECT --

-- Create the Deep Storage base object --
DSR = {
	ent = nil,
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
	if game.item_prototypes[self.inventoryItem] == nil then
		self.inventoryItem = nil
		self.inventoryCount = 0
		return
	end
	
	-- Display the Item Icon --
	if self.inventoryItem == nil then return true end
	local sprite = "item/" .. self.inventoryItem
	rendering.draw_sprite{sprite=sprite, target=self.ent, surface=self.ent.surface, time_to_live=self.updateTick + 1, target_offset={0,-0.35}, render_layer=131}
end

-- Tooltip Infos --
function DSR:getTooltipInfos(GUI)
	-- Create the ID label --
	local IDL = GUI.add{type="label"}
	IDL.style.font = "LabelFont"
	IDL.caption = {"", {"gui-description.DeepStorageID"}, ": ", tostring(self.ID)}
	IDL.style.font_color = {92, 232, 54}

	-- Create the Inventory List --
	if self.inventoryItem ~= nil and self.inventoryCount > 0 then
		Util.itemToFrame(self.inventoryItem, self.inventoryCount, GUI)
	end

	-- Create the Filter Display --
	if self.filter ~= nil and game.item_prototypes[self.filter] ~= nil then
		local fDisplayL = GUI.add{type="label"}
		fDisplayL.style.font = "LabelFont"
		fDisplayL.caption = {"", {"gui-description.Filter"}, ": "}
		fDisplayL.style.font_color = {92, 232, 54}
		fDisplayL.style.top_margin = 10

		local sprite = "item/" .. self.filter
		local fDisplayI = GUI.add{type="sprite", sprite=sprite}
		fDisplayI.tooltip = self.filter
	end

	-- Add the Set Filter Button --
	local fButton = GUI.add{type="button", name = "MFInfos", caption={"", {"gui-description.SetFilter"}}}
	fButton.style.width = 100

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








