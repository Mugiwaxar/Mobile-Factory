-- MINING JET --

-- Create the Mining Jet base Object --
MJ = {
	ent = nil,
	updateTick = 60,
	lastUpdate = 0,
	lastCommand = 0,
	targetOre = nil,
	lastOrder = "Created", -- Created - GoPath - Mine - GoMF - EnterMF --
	inventoryItem = nil,
	inventoryCount = 0,
	isMining = false,
	targetedInv = 0,
	TargetInventoryFull = false,
	MFFull = false,
	MFNotFound = false
}

-- Constructor --
function MJ:new(object, targetOre, targetedInv)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = MJ
	t.ent = object
	t.targetOre = targetOre
	t.targetedInv = targetedInv
	t:update()
	return t
end

-- Reconstructor --
function MJ:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = MJ
	setmetatable(object, mt)
end

-- Destructor --
function MJ:remove()
end

-- Is valid --
function MJ:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function MJ:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Check if the Entity is valid --
	if self.ent == nil or self.ent.valid == false then return end
	
	-- Check if the Entity has finished its Command --
	if self.ent.command ~= nil and (self.ent.command.type ~= 6 and self.ent.command.type ~= 9) then return end
	
	-- Go to the Targeted Ore Path --
	if self.lastOrder == "Created" then
		self:goToPath()
		self.lastOrder = "GoPath"
		self.lastCommand = game.tick
		return
	end
	
	-- Start to Mine --
	if self.lastOrder == "GoPath" then
		self:mine()
		self.lastOrder = "Mine"
		self.isMining = true
		self.lastCommand = game.tick
		-- Stop to move --
		self.ent.set_command({type=defines.command.stop})
		return
	end
	
	-- Continue to Mine --
	if self.lastOrder == "Mine" and self.isMining == true then
		self:mine()
		self.lastCommand = game.tick
		return
	end
	
	-- Return to the Mobile Factory --
	if self.lastOrder == "Mine" and self.isMining == false then
		-- Check the MF -
		if global.MF.ent == nil or global.MF.ent.valid == false or global.MF.ent.surface ~= self.ent.surface then 
			self.MFNotFound = true
			return
		else
			self:goMF()
			self.lastOrder = "GoMF"
			self.lastCommand = game.tick
			return
		end
	end
	
	-- Enter the Mobile Factory --
	if self.lastOrder == "GoMF" or self.lastOrder == "EnterMF" then
		if global.MF.ent == nil or global.MF.ent.valid == false or global.MF.ent.surface ~= self.ent.surface then 
			self.MFNotFound = true
			return
		else
			self:enterMF()
			self.lastOrder = "EnterMF"
			self.lastCommand = game.tick
			return
		end
	end
	
end

-- Tooltip Infos --
function MJ:getTooltipInfos(GUI)
	-- Create the Current Work Label --
	local work = GUI.add{type="label", caption={"", {"gui-description." .. self.lastOrder}}}
	work.style.font = "LabelFont"
	work.style.font_color = _mfBlue
	
	if self.TargetInventoryFull == true then
		-- Create the Inventory Full Label --
		local invFull = GUI.add{type="label", caption={"", {"gui-description.TargetInventoryFull"}}}
		invFull.style.font = "LabelFont"
		invFull.style.font_color = _mfRed
	end
	
	if self.MFFull == true then
		-- Create the Mobile Factory Full Label --
		local mfFull = GUI.add{type="label", caption={"", {"gui-description.MFTrunkFull"}}}
		mfFull.style.font = "LabelFont"
		mfFull.style.font_color = _mfRed
	end
	
	if self.MFNotFound == true then
		-- Create the Mobile Factory No Found Label --
		local mfNoFound = GUI.add{type="label", caption={"", {"gui-description.MFNotFound"}}}
		mfNoFound.style.font = "LabelFont"
		mfNoFound.style.font_color = _mfRed
	end
	
	
	-- Create the Inventory Frame --
	INV:itemToFrame(self.inventoryItem, self.inventoryCount, GUI)
	
	
end

-- Go to the Ore Path --
function MJ:goToPath()
	-- Check if the Ore Path is still valid --
	if self.targetOre == nil or self.targetOre.valid == false or self.targetOre.amount <= 0 then
		-- Go back to the Mobile Factory --
		self.lastOrder = "Mine"
		self.lastCommand = game.tick
		self.isMining = false
		return
	end
	
	-- Go to the Ore Path --
	self.ent.set_command({type=defines.command.go_to_location, destination_entity=self.targetOre, radius=4})
	
end

-- Beggin the Mining Process --
function MJ:mine()
	-- Check if the Ore Path is still valid --
	if self.targetOre == nil or self.targetOre.valid == false or self.targetOre.amount <= 0 then
		-- Go back to the Mobile Factory --
		self.lastOrder = "Mine"
		self.lastCommand = game.tick
		self.isMining = false
		return
	end
	-- Mine Ore --
	local oreExtracted = math.min(_mfMiningJetOrePerUpdate, self.targetOre.amount, _mfMiningJetInventorySize - self.inventoryCount)
	-- Add Ore to the Inventory --
	self.inventoryItem = self.targetOre.prototype.mineable_properties.products[1].name
	self.inventoryCount = self.inventoryCount + oreExtracted
	-- Remove Ores from the Ore Path --
	self.targetOre.amount = math.max(self.targetOre.amount - oreExtracted, 1)
	-- Make the Beam --
	if oreExtracted > 0 then
		-- Make the Beam --
		self.ent.surface.create_entity{name="GreenBeam", duration=60, position=self.ent.position, target=self.targetOre.position, source=self.ent.position}
	end
	-- Remove the Ore Path if it is empty and Send the Jet to the Mobile Factory --
	if self.targetOre.amount <= 1 then
		self.targetOre.destroy()
		self.isMining = false
		return
	end
	-- Go back to the Mobile Factory if the Inventory is full --
	if self.inventoryCount >= _mfMiningJetInventorySize then
		self.isMining = false
		return
	end
end

-- Go back to the Mobile Factory --
function MJ:goMF()
	-- Go to the MF --
	self.ent.set_command({type=defines.command.go_to_location, destination_entity=global.MF.ent, radius=1})
end

-- Enter the Mobile Factory --
function MJ:enterMF()

	-- Check if the Jet have Items to store --
	if self.inventoryItem ~= nil and self.inventoryCount > 0 then
		-- Check the targeted Inventory --
		if self.targetedInv == 0 then
			-- Get the Linked Inventory --
			local dataInv = global.MF.II
			-- Add Items to the Data Inventory --
			local amountAdded = dataInv:addItem(self.inventoryItem, self.inventoryCount)
			-- Remove Items from the local Inventory --
			if amountAdded > 0 then
				self.inventoryCount = self.inventoryCount - amountAdded
			end
		else
			-- Find the Ore Silo --
			local silo = global.oreSilotTable[self.targetedInv]
			-- Check the Ore Silo --
			if silo == nil or silo.valid == false then return end
			-- Get the Silo Inventory --
			local siloInv = silo.get_inventory(defines.inventory.chest)
			-- Check if the Inventory is valid --
			if siloInv == nil then return end
			-- Insert Items --
			local amountAdded = siloInv.insert({name=self.inventoryItem, count=self.inventoryCount})
			-- Remove Items from the local Inventory --
			if amountAdded > 0 then
				self.inventoryCount = self.inventoryCount - amountAdded
			end
		end
	end
	
	-- No enought space inside the Targeted Inventory --
	if self.inventoryCount > 0 then
		self.TargetInventoryFull = true
		return
	end
	
	-- Get the Mobile Factory Trunk --
	local inv = global.MF.ent.get_inventory(defines.inventory.car_trunk)
	
	-- Check the Inventory --
	if inv == nil or inv.valid == false then return end
	
	-- Stock the Jet --
	local stocked = inv.insert({name="MiningJet", count=1})
	
	-- No enought space inside the Mobile Factory Trunk --
	if stocked == 0 then
		self.MFFull = true
		return
	end
	
	-- Remove the Jet --
	global.jetFlagTable[self.ent.unit_number] = nil
	self:remove()
	self.ent.destroy()
	
end






