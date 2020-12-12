-- Create the Mobile Factory Object --
MF = {
	ent = nil,
	playerIndex = nil,
	player = "",
	name = "";
	updateTick = 1,
	lastUpdate = 0,
	lastSurface = nil,
	lastPosX = 0,
	lastPosY = 0,
	fS = nil,
	ccS = nil,
	II = nil,
	dataNetwork = nil,
	netwokController = nil,
	internalEnergyObj = nil,
	internalQuatronObj = nil,
	jumpDriveObj = nil,
	tpEnabled = true,
	onTP = false,
	tpCurrentTick = 0,
	tpLocation = nil,
	locked = true,
	laserRadiusMultiplier = 0,
	laserDrainMultiplier = 0,
	laserNumberMultiplier = 0,
	energyLaserActivated = false,
	quatronLaserActivated = false,
	fluidLaserActivated = false,
	itemLaserActivated = false,
	selectedInventory = nil,
	selectedEnergyLaserMode = "input", -- input, output
	selectedQuatronLaserMode = "input", -- input, output
	selectedFluidLaserMode = "input", -- input, output
	ELEntities = nil,
	QLEntities = nil,
	FLEntities = nil,
	ILEntities = nil,
	syncAreaID = 0,
	syncAreaInsideID = 0,
	syncAreaEnabled = true,
	syncAreaScanned = false,
	clonedResourcesTable = nil, -- {original, cloned}
	varTable = nil
}

-- Constructor --
function MF:new(args)
	local t = {}
	local player = nil
	if args then
		if args.refreshObj then t = args.refreshObj end
		if args.player then player = args.player end
	end
	local mt = {}
	setmetatable(t, mt)
	mt.__index = MF
	t.clonedResourcesTable = t.clonedResourcesTable or {}
	t.varTable = t.varTable or {}
	t.varTable.tech = t.varTable.tech or {}
	t.varTable.allowedPlayers = t.varTable.allowedPlayers or {}

	if player then
		global.MFTable[player.name] = t
		t.playerIndex = player.index
		t.player = player.name
		t.name = player.name .. "'s Mobile Factory"
	end

	t.II = t.II or INV:new("Internal Inventory")
	t.dataNetwork = t.dataNetwork or DN:new(t)
	t.II.MF = t
	t.II.dataNetwork = t.dataNetwork
	t.dataNetwork.MF = t
	t.dataNetwork.invObj = t.II

	t.internalEnergyObj = t.internalEnergyObj or IEC:new(t)
	t.internalQuatronObj = t.internalQuatronObj or IQC:new(t)
	t.jumpDriveObj = t.jumpDriveObj or JD:new(t)

	t.MF = t
	if not args or not args.refreshObj then
		UpSys.addObj(t)
	end
	return t
end

function MF:refresh()
  MF:new({refreshObj = self})
end

-- Constructor for a placed Mobile Factory --
function MF:construct(object)
	if object == nil then return end
	self.ent = object
	if self.fS == nil or self.fS.valid == false then self.fS = nil createMFSurface(self) end
	if self.ccS == nil or self.ccS.valid == false then self.ccS = nil createControlRoom(self) end
	global.entsTable[object.unit_number] = self
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
	IEC:rebuild(object.internalEnergyObj)
	IQC:rebuild(object.internalQuatronObj)
	JD:rebuild(object.jumpDriveObj)
	DN:rebuild(object.dataNetwork)
	NC:rebuild(object.networkController)
	INV:rebuild(object.II)
end

-- Destructor --
function MF:remove()
	self.ent = nil
	-- self.internalEnergyObj:removeEnergy(self.internalEnergyObj:energy())
	-- self.internalQuatronObj:removeQuatron(self.internalQuatronObj:quatron())
	-- self.jumpDriveObj.charge = 0
	self:removeSyncArea()
end

-- Is valid --
function MF:valid()
	return true
end

-- Tooltip Infos --
function MF:getTooltipInfos(GUITable, mainFrame, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.MobileFactory"}

		-- Set the Main Frame Height --
		-- mainFrame.style.height = 200

		-- Create the Network Inventory Frame --
		local inventoryFrame = GAPI.addFrame(GUITable, "InventoryFrame", mainFrame, "vertical", true)
		inventoryFrame.style = "MFFrame1"
		inventoryFrame.style.vertically_stretchable = true
		inventoryFrame.style.left_padding = 3
		inventoryFrame.style.right_padding = 3
		inventoryFrame.style.left_margin = 3
		inventoryFrame.style.right_margin = 3

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", inventoryFrame, {"gui-description.Inventory"})

		-- Create the Inventory Flow and Button --
		local inventoryFlow = GAPI.addFlow(GUITable, "", inventoryFrame, "horizontal")
		inventoryFlow.style.horizontal_align = "center"
		GAPI.addSimpleButton(GUITable, "M.F.OpenInvButton", inventoryFlow, {"gui-description.OpenInventory"}, "", false, {ID=self.player})

		-- Create the Parameters Frame --
		local laserFrame = GAPI.addFrame(GUITable, "LaserFrame", mainFrame, "vertical", true)
		laserFrame.style = "MFFrame1"
		laserFrame.style.vertically_stretchable = true
		laserFrame.style.left_padding = 3
		laserFrame.style.right_padding = 3
		laserFrame.style.right_margin = 3

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", laserFrame, {"gui-description.MFEnergyLaser"})

		-- Energy Lasers Settings --
		if technologyUnlocked("EnergyDrain1", getForce(self.player)) then
			GAPI.addLabel(GUITable, "", laserFrame, {"gui-description.MFEnergyLaser"}, nil, "", false, nil, _mfLabelType.yellowTitle)
			local state = "left"
			if self.selectedEnergyLaserMode == "output" then state = "right" end
			GAPI.addSwitch(GUITable, "M.F.EnergyLasersSwitch", laserFrame, {"gui-description.Drain"}, {"gui-description.Send"}, {"gui-description.MFDrainTT"}, {"gui-description.MFSendTT"}, state, false, {ID=self.playerIndex})
		end

		-- Quatron Lasers Settings --
		if technologyUnlocked("EnergyDrain1", getForce(self.player)) then
			GAPI.addLabel(GUITable, "", laserFrame, {"gui-description.MFQuatronLaser"}, nil, "", false, nil, _mfLabelType.yellowTitle)
			local state = "left"
			if self.selectedQuatronLaserMode == "output" then state = "right" end
			GAPI.addSwitch(GUITable, "M.F.QuatronLasersSwitch", laserFrame, {"gui-description.Drain"}, {"gui-description.Send"}, {"gui-description.MFDrainTT"}, {"gui-description.MFSendTT"}, state, false, {ID=self.playerIndex})
		end

		-- Fluid Lasers Settings --
		if technologyUnlocked("FluidDrain1", getForce(self.player)) then
			-- Send/Drain --
			GAPI.addLabel(GUITable, "", laserFrame, {"gui-description.MFFluidLaser"}, nil, "", false, nil, _mfLabelType.yellowTitle)
			local state = "left"
			if self.selectedFluidLaserMode == "output" then state = "right" end
			GAPI.addSwitch(GUITable, "M.F.FluidLasersSwitch", laserFrame, {"gui-description.Drain"}, {"gui-description.Send"}, {"gui-description.MFDrainTT"}, {"gui-description.MFSendTT"}, state, false, {ID=self.playerIndex})
			-- Target --
			local invs = {{"", {"gui-description.None"}}}
			local selectedIndex = 1
			local i = 1
			for k, deepTank in pairs(self.dataNetwork.DTKTable) do
				if deepTank ~= nil and deepTank.ent ~= nil then
					i = i + 1
					local itemText = {"", " (", {"gui-description.Empty"}, " - ", deepTank.player, ")"}
					if deepTank.filter ~= nil then
						itemText = {"", " (", game.fluid_prototypes[deepTank.filter].localised_name, " - ", deepTank.player, ")"}
					elseif deepTank.inventoryFluid ~= nil then
						itemText = {"", " (", game.fluid_prototypes[deepTank.inventoryFluid].localised_name, " - ", deepTank.player, ")"}
					end
					invs[k+1] = {"", {"gui-description.DT"}, " ", tostring(deepTank.ID), itemText}
					if self.selectedInv and self.selectedInv.entID == deepTank.entID then
						selectedIndex = i
					end
				end
			end
			if selectedIndex ~= nil and selectedIndex > table_size(invs) then selectedIndex = nil end
			GAPI.addDropDown(GUITable, "M.F.FluidLasersTargetDD", laserFrame, invs, selectedIndex, false, {"gui-description.MFFluidLasersTargetTT"}, {ID=self.playerIndex})
		end

	end

end

-- Change the Fluid Laser Targeted Inventory --
function MF:fluidLaserTarget(ID)
	-- Check the ID --
	if ID == nil then
		self.selectedInv = nil
		return
	end
	-- Select the Inventory --
	self.selectedInv = nil
	for k, deepTank in pairs(self.dataNetwork.DTKTable) do
		if valid(deepTank) then
			if ID == deepTank.ID then
				self.selectedInv = deepTank
			end
		end
	end
end

-- Update the Mobile Factory --
function MF:update(event)
	if self.fS ~= nil and self.fS.valid == false then
		self.fS = nil
	end
	if self.ccS ~= nil and self.ccS.valid == false then
		self.ccS = nil
	end

	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Get the current tick --
	local tick = event.tick

	-- Update the Internal Inventory capacity --
	if tick%_eventTick80 == 0 then self.II:rescan() end
	-- Check if the Mobile Factory has to TP --
	if self.onTP and game.tick - self.tpCurrentTick > 30 then self:TPMobileFactoryPart2() end
	-- Check the Mobile Factory --
	if self.ent == nil or self.ent.valid == false then return end

	--Update all lasers --
	if tick%_eventTick60 == 0 then self:updateLasers() end
	-- Update the Fuel --
	if tick%_eventTick27 == 0 then self:updateFuel() end
	-- Scan Entities Around --
	if tick%_eventTick90 == 0 then self:scanEnt() end
	-- Update the Shield --
	self:updateShield(event)
	-- Update Pollution --
	if event.tick%_eventTick1200 == 0 then self:updatePollution() end
	-- Update Teleportation Box --
	if event.tick%_eventTick5 == 0 then self:factoryTeleportBox() end
	-- Read Modules inside the Equipment Grid --
	if event.tick%_eventTick125 == 0 then self:scanModules() end
	-- Update the Sync Area --
	if tick%_eventTick30 == 0 then self:updateSyncArea() end
end

-- Return the Lasers radius --
function MF:getLaserRadius()
	return _mfBaseLaserRadius + (self.laserRadiusMultiplier * 2)
end

-- Return the number of Lasers --
function MF:getLaserNumber()
	return _mfBaseLaserNumber + self.laserNumberMultiplier
end

function MF:getLaserPower()
	return self.laserDrainMultiplier + 1
end

-- Return the Energy Lasers Drain --
function MF:getLaserEnergyDrain()
	return _mfEnergyDrain * (self.laserDrainMultiplier + 1)
end

-- Return the Quatron Lasers Drain --
function MF:getLaserQuatronDrain()
	return _mfQuatronDrain * (self.laserDrainMultiplier + 1)
end

-- Return the Fluid Lasers Drain --
function MF:getLaserFluidDrain()
	return _mfFluidDrain * (self.laserDrainMultiplier + 1)
end

-- Return the Logistic Lasers Drain --
function MF:getLaserItemDrain()
	return _mfItemsDrain * (self.laserDrainMultiplier + 1)
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

-- Scan all Entities around the Mobile Factory --
function MF:scanEnt()
	local selfForce = getForce(self.player)
	local selfSurface = self.ent.surface
	local selfRadius = self:getLaserRadius()
	local selfPosition = self.ent.position

	-- Look for Energy Laser targets
	if self.energyLaserActivated and technologyUnlocked("EnergyDrain1", selfForce) then
		self.ELEntities = selfSurface.find_entities_filtered{position=selfPosition, force=selfForce, radius=selfRadius, name=_mfEnergyShare}
	else
		self.ELEntities = nil
	end

	-- Look for Quatron Laser targets
	if self.quatronLaserActivated and technologyUnlocked("EnergyDrain1", selfForce) and technologyUnlocked("QuatronLogistic", selfForce) then
		self.QLEntities = selfSurface.find_entities_filtered{position=selfPosition, force=selfForce, radius=selfRadius, name=_mfQuatronShare}
	else
		self.QLEntities = nil
	end

	-- Look for Quatron Laser targets
	if self.fluidLaserActivated and technologyUnlocked("FluidDrain1", selfForce) then
		self.FLEntities = selfSurface.find_entities_filtered{position=selfPosition, force=selfForce, radius=selfRadius, type="storage-tank"}
	else
		self.FLEntities = nil
	end

	-- Look for Logistic Laser targets
	if self.itemLaserActivated and technologyUnlocked("TechItemDrain", selfForce) then
		self.ILEntities = selfSurface.find_entities_filtered{position=selfPosition, force=selfForce, radius=selfRadius, type={"container", "logistic-container"}}
	else
		self.ILEntities = nil
	end
end

-- Update lasers of the Mobile Factory --
function MF:updateLasers()
	-- Create all Lasers --
	local laserUsed = 0
	local laserNumber = self:getLaserNumber()

	if self.energyLaserActivated then
		for k, entity in pairs(self.ELEntities or {}) do
			if entity ~= nil and entity.valid == true then
				if self:updateEnergyLaser(entity) == true then
					laserUsed = laserUsed + 1
					if laserUsed >= laserNumber then return end
				end
			end
		end
	end

	if self.quatronLaserActivated then
		for k, entity in pairs(self.QLEntities or {}) do
			if entity ~= nil and entity.valid == true then
				if self:updateQuatronLaser(entity) == true then
					laserUsed = laserUsed + 1
					if laserUsed >= laserNumber then return end
				end
			end
		end
	end

	if self.fluidLaserActivated then
		for k, entity in pairs(self.FLEntities or {}) do
			if entity ~= nil and entity.valid == true then
				if self:updateFluidLaser(entity) == true then
					laserUsed = laserUsed + 1
					if laserUsed >= laserNumber then return end
				end
			end
		end
	end

	if self.itemLaserActivated then
		for k, entity in pairs(self.ILEntities or {}) do
			if entity ~= nil and entity.valid == true then
				if self:updateLogisticLaser(entity) == true then
					laserUsed = laserUsed + 1
					if laserUsed >= laserNumber then return end
				end
			end
		end
	end
end

function MF:updateQuatronLaser(entity)
	local obj = global.entsTable[entity.unit_number]
	----------------------- Drain Quatron -------------------------
	if self.selectedQuatronLaserMode == "input" and self.internalQuatronObj.ent ~= nil and self.internalQuatronObj.ent.valid == true and  obj.quatronCharge > 0 then
		-- Missing Internal Quatron or Structure Quatron or LaserDrain Caparity --
		local drainedQuatron = math.min(self.internalQuatronObj.quatronMax - self.internalQuatronObj.quatronCharge, obj.quatronCharge, self:getLaserQuatronDrain())
		-- Test if some Quatron was drained --
		if drainedQuatron > 0 then
			-- Add the Quatron to the Mobile Factory Batteries --
			self.internalQuatronObj:addQuatron(drainedQuatron, obj.quatronLevel)
			-- Remove the Quatron from the Structure --
			obj.quatronCharge = obj.quatronCharge - drainedQuatron
			-- Create the Beam --
			self.ent.surface.create_entity{name="PurpleQuatronBeam", duration=60, position=self.ent.position, target_position=entity.position, source_position={self.ent.position.x,self.ent.position.y}}
			-- One less Beam to the Beam capacity --
			return true
		end
	----------------------- Send Quatron -------------------------
	elseif self.selectedQuatronLaserMode == "output" and self.internalQuatronObj.ent ~= nil and self.internalQuatronObj.ent.valid == true and  obj.quatronCharge < obj.quatronMax then
			-- Structure missing Quatron or Laser Power or Mobile Factory Quatron --
		local quatronSend = math.min(obj.quatronMax - obj.quatronCharge, self:getLaserQuatronDrain(), self.internalQuatronObj.quatronCharge)
		-- Check if Quatron can be send --
		if quatronSend > 0 then
			-- Add the Quatron to the Entity --
			obj:addQuatron(quatronSend, self.internalQuatronObj.quatronLevel)
			-- Remove the Quatron from the Mobile Factory --
			self.internalQuatronObj.quatronCharge = self.internalQuatronObj.quatronCharge - quatronSend
			-- Create the Beam --
			self.ent.surface.create_entity{name="PurpleQuatronBeam", duration=60, position=self.ent.position, target_position=entity.position, source_position={self.ent.position.x,self.ent.position.y}}
			-- One less Beam to the Beam capacity --
			return true
		end
	end
end

-------------------------------------------- Energy Laser --------------------------------------------
function MF:updateEnergyLaser(entity)
	----------------------- Drain Energy -------------------------
	if self.selectedEnergyLaserMode == "input" and self.internalEnergyObj.ent ~= nil and self.internalEnergyObj.ent.valid == true and entity.energy > 0 then
		-- Missing Internal Energy or Structure Energy or LaserDrain Caparity --
		local drainedEnergy = math.min(self.internalEnergyObj:maxEnergy() - self.internalEnergyObj:energy(), entity.energy, self:getLaserEnergyDrain())
		-- Test if some Energy was drained --
		if drainedEnergy > 0 then
			-- Add the Energy to the Mobile Factory Batteries --
			self.internalEnergyObj:addEnergy(drainedEnergy)
			-- Remove the Energy from the Structure --
			entity.energy = entity.energy - drainedEnergy
			-- Create the Beam --
			self.ent.surface.create_entity{name="BlueBeam", duration=60, position=self.ent.position, target_position=entity.position, source_position={self.ent.position.x,self.ent.position.y}}
			-- One less Beam to the Beam capacity --
			return true
		end
	----------------------- Send Energy -------------------------
	elseif self.selectedEnergyLaserMode == "output" and self.internalEnergyObj.ent ~= nil and self.internalEnergyObj.ent.valid == true and  entity.energy < entity.electric_buffer_size then
		-- Structure missing Energy or Laser Power or Mobile Factory Energy --
		local energySend = math.min(entity.electric_buffer_size - entity.energy, self:getLaserEnergyDrain(), self.internalEnergyObj:energy())
		-- Check if Energy can be send --
		if energySend > 0 then
			-- Add the Energy to the Entity --
			entity.energy = entity.energy + energySend
			-- Remove the Energy from the Mobile Factory --
			self.internalEnergyObj:removeEnergy(energySend)
			-- Create the Beam --
			self.ent.surface.create_entity{name="BlueBeam", duration=60, position=self.ent.position, target_position=entity.position, source_position={self.ent.position.x,self.ent.position.y}}
			-- One less Beam to the Beam capacity --
			return true
		end
	end
end

-------------------------------------------- Fluid Laser --------------------------------------------
function MF:updateFluidLaser(entity)
	-- Check if a laser should be created --
	if self.selectedInv == nil then return false end

	-- Get both Tanks and their characteristics --
	local localTank = entity
	local distantTank = self.selectedInv
	local localFluid = nil
	
	-- Get the Fluid inside the local Tank --
	for i=1,#localTank.fluidbox do
		if localTank.fluidbox[i] then
			localFluid = localTank.fluidbox[i]
		end
	end
	
	-- Input mode --
	if self.selectedFluidLaserMode == "input" then
		if localFluid == nil then return end
		-- Check the local and distant Tank --
		if distantTank:canAccept(localFluid) == false then return end
		-- Send the Fluid --
		local amountAdded = distantTank:addFluid(localFluid)
		-- Remove the local Fluid --
		localTank.remove_fluid({name=localFluid.name, amount=amountAdded, minimum_temperature = -300, maximum_temperature = 1e7})
		if amountAdded > 0 then
			-- Create the Laser --
			self.ent.surface.create_entity{name="PurpleBeam", duration=60, position=self.ent.position, target=localTank.position, source=self.ent.position}
			-- Drain Energy --
			self.internalEnergyObj:removeEnergy(_mfFluidConsomption*amountAdded)
			-- One less Beam to the Beam capacity --
			return true
		end
	elseif self.selectedFluidLaserMode == "output" then
		-- Check the local and distant Tank --
		if localFluid and localFluid.name ~= distantTank.inventoryFluid then return end
		if distantTank.inventoryFluid == nil or distantTank.inventoryCount == 0 then return end
		-- Get the Fluid --
		local amountAdded = localTank.insert_fluid({name=distantTank.inventoryFluid, amount=distantTank.inventoryCount, temperature = distantTank.inventoryTemperature})
		-- Remove the distant Fluid --
		distantTank:getFluid({name = distantTank.inventoryFluid, amount = amountAdded})
		if amountAdded > 0 then
			-- Create the Laser --
			self.ent.surface.create_entity{name="PurpleBeam", duration=60, position=self.ent.position, target=localTank.position, source=self.ent.position}
			-- Drain Energy --
			self.internalEnergyObj:removeEnergy(_mfFluidConsomption*amountAdded)
			-- One less Beam to the Beam capacity --
			return true
		end
	end
end

-------------------------------------------- Logistic Laser --------------------------------------------
function MF:updateLogisticLaser(entity)
	-- Create the Laser --
	if self.internalEnergyObj:energy() > _mfBaseItemEnergyConsumption * self:getLaserItemDrain() then
		-- Get Chest Inventory --
		local inv = entity.get_inventory(defines.inventory.chest)
		-- Get the Internal Inventory --
		local dataInv = self.II
		if inv ~= nil and inv.valid == true then
			-- Create the Laser Capacity variable --
			local capItems = math.min(self:getLaserItemDrain(), self.internalEnergyObj:energy() * _mfBaseItemEnergyConsumption)
			local canMove = capItems
			-- Retrieve Items from the Inventory --
			for i=1, #inv do
				local stack = inv[i]
				-- Move only items with no uniq data(excluding items with tags, inventory, blueprints, etc)
				if stack.valid_for_read == true and stack.item_number == nil then
					local moved = dataInv:addItem(stack.name, math.min(stack.count, canMove))
					if moved > 0 then
						-- Remove Items from the Chest --
						inv.remove{name=stack.name, count=moved}
						-- Recalcule the capItems --
						canMove = canMove - moved
						-- Test if capItems is empty --
						if canMove <= 0 then
							-- Stop --
							break
						end
					end
				end
			end
			-- Something was moved
			if canMove < capItems then
				-- Create the laser and remove energy --
				self.ent.surface.create_entity{name="GreenBeam", duration=60, position=self.ent.position, target=entity.position, source=self.ent.position}
				self.internalEnergyObj:removeEnergy((capItems - canMove) * _mfBaseItemEnergyConsumption)
				-- One less Beam to the Beam capacity --
				return true
			end
		end
	end
end

-- Update the Fuel --
function MF:updateFuel()
	-- Recharge the tank fuel --
	local burner = self.ent.burner
	if burner ~= nil then
		local fuelInventory = burner.inventory
		if fuelInventory.is_empty() == true then
			local fuel = game.item_prototypes['coal']
			if fuel == nil then return end
			if burner.currently_burning == nil then
				-- Insert coal in case of the Tank is off --
				if (fuel ~= nil) and (self.internalEnergyObj:energy() >= fuel.fuel_value/_mfFuelMultiplicator) then
					burner.currently_burning = fuel
					self.internalEnergyObj:removeEnergy(fuel.fuel_value/_mfFuelMultiplicator)
				end
			elseif burner.currently_burning == fuel then
				-- Calcule the missing Fuel amount --
				local remainingFuelValue = burner.remaining_burning_fuel
				local missingFuelValue = math.floor(fuel.fuel_value - remainingFuelValue)
				if missingFuelValue > 0 and self.internalEnergyObj:energy() >= missingFuelValue/_mfFuelMultiplicator then
					-- Add the missing Fuel to the Tank --
					burner.remaining_burning_fuel = remainingFuelValue + missingFuelValue
					-- Drain energy --
					self.internalEnergyObj:removeEnergy(missingFuelValue/_mfFuelMultiplicator)
				end
			end
		end
	end
end

-- Update the Shield --
function MF:updateShield(event)
	-- Get the current tick --
	local tick = event.tick
	-- Create the visual --
	if self:shield() > 0 then
		-- Calcule the shield tint --
		local tint = self:shield() / self:maxShield()
		-- Calcule the shield size --
		local mfB = self.ent.selection_box
		local size = (mfB.right_bottom.y - mfB.left_top.y) / 12
		rendering.draw_animation{animation="mfShield", target={self.ent.position.x-0.25, self.ent.position.y-0.3}, tint={1,tint,tint}, time_to_live=2, x_scale=size, y_scale=size, surface=self.ent.surface, render_layer=134}
	end
	-- Charge the Shield --
	local chargeSpeed = 10
	if tick%60 == 0 and self.internalEnergyObj:energy() > 0 then
		-- Get the Shield --
		for k, equipment in pairs(self.ent.grid.equipment) do
			-- Check if this is a Shield --
			if equipment.name == "mfShieldEquipment" then
				local missingCharge = equipment.max_shield - equipment.shield
				local chargeAmount = math.min(missingCharge, chargeSpeed)
				-- Check if the Shield can be charged --
				if chargeAmount > 0 and chargeAmount*_mfShieldComsuption <= self.internalEnergyObj:energy() then
					 -- Charge the Shield --
					 equipment.shield = equipment.shield + chargeAmount
					 -- Remove the energy --
					 self.internalEnergyObj:removeEnergy(chargeAmount*_mfShieldComsuption)
				end
			end
		end
	end
end

-- Send all Pollution outside --
function MF:updatePollution()
	-- Test if the Mobile Factory is valid --
	if self.fS == nil or self.ent == nil then return end
	if self.ent.valid == false then return end
	if self.ent.surface == nil then return end
	-- Get the total amount of Pollution --
	local totalPollution = self.fS.get_total_pollution()
	if totalPollution ~= nil then
		-- Create Pollution outside the Factory --
		self.ent.surface.pollute(self.ent.position, totalPollution)
		-- Clear the Factory Pollution --
		self.fS.clear_pollution()
	end
end

-- Update teleportation box --
function MF:factoryTeleportBox()
	-- Mobile Factory Vehicule --
	if self.tpEnabled == true then
		local mfB = self.ent.bounding_box
		local entities = self.ent.surface.find_entities_filtered{area={{mfB.left_top.x-0.5,mfB.left_top.y-0.5},{mfB.right_bottom.x+0.5, mfB.right_bottom.y+0.5}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerInside(entity.player, self)
		end
	end
	-- Factory to Outside --
	if self.fS ~= nil then
		local entities = self.fS.find_entities_filtered{area={{-1,-1},{1,1}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerOutside(entity.player, self)
		end
	end
	-- Factory to Control Center --
	if technologyUnlocked("ControlCenter", getForce(self.player)) ~= false and self.fS ~= nil then
		local entities = self.fS.find_entities_filtered{area={{-3,-34},{3,-32}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerToControlCenter(entity.player, self)
		end
	end
	-- Control Center to Factory --
	if technologyUnlocked("ControlCenter", getForce(self.player)) ~= false and self.ccS ~= nil and self.fS ~= nil then
		local entities = self.ccS.find_entities_filtered{area={{-3,5},{3,8}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerToFactory(entity.player, self)
		end
	end
end

-- Scan modules inside the Equipment Grid --
function MF:scanModules()
	-- Check if the Technology is unlocked --
	if technologyUnlocked("EnergyPowerModule", getForce(self.player)) == nil then return end
	-- Init Variables --
	self.laserRadiusMultiplier = 0
	self.laserDrainMultiplier = 0
	self.laserNumberMultiplier = 0
	-- Look for Modules --
	for k, equipment in pairs(self.ent.grid.equipment) do
		if equipment.name == "EnergyPowerModule" then
			self.laserRadiusMultiplier = self.laserRadiusMultiplier + 1
		end
		if equipment.name == "EnergyEfficiencyModule" then
			self.laserDrainMultiplier = self.laserDrainMultiplier + 1
		end
		if equipment.name == "EnergyFocusModule" then
			self.laserNumberMultiplier = self.laserNumberMultiplier + 1
		end
	end
end

-- Call the mobile Factory to the player (Before TP) --
function MF:TPMobileFactoryPart1(location)
	-- Get the Player --
	local player = getPlayer(self.playerIndex)
	-- Check if the Surface Exist --
	if location.surface == nil or game.surfaces[location.surface.name] == nil then
		player.print({"", {"gui-description.TPSurfaceNoFound"}})
		return
	end
	-- Check if the Mobile Factory exist --
	if self.ent == nil or self.ent.valid == false then
		player.print({"", {"gui-description.MFLostOrDestroyed"}})
		return
	end
	-- Check if the Mobile Factory has a Driver --
	if self.ent.get_driver() == nil then
		player.print({"", {"gui-description.TPNoDriver"}})
		return
	end
	-- Try to find the best coords --
	local tpCoords = location.surface.find_non_colliding_position(self.MF.ent.name, {location.posX,location.posY}, 10, 0.1, false)
	-- Return if no coords was found --
	if tpCoords == nil then
		player.print({"", {"gui-description.TPObstruction"}})
		return
	end
	-- Set the Non-colliding Destination --
	location.posX = tpCoords.x
	location.posY = tpCoords.y
	-- Start the TP --
	self.onTP = true
	self.tpCurrentTick = game.tick
	self.tpLocation = location
	-- Start all Animations --
	local animation1 = rendering.draw_animation{animation="SimpleTPAn", animation_speed=0.5, render_layer=131, x_scale=4, y_scale=3.5, target={self.ent.position.x, self.ent.position.y-0.7}, surface=self.ent.surface, time_to_live=150*2}
	Util.resetAnimation(animation1, 150)
	local animation2 = rendering.draw_animation{animation="SimpleTPAn", animation_speed=0.5, render_layer=131, x_scale=4, y_scale=3.5, target={location.posX, location.posY-0.7}, surface=location.surface, time_to_live=150*2}
	Util.resetAnimation(animation2, 150)
	-- Play all Sounds --
	self.ent.surface.play_sound{path="MFSimpleTP", position=self.ent.position}
	self.ent.surface.play_sound{path="MFSimpleTP", position=player.position}
	-- Close the TPGUI --
	local MFPlayer = getMFPlayer(self.playerIndex)
	if MFPlayer.GUI[_mfGUIName.TPGUI] ~= nil then
		MFPlayer.GUI[_mfGUIName.TPGUI].gui.destroy()
		MFPlayer.GUI[_mfGUIName.TPGUI] = nil
	end
end

-- Call the mobile Factory to the player (After TP) --
function MF:TPMobileFactoryPart2()
	-- Get the Player --
	local player = getPlayer(self.playerIndex)
	-- Check if the Surface Exist --
	if self.tpLocation.surface == nil or game.surfaces[self.tpLocation.surface.name] == nil then
		player.print({"", {"gui-description.TPSurfaceNoFound"}})
		-- Stop the TP --
		self.onTP = false
		self.tpCurrentTick = 0
		self.tpLocation = nil
		return
	end
	-- Check if the Mobile Factory exist --
	if self.ent == nil or self.ent.valid == false then
		player.print({"", {"gui-description.MFLostOrDestroyed"}})
		-- Stop the TP --
		self.onTP = false
		self.tpCurrentTick = 0
		self.tpLocation = nil
		return
	end
	-- Check if the Mobile Factory has a Driver --
	if self.ent.get_driver() == nil then
		player.print({"", {"gui-description.TPNoDriver"}})
		-- Stop the TP --
		self.onTP = false
		self.tpCurrentTick = 0
		self.tpLocation = nil
		return
	end
	-- Get the distance --
	local distance = Util.distance({self.tpLocation.posX,self.tpLocation.posY}, self.ent.position)
	-- Remove the Jump Drive Charge --
	self.jumpDriveObj.charge = math.max(0, self.jumpDriveObj.charge - distance)
	-- Remove the Quatron --
	if self.tpLocation.surface ~= self.ent.surface then
		self.internalQuatronObj:removeQuatron(1000)
	end
	-- Teleport the Mobile Factory to the cords --
	self.ent.teleport({self.tpLocation.posX, self.tpLocation.posY}, self.tpLocation.surface)
	-- Save the position --
	self.lastSurface = self.ent.surface
	self.lastPosX = self.ent.position.x
	self.lastPosY = self.ent.position.y
	-- Stop the TP --
	self.onTP = false
	self.tpCurrentTick = 0
	self.tpLocation = nil
end

-- Remove the Sync Area --
function MF:removeSyncArea()
	if self.syncAreaScanned == false then return end
	rendering.destroy(self.syncAreaID)
	rendering.destroy(self.syncAreaInsideID)
	self.syncAreaID = 0
	self.syncAreaInsideID = 0
	self.syncAreaScanned = false
	self:unCloneSyncArea()
end

-- Update the Sync Area --
function MF:updateSyncArea()
	local radius = 2 * _mfSyncAreaRadius
	local nearbyMFs = self.ent.surface.count_entities_filtered{position = self.ent.position, radius = radius, name = _mfMobileFactories, limit = 2}

	-- Check if the Mobile Factory is moving or the Sync Area is disabled --
	if self.syncAreaEnabled == false or self.ent.speed ~= 0 then
		self:removeSyncArea()
		return
	end

	if nearbyMFs > 1 then
		local player = getPlayer(self.player)
		if player.connected then
			player.create_local_flying_text{text={"info.MF-sync-too-close"}, position = self.ent.position}
		end
		self:removeSyncArea()
		return
	end

	-- Create the Circle --
	if self.syncAreaID == 0 then
		self.syncAreaID = rendering.draw_circle{color={108,52,131}, radius=_mfSyncAreaRadius, width=1, filled=false,target=self.ent, surface=self.ent.surface}
		self.syncAreaInsideID = rendering.draw_circle{color={108,52,131}, radius=_mfSyncAreaRadius, width=1, filled=false,target=_mfSyncAreaPosition, surface=self.fS}
	end

	-- Scan the Area if needed --
	if self.syncAreaScanned == false then
		self:syncAreaScan()
		self.syncAreaScanned = true
		return
	end

	-- Update Cloned Entities and Remove Invalid Pairs --
	self:updateClonedEntities()
end

-- Scan around the Mobile Factory for the Sync Area --
function MF:syncAreaScan()
	self.clonedResourcesTable = {}
	-- Cloning Tiles --
	local radius = _mfSyncAreaRadius + 1
	local bdb = {{self.ent.position.x - radius, self.ent.position.y - radius},{self.ent.position.x + radius, self.ent.position.y + radius}}
	local clonedBdb = {{_mfSyncAreaPosition.x - radius, _mfSyncAreaPosition.y - radius},{_mfSyncAreaPosition.x + radius, _mfSyncAreaPosition.y + radius}}

	local inside = self.fS
	local outside = self.ent.surface
	local obstructed = nil
	local distancesInBools = {}
	local distancesOutBools = {}

	-- Look for Entities inside the Sync Area --
	local entTableIn = inside.find_entities_filtered{area = clonedBdb}

--[[
	-- 06-05-2020: suggestion from Klonan, with idea/contributions from Optera
	-- this is complicated. I don't need entities for obstruction detection, but I need them for cloning
	tiles = outside.find_tiles_filtered{position = sync-area, radius = sync-area-radius}
	inside.count_entities_filtered{area = {{tile.position.x, tile.position.y}, {tile.position.x + 1, tile.position.y + 1}}, collision_mask = tile.prototype.collision_mask, limit = 1}
--]]
	-- Check if Entities inside Can't be Placed Outside --
	for k, ent in pairs(entTableIn) do
		if not _mfSyncAreaIgnoredTypes[ent.type] then
			local posX = math.floor(self.ent.position.x) + (ent.position.x - _mfSyncAreaPosition.x)
			local posY = math.floor(self.ent.position.y) + (ent.position.y - _mfSyncAreaPosition.y)

			distancesInBools[k] = Util.distance(ent.position, _mfSyncAreaPosition) < _mfSyncAreaRadius

			-- if we can place it, including marking obstructions for deconstruction... would overlap entities if we have friendly chests etc on the other side
			local arg = {
				name = ent.name,
				position = {posX, posY},
				direction = ent.direction,
				force = ent.force,
				build_check_type = defines.build_check_type.ghost_place,
				forced = true
			}
			-- Will create_entity Fail Without More Details? --
			if _mfSyncAreaExtraDetails[ent.type] then
				for argKey, entKey in pairs(_mfSyncAreaExtraDetails[ent.type]) do
					-- LuaItemStack vs SimpleItemStack (dictionary) --
					if entKey == "stack" then
						--unsure if stack could ever be invalid, but reading would cause an error
						if ent.stack.valid_for_read then
							arg[argKey] = {name = ent.stack.name, count = ent.stack.count}
						else
							--this is such a hackjob
							arg = nil
							break
						end
					else
						arg[argKey] = ent[entKey]
					end
				end
			end
 			if arg and outside.can_place_entity(arg) == false then
				obstructed = ent.localised_name or {"", ent.name}
				break
			end
		end
	end
	if obstructed then
		local player = nil
		if self.player ~= "" then
			player = getPlayer(self.player)
			if player.connected then
				player.create_local_flying_text{text={"", {"info.MF-sync-collision-in-out"}, ": ", obstructed}, position = self.ent.position}
			end
		end
		return
	end

	-- Look for Entities around the Mobile Factory --
	local entTableOut = outside.find_entities_filtered{area = bdb}

	-- Check if Entities inside Can't be Placed Iutside --
	for k, ent in pairs(entTableOut) do
		if _mfSyncAreaAllowedTypes[ent.type] == true then
			local posX = (ent.position.x - math.floor(self.ent.position.x)) + _mfSyncAreaPosition.x
			local posY = (ent.position.y - math.floor(self.ent.position.y)) + _mfSyncAreaPosition.y

			distancesOutBools[k] = Util.distance(ent.position, {math.floor(self.ent.position.x), math.floor(self.ent.position.y)}) < _mfSyncAreaRadius
			if distancesOutBools[k] and inside.entity_prototype_collides(ent.name, {posX, posY}, false) == true then
				obstructed = ent.localised_name or {"", ent.name}
				break
			end
		end
	end
	if obstructed then
		local player = nil
		if self.player ~= "" then
			player = getPlayer(self.player)
			if player.connected then
				player.create_local_flying_text{text={"", {"info.MF-sync-collision-out-in"}, ": ", obstructed}, position = self.ent.position}
			end
		end
		return
	end

	-- Clone Area to Sync Area --
	-- cloning the area can destroy inside entities (invalid tile placement), thus we checked first
	outside.clone_area{source_area=bdb, destination_area=clonedBdb, destination_surface=inside, clone_entities=false, clone_decoratives=false, clear_destination_entities=false}
	createSyncAreaMFSurface(inside)

	-- Clone Outside Entities --
	for k, ent in pairs(entTableOut) do
		if _mfSyncAreaAllowedTypes[ent.type] == true and distancesOutBools[k] == true and ent.name ~= "InternalEnergyCube" and ent.name ~= "InternalQuatronCube" then
			self:cloneEntity(ent, "in")
		end
	end

	-- Clone Inside Entities --
	for k, ent in pairs(entTableIn) do
		if _mfSyncAreaAllowedTypes[ent.type] == true and distancesInBools[k] == true then
			self:cloneEntity(ent, "out")
		end
		if ent.type == "mining-drill" then
			ent.update_connections()
		end
	end

end

-- Clone an Entity --
function MF:cloneEntity(ent, side) -- side: in (Clone inside), out (Clone outside)
	if self.ent == nil or self.ent.valid == false then return nil end
	local posX = 0
	local posY = 0
	local surface = nil
	local clone = nil
	-- Calcul the position and set the Surface --
	if side == "in" then
		posX = ent.position.x - math.floor(self.ent.position.x) + _mfSyncAreaPosition.x
		posY = ent.position.y - math.floor(self.ent.position.y) + _mfSyncAreaPosition.y
		surface = self.fS
	end
	if side == "out" then
		posX = math.floor(self.ent.position.x) + ent.position.x - _mfSyncAreaPosition.x
		posY = math.floor(self.ent.position.y) + ent.position.y - _mfSyncAreaPosition.y
		surface = self.ent.surface
	end
	-- Clone the Entity --
	clone = ent.clone{position={posX, posY}, surface=surface}
	if clone ~= nil and clone.valid == true then
		table.insert(self.clonedResourcesTable,  {original=ent, cloned=clone})
		if ent.type == "container" or ent.type == "logistic-container" then
			local cloneInv = clone.get_inventory(defines.inventory.chest)
			cloneInv.clear()
			if cloneInv.supports_bar() then
				local origInv = ent.get_inventory(defines.inventory.chest)
				origInv.set_bar(math.ceil(origInv.get_bar() / 2 + 0.5))
				cloneInv.set_bar(math.ceil(cloneInv.get_bar() / 2 + 0.5))
			end
		end
		if ent.type == "storage-tank" then
			clone.clear_fluid_inside()
		end
		if ent.type == "accumulator" then
			clone.energy = 0
		end
	else
		clone = nil
	end
	return clone
end

-- Return Items From Chest2 to Chest1 --
local function uncloneChest(chest1, chest2)
	local inv1 = chest1.get_inventory(defines.inventory.chest)
	local inv2 = chest2.get_inventory(defines.inventory.chest)

	if inv1.supports_bar() then
		inv1.set_bar(inv1.get_bar() * 2 - 1)
	end
	for i = 1, #inv2 do
		local stack = inv2[i]
		if stack.valid_for_read == true then
			local itemsInStack = stack.count
			local itemsInserted = inv1.insert(stack)
			if itemsInserted < itemsInStack then
				stack.count = itemsInStack - itemsInserted
				chest1.surface.spill_item_stack(chest1.position, stack, true, nil, false)
			end
		end
	end
	inv2.clear()
end

-- Return Fluid From Tank2 to Tank1 --
local function uncloneStorageTank(tank1, tank2)

	-- Check the Tanks --
	if tank1.fluidbox[1] == nil and tank2.fluidbox[1] == nil then return end

	-- Get Tanks Fluid --
	local t1FluidName = nil
	local t1FluidAmount = 0
	local t1FluidTemperature = nil
	local t2FluidName = nil
	local t2FluidAmount = 0
	local t2FluidTemperature = nil
	if tank1.fluidbox[1] ~= nil then
		t1FluidName = tank1.fluidbox[1].name
		t1FluidAmount = tank1.fluidbox[1].amount
		t1FluidTemperature = tank1.fluidbox[1].temperature
	end
	if tank2.fluidbox[1] ~= nil then
		t2FluidName = tank2.fluidbox[1].name
		t2FluidAmount = tank2.fluidbox[1].amount
		t2FluidTemperature = tank2.fluidbox[1].temperature
	end

	-- Clear Tank2 --
	tank2.clear_fluid_inside()

	-- Check the Fluids --
	if t1FluidName ~= nil and t2FluidName ~= nil and t1FluidName ~= t2FluidName then return end
	if t1FluidName == nil then t1FluidTemperature = t2FluidTemperature end
	if t2FluidName == nil then t2FluidTemperature = t1FluidTemperature end

	-- Calcul total Fluid --
	local fluidName = t1FluidName or t2FluidName
	local fluidAmount = math.floor(t1FluidAmount + t2FluidAmount)
	local fluidTemperature = math.floor(t1FluidTemperature + t2FluidTemperature)/2


	-- Check the Amount of Fluid --
	if fluidAmount <= 0 then return end

	-- Give Tank1 all Fluid --
	tank1.fluidbox[1] = {name=fluidName, amount=fluidAmount, temperature=fluidTemperature}

end

-- Send Energy from cloned Accu2 --
local function uncloneEnergy(accu1, accu2)
	-- Calcul the total energy --	
	local totalEnergy = accu1.energy + accu2.energy
	-- Set the Energy of the Accu1 --
	accu1.energy = totalEnergy
end

-- Send Quatron from cloned Accu2 --
local function uncloneQuatron(accu1, accu2)
	local obj1 = global.entsTable[accu1.unit_number]
	local obj2 = global.entsTable[accu2.unit_number]
	-- Calcul the total quatron --
	local effectiveCharge = obj1.quatronCharge * math.pow(obj1.quatronLevel, _mfQuatronScalePower) + obj2.quatronCharge * math.pow(obj2.quatronLevel, _mfQuatronScalePower)
	local totalCharge = obj1.quatronCharge + obj2.quatronCharge
	local effectiveLevel = math.pow(effectiveCharge / totalCharge, 1/_mfQuatronScalePower)
	-- Set the Quatron of the Accu1 --
	obj1.quatronCharge = math.min(totalCharge, obj1.quatronMax)
	obj1.quatronLevel = effectiveLevel
end

function MF:uncloneEntity(original, clone)
	if original.type == "container" or original.type == "logistic-container" then
		uncloneChest(original, clone)
	elseif original.type == "storage-tank" then
		uncloneStorageTank(original, clone)
	elseif original.name == "QuatronCubeMK1" then
		uncloneQuatron(original, clone)
	elseif original.type == "accumulator" then
		uncloneEnergy(original, clone)
	end
	clone.destroy{raise_destroy=true}
end

-- Unclone all Entities inside the Sync Area --
function MF:unCloneSyncArea()
	-- Set default Tiles --
	createSyncAreaMFSurface(self.fS, true)
	-- Update Before Trying to Unclone -- 
	self:updateClonedEntities()
	-- Remove all cloned Entities --
	for i, ents in pairs(self.clonedResourcesTable) do
		self:uncloneEntity(ents.original, ents.cloned)
	end
	self.clonedResourcesTable = {}
end

-- Update Entities inside the Sync Area --
function MF:updateClonedEntities()
	for i, ents in pairs(self.clonedResourcesTable) do
		self:updateClonedEntity(ents)
		if ents.original == nil or ents.original.valid == false then
			-- only checking original because both are nil/invalid after updating
			table.remove(self.clonedResourcesTable, i)
		end
	end
end

-- Update an Entity inside the Sync Area --
function MF:updateClonedEntity(ents)
	-- Check the Entities --
	if ents == nil then return end
	if ents.original == nil or ents.original.valid == false then
		if ents.cloned ~= nil and ents.cloned.valid == true then
			ents.cloned.destroy({raise_destroy = true})
		end
		return
	end
	if ents.cloned == nil or ents.cloned.valid == false then
		if ents.original ~= nil and ents.original.valid == true then
			ents.original.destroy({raise_destroy = true})
		end
		return
	end
	if ents.original.type == "resource" then
		-- If the Entity is a resource --
		if ents.cloned.amount < ents.original.amount then
			ents.original.amount = ents.cloned.amount
		end
		if ents.cloned.amount > ents.original.amount then
			ents.cloned.amount = ents.original.amount
		end
		if ents.original.amount <= 0 then
			ents.original.destroy()
			ents.cloned.destroy()
		end
	elseif ents.original.type == "container" or ents.original.type == "logistic-container" then
		-- If the Entity is a Chest --
		Util.syncChest(ents.original, ents.cloned)
	elseif ents.original.type == "storage-tank" then
		-- If the Entity is a Storage Tank --
		Util.syncTank(ents.original, ents.cloned)
	elseif ents.original.name == "QuatronCubeMK1" then
		-- If the Entity is a Quatron Cube --
		Util.syncQuatron(ents.original, ents.cloned)
	elseif ents.original.type == "accumulator" then
		-- If the Entity is an Accumulator --
		Util.syncEnergy(ents.original, ents.cloned)
	end
end

-- Check stored data, and remove invalid record
function MF:validate()
	-- Jump Drive location icons
	for _, loc in pairs(self.jumpDriveObj.locationTable or {}) do
		if loc.filter ~= nil and game.recipe_prototypes[loc.filter] == nil then
			loc.filter = nil
		end
	end
	-- Internal Inventory items
	for item, _ in pairs(self.II.inventory) do
		if game.item_prototypes[item] == nil then
			self.II.inventory[item] = nil
		end
	end
end

-- Called if the Player interacted with the GUI --
function MF.interaction(event, player, MFPlayer)
	-- Open Inventory --
	if string.match(event.element.name, "M.F.OpenInvButton") then
		-- Get the Object --
		local objId = event.element.tags.ID
		local ent = global.MFTable[objId].ent
		if ent ~= nil and ent.valid == true then
			MFPlayer.varTable.bypassGUI = true
			player.opened = ent
		end
		return
	end
	-- Energy Lasers --
	if string.match(event.element.name, "M.F.EnergyLasersSwitch") then
		-- Look for the Mobile Factory ID --
		local objId = event.element.tags.ID
		local MF = getMF(objId)
		-- Change the Energy Laser to Drain/Send --
		if event.element.switch_state == "left" then
			MF.selectedEnergyLaserMode = "input"
		else
			MF.selectedEnergyLaserMode = "output"
		end
		return
	end
	-- Quatron Lasers --
	if string.match(event.element.name, "M.F.QuatronLasersSwitch") then
		-- Look for the Mobile Factory ID --
		local objId = event.element.tags.ID
		local MF = getMF(objId)
		-- Change the Matter Serializer targeted Inventory --
		if event.element.switch_state == "left" then
			MF.selectedQuatronLaserMode = "input"
		else
			MF.selectedQuatronLaserMode = "output"
		end
		return
	end
	-- Fluid Lasers --
	if string.match(event.element.name, "M.F.FluidLasersSwitch") then
		-- Look for the Mobile Factory ID --
		local objId = event.element.tags.ID
		local MF = getMF(objId)
		-- Change the Mode --
		if event.element.switch_state == "left" then
			MF.selectedFluidLaserMode = "input"
		else
			MF.selectedFluidLaserMode = "output"
		end
		return
	end
	-- Fluid Lasers Target --
	if string.match(event.element.name, "M.F.FluidLasersTargetDD") then
		-- Look for the Mobile Factory ID --
		local objId = event.element.tags.ID
		local MF = getMF(objId)
		-- Change the Fluid Interactor Target --
		MF:fluidLaserTarget(tonumber(event.element.items[event.element.selected_index][4]))
		return
	end
end