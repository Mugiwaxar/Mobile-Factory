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
	t.entID = object.unit_number
	t.dataNetwork = t.MF.dataNetwork
	-- Draw the state Sprite --
	t.stateSprite = rendering.draw_sprite{sprite="NetworkExplorerSprite1", target=object, surface=object.surface, render_layer=131}
	UpSys.addObj(t)
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
	if self.networkAccessPoint ~= nil and self.ent ~= nil and self.ent.valid == true then
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
	if valid(self.networkAccessPoint) == false or self.dataNetwork ~= self.networkAccessPoint.dataNetwork then
		self.networkAccessPoint = self.dataNetwork:getCloserNAP(self)
		if self.networkAccessPoint ~= nil then
			self.networkAccessPoint.objTable[self.ent.unit_number] = self
		end
	end

	-- Set Active or Not --
	if self.networkAccessPoint ~= nil and EI.energy(self.networkAccessPoint) > 0 then
		self:setActive(true)
	else
		self:setActive(false)
    end

    -- Stop if not active --
    if self.active == false then return end

end

-- Tooltip Infos --
function NE:getTooltipInfos(GUITable, mainFrame, justCreated)

	-- Get the MFPlayer --
	local MFPlayer = GUITable.MFPlayer

	-- Create the Data Network Frame --
	DN.addDataNetworkFrame(GUITable, mainFrame, self, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.NetworkExplorer"}

		-- Set the Main Frame Height --
		mainFrame.style.height = 450

		-- Get all Locals --
		self:getLocals(GUITable, MFPlayer)

		-- Create the Network Inventory Frame --
		local inventoryFrame = GAPI.addFrame(GUITable, "InventoryFrame", mainFrame, "vertical", true)
		inventoryFrame.style = "MFFrame1"
		inventoryFrame.style.vertically_stretchable = true
		inventoryFrame.style.left_padding = 3
		inventoryFrame.style.right_padding = 3
		inventoryFrame.style.left_margin = 3
		inventoryFrame.style.right_margin = 3

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", inventoryFrame, {"gui-description.NetworkInventory"})

		-- Create the Network Inventory Scroll Pane --
		local inventoryScrollPane = GAPI.addScrollPane(GUITable, "InventoryScrollPane", inventoryFrame, 500, true)
		inventoryScrollPane.style = "MF_Inventory_scroll_pan"
		inventoryScrollPane.style.minimal_width = 308
		inventoryScrollPane.style.vertically_stretchable = true
		inventoryScrollPane.style.bottom_margin = 3

		-- Create the Player Inventory Frame --
		local playerInventoryFrame = GAPI.addFrame(GUITable, "PlayerInventoryFrame", mainFrame, "vertical", true)
		playerInventoryFrame.style = "MFFrame1"
		playerInventoryFrame.style.vertically_stretchable = true
		playerInventoryFrame.style.left_padding = 3
		playerInventoryFrame.style.right_padding = 3
		playerInventoryFrame.style.right_margin = 3

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", playerInventoryFrame, {"gui-description.PlayerInventory"})

		-- Create the Player Inventory Scroll Pane --
		local playerInventoryScrollPane = GAPI.addScrollPane(GUITable, "PlayerInventoryScrollPane", playerInventoryFrame, 500, true)
		playerInventoryScrollPane.style = "MF_Inventory_scroll_pan"
		playerInventoryScrollPane.style.minimal_width = 308
		playerInventoryScrollPane.style.vertically_stretchable = true
		playerInventoryScrollPane.style.bottom_margin = 3

		-- Create the Information Frame --
		local informationFrame = GAPI.addFrame(GUITable, "InformationFrame", mainFrame, "vertical", true)
		informationFrame.style = "MFFrame1"
		informationFrame.style.vertically_stretchable = true
		informationFrame.style.left_padding = 3
		informationFrame.style.right_padding = 3
		informationFrame.style.right_margin = 3
		informationFrame.style.minimal_width = 200

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", informationFrame, {"gui-description.Information"})

		-- Create the Search Flow --
		local searchFlow = GAPI.addFlow(GUITable, "", informationFrame, "horizontal")
		searchFlow.style.vertical_align = "center"
		
		-- Create the Search Label --
		GAPI.addLabel(GUITable, "Label", searchFlow, {"", {"gui-description.NEItemSearchText"}, ": "}, nil, {"gui-description.NEItemSearchTextTT"}, false, nil, _mfLabelType.yellowTitle)
		
		-- Create the Search TextField
		local textField = GAPI.addTextField(GUITable, "N.E.SearchTextField", searchFlow, "", "", true, false, false, false, false)
		textField.style.maximal_width = 130

		-- Add the Line --
		GAPI.addLine(GUITable, "", informationFrame, "horizontal")

		-- Create the Inventory Labels --
		GAPI.addLabel(GUITable, "DNCapacityLabel", informationFrame, {"gui-description.Unknow"}, _mfOrange, "", true)

		-- Add the Line --
		GAPI.addLine(GUITable, "", informationFrame, "horizontal")

		-- Create the Help Table --
		local helpTable = GAPI.addTable(GUITable, "", informationFrame, 1)

		-- Create the Information Labels --
		GAPI.addLabel(GUITable, "", helpTable, {"gui-description.NEHelpText1"}, _mfWhite)
		GAPI.addLabel(GUITable, "", helpTable, {"gui-description.NEHelpText2"}, _mfWhite)
		GAPI.addLabel(GUITable, "", helpTable, {"gui-description.NEHelpText3"}, _mfWhite)
		GAPI.addLabel(GUITable, "", helpTable, {"gui-description.NEHelpText4"}, _mfWhite)
		GAPI.addLabel(GUITable, "", helpTable, {"gui-description.NEHelpText5"}, _mfWhite)
		GAPI.addLabel(GUITable, "", helpTable, {"gui-description.NEHelpText6"}, _mfWhite)

	end

	-- Get the Scroll Pane and the Text Field --
	local inventoryScrollPane = GUITable.vars.InventoryScrollPane
	local playerInventoryScrollPane = GUITable.vars.PlayerInventoryScrollPane
	local textField = GUITable.vars["N.E.SearchTextField"]

	-- Clear the Scroll Panes --
	inventoryScrollPane.clear()
	playerInventoryScrollPane.clear()

	-- Check the Data Network --
	if self.active == false then return end

	-- Create the Data Network Inventory --
	self:createDNInventory(GUITable, inventoryScrollPane, textField.text)

	-- Create the Player Inventory --
	self:createPlayerInventory(GUITable, MFPlayer, playerInventoryScrollPane, textField.text)

	-- Update the Network Capacity Label --
	local inv = self.dataNetwork.invObj
	GUITable.vars.DNCapacityLabel.caption = {"" , {"gui-description.NENetworkCapacity"}, " [color=yellow]", Util.toRNumber(inv.usedCapacity), "/", Util.toRNumber(inv.maxCapacity), "[/color]"}
	GUITable.vars.DNCapacityLabel.tooltip = "[color=yellow]" .. inv.usedCapacity .. "/" .. inv.maxCapacity .. "[/color]"

end

-- Request Items/Fluids Locals --
function NE:getLocals(GUITable, MFPlayer)
	-- Create the Localised name List --
	GUITable.vars.tmpLocal = {}
	-- Get Items Local --
	for name, _ in pairs(self.dataNetwork.invObj.inventory) do
		MFPlayer.ent.request_translation(Util.getLocItemName(name))
	end
	-- Get Fluid Local --
	for name, _ in pairs(MFPlayer.ent.get_main_inventory().get_contents()) do
		MFPlayer.ent.request_translation(Util.getLocItemName(name))
	end
	-- Get Deep Storages Items Local --
	for _, deepStorage in pairs(self.dataNetwork.DSRTable) do
		if deepStorage.inventoryItem ~= nil or deepStorage.filter ~= nil then
			MFPlayer.ent.request_translation(Util.getLocItemName(deepStorage.inventoryItem or deepStorage.filter))
		end
	end
	-- Get Deep Tank Fluids Local --
	for _, deepTank in pairs(self.dataNetwork.DTKTable) do
		if deepTank.inventoryFluid ~= nil or deepTank.filter ~= nil then
			MFPlayer.ent.request_translation(Util.getLocFluidName(deepTank.inventoryFluid or deepTank.filter))
		end
	end
end

-- Create the Data Network Inventory --
function NE:createDNInventory(GUITable, inventoryScrollPane, searchText)

	-- Get the Mobile Factory --
	local MF = self.MF

	-- Create the Table --
	local tableList = GAPI.addTable(GUITable, "", inventoryScrollPane, 8)

	-- Look for all Deep Tanks --
	for _, DT in pairs(MF.dataNetwork.DTKTable) do
		
		-- Check the Deep Tank --
		if DT.ent == nil or DT.ent.valid == false or DT.inventoryFluid == nil or DT.inventoryCount == nil or DT.inventoryCount == 0 then goto continue end

		-- Check the Search Text --
		if GUITable.vars.tmpLocal ~= nil and Util.getLocFluidName(DT.inventoryFluid)[1] ~= nil then
			local locName = GUITable.vars.tmpLocal[Util.getLocFluidName(DT.inventoryFluid)[1]]
			if searchText ~= nil and searchText ~= "" and locName ~= nil and string.match(string.lower(locName), string.lower(searchText)) == nil then goto continue end
		end

		-- Create the Button --
		local buttonText = {"", "[color=purple]", Util.getLocFluidName(DT.inventoryFluid), "[/color]\n[color=yellow]", Util.toRNumber(DT.inventoryCount), "[/color]"}
		local button = GAPI.addButton(GUITable, "N.E.DTK," .. DT.ent.unit_number, tableList, "fluid/" .. DT.inventoryFluid, "fluid/" .. DT.inventoryFluid, buttonText, 37, false, true, DT.inventoryCount)
		button.style = "MF_Button_Purple"
		button.style.padding = 0
		button.style.margin = 0

		::continue::

	end

	-- Look for all Deep Storages --
	for _, DSR in pairs(MF.dataNetwork.DSRTable) do
		-- Check the Deep Storage --
		if DSR.ent == nil or DSR.ent.valid == false or DSR.inventoryItem == nil or DSR.inventoryCount == nil or DSR.inventoryCount == 0 then goto continue end

		-- Check the Search Text --
		if GUITable.vars.tmpLocal ~= nil and Util.getLocItemName(DSR.inventoryItem)[1] ~= nil then
			local locName = GUITable.vars.tmpLocal[Util.getLocItemName(DSR.inventoryItem)[1]]
			if searchText ~= nil and searchText ~= "" and locName ~= nil and string.match(string.lower(locName), string.lower(searchText)) == nil then goto continue end
		end

		-- Create the Button --
		local buttonText = {"", "[color=green]", Util.getLocItemName(DSR.inventoryItem), "[/color]\n[color=yellow]", Util.toRNumber(DSR.inventoryCount), "[/color]"}
		local button = GAPI.addButton(GUITable, "N.E.DSR" .. DSR.ent.unit_number, tableList, "item/" .. DSR.inventoryItem, "item/" .. DSR.inventoryItem, buttonText, 37, false, true, DSR.inventoryCount, nil, {ID=DSR.ent.unit_number})
		button.style = "shortcut_bar_button_green"
		button.style.padding = 0
		button.style.margin = 0

		::continue::
	end

	-- Look for all Data Network Inventory Items --
	for name, count in pairs(MF.II.inventory) do
		
		-- Check the Item --
		if count == nil or count == 0 then goto continue end

		-- Check the Search Text --
		if GUITable.vars.tmpLocal ~= nil and Util.getLocItemName(name)[1] ~= nil then
			local locName = GUITable.vars.tmpLocal[Util.getLocItemName(name)[1]]
			if searchText ~= nil and searchText ~= "" and locName ~= nil and string.match(string.lower(locName), string.lower(searchText)) == nil then goto continue end
		end

		-- Create the Button --
		local buttonText = {"", "[color=blue]", Util.getLocItemName(name), "[/color]\n[color=yellow]", Util.toRNumber(count), "[/color]"}
		local button = GAPI.addButton(GUITable, "N.E.Inv" .. name, tableList, "item/" .. name, "item/" .. name, buttonText, 37, false, true, count, nil, {ID=self.entID, name=name})
		button.style = "shortcut_bar_button_blue"
		button.style.padding = 0
		button.style.margin = 0
		
		::continue::

	end

end

-- Create the Player Inventory --
function NE:createPlayerInventory(GUITable, MFPlayer, inventoryScrollPane, searchText)

	-- Create the Table --
	local tableList = GAPI.addTable(GUITable, "", inventoryScrollPane, 8)

	-- Look for all Player Inventory Items --
	for name, count in pairs(MFPlayer.ent.get_main_inventory().get_contents()) do
		
		-- Check the Item --
		if count == nil or count == 0 then goto continue end

		-- Stop if this is an Item with Tags--
        if game.item_prototypes[name].type == "item-with-tags" then goto continue end

		-- Check the Search Text --
		if GUITable.vars.tmpLocal ~= nil and Util.getLocItemName(name)[1] ~= nil then
			local locName = GUITable.vars.tmpLocal[Util.getLocItemName(name)[1]]
			if searchText ~= nil and searchText ~= "" and locName ~= nil and string.match(string.lower(locName), string.lower(searchText)) == nil then goto continue end
		end

		-- Create the Button --
		local buttonText = {"", "[color=blue]", Util.getLocItemName(name), "[/color]\n[color=yellow]", Util.toRNumber(count), "[/color]"}
		local button = GAPI.addButton(GUITable, "N.E.PInv" .. name, tableList, "item/" .. name, "item/" .. name, buttonText, 37, false, true, count, nil, {ID=self.entID, name=name})
		button.style = "shortcut_bar_button_blue"
		button.style.padding = 0
		button.style.margin = 0
		
		::continue::

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
	if item == nil then return end
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
	if item == nil then return end
	local half = (count or 1) < 1 and true or false
	if count == nil or count <= 0 then count = game.item_prototypes[item].stack_size end

	-- Try to transfer Items --
	local amount = math.min(DNInv:hasItem(item), count)
	if half == true and amount >= 2 then amount = math.floor(amount/2) end
	if amount <= 0 then amount = 1 end

	-- Send the Items to the Player Inventory --
	if amount <= 0 then return end
	local inserted = inv.insert({name=item, count=amount})

	-- Remove the Items from the Deep Storage --
	DNInv:getItem(item, inserted)

end

-- Transfer Items from the Player Inventory --
function NE.transferItemsFromPInv(PInv, NE, item, count)

	-- Check all values --
	if PInv == nil or NE == nil then return end
	local DNInv = NE.dataNetwork.invObj
	if item == nil then return end
	local half = (count or 1) < 1 and true or false
	if count == nil or count <= 0 then count = game.item_prototypes[item].stack_size end

	-- Try to transfer Items --
	local amount = math.min(PInv.get_item_count(item), count)
	if half == true then amount = math.floor(amount/2) end
	if amount <= 0 then amount = 1 end

	local amountOriginal = amount

	-- Try to send the Items to a Deep Storage --
	for _, deepStorage in pairs(NE.dataNetwork.DSRTable) do
		local availableSpace = deepStorage:availableSpace()
		if availableSpace > 0 and deepStorage:canAccept(item, availableSpace) then
			amount = amount - deepStorage:addItem(item, math.min(availableSpace, amount))
		end
	end

	-- Try to send the Items to the Data Network inventory --
	if amount > 0 then
		amount = amount - DNInv:addItem(item, amount)
	end

	local inserted = amountOriginal - amount
	-- Remove the Item from the Player Inventory --
	if inserted > 0 then
		PInv.remove({name=item, count=inserted})
	end

end

-- Called if the Player interacted with the GUI --
function NE.interaction(event, playerIndex)
	-- If this is the Search Text Field (Used to Update all GUIs)  --
	if string.match(event.element.name, "N.E.SearchTextField") then
		return
	end
	-- If a Item Button is clicked --
	local count = 1
	if event.alt == true then count = 10 end
	if event.control == true then count = 100 end
	if event.shift == true then count = nil end
	if event.button == defines.mouse_button_type.right then count = -1 end
	if event.button == defines.mouse_button_type.right and event.shift == true then count = 99999999 end
	-- If it's a Deep Tank, do nothing --
	if string.match(event.element.name, "N.E.DTK") then
		return
	end
	-- If it's a Deep Storage --
	if string.match(event.element.name, "N.E.DSR") then
		local objId = event.element.tags.ID
		local obj = global.deepStorageTable[objId]
		NE.transferItemsFromDS(obj, getMFPlayer(playerIndex).ent.get_main_inventory(), count)
		return
	end
	-- If it's a Data Network Inventory --
	if string.match(event.element.name, "N.E.Inv") then
		local objId = event.element.tags.ID
		local obj = global.networkExplorerTable[objId]
		NE.transferItemsFromDNInv(obj, getMFPlayer(playerIndex).ent.get_main_inventory(), event.element.tags.name, count)
		return
	end
	-- If it's a player Inventory --
	if string.match(event.element.name, "N.E.PInv") then
		local objId = event.element.tags.ID
		local obj = global.networkExplorerTable[objId]
		NE.transferItemsFromPInv(getMFPlayer(playerIndex).ent.get_main_inventory(), obj, event.element.tags.name, count)
		return
	end
end