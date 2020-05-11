-- MINING JET FLAG --

-- Create the Mining Jet Flag base Object --
MJF = {
	ent = nil,
	player = "",
	MF = nil,
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
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
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

-- Copy Settings --
function MJF:copySettings(obj)
	if obj.selectedInv ~= nil then
		self.selectedInv = obj.selectedInv
	end
end

-- Update --
function MJF:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end
	-- Send Inventory to the Targed --
	if game.tick - self.lastInventorySend > 300 then
		self:sendInventory()
		self.lastInventorySend = game.tick
	end
end

-- Tooltip Infos --
function MJF:getTooltipInfos(GUIObj, gui, justCreated)

	-- Create the Title --
	local frame = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Information"}, _mfOrange)

	-- Create the Resource Label --
	GUIObj:addDualLabel(frame, {"", {"gui-description.NumberOfOrePath"}, ": "}, table_size(self.oreTable), _mfOrange, _mfGreen)

	-- Create the Inventory Full Label --
	if self.TargetInventoryFull == true then
		GUIObj:addLabel("", frame, {"gui-description.InvalidTargetInventory"}, _mfRed)
	end

	if self.MFNotFound == true then
		GUIObj:addLabel("", frame, {"gui-description.MFNotFound"}, _mfRed)
	end

	-- Create the Inventory Title --
	local invFrame = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Inventory"}, _mfOrange)
	invFrame.visible = false

	-- Create the Items Table --
	local table = GUIObj:addTable("", invFrame, 5)

	-- Create the Inventory Frame --
	for name, count in pairs(self.inventory) do
		invFrame.visible = true
		-- Check the Item --
		if name == nil or count == nil or count == 0 or game.item_prototypes[name] == nil then goto continue end
		-- Create the Button
		Util.itemToFrame(name, count, GUIObj, table)
		::continue::
	end

	-- Stop of the Settings can't be Modified --
	if canModify(getPlayer(gui.player_index).name, self.ent) == false or justCreated ~= true then return end

	-- Create the Title --
	local settingFrame = GUIObj:addTitledFrame("", GUIObj.SettingsFrame, "vertical", {"gui-description.Settings"}, _mfOrange)
	GUIObj.SettingsFrame.visible = true

	-- Create the Select Deep Storage Label --
	GUIObj:addLabel("", settingFrame, {"", {"gui-description.TargetedStorage"}}, _mfOrange)

	local invs = {{"gui-description.All"}}
	local selectedIndex = 1
	local i = 1
	for k, deepStorage in pairs(global.deepStorageTable) do
		if deepStorage ~= nil and deepStorage.ent ~= nil and Util.canUse(getMFPlayer(self.player), deepStorage) then
			i = i + 1
			local itemText = ""
			if deepStorage.inventoryItem ~= nil and game.item_prototypes[deepStorage.inventoryItem] ~= nil then
				itemText = {"", " (", game.item_prototypes[deepStorage.inventoryItem].localised_name, " - ", deepStorage.player, ")"}
			end
			invs[k+1] = {"", {"gui-description.DS"}, " ", tostring(deepStorage.ID), itemText}
			if self.selectedInv == deepStorage then
				selectedIndex = i
			end
		end
	end
	if selectedIndex ~= nil and selectedIndex > table_size(invs) then selectedIndex = nil end
	GUIObj:addDropDown("MJF" .. self.ent.unit_number, settingFrame, invs, selectedIndex)
end

-- Change the Targeted Inventory --
function MJF:changeInventory(ID)
	-- Check the ID --
	if ID == nil then self.selectedInv = nil end
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
	radius = radius / 2
	if radius <= 1 then radius = 1 end
	local area = {{self.ent.position.x - radius, self.ent.position.y - radius},{self.ent.position.x + radius, self.ent.position.y + radius}}
	self.oreTable = self.ent.surface.find_entities_filtered{area=area, type="resource"}
	-- Remove Fluid Path from the Table --
	for k, path in pairs(self.oreTable) do
		if path.prototype.mineable_properties.products[1].type ~= "item" then
			self.oreTable[k] = nil
		end
	end
	
end

-- Get a new Ore Path to Mine --
function MJF:getOrePath()
	-- Get a random Path --
	if table_size(self.oreTable) <= 0 then return nil end
	local i = math.random(1, table_size(self.oreTable))
	local orePath = self.oreTable[i]
	if orePath == nil then
		for k, path in pairs(self.oreTable) do
			if path ~= nil and path.valid == true then return path end
			if path ~= nil and path.valid == false then self:removeOrePath(path) end
		end
	elseif orePath.valid == false then
		self:removeOrePath(orePath)
	else
		return orePath
	end
	return nil
end

-- Remove an Ore Path from the Ore Table --
function MJF:removeOrePath(orePath)
	for k, path in pairs(self.oreTable) do
		if path == orePath then
			if table_size(self.oreTable) <= 1 then
				self.oreTable = {}
			else
				table.remove(self.oreTable, k)
			end
			
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
	if self.MF.ent == nil or self.MF.ent.valid == false then
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
	
	-- Check the Data Inventory --
	if dataInv ~= 0 and (dataInv == nil or getmetatable(dataInv) == nil) then return end

	-- Itinerate the Inventory --
	for name, count in pairs(self.inventory) do
		if dataInv == 0 then
			-- Send Ore to all Deep Storage --
			for k, dp in pairs(global.deepStorageTable) do
				if self.player == dp.player then
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
		self.ent.surface.create_entity{name="BlueBeam", duration=20, position=self.ent.position, target=self.MF.ent.position, source={self.ent.position.x,self.ent.position.y}}
	end
	
	-- No enought space inside the Targeted Inventory --
	if table_size(self.inventory) > 0 then
		self.TargetInventoryFull = true
		return
	else
		self.TargetInventoryFull = false
	end
end













