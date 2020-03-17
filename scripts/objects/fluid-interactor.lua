-- FLUID INTERACTOR OBJECT --

-- Create the Fluid Interactor base object --
FI = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
    stateSprite = 0,
    levelSprite = 0,
	active = false,
	consumption = _mfFIEnergyDrainPerUpdate,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
    selectedInv = 0,
    selectedMode = "input" -- input or output
}

-- Constructor --
function FI:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = FI
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
    UpSys.addObj(t)
    -- Draw the state Sprite --
	t.stateSprite = rendering.draw_sprite{sprite="FluidInteractorSprite1", target=object, surface=object.surface, render_layer=131}
	return t
end

-- Reconstructor --
function FI:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = FI
	setmetatable(object, mt)
end

-- Destructor --
function FI:remove()
	-- Destroy the Sprites --
	rendering.destroy(self.stateSprite)
	rendering.destroy(self.levelSprite)
	-- Remove from the Update System --
	UpSys.removeObj(self)
	-- Remove from the Data Network --
	if self.dataNetwork ~= nil and getmetatable(self.dataNetwork) ~= nil then
		self.dataNetwork:removeObject(self)
	end
end

-- Is valid --
function FI:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Copy Settings --
function FI:copySettings(obj)
	if obj.selectedInv ~= nil then
		self.selectedInv = obj.selectedInv
    end
    if obj.selectedInv ~= nil then
		self.mode = obj.mode
	end
end

-- Update --
function FI:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
    end
    
    -- Update the level Sprite --
    local amount = nil
    local capacity = self.ent.fluidbox.get_capacity(1)
    for k3, i in pairs(self.ent.get_fluid_contents()) do
        amount = math.floor(i)
    end
    rendering.destroy(self.levelSprite)
    if amount ~= nil then
        local spriteNumber = math.floor(amount/capacity*10)
        if spriteNumber == 0 then
            rendering.destroy(self.levelSprite)
        else
            self.levelSprite = rendering.draw_sprite{sprite="FluidInteractorSprite3" .. spriteNumber, target=self.ent, surface=self.ent.surface, render_layer=131}
        end
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

    -- Update Inventory --
    self:updateInventory()
end

-- Tooltip Infos --
function FI:getTooltipInfos(GUI)

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
	-- Check if the Data Storage is linked with a Data Center --
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
    
    -- Create the Mode Selection --
    if valid(self.dataNetwork) == true and valid(self.dataNetwork.dataCenter) == true and self.dataNetwork.dataCenter.invObj.isII == true then
        -- Create the Mode Label --
        local modeLabel = GUI.add{type="label", caption={"",{"gui-description.SelectMode"}, ":"}}
        modeLabel.style.top_margin = 7
		modeLabel.style.font = "LabelFont"
        modeLabel.style.font_color = {108, 114, 229}

        local state = "left"

        if self.selectedMode == "output" then state = "right" end
        
        local modeSwitch = GUI.add{type="switch", name="FIMode" .. self.ent.unit_number, allow_none_state=false, switch_state=state}
        modeSwitch.left_label_caption = {"gui-description.Input"}
        modeSwitch.left_label_tooltip = {"gui-description.InputTT"}
        modeSwitch.right_label_caption = {"gui-description.Output"}
        modeSwitch.right_label_tooltip = {"gui-description.OutputTT"}
    end

	-- Create the Inventory Selection --
	if valid(self.dataNetwork) == true and valid(self.dataNetwork.dataCenter) == true and self.dataNetwork.dataCenter.invObj.isII == true then
		-- Create the targeted Inventory label --
		local targetLabel = GUI.add{type="label", caption={"", {"gui-description.MSTarget"}, ":"}}
		targetLabel.style.top_margin = 7
		targetLabel.style.font = "LabelFont"
		targetLabel.style.font_color = {108, 114, 229}

		local invs = {{"", {"gui-description.Any"}}}
		local selectedIndex = 1
		local i = 1
		for k, deepTank in pairs(global.deepTankTable) do
			if deepTank ~= nil and deepTank.ent ~= nil and Util.canUse(self.player, deepTank.ent) then
				i = i + 1
				local itemText = {"", " (", {"gui-description.Empty"}, " - ", deepTank.player, ")"}
				if deepTank.filter ~= nil and game.fluid_prototypes[deepTank.filter] ~= nil then
					itemText = {"", " (", game.fluid_prototypes[deepTank.filter].localised_name, " - ", deepTank.player, ")"}
				elseif deepTank.inventoryFluid ~= nil and game.fluid_prototypes[deepTank.inventoryFluid] ~= nil then
					itemText = {"", " (", game.fluid_prototypes[deepTank.inventoryFluid].localised_name, " - ", deepTank.player, ")"}
				end
				invs[k+1] = {"", {"gui-description.DT"}, " ", tostring(deepTank.ID), itemText}
				if self.selectedInv == deepTank then
					selectedIndex = i
				end
			end
		end
		if selectedIndex ~= nil and selectedIndex > table_size(invs) then selectedIndex = nil end
		local invSelection = GUI.add{type="list-box", name="FITarget" .. self.ent.unit_number, items=invs, selected_index=selectedIndex}
		invSelection.style.width = 100
	end
end

-- Change the Mode --
function FI:changeMode(mode)
    if mode == "left" then
        self.selectedMode = "input"
    elseif mode == "right" then
        self.selectedMode = "output"
    end
end

-- Change the Targeted Inventory --
function FI:changeInventory(ID)
	-- Check the ID --
    if ID == nil then
        self.selectedInv = nil
        return
    end
	-- Select the Inventory --
	self.selectedInv = nil
	for k, deepTank in pairs(global.deepTankTable) do
		if valid(deepTank) then
			if ID == deepTank.ID then
				self.selectedInv = deepTank
			end
		end
	end
end

-- Set Active --
function FI:setActive(set)
    self.active = set
    if set == true then
        -- Create the Active Sprite --
        rendering.destroy(self.stateSprite)
        self.stateSprite = rendering.draw_sprite{sprite="FluidInteractorSprite2", target=self.ent, surface=self.ent.surface, render_layer=131}
    else
        -- Create the Inactive Sprite --
        rendering.destroy(self.stateSprite)
        self.stateSprite = rendering.draw_sprite{sprite="FluidInteractorSprite1", target=self.ent, surface=self.ent.surface, render_layer=131}
    end
end

-- Update the Tank Inventory --
function FI:updateInventory()
    -- Check the selected Inventory --
    if self.selectedInv == nil or valid(self.selectedInv) == false then return end

    -- Get both Tanks and their characteristics --
    local localTank = self.ent
    local distantTank = self.selectedInv
    local localFluid = nil
    local localAmount = nil

    -- Get the Fluid inside the local Tank --
    for k, i in pairs(localTank.get_fluid_contents()) do
        localFluid = k
        localAmount = i
    end

    -- Input mode --
    if self.selectedMode == "input" then
        -- Check the local and distant Tank --
        if localFluid == nil or localAmount == nil then return end
        if distantTank:canAccept(localFluid) == false then return end
        -- Send the Fluid --
        local amountAdded = distantTank:addFluid(localFluid, localAmount)
        -- Remove the local Fluid --
        localTank.remove_fluid{name=localFluid, amount=amountAdded}
    elseif self.selectedMode == "output" then
        -- Check the local and distant Tank --
        if localFluid ~= nil and localFluid ~= distantTank.inventoryFluid then return end
        if distantTank.inventoryFluid == nil or distantTank.inventoryCount == 0 then return end
        -- Get the Fluid --
        local amountAdded = localTank.insert_fluid({name=distantTank.inventoryFluid, amount=distantTank.inventoryCount})
        -- Remove the distant Fluid --
        distantTank:getFluid(distantTank.inventoryFluid, amountAdded)
    end
end