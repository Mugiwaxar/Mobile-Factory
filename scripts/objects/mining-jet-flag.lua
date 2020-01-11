-- MINING JET FLAG --

-- Create the Mining Jet Flag base Object --
MJF = {
	ent = nil,
	updateTick = 15,
	lastUpdate = 0,
	oreTable = nil,
	targetedOre = 1,
	targetedInv = 0
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
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function MJF:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Check if the Entity is valid --
	if self.ent == nil or self.ent.valid == false then return end
	-- Request a Jet --
	self:requestJet()
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
	local area = {{self.ent.position.x - _mfMiningJetFlagRadius, self.ent.position.y - _mfMiningJetFlagRadius},{self.ent.position.x + _mfMiningJetFlagRadius, self.ent.position.y + _mfMiningJetFlagRadius}}
	self.oreTable = self.ent.surface.find_entities_filtered{area=area, type="resource"}
	-- Remove Fluid Path from the Table --
	for k, path in pairs(self.oreTable) do
		if path.prototype.mineable_properties.products[1].type ~= "item" then
			self.oreTable[k] = nil
		end
	end
	-- Shuffle the Ore Table --
	UpSys.shuffle(self.oreTable)
end

-- Request a Mining Jet --
function MJF:requestJet()

	-- Check the Mobile Factory --
	if global.MF.ent == nil or global.MF.ent.valid == false or global.MF.ent.surface ~= self.ent.surface then return end
	
	-- Check if there are Ores left --
	if table_size(self.oreTable) <= 0 then return end
	
	-- Check if the Targeted Ore value isn't too high --
	if self.targetedOre > table_size(self.oreTable) then
		self.targetedOre = 1
	end
	
	-- Take an Ore Path --
	local orePath = self.oreTable[self.targetedOre]
	
	-- Check the Ore Path --
	if orePath == nil or orePath.valid == false or orePath.amount <= 0 then
		table.remove(self.oreTable, self.targetedOre)
	end
	
	-- Get the Mobile Factory Trunk --
	local inv = global.MF.ent.get_inventory(defines.inventory.car_trunk)
	
	-- Check the Inventory --
	if inv == nil or inv.valid == false then return end
	
	-- Remove a Jet from the Inventory --
	local removed = inv.remove({name="MiningJet", count=1})
	
	-- Check if the Jet exist --
	if removed <= 0 then return end
	
	-- Increase the Targeted Ore number --
	self.targetedOre = self.targetedOre + 1
	
	-- Create the Entity --
	local entity = global.MF.ent.surface.create_entity{name="MiningJet", position=global.MF.ent.position, force="player"}
	global.miningJetTable[entity.unit_number] = MJ:new(entity, orePath, self.targetedInv)
	
end

-- Save the Selected Inventory --
function MJF:changeInventory(ID)
	if ID == nil then self.targetedInv = 0 end
	self.targetedInv = ID
end















