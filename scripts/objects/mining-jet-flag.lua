-- MINING JET FLAG --

-- Create the Mining Jet Flag base Object --
MJF = {
	ent = nil,
	updateTick = 60,
	lastUpdate = 0,
	lastInventorySend = 0,
	oreTable = nil,
	selectedInv = 0,
	inventory = nil, -- [item]{count}
	TargetInventoryFull = false,
	MFNotFound = false
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

	-- Create the Inventory Full Label --
	if self.TargetInventoryFull == true then
		local invFull = GUI.add{type="label", caption={"", {"gui-description.TargetInventoryFull"}}}
		invFull.style.font = "LabelFont"
		invFull.style.font_color = _mfRed
	end
	
	-- Create the Mobile Factory No Found Label --
	if self.MFNotFound == true then
		local mfNoFound = GUI.add{type="label", caption={"", {"gui-description.MFNotFound"}}}
		mfNoFound.style.font = "LabelFont"
		mfNoFound.style.font_color = _mfRed
	end

	-- Create the Targed Label --
	local targetLabel = GUI.add{type="label", caption={"", {"gui-description.InternalInventory"}, ":"}}
	targetLabel.style.font = "LabelFont"
	targetLabel.style.font_color = _mfBlue
	
	-- Create the Inventory Frame --
	for name, count in pairs(self.inventory) do
		Util.itemToFrame(name, count, GUI)
	end

	-- Create the targeted Inventory label --
	local targetLabel = GUI.add{type="label", caption={"", {"gui-description.MSTarget"}, ":"}}
	targetLabel.style.top_margin = 7
	targetLabel.style.font = "LabelFont"
	targetLabel.style.font_color = {108, 114, 229}

	local invs = {{"gui-description.All"}}
	local selectedIndex = 1
	local i = 1
	for k, deepStorage in pairs(global.deepStorageTable) do
		if deepStorage ~= nil then
			i = i + 1
			invs[k+1] = {"", {"gui-description.DS"}, " ", tostring(deepStorage.ID)}
			if self.selectedInv == deepStorage then
				selectedIndex = i
			end
		end
	end
	if selectedIndex ~= nil and selectedIndex > table_size(invs) then selectedIndex = nil end
	local invSelection = GUI.add{type="list-box", name="MJF" .. self.ent.unit_number, items=invs, selected_index=selectedIndex}
	invSelection.style.width = 70
end

-- Change the Targeted Inventory --
function MJF:changeInventory(ID)
	-- Check the ID --
	if ID == nil then self.selectedInv = nil end
	-- Select the Inventory --
	self.selectedInv = nil
	for k, deepStorage in pairs(global.deepStorageTable) do
		if deepStorage ~= nil and deepStorage:valid() == true then
			if ID == deepStorage.ID then
				self.selectedInv = deepStorage
			end
		end
	end
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
	
	-- Check the Distance --
	if Util.distance(self.ent.position, global.MF.ent.position) > global.mjMaxDistance then return end
	
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

-- Send inside Inventory to the Targeted one --
function MJF:sendInventory()

	-- Check the Mobile Factory --
	if global.MF.ent == nil or global.MF.ent.valid == false then
		self.MFNotFound = true
		return
	else
		self.MFNotFound = false
	end

	-- Check the Inventory Table --
	if self.inventory == nil then self.inventory = {} end

	-- Sended value --
	local sended = false
	
	-- Check the targeted Inventory --
	local dataInv = self.selectedInv
	if dataInv == nil and dataInv:valid() == false then return end

	-- Itinerate the Inventory --
	for name, count in pairs(self.inventory) do
		if dataInv == 0 then
			-- Send Ore to all Deep Storage --
			for k, dp in pairs(global.deepStorageTable) do
				local added = dp:addItem(name, count)
				-- Check if Ore was added --
				if added > 0 then
					self.inventory[name] = self.inventory[name] - added
					sended = true
					-- Remove the Ore --
					if self.inventory[name] <= 0 then
						self.inventory[name] = nil
						break
					end
				end
			end
		else
			local added = dataInv:addItem(name, count)
			-- Check if Ore was added --
			if added > 0 then
				self.inventory[name] = self.inventory[name] - added
				sended = true
				-- Remove the Ore --
				if self.inventory[name] <= 0 then
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













