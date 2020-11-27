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
	self.quatronLevel = tags.purity or 0
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
function FE:getTooltipInfos(GUIObj, gui, justCreated)

	-- Get the Flow --
	local informationFlow = GUIObj.InformationFlow

	if justCreated == true then

		-- Create the Information Title --
		local informationTitle = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Information"}, _mfOrange)
		informationFlow = GUIObj:addFlow("InformationFlow", informationTitle, "vertical", true)

		-- Create the Settings Title --
		local settingsTitle = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Settings"}, _mfOrange)

		-- Create the Select Data Network Label --
		GUIObj:addLabel("", settingsTitle, {"", {"gui-description.OCFESelectDataNetwork"}}, _mfBlue, nil, false, "LabelFont2")

		-- Create the Select Network Table --
		local networks = {}
		local selected = 1
		local total = 0
		for _, MF in pairs(global.MFTable) do
			if Util.canUse(GUIObj.MFPlayer, MF) then
				table.insert(networks, MF.player)
				total = total + 1
				if self.dataNetwork.ID == MF.dataNetwork.ID then selected = total end
			end
		end

		-- Create the Select Network Drop Down --
		if table_size(networks) > 0 then
			GUIObj:addDropDown("DNFESelect" .. self.ent.unit_number, settingsTitle, networks, selected, true, {"gui-description.SelectDataNetwork"})
		end

		-- Create the Select Tank Label --
		GUIObj:addLabel("", settingsTitle, {"", {"gui-description.TargetedTank"}}, _mfBlue, nil, false, "LabelFont2")

		-- Create the Tank List --
		local invs = {{"", {"gui-description.All"}}}
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
		GUIObj:addDropDown("FE" .. self.ent.unit_number, settingsTitle, invs, selectedIndex)

	end

	-- Clear the Flow --
	informationFlow.clear()

	-- Create the Quatron Charge --
	GUIObj:addDualLabel(informationFlow, {"", {"gui-description.Charge"}, ": "}, math.floor(self.quatronCharge), _mfOrange, _mfGreen)
	GUIObj:addProgressBar("", informationFlow, "", "", false, _mfPurple, self.quatronCharge/_mfFEMaxCharge, 100)

	-- Create the Quatron Purity --
	GUIObj:addDualLabel(informationFlow, {"", {"gui-description.Purity"}, ": "}, string.format("%.3f", self.quatronLevel), _mfOrange, _mfGreen)
	GUIObj:addProgressBar("", informationFlow, "", "", false, _mfPurple, self.quatronLevel/20, 100)

	-- Create the Speed --
	GUIObj:addDualLabel(informationFlow, {"", {"gui-description.Speed"}, ": "}, self:fluidPerExtraction() .. " u/s", _mfOrange, _mfGreen)

	-- Check the Resource --
	if self.resource ~= nil and self.resource.valid == true then
		for _, product in pairs(self.resource.prototype.mineable_properties.products) do
			if product.type == "fluid" then
				-- Create the Resource Type --
				GUIObj:addDualLabel(informationFlow, {"", {"gui-description.ResouceType"}, ": "}, Util.getLocFluidName(product.name), _mfOrange, _mfGreen)
				-- Create the Resource Amount --
				GUIObj:addDualLabel(informationFlow, {"", {"gui-description.ResourceAmount"}, ": "}, self.resource.amount, _mfOrange, _mfGreen)
			end
		end
	end

	-- Create the Mobile Factory Too Far Label --
	if self.MFTooFar == true then
		GUIObj:addLabel("", informationFlow, {"", {"gui-description.MFTooFar"}}, _mfRed)
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
	-- Test if the Mobile Factory is valid --
	if valid(self.MF) == false then return end
	-- Check the Quatron Charge --
	if self.quatronCharge < 100 then return end
	-- Check the Resource --
	if self.resource == nil or self.listProducts == nil then
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
	if self.resource == nil or self.listProducts == nil then return end

	-- Check the selected Inventory --
	if self.selectedInv ~= nil then
		-- Check Selected Inventory
		if valid(self.selectedInv) == false then return end
	end

	-- Check if there is a room for all products
	local deepStorages = {}
	local fluidExtracted = math.min(self:fluidPerExtraction(), self.resource.amount)
	for _, product in pairs(self.listProducts) do
		-- Check if product is fluid --
		if product.type ~= 'fluid' then return end

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