-- POWER DRAIN POLE OBJECT --

-- Create the Power Drain Pole object --
PDP = {
	ent = nil,
	player = "",
	MF = nil,
	updateTick = 60,
	lastUpdate = 0,
	laserRadius = _pdpEnergyRadius,
	laserDrain = _pdpEnergyDrain,
	laserNumber = _pdpEnergyLaser,
}

-- Constructor --
function PDP:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	setmetatable(t, mt)
	mt.__index = PDP
	return t
end

-- Reconstructor --
function PDP:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = PDP
	setmetatable(object, mt)
end

-- Destructor --
function PDP:remove()
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function PDP:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update the PDP modules --
function PDP:updateModules()
	-- Create the bases variables --
	local powerMD = 0
	local efficiencyMD = 0
	local focusMD = 0
	-- Look for modules inside the Module Inventory of the Power Drain Pole --
	for name, count in pairs(self.ent.get_inventory(defines.inventory.beacon_modules).get_contents()) do
		if name == "EnergyPowerModule" then powerMD = powerMD + count end
		if name == "EnergyEfficiencyModule" then efficiencyMD = efficiencyMD + count end
		if name == "EnergyFocusModule" then focusMD = focusMD + count end
	end
	self.laserRadius = _pdpEnergyRadius + powerMD
	self.laserDrain = _pdpEnergyDrain * (efficiencyMD + 1)
	self.laserNumber = _pdpEnergyLaser + focusMD
end

-- Update the PDP --
function PDP:update(event)
	-- Update lastUpdate variable --
	self.lastUpdate = event.tick
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end
	-- Update Modules --
	self:updateModules()
	-- Look for all Entities around --
	local entities = self.ent.surface.find_entities_filtered{position=self.ent.position, radius=self.laserRadius}
	-- Number of lasers variable --
	i = 1
	-- Itinerate all Entities --
	for k, entity in pairs(entities) do
		-- Stop if the number of lasers is exceeded --
		if i > self.laserNumber then break end
		-- Exclude Character, Power Drain Pole and Entities with 0 energy --
		if entity.type ~= "character" and entity.name ~= "PowerDrainPole" and entity.name ~= "OreCleaner" and entity.name ~= "FluidExtractor" and entity.energy > 0 then
			-- Missing Internal Energy or Structure Energy --
			local energyDrain = math.min(self.MF.maxInternalEnergy - self.MF.internalEnergy, entity.energy)
			-- EnergyDrain or LaserDrain Caparity --
			local drainedEnergy = math.min(self.laserDrain, energyDrain)
			-- Test if some Energy was drained --
			if drainedEnergy > 0 then
				-- Add the Energy to the Mobile Factory Batteries --
				self.MF.internalEnergy = self.MF.internalEnergy + drainedEnergy
				-- Remove the Energy from the Structure --
				entity.energy = entity.energy - drainedEnergy
				-- Create the Beam --
				self.ent.surface.create_entity{name="BlueBeam", duration=60, position=self.ent.position, target_position=entity.position, source_position={self.ent.position.x,self.ent.position.y-4}}
				-- One less Beam to the Beam capacity --
				i = i + 1
			end
		end
	end
end