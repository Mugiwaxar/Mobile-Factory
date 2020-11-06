-- NETWORK ACCESS POINT OBJECT --

-- Create the Network Access Point base object --
NAP = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	dataNetwork = nil,
	networkAccessPoint = nil,
	consumption = _mfNAPQuatronDrainPerUpdate,
	totalConsumption = 0,
	showArea = false,
	areaRenderID = 0,
	animID = 0,
	noQuatronSpriteID = 0,
	objTable = nil,
	updateTick = 60,
	lastUpdate = 0,
	quatronCharge = 0,
	quatronLevel = 1,
	quatronMax = _mfNAPQuatronCapacity,
	quatronMaxInput = 999999,
	quatronMaxOutput = 0
}

-- Constructor --
function NAP:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = NAP
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	t.dataNetwork = t.MF.dataNetwork
	t.dataNetwork.networkAccessPointTable[object.unit_number] = t
	t.networkAccessPoint = t
	t.objTable = {}
	t.animID = rendering.draw_animation{animation="NetworkAccessPointA", target={object.position.x, object.position.y-0.9}, surface=object.surface, render_layer=131}
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function NAP:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = NAP
	setmetatable(object, mt)
end

-- Destructor --
function NAP:remove()
    -- Destroy the Animation and the Area --
	rendering.destroy(self.animID)
	rendering.destroy(self.areaRenderID)
	-- Remove from the Update System --
    UpSys.removeObj(self)
    -- Remove from the Data Network --
    self.dataNetwork.networkAccessPointTable[self.ent.unit_number] = nil
end

-- Is valid --
function NAP:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function NAP:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick

	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end

	-- Render the Animation --
	if self.quatronCharge <= 0 and rendering.is_valid(self.noQuatronSpriteID) == false then
		self.noQuatronSpriteID = rendering.draw_sprite{sprite="QuatronIconDisabled", render_layer=131, target=self.ent, surface=self.ent.surface}
		rendering.destroy(self.animID)
	elseif self.quatronCharge > 0 and rendering.is_valid(self.animID) == false then
		self.animID = rendering.draw_animation{animation="NetworkAccessPointA", target={self.ent.position.x,self.ent.position.y-0.9}, surface=self.ent.surface, render_layer=131}
		rendering.destroy(self.noQuatronSpriteID)
	end

	-- Render the Area --
	if self.showArea == true and rendering.is_valid(self.areaRenderID) == false then
			self.areaRenderID = rendering.draw_rectangle{color=_mfGreen, width=5, filled=false, left_top={self.ent.position.x-_mfNAPAreaSize, self.ent.position.y-_mfNAPAreaSize}, right_bottom={self.ent.position.x+_mfNAPAreaSize, self.ent.position.y+_mfNAPAreaSize}, surface=self.ent.surface}
	elseif self.showArea == false then
			rendering.destroy(self.areaRenderID)
	end

	-- Create the Signals --
	self:createDNSignals()

	-- Calculate the total Consumption --
	self:updateTotalConsumption()

	-- Remove the Quatron --
	self:removeConsumption()
end

-- Tooltip Infos --
function NAP:getTooltipInfos(GUIObj, gui, justCreated)

	-- Create the Data Network Frame --
    GUIObj:addDataNetworkFrame(gui, self)

    -- Get the Flow --
    local informationFlow = GUIObj.InformationFlow
    
    if justCreated == true then
        
        -- Create the Information Title --
        local informationTitle = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Information"}, _mfOrange)

        -- Create the Area Show/Hide Switch --
        GUIObj:addLabel("", informationTitle, {"", {"gui-description.ShowNAPArea"}, ":"}, _mfOrange)
        GUIObj:addSwitch("NAPAreaSwitch," .. self.ent.unit_number, informationTitle, {"gui-description.Off"}, {"gui-description.On"}, "", "", self.showArea == true and "right")

        -- Create the Information Flow --
        informationFlow = GUIObj:addFlow("InformationFlow", informationTitle, "vertical", true)
    end

    -- Clear the Flow --
    informationFlow.clear()

    -- Add the Quatron Charge --
    GUIObj:addLabel("", informationFlow, {"", {"gui-description.QuatronCharge"}, ":"}, _mfOrange)
    GUIObj:addProgressBar("", informationFlow, "", self.quatronCharge .. "/" .. self.quatronMax, false, _mfPurple, self.quatronCharge/self.quatronMax, 100)

end

-- Create all Signals --
function NAP:createDNSignals()

    -- Create the Inventory Signal --
	self.ent.get_control_behavior().parameters = nil
	local i = 1
	for name, count in pairs(self.dataNetwork.invObj.inventory) do
		-- Create and send the Signal --
		if game.item_prototypes[name] ~= nil then
			local signal = {signal={type="item", name=name},count=count}
			self.ent.get_control_behavior().set_signal(i, signal)
			-- Increament the Slot --
			i = i + 1
			-- Stop if there are to much Items --
			if i > 999 then break end
		end
	end
	
	-- Create the Deep Storages Signals --
	for k, ds in pairs(self.dataNetwork.DSRTable) do
		-- Create and send the Signal --
		if ds.inventoryItem ~= nil and game.item_prototypes[ds.inventoryItem] ~= nil then
			local signal = {signal={type="item", name=ds.inventoryItem}, count=math.min(ds.inventoryCount, 2e9)}
			self.ent.get_control_behavior().set_signal(i, signal)
			-- Increament the Slot --
			i = i + 1
			-- Stop if there are to much Items --
			if i > 999 then break end
		end
	end

	-- Create the Deep Tanks Signals --
	for k, dtk in pairs(self.dataNetwork.DTKTable) do
		-- Create and send the Signal --
		if dtk.inventoryFluid ~= nil and game.fluid_prototypes[dtk.inventoryFluid] ~= nil then
			local signal = {signal={type="fluid", name=dtk.inventoryFluid} ,count=dtk.inventoryCount}
			self.ent.get_control_behavior().set_signal(i, signal)
			-- Increament the Slot --
			i = i + 1
			-- Stop if there are to much Items --
			if i > 999 then break end
		end
    end
    
end

-- Calculate the Total Consumption --
function NAP:updateTotalConsumption()
	local totalConsumption = self.consumption
	for k, obj in pairs(self.objTable) do
			if valid(obj) == false then
					self.objTable[k] = nil
			else
					totalConsumption = totalConsumption + obj.consumption
			end
	end
	-- TODO: NAP doesn't get better with levels, so just reducing consumption for now
	self.totalConsumption = math.ceil(totalConsumption / math.pow(self.quatronLevel, _mfQuatronScalePower))
end

-- Remove the Quatron Consumed --
function NAP:removeConsumption()
	-- Check and Remove Quatron --
	if self.totalConsumption >= self.quatronCharge then
		self.quatronCharge = 0
	else
		self.quatronCharge = self.quatronCharge - self.totalConsumption
	end
end

-- Return the amount of Quatron --
function NAP:quatron()
	return self.quatronCharge
end

-- Return the Quatron Buffer size --
function NAP:maxQuatron()
	return self.quatronMax
end

-- Add Quatron (Return the amount added) --
function NAP:addQuatron(amount, level)
	local added = math.min(amount, self.quatronMax - self.quatronCharge)
	if self.quatronCharge > 0 then
		mixQuatron(self, added, level)
	else
		self.quatronCharge = added
		self.quatronLevel = level
	end
	return added
end

-- Remove Quatron (Return the amount removed) --
function NAP:removeQuatron(amount)
	local removed = math.min(amount, self.quatronCharge)
	self.quatronCharge = self.quatronCharge - removed
	return removed
end

-- Return the max input flow --
function NAP:maxInput()
	return self.quatronMaxInput
end

-- Return the max output flow --
function NAP:maxOutput()
	return self.quatronMaxOutput
end