-- Create the Info GUI --
function GUI.createInfoGui(player)

	-- Get the MFPlayer --
	local MFPlayer = getMFPlayer(player.name)

	-- Create the GUI --
	local GUITable = GAPI.createBaseWindows(_mfGUIName.InfoGUI, getCurrentMF(MFPlayer).name, MFPlayer, true, false, false, "vertical", "horizontal")

	-- Add the Switch Button --
	GAPI.addButton(GUITable, "SwitchMFButton", GUITable.vars.topBarFlow, "SwitchIcon", "SwitchIcon", {"gui-description.SwitchMFButton"}, 20, false, true, nil, "frame_action_button")

	-- Add the Close Button --
	GAPI.addCloseButton(GUITable)
	
	-- Add the Buttons Bar --
	GAPI.addLine(GUITable, "", GUITable.gui, "horizontal")
	local buttonBar = GAPI.addFlow(GUITable, "ButtonBar", GUITable.gui, "horizontal", true)
	buttonBar.style.horizontal_align = "center"

	-- Add the Main Frame --
	local mainFrame = GAPI.addFrame(GUITable, "MainFrame", GUITable.gui, "horizontal", true)
	mainFrame.style = "invisible_frame"
	mainFrame.style.padding = 0
	mainFrame.style.margin = 0

	-- Create the Frames --
	local infoFrame = GAPI.addFrame(GUITable, "InfoFrame", mainFrame, "vertical", true)
	local tankFrame = GAPI.addFrame(GUITable, "TankFrame", mainFrame, "vertical", true)
	local storageFrame = GAPI.addFrame(GUITable, "StorageFrame", mainFrame, "vertical", true)
	local inventoryFrame = GAPI.addFrame(GUITable, "InventoryFrame", mainFrame, "vertical", true)

	infoFrame.style = "MFFrame1"
	tankFrame.style = "MFFrame1"
	storageFrame.style = "MFFrame1"
	inventoryFrame.style = "MFFrame1"

	infoFrame.style.top_padding = 1
	infoFrame.style.left_padding = 3
	infoFrame.style.right_padding = 3
	infoFrame.style.bottom_padding = 5
	infoFrame.style.right_margin = 3
	tankFrame.style.top_padding = 1
	tankFrame.style.bottom_padding = 5
	tankFrame.style.right_margin = 3
	storageFrame.style.top_padding = 1
	storageFrame.style.bottom_padding = 5
	storageFrame.style.right_margin = 3
	inventoryFrame.style.top_padding = 1
	inventoryFrame.style.bottom_padding = 5

	infoFrame.style.vertically_stretchable = true
	tankFrame.style.vertically_stretchable = true
	storageFrame.style.vertically_stretchable = true
	inventoryFrame.style.vertically_stretchable = true

	-- Create Frames Titles --
	GAPI.addSubtitle(GUITable, "", tankFrame, {"gui-description.mfTanksTitle"})
	GAPI.addSubtitle(GUITable, "", storageFrame, {"gui-description.mfDeepStorageTitle"})
	GAPI.addSubtitle(GUITable, "", inventoryFrame, {"gui-description.mfInventoryTitle"})

	-- Create Scroll Panes --
	local DTScrollPane = GAPI.addScrollPane(GUITable, "DTScrollPane", tankFrame, nil, true, "MF_DeepTank_scroll_pan")
	local DSScrollPane = GAPI.addScrollPane(GUITable, "DSScrollPane", storageFrame, nil, true, "MF_DeepStorage_scroll_pan")
	local InvScrollPane = GAPI.addScrollPane(GUITable, "InvScrollPane", inventoryFrame, nil, true, "MF_Inventory_scroll_pan")
	GAPI.addTable(GUITable, "InventoryTable", inventoryFrame, 1, true)
	
	DTScrollPane.style.vertically_stretchable = true
	DSScrollPane.style.vertically_stretchable = true
	InvScrollPane.style.vertically_stretchable = true
	DTScrollPane.style.minimal_width = 198
	DSScrollPane.style.minimal_width = 198
	InvScrollPane.style.minimal_width = 198
	DTScrollPane.style.left_margin = 5
	DTScrollPane.style.right_margin = 5
	DSScrollPane.style.left_margin = 5
	DSScrollPane.style.right_margin = 5
	InvScrollPane.style.left_margin = 5
	InvScrollPane.style.right_margin = 5

	-- Update the GUI --
	GUI.updateMFInfoGUI(GUITable)

	-- Return the Table --
	return GUITable

end

-- Update the Mobile Factory Info GUI --
function GUI.updateMFInfoGUI(GUITable)
	GUI.updateButtonsBar(GUITable)
	GUI.updateMFInfos(GUITable)
	GUI.updateDeepTankFrame(GUITable)
	GUI.updateDeepStorageFrame(GUITable)
	GUI.updateInventoryFrame(GUITable)
end

-- Update the Buttons Bar --
function GUI.updateButtonsBar(GUITable)

	-- Get GUI, MF and player --
	local buttonsBar = GUITable.vars.ButtonBar
	local MF = getCurrentMF(GUITable.MFPlayer)

	-- Clear the Bar --
	buttonsBar.clear()

	-------------------------------------------------------- Get Buttons Variables --------------------------------------------------------
	local showCallMFButton = technologyUnlocked("JumpDrive", getForce(MF))
	local syncAreaSprite = MF.syncAreaEnabled == true and "SyncAreaIcon" or "SyncAreaIconDisabled"
	local showFindMFButton = (MF.ent ~= nil and MF.ent.valid == false) and true or false
	local tpInsideSprite = MF.tpEnabled == true and "MFTPIcon" or "MFTPIconDisabled"
	local lockMFSprite = MF.locked == true and "LockMFCIcon" or "LockMFOIcon"
	local showEnergyDrainButton = technologyUnlocked("EnergyDrain1", getForce(MF)) and true or false
	local energyDrainSprite = MF.energyLaserActivated == true and "EnergyDrainIcon" or "EnergyDrainIconDisabled"
	local showFluidDrainButton = technologyUnlocked("FluidDrain1", getForce(MF)) and true or false
	local fluidDrainSprite = MF.fluidLaserActivated == true and "FluidDrainIcon" or "FluidDrainIconDisabled"
	local showItemDrainButton = technologyUnlocked("TechItemDrain", getForce(MF)) and true or false
	local itemDrainSprite = MF.itemLaserActivated == true and "ItemDrainIcon" or "ItemDrainIconDisabled"
	local showQuatronDrainButton = technologyUnlocked("EnergyDrain1", getForce(MF)) and technologyUnlocked("QuatronLogistic", getForce(MF)) and true or false
	local quatronDrainSprite = MF.quatronLaserActivated == true and "QuatronIcon" or "QuatronIconDisabled"


	-------------------------------------------------------- Update all Buttons --------------------------------------------------------
	GAPI.addButton(GUITable, "PortOutsideButton", buttonsBar, "PortIcon", "PortIcon", {"gui-description.teleportOutsideButton"}, _mfInfoGUIButtonsSize, true)
	GAPI.addButton(GUITable, "JumpDriveButton", buttonsBar, "MFJDIcon", "MFJDIcon", {"gui-description.jumpDriveButton"}, _mfInfoGUIButtonsSize, true, showCallMFButton)
	GAPI.addButton(GUITable, "SyncAreaButton", buttonsBar, syncAreaSprite, syncAreaSprite, {"gui-description.syncAreaButton"}, _mfInfoGUIButtonsSize, true)
	GAPI.addButton(GUITable, "FindMFButton", buttonsBar, "MFIconExc", "MFIconExc", {"gui-description.fixMFButton"}, _mfInfoGUIButtonsSize, true, showFindMFButton)
	GAPI.addButton(GUITable, "TPInsideButton", buttonsBar, tpInsideSprite, tpInsideSprite, {"gui-description.MFTPInside"}, _mfInfoGUIButtonsSize, true)
	GAPI.addButton(GUITable, "LockMFButton", buttonsBar, lockMFSprite, lockMFSprite, {"gui-description.LockMF"}, _mfInfoGUIButtonsSize, true)
	GAPI.addButton(GUITable, "LockMFButton", buttonsBar, lockMFSprite, lockMFSprite, {"gui-description.LockMF"}, _mfInfoGUIButtonsSize, true)
	GAPI.addButton(GUITable, "EnergyDrainButton", buttonsBar, energyDrainSprite, energyDrainSprite, {"gui-description.mfEnergyDrainButton"}, _mfInfoGUIButtonsSize, true, showEnergyDrainButton)
	GAPI.addButton(GUITable, "FluidDrainButton", buttonsBar, fluidDrainSprite, fluidDrainSprite, {"gui-description.mfFluidDrainButton"}, _mfInfoGUIButtonsSize, true, showFluidDrainButton)
	GAPI.addButton(GUITable, "ItemDrainButton", buttonsBar, itemDrainSprite, itemDrainSprite, {"gui-description.mfItemDrainButton"}, _mfInfoGUIButtonsSize, true, showItemDrainButton)
	GAPI.addButton(GUITable, "QuatronDrainButton", buttonsBar, quatronDrainSprite, quatronDrainSprite, {"gui-description.mfQuatronDrainButton"}, _mfInfoGUIButtonsSize, true, showQuatronDrainButton)
end

-- Update Information --
function GUI.updateMFInfos(GUITable)

	-- Get Variables --
	local infosFrame = GUITable.vars.InfoFrame
	local MF = getCurrentMF(GUITable.MFPlayer)

	-- Clear the Frame --
	infosFrame.clear()

	-------------------------------------------------------- Get Mobile Factory Information Variables --------------------------------------------------------
	local mfPositionText = {"", {"gui-description.mfPosition"}, ": [color=yellow]", {"gui-description.Unknow"}, "[/color]"}
	local mfHealthValue = 0
	local mfHealthText = {"", {"gui-description.mfHealth"}, ": [color=yellow]", {"gui-description.Unknow"}, "[/color]"}
	local mfShielValue = 0
	local mfShieldText = {"", {"gui-description.mfShield"}, ": [color=yellow]", {"gui-description.Unknow"}, "[/color]"}
	local mfEnergyValue = 0
	local mfEnergyText = {"", {"gui-description.mfEnergyCharge"}, ": [color=yellow]", {"gui-description.Unknow"}, "[/color]"}
	local mfQuatronValue = 0
	local mfQuatronText = {"", {"gui-description.mQuatronCharge"}, ": [color=yellow]", {"gui-description.Unknow"}, "[/color]"}
	local mfJumpDriveValue = 0
	local mfJumpDriveText = {"", {"gui-description.mfJumpCharge"}, ": [color=yellow]", {"gui-description.Unknow"}, "[/color]"}

	if MF.ent ~= nil and MF.ent.valid == true then
		mfPositionText = {"", {"gui-description.mfPosition"}, ": [color=yellow](", math.floor(MF.ent.position.x), " ; ", math.floor(MF.ent.position.y), ")  ", MF.ent.surface.name, "[/color]"}
		mfHealthValue = MF.ent.health / MF.ent.prototype.max_health
		mfHealthText = {"", {"gui-description.mfHealth"}, ": [color=yellow]", math.floor(MF.ent.health), "/", MF.ent.prototype.max_health, "[/color]"}
		mfShielValue = 0
		mfShieldText = {"", {"gui-description.mfShield"}, ": [color=yellow]", 0, "[/color]"}
		if MF:maxShield() > 0 then
			mfShielValue = MF:shield() / MF:maxShield()
			mfShieldText = {"", {"gui-description.mfShield"}, ": [color=yellow]", math.floor(MF:shield()), "/", MF:maxShield(), "[/color]"}
		end
		mfEnergyValue = 1 - (math.floor(100 - MF.internalEnergyObj:energy() / MF.internalEnergyObj:maxEnergy() * 100)) / 100
		mfEnergyText = {"", {"gui-description.mfEnergyCharge"}, ": [color=yellow]", Util.toRNumber(MF.internalEnergyObj:energy()), "J/", Util.toRNumber(MF.internalEnergyObj:maxEnergy()), "J[/color]"}
		mfQuatronValue = 1 - (math.floor(100 - MF.internalQuatronObj.quatronCharge / MF.internalQuatronObj.quatronMax * 100)) / 100
		mfQuatronText = {"", {"gui-description.mQuatronCharge"}, ": [color=yellow]", Util.toRNumber(MF.internalQuatronObj.quatronCharge), "/", Util.toRNumber(MF.internalQuatronObj.quatronMax), " (", {"gui-description.mQuatronPurity"}, ": ",  string.format("%.3f", MF.internalQuatronObj.quatronLevel), ")[/color]"}
		mfJumpDriveValue = (math.floor(MF.jumpDriveObj.charge / MF.jumpDriveObj.maxCharge * 100)) / 100
		mfJumpDriveText = {"", {"gui-description.mfJumpCharge"}, ": [color=yellow]", MF.jumpDriveObj.charge, "/", MF.jumpDriveObj.maxCharge, " (", MF.jumpDriveObj.chargeRate, "/s)[/color]"}
	end

	-------------------------------------------------------- Update Mobile Factory Information --------------------------------------------------------
	-- Add Labels and Progress Bars --
	GAPI.addSubtitle(GUITable, "MFInfoFrame", infosFrame, "Mobile Factory")
	GAPI.addLabel(GUITable, "PositionLabel", infosFrame, mfPositionText, _mfOrange)
	GAPI.addLabel(GUITable, "HealLabel", infosFrame, mfHealthText, _mfOrange)
	GAPI.addProgressBar(GUITable, "HealBar", infosFrame, "", mfHealthText, false, _mfRed, mfHealthValue)
	GAPI.addLabel(GUITable, "ShieldLabel", infosFrame, mfShieldText, _mfOrange)
	GAPI.addProgressBar(GUITable, "ShieldBar", infosFrame, "", mfShieldText, false, _mfBlue, mfShielValue)
	GAPI.addLabel(GUITable, "EnergyLabel", infosFrame, mfEnergyText, _mfOrange)
	GAPI.addProgressBar(GUITable, "EnergyBar", infosFrame, "", mfEnergyText, false, _mfYellow, mfEnergyValue)
	GAPI.addLabel(GUITable, "QuatronLabel", infosFrame, mfQuatronText, _mfOrange)
	GAPI.addProgressBar(GUITable, "QuatronBar", infosFrame, "", mfQuatronText, false, _mfPurple, mfQuatronValue)
	GAPI.addLabel(GUITable, "JumpDriveLabel", infosFrame, mfJumpDriveText, _mfOrange)
	GAPI.addProgressBar(GUITable, "JumpDriveBar", infosFrame, "", mfJumpDriveText, false, _mfOrange, mfJumpDriveValue)

	-------------------------------------------------------- Update Lasers Information --------------------------------------------------------
	-- Create the Frame --
	GAPI.addSubtitle(GUITable, "lasersFrame", infosFrame, {"gui-description.Lasers"})

	-- Number of Lasers --
	if technologyUnlocked("EnergyDrain1", getForce(MF)) or technologyUnlocked("FluidDrain1", getForce(MF)) or technologyUnlocked("TechItemDrain", getForce(MF)) then
		GAPI.addLabel(GUITable, "LasersNumberLabel", infosFrame,{"", {"gui-description.LaserNumber"}, ": [color=yellow]", MF:getLaserNumber(), "[/color]"}, _mfOrange)
		GAPI.addLabel(GUITable, "LasersRadiusLabel", infosFrame, {"", {"gui-description.LaserRadius"}, ": [color=yellow]", MF:getLaserRadius(), " tiles[/color]"}, _mfOrange)
		GAPI.addLabel(GUITable, "LasersMultiplierLabel", infosFrame, {"", {"gui-description.LaserEfficiency"}, ": [color=yellow]", MF:getLaserPower(), "[/color]"}, _mfOrange)
	end

	-- Energy Lasers --
	if technologyUnlocked("EnergyDrain1", getForce(MF)) then
		GAPI.addLabel(GUITable, "EnergyLasersSpeed", infosFrame, {"", {"gui-description.EnergyLasersSpeed"}, ": [color=yellow]", Util.toRNumber(MF:getLaserEnergyDrain()), "W[/color]"}, _mfYellow)
	end

	-- Fluid Lasers --
	if technologyUnlocked("FluidDrain1", getForce(MF)) then
		GAPI.addLabel(GUITable, "FluidLasersSpeed", infosFrame, {"", {"gui-description.FluidLasersSpeed"}, ": [color=yellow]", Util.toRNumber(MF:getLaserFluidDrain()), "u/s[/color]"}, _mfPurple)
		GAPI.addLabel(GUITable, "FluidLasersConsumption", infosFrame, {"", {"gui-description.FluidLasersConsumption"}, ": [color=yellow]", Util.toRNumber(MF:getLaserFluidDrain()*_mfFluidConsomption), "W[/color]"},_mfPurple)
	end

	-- Logistic Lasers --
	if technologyUnlocked("TechItemDrain", getForce(MF)) then
		GAPI.addLabel(GUITable, "LogisticLasersSpeed", infosFrame, {"", {"gui-description.LogisticLasersSpeed"}, ": [color=yellow]", Util.toRNumber(MF:getLaserItemDrain()), "i/s[/color]"}, _mfGreen)
		GAPI.addLabel(GUITable, "LogisticLasersConsumption", infosFrame, {"", {"gui-description.LogisticLasersConsumption"}, ": [color=yellow]", Util.toRNumber(MF:getLaserItemDrain()*_mfBaseItemEnergyConsumption), "W[/color]"}, _mfGreen)
	end

	-------------------------------------------------------- Update Upgrades Information --------------------------------------------------------
	-- Create the Frame --
	GAPI.addSubtitle(GUITable, "upgradeFrame", infosFrame, {"gui-description.Upgrades"})

	-- Add Labels --
	GAPI.addLabel(GUITable, "PowerModuleUpgrade", infosFrame, {"", {"gui-description.PowerModuleUpgrade"}, ": [color=yellow]", MF.laserRadiusMultiplier, "[/color]"}, _mfOrange)
	GAPI.addLabel(GUITable, "EfficiencyModuleUpgrade", infosFrame, {"", {"gui-description.EfficiencyModuleUpgrade"}, ": [color=yellow]", MF.laserDrainMultiplier, "[/color]"}, _mfOrange)
	GAPI.addLabel(GUITable, "FocusModuleUpgrade", infosFrame, {"", {"gui-description.FocusModuleUpgrade"}, ": [color=yellow]", MF.laserNumberMultiplier, "[/color]"}, _mfOrange)

end

-- Update Deep Tank Frame --
function GUI.updateDeepTankFrame(GUITable)

	-- Stop if a Filter is on selection --
	if GUITable.vars.freezeTankGUI == true then return end

	-- Get the GUI, MF and Player--
	local MF = getCurrentMF(GUITable.MFPlayer)

	-- Get the Tank Scroll Pane --
	local tankScrollPane = GUITable.vars.DTScrollPane

	-- Clear the Deep Tanks List --
	tankScrollPane.clear()

	-- Create the Table --
	local tankTable = GAPI.addTable(GUITable, "", tankScrollPane, 1)

	-- Look for all Deep Tanks --
	for _, deepTank in pairs(MF.dataNetwork.DTKTable) do

		-- Check the Deep Tank --
		if deepTank.ent == nil or deepTank.ent.valid == false then goto continue end

		-- Create the Deep Tank Variables --
		local sprite = deepTank.filter or deepTank.inventoryFluid
		local fName = Util.getLocFluidName(deepTank.inventoryFluid) or Util.getLocFluidName(deepTank.filter) or {"", {"gui-description.DeepTank"}, " ", deepTank.ID}
		local fAmount = deepTank.inventoryCount or 0
		local tCapacity = _dtMaxFluid
		local color = _mfPurple

		-- Create the Frame --
		local frame = GAPI.addFrame(GUITable, "", tankTable, "horizontal")

		-- Create the Button --
		if deepTank.inventoryFluid ~= nil and game.fluid_prototypes[deepTank.inventoryFluid] ~= nil then
			color = game.fluid_prototypes[deepTank.inventoryFluid].base_color
		end
		local buttonText = {"", {"gui-description.FilterSelect"}, "\n", {"gui-description.Filter"}, ": [color=purple]", (Util.getLocFluidName(deepTank.filter) or {"gui-description.None"}), "[/color]" }
		local button = GAPI.addFilter(GUITable, "DTF" .. tostring(deepTank.ent.unit_number), frame, buttonText, true, "fluid", 50)
		button.elem_value = sprite

		-- Create the table Flow --
		local flow = GAPI.addTable(GUITable, "", frame, 1)

		-- Create the Labels --
		GAPI.addLabel(GUITable, "", flow, fName, nil, "", false, nil, _mfLabelType.yellowTitle)
		GAPI.addLabel(GUITable, "", flow, Util.toRNumber(fAmount) .. "/" .. Util.toRNumber(tCapacity), _mfYellow)

		-- Create the Progress Bar --
		local bar = GAPI.addProgressBar(GUITable, "", flow, "", "", false, color, fAmount/tCapacity)
		bar.style.horizontally_stretchable = true

		::continue::
	
	end
end

-- Update Deep Storage Frame --
function GUI.updateDeepStorageFrame(GUITable)

	-- Stop if a Filter is on selection --
	if GUITable.vars.freezeStorageGUI == true then return end

	-- Get the GUI, MF and Player--
	local MF = getCurrentMF(GUITable.MFPlayer)

	-- Get the Deep Storage Scroll Pane --
	local storageScrollPane = GUITable.vars.DSScrollPane

	-- Clear the Deep Storages list --
	storageScrollPane.clear()

	-- Create the Table --
	local storageTable = GAPI.addTable(GUITable, "", storageScrollPane, 1)

	-- Look for all Deep Storage --
	for _, deepStorage in pairs(MF.dataNetwork.DSRTable) do

		-- Check the Deep Storage --
		if deepStorage.ent == nil or deepStorage.ent.valid == false then return end

		-- Create the Storage Variables --
		local sprite = deepStorage.filter or deepStorage.inventoryItem
		local fName = Util.getLocItemName(deepStorage.inventoryItem) or Util.getLocItemName(deepStorage.filter) or {"", {"gui-description.DeepStorage"}, " ", deepStorage.ID}
		local fAmount = deepStorage.inventoryCount or 0

		-- Create the Frame --
		local frame = GAPI.addFrame(GUITable, "", storageTable, "horizontal")

		-- Create the Button --
		local buttonText = {"", {"gui-description.FilterSelect"}, "\n", {"gui-description.Filter"}, ": [color=green]", (Util.getLocFluidName(deepStorage.filter) or {"gui-description.None"}), "[/color]" }
		local button = GAPI.addFilter(GUITable, "DSRF" .. tostring(deepStorage.ent.unit_number), frame, buttonText, true, "item", 50)
		button.elem_value = sprite

		-- Create the table flow --
		local flow = GAPI.addTable(GUITable, "", frame, 1)

		-- Create the Label --
		GAPI.addLabel(GUITable, "", flow, fName, nil, "", false, nil, _mfLabelType.yellowTitle)
		GAPI.addLabel(GUITable, "", flow, fAmount, _mfYellow)
		-- label1.style.width = 70
		-- label1.style.height = 15
		-- label2.style.width = 70
		-- label2.style.height = 15

		::continue::

	end
end
	
-- Update the Inventory GUI Frame --
function GUI.updateInventoryFrame(GUITable)

	-- Get the MF --
	local MF = getCurrentMF(GUITable.MFPlayer)

	-- Get the Inventory Scroll Pane and Flow --
	local inventoryFlow = GUITable.vars.InventoryTable
	local inventoryScrollPane = GUITable.vars.InvScrollPane

	-- Clear the Inventory --
	inventoryFlow.clear()
	inventoryScrollPane.clear()

	-- Create the Dual Labels --
	GAPI.addDualLabel(GUITable, inventoryFlow, {"", {"gui-description.BelongsTo"}, ": "},  MF.player, _mfOrange, _mfYellow)
	GAPI.addDualLabel(GUITable, inventoryFlow, {"", {"gui-description.InventoryCapacity"}, ": "}, Util.toRNumber(MF.II.usedCapacity) .. "/" .. Util.toRNumber(MF.II.maxCapacity) .. "  (" .. MF.II.usedCapacity .. "/" .. MF.II.maxCapacity .. ")", _mfOrange, _mfYellow)

	-- Create the Table --
    local tableList = GAPI.addTable(GUITable, "", inventoryScrollPane, 5)

	-- Look for all Deep Tanks --
	for _, DT in pairs(MF.dataNetwork.DTKTable) do
		
		-- Check the Deep Tank --
		if DT.ent == nil or DT.ent.valid == false or DT.inventoryFluid == nil or DT.inventoryCount == nil or DT.inventoryCount == 0 then goto continue end

		-- Create the Button --
		local buttonText = {"", "[color=purple]", Util.getLocFluidName(DT.inventoryFluid), "[/color]\n[color=yellow]", Util.toRNumber(DT.inventoryCount), "[/color]"}
		local button = GAPI.addButton(GUITable, "", tableList, "fluid/" .. DT.inventoryFluid, "fluid/" .. DT.inventoryFluid, buttonText, 37, false, true, DT.inventoryCount)
		button.style = "MF_Fake_Button_Purple"
        button.style.padding = 0
        button.style.margin = 0

		::continue::

	end

	-- Look for all Deep Storages --
	for _, DSR in pairs(MF.dataNetwork.DSRTable) do
		-- Check the Deep Storage --
		if DSR.ent == nil or DSR.ent.valid == false or DSR.inventoryItem == nil or DSR.inventoryCount == nil or DSR.inventoryCount == 0 then goto continue end

		-- Create the Button --
		local buttonText = {"", "[color=green]", Util.getLocItemName(DSR.inventoryItem), "[/color]\n[color=yellow]", Util.toRNumber(DSR.inventoryCount), "[/color]"}
		local button = GAPI.addButton(GUITable, "", tableList, "item/" .. DSR.inventoryItem, "item/" .. DSR.inventoryItem, buttonText, 37, false, true, DSR.inventoryCount)
		button.style = "MF_Fake_Button_Green"
        button.style.padding = 0
        button.style.margin = 0

		::continue::
	end

	-- Look for all Data Network Inventory Items --
	for name, count in pairs(MF.II.inventory) do
		
		-- Check the Item --
		if count == nil or count == 0 then goto continue end

		-- Create the Button --
		local buttonText = {"", "[color=blue]", Util.getLocItemName(name), "[/color]\n[color=yellow]", Util.toRNumber(count), "[/color]"}
		local button = GAPI.addButton(GUITable, "", tableList, "item/" .. name, "item/" .. name, buttonText, 37, false, true, count)
		button.style = "MF_Fake_Button_Blue"
        button.style.padding = 0
		button.style.margin = 0
		
		::continue::

	end

end