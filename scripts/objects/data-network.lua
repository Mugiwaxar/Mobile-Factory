-- DATA NETWORK OBJECT --

-- Create the Data Network base object --
DN = {
	ID = 0,
	entitiesTable = nil,
	dataCenter = nil,
	wirelessDataTransmitter = nil,
	wirelessReceiverTable = nil,
	energyCubeTable = nil,
	dataStorageTable = nil,
	signalsTable = nil, -- {obj, signal}
	totalEnergy = 0,
	totalConsumption = 0,
	outOfPower = true,
	updateTick = 60,
	lastUpdate = 0
}

-- Constructor --
function DN:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DN
	t.dataCenter = object
	t.ID = getDataNetworkID()
	t.entitiesTable = {}
	t.wirelessReceiverTable = {}
	t.energyCubeTable = {}
	t.dataStorageTable = {}
	t.signalsTable = {}
	table.insert(global.dataNetworkTable, t)
	t.entitiesTable[object.ent.unit_number] = object
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function DN:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = DN
	setmetatable(object, mt)
end

-- Destructor --
function DN:remove()
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function DN:valid()
	if valid(self.dataCenter) == true then
		return true
	end
	return false
end

-- Is live --
function DN:isLive()
	if valid(self.dataCenter) == false then return false end
	if self.outOfPower == true then return false end
	return true
end

-- Update --
function DN:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end
	-- Drain Power --
	if self:drainPower(self:powerConsumption()) == true then
		self.outOfPower = false
	else
		self.outOfPower = true
	end
	-- Update all Signals --
	self:updateSignals()
end

-- Get the Tooltip --
function DN:getTooltipInfos(GUIObj, gui, obj)

	-- Create the Belongs to Label --
	GUIObj:addDualLabel(gui, {"", {"gui-description.BelongsTo"}, ":"}, obj.player, _mfOrange, _mfGreen)

	-- Create the Total Energy Label --
	GUIObj:addDualLabel(gui, {"", {"gui-description.DNTotalEnergy"}, ":"}, Util.toRNumber(self.totalEnergy) .. "J", _mfOrange, _mfYellow)

	-- Create the Consumption Label --
	GUIObj:addDualLabel(gui, {"", {"gui-description.DNTotalConsumption"}, ":"}, Util.toRNumber(self.totalConsumption) .. "W", _mfOrange, _mfYellow)

	-- Create the Out Of Power Label --
	if self.outOfPower == true then
		GUIObj:addLabel("", gui, {"gui-description.DNOutOfPower"}, _mfRed)
	end

end

-- Register Object --
function DN:addObject(obj)
	if valid(obj) == false then return end
	-- Add the Object to the Entities Table --
	self.entitiesTable[obj.entID] = obj
	-- Check if the Object have to be in another Table --
	-- EnergyCube --
	if string.match(obj.ent.name, "EnergyCube") then
		self.energyCubeTable[obj.entID] = obj
	end
	-- Data Storage --
	if obj.ent.name == "DataStorage" then
		self.dataStorageTable[obj.entID] = obj
	end
	-- Wireless Data Receiver --
	if obj.ent.name == "WirelessDataReceiver" then
		self.wirelessReceiverTable[obj.entID] = obj
	end
end

-- Remove Object --
function DN:removeObject(obj)
	if obj == nil then return end
	-- Remove the Object from the Entities Table --
	self.entitiesTable[obj.entID] = nil
	-- Check if the Object have to be removed from another Table --
	-- EnergyCube --
	self.energyCubeTable[obj.entID] = nil
	-- Data Storage --
	self.dataStorageTable[obj.entID] = nil
	-- Wireless Data Receiver --
	self.wirelessReceiverTable[obj.entID] = nil
end

-- Return true if the passed Object is a part of this Data Network --
function DN:isLinked(obj)
	if valid(obj) == true and self.entitiesTable[obj.ent.unit_number] ~= nil then
		return true
	end
	return false
end

-- Return the available Power --
function DN:availablePower()
	-- Calcule the Total Power available --
	self.totalEnergy = 0
	for k, obj in pairs(self.energyCubeTable) do
		if valid(obj) then
			self.totalEnergy = self.totalEnergy + obj.ent.energy
		end
	end
	return self.totalEnergy
end

-- Return the Power Consumption --
function DN:powerConsumption()
	-- Calcule the total Power Consumption --
	self.totalConsumption = 0
	for k, obj in pairs(self.entitiesTable) do
		if valid(obj) == false then
			self.entitiesTable[k] = nil
		else
			if obj.active == true or (obj.ent ~= nil and string.match(obj.ent.name, "DataCenter")) then
				self.totalConsumption = self.totalConsumption + (obj.consumption or 0)
			end
		end
	end
	return self.totalConsumption
end

-- Return the number of Data Storage --
function DN:dataStoragesCount()
	-- Calcule the total number of valid Data Storage --
	local totalDataStorages = 0
	for k, obj in pairs(self.dataStorageTable) do
		totalDataStorages = totalDataStorages + 1
	end
	return totalDataStorages
end

-- Drain Power from the Data Network and return the amount that was drained --
function DN:drainPower(amount)
	-- Get the available Energy --
	local availableEnergy = self:availablePower()
	-- Return if the amount is upper than the available Energy --
	if amount > availableEnergy then return false end
	-- Remove the Energy from Energy Cubes --
	local energyLeft = amount
	local i = 0
	local energyToRemovePerCube = math.floor(amount/table_size(self.energyCubeTable))
	while energyLeft > 0 do
		for k, ec in pairs(self.energyCubeTable) do
			if valid(ec) == true then
				local removedEnergy = math.min(ec.ent.energy, energyToRemovePerCube)
				ec.ent.energy = ec.ent.energy - removedEnergy
				energyLeft = energyLeft - removedEnergy
			end
		end
		i = i + 1
		if i > 100 then break end
	end
	return true
end

-- Update all Signals --
function DN:updateSignals()
	-- Clear the Table --
	self.signalsTable = {}
	-- Get all signals from Transmitter --
	if valid(self.wirelessDataTransmitter) == true then
		self.wirelessDataTransmitter:getSignals(self.signalsTable)
	end
	-- Get all signals from Receivers --
	for k, receiver in pairs(self.wirelessReceiverTable) do
		if valid(receiver) == true then
			receiver:getSignals(self.signalsTable)
		end
	end
end

-- Return how many Items the Data Network has --
function DN:hasItem(item)
	-- Check the Data Center --
	if self.dataCenter == nil then return 0 end
	local amount = 0
	local playerName = self.dataCenter.player
	-- Check the Deep Storages --
	for k, deepStorage in pairs(global.deepStorageTable) do
		if deepStorage.player == playerName then
			amount = amount + deepStorage:hasItem(item)
		end
	end
	-- Check the Data Center --
	amount = amount + self.dataCenter.invObj:hasItem(item)
	-- Return the Amount --
	return amount
end

-- Return the Fluid amount the Data Network has --
function DN:hasFluid(fluid)
	-- Check the Data Center --
	if self.dataCenter == nil then return 0 end
	local amount = 0
	local playerName = self.dataCenter.player
	-- Check the Deep Tank --
	for k, deepTank in pairs(global.deepTankTable) do
		if deepTank.player == playerName then
			amount = amount + deepTank:hasFluid(fluid)
		end
	end
	-- Return the Amount --
	return amount
end

-- Get Items from the Data Network --
function DN:getItem(item, amount)
	-- Check if the Item still exist --
	if game.item_prototypes[item] == nil then return 0 end
	-- Check the Data Center --
	if self.dataCenter == nil then return 0 end
	-- Set the Amount of Item to retrieve left --
	local amountLeft = amount
	local playerName = self.dataCenter.player
	-- Check the Deep Storages --
	for k, deepStorage in pairs(global.deepStorageTable) do
		if deepStorage.player == playerName then
			local amountGot = deepStorage:getItem(item, amountLeft)
			amountLeft = amountLeft - amountGot
			if amountLeft <= 0 then return amount end
		end
	end
	-- Check the Data Center --
	amountLeft = amountLeft - self.dataCenter.invObj:getItem(item, amountLeft)
	-- Return the amount removed --
	return amount - amountLeft
end

-- Get Fluid form the Data Network --
function DN:getFluid(fluid, amount)
	-- Check if the Fluid still exist --
	if game.fluid_prototypes[fluid] == nil then return 0 end
	-- Check the Data Center --
	if self.dataCenter == nil then return 0 end
	-- Set the Amount of Item to retrieve left --
	local amountLeft = amount
	local playerName = self.dataCenter.player
	-- Check the Deep Tanks --
	for k, deepTank in pairs(global.deepTankTable) do
		if deepTank.player == playerName then
			local amountGot = deepTank:getFluid({name=fluid, amount=amountLeft})
			amountLeft = amountLeft - amountGot
			if amountLeft <= 0 then return amount end
		end
	end
	-- Return the amount removed --
	return amount - amountLeft
end

-- Check if the Data Network can accept a Item --
function DN:canAcceptItem(item, amount)
	-- Check the Data Center --
	if self.dataCenter == nil then return 0 end
	local playerName = self.dataCenter.player
	-- Check the Deep Storages --
	for k, deepStorage in pairs(global.deepStorageTable) do
		if deepStorage.player == playerName and deepStorage:canAccept(item) then
			return true
		end
	end
	-- Check the Data Center --
	if self.dataCenter.invObj:canAccept(amount) then return true end
	return false
end

-- Check if the Data Network can accept a Fluid --
function DN:canAcceptFluid(fluid, amount)
	-- Check the Data Center --
	if self.dataCenter == nil then return 0 end
	local playerName = self.dataCenter.player
	-- Check the Deep Tanks --
	for k, deepTank in pairs(global.deepTankTable) do
		if deepTank.player == playerName and deepTank:canAccept({name=fluid, amount=amount}) then
			return true
		end
	end
	return false
end

-- Send Items to the Data Network --
function DN:addItems(item, amount)
	-- Check if the Item still exist --
	if game.item_prototypes[item] == nil then return 0 end
	-- Check the Data Center --
	if self.dataCenter == nil then return 0 end
	-- Set the Amount of Item to send left --
	local amountLeft = amount
	local playerName = self.dataCenter.player
	-- Check the Deep Storages --
	for k, deepStorage in pairs(global.deepStorageTable) do
		if deepStorage.player == playerName and deepStorage:canAccept(item) then
			deepStorage:addItem(item, amount)
			return amount
		end
	end
	-- Check the Data Center --
	amountLeft = amountLeft - self.dataCenter.invObj:addItem(item, amountLeft)
	-- Return the amount added --
	return amount - amountLeft
end

-- Send Fluid to the Data Network --
function DN:addFluid(fluid, amount, temperature)
	-- Check if the Fluid still exist --
	if game.fluid_prototypes[fluid] == nil then return 0 end
	-- Check the Data Center --
	if self.dataCenter == nil then return 0 end
	-- Set the Amount of Item to retrieve left --
	local amountLeft = amount
	local playerName = self.dataCenter.player
	-- Check the Deep Tanks --
	for k, deepTank in pairs(global.deepTankTable) do
		if deepTank.player == playerName then
			local amountSend = deepTank:addFluid({name=fluid, amount=amountLeft, temperature=temperature})
			amountLeft = amountLeft - amountSend
			if amountLeft <= 0 then return amount end
		end
	end
	-- Return the amount added --
	return amount - amountLeft
end