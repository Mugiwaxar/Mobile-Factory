-- NETWORK EXPLORER OBJECT --

-- Create the Network Explorer base object --
NE = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
    stateSprite = 0,
	active = false,
	consumption = _mfNEEnergyDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
    dataNetwork = nil
}

-- Constructor --
function NE:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = NE
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
    UpSys.addObj(t)
    -- Draw the state Sprite --
	t.stateSprite = rendering.draw_sprite{sprite="NetworkExplorerSprite1", target=object, surface=object.surface, render_layer=131}
	return t
end

-- Reconstructor --
function NE:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = NE
	setmetatable(object, mt)
end

-- Destructor --
function NE:remove()
	-- Destroy the Sprites --
	rendering.destroy(self.stateSprite)
	-- Remove from the Update System --
	UpSys.removeObj(self)
	-- Remove from the Data Network --
	if self.dataNetwork ~= nil and getmetatable(self.dataNetwork) ~= nil then
		self.dataNetwork:removeObject(self)
	end
end

-- Is valid --
function NE:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function NE:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
    end

    -- Try to find a connected Data Network --
	local obj = Util.getConnectedDN(self)
	if obj ~= nil and valid(obj.dataNetwork) then
		self.dataNetwork = obj.dataNetwork
		self.dataNetwork:addObject(self)
	else
		if valid(self.dataNetwork) then
			self.dataNetwork:removeObject(self)
		end
		self.dataNetwork = nil
	end

	-- Set Active or Not --
	if self.dataNetwork ~= nil and self.dataNetwork:isLive() == true then
		self:setActive(true)
	else
		self:setActive(false)
    end

    -- Stop if not active --
    if self.active == false then return end

end

-- Tooltip Infos --
function NE:getTooltipInfos(GUIObj, gui, justCreated)

	-- Create the Data Network Frame --
	GUIObj:addDataNetworkFrame(gui, self)

	-- Check if the Parameters can be modified --
	if canModify(getPlayer(gui.player_index).name, self.player) == false or valid(self.dataNetwork) == false then return end

	-- Get the Textfield Text --
	local searchText = nil
	if GUIObj[self.entID .. ":SearchTextField"] ~= nil then
		searchText = GUIObj[self.entID .. ":SearchTextField"].text
	end

	-- Create the Inventory Title --
	local inventoryFrame = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.NetworkInventory"}, _mfOrange)

	-- Create the total Items Label --
	if self.dataNetwork ~= nil and self.dataNetwork.dataCenter ~= nil and self.dataNetwork.dataCenter.invObj ~= nil then
		local inv = self.dataNetwork.dataCenter.invObj
		GUIObj:addDualLabel(inventoryFrame, {"", {"gui-description.INVTotalItems"}, ":"}, Util.toRNumber(inv.usedCapacity) .. "/" .. Util.toRNumber(inv.maxCapacity), _mfOrange, _mfGreen, nil, nil, inv.usedCapacity .. "/" .. inv.maxCapacity)
	end

	-- Create the Inventory Scroll Pane --
	local inventoryScrollPane = GUIObj:addScrollPane("InventoryScrollPane", inventoryFrame, 500, true)
	inventoryScrollPane.style = "MF_Inventory_scroll_pan"
	inventoryScrollPane.style.minimal_width = 308
	inventoryScrollPane.style.minimal_height = 400
	inventoryScrollPane.style.vertically_stretchable = true

	-- Create the Inventory List --
	createDNInventoryFrame(GUIObj, inventoryScrollPane, GUIObj.MFPlayer, "NE," .. self.entID .. ",", self.dataNetwork.dataCenter.invObj, 8, true, true, true, searchText)

	-- Create the Player Inventory Title --
	local playerInventoryFrame = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.PlayerInventory"}, _mfOrange)

	-- Create the Player Inventory Scroll Pane --
	local playerInventoryScrollPane = GUIObj:addScrollPane("PlayerInventoryScrollPane", playerInventoryFrame, 500, true)
	playerInventoryScrollPane.style = "MF_Inventory_scroll_pan"
	playerInventoryScrollPane.style.minimal_width = 308
	playerInventoryScrollPane.style.minimal_height = 400
	playerInventoryScrollPane.style.vertically_stretchable = true

	-- Create the Player Inventory List --
	createPlayerInventoryFrame(GUIObj, playerInventoryScrollPane, GUIObj.MFPlayer, 8, "NE," .. self.entID .. ",", searchText)

	-- Create the Informations Frame --
	if justCreated == true then

		-- Create the Localised name List --
		GUIObj.MFPlayer.varTable.tmpLocal = {}
		for name, count in pairs(self.dataNetwork.dataCenter.invObj.inventory) do
			GUIObj.MFPlayer.ent.request_translation(Util.getLocItemName(name))
		end
		for name, count in pairs(GUIObj.MFPlayer.ent.get_main_inventory().get_contents()) do
			GUIObj.MFPlayer.ent.request_translation(Util.getLocItemName(name))
		end
		for k, deepStorage in pairs(global.deepStorageTable) do
			if deepStorage.inventoryItem ~= nil or deepStorage.filter ~= nil then
				GUIObj.MFPlayer.ent.request_translation(Util.getLocItemName(deepStorage.inventoryItem or deepStorage.filter))
			end
		end
		for k, deepTank in pairs(global.deepTankTable) do
			if deepTank.inventoryFluid ~= nil or deepTank.filter ~= nil then
				GUIObj.MFPlayer.ent.request_translation(Util.getLocFluidName(deepTank.inventoryFluid or deepTank.filter))
			end
		end

		GUIObj.SettingsFrame.visible = true
		local titleFrame = GUIObj:addTitledFrame("", GUIObj.SettingsFrame, "vertical", {"gui-description.Information"}, _mfOrange)
		local flow = GUIObj:addFlow("", titleFrame, "horizontal")
		GUIObj:addLabel("Label", flow, {"", {"gui-description.ItemSearchText"}, ":"}, _mfOrange, "", false)
		local textField = GUIObj:addTextField(self.entID .. ":SearchTextField", flow, "", {"gui-description.ItemSearchTextTT"}, true, false, false, false, false)
		textField.style.maximal_width = 130
		flow.style.vertical_align = "center"
		flow.style.bottom_padding = 10
		GUIObj:addLabel("", titleFrame, {"gui-description.ItemTransferText"}, _mfGreen)
		GUIObj:addLabel("", titleFrame, {"gui-description.ItemTransferText2"}, _mfGreen)
		GUIObj:addLabel("", titleFrame, {"gui-description.ItemTransferText3"}, _mfGreen)
		GUIObj:addLabel("", titleFrame, {"gui-description.ItemTransferText4"}, _mfGreen)
		GUIObj:addLabel("", titleFrame, {"gui-description.ItemTransferText5"}, _mfGreen)
		GUIObj:addLabel("", titleFrame, {"gui-description.ItemTransferText6"}, _mfGreen)
	end
	
end

-- Set Active --
function NE:setActive(set)
    self.active = set
    if set == true then
        -- Create the Active Sprite --
        rendering.destroy(self.stateSprite)
        self.stateSprite = rendering.draw_sprite{sprite="NetworkExplorerSprite2", target=self.ent, surface=self.ent.surface, render_layer=131}
    else
        -- Create the Inactive Sprite --
        rendering.destroy(self.stateSprite)
        self.stateSprite = rendering.draw_sprite{sprite="NetworkExplorerSprite1", target=self.ent, surface=self.ent.surface, render_layer=131}
    end
end

-- Transfer Items from Deep Storage --
function NE.transferItemsFromDS(DS, inv, count)
	
	-- Check all values --
	if DS == nil or inv == nil then return end
	local item = DS.inventoryItem
	if item == nil or game.item_prototypes[item] == nil then return end
	local half = (count or 1) < 1 and true or false
	if count == nil or count <= 0 then count = game.item_prototypes[item].stack_size end

	-- Try to transfer Items --
	local amount = math.min(DS.inventoryCount, count)
	if half == true and amount >= 2 then amount = math.floor(amount/2) end

	-- Send the Items to the Player Inventory --
	if amount <= 0 then return end
	local inserted = inv.insert({name=item, count=amount})

	-- Remove the Items from the Deep Storage --
	DS:getItem(item, inserted)

end

-- Transfer Items from Data Networl Inventory --
function NE.transferItemsFromDNInv(NE, inv, item, count)

	-- Check all values --
	if NE == nil or NE.dataNetwork == nil or NE.dataNetwork.dataCenter == nil or NE.dataNetwork.dataCenter.invObj == nil or inv == nil then return end
	local DNInv = NE.dataNetwork.dataCenter.invObj
	if item == nil or game.item_prototypes[item] == nil then return end
	local half = (count or 1) < 1 and true or false
	if count == nil or count <= 0 then count = game.item_prototypes[item].stack_size end

	-- Try to transfer Items --
	local amount = math.min(DNInv:hasItem(item), count)
	if half == true and amount >= 2 then amount = math.floor(amount/2) end

	-- Send the Items to the Player Inventory --
	if amount <= 0 then return end
	local inserted = inv.insert({name=item, count=amount})

	-- Remove the Items from the Deep Storage --
	DNInv:getItem(item, inserted)

end

-- Transfer Items from the Player Inventory --
function NE.transferItemsFromPInv(PInv, PName, NE, item, count)

	-- Check all values --
	if PInv == nil or NE == nil or NE.dataNetwork == nil or NE.dataNetwork.dataCenter == nil or NE.dataNetwork.dataCenter.invObj == nil then return end
	local DNInv = NE.dataNetwork.dataCenter.invObj
	if item == nil or game.item_prototypes[item] == nil then return end
	local half = (count or 1) < 1 and true or false
	if count == nil or count <= 0 then count = game.item_prototypes[item].stack_size end
	local inserted = 0

	-- Try to transfer Items --
	local amount = math.min(PInv.get_item_count(item), count)
	if half == true then amount = math.floor(amount/2) end

	-- Try to send the Items to a Deep Storage --
	for k, deepStorage in pairs(global.deepStorageTable) do
		if PName == deepStorage.player then
			if deepStorage:canAccept(item) then
				inserted = deepStorage:addItem(item, amount)
				break
			end
		end
	end

	-- Try to send the Items to the Data Network inventory --
	if inserted == 0 then
		inserted = DNInv:addItem(item, amount)
	end

	-- Remove the Item from the Player Inventory --
	if inserted > 0 then
		PInv.remove({name=item, count=inserted})
	end

end