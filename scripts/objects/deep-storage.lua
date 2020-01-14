-- DEEP STORAGE OBJECT --

-- Create the Deep Storage base object --
DSR = {
	ent = nil,
	updateTick = 0,
	lastUpdate = 0,
	inventoryItem = nil,
	inventoryCount = 0
}

-- Constructor --
function DSR:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DSR
	t.ent = object
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
	IDL.caption = {"", {"gui-description.DeepStorageID"}, ": ", tostring(self.ent.unit_number)}
	IDL.style.font_color = {92, 232, 54}

	-- Create the Inventory List --
	if self.inventoryItem ~= nil and self.inventoryCount > 0 then
		Util.itemToFrame(self.inventoryItem, self.inventoryCount, GUI)
	end
end














