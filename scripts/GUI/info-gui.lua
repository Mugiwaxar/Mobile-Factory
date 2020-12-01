-- Create the Info GUI --
function GUI.createInfoGui(player)

	-- Get the MFPlayer --
	local MFPlayer = getMFPlayer(player.name)

	-- Create the GUI --
	local table = GAPI.createBaseWindows(_mfGUIName.InfoGUI, getCurrentMF(MFPlayer).name, MFPlayer, true, false, false, "vertical", "horizontal")
	table.gui.style.maximal_height = 800
	table.gui.style.maximal_width = 1500

	-- Add the Switch Button --
	GAPI.addButton(table, "SwitchMFButton", table.vars.topBarFlow, "SwitchIcon", "SwitchIcon", {"gui-description.SwitchMFButton"}, 20, false, true, nil, "frame_action_button")

	-- Add the Close Button --
	GAPI.addCloseButton(table)
	
	-- Add the Buttons Bar --
	GAPI.addLine(table, "", table.gui, "horizontal")
	local buttonBar = GAPI.addFlow(table, "ButtonBar", table.gui, "horizontal", true)
	buttonBar.style.horizontal_align = "center"

	-- Add the Main Frame --
	local mainFrame = GAPI.addFrame(table, "MainFrame", table.gui, "horizontal", true)
	mainFrame.style = "MFFrame1"

	-- Create the Frames --
	local infoFrame = GAPI.addFrame(table, "InfoFrame", mainFrame, "vertical", true)
	local tankFrame = GAPI.addFrame(table, "TankFrame", mainFrame, "vertical", true)
	local storageFrame = GAPI.addFrame(table, "StorageFrame", mainFrame, "vertical", true)
	local inventoryFrame = GAPI.addFrame(table, "InventoryFrame", mainFrame, "vertical", true)

	infoFrame.style = "MFFrame1"
	tankFrame.style = "MFFrame1"
	storageFrame.style = "MFFrame1"
	inventoryFrame.style = "MFFrame1"

	infoFrame.style.left_padding = 7
	infoFrame.style.right_padding = 7
	tankFrame.style.left_padding = 7
	tankFrame.style.right_padding = 7
	storageFrame.style.left_padding = 7
	storageFrame.style.right_padding = 7
	inventoryFrame.style.left_padding = 7
	inventoryFrame.style.right_padding = 7

	infoFrame.style.vertically_stretchable = true
	tankFrame.style.vertically_stretchable = true
	storageFrame.style.vertically_stretchable = true
	inventoryFrame.style.vertically_stretchable = true

	-- Create Frames Titles --
	GAPI.addSubtitle(table, "", tankFrame, {"gui-description.mfTanksTitle"})
	GAPI.addSubtitle(table, "", storageFrame, {"gui-description.mfDeepStorageTitle"})
	GAPI.addSubtitle(table, "", inventoryFrame, {"gui-description.mfInventoryTitle"})

	-- Create Scroll Panes --
	local DTScrollPane = GAPI.addScrollPane(table, "DTScrollPane", tankFrame, nil, true, "MF_DeepTank_scroll_pan")
	local DSScrollPane = GAPI.addScrollPane(table, "DSScrollPane", storageFrame, nil, true, "MF_DeepStorage_scroll_pan")
	local InvScrollPane = GAPI.addScrollPane(table, "InvScrollPane", inventoryFrame, nil, true, "MF_Inventory_scroll_pan")
	GAPI.addTable(table, "InventoryTable", inventoryFrame, 1, true)
	
	DTScrollPane.style.vertically_stretchable = true
	DSScrollPane.style.vertically_stretchable = true
	InvScrollPane.style.vertically_stretchable = true
	InvScrollPane.style.minimal_width = 198

	-- Update the GUI --
	GUI.updateMFInfoGUI(table)

	-- Return the Table --
	return table

end

-- Update the Mobile Factory Info GUI --
function GUI.updateMFInfoGUI(table)
	GUI.updateButtonsBar(table)
	GUI.updateMFInfos(table)
	GUI.updateDeepTankFrame(table)
	GUI.updateDeepStorageFrame(table)
	GUI.updateInventoryFrame(table)
end

-- Update the Buttons Bar --
function GUI.updateButtonsBar(table)

	-- Get GUI, MF and player --
	local buttonsBar = table.vars.ButtonBar
	local MF = getCurrentMF(table.MFPlayer)
	local player = table.MFPlayer.ent

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
	GAPI.addButton(table, "PortOutsideButton", buttonsBar, "PortIcon", "PortIcon", {"gui-description.teleportOutsideButton"}, _mfInfoGUIButtonsSize, true)
	GAPI.addButton(table, "JumpDriveButton", buttonsBar, "MFJDIcon", "MFJDIcon", {"gui-description.jumpDriveButton"}, _mfInfoGUIButtonsSize, true, showCallMFButton)
	GAPI.addButton(table, "SyncAreaButton", buttonsBar, syncAreaSprite, syncAreaSprite, {"gui-description.syncAreaButton"}, _mfInfoGUIButtonsSize, true)
	GAPI.addButton(table, "FindMFButton", buttonsBar, "MFIconExc", "MFIconExc", {"gui-description.fixMFButton"}, _mfInfoGUIButtonsSize, true, showFindMFButton)
	GAPI.addButton(table, "TPInsideButton", buttonsBar, tpInsideSprite, tpInsideSprite, {"gui-description.MFTPInside"}, _mfInfoGUIButtonsSize, true)
	GAPI.addButton(table, "LockMFButton", buttonsBar, lockMFSprite, lockMFSprite, {"gui-description.LockMF"}, _mfInfoGUIButtonsSize, true)
	GAPI.addButton(table, "LockMFButton", buttonsBar, lockMFSprite, lockMFSprite, {"gui-description.LockMF"}, _mfInfoGUIButtonsSize, true)
	GAPI.addButton(table, "EnergyDrainButton", buttonsBar, energyDrainSprite, energyDrainSprite, {"gui-description.mfEnergyDrainButton"}, _mfInfoGUIButtonsSize, true, showEnergyDrainButton)
	GAPI.addButton(table, "FluidDrainButton", buttonsBar, fluidDrainSprite, fluidDrainSprite, {"gui-description.mfFluidDrainButton"}, _mfInfoGUIButtonsSize, true, showFluidDrainButton)
	GAPI.addButton(table, "ItemDrainButton", buttonsBar, itemDrainSprite, itemDrainSprite, {"gui-description.mfItemDrainButton"}, _mfInfoGUIButtonsSize, true, showItemDrainButton)
	GAPI.addButton(table, "QuatronDrainButton", buttonsBar, quatronDrainSprite, quatronDrainSprite, {"gui-description.mfQuatronDrainButton"}, _mfInfoGUIButtonsSize, true, showQuatronDrainButton)
end

-- Update Information --
function GUI.updateMFInfos(table)

	-- Get Variables --
	local infosFrame = table.vars.InfoFrame
	local MF = getCurrentMF(table.MFPlayer)

	-- Clear the Frame --
	infosFrame.clear()

	-------------------------------------------------------- Get Mobile Factory Information Variables --------------------------------------------------------
	local mfPositionText = {"", {"gui-description.mfPosition"}, ": ", {"gui-description.Unknow"}}
	local mfHealthValue = 0
	local mfHealthText = {"", {"gui-description.mfHealth"}, ": ", {"gui-description.Unknow"}}
	local mfShielValue = 0
	local mfShieldText = {"", {"gui-description.mfShield"}, ": ", {"gui-description.Unknow"}}
	local mfEnergyValue = 0
	local mfEnergyText = {"", {"gui-description.mfEnergyCharge"}, ": ", {"gui-description.Unknow"}}
	local mfQuatronValue = 0
	local mfQuatronText = {"", {"gui-description.mQuatronCharge"}, ": ", {"gui-description.Unknow"}}
	local mfJumpDriveValue = 0
	local mfJumpDriveText = {"", {"gui-description.mfJumpCharge"}, ": ", {"gui-description.Unknow"}}

	if MF.ent ~= nil and MF.ent.valid == true then
		mfPositionText = {"", {"gui-description.mfPosition"}, ": (", math.floor(MF.ent.position.x), " ; ", math.floor(MF.ent.position.y), ")  ", MF.ent.surface.name}
		mfHealthValue = MF.ent.health / MF.ent.prototype.max_health
		mfHealthText = {"", {"gui-description.mfHealth"}, ": ", math.floor(MF.ent.health), "/", MF.ent.prototype.max_health}
		mfShielValue = 0
		mfShieldText = {"", {"gui-description.mfShield"}, ": ", 0}
		if MF:maxShield() > 0 then
			mfShielValue = MF:shield() / MF:maxShield()
			mfShieldText = {"", {"gui-description.mfShield"}, ": ", math.floor(MF:shield()), "/", MF:maxShield()}
		end
		mfEnergyValue = 1 - (math.floor(100 - MF.internalEnergyObj:energy() / MF.internalEnergyObj:maxEnergy() * 100)) / 100
		mfEnergyText = {"", {"gui-description.mfEnergyCharge"}, ": ", Util.toRNumber(MF.internalEnergyObj:energy()), "J/", Util.toRNumber(MF.internalEnergyObj:maxEnergy()), "J"}
		mfQuatronValue = 1 - (math.floor(100 - MF.internalQuatronObj.quatronCharge / MF.internalQuatronObj.quatronMax * 100)) / 100
		mfQuatronText = {"", {"gui-description.mQuatronCharge"}, ": ", Util.toRNumber(MF.internalQuatronObj.quatronCharge), "/", Util.toRNumber(MF.internalQuatronObj.quatronMax), " (", {"gui-description.mQuatronPurity"}, ": ",  string.format("%.3f", MF.internalQuatronObj.quatronLevel), ")"}
		mfJumpDriveValue = (math.floor(MF.jumpDriveObj.charge / MF.jumpDriveObj.maxCharge * 100)) / 100
		mfJumpDriveText = {"", {"gui-description.mfJumpCharge"}, ": ", MF.jumpDriveObj.charge, "/", MF.jumpDriveObj.maxCharge, " (", MF.jumpDriveObj.chargeRate, "/s)"}
	end

	-------------------------------------------------------- Update Mobile Factory Information --------------------------------------------------------
	-- Add Labels and Progress Bars --
	GAPI.addSubtitle(table, "MFInfoFrame", infosFrame, "Mobile Factory")
	GAPI.addLabel(table, "PositionLabel", infosFrame, mfPositionText, _mfGreen)
	GAPI.addLabel(table, "HealLabel", infosFrame, mfHealthText, _mfRed)
	GAPI.addProgressBar(table, "HealBar", infosFrame, "", mfHealthText, false, _mfRed, mfHealthValue)
	GAPI.addLabel(table, "ShieldLabel", infosFrame, mfShieldText, _mfBlue)
	GAPI.addProgressBar(table, "ShieldBar", infosFrame, "", mfShieldText, false, _mfBlue, mfShielValue)
	GAPI.addLabel(table, "EnergyLabel", infosFrame, mfEnergyText, _mfYellow)
	GAPI.addProgressBar(table, "EnergyBar", infosFrame, "", mfEnergyText, false, _mfYellow, mfEnergyValue)
	GAPI.addLabel(table, "QuatronLabel", infosFrame, mfQuatronText, _mfPurple)
	GAPI.addProgressBar(table, "QuatronBar", infosFrame, "", mfQuatronText, false, _mfPurple, mfQuatronValue)
	GAPI.addLabel(table, "JumpDriveLabel", infosFrame, mfJumpDriveText, _mfOrange)
	GAPI.addProgressBar(table, "JumpDriveBar", infosFrame, "", mfJumpDriveText, false, _mfOrange, mfJumpDriveValue)

	-------------------------------------------------------- Update Lasers Information --------------------------------------------------------
	-- Create the Frame --
	GAPI.addSubtitle(table, "lasersFrame", infosFrame, {"gui-description.Lasers"})

	-- Number of Lasers --
	if technologyUnlocked("EnergyDrain1", getForce(MF)) or technologyUnlocked("FluidDrain1", getForce(MF)) or technologyUnlocked("TechItemDrain", getForce(MF)) then
		GAPI.addLabel(table, "LasersNumberLabel", infosFrame,{"", {"gui-description.LaserNumber"}, ": ", MF:getLaserNumber()})
		GAPI.addLabel(table, "LasersRadiusLabel", infosFrame, {"", {"gui-description.LaserRadius"}, ": ", MF:getLaserRadius(), " tiles"})
		GAPI.addLabel(table, "LasersMultiplierLabel", infosFrame, {"", {"gui-description.LaserEfficiency"}, ": ", MF:getLaserPower()})
	end

	-- Energy Lasers --
	if technologyUnlocked("EnergyDrain1", getForce(MF)) then
		GAPI.addLabel(table, "EnergyLasersSpeed", infosFrame, {"", {"gui-description.EnergyLasersSpeed"}, ": ", Util.toRNumber(MF:getLaserEnergyDrain()), "W"}, _mfYellow)
	end

	-- Fluid Lasers --
	if technologyUnlocked("FluidDrain1", getForce(MF)) then
		GAPI.addLabel(table, "FluidLasersSpeed", infosFrame, {"", {"gui-description.FluidLasersSpeed"}, ": ", Util.toRNumber(MF:getLaserFluidDrain()), "u/s"}, _mfPurple)
		GAPI.addLabel(table, "FluidLasersConsumption", infosFrame, {"", {"gui-description.FluidLasersConsumption"}, ": ", Util.toRNumber(MF:getLaserFluidDrain()*_mfFluidConsomption), "W"},_mfPurple)
	end

	-- Logistic Lasers --
	if technologyUnlocked("TechItemDrain", getForce(MF)) then
		GAPI.addLabel(table, "LogisticLasersSpeed", infosFrame, {"", {"gui-description.LogisticLasersSpeed"}, ": ", Util.toRNumber(MF:getLaserItemDrain()), "i/s"}, _mfGreen)
		GAPI.addLabel(table, "LogisticLasersConsumption", infosFrame, {"", {"gui-description.LogisticLasersConsumption"}, ": ", Util.toRNumber(MF:getLaserItemDrain()*_mfBaseItemEnergyConsumption), "W"}, _mfGreen)
	end

	-------------------------------------------------------- Update Upgrades Information --------------------------------------------------------
	-- Create the Frame --
	GAPI.addSubtitle(table, "upgradeFrame", infosFrame, {"gui-description.Upgrades"})

	-- Add Labels --
	GAPI.addLabel(table, "PowerModuleUpgrade", infosFrame, {"", {"gui-description.PowerModuleUpgrade"}, ": ", MF.laserRadiusMultiplier})
	GAPI.addLabel(table, "EfficiencyModuleUpgrade", infosFrame, {"", {"gui-description.EfficiencyModuleUpgrade"}, ": ", MF.laserDrainMultiplier})
	GAPI.addLabel(table, "FocusModuleUpgrade", infosFrame, {"", {"gui-description.FocusModuleUpgrade"}, ": ", MF.laserNumberMultiplier})

end

-- Update Deep Tank Frame --
function GUI.updateDeepTankFrame(table)

	-- Stop if a Filter is on selection --
	if table.vars.freezeTankGUI == true then return end

	-- Get the GUI, MF and Player--
	local MF = getCurrentMF(table.MFPlayer)

	-- Get the Tank Scroll Pane --
	local tankScrollPane = table.vars.DTScrollPane

	-- Clear the Deep Tanks List --
	tankScrollPane.clear()

	-- Create the Table --
	local tankTable = GAPI.addTable(table, "", tankScrollPane, 1)

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
		local frame = GAPI.addFrame(table, "", tankTable, "horizontal")

		-- Create the Button --
		if deepTank.inventoryFluid ~= nil and game.fluid_prototypes[deepTank.inventoryFluid] ~= nil then
			color = game.fluid_prototypes[deepTank.inventoryFluid].base_color
		end
		local buttonText = {"", {"gui-description.FilterSelect"}, "\n", {"gui-description.Filter"}, ": [color=purple]", (Util.getLocFluidName(deepTank.filter) or {"gui-description.None"}), "[/color]" }
		local button = GAPI.addFilter(table, "DTF" .. tostring(deepTank.ent.unit_number), frame, buttonText, true, "fluid", 50)
		button.elem_value = sprite

		-- Create the table Flow --
		local flow = GAPI.addTable(table, "", frame, 1)

		-- Create the Labels --
		GAPI.addLabel(table, "", flow, fName, nil, "", false, nil, "yellow_label")
		GAPI.addLabel(table, "", flow, Util.toRNumber(fAmount) .. "/" .. Util.toRNumber(tCapacity), _mfYellow)

		-- Create the Progress Bar --
		local bar = GAPI.addProgressBar(table, "", flow, "", "", false, color, fAmount/tCapacity)
		bar.style.horizontally_stretchable = true

		::continue::
	
	end
end

-- Update Deep Storage Frame --
function GUI.updateDeepStorageFrame(table)

	-- Stop if a Filter is on selection --
	if table.vars.freezeStorageGUI == true then return end

	-- Get the GUI, MF and Player--
	local MF = getCurrentMF(table.MFPlayer)

	-- Get the Deep Storage Scroll Pane --
	local storageScrollPane = table.vars.DSScrollPane

	-- Clear the Deep Storages list --
	storageScrollPane.clear()

	-- Create the Table --
	local storageTable = GAPI.addTable(table, "", storageScrollPane, 1)

	-- Look for all Deep Storage --
	for _, deepStorage in pairs(MF.dataNetwork.DSRTable) do

		-- Check the Deep Storage --
		if deepStorage.ent == nil or deepStorage.ent.valid == false then return end

		-- Create the Storage Variables --
		local sprite = deepStorage.filter or deepStorage.inventoryItem
		local fName = Util.getLocItemName(deepStorage.inventoryItem) or Util.getLocItemName(deepStorage.filter) or {"", {"gui-description.DeepStorage"}, " ", deepStorage.ID}
		local fAmount = deepStorage.inventoryCount or 0

		-- Create the Frame --
		local frame = GAPI.addFrame(table, "", storageTable, "horizontal")

		-- Create the Button --
		local buttonText = {"", {"gui-description.FilterSelect"}, "\n", {"gui-description.Filter"}, ": [color=green]", (Util.getLocFluidName(deepStorage.filter) or {"gui-description.None"}), "[/color]" }
		local button = GAPI.addFilter(table, "DSRF" .. tostring(deepStorage.ent.unit_number), frame, buttonText, true, "item", 50)
		button.elem_value = sprite

		-- Create the table flow --
		local flow = GAPI.addTable(table, "", frame, 1)

		-- Create the Label --
		GAPI.addLabel(table, "", flow, fName, nil, "", false, nil, "yellow_label")
		GAPI.addLabel(table, "", flow, fAmount, _mfYellow)
		-- label1.style.width = 70
		-- label1.style.height = 15
		-- label2.style.width = 70
		-- label2.style.height = 15

		::continue::

	end
end
	
-- Update the Inventory GUI Frame --
function GUI.updateInventoryFrame(table)

	-- Get the MF --
	local MF = getCurrentMF(table.MFPlayer)

	-- Get the Inventory Scroll Pane and Flow --
	local inventoryFlow = table.vars.InventoryTable
	local inventoryScrollPane = table.vars.InvScrollPane

	-- Clear the Inventory --
	inventoryFlow.clear()
	inventoryScrollPane.clear()

	-- Create the Dual Labels --
	GAPI.addDualLabel(table, inventoryFlow, {"", {"gui-description.BelongsTo"}, ": "},  MF.player, _mfOrange, _mfGreen)
	GAPI.addDualLabel(table, inventoryFlow, {"", {"gui-description.InventoryCapacity"}, ": "}, Util.toRNumber(MF.II.usedCapacity) .. "/" .. Util.toRNumber(MF.II.maxCapacity) .. "  (" .. MF.II.usedCapacity .. "/" .. MF.II.maxCapacity .. ")", _mfOrange, _mfGreen)

	-- Create the Table --
    local tableList = GAPI.addTable(table, "", inventoryScrollPane, 5)

	-- Create the Inventory List --
	-- createDNInventoryFrame(GUIObj, inventoryScrollPane, getMFPlayer(MF.playerIndex), "INV", MF.II, 5, true, true, true)

	-- Look for all Deep Tanks --
	for _, DT in pairs(MF.dataNetwork.DTKTable) do
		
		-- Check the Deep Tank --
		if DT.ent == nil or DT.ent.valid == false or DT.inventoryFluid == nil or DT.inventoryCount == nil or DT.inventoryCount == 0 then goto continue end

		-- Create the Button --
		local buttonText = {"", "[color=purple]", Util.getLocFluidName(DT.inventoryFluid), "[/color]\n[color=yellow]", Util.toRNumber(DT.inventoryCount), "[/color]"}
		local button = GAPI.addButton(table, "", tableList, "fluid/" .. DT.inventoryFluid, "fluid/" .. DT.inventoryFluid, buttonText, 37, false, true, DT.inventoryCount)
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
		local button = GAPI.addButton(table, "", tableList, "item/" .. DSR.inventoryItem, "item/" .. DSR.inventoryItem, buttonText, 37, false, true, DSR.inventoryCount)
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
		local button = GAPI.addButton(table, "", tableList, "item/" .. name, "item/" .. name, buttonText, 37, false, true, count)
		button.style = "MF_Fake_Button_Blue"
        button.style.padding = 0
		button.style.margin = 0
		
		::continue::

	end

end