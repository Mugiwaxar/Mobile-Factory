-- DATA NETWORK OBJECT --

-- Create the Data Network base object --
DN = {
	ID = 0,
	GCNTable = nil,
	RCNTable = nil,
	entitiesTable = nil,
	dataCenter = nil,
	wirelessDataTransmitter = nil,
	wirelessReceiverTable = nil,
	energyCubeTable = nil,
	dataStorageTable = nil,
	totalEnergy = 0,
	powerConsumption = 0,
	inConflict = false,
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
	t.GCNTable = {}
	t.RCNTable = {}
	t.entitiesTable = {}
	t.wirelessReceiverTable = {}
	t.energyCubeTable = {}
	t.dataStorageTable = {}
	table.insert(global.dataNetworkTable, t)
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
end

-- Is valid --
function DN:valid()
	if self.dataCenter:valid() == true then
		return true
	end
	return false
end

-- Is live --
function DN:isLive()
	if self.inConflict == true then return false end
	if self.outOfPower == true then return false end
	return true
end

-- Update --
function DN:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Check all added Network --
	self:checkNetworkID()
	-- Get all Linked Entities --
	self:getAllNetworkEntities() --
	-- Sort all Linked Entities --
	self:sortEntities()
	-- Drain Power --
	if self:drainPower(self:powerConsumption()) > 0 then
		self.outOfPower = false
	else
		self.outOfPower = true
	end
end

-- Check all Network ID --
function DN:checkNetworkID()
	-- Check the Green Network Table --
	for k, obj in pairs(self.GCNTable) do
		if obj == nil or getmetatable(obj) == nil or obj:valid() == false or obj.active == false or k ~= obj.GCNID then
			self.GCNTable[k] = nil
		end
	end
	-- Check the Red Network Table --
	for k, obj in pairs(self.RCNTable) do
		if obj == nil or getmetatable(obj) == nil or obj:valid() == false or obj.active == false or k ~= obj.RCNID then
			self.RCNTable[k] = nil
		end
	end
	
	-- Add Data Center Circuit Network --
	self.GCNTable[self.dataCenter.GCNID] = self.dataCenter
	self.RCNTable[self.dataCenter.RCNID] = self.dataCenter
end

-- Add all Linked Entities inside the Entities Table --
function DN:getAllNetworkEntities()
	-- Clear the Table --
	self.entitiesTable = {}
	-- Look for all Entities linked trought the Green Circuit Network --
	for k, obj in pairs(global.entsTable) do
		if obj.GCNID ~= 0 and self.GCNTable[obj.GCNID] ~= nil then
			if obj:valid() == true then
				self.entitiesTable[obj.ent.unit_number] = obj
			end
		end
	end
	-- Look for all Entities linked trought the Green Circuit Network --
	for k, obj in pairs(global.entsTable) do
		if obj.RCNID ~= 0 and self.RCNTable[obj.RCNID] ~= nil then
			if obj:valid() == true then
				self.entitiesTable[obj.ent.unit_number] = obj
			end
		end
	end
end

-- Sort all Entities inside they respective Tables --
function DN:sortEntities()
	-- Clear Tables and initialize Variables --
	self.wirelessDataTransmitter = nil
	self.wirelessReceiverTable = {}
	self.energyCubeTable = {}
	self.dataStorageTable = {}
	self.inConflict = false
	
	-- Sort all Entities --
	for k, obj in pairs(self.entitiesTable) do
		-- Data Center --
		if obj.ent.name == "DataCenter" or obj.ent.name == "DataCenterMF" then
			if obj.ent.unit_number ~= self.dataCenter.ent.unit_number then
				-- Stop, only one Data Center per Data Network --
				self.inConflict = true
				return
			end
		end
		-- EnergyCube --
		if string.match(obj.ent.name, "EnergyCube") then
			self.energyCubeTable[k] = obj
		end
		-- Data Storage --
		if obj.ent.name == "DataStorage" then
			self.dataStorageTable[k] = obj
		end
		-- Wireless Data Transmitter --
		if obj.ent.name == "WirelessDataTransmitter" then
			self.wirelessDataTransmitter = obj
		end
		-- Wireless Data Receiver --
		if obj.ent.name == "WirelessDataReceiver" then
			self.wirelessReceiverTable[k] = obj
		end
	end
	
end

-- Return true if the passed Object is a part of this Data Network --
function DN:isLinked(obj)
	if obj:valid() == true and self.entitiesTable[obj.ent.unit_number] ~= nil then
		return true
	end
	return false
end

-- Return the available Power --
function DN:availablePower()
	-- Calcule the Total Power available --
	local totalPower = 0
	for k, obj in pairs(self.energyCubeTable) do
		if obj:valid() then
			totalPower = totalPower + obj.ent.energy
		end
	end
	return totalPower
end

-- Return the Power Consumption --
function DN:powerConsumption()
	-- Calcule the total Power Consumption --
	local totalConsumption = 0
	for k, obj in pairs(self.entitiesTable) do
		totalConsumption = totalConsumption + (obj.consumption or 0)
	end
	return totalConsumption
end

-- Return the number of Data Storage --
function DN:dataStoragesCount()
	-- Calcule the total number of valid Data Storage --
	local totalDataStorages = 0
	for k, obj in pairs(self.dataStorageTable) do
		if obj:valid() and obj.active then
			totalDataStorages = totalDataStorages + 1
		end
	end
	return totalDataStorages
end

-- Drain Power from the Data Network and return the amount that was drained --
function DN:drainPower(amount)
	-- Get the available Energy --
	local availableEnergy = self:availablePower()
	-- Return if the amount is upper than the available Energy --
	if amount > availableEnergy then return 0 end
	-- Remove the Energy from Energy Cubes --
	local energyLeft = amount
	local i = 0
	local energyToRemovePerCube = math.floor(amount/table_size(self.energyCubeTable))
	while energyLeft > 0 do
		for k, ec in pairs(self.energyCubeTable) do
			local removedEnergy = math.min(ec.ent.energy, energyToRemovePerCube)
			ec.ent.energy = ec.ent.energy - removedEnergy
			energyLeft = energyLeft - removedEnergy
		end
		i = i + 1
		if i > 100 then break end
	end
	return amount
end












