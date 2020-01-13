-- MINING JET FLAG --

-- Create the Mining Jet Flag base Object --
MJF = {
	ent = nil,
	updateTick = 60,
	lastUpdate = 0,
	lastInventorySend = 0,
	oreTable = nil,
	targetedInv = 0,
	inventory = nil, -- [item]{count}
	TargetInventoryFull = false
}

-- Constructor --
function MJF:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = MJF
	t.ent = object
	t.oreTable = {}
	t.inventory = {}
	UpSys.addObj(t)
	t:scanOres()
	return t
end

-- Reconstructor --
function MJF:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = MJF
	setmetatable(object, mt)
end

-- Destructor --
function MJF:remove()
end

-- Is valid --
function MJF:valid()
	if self.ent ~= nil and self.ent.valid == true then return true end
	return false
end

-- Update --
function MJF:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Check the Validity --
	if self:valid() == false then
		self:remove()
		return
	end
	-- Request a Jet --
	self:requestJet()
	-- Send Inventory to the Targed --
	if game.tick - self.lastInventorySend > 300 then
		self:sendInventory()
		self.lastInventorySend = game.tick
	end
end

-- Tooltip Infos --
function MJF:getTooltipInfos(GUI)

	-- Create the Total Ore Path Label --
	local pathLabel = GUI.add{type="label", caption={"", tonumber(table_size(self.oreTable)), " ", {"gui-description.OrePathsFound"}, ":"}}
	pathLabel.style.font = "LabelFont"
	pathLabel.style.font_color = _mfBlue

	-- Create the Targed Label --
	local targetLabel = GUI.add{type="label", caption={"", {"gui-description.TargetedInventory"}, ":"}}
	targetLabel.style.font = "LabelFont"
	targetLabel.style.font_color = _mfBlue
	
	-- Create the Inventory Full Label --
	if self.TargetInventoryFull == true then
		local invFull = GUI.add{type="label", caption={"", {"gui-description.TargetInventoryFull"}}}
		invFull.style.font = "LabelFont"
		invFull.style.font_color = _mfRed
	end
	
	-- Create the Inventory Frame --
	for name, count in pairs(self.inventory) do
		Util.itemToFrame(name, count, GUI)
	end

	-- Create the Ore Silo Selection --
	local inventories = {{"gui-description.InternalInventory"}}
	local selectedIndex = 1
	local i = 1
	for k, oreSilo in pairs(global.oreSilotTable) do
		if oreSilo ~= nil then
			i = i + 1
			inventories[k+1] = tostring(k)
			if self.targetedInv == k then
				selectedIndex = i
			end
		end
	end
	if selectedIndex ~= nil and selectedIndex > table_size(inventories) then selectedIndex = nil end
	local oreSiloSelection = GUI.add{type="list-box", name="MJF" .. self.ent.unit_number, items=inventories, selected_index=selectedIndex}
	oreSiloSelection.style.width = 50
end

-- Scan Ores Around --
function MJF:scanOres()
	-- Test if the Surface is valid --
	if self.ent.surface == nil then return end
	-- Add all surrounding Ores and add them to the oreTable --
	local radius = 0
	if self.ent.name == "MiningJetFlagMK1" then
		radius = _mfMiningJetFlagMK1Radius
	elseif self.ent.name == "MiningJetFlagMK2" then
		radius = _mfMiningJetFlagMK2Radius
	elseif self.ent.name == "MiningJetFlagMK3" then
		radius = _mfMiningJetFlagMK3Radius
	elseif self.ent.name == "MiningJetFlagMK4" then
		radius = _mfMiningJetFlagMK4Radius
	end
	local area = {{self.ent.position.x - radius, self.ent.position.y - radius},{self.ent.position.x + radius, self.ent.position.y + radius}}
	self.oreTable = self.ent.surface.find_entities_filtered{area=area, type="resource"}
	-- Remove Fluid Path from the Table --
	for k, path in pairs(self.oreTable) do
		if path.prototype.mineable_properties.products[1].type ~= "item" then
			self.oreTable[k] = nil
		end
	end
	
end

-- Request a Mining Jet --
function MJF:requestJet()

	-- Check the Mobile Factory --
	if global.MF.ent == nil or global.MF.ent.valid == false or global.MF.ent.surface ~= self.ent.surface then return end
	
	-- Check if there are Ores left --
	if table_size(self.oreTable) <= 0 then return end
	
	
	-- Check if there are enought space inside the Targeted Inventory --
	if self.TargetInventoryFull == true then return end
	
	-- Get the Mobile Factory Trunk --
	local inv = global.MF.ent.get_inventory(defines.inventory.car_trunk)
	
	-- Check the Inventory --
	if inv == nil or inv.valid == false then return end
	
	-- Request Jet --
	for i = 1, table_size(self.oreTable) do
		-- Get an Ore Path --
		local orePath = self:getOrePath()
		
		-- Check the Ore Path --
		if orePath == nil or orePath.valid == false or orePath.amount <= 0 then
			self:removeOrePath(orePath)
		else
			-- Remove a Jet from the Inventory --
			local removed = inv.remove({name="MiningJet", count=1})
			-- Check if the Jet exist --
			if removed <= 0 then return end
			-- Create the Entity --
			local entity = global.MF.ent.surface.create_entity{name="MiningJet", position=global.MF.ent.position, force="player"}
			global.miningJetTable[entity.unit_number] = MJ:new(entity, orePath, self)
		end
		-- Stop if there are 5 Jet out --
		if i >= 5 then return end
	end
	
end

-- Get a new Ore Path to Mine --
function MJF:getOrePath()
	-- Get a random Path --
	local i = math.random(1, table_size(self.oreTable))
	return self.oreTable[i]
end

-- Remove an Ore Path from the Ore Table --
function MJF:removeOrePath(orePath)
	for k, path in pairs(self.oreTable) do
		if path == orePath then
			table.remove(self.oreTable, k)
		end
	end
end

-- Add items to the Inventory --
function MJF:addItems(name, count)
	if self.inventory[name] == nil then
		self.inventory[name] = count
	else
		self.inventory[name] = self.inventory[name] + count
	end
end

-- Save the Selected Inventory --
function MJF:changeInventory(ID)
	if ID == nil then self.targetedInv = 0 end
	self.targetedInv = ID
end

-- Send inside Inventory to the Targeted one --
function MJF:sendInventory()

	if self.inventory == nil then self.inventory = {} end

	-- Sended value --
	local sended = false

	-- Itinerate the Inventory --
	for name, count in pairs(self.inventory) do
		-- Check the targeted Inventory --
		if self.targetedInv == 0 then
			-- Get the Linked Inventory --
			local dataInv = global.MF.II
			-- Add Items to the Data Inventory --
			local amountAdded = dataInv:addItem(name, count)
			-- Remove Items from the local Inventory --
			if amountAdded > 0 then
				count = count - amountAdded
				sended = true
				if count <= 0 then
					self.inventory[name] = nil
				end
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
			local amountAdded = siloInv.insert({name=name, count=count})
			-- Remove Items from the local Inventory --
			if amountAdded > 0 then
				count = count - amountAdded
				sended = true
				if count <= 0 then
					self.inventory[name] = nil
				end
			end
		end
	end
	
	-- Create the Laser --
	if sended == true then
		self.ent.surface.create_entity{name="BlueBeam", duration=20, position=self.ent.position, target=global.MF.ent.position, source={self.ent.position.x,self.ent.position.y}}
	end
	
	-- No enought space inside the Targeted Inventory --
	if table_size(self.inventory) > 0 then
		self.TargetInventoryFull = true
		return
	else
		self.TargetInventoryFull = false
	end
end













