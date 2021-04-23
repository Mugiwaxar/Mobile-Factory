-- RESOURCES COLLECTOR TABLE --

RCL = {}

-- Constructor --
function RCL.new(ent)

	-- Check the Entity --
	if ent == nil then return end
	if ent.last_user == nil then return end

	-- Create the Table --
	local t = {}
	t.meta = "RCL"
	t.ent = ent
	t.player = ent.last_user.name
	t.MF = getMF(t.player)
	t.entID = ent.unit_number
	t.dataNetwork = t.MF.dataNetwork
	t.resourcesTable = {}  -- {ent, infinite?}
	t.selectedInv = -1
	t.selectedDTK = -1
	t.lightAnID = nil
	t.updateTick = 20
	t.lastOreDNSend = 0
	t.lastFluidDNSend = 0
	t.lastUpdate = 0
	t.lastScan = 0
	t.consumption = 0
	t.collectOres = true
	t.collectFluids = true
	t.outOfQuatron = false
	t.inventoryFull = false
	t.energyCharge = 0
	t.energyLevel = 1
	t.energyBuffer = _mfRCLMaxCharge

	-- Get the Inventory --
	t.chest = t.ent.get_inventory(defines.inventory.chest)

	-- Create the Tank --
	t.tank = ent.surface.create_entity{name="ResourcesCollectorTank", position=ent.position, force=ent.force}

	-- Save the Object inside the Tables --
	global.objectsTable[ent.unit_number] = t
	table.insert(global.ResourceCollectorTable, t)

	-- Scan all Resources around --
	RCL.scanResources(t, ent)

	return t

end

-- Destructor --
function RCL.remove(obj)
	-- Destroy the Animation --
	rendering.destroy(obj.lightAnID or 0)
	-- Destroy the Tank --
	if obj.tank ~= nil and obj.tank.valid == true then obj.tank.destroy() end
	-- Remove from the Network Access Point --
	if obj.networkAccessPoint ~= nil and obj.ent ~= nil and obj.ent.valid == true then
		obj.networkAccessPoint.objTable[obj.ent.unit_number] = nil
	end
	-- Remove from the Objects the Tables --
	global.objectsTable[obj.entID] = nil
	for k, rcl in pairs(global.ResourceCollectorTable) do
		if rcl == obj then
			table.remove(global.ResourceCollectorTable, k)
		end
	end
end

-- Is valid --
function RCL.valid(obj)
	if obj.ent ~= nil and obj.ent.valid then return true end
	return false
end

-- Copy Settings --
function RCL.copySettings(obj1, obj2)
	obj1.selectedInv = obj2.selectedInv
end

-- Item Tags to Content --
function RCL.itemTagsToContent(obj, tags)
	obj.energyCharge = tags.charge or 0
	obj.energyLevel = tags.purity or 1
end

-- Content to Item Tags --
function RCL.contentToItemTags(obj, tags)
	if EI.energy(obj) > 0 then
		tags.set_tag("Infos", {charge=EI.energy(obj), purity=EI.energyLevel(obj)})
		tags.custom_description = {"", tags.prototype.localised_description, {"item-description.ResourcesCollectorC", math.floor(EI.energy(obj)), string.format("%.3f", EI.energyLevel(obj))}}
	end
end

-- Settings To Blueprint Tags --
function RCL.settingsToBlueprintTags(obj)
	local tags = {}
	if type(obj.selectedInv) == "table" then
		tags["SelectedInv"] = obj.selectedInv.ID
	else
		tags["SelectedInv"] = obj.selectedInv or -3
	end
	return tags
end

-- Blueprint Tags To Settings --
function RCL.blueprintTagsToSettings(obj, tags)
	obj.selectedInv = tags["SelectedInv"]
	if obj.selectedInv == -3 then obj.selectedInv = nil end
	if obj.selectedInv > 0 then
		for _, deepStorage in pairs(obj.dataNetwork.DSRTable) do
			if valid(deepStorage) == true then
				if obj.selectedInv == deepStorage.ID then
					obj.selectedInv = deepStorage
				end
			end
		end
	end
end

-- Tooltip Infos --
function RCL.getTooltipInfos(obj, GUITable, mainFrame, justCreated)

	-- Create the Data Network Frame --
	DN.addDataNetworkFrame(GUITable, mainFrame, obj, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.ResourcesCollector"}

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

		-- Create the Inventory Flow and Button --
		local inventoryFlow = GAPI.addFlow(GUITable, "", inventoryFrame, "horizontal")
		inventoryFlow.style.horizontal_align = "center"
		inventoryFlow.style.bottom_margin = 15
		GAPI.addSimpleButton(GUITable, "R.C.L.OpenInvButton", inventoryFlow, {"gui-description.OpenInventory"}, "", false, {ID=obj.entID})

		-- Create the Inventory Table --
		GAPI.addTable(GUITable, "InventoryTable", inventoryFrame, 1, true)

		-- Create the Settings Frame --
		local settingsFrame = GAPI.addFrame(GUITable, "SettingsFrame", mainFrame, "vertical", true)
		settingsFrame.style = "MFFrame1"
		settingsFrame.style.vertically_stretchable = true
		settingsFrame.style.left_padding = 3
		settingsFrame.style.right_padding = 3
		settingsFrame.style.left_margin = 3
		settingsFrame.style.right_margin = 3

		-- Add the Title --
		GAPI.addSubtitle(GUITable, "", settingsFrame, {"gui-description.Settings"})

		------------------------------------------------------ COLLECT SETTINGS ------------------------------------------------------

		-- Add the Collect Ores Flow --
		local collectOresFlow = GAPI.addFlow(GUITable, "", settingsFrame, "horizontal")
		-- Add the Collect Ores Label --
		GAPI.addLabel(GUITable, "", collectOresFlow, {"gui-description.RCLCollectOres"}, nil, "", false, nil, _mfLabelType.yellowTitle)
		-- Add the Collect Ores Switch --
		local state = obj.collectOres == true and "right" or "left"
		GAPI.addSwitch(GUITable, "R.C.L.CollectOres", collectOresFlow, {"gui-description.No"}, {"gui-description.Yes"}, nil, nil, state, false, {ID=obj.ent.unit_number})

		-- Add the Collect Fluids Flow --
		local collectFluidFlow = GAPI.addFlow(GUITable, "", settingsFrame, "horizontal")
		-- Add the Collect Fluids Label --
		GAPI.addLabel(GUITable, "", collectFluidFlow, {"gui-description.RCLCollectFluids"}, nil, "", false, nil, _mfLabelType.yellowTitle)
		-- Add the Collect Fluid Switch --
		state = obj.collectFluids == true and "right" or "left"
		GAPI.addSwitch(GUITable, "R.C.L.CollectFluids", collectFluidFlow, {"gui-description.No"}, {"gui-description.Yes"}, nil, nil, state, false, {ID=obj.ent.unit_number})

		------------------------------------------------------ DEEP STORAGE SELECTION ------------------------------------------------------

		-- Create the Select Storage Label --
		GAPI.addLabel(GUITable, "", settingsFrame, {"gui-description.RCLTargetedOresStorage"}, nil, "", false, nil, _mfLabelType.yellowTitle)

		-- Create the Storage List --
		local invs = {{"gui-description.None"}, {"gui-description.Auto"}, {"gui-description.DataNetwork"}}
		local selectedIndex = 1
		-- Change the selected Index --
		if obj.selectedInv == -1 then
			selectedIndex = 2
		elseif obj.selectedInv == -2 then
			selectedIndex = 3
		end

		-- List all Deep Storages --
		local i = 3
		for _, deepStorage in pairs(obj.dataNetwork.DSRTable) do

			-- Check the Deep Storage --
			if deepStorage ~= nil and deepStorage.ent ~= nil then
				i = i + 1

				-- Check the Deep Storage Item/Filter --
				local item = nil
				if deepStorage.inventoryItem ~= nil then
					item = deepStorage.inventoryItem
				elseif deepStorage.filter ~= nil then
					item = deepStorage.filter
				end

				-- Create the Name --
				if item ~= nil then
					table.insert(invs, {"", "[img=item/"..item.."] ", game.item_prototypes[item].localised_name, " - ", deepStorage.ID})
				else
					table.insert(invs, {"", "", {"gui-description.Empty"}, " - ", deepStorage.ID})
				end

				-- Check if the Deep Storage is selected --
				if type(obj.selectedInv) == "table" and obj.selectedInv.entID ~= nil then
					if obj.selectedInv.entID == deepStorage.entID then
						selectedIndex = i
					end
				end

			end
		end

		-- Check the selected Index --
		if selectedIndex ~= nil and selectedIndex > table_size(invs) then selectedIndex = nil end

		-- Add the Selected Deep Tank Drop Down --
		GAPI.addDropDown(GUITable, "R.C.L.TargetDSR", settingsFrame, invs, selectedIndex, false, {"gui-description.RCLOresInventorySelectTT"}, {ID=obj.ent.unit_number})

		------------------------------------------------------ DEEP TANK SELECTION ------------------------------------------------------

		-- Create the Select Storage Label --
		GAPI.addLabel(GUITable, "", settingsFrame, {"gui-description.RCLTargetedFluidStorage"}, nil, "", false, nil, _mfLabelType.yellowTitle)

		-- Create the Storage List --
		invs = {{"gui-description.None"}, {"gui-description.Auto"}}
		selectedIndex = 1
		-- Change the selected Index --
		if obj.selectedDTK == -1 then
			selectedIndex = 2
		elseif obj.selectedDTK == -2 then
			selectedIndex = 3
		end

		-- List all Deep Storages --
		i = 2
		for _, deepTank in pairs(obj.dataNetwork.DTKTable) do

			-- Check the Deep Storage --
			if deepTank ~= nil and deepTank.ent ~= nil then
				i = i + 1

				-- Check the Deep Storage Fluid/Filter --
				local fluid = nil
				if deepTank.inventoryFluid ~= nil then
					fluid = deepTank.inventoryFluid
				elseif deepTank.filter ~= nil then
					fluid = deepTank.filter
				end

				-- Create the Name --
				if fluid ~= nil then
					table.insert(invs, {"", "[img=fluid/"..fluid.."] ", game.fluid_prototypes[fluid].localised_name, " - ", deepTank.ID})
				else
					table.insert(invs, {"", "", {"gui-description.Empty"}, " - ", deepTank.ID})
				end

				-- Check if the Deep Tank is selected --
				if type(obj.selectedDTK) == "table" and obj.selectedDTK.entID ~= nil then
					if obj.selectedDTK.entID == deepTank.entID then
						selectedIndex = i
					end
				end

			end
		end

		-- Check the selected Index --
		if selectedIndex ~= nil and selectedIndex > table_size(invs) then selectedIndex = nil end

		-- Add the Selected Deep Tank Drop Down --
		GAPI.addDropDown(GUITable, "R.C.L.TargetDTK", settingsFrame, invs, selectedIndex, false, {"gui-description.RCLFluidInventorySelectTT"}, {ID=obj.ent.unit_number})

	end

	-- Get the Information Table --
	local informationTable = GUITable.vars.InformationTable

	-- Clear Information the Table --
	informationTable.clear()

	-- Add the Quatron Charge --
    GAPI.addLabel(GUITable, "", informationTable, {"gui-description.QuatronCharge", Util.toRNumber(EI.energy(obj)) }, _mfOrange)
	GAPI.addProgressBar(GUITable, "", informationTable, "", EI.energy(obj) .. "/" .. EI.maxEnergy(obj), false, _mfPurple, EI.energy(obj)/EI.maxEnergy(obj), 100)

	-- Create the Quatron Purity --
	GAPI.addLabel(GUITable, "", informationTable, {"gui-description.Quatronlevel", string.format("%.3f", EI.energyLevel(obj))}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", informationTable, "", "", false, _mfPurple, EI.energyLevel(obj)/20, 100)

	-- Create the Speed --
	local speed = math.floor((math.pow(EI.energyLevel(obj), _mfQuatronScalePower) + _mfOreCleanerResourcesPerExtraction) * EI.energyLevel(obj) * 3)
	local speedLabel = GAPI.addLabel(GUITable, "", informationTable, {"gui-description.RCLSpeed", speed}, _mfOrange)
	speedLabel.style.top_margin = 10

	-- Create the Resource Label --
	GAPI.addLabel(GUITable, "", informationTable, {"", {"gui-description.RCLPathsCount"}, " [color=yellow]", table_size(obj.resourcesTable), "[/color]"}, _mfOrange)

	-- Create the Mobile Factory Too Far Label --
	if obj.outOfQuatron == true then
		GAPI.addLabel(GUITable, "", informationTable, {"gui-description.OutOfQuatron"}, _mfRed)
	end

	-- Create the Mobile Factory Too Far Label --
	if obj.inventoryFull == true then
		GAPI.addLabel(GUITable, "", informationTable, {"gui-description.InventoryFull"}, _mfRed)
	end

	-- Get the Inventory Table --
	local inventoryTable = GUITable.vars.InventoryTable

	-- Clear Inventory the Table --
	inventoryTable.clear()

	-- Get all Fluids Name --
	local fluidsName1 = nil
	local fluidsName2 = nil
	local fluidsName3 = nil
	local fluidsName4 = nil
	
	-- Get all Fluids amount --
	local fluidsAmount1 = 0
	local fluidsAmount2 = 0
	local fluidsAmount3 = 0
	local fluidsAmount4 = 0

	-- Get all Fluids Color --
	local fluidsColor1 = nil
	local fluidsColor2 = nil
	local fluidsColor3 = nil
	local fluidsColor4 = nil

	-- Get the Fluids Tooltips --
	local fluidsTT1 = {"gui-description.Empty"}
	local fluidsTT2 = {"gui-description.Empty"}
	local fluidsTT3 = {"gui-description.Empty"}
	local fluidsTT4 = {"gui-description.Empty"}

	-- Get the Fluid 1 --
	if obj.tank ~= nil and obj.tank.fluidbox[1] ~= nil then
		fluidsName1 = obj.tank.fluidbox[1].name
		fluidsAmount1 = obj.tank.fluidbox[1].amount
		fluidsColor1 = game.fluid_prototypes[fluidsName1].base_color
		fluidsTT1 = {"", Util.getLocFluidName(fluidsName1), ": ", fluidsAmount1, "/", _mfRCLTankSize}
	end

	-- Get the Fluid 2 --
	if obj.tank ~= nil and obj.tank.fluidbox[2] ~= nil then
		fluidsName2 = obj.tank.fluidbox[2].name
		fluidsAmount2 = obj.tank.fluidbox[2].amount
		fluidsColor2 = game.fluid_prototypes[fluidsName2].base_color
		fluidsTT2 = {"", Util.getLocFluidName(fluidsName2), ": ", fluidsAmount2, "/", _mfRCLTankSize}
	end

	-- Get the Fluid 3 --
	if obj.tank ~= nil and obj.tank.fluidbox[3] ~= nil then
		fluidsName3 = obj.tank.fluidbox[3].name
		fluidsAmount3 = obj.tank.fluidbox[3].amount
		fluidsColor3 = game.fluid_prototypes[fluidsName3].base_color
		fluidsTT3 = {"", Util.getLocFluidName(fluidsName3), ": ", fluidsAmount3, "/", _mfRCLTankSize}
	end

	-- Get the Fluid 4 --
	if obj.tank ~= nil and obj.tank.fluidbox[4] ~= nil then
		fluidsName4 = obj.tank.fluidbox[4].name
		fluidsAmount4 = obj.tank.fluidbox[4].amount
		fluidsColor4 = game.fluid_prototypes[fluidsName4].base_color
		fluidsTT4 = {"", Util.getLocFluidName(fluidsName4), ": ", fluidsAmount4, "/", _mfRCLTankSize}
	end

	-- Create the Tank 1 Progress Bar --
	GAPI.addLabel(GUITable, "", inventoryTable, {"gui-description.RCLTank1", Util.getLocFluidName(fluidsName1) or {"gui-description.Empty"}}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", inventoryTable, nil, fluidsTT1, false, fluidsColor1, fluidsAmount1/_mfRCLTankSize, nil)

	-- Create the Tank 2 Progress Bar --
	GAPI.addLabel(GUITable, "", inventoryTable, {"gui-description.RCLTank2", Util.getLocFluidName(fluidsName2) or {"gui-description.Empty"}}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", inventoryTable, nil, fluidsTT2, false, fluidsColor2, fluidsAmount2/_mfRCLTankSize, nil)

	-- Create the Tank 3 Progress Bar --
	GAPI.addLabel(GUITable, "", inventoryTable, {"gui-description.RCLTank3", Util.getLocFluidName(fluidsName3) or {"gui-description.Empty"}}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", inventoryTable, nil, fluidsTT3, false, fluidsColor3, fluidsAmount3/_mfRCLTankSize, nil)

	-- Create the Tank 4 Progress Bar --
	GAPI.addLabel(GUITable, "", inventoryTable, {"gui-description.RCLTank4", Util.getLocFluidName(fluidsName4) or {"gui-description.Empty"}}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", inventoryTable, nil, fluidsTT4, false, fluidsColor4, fluidsAmount4/_mfRCLTankSize, nil)

end

-- Update --
function RCL.update(obj)

    -- Set the lastUpdate variable --
    obj.lastUpdate = game.tick

    -- Check the Validity --
    if RCL.valid(obj) == false then
        RCL.remove(obj)
        return
    end

	-- Try to get Quatron from the Network Access Point --
	if EI.energy(obj) <= 100 and obj.networkAccessPoint ~= nil then
		local chargeToBorrow = math.min(EI.energy(obj.networkAccessPoint), EI.maxEnergy(obj) - EI.energy(obj))
		if chargeToBorrow > 0 then
			local added = RCL.addQuatron(obj, chargeToBorrow, EI.energyLevel(obj.networkAccessPoint))
			EI.removeEnergy(obj.networkAccessPoint, added)
			obj.outOfQuatron = false
		end
	end

    -- Collect Resources --
    RCL.collectResources(obj)

	-- Try to find a Network Access Point if needed --
	if valid(obj.networkAccessPoint) == false or obj.dataNetwork ~= obj.networkAccessPoint.dataNetwork then
		obj.networkAccessPoint = obj.dataNetwork:getCloserNAP(obj)
		if obj.networkAccessPoint ~= nil then
			obj.networkAccessPoint.objTable[obj.ent.unit_number] = obj
		end
	end

	-- Send the Ores to the Data Network --
	if game.tick - obj.lastOreDNSend > 79 then
		obj.lastOreDNSend = game.tick
		RCL.sendOreToDN(obj)
	end

	-- Send the Fluids to the Data Network --
	if game.tick - obj.lastFluidDNSend > 59 then
		obj.lastFluidDNSend = game.tick
		RCL.sendFluidToDN(obj)
	end

	-- Scan Resources around --
	if game.tick - obj.lastScan > 200 and table_size(obj.resourcesTable) < math.floor(EI.energyLevel(obj)) then
		obj.lastScan = game.tick
		RCL.scanResources(obj, obj.ent)
	end

    -- Draw the Animation --
	if obj.inventoryFull == true or obj.outOfQuatron == true then
		rendering.destroy(obj.lightAnID or 0)
		obj.lightAnID = nil
    elseif obj.lightAnID == nil or rendering.is_valid(obj.lightAnID) == false then
        obj.lightAnID = rendering.draw_animation{animation="ResourcesCollectorAn", target=obj.ent.position, surface=obj.ent.surface, render_layer=144, animation_speed=0.3}
    end

end

-- Scan surronding Ores --
function RCL.scanResources(obj, entity)

	-- Return if there are not Quatron Charge remaining --
	if EI.energy(obj) < 3 then
		obj.outOfQuatron = true
		return
	else
		obj.outOfQuatron = false
	end

	-- Clean the Resources Table --
	obj.resourcesTable = {}

	-- Test if the Entity is valid --
	if entity == nil or entity.valid == false then return end

	-- Test if the Surface is valid --
	if entity.surface == nil then return end

	-- Calculate the Radius --
	local area = {{entity.position.x-_mfRCLRadius,entity.position.y-_mfRCLRadius},{entity.position.x+_mfRCLRadius,entity.position.y+_mfRCLRadius}}

	-- Check what have to be collected --
	if obj.collectOres == true and obj.collectFluids == true then
		-- Collect every Resources --
		obj.resourcesTable = entity.surface.find_entities_filtered{area=area, type="resource", limit=EI.energyLevel(obj)}
	elseif obj.collectOres == true and obj.collectFluids == false then
		-- Collect Ores Only --
		obj.resourcesTable = entity.surface.find_entities_filtered{area=area, type="resource", name=global.oresTable, limit=EI.energyLevel(obj)}
	elseif obj.collectOres == false and obj.collectFluids == true then
		-- Collect Fluids Only --
		obj.resourcesTable = entity.surface.find_entities_filtered{area=area, type="resource", name=global.fluidsTable, limit=EI.energyLevel(obj)}
	end

end

-- Collect surrounding Resources --
function RCL.collectResources(obj)

	-- Get the Energy Level --
	local quatron = EI.energy(obj)

    -- Calcule the amount of Resources to extract --
    local toExtract = math.floor(math.pow(EI.energyLevel(obj), _mfQuatronScalePower) + _mfOreCleanerResourcesPerExtraction)

    -- Get the Inventory --
    local inv = obj.chest

    -- Do the job for all Resources inside the Table --
    for _, resourcesPath in pairs(obj.resourcesTable) do

		-- Stop if we are out of Quatron --
		if quatron < 3 then
			obj.outOfQuatron = true
			break
		else
			obj.outOfQuatron = false
		end

        -- Check the Path --
        if resourcesPath == nil or resourcesPath.valid == false then
			for k, op in pairs(obj.resourcesTable) do
				if op == resourcesPath then
            		table.remove(obj.resourcesTable, k)
				end
			end
			goto continue
		end

        -- Calculate the amout of Resources that will be extracted --
        local resourcesExtracted = math.min(toExtract, resourcesPath.amount)

        -- Itinerate all Products --
        local added = 0
		local isFluid = false
        for _, product in pairs(global.ResourcesProductsTable[resourcesPath.name]) do
			-- Calculate how many products can be extracted --
			local amount = product.amount or math.random(product.min, product.max)
			local inserted = 0
			-- If this is an Item --
			if product.type == "item" and obj.collectOres == true and math.random(0, 100) <= product.probability*100 then
				-- Insert the Product inside the Inventory --
				inserted = inv.insert({name=product.name, count=amount*resourcesExtracted})
			-- If this is a Fluid --
			elseif product.type == "fluid" and obj.collectFluids == true and math.random(0, 100) <= product.probability*100 then
				-- Insert the Fluid inside the Tank --
				if obj.tank ~= nil then
					inserted = obj.tank.insert_fluid({name=product.name, amount=(amount*resourcesExtracted)/10})
					isFluid = true
				end
			end
			-- Check if something was inserted --
			if inserted > 0 then
				-- Register the amount inserted if this is the main Product --
				added = math.max(inserted, added)
				-- Create the Projectile --
				obj.ent.surface.create_entity{name="RCLProjectile:" .. product.name, position=resourcesPath.position, target=obj.ent, speed=0.1, max_range=999, force=obj.ent.force}
				obj.inventoryFull = false
			else
				obj.inventoryFull = true
			end
        end

        -- Check if something was extrated --
        if added <= 0 then goto continue end

		-- Increase the number of Extractions --
		quatron = quatron - 3

        -- Remove Resources from the Resources Path --
		if resourcesPath.prototype.infinite_resource ~= true or isFluid == true then
        	resourcesPath.amount = math.max(resourcesPath.amount - added, 1)
		end

		-- Remove the Resource Path if it is empty --
        if resourcesPath.amount <= 1 then
            resourcesPath.deplete()
			for k, op in pairs(obj.resourcesTable) do
				if op == resourcesPath then
            		table.remove(obj.resourcesTable, k)
				end
			end
        end

		::continue::

    end

	-- Remove a Quatron Charge --
	EI.setEnergy(obj, quatron)

end

-- Send the Ore Inside to the Data Network --
function RCL.sendOreToDN(obj)

	-- Stop if the selected Inventory is None --
	if obj.selectedInv == nil then return end

	-- Get the Inventory --
    local inv = obj.chest

	-- Check if the Mobile Factory is close --
	local MFTooFar = true
	if obj.MF.ent ~= nil and obj.MF.ent.valid == true and obj.ent.surface == obj.MF.ent.surface and Util.distance(obj.ent.position, obj.MF.ent.position) <= _mfOreCleanerMaxDistance then
		MFTooFar = false
	end

	-- Get the Ore Cleaner Target --
	local target = nil
	if MFTooFar == false then
		target = obj.MF.ent
	end
	if MFTooFar == false and valid(obj.networkAccessPoint) and EI.energy(obj.networkAccessPoint) > 0 and Util.distance(obj.ent.position, obj.MF.ent.position) > Util.distance(obj.ent.position, obj.networkAccessPoint.ent.position) then
		target = obj.networkAccessPoint.ent
	end
	if MFTooFar == true and valid(obj.networkAccessPoint) and EI.energy(obj.networkAccessPoint) > 0 then
		target = obj.networkAccessPoint.ent
	end

	-- Check the Target --
	if target == nil then return end

	-- If the Selected Inventory is a Deep Storage --
	if valid(obj.selectedInv) == true then
		-- Get the Deep Storage --
		local dsr = obj.selectedInv
		-- Get the Deep Storage Item or Filter --
		local itemName = dsr.inventoryItem or dsr.filter
		-- Check the Name --
		if itemName == nil then return end
		-- Check if the Resource Collector Inventory has this item --
		local itemCount = inv.get_item_count(itemName)
		-- Try to send the Item count to the Deep Storage --
		local inserted = dsr:addItem(itemName, math.min(itemCount, dsr:availableSpace()))
		-- Remove the Items from the Inventory --
		if inserted > 0 then
			inv.remove({name=itemName, count=inserted})
			-- Create the Projectile --
			RCL.createOreBeam(obj, itemName, target)
		end
	end

	-- If the Selected Inventory is Auto --
	if obj.selectedInv == -1 then
		-- Get all Items inside the Resource Collector Inventory --
		for item, count in pairs(inv.get_contents()) do
			-- Check all Deep Storages --
			for _, dsr in pairs(obj.dataNetwork.DSRTable) do
				-- Try to send the Items to the Deep Storage --
				local inserted = dsr:addItem(item, math.min(count, dsr:availableSpace()))
				-- Remove the Items from the Inventory --
				if inserted > 0 then
					inv.remove({name=item, count=inserted})
					-- Create the Projectile --
					RCL.createOreBeam(obj, item, target)
				end
				-- Decrease the count --
				count = count - inserted
			end
		end
	end

	-- If the Selected Inventory is Data Network --
	if obj.selectedInv == -2 then
		-- Get all Items inside the Ore Cleaner Inventory --
		for item, count in pairs(inv.get_contents()) do
			-- Check all Deep Storages --
			for _, dsr in pairs(obj.dataNetwork.DSRTable) do
				-- Try to send the Items to the Deep Storage --
				local inserted = dsr:addItem(item, math.min(count, dsr:availableSpace()))
				-- Remove the Items from the Inventory --
				if inserted > 0 then
					inv.remove({name=item, count=inserted})
					-- Create the Projectile --
					RCL.createOreBeam(obj, item, target)
				end
				-- Decrease the count --
				count = count - inserted
			end
			-- Send to the Data Network if there are still Items left --
			if count > 0 then
				local inserted = obj.dataNetwork:addItems(item, count)
				-- Remove the Items from the Inventory --
				if inserted > 0 then
					inv.remove({name=item, count=inserted})
					-- Create the Projectile --
					RCL.createOreBeam(obj, item, target)
				end
				-- Decrease the count --
				count = count - inserted
			end
		end
	end

end

function RCL.sendFluidToDN(obj)

	-- Check the Tank --
	if obj.tank == nil or obj.tank.valid == false then return end

	-- Stop if the selected Deep Tank is none --
	if obj.selectedDTK == nil then return end

	-- Check if the Mobile Factory is close --
	local MFTooFar = true
	if obj.MF.ent ~= nil and obj.MF.ent.valid == true and obj.ent.surface == obj.MF.ent.surface and Util.distance(obj.ent.position, obj.MF.ent.position) <= _mfOreCleanerMaxDistance then
		MFTooFar = false
	end

	-- Get the Ore Cleaner Target --
	local target = nil
	if MFTooFar == false then
		target = obj.MF.ent
	end
	if MFTooFar == false and valid(obj.networkAccessPoint) and EI.energy(obj.networkAccessPoint) > 0 and Util.distance(obj.ent.position, obj.MF.ent.position) > Util.distance(obj.ent.position, obj.networkAccessPoint.ent.position) then
		target = obj.networkAccessPoint.ent
	end
	if MFTooFar == true and valid(obj.networkAccessPoint) and EI.energy(obj.networkAccessPoint) > 0 then
		target = obj.networkAccessPoint.ent
	end

	-- Check the Target --
	if target == nil then return end

	-- If the Selected Inventory is a Deep Tank --
	if valid(obj.selectedDTK) == true then
		-- Get the Deep Tank --
		local dtk = obj.selectedDTK
		-- Get the Deep Tank Fluid or Filter --
		local fluidName = dtk.inventoryFluid or dtk.filter
		-- Check the name --
		if fluidName == nil then return end
		-- Check if the Resource Collector Tank has this Fluid --
		local fluidCount = obj.tank.get_fluid_count(fluidName)
		-- Try to send the Fluid count to the Deep Tank --
		local inserted = dtk:addFluid{name=fluidName, amount=math.min(fluidCount, dtk:availableSpace())}
		-- Remove the Items from the Inventory --
		if inserted > 0 then
			obj.tank.remove_fluid{name=fluidName, amount=inserted}
			-- Create the Projectile --
			RCL.createOreBeam(obj, fluidName, target)
		end
	end

	-- If the Selected Inventory is Auto --
	if obj.selectedInv == -1 then
		-- Get all Fluids inside the Resource Collector Tank --
		for fluid, count in pairs(obj.tank.get_fluid_contents()) do
			-- Check all Deep Tank --
			for _, dtk in pairs(obj.dataNetwork.DTKTable) do
				-- Try to send the Fluids to the Deep Storage --
				local inserted = dtk:addFluid{name=fluid, amount=math.min(count, dtk:availableSpace())}
				-- Remove the Fluids from the Inventory --
				if inserted > 0 then
					obj.tank.remove_fluid{name=fluid, amount=inserted}
					-- Create the Projectile --
					RCL.createOreBeam(obj, fluid, target)
				end
				-- Decrease the count --
				count = count - inserted
			end
		end
	end

end

-- Called if the Player interacted with the GUI --
function RCL.interaction(event, MFPlayer)

	-- Open Inventory --
	if string.match(event.element.name, "R.C.L.OpenInvButton") then
		-- Get the Object --
		local objId = event.element.tags.ID
		local ent = global.objectsTable[objId].ent
		if ent ~= nil and ent.valid == true then
			MFPlayer.ent.opened = ent
		end
		return
	end

	-- Select Data Network --
	if string.match(event.element.name, "R.C.L.DNSelect") then
		local objId = event.element.tags.ID
		local obj = global.objectsTable[objId]
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

	-- Collect Ores --
	if string.match(event.element.name, "R.C.L.CollectOres") then
		local objId = event.element.tags.ID
		local obj = global.objectsTable[objId]
		if obj == nil then return end
		-- Change the Collect Ores Setting --
		local state = event.element.switch_state == "right" and true or false
		obj.collectOres = state
		RCL.scanResources(obj, obj.ent)
	end

	-- Collect Fluids --
	if string.match(event.element.name, "R.C.L.CollectFluids") then
		local objId = event.element.tags.ID
		local obj = global.objectsTable[objId]
		if obj == nil then return end
		-- Change the Collect Fludis Setting --
		local state = event.element.switch_state == "right" and true or false
		obj.collectFluids = state
		RCL.scanResources(obj, obj.ent)
	end

	-- Select Deep Storage --
	if string.match(event.element.name, "R.C.L.TargetDSR") then
		local objId = event.element.tags.ID
		local obj = global.objectsTable[objId]
		if obj == nil then return end
		-- Change the Ore Cleaner targeted Deep Storage --
		RCL.changeDSR(obj, event.element)
	end

	-- Select Deep Tank --
	if string.match(event.element.name, "R.C.L.TargetDTK") then
		local objId = event.element.tags.ID
		local obj = global.objectsTable[objId]
		if obj == nil then return end
		-- Change the Ore Cleaner targeted Deep Storage --
		RCL.changeDTK(obj, event.element)
	end

end

-- Change the Targeted Deep Storage --
function RCL.changeDSR(obj, element)

	-- If None is selected --
	if element.selected_index == 1 then
		obj.selectedInv = nil
		return
	end

	-- If Auto is selected --
	if element.selected_index == 2 then
		obj.selectedInv = -1
		return
	end

	-- If Data Network is selected --
	if element.selected_index == 3 then
		obj.selectedInv = -2
		return
	end

	-- Get the Deep Storage ID --
	local ID = tonumber(element.items[element.selected_index][5])

	-- Check the ID --
	if ID == nil then
		obj.selectedInv = nil
		return
	end

	-- Select the Inventory --
	obj.selectedInv = nil
	for _, deepStorage in pairs(obj.dataNetwork.DSRTable) do
		if valid(deepStorage) == true then
			if ID == deepStorage.ID then
				obj.selectedInv = deepStorage
			end
		end
	end

end

-- Change the Targeted Deep Tank --
function RCL.changeDTK(obj, element)

	-- If None is selected --
	if element.selected_index == 1 then
		obj.selectedDTK = nil
		return
	end

	-- If Auto is selected --
	if element.selected_index == 2 then
		obj.selectedDTK = -1
		return
	end

	-- Get the Deep Tank ID --
	local ID = tonumber(element.items[element.selected_index][5])

	-- Check the ID --
	if ID == nil then
		obj.selectedDTK = nil
		return
	end

	-- Select the Inventory --
	obj.selectedDTK = nil
	for _, deepTank in pairs(obj.dataNetwork.DTKTable) do
		if valid(deepTank) == true then
			if ID == deepTank.ID then
				obj.selectedDTK = deepTank
			end
		end
	end

end

function RCL.createOreBeam(obj, itemName, target)
	local positionX = obj.ent.position.x + (math.random(-200, 200)/100)
	local positionY = obj.ent.position.y + (math.random(-200, 200)/100)
	obj.ent.surface.create_entity{name="RCLProjectile:" .. itemName, position={positionX,positionY}, target=target, speed=0.25, max_range=999, force=obj.ent.force}
end

-- Add Quatron (Return the amount added) --
function RCL.addQuatron(obj, amount, level)
	if EI.energy(obj) > 0 then
		EI.mixQuatron(obj, amount, level)
	else
		obj.energyCharge = amount
		obj.energyLevel = level
	end
	return amount
end