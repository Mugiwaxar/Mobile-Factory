-- MATTER INTERACTOR OBJECT --

-- Create the Matter Interactor base object --
MI = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
    stateSprite = 0,
	active = false,
	consumption = _mfMIEnergyDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
    dataNetwork = nil,
    selectedFilter = nil,
    selectedInv = 0,
    selectedMode = "input" -- input or output
}

-- Constructor --
function MI:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = MI
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
    UpSys.addObj(t)
    -- Draw the state Sprite --
	t.stateSprite = rendering.draw_sprite{sprite="MatterInteractorSprite1", target=object, surface=object.surface, render_layer=131}
	return t
end

-- Reconstructor --
function MI:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = MI
	setmetatable(object, mt)
end

-- Destructor --
function MI:remove()
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
function MI:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Copy Settings --
function MI:copySettings(obj)
    if obj.selectedFilter ~= nil then
        self.selectedFilter = obj.selectedFilter
    end
    if obj.selectedInv ~= nil then
		self.selectedInv = obj.selectedInv
    end
    if obj.selectedMode ~= nil then
		self.mode = obj.mode
    end
end

-- Update --
function MI:update()
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

    if self.active == false then return end

    self:updateInventory()

end

-- Tooltip Infos --
function MI:getTooltipInfos(GUI)

	-- Create the Belongs to Label --
	local belongsToL = GUI.add{type="label", caption={"", {"gui-description.BelongsTo"}, ": ", self.player}}
	belongsToL.style.font = "LabelFont"
	belongsToL.style.font_color = _mfOrange

	-- Create the Data Network label --
	local DNText = {"", {"gui-description.DataNetwork"}, ": ", {"gui-description.Unknow"}}
	if self.dataNetwork ~= nil then
		DNText = {"", {"gui-description.DataNetwork"}, ": ", self.dataNetwork.ID}
	end
	local dataNetworkL = GUI.add{type="label"}
	dataNetworkL.style.font = "LabelFont"
	dataNetworkL.caption = DNText
	dataNetworkL.style.font_color = {155, 0, 168}

	-- Create the Out Of Power Label --
	if self.dataNetwork ~= nil then
		if self.dataNetwork.outOfPower == true then
			local dataNetworOOPower = GUI.add{type="label"}
			dataNetworOOPower.style.font = "LabelFont"
			dataNetworOOPower.caption = {"", {"gui-description.OutOfPower"}}
			dataNetworOOPower.style.font_color = {231, 5, 5}
		end
	end
	
	-- Create the text and style variables --
	local text = ""
	local style = {}
	-- Check if the Matter Interactor is linked with a Data Center --
	if valid(self.dataNetwork) == true and valid(self.dataNetwork.dataCenter) == true then
		text = {"", {"gui-description.LinkedTo"}, ": ", self.dataNetwork.dataCenter.invObj.name}
		style = {92, 232, 54}
	else
		text = {"gui-description.Unlinked"}
		style = {231, 5, 5}
	end
	-- Create the Link label --
	local link = GUI.add{type="label"}
	link.style.font = "LabelFont"
	link.caption = text
	link.style.font_color = style
	
    if canModify(getPlayer(GUI.player_index).name, self.ent) == false then return end
    
    if valid(self.dataNetwork) == true and valid(self.dataNetwork.dataCenter) == true and self.dataNetwork.dataCenter.invObj.isII == true then
        -- Create the Filter --
        local filterLabel = GUI.add{type="label", caption={"",{"gui-description.SelectFilter"}, ":"}}
        filterLabel.style.top_margin = 7
		filterLabel.style.font = "LabelFont"
        filterLabel.style.font_color = {108, 114, 229}

		local filter = GUI.add{type="choose-elem-button", elem_type="item", name="MIFilter" .. tostring(self.ent.unit_number), tooltip={"gui-description.SelectFilterTT"}}
		filter.style.maximal_height = 25
		filter.style.maximal_width = 25
		if filter.elem_value == nil and self.selectedFilter ~= nil then
            filter.elem_value = self.selectedFilter
		end
        self.selectedFilter = filter.elem_value

        -- Create the Mode Selection --
        local modeLabel = GUI.add{type="label", caption={"",{"gui-description.SelectMode"}, ":"}}
        modeLabel.style.top_margin = 7
		modeLabel.style.font = "LabelFont"
        modeLabel.style.font_color = {108, 114, 229}

        local state = "left"

        if self.selectedMode == "output" then state = "right" end
        
        local modeSwitch = GUI.add{type="switch", name="MIMode" .. self.ent.unit_number, allow_none_state=false, switch_state=state}
        modeSwitch.left_label_caption = {"gui-description.Input"}
        modeSwitch.left_label_tooltip = {"gui-description.InputTT"}
        modeSwitch.right_label_caption = {"gui-description.Output"}
        modeSwitch.right_label_tooltip = {"gui-description.OutputTT"}

	    -- Create the Inventory Selection --
		local targetLabel = GUI.add{type="label", caption={"", {"gui-description.MSTarget"}, ":"}}
		targetLabel.style.top_margin = 7
		targetLabel.style.font = "LabelFont"
		targetLabel.style.font_color = {108, 114, 229}

		local invs = {self.dataNetwork.dataCenter.invObj.name or {"gui-description.Any"}}
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
		local invSelection = GUI.add{type="list-box", name="MITarget" .. self.ent.unit_number, items=invs, selected_index=selectedIndex}
		invSelection.style.width = 100
	end
end

-- Change the Mode --
function MI:changeMode(mode)
    if mode == "left" then
        self.selectedMode = "input"
    elseif mode == "right" then
        self.selectedMode = "output"
    end
end

-- Change the Targeted Inventory --
function MI:changeInventory(ID)
	-- Check the ID --
    if ID == nil then
        self.selectedInv = nil
        return
    end
	-- Select the Inventory --
	self.selectedInv = nil
	for k, deepStorage in pairs(global.deepStorageTable) do
		if valid(deepStorage) then
			if ID == deepStorage.ID then
				self.selectedInv = deepStorage
			end
		end
	end
end

-- Set Active --
function MI:setActive(set)
    self.active = set
    if set == true then
        -- Create the Active Sprite --
        rendering.destroy(self.stateSprite)
        self.stateSprite = rendering.draw_sprite{sprite="MatterInteractorSprite2", target=self.ent, surface=self.ent.surface, render_layer=131}
    else
        -- Create the Inactive Sprite --
        rendering.destroy(self.stateSprite)
        self.stateSprite = rendering.draw_sprite{sprite="MatterInteractorSprite1", target=self.ent, surface=self.ent.surface, render_layer=131}
    end
end

-- Update the Inventory --
function MI:updateInventory()
    -- Get the Internal Inventory
    local inv = self.ent.get_inventory(defines.inventory.chest)
    -- Get the targeted Inventory --
    local dataInv = self.selectedInv
    if dataInv == 0 then
        dataInv = self.dataNetwork.dataCenter.invObj
    end
    -- Check the Data Inventory --
    if valid(dataInv) == false then return end

    -- Input mode --
    if self.selectedMode == "input" then
        -- Itinerate the Inventory --
        for item, count in pairs(inv.get_contents()) do
            -- Add Items to the Data Inventory --
            local amountAdded = dataInv:addItem(item, count)
            -- Remove Items from the local Inventory --
            if amountAdded > 0 then
                inv.remove({name=item, count=amountAdded})
            end
        end
    -- Output mode --
    elseif self.selectedMode == "output" then
        -- Return if the Filter is nil --
        if self.selectedFilter == nil then return end
        -- Check if the Item still exist --
        if game.item_prototypes[self.selectedFilter] == nil then return end
        -- Get Items count from the Data Inventory --
        local returnedItems = dataInv:hasItem(self.selectedFilter)
        -- Return if there are no Items --
        if returnedItems <= 0 then return end
        -- Insert requested Item inside the local Inventory --
        local addedItems = inv.insert({name=self.selectedFilter, count=returnedItems})
        -- Remove Item from the Data Inventory --
	    dataInv:getItem(self.selectedFilter, addedItems)
    end


end