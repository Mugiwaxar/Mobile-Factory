-- DATA CENTER MF OBJECT --

-- Create the Data Center MF base object --
DCMF = {
	ent = nil,
	invObj = nil,
	animID = 0,
	active = false,
	dataStorages = nil,
	updateTick = 60,
	lastUpdate = 0,
	GCNID = 0,
	RCNID = 0,
	CNEntitiesTable = nil,
	CNEnergyCubesTable = nil,
	totalCircuitNetworkEnergy = 0,
	currentCircuitNetworkConsumption = 0
}

-- Contructor --
function DCMF:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DCMF
	t.ent = object
	t.invObj = global.MF.II
	t.dataStorages = {}
	t.CNEntitiesTable = {}
	t.CNEnergyCubesTable = {}
	return t
end

-- Reconstructor --
function DCMF:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = DCMF
	setmetatable(object, mt)
end

-- Destructor --
function DCMF:remove()
	-- Destroy the Inventory --
	self.invObj = nil
	-- Destroy the Animation --
	rendering.destroy(self.animID)
end

-- Is valid --
function DCMF:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function DCMF:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Entity --
	if self.ent == nil or self.ent.valid == false then return end
	
	-- Check if the Entity is inside a Green Circuit Network --
	if self.ent.get_circuit_network(defines.wire_type.green) ~= nil and self.ent.get_circuit_network(defines.wire_type.green).valid == true then
		self.GCNID = self.ent.get_circuit_network(defines.wire_type.green).network_id
	else
		self.GCNID = 0
	end
	
	-- Check if the Entity is inside a Red Circuit Network --
	if self.ent.get_circuit_network(defines.wire_type.red) ~= nil and self.ent.get_circuit_network(defines.wire_type.red).valid == true then
		self.RCNID = self.ent.get_circuit_network(defines.wire_type.red).network_id
	else
		self.RCNID = 0
	end
	
	-- Reinitialize the Tables and Variables --
	self.CNEntitiesTable = {}
	self.CNEnergyCubesTable = {}
	self.dataStorages = 0
	self.currentCircuitNetworkConsumption = _mfDCEnergyDrainPerUpdate
	
	-- Look for all connected Entities --
	self:getAllCNEntities()

	-- Itinerate the Entities Table --
	for ID, object in pairs(self.CNEntitiesTable) do
		-- Check the Entity --
		if object.ent ~= nil and object.ent.valid == true then
			-- Stop if another Data Center is Found --
			if object.ent.name == "DataCenter" or object.ent.name == "DataCenterMF" then
				if object.ent.unit_number ~= self.ent.unit_number then
					self:setActive(false)
					return
				end
			end
			-- Add the Data Storage --
			if object.ent.name == "DataStorage" then
				object.linkedDC = self
				self.dataStorages = self.dataStorages + 1
				self.currentCircuitNetworkConsumption = self.currentCircuitNetworkConsumption + _mfDSEnergyDrainPerUpdate
			end
			-- Add the Matter Serializer --
			if object.ent.name == "MatterSerializer" then
				object.linkedDC = self
				self.currentCircuitNetworkConsumption = self.currentCircuitNetworkConsumption + _mfMSEnergyDrainPerUpdate
			end
			-- Add the Matter Printer --
			if object.ent.name == "MatterPrinter" then
				object.linkedDC = self
				self.currentCircuitNetworkConsumption = self.currentCircuitNetworkConsumption + _mfMPEnergyDrainPerUpdate
			end
			-- Add the Energy Cube --
			if string.match(object.ent.name, "EnergyCube") then
				object.linkedDC = self
				self.CNEnergyCubesTable[object.ent.unit_number] = object
			end
		end
	end
	
	-- Update the Data Storages Numbers --
	self.invObj.dataStoragesCount = self.dataStorages
	self.invObj.maxCapacity = _mfBaseMaxItems + (_mfDataStorageCapacity * self.dataStorages)
	
	-- Create the Inventory Signal --
	self.ent.get_control_behavior().parameters = nil
	local i = 1
	for name, count in pairs(self.invObj.inventory) do
		-- Create and send the Signal --
		if game.item_prototypes[name] ~= nil then
			local signal = {signal={type="item", name=name},count=count}
			self.ent.get_control_behavior().set_signal(i, signal)
			-- Increament the Slot --
			i = i + 1
			-- Stop if there are to much Items --
			if i > 999 then break end
		end
	end
	-- Create the Ore Silos Signal --
	for name, count in pairs(self.invObj.CCInventory) do
		-- Create and send the Signal --
		if game.item_prototypes[name] ~= nil then
			local signal = {signal={type="item", name=name},count=count}
			self.ent.get_control_behavior().set_signal(i, signal)
			-- Increament the Slot --
			i = i + 1
			-- Stop if there are to much Items --
			if i > 999 then break end
		end
	end
	
	-- Remove Needed Energy --
	if self:removeEnergy(self.currentCircuitNetworkConsumption) > 0 then
		-- Set the Data Center to active --
		self:setActive(true)
	else
		-- Set the Data Center to inactive --
		self:setActive(false)
	end
end

-- Add all Entities connected to the circuit network to a table --
function DCMF:getAllCNEntities()
	-- Look at the Entities Table --
	for k, object in pairs(global.entsTable) do
		-- Check the Entity --
		if object.ent ~= nil and object.ent.valid == true then
			-- Check if the object is inside the same Circuit Network --
			if self:sameCN(object) then
				self.CNEntitiesTable[object.ent.unit_number] = object
			end
		end
	end
end

-- Return true if two the value object is in the same Circuit Network than this Object --
function DCMF:sameCN(object)
	if self.GCNID ~= nil and self.GCNID ~= 0 and self.GCNID == object.GCNID then
		return true
	end
	if self.RCNID ~= nil and self.RCNID ~= 0 and self.RCNID == object.RCNID then
		return true
	end
	return false
end

-- Tooltip Infos --
function DCMF:getTooltipInfos(GUI)
	-- Create the Total Energy label --
	local totalEnergy = GUI.add{type="label"}
	totalEnergy.style.font = "LabelFont"
	totalEnergy.caption = {"", {"gui-description.CNTotalEnergy"}, ": ", self.totalCircuitNetworkEnergy/1000000, " MJ"}
	totalEnergy.style.font_color = {92, 232, 54}
	
	-- Create the Consumption label --
	local consumption = GUI.add{type="label"}
	consumption.style.font = "LabelFont"
	consumption.caption = {"", {"gui-description.CNConsumption"}, ": ", self.currentCircuitNetworkConsumption/1000, " kW"}
	consumption.style.font_color = {231, 5, 5}
	
	-- Return Inventory Frame --
	self.invObj:getFrame(GUI)
end

-- Set Active --
function DCMF:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation if it doesn't exist --
		if self.animID == 0 then
			self.animID = rendering.draw_animation{animation="DataCenterA", target={self.ent.position.x,self.ent.position.y-1.22}, surface=self.ent.surface}
		end
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
	end
end

-- Remove Energy from Energy Cube Inside the Circuit Network and return the amount removed --
function DCMF:removeEnergy(energy)
	-- Count the total Energy --
	self.totalCircuitNetworkEnergy = 0
	for k, ec in pairs(self.CNEnergyCubesTable) do
		self.totalCircuitNetworkEnergy = self.totalCircuitNetworkEnergy + math.floor(ec.ent.energy)
	end
	-- Return if they are not enought Energy --
	if energy > self.totalCircuitNetworkEnergy then return 0 end
	-- Remove the Energy from Energy Cube --
	local energyLeft = energy
	local i = 0
	local energyToRemovePerCube = math.floor(energy/table_size(self.CNEnergyCubesTable))
	while energyLeft > 0 do
		for k, ec in pairs(self.CNEnergyCubesTable) do
			local removedEnergy = math.min(ec.ent.energy, energyToRemovePerCube)
			ec.ent.energy = ec.ent.energy - removedEnergy
			energyLeft = energyLeft - removedEnergy
		end
		i = i + 1
		if i > 100 then break end
	end
	return energy
end












