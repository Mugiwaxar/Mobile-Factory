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
function NAP:getTooltipInfos(GUITable, mainFrame, justCreated)

	-- Create the Data Network Frame --
	DN.addDataNetworkFrame(GUITable, mainFrame, self, justCreated)

	if justCreated == true then

		-- Set the Main Frame Height --
		mainFrame.style.height = 450
		
		-- Create the Information Frame --
		local infoFrame = GAPI.addFrame(GUITable, "", mainFrame, "vertical")
		infoFrame.style = "MFFrame1"
		infoFrame.style.vertically_stretchable = true
		infoFrame.style.minimal_width = 200
		infoFrame.style.left_margin = 3
		infoFrame.style.left_padding = 3
		infoFrame.style.right_padding = 3

		-- Create the Tite --
		GAPI.addSubtitle(GUITable, "", infoFrame, {"gui-description.Information"})

		-- Create the Show Area Label --
		GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.ShowNAPArea"}, nil, nil, false, nil, _mfLabelType.yellowTitle)
		GAPI.addSwitch(GUITable, "NAPAreaSwitch," .. self.ent.unit_number, infoFrame, {"gui-description.Off"}, {"gui-description.On"}, "", "", self.showArea == true and "right")

		-- Create the Information Flow --
		GAPI.addFlow(GUITable, "InformationFlow", infoFrame, "vertical", true)
		
		-- Create the Connected Structures Frame --
		local conStructuresFrame = GAPI.addFrame(GUITable, "", mainFrame, "vertical")
		conStructuresFrame.style = "MFFrame1"
		conStructuresFrame.style.vertically_stretchable = true
		conStructuresFrame.style.minimal_width = 200
		conStructuresFrame.style.left_margin = 3
		conStructuresFrame.style.left_padding = 3
		conStructuresFrame.style.right_padding = 3

		-- Create the Tite --
		GAPI.addSubtitle(GUITable, "", conStructuresFrame, {"gui-description.NAPConnectedStructures"})

		-- Create the Scroll Pane --
		local conStructuresSC = GAPI.addScrollPane(GUITable, "", conStructuresFrame, nil, false)
		conStructuresSC.style.vertically_stretchable = true
		conStructuresSC.style.bottom_margin = 3

		-- Create the Connected Structures Table --
		GAPI.addTable(GUITable, "ConnectedStructuresTable", conStructuresSC, 1, true)

	end

	-- Get the Information flow and the Connected Structures Table --
	local infoFlow = GUITable.vars.InformationFlow
	local conStructuresTable = GUITable.vars.ConnectedStructuresTable

	-- Clear the Flow and the Table --
	infoFlow.clear()
	conStructuresTable.clear()

    -- Add the Quatron Charge --
    GAPI.addLabel(GUITable, "", infoFlow, {"gui-description.QuatronCharge", self.quatronCharge}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", infoFlow, "", self.quatronCharge .. "/" .. self.quatronMax, false, _mfPurple, self.quatronCharge/self.quatronMax, 100)
	
	-- Create the Quatron Purity --
	GAPI.addLabel(GUITable, "", infoFlow, {"gui-description.Quatronlevel", string.format("%.3f", self.quatronLevel)}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", infoFlow, "", "", false, _mfPurple, self.quatronLevel/20, 100)

	-- Show the Connected Structures List --
	for _, obj in pairs(self.objTable) do
		-- Check the Structure --
		if valid(obj) == true then
			-- Create the Label --
			GAPI.addLabel(GUITable, "", conStructuresTable, {"", Util.getLocEntityName(obj.ent.name), " (", {"gui-description.mfPosition"}, ": ", obj.ent.position.x, ";", obj.ent.position.y, ")"}, _mfYellow)
		end

	end

end

-- Create all Signals --
function NAP:createDNSignals()
	-- Create the Inventory Signal --
	self.ent.get_control_behavior().parameters = nil
	local i = 1
	for name, count in pairs(self.dataNetwork.invObj.inventory) do
		-- Create and send the Signal --
		local signal = {signal={type="item", name=name},count=count}
		self.ent.get_control_behavior().set_signal(i, signal)
		-- Increament the Slot --
		i = i + 1
		-- Stop if there are to much Items --
		if i > 999 then break end
	end

	-- Create the Deep Storages Signals --
	for k, ds in pairs(self.dataNetwork.DSRTable) do
		-- Create and send the Signal --
		if ds.inventoryItem ~= nil then
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
		if dtk.inventoryFluid ~= nil then
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