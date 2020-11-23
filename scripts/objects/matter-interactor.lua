-- MATTER INTERACTOR OBJECT --

-- Create the Matter Interactor base object --
MI = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	stateSprite = 0,
	active = false,
	consumption = _mfMIQuatronDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
	networkAccessPoint = nil,
	selectedFilter = nil,
	selectedMode = "input", -- input or output
	lastSelectedPlayer = "",
	selectedPlayer = "",
	selectedInv = 0,
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
	t.selectedPlayer = t.player
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	t.dataNetwork = t.MF.dataNetwork
	-- Draw the state Sprite --
	t.stateSprite = rendering.draw_sprite{sprite="MatterInteractorSprite1", target=object, surface=object.surface, render_layer=131}
	UpSys.addObj(t)
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
	-- Remove from the Network Access Point --
	if self.networkAccessPoint ~= nil and self.ent ~= nil and self.ent.valid == true then
		self.networkAccessPoint.objTable[self.ent.unit_number] = nil
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
		self.selectedMode = obj.selectedMode
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

    -- Try to find a Network Access Point if needed --
	if valid(self.networkAccessPoint) == false then
		self.networkAccessPoint = self.dataNetwork:getCloserNAP(self)
		if self.networkAccessPoint ~= nil then
			self.networkAccessPoint.objTable[self.ent.unit_number] = self
		end
	end

	-- Set Active or Not --
	if self.networkAccessPoint ~= nil and self.networkAccessPoint.quatronCharge > 0 then
		self:setActive(true)
	else
		self:setActive(false)
    end

	-- Stop if not active --
    if self.active == false then return end

	-- Update the Inventory --
    self:updateInventory()

end

-- Tooltip Infos --
function MI:getTooltipInfos(GUIObj, gui, justCreated)

	-- Create the Data Network Frame --
	GUIObj:addDataNetworkFrame(gui, self)

	-- Update the Filter --
	if self.selectedFilter ~= nil and GUIObj["MIFilter" .. tostring(self.ent.unit_number)] ~= nil then
		GUIObj["MIFilter" .. tostring(self.ent.unit_number)].elem_value = self.selectedFilter
	end

	if justCreated ~= true then return end

	-- Create the Inventory Title --
	local frame = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Inventory"}, _mfOrange)

	-- Create the Filter Label --
	local filterName = self.selectedFilter ~= nil and Util.getLocItemName(self.selectedFilter) or {"gui-description.None"}
	GUIObj:addDualLabel(frame, {"", {"gui-description.Filter"}, ":"}, filterName, _mfOrange, _mfGreen)

	-- Create the Inventory Button --
	GUIObj:addSimpleButton("MIOpenI," .. tostring(self.ent.unit_number), frame, {"gui-description.OpenInventory"})
	
	-- Check if the Parameters can be modified --
	if valid(self.dataNetwork) == false then return end

	if self.lastSelectedPlayer ~= self.selectedPlayer then
		self.lastSelectedPlayer = self.selectedPlayer
		self.selectedInv = 0
	end
	
	-- Create the Parameters Title --
	local titleFrame = GUIObj:addTitledFrame("titleFrame"..self.ent.unit_number, gui, "vertical", {"gui-description.Settings"}, _mfOrange)

	-- Create the Filter Selection --
	GUIObj:addLabel("", titleFrame, {"gui-description.ChangeFilter"}, _mfOrange)
	local filter = GUIObj:addFilter("MIFilter" .. tostring(self.ent.unit_number), titleFrame, {"gui-description.FilterSelect"}, true, "item", 40)
	if self.selectedFilter ~= nil then filter.elem_value = self.selectedFilter end

	-- Create the Mode Selection --
	GUIObj:addLabel("", titleFrame, {"gui-description.SelectMode"}, _mfOrange)
	local state = "left"
	if self.selectedMode == "output" then state = "right" end
	GUIObj:addSwitch("MIMode" .. self.ent.unit_number, titleFrame, {"gui-description.Input"}, {"gui-description.Output"}, {"gui-description.InputTT"}, {"gui-description.OutputTT"}, state)

	--prevent item-with-tags from being stored, allow retrieval (0.0.197+) - workaround until we record tags
	if self.selectedMode == "input"
			and filter.elem_value ~= nil
			and game.item_prototypes[filter.elem_value].type == "item-with-tags"
		then
		game.print("Inputing an item-with-tags ([item="..filter.elem_value.."]) erases tags (dangerous!). Clearing Matter Interactor values.")
		filter.elem_value = nil
		self.selectedFilter = nil
		self.selectedInv = nil --may not be necessary? assigning anyway
	end

	-- Create the Inventory Selection --
	GUIObj:addLabel("", titleFrame, {"gui-description.MSTarget"}, _mfOrange)

	local invs = {}
	invs[1] = {"", {"gui-description.None"}} --LuaGuiElement.selected_index returns 0 for no selection, and is a uint
	invs[2] = {"", "[img=entity/MobileFactory] ", self.dataNetwork.invObj.name, " - ", 0}

	-- Create the Inventory and Deep Storage List --
	local selectedIndex = 1
	if self.selectedInv and type(self.selectedInv) == "table" and not self.selectedInv.ID then selectedIndex = 2 end
	local i = 2
	for k, deepStorage in pairs(self.dataNetwork.DSRTable) do
		if deepStorage ~= nil and deepStorage.ent ~= nil then
			i = i + 1
			local item
			if deepStorage.filter ~= nil then
				item = deepStorage.filter
			elseif deepStorage.inventoryItem ~= nil then
				item = deepStorage.inventoryItem
			end

			if item then
				invs[k+2] = {"", "[img=item/"..item.."] ", game.item_prototypes[item].localised_name, " - ", deepStorage.ID}
			else
				invs[k+2] = {"", "", {"gui-description.Empty"}, " - ", deepStorage.ID}
			end

			if self.selectedInv and type(self.selectedInv) == "table" and self.selectedInv.entID == deepStorage.entID then
				selectedIndex = i
			end
		end
	end
	if selectedIndex > table_size(invs) then selectedIndex = nil end
	GUIObj:addDropDown("MITarget" .. self.ent.unit_number, titleFrame, invs, selectedIndex)
end

-- Change the Mode --
function MI:changeMode(mode)
    if mode == "left" then
        self.selectedMode = "input"
    elseif mode == "right" then
        self.selectedMode = "output"
    end
end

-- Change the Target Player --
function MI:changePlayer(playerName)
    if type(playerName) ~= "string" then return end
	lastSelectedPlayer = self.selectedPlayer

	if game.players[playerName] then
		self.selectedPlayer = playerName
	else
		self.selectedPlayer = self.player
	end
end

-- Change the Targeted Inventory --
function MI:changeInventory(ID)
	-- Check the ID --
    if ID == nil then
        self.selectedInv = nil
        return
    end

    if ID == 0 then
        self.selectedInv = self.dataNetwork.invObj
        return
    end

	-- Select the Inventory --
	self.selectedInv = nil
	for k, deepStorage in pairs(self.dataNetwork.DSRTable) do
		if valid(deepStorage) then
			if ID == deepStorage.ID then
				self.selectedInv = deepStorage
				if self.selectedInv.filter then
					self.selectedFilter = self.selectedInv.filter
				end
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

-- Settings To Blueprint Tags --
function MI:settingsToBlueprintTags()
	local tags = {}
	tags["selfFilter"] = self.selectedFilter
	if self.selectedInv and valid(self.selectedInv) then
		tags["deepStorageID"] = self.selectedInv.ID
		tags["deepStorageFilter"] = self.selectedInv.filter
	end
	tags["selectedMode"] = self.selectedMode
	return tags
end

-- Blueprint Tags To Settings --
function MI:blueprintTagsToSettings(tags)
	self.selectedFilter = tags["selfFilter"]
	local ID = tags["deepStorageID"]
	local deepStorageFilter = tags["deepStorageFilter"]
	if ID then
		for _, deepStorage in pairs(self.MF.dataNetwork.DSRTable) do
			if valid(deepStorage) then
				if ID == deepStorage.ID and deepStorageFilter == deepStorage.filter then
					-- We Should Have the Exact Inventory --
					self.selectedInv = deepStorage
					break
				elseif deepStorageFilter ~= nil and deepStorageFilter == deepStorage.filter then
					-- We Have A Similar Inventory And Will Keep Checking --
					self.selectedInv = deepStorage
				end
			end
		end
	end
	-- be careful of a nil selectedMode
	if tags["selectedMode"] then self.selectedMode = tags["selectedMode"] end
end

-- Check stored data, and remove invalid record
function MI:validate()
	if game.item_prototypes[self.selectedFilter] == nil then
		self.selectedFilter = nil
	end
end