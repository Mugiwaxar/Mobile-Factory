-- MINING JET --

-- Create the Mining Jet base Object --
MJ = {
	ent = nil,
	updateTick = 60,
	lastUpdate = 0,
	targetOre = nil,
	currentOrder = "Created", -- Created - GoPath - Mine - GoFlag - EmptInv - GoMF - EnterMF --
	inventoryItem = nil,
	inventoryCount = 0,
	isMining = false,
	flag = 0,
	MFFull = false,
	MFNotFound = false
}

-- Constructor --
function MJ:new(object, targetOre, flag)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = MJ
	t.ent = object
	t.targetOre = targetOre
	t.flag = flag
	UpSys.addObj(t)
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
	-- Remove from the Update System --
	UpSys.removeObj(self)
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
	-- Check the Validity --
	if self:valid() == false then
		self:remove()
		return
	end
	
	-- Give a command to the Jet --
	if self.currentOrder == "Created" then
		self:goToPath()
		return
	end
	if self.currentOrder == "GoPath" and self:isIddle() == true then
		self:mine()
		return
	end
	if self.currentOrder == "Mine" and self.isMining == true then
		self:mine()
		return
	end
	if self.currentOrder == "Mine" and self:isIddle() == true then
		self:goToFlag()
		return
	end
	if self.currentOrder == "GoFlag" and self:isIddle() == true then
		self:emptyInventory()
		return
	end
	if self.currentOrder == "EmptInv" and self:isIddle() == true then
		self:takeAnotherPath()
		return
	end
	if self.currentOrder == "GoMF" and self:isIddle() == true then
		self:enterMF()
		return
	end
end

-- Tooltip Infos --
function MJ:getTooltipInfos(GUI)
	-- Create the Current Work Label --
	local work = GUI.add{type="label", caption={"", {"gui-description." .. self.currentOrder}}}
	work.style.font = "LabelFont"
	work.style.font_color = _mfBlue
	
	-- Create the Mobile Factory Full Label --
	if self.MFFull == true then
		local mfFull = GUI.add{type="label", caption={"", {"gui-description.MFTrunkFull"}}}
		mfFull.style.font = "LabelFont"
		mfFull.style.font_color = _mfRed
	end
	
	-- Create the Mobile Factory No Found Label --
	if self.MFNotFound == true then
		local mfNoFound = GUI.add{type="label", caption={"", {"gui-description.MFNotFound"}}}
		mfNoFound.style.font = "LabelFont"
		mfNoFound.style.font_color = _mfRed
	end
	
	-- Create the Inventory List --
	Util.itemToFrame(self.inventoryItem, self.inventoryCount, GUI)
	
end

-- Is the Jet Iddle ? --
function MJ:isIddle()
	if self.isMining == true or (self.ent.command.type ~= 6 and self.ent.command.type ~= 9) then
		return false
	end
	return true
end

-- Go to the Ore Path --
function MJ:goToPath()
	-- Check if the Ore Path is still valid --
	if self.targetOre == nil or self.targetOre.valid == false or self.targetOre.amount <= 0 then
		-- Remove the Path --
		self.flag:removeOrePath(self.targetOre)
		-- Check if there are Path left --
		if table_size(self.flag.oreTable) <= 0 then
			-- Return to the Mobile Factory --
			self:goToMF()
			return
		end
		
		-- Take Another Path --
		self:takeAnotherPath()
		return
	end
	
	-- Go to the Ore Path --
	self.ent.set_command({type=defines.command.go_to_location, destination_entity=self.targetOre, radius=2})
	self.currentOrder = "GoPath"
	
end

-- Beggin the Mining Process --
function MJ:mine()
	-- Check if the Ore Path is still valid --
	if self.targetOre == nil or self.targetOre.valid == false or self.targetOre.amount <= 0 then
		self.isMining = false
		-- Take Another Ore Path or return to the Flag --
		if self.inventoryCount >= _mfMiningJetInventorySize then
			self:goToFlag()
		else
			self:takeAnotherPath()
		end
		return
	end
	
	-- Set the current Order --
	self.currentOrder = "Mine"
	self.isMining = true
	self.ent.set_command({type=defines.command.stop})
	
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
		self.ent.surface.create_entity{name="GreenBeam", duration=self.updateTick, position=self.ent.position, target=self.targetOre.position, source=self.ent.position}
	end
	
	-- Remove the Ore Path if it is empty --
	if self.targetOre.amount <= 1 then
		self.targetOre.destroy()
		self.isMining = false
		self.flag:removeOrePath(targetOre)
		-- Take Another Ore Path or return home --
		if self.inventoryCount >= _mfMiningJetInventorySize then
			self:goToFlag()
		else
			self:takeAnotherPath()
		end
		return
	end
	
	-- Go back to the Flag if the Inventory is full --
	if self.inventoryCount >= _mfMiningJetInventorySize then
		self.isMining = false
		self:goToFlag()
		return
	end
	
end

-- Go back to the Flag --
function MJ:goToFlag()
	-- Check if the Flag still exist --
	if self.flag:valid() == false then
		-- Go to the Mobile Factory --
		self:goToMF()
		return
	end
	-- Set the current Order --
	self.ent.set_command({type=defines.command.go_to_location, destination_entity=self.flag.ent, radius=2})
	self.currentOrder = "GoFlag"
end

-- Empty the Inventory --
function MJ:emptyInventory()
	self.currentOrder = "EmptInv"
	if self.flag:valid() == false then
		self:goToMF()
		return
	end
	-- Check if there are something inside the Inventory --
	if self.inventoryItem ~= nil and self.inventoryCount > 0 then
		self.flag:addItems(self.inventoryItem, self.inventoryCount)
		self.inventoryItem = nil
		self.inventoryCount = 0
		-- Create the Laser --
		self.ent.surface.create_entity{name="GreenBeam", duration=10, position=self.ent.position, target=self.flag.ent.position, source=self.ent.position}
	end
	self:takeAnotherPath()
end

-- Take another Ore Path --
function MJ:takeAnotherPath()
	-- Check if there are Path left and if the Targeted Inventory is not full --
	if table_size(self.flag.oreTable) <= 0 or self.flag.TargetInventoryFull == true then
		-- Return to the Mobile Factory --
		self:goToMF()
		return
	end
	-- Take a new Ore Path --
	self.targetOre = self.flag:getOrePath()
	-- Check the Ore Path --
	if self.targetOre == nil then return end
	-- Go to the Path --
	self:goToPath()
end

-- Go back to the Mobile Factory --
function MJ:goToMF()
	-- Check if the Jet have to empty its Inventory --
	if self.inventoryItem ~= nil and self.inventoryCount > 0 and self.flag:valid() == true then
		self:goToFlag()
		return
	end
	-- Check if the Mobile Factory is still valid --
	if global.MF.ent == nil or global.MF.ent.valid == false then
		-- Say the Mobile Factory is not found --
		self.MFNotFound = true
		return
	else
		self.MFNotFound = false
	end
	-- Set the current Order --
	self.currentOrder = "GoMF"
	-- Go to the MF --
	self.ent.set_command({type=defines.command.go_to_location, destination_entity=global.MF.ent, radius=1})
end

-- Enter the Mobile Factory --
function MJ:enterMF()
	
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






