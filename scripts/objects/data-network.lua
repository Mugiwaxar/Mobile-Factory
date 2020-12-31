-- DATA NETWORK OBJECT --

-- Create the Data Network base object --
DN = {
	ID = 0,
	MF = nil,
	invObj = nil,
	networkController = nil,
	dataStorageTable = nil,
	DTKTable = nil,
	DSRTable = nil,
	networkAccessPointTable = nil,
	playerIndex = 0,
	updateTick = 220,
	lastUpdate = 0
}

-- Constructor --
function DN:new(MF)
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DN
	t.dataStorageTable = {}
	t.DTKTable = {}
	t.DSRTable = {}
	t.networkAccessPointTable = {}
	t.playerIndex = MF.playerIndex
	t.ID = getDataNetworkID()
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function DN:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = DN
	setmetatable(object, mt)
end

-- Destructor --
function DN:remove()
end

-- Is valid --
function DN:valid()
	return true
end

-- Update --
function DN:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick

	-- Check if all Data Storages are valid --
	for k, ds in pairs(self.dataStorageTable) do
		if valid(ds) == false then
			self.dataStorageTable[k] = nil
		end
	end

	-- Check if all Network Access Points are valid --
	for k, nap in pairs(self.networkAccessPointTable) do
		if valid(nap) == false then
			self.networkAccessPointTable[k] = nil
		end
	end

end

-- Create a Data Network Frame --
function DN.addDataNetworkFrame(GUITable, mainFrame, obj, justCreated)

	if justCreated == true then

		-- Clear the Main Frame --
		mainFrame.clear()

		-- Create the Frame --
		local frame = GAPI.addFrame(GUITable, "", mainFrame, "vertical")
		frame.style = "MFFrame1"
		frame.style.vertically_stretchable = true
		frame.style.left_padding = 3
		frame.style.right_padding = 3
		frame.style.minimal_width = 250

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", frame, {"gui-description.DNTitle"})

		-- Add the Select Data Network Dropdown --
		local networks = {}
		local selected = 1
		local total = 0
		for _, MF in pairs(global.MFTable) do
			if canUse(GUITable.MFPlayer, MF) then
				table.insert(networks, MF.player)
				total = total + 1
				if obj.dataNetwork.ID == MF.dataNetwork.ID then selected = total end
			end
		end

		-- Create the Select Data Network Label --
		GAPI.addLabel(GUITable, "", frame, {"", {"gui-description.DNSelectDataNetwork"}, ":"}, nil, {"gui-description.DNSelectDataNetworkLabelTT"}, false, nil, _mfLabelType.yellowTitle)

		-- Create the Select Network Drop Down --
		if table_size(networks) > 0 then
			GAPI.addDropDown(GUITable, "D.N.Select", frame, networks, selected, true, "", {ID=obj.ent.unit_number})
		end

		-- Create the Information Flow --
		GAPI.addTable(GUITable, "DNInfoTable", frame, 1, true)

	end

	-- Get the Information Table --
	local infoTable = GUITable.vars.DNInfoTable

	-- Clear the Table --
	infoTable.clear()

	-- Add the Connected Statue --
	if valid(obj.networkAccessPoint) == false then
		GAPI.addLabel(GUITable, "", infoTable, {"gui-description.NotLinked"}, _mfRed)
	else
		obj.dataNetwork:getTooltipInfos(obj, infoTable, obj)
    end

end

-- Get the Tooltip --
function DN:getTooltipInfos(GUITable, infoTable, obj)

	-- Create the Network Access Point Label --
	GAPI.addLabel(GUITable, "", infoTable, {"", {"gui-description.NetworkAccessPoint"}, ": "}, nil, nil, false, nil, _mfLabelType.yellowTitle)

	-- Create the Connected to Label --
	GAPI.addLabel(GUITable, "", infoTable, {"gui-description.DNConnectedTo", obj.dataNetwork.MF.name}, _mfOrange, {"gui-description.DNConnectedToDNTT"})

	-- Create the Total Quatron Label --
	GAPI.addLabel(GUITable, "", infoTable, {"gui-description.DNTotalQuatron", Util.toRNumber(obj.networkAccessPoint.quatronCharge)}, _mfOrange, {"gui-description.DNTotalQuatronTT"})

	-- Create the Quatron Putiry Label --
	GAPI.addLabel(GUITable, "", infoTable, {"gui-description.DNQuatronPutiry", string.format("%.3f", obj.networkAccessPoint.quatronLevel)}, _mfOrange, {"gui-description.DNQuatronPutiryTT"})

	-- Create the Consumption Label --
	GAPI.addLabel(GUITable, "", infoTable, {"gui-description.DNTotalConsumption", Util.toRNumber(obj.networkAccessPoint.totalConsumption)}, _mfOrange, {"gui-description.DNTotalConsumptionTT"})

	-- Create the own Consumtion Label --
	GAPI.addLabel(GUITable, "", infoTable, {"gui-description.DNSelfConsumption", obj.consumption}, _mfOrange, {"gui-description.DNSelfConsumptionTT"})

	-- Create the Out Of Power Label --
	if obj.networkAccessPoint.quatronCharge <= 0 then
		GAPI.addLabel(GUITable, "", infoTable, {"gui-description.OutOfQuatron"}, _mfRed)
	end

end

-- Return the number of Data Storage --
function DN:dataStoragesCount()
	return table_size(self.dataStorageTable)
end

-- Return the closer Network Access Point --
function DN:getCloserNAP(obj)
	-- Check the Object --
	if valid(obj) == false or obj.ent == nil or obj.ent.valid == false then return end
	-- Find the closer Network Access Point --
	local closerNAP = nil
	local closerNAPDistance = nil
	for _, nap in pairs(global.networkAccessPointTable) do
		-- Check the Network Access Point --
		if nap.ent ~= nil and nap.ent.valid == true and obj.ent.surface == nap.ent.surface then
			-- Check the distance --
			local distance = Util.distanceByTiles(obj.ent.position, nap.ent.position)
			if closerNAP == nil or closerNAPDistance == nil or distance < closerNAPDistance then
				-- Check if this is the requested Data Network --
				if nap.dataNetwork == obj.dataNetwork then
					closerNAP = nap
					closerNAPDistance = distance
				end
			end
		end
	end
	-- Check the Network Access Point distance --
	if closerNAP ~= nil and closerNAPDistance ~= nil and closerNAPDistance <= _mfNAPAreaSize then
		return closerNAP
	end
end

-- Return how many Items the Data Network has --
function DN:hasItem(item)
	local amount = 0
	-- Check the Deep Storages --
	for k, deepStorage in pairs(self.DSRTable) do
		amount = amount + deepStorage:hasItem(item)
	end
	-- Check the Amount --
	amount = amount + self.invObj:hasItem(item)
	-- Return the Amount --
	return amount
end

-- Return the Fluid amount the Data Network has --
function DN:hasFluid(fluid)
	local amount = 0
	-- Check the Deep Tank --
	for k, deepTank in pairs(self.DTKTable) do
		amount = amount + deepTank:hasFluid(fluid)
	end
	-- Return the Amount --
	return amount
end

-- Get Items from the Data Network --
function DN:getItem(item, amount)
	-- Set the Amount of Item to retrieve left --
	local amountLeft = amount
	-- Check the Deep Storages --
	for k, deepStorage in pairs(self.DSRTable) do
		local amountGot = deepStorage:getItem(item, amountLeft)
		amountLeft = amountLeft - amountGot
		if amountLeft <= 0 then return amount end
	end
	-- Check the Data Center --
	amountLeft = amountLeft - self.invObj:getItem(item, amountLeft)
	-- Return the amount removed --
	return amount - amountLeft
end

-- Get Fluid form the Data Network --
function DN:getFluid(fluid, amount)
	-- Set the Amount of Item to retrieve left --
	local amountLeft = amount
	-- Check the Deep Tanks --
	for k, deepTank in pairs(self.DTKTable) do
		local amountGot = deepTank:getFluid({name=fluid, amount=amountLeft})
		amountLeft = amountLeft - amountGot
		if amountLeft <= 0 then return amount end
	end
	-- Return the amount removed --
	return amount - amountLeft
end

-- Check if the Data Network can accept a Item --
function DN:canAcceptItem(item, amount)
	-- Check the Deep Storages --
	for k, deepStorage in pairs(self.DSRTable) do
		if deepStorage:canAccept(item) then
			return true
		end
	end
	-- Check the Data Center --
	if self.invObj:canAccept(amount) then return true end
	return false
end

-- Check if the Data Network can accept a Fluid --
function DN:canAcceptFluid(fluid, amount)
	-- Check the Deep Tanks --
	for k, deepTank in pairs(self.DTKTable) do
		if deepTank:canAccept({name=fluid, amount=amount}) then
			return true
		end
	end
	return false
end

-- Send Items to the Data Network --
function DN:addItems(item, amount)
	-- Set the Amount of Item to send left --
	local amountLeft = amount
	-- Check the Deep Storages --
	for k, deepStorage in pairs(self.DSRTable) do
		if deepStorage:canAccept(item) then
			deepStorage:addItem(item, amount)
			return amount
		end
	end
	-- Check the Data Center --
	amountLeft = amountLeft - self.invObj:addItem(item, amountLeft)
	-- Return the amount added --
	return amount - amountLeft
end

-- Send Fluid to the Data Network --
function DN:addFluid(fluid, amount, temperature)
	-- Set the Amount of Item to retrieve left --
	local amountLeft = amount
	-- Check the Deep Tanks --
	for k, deepTank in pairs(self.DTKTable) do
		local amountSend = deepTank:addFluid({name=fluid, amount=amountLeft, temperature=temperature})
		amountLeft = amountLeft - amountSend
		if amountLeft <= 0 then return amount end
	end
	-- Return the amount added --
	return amount - amountLeft
end

-- Called if the Player interacted with the GUI --
function DN.interaction(event, MFPlayer)

	-- Select Network --
	if string.match(event.element.name, "D.N.Select") then
		-- Get the Object --
		local ID = event.element.tags.ID
		local obj = global.entsTable[ID]
		if obj == nil then return end
		-- Get the Mobile Factory --
		local selectedMF = getMF(event.element.items[event.element.selected_index])
		if selectedMF == nil then return end
		-- Set the New Data Network --
		obj.dataNetwork = selectedMF.dataNetwork
		-- Update the Tooltip GUI --
		GUI.updateMFTooltipGUI(MFPlayer.GUI["MFTooltipGUI"], true)
		return
	end

end