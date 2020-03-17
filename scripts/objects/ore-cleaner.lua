-- ORE CLEANER OBJECT --

OC = {
	ent = nil,
	player = "",
	MF = nil,
	purity = 0,
	charge = 0,
	totalCharge = 0,
	oreTable = nil,
	selectedInv = nil,
	animID = 0,
	animTick = 0,
	updateTick = 1,
	lastUpdate = 0,
	lastExtraction = 0,
	mfTooFar = false
}

-- Constructor --
function OC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = OC
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.oreTable = {}
	t.inventory = {}
	UpSys.addObj(t)
	t:scanOres(object)
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
	-- Destroy the Animation --
	rendering.destroy(self.animID)
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function OC:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Copy Settings --
function OC:copySettings(obj)
	self.selectedInv = obj.selectedInv
end

-- Update --
function OC:update(event)
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end
	-- The Ore Cleaner can work only if the Mobile Factory Entity is valid --
	if self.MF.ent == nil or self.MF.ent.valid == false then return end
	-- Check the Surface --
	if self.ent.surface ~= self.MF.ent.surface then return end
	-- Check the Distance --
	if Util.distance(self.ent.position, self.MF.ent.position) > _mfOreCleanerMaxDistance then
		self.MFTooFar = true
	else
		self.MFTooFar = false
	end
	-- Set the Ore Cleaner Energy --
	self.ent.energy = 600
	-- Collect Ores --
	if event.tick%_mfOreCleanerExtractionTicks == 0 and self.MFTooFar == false then
		self:collectOres(event)
	end
	-- Update Animation --
	 self:updateAnimation(event)
end

-- Tooltip Infos --
function OC:getTooltipInfos(GUI)
	local ocFrame = GUI.add{type="frame", direction="vertical"}
	ocFrame.style.width = 150

	-- Create the Belongs to Label --
	local belongsToL = ocFrame.add{type="label", caption={"", {"gui-description.BelongsTo"}, ": ", self.player}}
	belongsToL.style.font = "LabelFont"
	belongsToL.style.font_color = _mfOrange
		
	-- Create Labels and Bares --
	local nameLabel = ocFrame.add{type="label", caption={"", {"gui-description.OreCleaner"}}}
	local SpeedLabel = ocFrame.add{type="label", caption={"", {"gui-description.Speed"}, ": ", self:orePerExtraction() * (60/_mfOreCleanerExtractionTicks), " ores/s"}}
	local ChargeLabel = ocFrame.add{type="label", caption={"", {"gui-description.Charge"}, ": ", self.charge}}
	local ChargeBar = ocFrame.add{type="progressbar", value=self.charge/_mfOreCleanerMaxCharge}
	local PurityLabel = ocFrame.add{type="label", caption={"", {"gui-description.Purity"}, ": ", math.floor(self.purity*100)/100}}
	local PurityBar = ocFrame.add{type="progressbar", value=self.purity/100}
	
	-- Update Style --
	nameLabel.style.bottom_margin = 5
	SpeedLabel.style.font = "LabelFont"
	ChargeLabel.style.font = "LabelFont"
	PurityLabel.style.font = "LabelFont"
	nameLabel.style.font_color = {108, 114, 229}
	SpeedLabel.style.font_color = {39,239,0}
	ChargeLabel.style.font_color = {39,239,0}
	ChargeBar.style.color = {176,50,176}
	PurityLabel.style.font_color = {39,239,0}
	PurityBar.style.color = {255, 255, 255}
	
	-- Create the Mobile Factory Too Far Label --
	if self.MFTooFar == true then
		local mfTooFarL = ocFrame.add{type="label", caption={"", {"gui-description.MFTooFar"}}}
		mfTooFarL.style.font = "LabelFont"
		mfTooFarL.style.font_color = _mfRed
	end
	
	if canModify(getPlayer(GUI.player_index).name, self.ent) == false then return end
	
	-- Create the targeted Inventory label --
	local targetLabel = ocFrame.add{type="label", caption={"", {"gui-description.MSTarget"}, ":"}}
	targetLabel.style.top_margin = 7
	targetLabel.style.font = "LabelFont"
	targetLabel.style.font_color = {108, 114, 229}

	local invs = {{"gui-description.All"}}
	local selectedIndex = 1
	local i = 1
	for k, deepStorage in pairs(global.deepStorageTable) do
		if deepStorage ~= nil and deepStorage.ent ~= nil and Util.canUse(self.player, deepStorage.ent) then
			i = i + 1
			local itemText = {"", " (", {"gui-description.Empty"}, " - ", deepStorage.player, ")"}
			if deepStorage.filter ~= nil and game.item_prototypes[deepStorage.filter] ~= nil then
				itemText = {"", " (", game.item_prototypes[deepStorage.filter].localised_name, " - ", deepStorage.player, ")"}
			elseif deepStorage.inventoryItem ~= nil and game.item_prototypes[deepStorage.inventoryItem] ~= nil then
				itemText = {"", " (", game.item_prototypes[deepStorage.inventoryItem].localised_name, " - ", deepStorage.player, ")"}
			end
			invs[k+1] = {"", {"gui-description.DS"}, " ", tostring(deepStorage.ID), itemText}
			if self.selectedInv == deepStorage then
				selectedIndex = i
			end
		end
	end
	if selectedIndex ~= nil and selectedIndex > table_size(invs) then selectedIndex = nil end
	local invSelection = ocFrame.add{type="list-box", name="OC" .. self.ent.unit_number, items=invs, selected_index=selectedIndex}
	invSelection.style.width = 100
end

-- Change the Targeted Inventory --
function OC:changeInventory(ID)
	-- Check the ID --
	if ID == nil then
		self.selectedInv = nil
		return
	end
	-- Select the Inventory --
	self.selectedInv = nil
	for k, deepStorage in pairs(global.deepStorageTable) do
		if valid(deepStorage) == true then
			if ID == deepStorage.ID then
				self.selectedInv = deepStorage
			end
		end
	end
end

-- Add a Quatron Charge --
function OC:addQuatron(level)
	self.totalCharge = self.totalCharge + 1
	self.charge = self.charge + 100
	self.purity = math.ceil(((self.purity * self.totalCharge) + level) / (self.totalCharge + 1))
end

-- Get the number of Ores per extraction --
function OC:orePerExtraction()
	return math.floor(self.purity * _mfOreCleanerOrePerExtraction)
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
	-- Test if the Mobile Factory and the Ore Cleaner are valid --
	if valid(self) == false or valid(self.MF) == false then return end
	-- Return if the Ore Table is empty --
	if table_size(self.oreTable) <= 0 then return end
	-- Return if there are not Quatron Charge remaining --
	if self.charge <= 0 then return end
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
	local oreName = orePath.prototype.mineable_properties.products[1].name
	-- Check if a Name was found --
	if oreName == nil then return end
	-- Try to find a Deep Storage if the Selected Inventory is All --
	local dataInv = self.selectedInv
	if dataInv == nil then
		for k, dp in pairs(global.deepStorageTable) do
			if self.player == dp.player and dp:canAccept(oreName) == true then
				dataInv = dp
			end
		end
	end
	-- Check the Data Inventory --
	if dataInv == nil or getmetatable(dataInv) == nil then return end
	-- Check if the Ore type is the same as the selected Inventory --
	if dataInv:canAccept(oreName) == false then return end
	-- Extract Ore --
	local oreExtracted = math.min(self:orePerExtraction(), orePath.amount)
	-- Add Ores to the Inventory --
	dataInv:addItem(oreName, oreExtracted)
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
		table.remove(self.oreTable, randomNum)
	end
end

-- Update the Animation --
function OC:updateAnimation(event)
	-- Test if they was any extraction since the last tick --
	if event.tick - self.lastExtraction > _mfOreCleanerExtractionTicks + 10 and self.animID ~= 0 then
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
		-- Make the transfer Beam --
		self.ent.surface.create_entity{name="OCBigBeam", duration=16, position=self.ent.position, target=self.MF.ent.position, source={self.ent.position.x-0.3,self.ent.position.y-4}}
		return
	-- If they was extraction but the animation doesn't exist --
	elseif event.tick - self.lastExtraction <= _mfOreCleanerExtractionTicks + 10 and self.animID == 0 then
		-- Create the Orb Animation --
		self.animID = rendering.draw_animation{animation="RedEnergyOrb", target={self.ent.position.x,self.ent.position.y - 3.25}, surface=self.ent.surface, render_layer=144}
		-- I don't know what this do, but it work (reset the animation) --
		rendering.set_animation_offset(self.animID, 240 - (event.tick%240))
		self.animTick = event.tick
	-- Make the Beam if the animation ended --
	elseif (event.tick - self.animTick)%240 == 0 and self.animID ~= 0 then
		-- Make the transfer Beam --
		self.ent.surface.create_entity{name="OCBigBeam", duration=16, position=self.ent.position, target=self.MF.ent.position, source={self.ent.position.x-0.3,self.ent.position.y-4}}
	end
end












