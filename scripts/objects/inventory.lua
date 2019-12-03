-- INVENTORY OBJECT --

-- Create the Inventory base object --
II = {
	name = "",
	usedCapacity = 0,
	maxCapacity = _mfBaseMaxItems,
	inventory = nil, -- [name]{count}
	dataStoragesTable = nil
}

-- Constructor --
function II:new(name)
	if name == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = II
	t.name = name
	return t
end

-- Reconstructor --
function II:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = II
	setmetatable(object, mt)
end

-- Rescan Inventory --
function II:rescan()

	-- Check if the Inventory Table is valid --
	if self.inventory == nil then self.inventory = {} end
	
	local totalItem = 0
	-- Itinerate the Invernal Inventory --
	for item, count in pairs(self.inventory) do
		totalItem = totalItem + count
	end
	
	-- Save the used Capacity --
	self.usedCapacity = totalItem
	
end

-- Return remaining capacity --
function II:remCap()
	-- Rescan the Inventory --
	self:rescan()
	return self.maxCapacity - self.usedCapacity
end

-- Return the number of requested Item --
function II:hasItem(item)
	-- Check if the Inventory Table is valid --
	if self.inventory == nil then self.inventory = {} end
	
	-- Rescan the Inventory --
	self:rescan()
	
	-- Test if the item exist and return the amount --
	if self.inventory[item] ~= nil then
		return self.inventory[item]
	end
	
	return 0
end

-- Request to add an Item and return the amount added --
function II:addItem(item, amount)
	-- Check if the Inventory Table is valid --
	if self.inventory == nil then self.inventory = {} end

	-- Rescan the Inventory --
	self:rescan()

	-- Calcule the amount of items that can be inserted --
	local capableAmount = math.min(amount, self:remCap())
	
	-- Check if the amount is > 0 --
	if capableAmount > 0 then
		-- Insert the Item --
		if self.inventory[item] ~= nil then
			self.inventory[item] = self.inventory[item] + capableAmount
		else
			self.inventory[item] = capableAmount
		end
	end
	
	-- Return the amount inserted --
	return amount - capableAmount	
	
end

-- Request to remove an Item and return the amount removed --
function II:getItem(item, amount)
	-- Check if the Inventory Table is valid --
	if self.inventory == nil then self.inventory = {} end
	
	-- Rescan the Inventory --
	self:rescan()

	-- Check if the Item is inside the Inventory --
	if self.inventory[item] ~= nil then
	
		-- Calcule the amount removed --
		local itemAmount = math.min(amount, self.inventory[item])
		
		-- Remove the Item amount --
		self.inventory[item] = self.inventory[item] - itemAmount
		
		-- Remove the Item it doesn't exist anymore inside the Inventory --
		if self.inventory[item] >= 0 then
			self.inventory[item] = nil
		end
		
		-- Return the amount removed --
		return itemAmount
	end
	
	return 0
end

-- Return the Inventory Frame --
function II:getFrame(guiElement)
	-- Check if the Inventory Table is valid --
	if self.inventory == nil then self.inventory = {} end
	
	-- Rescan the Inventory --
	self:rescan()

	-- Create the Title Label --
	local title = guiElement.add{type="label"}
	title.style.font = "TitleFont"
	title.caption = (self.name)
	
	-- Create the Amount label --
	local amount = guiElement.add{type="label"}
	amount.style.font = "LabelFont"
	amount.caption = {"", {"gui-description.InventoryAmount"}, ": ", self.usedCapacity, "/", self.maxCapacity}
	amount.style.font_color = {108, 114, 229}
	
	-- Create the Data Storage Label --
	local dataStorage = guiElement.add{type="label"}
	dataStorage.style.font = "LabelFont"
	dataStorage.caption = {"", {"gui-description.dataStorage"}, ": ", table_size(self.dataStoragesTable)}
	dataStorage.style.font_color = {108, 114, 229}
	dataStorage.style.bottom_margin = 7
	
	-- Create the Inventory List Flow --
	local invList = guiElement.add{type="flow", direction="vertical"}
	invList.style.width = 205
	-- Create the list --
	for item, count in pairs(self.inventory) do
		II:itemToFrame(item, count, invList)
	end
	
end

-- Create a frame from an Item --
function II:itemToFrame(item, amount, guiElement)

	-- Create the Frame --
	local frame = guiElement.add{type="frame", direction="horizontal"}
	frame.style.minimal_width = 100
	frame.style.margin = 0
	frame.style.padding = 0
	
	-- Add the Icon and the Tooltip to the frame --
	local sprite = frame.add{type="sprite", tooltip=game.item_prototypes[item].localised_name, sprite="item/" .. item}
	sprite.style.padding = 0
	sprite.style.margin = 0
	
	-- Add the amount label --
	local label = frame.add{type="label", caption=tonumber(amount)}
	label.style.padding = 0
	label.style.margin = 0
	
end








