-- DEEP STORAGE OBJECT --

-- Create the Deep Storage base object --
DSR = {
	ent = nil,
	updateTick = 0,
	lastUpdate = 0,
	inventoryItem = nil,
	inventoryCount = 0,
	ID = 0
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
	dsTable = {}
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

-- Update --
function DSR:update()
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
end

-- Return the number of item present inside the Inventory --
function DSR:hasItem(name)
	if self.inventoryItem ~= nil and self.inventoryItem == name then
		return self.inventoryCount
	end
	return 0
end

-- Add Items --
function DSR:addItem(name, count)
	if self.inventoryItem == nil or self.inventoryItem == name then
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








