-- INVENTORY OBJECT --

-- Create the Inventory base object --
INV = {
	name = "",
	MF = nil,
	dataNetwork = nil,
	networkController = nil,
	usedCapacity = 0,
	maxCapacity = _mfBaseMaxItems,
	inventory = nil -- [name]{count}
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
	-- Get the max Capacity --
	self.maxCapacity = _mfBaseMaxItems + (_mfDataStorageCapacity*self.dataNetwork:dataStoragesCount())
	-- Get the used Capacity --
	self.usedCapacity = 0
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
	self:rescan()
	return self.maxCapacity - self.usedCapacity
end

-- Return the number of requested Item --
function INV:hasItem(item)
	return self.inventory[item] or 0
end

-- Return if the Item can be accepted --
function INV:canAccept(number)
	if number ~= nil then
		if self:remCap() >= number then return true end
	end
	if self:remCap() > 0 then return true end
	return false
end

-- Request to add an Item and return the amount added --
function INV:addItem(item, amount)

	-- Check if the Item can be accepted --
	if self:canAccept() == false then return 0 end

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

-- Get the Tooltip --
function INV:getTooltipInfos(GUIObj, gui)

	-- Rescan the Inventory --
	self:rescan()
	
	-- Create the Title --
	local frame = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Inventory"}, _mfOrange)

	-- Create the total Items Label --
	GUIObj:addDualLabel(frame, {"", {"gui-description.INVTotalItems"}, ":"}, Util.toRNumber(self.usedCapacity) .. "/" .. Util.toRNumber(self.maxCapacity), _mfOrange, _mfGreen, nil, nil, self.usedCapacity .. "/" .. self.maxCapacity)

	-- Create the Number of Data Storage Label --
	GUIObj:addDualLabel(frame, {"", {"gui-description.INVTotalDataStorages"}, ":"}, self.dataNetwork:dataStoragesCount(), _mfOrange, _mfGreen)

	-- Create the Item List Flow --
	local listFlow = GUIObj:addFlow("", frame, "vertical")

	-- Create the Items Table --
	local table = GUIObj:addTable("", frame, 5)

	-- Look for all Items --
	for name, count in pairs(self.inventory) do
		-- Check the Item --
		if name == nil or count == nil or count == 0 or game.item_prototypes[name] == nil then goto continue end
		-- Create the Button --
		Util.itemToFrame(name, count, GUIObj, table)
		::continue::
	end

end

-- Return the Inventory Frame --
function INV:getFrame(guiElement)
	
	-- Create the Inventory List Flow --
	local invList = guiElement.add{type="flow", direction="vertical"}
	-- Create the list --
	for item, count in pairs(self.inventory) do
		Util.itemToFrame(item, count, invList)
	end
	
end