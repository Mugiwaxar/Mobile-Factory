-- INVENTORY OBJECT --

-- Create the Inventory base object --
INV = {
	name = "",
	usedCapacity = 0,
	maxCapacity = _mfBaseMaxItems,
	dataStoragesCount = 0,
	inventory = nil, -- [name]{count}
	isII = false
}

-- Constructor --
function INV:new(name)
	if name == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = INV
	t.name = name
	t.inventory = {}
	return t
end

-- Reconstructor --
function INV:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = INV
	setmetatable(object, mt)
end

-- Is valid --
function INV:valid()
	return true
end

-- Rescan Inventory --
function INV:rescan()

	-- Calcule the max capacity --
	if self.isII == true then
		self.dataStoragesCount = 0
		if valid(global.MF.dataCenter) == true and global.MF.dataCenter.active == true then
			if global.MF.dataCenter.dataNetwork ~= nil then
				self.dataStoragesCount = table_size(global.MF.dataCenter.dataNetwork.dataStorageTable)
			end
		end
	end
	self.maxCapacity = _mfBaseMaxItems + (_mfDataStorageCapacity*self.dataStoragesCount)
	
	self.usedCapacity = 0
	-- Itinerate the Invernal Inventory --
	for item, count in pairs(self.inventory) do
		-- Check if the Item still exist --
		if game.item_prototypes[item] == nil then
			self.inventory[item] = nil
		else
			self.usedCapacity = self.usedCapacity + count
		end
	end
end

-- Return remaining capacity --
function INV:remCap()
	return self.maxCapacity - self.usedCapacity
end

-- Return the number of requested Item --
function INV:hasItem(item)
	return self.inventory[item] or 0
end

-- Return if the Item can be accepted --
function INV:canAccept(name)
	if self:remCap() > 0 then return true end
	return false
end

-- Request to add an Item and return the amount added --
function INV:addItem(item, amount)

	-- Check if the Item can be accepted --
	if self:canAccept(item) == false then return 0 end

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
		-- Set the new Capacity --
		self.usedCapacity = self.usedCapacity + capableAmount
	end
	
	-- Return the amount inserted --
	return capableAmount
	
end

-- Request to remove an Item and return the amount removed --
function INV:getItem(item, amount)
	
	-- Check if the Item is inside the Inventory --
	if self.inventory[item] ~= nil then
	
		-- Calcule the amount removed --
		local itemAmount = math.min(amount, self.inventory[item])
		
		-- Remove the Item amount --
		self.inventory[item] = self.inventory[item] - itemAmount
		
		-- Remove the Item if it doesn't exist anymore inside the Inventory --
		if self.inventory[item] <= 0 then
			self.inventory[item] = nil
		end
		
		-- Set the new Capacity --
		self.usedCapacity = self.usedCapacity - itemAmount
		
		-- Return the amount removed --
		return itemAmount
	end
	
	return 0
	
end

-- Return the Best Quatron Charge --
function INV:getBestQuatron()
	for i=100, 1, -1 do
		if self.inventory["Quatron"..i] ~= nil then
			self:getItem("Quatron"..i, 1)
			return i
		end
	end
	return 0
end

-- Return the Inventory Frame --
function INV:getFrame(guiElement)

	-- Create the Title Label --
	local title = guiElement.add{type="label"}
	title.style.font = "TitleFont"
	title.caption = (self.name)
	
	-- Create the Amount label --
	local amount = guiElement.add{type="label"}
	amount.style.font = "LabelFont"
	amount.caption = {"", {"gui-description.InventoryAmount"}, ": ", Util.toRNumber(self.usedCapacity), "/", Util.toRNumber(self.maxCapacity)}
	amount.style.font_color = {108, 114, 229}
	
	-- Create the Data Storage Label --
	local dataStorage = guiElement.add{type="label"}
	dataStorage.style.font = "LabelFont"
	dataStorage.caption = {"", {"gui-description.dataStorage"}, ": ", self.dataStoragesCount}
	dataStorage.style.font_color = {108, 114, 229}
	dataStorage.style.bottom_margin = 7
	
	-- Create the Inventory List Flow --
	local invList = guiElement.add{type="flow", direction="vertical"}
	-- Create the list --
	for item, count in pairs(self.inventory) do
		Util.itemToFrame(item, count, invList)
	end
	
end









