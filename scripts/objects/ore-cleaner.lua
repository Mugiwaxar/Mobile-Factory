-- ORE CLEANER OBJECT --

OC = {
	ent = nil,
	purity = 0,
	charge = 0,
	totalCharge = 0,
	oreTable = nil,
	inventory = nil,
	animID = 0,
	animTick = 0,
	updateTick = 1,
	lastUpdate = 0,
	lastExtraction = 0
}

-- Constructor --
function OC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = OC
	t.ent = object
	return t
end

-- Reconstructor --
function OC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = OC
	setmetatable(object, mt)
end

-- Destructor --
function OC:remove()
	self.ent = nil
	self.oreTable = {}
	animID = 0
	animTick = 0
	lastUpdate = 0
	rendering.destroy(self.animID)
end

-- Is valid --
function OC:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function OC:update(event)
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Remove the Ore Cleaner if it no longer exist --
	if self.ent == nil then self:remove() return end
	if self.ent.valid == false then self:remove() return end
	-- Set the Ore Cleaner Energy --
	global.oreCleaner.ent.energy = 60
	-- Collect Ores --
	if event.tick%_mfOreCleanerExtractionTicks == 0 then
		self:collectOres(event)
	end
	-- Send ores to the Ore Silo --
	if event.tick%_eventTick57 == 0 then
		self:sendToSilo()
	end
	-- Update Animation --
	 self:updateAnimation(event)
	 --
end

-- Tooltip Infos --
function OC:getTooltipInfos(GUI)
end

-- Add a Quatron Charge --
function OC:addQuatron(level)
	self.charge = self.charge + 100
	self.purity = ((self.purity * self.totalCharge) + level) / (self.totalCharge + 1)
end

-- Get the number of Ores per extraction --
function OC:orePerExtraction()
	return math.floor(self.purity * _mfOreCleanerOrePerExtraction)
end

-- Get the Inventory items number --
function OC:inventoryItemNumber()
	-- Check if the Inventory Table is valid --
	if self.inventory == nil then self.inventory = {} end
	-- Create the number variable --
	local number = 0
	-- Look for all items --
	for	 k, itemStack in pairs(self.inventory) do
		number = number + itemStack.count
	end
	return number
end

-- Add itemsStack to the Inventory --
function OC:addItemStack(item)
	-- Test if the Ore Cleaner is valid --
	if self.ent == nil then return 0 end
	if self.ent.valid == false then return 0 end
	-- Test if the Item exist or not inside the Inventory --
	for k, itemStack in pairs(self.inventory) do
		-- Look for a corresponding Item --
		if item.name == itemStack.name then
			-- Add the Item to the Stack --
			itemStack.count = itemStack.count + item.count
			return
		end
	end
	-- If any corresponding Item exist, create a new one --
	table.insert(self.inventory, item)
end

-- Get the module ID inside --
function OC:getModuleID()
	-- Test if the Ore Cleaner is valid --
	if self.ent == nil then return 0 end
	if self.ent.valid == false then return 0 end
	-- Get the Inventory --
	local inventory = global.oreCleaner.ent.get_module_inventory()
	-- Test if the Inventory is valid --
	if inventory == nil then return 0 end
	-- Look for the Module --
	local moduleID = inventory[1]
	-- Test if the Module is valid --
	if moduleID == nil then return 0 end
	if moduleID.valid == false then return 0 end
	if moduleID.valid_for_read == false then return 0 end
	-- Look for the Module name --
	local moduleName = moduleID.name
	-- Test if the Module Name is valid --
	if moduleName == nil then return 0 end
	-- Look for the ID --
	if string.match(moduleName, "ModuleID") then
		ID = tonumber(string.sub(moduleName, -1))
	end
	-- Test if the ID is valid --
	if ID == nil then return 0 end
	-- Return the ID --
	return ID	
end

-- Scan surronding Ores --
function OC:scanOres(entity)
	-- Test if the Entity is valid --
	if entity == nil or entity.valid == false then return end
	-- Test if the Surface is valid --
	if entity.surface == nil then return end
	-- Get the name of the Ore under the Ore Cleaner --
	local resource = entity.surface.find_entities_filtered{position=entity.position, radius=1, type="resource", limit=1}
	-- Test if the Ore was found --
	if resource[1] == nil or resource[1].valid == false then return end
	-- Add all surrounding Ores and add them to the oreTable --
	self.oreTable = entity.surface.find_entities_filtered{position=entity.position, radius=_mfOreCleanerRadius, name=resource[1].name}
end

-- Collect surrounding Ores --
function OC:collectOres(event)
	-- Test if the Ore Cleaner and the Mobile Factory are valid --
	if global.oreCleaner == nil or global.MF == nil or global.MF.ent == nil then return end
	if global.MF.ent.valid == false then return end
	-- Set the Ore Cleaner to nil if the Entity is no longer valid --
	if global.oreCleaner.ent ~= nil and global.oreCleaner.ent.valid == false then global.oreCleaner:remove() return end
	-- Get the Inventory remaining space --
	local iRemSpace = _mfOreCleanerInventorySize - self:inventoryItemNumber()
	-- Return if there are no space remaining --
	if iRemSpace <= 0 then return end
	-- Return if the Ore Table is empty --
	if table_size(self.oreTable) <= 0 then return end
	-- Return if there are not Quatron Charge remaining --
	if self.charge <= 0 then return end
	-- Get the ID of the focused Ore Silo --
	local oreSiloID = self:getModuleID()
	-- Test if the ID was found --
	if oreSiloID == 0 then return end
	-- Create the OrePath and randomNum variable --
	local orePath = nil
	local randomNum  = 0
	-- Look for a random Ore Path --
	for i=0, 1000 do
		-- Calcul a random Ore Path --
		randomNum = math.random(1, table_size(self.oreTable))
		-- Get the Ore Path --
		orePath = self.oreTable[randomNum]
		-- If the Ore Path is valid, break --
		if orePath ~= nil and orePath.valid == true then
			break
		end
	end
	-- Test if the Ore Path exist and is valid --
	if orePath == nil then return end
	if orePath.valid == false then return end
	-- Extract Ore --
	local oreExtracted = math.min(self:orePerExtraction(), orePath.amount, iRemSpace)
	-- Add Ores to the Inventory --
	self:addItemStack({name=orePath.prototype.mineable_properties.products[1].name, count=oreExtracted})
	-- Remove Ores from the Ore Path --
	orePath.amount = math.max(orePath.amount - oreExtracted, 1)
	-- Make the beam --
	if oreExtracted > 0 then
		-- Make the Beam --
		self.ent.surface.create_entity{name="OCBeam", duration=60, position=self.ent.position, target=orePath.position, source={self.ent.position.x,self.ent.position.y-3.2}}
		-- Set the lastUpdate variable --
		self.lastExtraction = event.tick
		-- Remove a charge --
		self.charge = self.charge - 1
	end
	-- Remove the Ore Path if it is empty --
	if orePath.amount <= 1 then
		orePath.destroy()
		self.oreTable[randomNum] = nil
	end
end

-- Send to the Ore Silot --
function OC:sendToSilo()
	-- Get The Ore Silo --
	local oreSilo = global.oreSilotTable[self:getModuleID()]
	-- Test if the Ore Silo is valid --
	if oreSilo == nil then return end
	if oreSilo.valid == false then return end
	-- Get the Silo Inventory --
	local siloInv = oreSilo.get_inventory(defines.inventory.chest)
	-- Test if the Inventory is valid --
	if siloInv == nil then return end
	-- Try to send things --
	for k, itemStack in pairs(self.inventory) do
		-- Insert Items --
		local inserted = siloInv.insert({name=itemStack.name, count=itemStack.count})
		-- Test if Items was inserted --
		if inserted > 0 then
			-- Remove Items from the Inventory --
			itemStack.count = itemStack.count - inserted
			-- Test if the itemStack is empty --
			if itemStack.count <= 0 then
				-- Remove the ItemStack from the Inventory --
				self.inventory[k] = nil
			end
		end
	end
end

-- Update the Animation --
function OC:updateAnimation(event)
	-- Test if they was any extraction since the last tick --
	if event.tick - self.lastExtraction > 10 and self.animID ~= 0 then
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
		-- Make the transfer Beam --
		self.ent.surface.create_entity{name="OCBigBeam", duration=16, position=self.ent.position, target=global.MF.ent.position, source={self.ent.position.x-0.3,self.ent.position.y-4}}
		return
	-- If they was extraction but the animation doesn't exist --
	elseif event.tick - self.lastExtraction <= 10 and self.animID == 0 then
		-- Create the Orb Animation --
		self.animID = rendering.draw_animation{animation="RedEnergyOrb", target={self.ent.position.x,self.ent.position.y - 3.25}, surface=self.ent.surface}
		-- I don't know what this do, but it work (reset the animation) --
		rendering.set_animation_offset(self.animID, 240 - (event.tick%240))
		self.animTick = event.tick
	-- Make the Beam if the animation ended --
	elseif (event.tick - self.animTick)%240 == 0 and self.animID ~= 0 then
		-- Make the transfer Beam --
		self.ent.surface.create_entity{name="OCBigBeam", duration=16, position=self.ent.position, target=global.MF.ent.position, source={self.ent.position.x-0.3,self.ent.position.y-4}}
	end
end












