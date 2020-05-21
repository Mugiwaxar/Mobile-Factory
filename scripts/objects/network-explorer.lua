-- NETWORK EXPLORER OBJECT --

-- Create the Network Explorer base object --
NE = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
    stateSprite = 0,
	active = false,
	consumption = _mfNEQuatronDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
	networkAccessPoint = nil
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
	t.dataNetwork = t.MF.dataNetwork
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
	-- Remove from the Network Access Point --
	if self.networkAccessPoint ~= nil then
		self.networkAccessPoint.objTable[self.ent.unit_number] = nil
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

    -- Try to find a Network Access Point if needed --
	if valid(self.networkAccessPoint) == false then
		self.networkAccessPoint = self.dataNetwork:getCloserNAP(self)
		if self.networkAccessPoint ~= nil then
			self.networkAccessPoint.objTable[self.ent.unit_number] = self
		end
	end

	-- Set Active or Not --
	if self.networkAccessPoint ~= nil and self.networkAccessPoint.outOfQuatron == false and self.networkAccessPoint.quatronCharge > 0 then
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

	-- Get the Flows --
	local inventoryFlow = GUIObj.InventoryFlow
	local inventoryScrollPane = GUIObj.InventoryScrollPane
	local playerInventoryScrollPane = GUIObj.PlayerInventoryScrollPane


	if justCreated == true then

		-- Create the Localised name List --
		GUIObj.MFPlayer.varTable.tmpLocal = {}
		for name, count in pairs(self.dataNetwork.invObj.inventory) do
			GUIObj.MFPlayer.ent.request_translation(Util.getLocItemName(name))
		end
		for name, count in pairs(GUIObj.MFPlayer.ent.get_main_inventory().get_contents()) do
			GUIObj.MFPlayer.ent.request_translation(Util.getLocItemName(name))
		end
		for k, deepStorage in pairs(self.MF.DSRTable) do
			if deepStorage.inventoryItem ~= nil or deepStorage.filter ~= nil then
				GUIObj.MFPlayer.ent.request_translation(Util.getLocItemName(deepStorage.inventoryItem or deepStorage.filter))
			end
		end
		for k, deepTank in pairs(self.MF.DTKTable) do
			if deepTank.inventoryFluid ~= nil or deepTank.filter ~= nil then
				GUIObj.MFPlayer.ent.request_translation(Util.getLocFluidName(deepTank.inventoryFluid or deepTank.filter))
			end
		end

		-- Create the Inventory Title and Flow --
		local inventoryFrame = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.NetworkInventory"}, _mfOrange)
		inventoryFlow = GUIObj:addFlow("InventoryFlow", inventoryFrame, "vertical", true)

		-- Create the Inventory Scroll Pane --
		inventoryScrollPane = GUIObj:addScrollPane("InventoryScrollPane", inventoryFrame, 500, true)
		inventoryScrollPane.style = "MF_Inventory_scroll_pan"
		inventoryScrollPane.style.minimal_width = 308
		inventoryScrollPane.style.minimal_height = 400
		inventoryScrollPane.style.vertically_stretchable = true

		-- Create the Player Inventory Title --
		local playerInventoryTitle = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.PlayerInventory"}, _mfOrange)

		-- Create the Player Inventory Scroll Pane --
		playerInventoryScrollPane = GUIObj:addScrollPane("PlayerInventoryScrollPane", playerInventoryTitle, 500, true)
		playerInventoryScrollPane.style = "MF_Inventory_scroll_pan"
		playerInventoryScrollPane.style.minimal_width = 308
		playerInventoryScrollPane.style.minimal_height = 400
		playerInventoryScrollPane.style.vertically_stretchable = true

		-- Create the Information Title --
		local titleFrame = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Information"}, _mfOrange)

		-- Create the Search Flow --
		local flow = GUIObj:addFlow("", titleFrame, "horizontal")
		flow.style.vertical_align = "center"
		flow.style.bottom_padding = 10

		-- Create the Search Label --
		GUIObj:addLabel("Label", flow, {"", {"gui-description.ItemSearchText"}, ":"}, _mfOrange, "", false)

		-- Create the Search TextField
		local textField = GUIObj:addTextField(self.entID .. ":SearchTextField", flow, "", {"gui-description.ItemSearchTextTT"}, true, false, false, false, false)
		textField.style.maximal_width = 130

		-- Create the Information Labels --
		GUIObj:addLabel("", titleFrame, {"gui-description.ItemTransferText"}, _mfGreen)
		GUIObj:addLabel("", titleFrame, {"gui-description.ItemTransferText2"}, _mfGreen)
		GUIObj:addLabel("", titleFrame, {"gui-description.ItemTransferText3"}, _mfGreen)
		GUIObj:addLabel("", titleFrame, {"gui-description.ItemTransferText4"}, _mfGreen)
		GUIObj:addLabel("", titleFrame, {"gui-description.ItemTransferText5"}, _mfGreen)
		GUIObj:addLabel("", titleFrame, {"gui-description.ItemTransferText6"}, _mfGreen)

	end

	-- Clear the Flow and the Scroll Panes --
	inventoryFlow.clear()
	inventoryScrollPane.clear()
	playerInventoryScrollPane.clear()

	-- Check the Data Network --
	if self.active == false then return end

	-- Get the Textfield Text --
	local searchText = nil
	if GUIObj[self.entID .. ":SearchTextField"] ~= nil then
		searchText = GUIObj[self.entID .. ":SearchTextField"].text
	end

	local inv = self.dataNetwork.invObj
	GUIObj:addDualLabel(inventoryFlow, {"", {"gui-description.INVTotalItems"}, ":"}, Util.toRNumber(inv.usedCapacity) .. "/" .. Util.toRNumber(inv.maxCapacity), _mfOrange, _mfGreen, nil, nil, inv.usedCapacity .. "/" .. inv.maxCapacity)

	-- Create the Inventory List --
	createDNInventoryFrame(GUIObj, inventoryScrollPane, GUIObj.MFPlayer, "NE," .. self.entID .. ",", self.dataNetwork.invObj, 8, true, true, true, searchText, self)

	-- Create the Player Inventory List --
	createPlayerInventoryFrame(GUIObj, playerInventoryScrollPane, GUIObj.MFPlayer, 8, "NE," .. self.entID .. ",", searchText)
	
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

-- Transfer Items from Data Network Inventory --
function NE.transferItemsFromDNInv(NE, inv, item, count)

	-- Check all values --
	if NE == nil or inv == nil then return end
	local DNInv = NE.dataNetwork.invObj
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
	if PInv == nil or NE == nil then return end
	local DNInv = NE.dataNetwork.invObj
	if item == nil or game.item_prototypes[item] == nil then return end
	local half = (count or 1) < 1 and true or false
	if count == nil or count <= 0 then count = game.item_prototypes[item].stack_size end
	local inserted = 0

	-- Try to transfer Items --
	local amount = math.min(PInv.get_item_count(item), count)
	if half == true then amount = math.floor(amount/2) end

	-- Try to send the Items to a Deep Storage --
	for k, deepStorage in pairs(NE.MF.DSRTable) do
		if deepStorage:canAccept(item) then
			inserted = deepStorage:addItem(item, amount)
			break
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