-- FLUID EXTRACTEUR OBJECT --

FE = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	purity = 0,
	charge = 0,
	totalCharge = 0,
	updateTick = 60,
	lastUpdate = 0;
	selectedInv = nil,
	mfTooFar = false,
	resource = nil
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
	resource = object.surface.find_entities_filtered{position=object.position, radius=1, type="resource", limit=1}[1]
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
	self.purity = tags.purity or 0
	self.charge = tags.charge or 0
	self.totalCharge = tags.totalCharge or 0
end

-- Content to Item Tags --
function FE:contentToItemTags(tags)
	if self.charge > 0 then
		tags.set_tag("Infos", {purity=self.purity, charge=self.charge, totalCharge=self.totalCharge})
		tags.custom_description = {"", tags.prototype.localised_description, {"item-description.FluidExtractorC", self.purity, self.charge, self.totalCharge}}
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
	if self.MF.ent == nil or self.MF.ent.valid == false then return end
	-- Check the Surface --
	if self.ent.surface ~= self.MF.ent.surface then return end
	-- Check the Distance --
	if Util.distance(self.ent.position, self.MF.ent.position) > _mfOreCleanerMaxDistance then
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

		-- Create the Select Tank Label --
		GUIObj:addLabel("", settingsTitle, {"", {"gui-description.TargetedTank"}}, _mfOrange)

		-- Create the Tank List --
		local invs = {{"", {"gui-description.All"}}}
		local selectedIndex = 1
		local i = 1
		for k, deepTank in pairs(self.MF.dataNetwork.DTKTable) do
			if deepTank ~= nil and deepTank.ent ~= nil then
				i = i + 1
				local itemText = {"", " (", {"gui-description.Empty"}, " - ", deepTank.player, ")"}
				if deepTank.filter ~= nil and game.fluid_prototypes[deepTank.filter] ~= nil then
					itemText = {"", " (", game.fluid_prototypes[deepTank.filter].localised_name, ")"}
				elseif deepTank.inventoryFluid ~= nil and game.fluid_prototypes[deepTank.inventoryFluid] ~= nil then
					itemText = {"", " (", game.fluid_prototypes[deepTank.inventoryFluid].localised_name, ")"}
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
	GUIObj:addDualLabel(informationFlow, {"", {"gui-description.Charge"}, ": "}, self.charge, _mfOrange, _mfGreen)
	GUIObj:addProgressBar("", informationFlow, "", "", false, _mfPurple, self.charge/_mfFEMaxCharge, 100)

	-- Create the Quatron Purity --
	GUIObj:addDualLabel(informationFlow, {"", {"gui-description.Purity"}, ": "}, self.purity, _mfOrange, _mfGreen)
	GUIObj:addProgressBar("", informationFlow, "", "", false, _mfPurple, self.purity/100, 100)

	-- Create the Speed --
	GUIObj:addDualLabel(informationFlow, {"", {"gui-description.Speed"}, ": "}, self:fluidPerExtraction() .. " u/s", _mfOrange, _mfGreen)

	-- Check the Resource --
	if self.resource ~= nil and self.resource.valid == true then
		local fluidName = self.resource.prototype.mineable_properties.products[1].name
		-- Create the Resource Type --
		GUIObj:addDualLabel(informationFlow, {"", {"gui-description.ResouceType"}, ": "}, Util.getLocFluidName(fluidName), _mfOrange, _mfGreen)
		-- Create the Resource Amount --
		GUIObj:addDualLabel(informationFlow, {"", {"gui-description.ResourceAmount"}, ": "}, self.resource.amount, _mfOrange, _mfGreen)
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
	for k, dimTank in pairs(self.MF.dataNetwork.DTKTable) do
		if dimTank ~= nil and dimTank.ent ~= nil and dimTank.ent.valid == true then
			if ID == dimTank.ID then
				self.selectedInv = dimTank
			end
		end
	end
end

-- Add a Quatron Charge --
function FE:addQuatronCharge(level)
	self.totalCharge = self.totalCharge + 1
	self.charge = self.charge + 100
	self.purity = math.ceil(((self.purity * self.totalCharge) + level) / (self.totalCharge + 1))
end

-- Get the number of Fluid per extraction --
function FE:fluidPerExtraction()
	return math.floor(self.purity * _mfFEFluidPerExtraction)
end

-- Extract Fluids --
function FE:extractFluids(event)
	-- Check the Resource --
	self.resource = self.resource or self.ent.surface.find_entities_filtered{position=self.ent.position, radius=1, type="resource", limit=1}[1]
	if self.resource == nil or self.resource.valid == false then return end
	local resourceName = self.resource.prototype.mineable_properties.products[1].name
	if resourceName == nil then return end
	-- Check the Quatron Charge --
	if self.charge < 10 then return end
	-- Find the Focused Tank --
	local inventory = self.selectedInv
	if inventory == nil then
		-- Auto Select the Ore Silo --
		inventory = nil
		for k, dimTank in pairs(self.MF.dataNetwork.DTKTable) do
			if dimTank ~= nil and dimTank.ent ~= nil and dimTank.ent.valid == true then
				if dimTank:canAccept({name = resourceName}) then
					inventory = dimTank
					break
				end
			end
		end
	end
	-- Check the Selected Inventory --
	if inventory == nil then return end
	-- Calcule the amount that can be extracted --
	local amount = math.min(self.resource.amount, self:fluidPerExtraction())
	-- Check if the Distant Tank can accept the fluid --
	if inventory:canAccept({name = resourceName, amount = amount}) == false then return end
	-- Send the Fluid --
	--there is no temperature_min, temperature_max for products
	--will not work for a resource that can provide two fluids (which would require two outputs on pump)
	local temp = self.resource.prototype.mineable_properties.products[1].temperature or 15
	local amountAdded = inventory:addFluid({name = resourceName, amount = amount, temperature = temp})
	-- Test if Fluid was sended --
	if amountAdded > 0 then
		self.charge = self.charge - 10
		-- Make a Beam --
		self.ent.surface.create_entity{name="BigPurpleBeam", duration=59, position=self.ent.position, target=self.MF.ent.position, source=self.ent.position}
		-- Remove amount from the FluidPath --
		self.resource.amount = math.max(self.resource.amount - amountAdded, 1)
		-- Remove the FluidPath if amount == 0 --
		if self.resource.amount < 2 then
			self.resource.destroy()
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