-- FLUID EXTRACTEUR OBJECT --

FE = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	dataNetwork = nil,
	updateTick = 60,
	lastUpdate = 0,
	selectedInv = nil,
	mfTooFar = false,
	resource = nil,
	product = nil,
	quatronCharge = 0,
	quatronLevel = 1,
	quatronMax = _mfFEMaxCharge,
	quatronMaxInput = 100,
	quatronMaxOutput = 0
}

-- Constructor --
function FE:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = FE
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	t.dataNetwork = t.MF.dataNetwork
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function FE:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = FE
	setmetatable(object, mt)
end

-- Destructor --
function FE:remove()
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function FE:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Copy Settings --
function FE:copySettings(obj)
	self.selectedInv = obj.selectedInv
end

-- Item Tags to Content --
function FE:itemTagsToContent(tags)
	self.quatronLevel = tags.purity or 1
	self.quatronCharge = tags.charge or 0
end

-- Content to Item Tags --
function FE:contentToItemTags(tags)
	if self.quatronCharge > 0 then
		tags.set_tag("Infos", {purity=self.quatronLevel, charge=self.quatronCharge})
		tags.custom_description = {"", tags.prototype.localised_description, {"item-description.FluidExtractorC", math.floor(self.quatronCharge), string.format("%.3f", self.quatronLevel)}}
	end
end

-- Update --
function FE:update(event)
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end
	-- The Fluid Extractor can work only if the Mobile Factory Entity is valid --
	if self.dataNetwork.MF.ent == nil or self.dataNetwork.MF.ent.valid == false then return end
	-- Check the Surface --
	if self.ent.surface ~= self.dataNetwork.MF.ent.surface then return end
	-- Check the Distance --
	if Util.distance(self.ent.position, self.dataNetwork.MF.ent.position) > _mfOreCleanerMaxDistance then
		self.MFTooFar = true
	else
		self.MFTooFar = false
		-- Extract Fluid --
		self:extractFluids(event)
	end
end

-- Tooltip Infos --
function FE:getTooltipInfos(GUITable, mainFrame, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.FluidExtractor"}

		-- Set the Main Frame Height --
		-- mainFrame.style.height = 200

		-- Create the Information Frame --
		local informationFrame = GAPI.addFrame(GUITable, "InformationFrame", mainFrame, "vertical", true)
		informationFrame.style = "MFFrame1"
		informationFrame.style.vertically_stretchable = true
		informationFrame.style.left_padding = 3
		informationFrame.style.right_padding = 3
		informationFrame.style.left_margin = 3
		informationFrame.style.right_margin = 3
		informationFrame.style.minimal_width = 200

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", informationFrame, {"gui-description.Information"})

		-- Create the Information Table --
		GAPI.addTable(GUITable, "InformationTable", informationFrame, 1, true)

		-- Create the Parameters Frame --
		local parametersFrame = GAPI.addFrame(GUITable, "ParametersFrame", mainFrame, "vertical", true)
		parametersFrame.style = "MFFrame1"
		parametersFrame.style.vertically_stretchable = true
		parametersFrame.style.left_padding = 3
		parametersFrame.style.right_padding = 3
		parametersFrame.style.right_margin = 3

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", parametersFrame, {"gui-description.Settings"})

		-- Create the Select Data Network Label --
		GAPI.addLabel(GUITable, "", parametersFrame, {"", {"gui-description.DNSelectDataNetwork"}, ":"}, nil, {"gui-description.DNSelectDataNetworkLabelTT"}, false, nil, _mfLabelType.yellowTitle)

		-- Create the Select Network Table --
		local networks = {}
		local selected = 1
		local total = 0
		for _, MF in pairs(global.MFTable) do
			if Util.canUse(GUITable.MFPlayer, MF) then
				table.insert(networks, MF.player)
				total = total + 1
				if self.dataNetwork.ID == MF.dataNetwork.ID then selected = total end
			end
		end

		-- Create the Select Network Drop Down --
		if table_size(networks) > 0 then
			GAPI.addDropDown(GUITable, "F.E.DNSelect", parametersFrame, networks, selected, true, "", {ID=self.ent.unit_number})
		end

		-- Create the Select Tank Label --
		GAPI.addLabel(GUITable, "", parametersFrame, {"gui-description.OCFETargetedStorage"}, nil, "", false, nil, _mfLabelType.yellowTitle)

		-- Create the Tank List --
		local invs = {{"", {"gui-description.Auto"}}}
		local selectedIndex = 1
		local i = 1
		for k, deepTank in pairs(self.dataNetwork.DTKTable) do
			if deepTank ~= nil and deepTank.ent ~= nil then
				i = i + 1
				local itemText = nil
				if deepTank.filter ~= nil then
					itemText = {"", " (", game.fluid_prototypes[deepTank.filter].localised_name, ")"}
				elseif deepTank.inventoryFluid ~= nil then
					itemText = {"", " (", game.fluid_prototypes[deepTank.inventoryFluid].localised_name, ")"}
				else
					itemText = {"", " (", {"gui-description.Empty"}, " - ", deepTank.player, ")"}
				end
				invs[k+1] = {"", {"gui-description.DT"}, " ", tostring(deepTank.ID), itemText}
				if self.selectedInv and self.selectedInv.entID == deepTank.entID then
					selectedIndex = i
				end
			end
		end
		if selectedIndex ~= nil and selectedIndex > table_size(invs) then selectedIndex = nil end

		-- Add the Selected Deep Tank Drop Down --
		GAPI.addDropDown(GUITable, "F.E.TargetDD", parametersFrame, invs, selectedIndex, false, "", {ID=self.ent.unit_number})

	end
	
	-- Get the Table --
	local informationTable = GUITable.vars.InformationTable

	-- Clear the Table --
	informationTable.clear()

	-- Add the Quatron Charge --
    GAPI.addLabel(GUITable, "", informationTable, {"gui-description.QuatronCharge", Util.toRNumber(self.quatronCharge)}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", informationTable, "", self.quatronCharge .. "/" .. self.quatronMax, false, _mfPurple, self.quatronCharge/self.quatronMax, 100)
	
	-- Create the Quatron Purity --
	GAPI.addLabel(GUITable, "", informationTable, {"gui-description.Quatronlevel", string.format("%.3f", self.quatronLevel)}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", informationTable, "", "", false, _mfPurple, self.quatronLevel/20, 100)

	-- Create the Speed --
	local speedLabel = GAPI.addLabel(GUITable, "", informationTable, {"gui-description.OCFESpeedFE", self:fluidPerExtraction()}, _mfOrange)
	speedLabel.style.top_margin = 10
	
	-- Create the Resource Label --
	if self.resource ~= nil and self.resource.valid == true then
		for _, product in pairs(self.resource.prototype.mineable_properties.products) do
			if product.type == "fluid" then
				GAPI.addLabel(GUITable, "", informationTable, {"", Util.getLocFluidName(product.name), ": [color=yellow]", self.resource.amount, "[/color]"}, _mfPurple)
			end
		end
	end

	-- Create the Mobile Factory Too Far Label --
	if self.MFTooFar == true then
		GAPI.addLabel(GUITable, "", informationTable, {"gui-description.OCFEMFTooFar"}, _mfRed)
	end

end

-- Change the Targeted Dimensional Tank --
function FE:changeDimTank(ID)
	-- Check the ID --
	if ID == nil then
		self.selectedInv = nil
		return
	end
	-- Select the Ore Silo --
	self.selectedInv = nil
	for k, dimTank in pairs(self.dataNetwork.DTKTable) do
		if dimTank ~= nil and dimTank.ent ~= nil and dimTank.ent.valid == true then
			if ID == dimTank.ID then
				self.selectedInv = dimTank
			end
		end
	end
end

-- Get the number of Fluid per extraction --
function FE:fluidPerExtraction()
	return math.floor(_mfFEFluidPerExtraction * math.pow(self.quatronLevel, _mfQuatronScalePower))
end

-- Extract Fluids --
function FE:extractFluids(event)

	-- Check the Resource --
	if self.resource == nil or self.resource.valid == false or self.listProducts == nil then
		-- Get the Resources under the Fluid Extractor
		local resources = self.ent.surface.find_entities_filtered{position=self.ent.position, radius=1, type="resource"}
		for _, resource in pairs(resources or {}) do
			-- Check the Resources
			if resource ~= nil and resource.valid == true then
				-- Get the Products --
				local products = resource.prototype.mineable_properties.products
				-- Check the Products --
				for _, product in pairs(products or {}) do
					if product.type == "fluid" then
						self.resource = resource
						self.listProducts = products
					end
				end
			end
		end
	end

	-- Check if a Ressource was found --
	if self.resource == nil or self.resource.valid == false or self.listProducts == nil then return end

	-- Test if the Mobile Factory is valid --
	if valid(self.MF) == false then return end

	-- Check the Quatron Charge --
	if self.quatronCharge < 100 then return end

	-- Check the selected Inventory --
	if self.selectedInv ~= nil then
		-- Check Selected Inventory
		if valid(self.selectedInv) == false then return end
	end

	-- Check if there is a room for all products
	local deepStorages = {}
	local fluidExtracted = math.min(self:fluidPerExtraction(), self.resource.amount)
	for _, product in pairs(self.listProducts) do
		-- Check if the product is a Fluid --
		if product.type ~= "fluid" then return end
		if self.selectedInv then
			-- Deep Storage is assigned, check if it fits
			if self.selectedInv:canAccept({name = product.name, amount = fluidExtracted * product.amount}) then
				-- Selected inventory matches product, proceed
				deepStorages[product.name] = self.selectedInv
			else
				-- Selected inventory can't hold product, return
				return
			end
		else
			-- Try to find a Deep Storage if the Selected Inventory is All --
			for k, dp in pairs(self.dataNetwork.DTKTable) do
				if dp:canAccept({name = product.name, amount = fluidExtracted * product.amount}) == true then
					deepStorages[product.name] = dp
					break
				end
			end
			-- Return if storage not found
			if deepStorages[product.name] == nil then return end
		end
	end

	-- Extract Fluids --
	local stats = self.ent.force.fluid_production_statistics
	for _, product in pairs(self.listProducts) do
		if product.probability == 1 or product.probability > math.random() then
			-- Add Fluids to the Inventory --
			local temp = product.temperature or 15
			deepStorages[product.name]:addFluid({name = product.name, amount = fluidExtracted * product.amount, temperature = temp})
			-- Add Fluids to Production Statistics
			stats.on_flow(product.name, fluidExtracted * product.amount)
		end
	end
	-- Test if Fluid was sended --
	if fluidExtracted > 0 then
		-- Make a Beam --
		self.ent.surface.create_entity{name="BigPurpleBeam", duration=59, position=self.ent.position, target=self.dataNetwork.MF.ent.position, source=self.ent.position}
		-- Remove a charge --
		self.quatronCharge = self.quatronCharge - 100
		-- Remove amount from the FluidPath --
		self.resource.amount = math.max(self.resource.amount - fluidExtracted, 1)
		-- Remove the FluidPath if amount == 0 --
		if self.resource.amount <= 1 then
			self.resource.deplete() -- raises on_resource_depleted and destroys the fluid
		end
	end
end

-- Settings To Blueprint Tags --
function FE:settingsToBlueprintTags()
	local tags = {}
	if self.selectedInv and valid(self.selectedInv) then
		tags["deepStorageID"] = self.selectedInv.ID
		tags["deepStorageFilter"] = self.selectedInv.filter
	end
	return tags
end

-- Blueprint Tags To Settings --
function FE:blueprintTagsToSettings(tags)
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
end

-- Return the amount of Quatron --
function FE:quatron()
	return self.quatronCharge
end

-- Return the Quatron Buffer size --
function FE:maxQuatron()
	return self.quatronMax
end

-- Add Quatron (Return the amount added) --
function FE:addQuatron(amount, level)
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
function FE:removeQuatron(amount)
	local removed = math.min(amount, self.quatronCharge)
	self.quatronCharge = self.quatronCharge - removed
	return removed
end

-- Return the max input flow --
function FE:maxInput()
	return self.quatronMaxInput
end

-- Return the max output flow --
function FE:maxOutput()
	return self.quatronMaxOutput
end

-- Called if the Player interacted with the GUI --
function FE.interaction(event, MFPlayer)

	-- Select Data Network --
	if string.match(event.element.name, "F.E.DNSelect") then
		local objId = event.element.tags.ID
		local obj = global.fluidExtractorTable[objId]
		if obj == nil then return end
		-- Get the Mobile Factory --
		local selectedMF = getMF(event.element.items[event.element.selected_index])
		if selectedMF == nil then return end
		-- Set the New Data Network --
		obj.dataNetwork = selectedMF.dataNetwork
		-- Remove the Selected Inventory --
		obj.selectedInv = nil
		-- Force recreate the Tooltip GUI --
		GUI.updateMFTooltipGUI(MFPlayer.GUI["MFTooltipGUI"], true)
		return
	end

	-- Select the Target --
	if string.match(event.element.name, "F.E.TargetDD") then
		local objId = event.element.tags.ID
		local obj = global.fluidExtractorTable[objId]
		if obj == nil then return end
		-- Change the Fluid Extractor targeted Dimensional Tank --
		obj:changeDimTank(tonumber(event.element.items[event.element.selected_index][4]))
		return
	end

end