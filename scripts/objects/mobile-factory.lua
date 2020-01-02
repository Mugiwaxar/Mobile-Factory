-- MOBILE FACTORY OBJECT --
require("utils/functions")

-- Create the Mobile Factory Object --
MF = {
	ent = nil,
	updateTick = 1,
	lastUpdate = 0,
	lastSurface = nil,
	lastPosX = 0,
	lastPosY = 0,
	fS = nil,
	ccS = nil,
	fChest = nil,
	II = nil,
	dataCenter = nil,
	internalEnergy = _mfInternalEnergy,
	maxInternalEnergy = _mfInternalEnergyMax,
	jumpTimer = _mfBaseJumpTimer,
	baseJumpTimer = _mfBaseJumpTimer,
	tpEnabled = true,
	laserRadiusMultiplier = 0,
	laserDrainMultiplier = 0,
	laserNumberMultiplier = 0,
	energyLaserActivated = false,
	fluidLaserActivated = false,
	itemLaserActivated = false,
	internalEnergyDistributionActivated = false
}

-- Constructor --
function MF:new()
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = MF
	return t
end

-- Contructor for a placed Mobile Factory --
function MF:contruct(object)
	if object == nil then return end
	if self.fS == nil then createMFSurface() end
	if self.ccS == nil then createControlRoom() end
	self.ent = object
	self.lastSurface = object.surface
	self.lastPosX = object.position.x
	self.lastPosY = object.position.y
end

-- Reconstructor --
function MF:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = MF
	setmetatable(object, mt)
	INV:rebuild(global.MF.II)
end

-- Destructor --
function MF:remove()
	self.ent = nil
	self.internalEnergy = 0
	self.jumpTimer = _mfBaseJumpTimer
end

-- Is valid --
function MF:valid()
	return true
end

-- Tooltip Infos --
function MF:getTooltipInfos(GUI)
end

-- Update the Mobile Factory --
function MF:update(event)
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Get the current tick --
	local tick = event.tick
	--Update all lasers --
	if tick%_eventTick60 == 0 then self:updateLasers() end
	-- Update the Fuel --
	if tick%_eventTick27 == 0 then self:updateFuel() end
	-- Update the Shield --
	self:updateShield(event)
	-- Send Quatron Charge --
	self:SendQuatronToOC(event)
	self:SendQuatronToFE(event)
end

-- Synchronize Factory Chest --
function MF:syncFChest()
	if self.fChest ~= nil and self.fChest.valid == true then
		synchronizeInventory(self.ent.get_inventory(defines.inventory.car_trunk), self.fChest.get_inventory(defines.inventory.chest))
	end
end

-- Return the Lasers radius --
function MF:getLaserRadius()
	return _mfBaseLaserRadius + (self.laserRadiusMultiplier * 2)
end

-- Return the Energy Lasers Drain --
function MF:getLaserEnergyDrain()
	return _mfEnergyDrain * (self.laserDrainMultiplier + 1)
end

-- Return the Fluid Lasers Drain --
function MF:getLaserFluidDrain()
	return _mfFluidDrain * (self.laserDrainMultiplier + 1)
end

-- Return the Logistic Lasers Drain --
function MF:getLaserItemDrain()
	return _mfItemsDrain * (self.laserDrainMultiplier + 1)
end

-- Return the number of Lasers --
function MF:getLaserNumber()
	return _mfBaseLaserNumber + self.laserNumberMultiplier
end

-- Return the Shield --
function MF:shield()
	if self.ent == nil or self.ent.valid == false or self.ent.grid == nil then return 0 end
	return self.ent.grid.shield
end

-- Return the max Shield --
function MF:maxShield()
	if self.ent == nil or self.ent.valid == false or self.ent.grid == nil then return 0 end
	return self.ent.grid.max_shield
end

-- Search energy sources near Mobile Factory and update the burning fuel --
function MF:updateLasers()
	-- Check the Mobile Factory --
	if global.MF == nil or global.MF.ent == nil then return end
	if global.MF.ent.valid == false then return end
	-- Search Energy sources"
	if technologyUnlocked("EnergyDrain1") or technologyUnlocked("FluidDrain1") then
		-- Get Bounding Box --
		local mfB = self.ent.bounding_box
		-- Get all entities around --
		local entities = self.ent.surface.find_entities_filtered{position=self.ent.position, radius=self:getLaserRadius()}
		i = 1
		-- Look each entity --
		for k, entity in pairs(entities) do
			-- Stop if they are to much lasers --
			if i > self:getLaserNumber() then break end
			-- Energy Laser --
			dprint(entity.type)
			-- Exclude Character, Power Drain Pole and Entities with 0 energy --
			if entity.type ~= "character" and entity.name ~= "PowerDrainPole" and entity.name ~= "OreCleaner" and entity.name ~= "FluidExtractor" and entity.energy > 0 then
				-- Missing Internal Energy or Structure Energy --
				local energyDrain = math.min(self.maxInternalEnergy - self.internalEnergy, entity.energy)
				-- EnergyDrain or LaserDrain Caparity --
				local drainedEnergy = math.min(self:getLaserEnergyDrain(), energyDrain)
				-- Test if some Energy was drained --
				if drainedEnergy > 0 then
					-- Add the Energy to the Mobile Factory Batteries --
					global.MF.internalEnergy = global.MF.internalEnergy + drainedEnergy
					-- Remove the Energy from the Structure --
					entity.energy = entity.energy - drainedEnergy
					-- Create the Beam --
					self.ent.surface.create_entity{name="BlueBeam", duration=60, position=self.ent.position, target_position=entity.position, source_position={self.ent.position.x,self.ent.position.y}}
					-- One less Beam to the Beam capacity --
					i = i + 1
				end
			end
			-- Fluid Laser --
			if self.fluidLaserActivated == true and entity.type == "storage-tank" and global.IDModule > 0 then
				if self.ccS ~= nil then
					-- Get the Internal Tank --
					local name
					local ccTank
					if global.tankTable ~= nil and global.tankTable[global.IDModule] ~= nil then
						filter = global.tankTable[global.IDModule].filter
						ccTank = global.tankTable[global.IDModule].ent
					end
					if filter ~= nil and ccTank ~= nil then
						-- Get the focused Tank --
						local name
						local amount
						pTank = entity
						for k, i in pairs(pTank.get_fluid_contents()) do
							name = k
							amount = i
						end
						if name ~= nil and name == filter and self.internalEnergy > _lfpFluidConsomption * math.min(amount, self:getLaserFluidDrain()) then
							-- Add fluid to the Internal Tank --
							local amountRm = ccTank.insert_fluid({name=name, amount=math.min(amount, self:getLaserFluidDrain())})
							-- Remove fluid from the focused Tank --
							pTank.remove_fluid{name=name, amount=amountRm}
							if amountRm > 0 then
								-- Create the Laser --
								self.ent.surface.create_entity{name="PurpleBeam", duration=60, position=self.ent.position, target=pTank.position, source=self.ent.position}
								-- Drain Energy --
								self.internalEnergy = self.internalEnergy - (_mfFluidConsomption*amountRm)
								-- One less Beam to the Beam capacity --
								i = i + 1
							end
						end
					end
				end
			end
			-- Logistic Laser --
			if self.itemLaserActivated == true and self.internalEnergy > _mfBaseItemEnergyConsumption * self:getLaserItemDrain() and (entity.type == "container" or entity.type == "logistic-container") then
				-- Get Chest Inventory --
				local inv = entity.get_inventory(defines.inventory.chest)
				-- Get the Internal Inventory --
				local dataInv = self.II
				if inv ~= nil and inv.valid == true then
					-- Create the Laser Capacity variable --
					local capItems = self:getLaserItemDrain()
					-- Get all Items --
					local invItems = inv.get_contents()
					-- Retrieve Items from the Inventory --
					for iName, iCount in pairs(invItems) do
						local added = dataInv:addItem(iName, math.min(iCount, capItems))
						-- Check if Items was added --
						if added > 0 then
							-- Remove Items from the Chest --
							local removedItems = inv.remove({name=iName, count=added})
							-- Recalcule the capItems --
							capItems = capItems - added
							-- Create the laser and remove energy --
							if added > 0 then
								self.ent.surface.create_entity{name="GreenBeam", duration=60, position=self.ent.position, target=entity.position, source=self.ent.position}
								self.internalEnergy = self.internalEnergy - _mfBaseItemEnergyConsumption * removedItems
								-- One less Beam to the Beam capacity --
								i = i + 1
							end
							-- Test if capItems is empty --
							if capItems <= 0 then
								-- Stop --
								break
							end
						end
					end
				end
			end
		end
	end
end

-- Update the Fuel --
function MF:updateFuel()
	-- Check if the Mobile Factory is valid --
	if self.ent == nil or self.ent.valid == false then return end
	-- Recharge the tank fuel --
	if self.internalEnergy > 0 and self.ent.get_inventory(defines.inventory.fuel).get_item_count() < 2 then
		if self.ent.burner.remaining_burning_fuel == 0 and self.ent.get_inventory(defines.inventory.fuel).is_empty() == true then
			-- Insert coal in case of the Tank is off --
			self.ent.get_inventory(defines.inventory.fuel).insert({name="coal", count=1})
		elseif self.ent.burner.remaining_burning_fuel > 0 then
			-- Calcule the missing Fuel amount --
			local missingFuelValue = math.floor((_mfMaxFuelValue - self.ent.burner.remaining_burning_fuel) /_mfFuelMultiplicator)
			if math.floor(missingFuelValue/_mfFuelMultiplicator) < self.internalEnergy then
				-- Add the missing Fuel to the Tank --
				self.ent.burner.remaining_burning_fuel = _mfMaxFuelValue
				-- Drain energy --
				self.internalEnergy = math.floor(self.internalEnergy - missingFuelValue/_mfFuelMultiplicator)
			end
		end
	end
end

-- Update the Shield --
function MF:updateShield(event)
	-- Get the current tick --
	local tick = event.tick
	-- Check if the Mobile Factory is valid --
	if self.ent == nil or self.ent.valid == false then return end
	-- Create the visual --
	if self:shield() > 0 then
		-- Calcule the shield tint --
		local tint = self:shield() / self:maxShield()
		-- Calcule the shield size --
		local mfB = global.MF.ent.bounding_box
		local size = (mfB.right_bottom.y - mfB.left_top.y) / 12
		rendering.draw_animation{animation="mfShield", target={self.ent.position.x-0.25, self.ent.position.y-0.3}, tint={1,tint,tint}, time_to_live=2, x_scale=size, y_scale=size, surface=self.ent.surface}
	end
	-- Charge the Shield --
	local chargeSpeed = 10
	if tick%60 == 0 and self.internalEnergy > 0 then
		-- Get the Shield --
		for k, equipment in pairs(self.ent.grid.equipment) do
			-- Check if this is a Shield --
			if equipment.name == "mfShieldEquipment" then
				local missingCharge = equipment.max_shield - equipment.shield
				local chargeAmount = math.min(missingCharge, chargeSpeed)
				-- Check if the Shield can be charged --
				if chargeAmount > 0 and chargeAmount*_mfShieldComsuption <= self.internalEnergy then
					 -- Charge the Shield --
					 equipment.shield = equipment.shield + chargeAmount
					 -- Remove the energy --
					 self.internalEnergy = self.internalEnergy - chargeAmount*_mfShieldComsuption
				end
			end
		end
	end
	
	-- if tick%60 == 0 and self.internalEnergy*_mfShieldChargeRate > _mfShieldComsuption and self.shield < self.maxShield then
		-- Charge rate or Shield charge missing --
		-- local charge = math.min(self.maxShield - self.shield, _mfShieldChargeRate)
		-- Add the charge --
		-- self.shield = self.shield + charge
		-- Remove the energy --
		-- self.internalEnergy = self.internalEnergy - _mfShieldComsuption*charge
	-- end
end


-- Send Quatron Charge to the Ore Cleaner --
function MF:SendQuatronToOC(event)
	-- Test if the Ore Cleaner is valid --
	if global.oreCleaner == nil then return end
	if global.oreCleaner.ent == nil or global.oreCleaner.ent.valid == false then return end
	-- Send Charge only every 10 ticks --
	if event.tick%10 ~= 0 then return end
	-- Test if there are space inside the Ore Cleaner for Quatron Charge --
	if global.oreCleaner.charge > _mfOreCleanerMaxCharge - 100 then return end
	-- Get the Best Quatron Change --
	local charge = global.MF.II:getBestQuatron()
	if charge > 0 then
		-- Add the Charge --
		global.oreCleaner:addQuatron(charge)
		-- Create the Laser --
		self.ent.surface.create_entity{name="GreenBeam", duration=30, position=self.ent.position, target={global.oreCleaner.ent.position.x, global.oreCleaner.ent.position.y - 2}, source=self.ent}
	end
end

-- Send Quatron Charge to all Fluid Extractors --
function MF:SendQuatronToFE(event)
-- Send Charge only every 15 ticks --
	if event.tick%15 ~= 0 then return end
	for k, fe in pairs(global.fluidExtractorTable) do
		-- Check if the Fluid Extractor is valid --
		if fe:valid() == true then
			-- Test if there are space inside the Fluid Extractor for Quatron Charge --
			if fe.charge > _mfFEMaxCharge - 100 then return end
			-- Get the Best Quatron Change --
			local charge = global.MF.II:getBestQuatron()
			if charge > 0 then
				-- Add the Charge --
				fe:addQuatron(charge)
				-- Create the Laser --
				fe.ent.surface.create_entity{name="GreenBeam", duration=30, position=self.ent.position, target={fe.ent.position.x, fe.ent.position.y - 2}, source=self.ent}
			end
		end
	end
end







