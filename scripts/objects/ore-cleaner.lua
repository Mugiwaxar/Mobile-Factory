-- ORE CLEANER OBJECT --

OC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	dataNetwork = nil,
	networkAccessPoint = nil,
	oreTable = nil,
	selectedInv = nil,
	lightAnID = nil,
	updateTick = 20,
	lastDNSend = 0,
	lastUpdate = 0,
	consumption = 0,
	outOfQuatron = false,
	inventoryFull = false,
	energyCharge = 0,
	energyLevel = 1,
	energyBuffer = _mfOreCleanerMaxCharge
}

-- Constructor --
function OC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = OC
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	t.dataNetwork = t.MF.dataNetwork
	t.oreTable = {}
	t.inventory = {}
	t:scanOres(object)
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function OC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = OC
	setmetatable(object, mt)
end

-- Destructor --
function OC:remove()
	-- Destroy the Animation --
	rendering.destroy(self.lightAnID or 0)
	-- Remove from the Update System --
	UpSys.removeObj(self)
	-- Remove from the Network Access Point --
	if self.networkAccessPoint ~= nil and self.ent ~= nil and self.ent.valid == true then
		self.networkAccessPoint.objTable[self.ent.unit_number] = nil
	end
end

-- Is valid --
function OC:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Copy Settings --
function OC:copySettings(obj)
	self.selectedInv = obj.selectedInv
end

-- Item Tags to Content --
function OC:itemTagsToContent(tags)
	self.energyCharge = tags.charge or 0
	self.energyLevel = tags.purity or 1
end

-- Content to Item Tags --
function OC:contentToItemTags(tags)
	if EI.energy(self) > 0 then
		tags.set_tag("Infos", {charge=EI.energy(self), purity=EI.energyLevel(self)})
		tags.custom_description = {"", tags.prototype.localised_description, {"item-description.OreCleanerC", math.floor(EI.energy(self)), string.format("%.3f", EI.energyLevel(self))}}
	end
end

-- Settings To Blueprint Tags --
function OC:settingsToBlueprintTags()
	local tags = {}
	if self.selectedInv and valid(self.selectedInv) then
		tags["deepStorageID"] = self.selectedInv.ID
		tags["deepStorageFilter"] = self.selectedInv.filter
	end
	return tags
end

-- Blueprint Tags To Settings --
function OC:blueprintTagsToSettings(tags)
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

-- Tooltip Infos --
function OC:getTooltipInfos(GUITable, mainFrame, justCreated)

	-- Create the Data Network Frame --
	DN.addDataNetworkFrame(GUITable, mainFrame, self, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.OreCleaner"}

		-- Set the Main Frame Height --
		mainFrame.style.height = 350

		-- Create the Information Frame --
		local informationFrame = GAPI.addFrame(GUITable, "InformationFrame", mainFrame, "vertical", true)
		informationFrame.style = "MFFrame1"
		informationFrame.style.vertically_stretchable = true
		informationFrame.style.left_padding = 3
		informationFrame.style.right_padding = 3
		informationFrame.style.left_margin = 3
		informationFrame.style.right_margin = 3
		-- informationFrame.style.minimal_width = 200

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", informationFrame, {"gui-description.Information"})

		-- Create the Information Table --
		GAPI.addTable(GUITable, "InformationTable", informationFrame, 1, true)

		-- Create the Inventory Frame --
		local inventoryFrame = GAPI.addFrame(GUITable, "InventoryFrame", mainFrame, "vertical", true)
		inventoryFrame.style = "MFFrame1"
		inventoryFrame.style.vertically_stretchable = true
		inventoryFrame.style.left_padding = 3
		inventoryFrame.style.right_padding = 3
		inventoryFrame.style.left_margin = 3
		inventoryFrame.style.right_margin = 3

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", inventoryFrame, {"gui-description.Inventory"})

		-- Create the Select Storage Label --
		GAPI.addLabel(GUITable, "", inventoryFrame, {"gui-description.OCFETargetedStorage"}, nil, "", false, nil, _mfLabelType.yellowTitle)

		-- Create the Storage List --
		local invs = {{"gui-description.None"}, {"gui-description.Auto"}, {"gui-description.DataNetwork"}}
		local selectedIndex = 1
		local i = 1
		for _, deepStorage in pairs(self.dataNetwork.DSRTable) do
			if deepStorage ~= nil and deepStorage.ent ~= nil then
				i = i + 1
				local item
				if deepStorage.inventoryItem ~= nil then
					item = deepStorage.inventoryItem
				elseif deepStorage.filter ~= nil then
					item = deepStorage.filter
				end

				if item then
					table.insert(invs, {"", "[img=item/"..item.."] ", game.item_prototypes[item].localised_name, " - ", deepStorage.ID})
				else
					table.insert(invs, {"", "", {"gui-description.Empty"}, " - ", deepStorage.ID})
				end
				if self.selectedInv ~= nil then
					if self.selectedInv == -1 then
						selectedIndex = 2
					elseif self.selectedInv == -2 then
						selectedIndex = 3
					elseif self.selectedInv.entID == deepStorage.entID then
					selectedIndex = i
					end
				end
			end
		end
		if selectedIndex ~= nil and selectedIndex > table_size(invs) then selectedIndex = nil end

		-- Add the Selected Deep Tank Drop Down --
		GAPI.addDropDown(GUITable, "O.C.TargetDD", inventoryFrame, invs, selectedIndex, false, {"gui-description.OCInventorySelectTT"}, {ID=self.ent.unit_number})

		-- Create the Inventory Flow and Button --
		local inventoryFlow = GAPI.addFlow(GUITable, "", inventoryFrame, "horizontal")
		inventoryFlow.style.horizontal_align = "center"
		inventoryFlow.style.top_margin = 15
		GAPI.addSimpleButton(GUITable, "O.C.OpenInvButton", inventoryFlow, {"gui-description.OpenInventory"}, "", false, {ID=self.entID})

	end

	-- Get the Table --
	local informationTable = GUITable.vars.InformationTable

	-- Clear the Table --
	informationTable.clear()

	-- Add the Quatron Charge --
    GAPI.addLabel(GUITable, "", informationTable, {"gui-description.QuatronCharge", Util.toRNumber(EI.energy(self)) }, _mfOrange)
	GAPI.addProgressBar(GUITable, "", informationTable, "", EI.energy(self) .. "/" .. EI.maxEnergy(self), false, _mfPurple, EI.energy(self)/EI.maxEnergy(self), 100)
	
	-- Create the Quatron Purity --
	GAPI.addLabel(GUITable, "", informationTable, {"gui-description.Quatronlevel", string.format("%.3f", EI.energyLevel(self))}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", informationTable, "", "", false, _mfPurple, EI.energyLevel(self)/20, 100)

	-- Create the Speed --
	local speed = math.floor((math.pow(EI.energyLevel(self), _mfQuatronScalePower) + _mfOreCleanerOrePerExtraction) * EI.energyLevel(self) * 3)
	local speedLabel = GAPI.addLabel(GUITable, "", informationTable, {"gui-description.OCFESpeedOC", speed}, _mfOrange)
	speedLabel.style.top_margin = 10

	-- Create the Resource Label --
	GAPI.addLabel(GUITable, "", informationTable, {"", {"gui-description.OCFENumberOfOrePath"}, " [color=yellow]", table_size(self.oreTable), "[/color]"}, _mfOrange)

	-- Create the Mobile Factory Too Far Label --
	if self.outOfQuatron == true then
		GAPI.addLabel(GUITable, "", informationTable, {"gui-description.OutOfQuatron"}, _mfRed)
	end

	-- Create the Mobile Factory Too Far Label --
	if self.inventoryFull == true then
		GAPI.addLabel(GUITable, "", informationTable, {"gui-description.InventoryFull"}, _mfRed)
	end

end

-- Update --
function OC:update(event)

    -- Set the lastUpdate variable --
    self.lastUpdate = game.tick

    -- Check the Validity --
    if valid(self) == false then
        self:remove()
        return
    end

    -- Collect Ores --
    self:collectOres()

	-- Try to find a Network Access Point if needed --
	if valid(self.networkAccessPoint) == false or self.dataNetwork ~= self.networkAccessPoint.dataNetwork then
		self.networkAccessPoint = self.dataNetwork:getCloserNAP(self)
		if self.networkAccessPoint ~= nil then
			self.networkAccessPoint.objTable[self.ent.unit_number] = self
		end
	end

	-- Try to get Quatron from the Network Access Point --
	if EI.energy(self) <= 100 and self.networkAccessPoint ~= nil then
		local chargeToBorrow = math.min(EI.energy(self.networkAccessPoint), EI.maxEnergy(self) - EI.energy(self))
		if chargeToBorrow > 0 then
			local added = self:addQuatron(chargeToBorrow, EI.energyLevel(self.networkAccessPoint))
			EI.removeEnergy(self.networkAccessPoint, added)
			self.outOfQuatron = false
		end
	end

	-- Send to the Data Network --
	if game.tick - self.lastDNSend > 60 then
		self.lastDNSend = game.tick
		self:sendToDN()
	end

    -- Draw the Animation --
	if self.inventoryFull == true or self.outOfQuatron == true then
		rendering.destroy(self.lightAnID or 0)
		self.lightAnID = nil
    elseif self.lightAnID == nil then
        self.lightAnID = rendering.draw_animation{animation="OreCleanerAn", target=self.ent.position, surface=self.ent.surface, render_layer=144, animation_speed=0.3}
    end

end

-- Scan surronding Ores --
function OC:scanOres(entity)
	-- Test if the Entity is valid --
	if entity == nil or entity.valid == false then return end
	-- Test if the Surface is valid --
	if entity.surface == nil then return end
	-- Add all surrounding Ores and add them to the oreTable --
	local area = {{entity.position.x-_mfOreCleanerRadius,entity.position.y-_mfOreCleanerRadius},{entity.position.x+_mfOreCleanerRadius,entity.position.y+_mfOreCleanerRadius}}
	self.oreTable = entity.surface.find_entities_filtered{area=area, type="resource"}
end

-- Collect surrounding Ores --
function OC:collectOres()

    -- Calcule the amount of Ore to extract --
    local toExtract = math.floor(math.pow(EI.energyLevel(self), _mfQuatronScalePower) + _mfOreCleanerOrePerExtraction)

    -- Get the Ore Table size --
    local tableSize = table_size(self.oreTable)

    -- Return if the Ore Table is empty --
    if tableSize <= 0 then return end

    -- Get the Inventory --
    local inv = self.ent.get_inventory(defines.inventory.chest)

    -- Do the job for each Quatron Level --
    for i=1, math.floor(EI.energyLevel(self)) do

        -- Return if there are not Quatron Charge remaining --
        if EI.energy(self) < 3 then
			self.outOfQuatron = true
			return
		else
			self.outOfQuatron = false
		end

        -- Get a random Ore Path --
        local randOrePath = math.random(1, tableSize)
        local orePath = self.oreTable[randOrePath]

        -- Check the Path --
        if orePath == nil or orePath.valid == false then return end

        -- Get the Products List --
        local productsList = orePath.prototype.mineable_properties.products

        -- Calculate the amout of Ore that will be extracted --
        local oreExtracted = math.min(toExtract, orePath.amount)

        -- Itinerate all Products --
        local added = 0
        for _, product in pairs(productsList) do
            -- Check if this is an Item --
            if product.type == "item" then
                -- Calculate how many products can be extracted --
                local amount = product.amount or math.random(product.amount_min, product.amount_max)
                -- Calculate the Probability --
                if math.random(0, 100) <= product.probability*100 then
                    -- Insert the Product --
                    local inserted = inv.insert({name=product.name, count=amount*oreExtracted})
					-- Check if something was inserted --
					if inserted > 0 then
						-- Register the amount inserted if this is the main Product --
						added = math.max(inserted, added)
						-- Create the Projectile --
						self.ent.surface.create_entity{name="OreCleanerProjectile:" .. product.name, position=orePath.position, target=self.ent, speed=0.1, max_range=20}
						self.inventoryFull = false
					else
						self.inventoryFull = true
					end
                end
            end
        end

        -- Check if something was extrated --
        if added <= 0 then return end

        -- Remove a Quatron Charge --
        EI.removeEnergy(self, 3)

        -- Remove Ores from the Ore Path --
        orePath.amount = math.max(orePath.amount - added, 1)

        -- Remove the Ore Path if it is empty --
        if orePath.amount <= 1 then
            orePath.deplete()
            table.remove(self.oreTable, randOrePath)
        end

    end

end

-- Send the Ore Inside to the Data Network --
function OC:sendToDN()

	-- Stop if the selected Inventory is None --
	if self.selectedInv == nil then return end

	-- Get the Inventory --
    local inv = self.ent.get_inventory(defines.inventory.chest)

	-- Check if the Mobile Factory is close --
	local MFTooFar = true
	if self.MF.ent ~= nil and self.MF.ent.valid == true and Util.distance(self.ent.position, self.MF.ent.position) <= _mfOreCleanerMaxDistance then
		MFTooFar = false
	end

	-- Get the Ore Cleaner Target --
	local target = nil
	if MFTooFar == false then
		target = self.MF.ent
	end
	if MFTooFar == false and valid(self.networkAccessPoint) and EI.energy(self.networkAccessPoint) > 0 and Util.distance(self.ent.position, self.MF.ent.position) > Util.distance(self.ent.position, self.networkAccessPoint.ent.position) then
		target = self.networkAccessPoint.ent
	end
	if MFTooFar == true and valid(self.networkAccessPoint) and EI.energy(self.networkAccessPoint) > 0 then
		target = self.networkAccessPoint.ent
	end

	if target == nil then return end

	-- If the Selected Inventory is a Deep Storage --
	if valid(self.selectedInv) == true then
		-- Get the Deep Storage --
		local dsr = self.selectedInv
		-- Get the Deep Storage Item or Filter --
		local itemName = dsr.inventoryItem or dsr.filter
		-- Check the Name --
		if itemName == nil then return end
		-- Check if the Ore Cleaner Inventory has this item --
		local itemCount = inv.get_item_count(itemName)
		-- Try to send the Item count to the Deep Storage --
		local inserted = dsr:addItem(itemName, math.min(itemCount, dsr:availableSpace()))
		-- Remove the Items from the Inventory --
		if inserted > 0 then
			inv.remove({name=itemName, count=inserted})
			-- Create the Projectile --
			self:createOreBeam(itemName, target)
		end
	end

	-- If the Selected Inventory is Auto --
	if self.selectedInv == -1 then
		-- Get all Items inside the Ore Cleaner Inventory --
		for item, count in pairs(inv.get_contents()) do
			-- Check all Deep Storages --
			for _, dsr in pairs(self.dataNetwork.DSRTable) do
				-- Try to send the Items to the Deep Storage --
				local inserted = dsr:addItem(item, math.min(count, dsr:availableSpace()))
				-- Remove the Items from the Inventory --
				if inserted > 0 then
					inv.remove({name=item, count=inserted})
					-- Create the Projectile --
					self:createOreBeam(item, target)
				end
				-- Decrease the count --
				count = count - inserted
			end
		end
	end

	-- If the Selected Inventory is Data Network --
	if self.selectedInv == -2 then
		-- Get all Items inside the Ore Cleaner Inventory --
		for item, count in pairs(inv.get_contents()) do
			-- Check all Deep Storages --
			for _, dsr in pairs(self.dataNetwork.DSRTable) do
				-- Try to send the Items to the Deep Storage --
				local inserted = dsr:addItem(item, math.min(count, dsr:availableSpace()))
				-- Remove the Items from the Inventory --
				if inserted > 0 then
					inv.remove({name=item, count=inserted})
					-- Create the Projectile --
					self:createOreBeam(item, target)
				end
				-- Decrease the count --
				count = count - inserted
			end
			-- Send to the Data Network if there are still Items left --
			if count > 0 then
				local inserted = self.dataNetwork:addItems(item, count)
				-- Remove the Items from the Inventory --
				if inserted > 0 then
					inv.remove({name=item, count=inserted})
					-- Create the Projectile --
					self:createOreBeam(item, target)
				end
				-- Decrease the count --
				count = count - inserted
			end
		end
	end

end

-- Called if the Player interacted with the GUI --
function OC.interaction(event, MFPlayer)

	-- Open Inventory --
	if string.match(event.element.name, "O.C.OpenInvButton") then
		-- Get the Object --
		local objId = event.element.tags.ID
		local ent = global.oreCleanerTable[objId].ent
		if ent ~= nil and ent.valid == true then
			MFPlayer.ent.opened = ent
		end
		return
	end

	-- Select Data Network --
	if string.match(event.element.name, "O.C.DNSelect") then
		local objId = event.element.tags.ID
		local obj = global.oreCleanerTable[objId]
		if obj == nil then return end
		-- Get the Mobile Factory --
		local selectedMF = getMF(event.element.items[event.element.selected_index])
		if selectedMF == nil then return end
		-- Set the New Data Network --
		obj.dataNetwork = selectedMF.dataNetwork
		-- Remove the Selected Inventory --
		obj.selectedInv = nil
		return
	end

	-- Select Targed --
	if string.match(event.element.name, "O.C.TargetDD") then
		local objId = event.element.tags.ID
		local obj = global.oreCleanerTable[objId]
		if obj == nil then return end
		-- Change the Ore Cleaner targeted Deep Storage --
		obj:changeInventory(event.element)
	end

end

-- Change the Targeted Inventory --
function OC:changeInventory(element)

	-- If None is selected --
	if element.selected_index == 1 then
		self.selectedInv = nil
		return
	end

	-- If Auto is selected --
	if element.selected_index == 2 then
		self.selectedInv = -1
		return
	end

	-- If Data Network is selected --
	if element.selected_index == 3 then
		self.selectedInv = -2
		return
	end

	local ID = tonumber(element.items[element.selected_index][5])

	-- Check the ID --
	if ID == nil then
		self.selectedInv = nil
		return
	end

	-- Select the Inventory --
	self.selectedInv = nil
	for _, deepStorage in pairs(self.dataNetwork.DSRTable) do
		if valid(deepStorage) == true then
			if ID == deepStorage.ID then
				self.selectedInv = deepStorage
			end
		end
	end

end

function OC:createOreBeam(itemName, target)
	local positionX = self.ent.position.x + (math.random(-200, 200)/100)
	local positionY = self.ent.position.y + (math.random(-200, 200)/100)
	self.ent.surface.create_entity{name="OreCleanerProjectile:" .. itemName, position={positionX,positionY}, target=target, speed=0.25, max_range=999}
end

-- Add Quatron (Return the amount added) --
function OC:addQuatron(amount, level)
	if EI.energy(self) > 0 then
		EI.mixQuatron(self, amount, level)
	else
		self.energyCharge = amount
		self.energyLevel = level
	end
	return amount
end