-- Create the Info GUI --
function GUI.createInfoGui(player)

	-- Create the GUI --
	local GUIObj = GUI.createGUI("MFInfoGUI", getMFPlayer(player.name), "vertical", true, 0, 0)
	local infoGUI = GUIObj.gui

	-- Create the top Bar --
	local MFInfoGUITitleBar = GUI.createTopBar(GUIObj, 200)

	-- Add the Line --
	GUIObj:addLine("InfoGUITitleBarLine", MFInfoGUITitleBar, "horizontal")

	-- Create the Buttons Bar --
	local MFInfoGUIButtonBar = GUIObj:addFlow("MFInfoGUIButtonBar", MFInfoGUITitleBar, "horizontal", true)
	MFInfoGUIButtonBar.style.horizontal_align = "center"

	-- Create the Main Frame --
	local MFInfoGUIMainFrame = GUIObj:addFrame("MFInfoGUIMainFrame", infoGUI, "horizontal", true)

	-- Create the Information Frame --
	GUIObj:addFlow("InfosFlow", MFInfoGUIMainFrame, "vertical", true)

	-- Create the Tank Frame and Scroll Pane --
	local tankFrame = GUIObj:addTitledFrame("TanksFrame", GUIObj.MFInfoGUIMainFrame, "vertical", {"gui-description.mfTanksTitle"}, _mfOrange)
	local tankScrollPane = GUIObj:addScrollPane("TanksScrollPane", tankFrame, 500, true)
	tankScrollPane.style = "MF_DeepST_scroll_pan"
	tankScrollPane.style.minimal_width = 200
	tankScrollPane.style.vertically_stretchable = true

	-- Create the Tank Option Frame --
	local tankOptionFrame = GUIObj:addFrame("TanksOptionFrame", tankFrame, "vertical", true)
	tankOptionFrame.style.height = 150
	tankOptionFrame.visible = false

	-- Create the Deep Storage Frame and Scroll Pane --
	local storageFrame = GUIObj:addTitledFrame("StorageFrame", GUIObj.MFInfoGUIMainFrame, "vertical", {"gui-description.mfDeepStorageTitle"}, _mfOrange)
	local storageScrollPane = GUIObj:addScrollPane("StorageScrollPane", storageFrame, 500, true)
	storageScrollPane.style = "MF_DeepST_scroll_pan"
	storageScrollPane.style.minimal_width = 200
	storageScrollPane.style.vertically_stretchable = true

	-- Create the Storage Option Frame --
	local storageOptionFrame = GUIObj:addFrame("StorageOptionFrame", storageFrame, "vertical", true)
	storageOptionFrame.style.height = 150
	storageOptionFrame.visible = false 

	-- Create the Inventory Frame and Scroll Pane --
	local inventoryFrame = GUIObj:addTitledFrame("InventoryFrame", GUIObj.MFInfoGUIMainFrame, "vertical", {"gui-description.mfInventoryTitle"}, _mfOrange)
	local inventoryScrollPane = GUIObj:addScrollPane("InventoryScrollPane", inventoryFrame, 500, true)
	inventoryScrollPane.style = "MF_Inventory_scroll_pan"
	inventoryScrollPane.style.minimal_width = 200
	inventoryScrollPane.style.vertically_stretchable = true

	-- Create the Inventory Option Frame --
	local inventoryOptionFrame = GUIObj:addFrame("InventoryOptionFrame", inventoryFrame, "vertical")
	inventoryOptionFrame.style.maximal_height = 150

	-- Create the Inventory Info Flow --
	local inventoryInfoFlow = GUIObj:addFlow("InventoryInfoFlow", inventoryOptionFrame, "vertical", true)
	inventoryInfoFlow.style.height = 60

	-- Create the Inventory Item Flow --
	local inventoryItemFlow = GUIObj:addFlow("InventoryItemFlow", inventoryOptionFrame, "vertical", true)
	inventoryItemFlow.style.height = 90
	inventoryItemFlow.visible = false

	-- Center the GUI --
	infoGUI.force_auto_center()

	-- Update the GUI and return the GUI Object --
	GUI.updateMFInfoGUI(GUIObj)
	return GUIObj

end

-- Update the Mobile Factory Info GUI --
function GUI.updateMFInfoGUI(GUIObj)
	GUI.updateButtonsBar(GUIObj)
	GUI.updateMFInfos(GUIObj)
	GUI.updateTankFrame(GUIObj)
	GUI.updateDeepStorageFrame(GUIObj)
	GUI.updateInventoryFrame(GUIObj)
end

-- Update the Buttons Bar --
function GUI.updateButtonsBar(GUIObj)

	-- Get GUI, MF and player --
	local buttonsBar = GUIObj.MFInfoGUIButtonBar
	local MF = GUIObj.MF
	local player = GUIObj.MFPlayer.ent

	-- Clear the Bar --
	buttonsBar.clear()

	-------------------------------------------------------- Get Buttons Variables --------------------------------------------------------
	local showCallMFButton = Util.isOutside(player)
	local showPortOutsideButton = not Util.isOutside(player)
	local syncAreaSprite = MF.syncAreaEnabled == true and "SyncAreaIcon" or "SyncAreaIconDisabled"
	local syncAreaHovSprite = MF.syncAreaEnabled == true and "SyncAreaIconDisabled" or "SyncAreaIcon"
	local showFindMFButton = (MF.ent ~= nil and MF.ent.valid == false) and true or false
	local tpInsideSprite = MF.tpEnabled == true and "MFTPIcon" or "MFTPIconDisabled"
	local tpInsideHovSprite = MF.tpEnabled == true and "MFTPIconDisabled" or "MFTPIcon"
	local lockMFSprite = MF.locked == true and "LockMFCIcon" or "LockMFOIcon"
	local lockMFHovSprite = MF.locked == true and "LockMFOIcon" or "LockMFCIcon"
	local showEnergyDrainButton = technologyUnlocked("EnergyDrain1", getForce(player.name)) and true or false
	local energyDrainSprite = MF.energyLaserActivated == true and "EnergyDrainIcon" or "EnergyDrainIconDisabled"
	local energyDrainHovSprite = MF.energyLaserActivated == true and "EnergyDrainIconDisabled" or "EnergyDrainIcon"
	local showFluidDrainButton = technologyUnlocked("FluidDrain1", getForce(player.name)) and true or false
	local fluidDrainSprite = MF.fluidLaserActivated == true and "FluidDrainIcon" or "FluidDrainIconDisabled"
	local fluidDrainHovSprite = MF.fluidLaserActivated == true and "FluidDrainIconDisabled" or "FluidDrainIcon"
	local showItemDrainButton = technologyUnlocked("TechItemDrain", getForce(player.name)) and true or false
	local itemDrainSprite = MF.itemLaserActivated == true and "ItemDrainIcon" or "ItemDrainIconDisabled"
	local itemDrainHovSprite = MF.itemLaserActivated == true and "ItemDrainIconDisabled" or "ItemDrainIcon"
	local showEnergyDistributionButton = technologyUnlocked("EnergyDistribution1", getForce(player.name)) and true or false
	local energyDistributionSprite = MF.internalEnergyDistributionActivated == true and "EnergyDistributionIcon" or "EnergyDistributionIconDisabled"
	local energyDistributionHovSprite = MF.internalEnergyDistributionActivated == true and "EnergyDistributionIconDisabled" or "EnergyDistributionIcon"
	local showSendQuatronButton = (technologyUnlocked("OreCleaner", getForce(player.name)) or technologyUnlocked("FluidExtractor", getForce(player.name))) and true or false
	local sendQuatronSprite = MF.sendQuatronActivated == true and "QuatronIcon" or "QuatronIconDisabled"
	local sendQuatronHovSprite = MF.sendQuatronActivated == true and "QuatronIconDisabled" or "QuatronIcon"


	-------------------------------------------------------- Update all Buttons --------------------------------------------------------
	local buttonsSize = 20
	GUIObj:addButton("CallMFButton", buttonsBar, "MFIcon", "MFIcon", {"gui-description.callMFButton"}, buttonsSize, true, showCallMFButton)
	GUIObj:addButton("PortOutsideButton", buttonsBar, "PortIcon", "PortIcon", {"gui-description.teleportOutsideButton"}, buttonsSize, true, showPortOutsideButton)
	GUIObj:addButton("SyncAreaButton", buttonsBar, syncAreaSprite, syncAreaHovSprite, {"gui-description.syncAreaButton"}, buttonsSize, true)
	GUIObj:addButton("FindMFButton", buttonsBar, "MFIconExc", "MFIconExc", {"gui-description.fixMFButton"}, buttonsSize, true, showFindMFButton)
	GUIObj:addButton("TPInsideButton", buttonsBar, tpInsideSprite, tpInsideHovSprite, {"gui-description.MFTPInside"}, buttonsSize, true)
	GUIObj:addButton("LockMFButton", buttonsBar, lockMFSprite, lockMFHovSprite, {"gui-description.LockMF"}, buttonsSize, true)
	GUIObj:addButton("EnergyDrainButton", buttonsBar, energyDrainSprite, energyDrainHovSprite, {"gui-description.mfEnergyDrainButton"}, buttonsSize, true, showEnergyDrainButton)
	GUIObj:addButton("FluidDrainButton", buttonsBar, fluidDrainSprite, fluidDrainHovSprite, {"gui-description.mfFluidDrainButton"}, buttonsSize, true, showFluidDrainButton)
	GUIObj:addButton("ItemDrainButton", buttonsBar, itemDrainSprite, itemDrainHovSprite, {"gui-description.mfItemDrainButton"}, buttonsSize, true, showItemDrainButton)
	GUIObj:addButton("EnergyDistributionButton", buttonsBar, energyDistributionSprite, energyDistributionHovSprite, {"gui-description.mfDistribute"}, buttonsSize, true, showEnergyDistributionButton)
	GUIObj:addButton("SendQuatronButton", buttonsBar, sendQuatronSprite, sendQuatronHovSprite, {"gui-description.mfSendQuatron"}, buttonsSize, true, showSendQuatronButton)
end

-- Update Information --
function GUI.updateMFInfos(GUIObj)

	-- Get GUI, MF and player --
	local infosFlow = GUIObj.InfosFlow
	local MF = GUIObj.MF
	local player = GUIObj.MFPlayer.ent

	-------------------------------------------------------- Get Mobile Factory Information Variables --------------------------------------------------------
	local mfPositionText = {"", {"gui-description.mfPosition"}, ": ", {"gui-description.Unknow"}}
	local mfHealthValue = 0
	local mfHealthText = {"", {"gui-description.mfHealth"}, ": ", {"gui-description.Unknow"}}
	local mfShielValue = 0
	local mfShieldText = {"", {"gui-description.mfShield"}, ": ", {"gui-description.Unknow"}}
	local mfEnergyValue = 0
	local mfEnergyText = {"", {"gui-description.mfEnergyCharge"}, ": ", {"gui-description.Unknow"}}
	local mfQuatronValue = 0
	local mfQuatronText = {"", {"gui-description.mQuatronCharge"}, ": ", {"gui-description.Unknow"}, "\n", {"gui-description.mQuatronPurity"}, ": ", {"gui-description.Unknow"}}
	local mfJumpDriveValue = 0
	local mfJumpDriveText = {"", {"gui-description.mfJumpTimer"}, ": ", {"gui-description.Unknow"}}

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
		mfQuatronValue = 0
		mfQuatronText = {"", {"gui-description.mQuatronCharge"}, ": ", 0, "\n", {"gui-description.mQuatronPurity"}, ": ", 0}
		mfJumpDriveValue = (math.floor(100 - MF.jumpTimer / MF.baseJumpTimer * 100)) / 100
		mfJumpDriveText = {"", {"gui-description.mfJumpTimer"}, ": ", math.floor(100 - MF.jumpTimer / MF.baseJumpTimer * 100), "% (", MF.jumpTimer, "s)"}
	end

	-------------------------------------------------------- Update Mobile Factory Information --------------------------------------------------------
	-- Create the Frame --
	local MFInfoFrame = GUIObj:addTitledFrame("MFInfoFrame", infosFlow, "vertical", "Mobile Factory", _mfOrange)
	MFInfoFrame.style.minimal_height = 80
	local barSize = 150

	-- Add Labels and Progress Bars --
	GUIObj:addLabel("PositionLabel", MFInfoFrame, mfPositionText, _mfGreen)
	GUIObj:addLabel("HealLabel", MFInfoFrame, mfHealthText, _mfRed)
	GUIObj:addProgressBar("HealBar", MFInfoFrame, "", mfHealthText, false, _mfRed, mfHealthValue, barSize)
	GUIObj:addLabel("ShieldLabel", MFInfoFrame, mfShieldText, _mfBlue)
	GUIObj:addProgressBar("ShieldBar", MFInfoFrame, "", mfShieldText, false, _mfBlue, mfShielValue, barSize)
	GUIObj:addLabel("EnergyLabel", MFInfoFrame, mfEnergyText, _mfYellow)
	GUIObj:addProgressBar("EnergyBar", MFInfoFrame, "", mfEnergyText, false, _mfYellow, mfEnergyValue, barSize)
	GUIObj:addLabel("QuatronLabel", MFInfoFrame, mfQuatronText, _mfPurple)
	GUIObj:addProgressBar("QuatronBar", MFInfoFrame, "", mfQuatronText, false, _mfPurple, mfQuatronValue, barSize)
	GUIObj:addLabel("JumpDriveLabel", MFInfoFrame, mfJumpDriveText, _mfOrange)
	GUIObj:addProgressBar("JumpDriveBar", MFInfoFrame, "", mfJumpDriveText, false, _mfOrange, mfJumpDriveValue, barSize)

	-------------------------------------------------------- Update Lasers Information --------------------------------------------------------
	-- Create the Frame --
	local lasersFrame = GUIObj:addTitledFrame("lasersFrame", infosFlow, "vertical", {"gui-description.Lasers"}, _mfOrange)
	lasersFrame.style.minimal_height = 80

	-- Number of Lasers --
	if technologyUnlocked("EnergyDrain1", getForce(player.name)) or technologyUnlocked("FluidDrain1", getForce(player.name)) or technologyUnlocked("TechItemDrain", getForce(player.name)) then
		GUIObj:addLabel("LasersNumberLabel", lasersFrame,{"", {"gui-description.LaserNumber"}, ": ", MF:getLaserNumber()})
		GUIObj:addLabel("LasersRadiusLabel", lasersFrame, {"", {"gui-description.LaserRadius"}, ": ", MF:getLaserRadius(), " tiles"})
		GUIObj:addLabel("LasersMultiplierLabel", lasersFrame, {"", {"gui-description.LaserEfficiency"}, ": ", MF:getLaserPower()})
	end

	-- Energy Lasers --
	if technologyUnlocked("EnergyDrain1", getForce(player.name)) then
		GUIObj:addLabel("EnergyLasersSpeed", lasersFrame, {"", {"gui-description.EnergyLasersSpeed"}, ": ", Util.toRNumber(MF:getLaserEnergyDrain()), "W"}, _mfYellow)
	end

	-- Fluid Lasers --
	if technologyUnlocked("FluidDrain1", getForce(player.name)) then
		GUIObj:addLabel("FluidLasersSpeed", lasersFrame, {"", {"gui-description.FluidLasersSpeed"}, ": ", Util.toRNumber(MF:getLaserFluidDrain()), "u/s"}, _mfPurple)
		GUIObj:addLabel("FluidLasersConsumption", lasersFrame, {"", {"gui-description.FluidLasersConsumption"}, ": ", Util.toRNumber(MF:getLaserFluidDrain()*_mfFluidConsomption), "W"},_mfPurple)
	end

	-- Logistic Lasers --
	if technologyUnlocked("TechItemDrain", getForce(player.name)) then
		GUIObj:addLabel("LogisticLasersSpeed", lasersFrame, {"", {"gui-description.LogisticLasersSpeed"}, ": ", Util.toRNumber(MF:getLaserItemDrain()), "i/s"}, _mfGreen)
		GUIObj:addLabel("LogisticLasersConsumption", lasersFrame, {"", {"gui-description.LogisticLasersConsumption"}, ": ", Util.toRNumber(MF:getLaserItemDrain()*_mfBaseItemEnergyConsumption), "W"}, _mfGreen)
	end

	-------------------------------------------------------- Update Upgrades Information --------------------------------------------------------
	-- Create the Frame --
	local upgradeFrame = GUIObj:addTitledFrame("upgradeFrame", infosFlow, "vertical", {"gui-description.Upgrades"}, _mfOrange)
	upgradeFrame.style.minimal_height = 80

	-- Add Labels --
	GUIObj:addLabel("PowerModuleUpgrade", upgradeFrame, {"", {"gui-description.PowerModuleUpgrade"}, ": ", MF.laserRadiusMultiplier})
	GUIObj:addLabel("EfficiencyModuleUpgrade", upgradeFrame, {"", {"gui-description.EfficiencyModuleUpgrade"}, ": ", MF.laserDrainMultiplier})
	GUIObj:addLabel("FocusModuleUpgrade", upgradeFrame, {"", {"gui-description.FocusModuleUpgrade"}, ": ", MF.laserNumberMultiplier})

end

-- Update Tank Frame --
function GUI.updateTankFrame(GUIObj)

	-- Get the GUI, MF and Player--
	local player = GUIObj.MFPlayer.ent

	-- Get the Tank Scroll Pane --
	local tankScrollPane = GUIObj.TanksScrollPane

	-- Clear the Tanks List --
	tankScrollPane.clear()

	-- Look for all Tanks --
	for k, deepTank in pairs(global.deepTankTable) do

		-- Ckeck if the Deep Tank belongs to this Player --
		if deepTank.player ~= player.name then goto continue end

		-- -- Create the Tank Variables --
		local sprite = nil
		local fName = Util.getLocFluidName(deepTank.inventoryFluid) or Util.getLocFluidName(deepTank.filter) or nil
		local fAmount = deepTank.inventoryCount or 0
		local tCapacity = _dtMaxFluid
		local tankText = fName == nil and {"", {"gui-description.DeepTank"}, " ", deepTank.ID} or {"", {"gui-description.DeepTank"}, " ", deepTank.ID, ": ", fName, " ", Util.toRNumber(fAmount), "/", Util.toRNumber(tCapacity)}
		local color = _mfPurple
		if game.fluid_prototypes[deepTank.inventoryFluid] ~= nil then
			color = game.fluid_prototypes[deepTank.inventoryFluid].base_color
		end

		-- Create the Frame --
		local frame = GUIObj:addFrame("", tankScrollPane, "horizontal")

		-- Create the Button --
		if deepTank.inventoryFluid ~= nil then
			sprite = "fluid/" .. deepTank.inventoryFluid
		elseif deepTank.filter ~= nil then
			sprite = "fluid/" .. deepTank.filter
		else
			sprite = "item/DeepTank"
			fAmount = nil
		end
		local button = GUIObj:addButton("DTB" .. tostring(k), frame, sprite, sprite, tankText, 35, false, true, fAmount)
		button.style = "MF_Purple_Button_Purple"

		-- Create the flow --
		local flow = GUIObj:addFlow("", frame, "vertical")

		-- Create the Label --
		local label = GUIObj:addDualLabel(flow, fName or tankText, Util.toRNumber(fAmount) .. "/" .. Util.toRNumber(tCapacity), _mfOrange, _mfGreen)
		label.Label1.style.width = 70
		label.Label2.style.width = 70

		-- Create the Progress Bar --
		local bar = GUIObj:addProgressBar("", flow, "", "", false, color, (fAmount or 0)/tCapacity, 140)
		bar.style.horizontally_stretchable = true
		bar.style.top_padding = 7

	::continue::
	
	end
end

-- Update Deep Tank Info Frame --
function GUI.updateDeepTankInfo(GUIObj, id)
	
	-- Get GUI and Deep Tank --
	local gui = GUIObj.TanksOptionFrame
	local deepTank = global.deepTankTable[id]
	gui.visible = true

	-- Clear the Frame --
	gui.clear()

	-- Create all Labels --
	GUIObj:addDualLabel(gui, {"", {"gui-description.DeepTankID"}, ":"}, deepTank.ID, _mfOrange, _mfGreen)
	GUIObj:addDualLabel(gui, {"", {"gui-description.BelongsTo"}, ":"}, deepTank.player, _mfOrange, _mfGreen)
	GUIObj:addDualLabel(gui, {"", {"gui-description.DeepTankFluid"}, ":"}, Util.getLocFluidName(deepTank.inventoryFluid) or {"gui-description.None"}, _mfOrange, _mfGreen)
	GUIObj:addDualLabel(gui, {"", {"gui-description.Count"}, ":"}, (deepTank.inventoryCount or "0") .. "/" .. _dtMaxFluid, _mfOrange, _mfGreen)
	GUIObj:addDualLabel(gui, {"", {"gui-description.Filter"}, ":"}, Util.getLocFluidName(deepTank.filter) or {"gui-description.None"}, _mfOrange, _mfGreen)

	-- Create the Filter --
	local TankFilter = GUIObj:addFilter("TF" .. tostring(id), gui, {"gui-description.FilterSelect"}, true, "fluid", 25)

	-- Set the Filter --
	if game.fluid_prototypes[deepTank.filter] ~= nil  then
		TankFilter.elem_value = deepTank.filter
	end

end

-- Update Deep Storage Frame --
function GUI.updateDeepStorageFrame(GUIObj)

	-- Get the GUI, MF and Player--
	local player = GUIObj.MFPlayer.ent

	-- Get the Deep Storage Scroll Pane --
	local storageScrollPane = GUIObj.StorageScrollPane

	-- Clear the Deep Storages list --
	storageScrollPane.clear()

	-- Look for all Deep Storage --
	for k, deepStorage in pairs(global.deepStorageTable) do

		-- Ckeck if the Deep Storage belongs to this Player --
		if deepStorage.player ~= player.name then goto continue end

		-- Create the Storage Variables --
		local sprite = nil
		local fName = Util.getLocItemName(deepStorage.inventoryItem) or Util.getLocItemName(deepStorage.filter) or nil
		local fAmount = deepStorage.inventoryCount or 0
		local storageText = fName == nil and {"", {"gui-description.DeepStorage"}, " ", deepStorage.ID} or {"", {"gui-description.DeepStorage"}, " ", deepStorage.ID, ": ", fName, " ", Util.toRNumber(fAmount)}
				
		-- Create the Frame --
		local frame = GUIObj:addFrame("", storageScrollPane, "horizontal")

		-- Create the Button --
		if deepStorage.inventoryItem ~= nil then
			sprite = "item/" .. deepStorage.inventoryItem
		elseif deepStorage.filter ~= nil then
			sprite = "item/" .. deepStorage.filter
		else
			sprite = "item/DeepStorage"
			fAmount = nil
		end
		local button = GUIObj:addButton("DSRB" .. tostring(k), frame, sprite, sprite, storageText, 35, false, true, fAmount)
		button.style = "shortcut_bar_button_green"

		-- Create the flow --
		local flow = GUIObj:addFlow("", frame, "vertical")

		-- Create the Label --
		local label1 = GUIObj:addLabel("", flow, fName or storageText, _mfOrange)
		local label2 = GUIObj:addLabel("", flow, fAmount == nil and "" or fAmount, _mfGreen)
		label1.style.width = 70
		label1.style.height = 15
		label2.style.width = 70
		label2.style.height = 15

		::continue::

	end
end

-- Update Deep Storage Info Frame --
function GUI.updateDeepStorageInfo(GUIObj, id)

	-- Get GUI and Deep Storage --
	local gui = GUIObj.StorageOptionFrame
	local deepStorage = global.deepStorageTable[id]
	gui.visible = true

	-- Clear the Frame --
	gui.clear()

	-- Create all Labels --
	GUIObj:addDualLabel(gui, {"", {"gui-description.DeepStorageID"}, ":"}, deepStorage.ID, _mfOrange, _mfGreen)
	GUIObj:addDualLabel(gui, {"", {"gui-description.BelongsTo"}, ":"}, deepStorage.player, _mfOrange, _mfGreen)
	GUIObj:addDualLabel(gui, {"", {"gui-description.DeepTankFluid"}, ":"}, Util.getLocFluidName(deepStorage.inventoryItem) or {"gui-description.None"}, _mfOrange, _mfGreen)
	GUIObj:addDualLabel(gui, {"", {"gui-description.Count"}, ":"}, (deepStorage.inventoryCount or "0"), _mfOrange, _mfGreen)
	GUIObj:addDualLabel(gui, {"", {"gui-description.Filter"}, ":"}, Util.getLocItemName(deepStorage.filter) or {"gui-description.None"}, _mfOrange, _mfGreen)

	-- Create the Filter --
	local StorageFilter = GUIObj:addFilter("DSRF" .. tostring(id), gui, {"gui-description.FilterSelect"}, true, "item", 25)

	-- Save the Filter --
	if game.item_prototypes[deepStorage.filter] ~= nil  then
		StorageFilter.elem_value = deepStorage.filter
	end

end

	
-- Update the Inventory GUI Frame --
function GUI.updateInventoryFrame(GUIObj)

	-- Get the MF --
	local MF = GUIObj.MF

	-- Get the Inventory Scroll Pane --
	local InventoryScrollPanel = GUIObj.InventoryScrollPane

	-- Clear the Inventory List --
	InventoryScrollPanel.clear()

	-- Create the Inventory List --
	createDNInventoryFrame(GUIObj, InventoryScrollPanel, GUIObj.MFPlayer, "INV", MF.II, 5, true, true, true)

	-- Clean the Inventory Information Flow --
	GUIObj.InventoryInfoFlow.clear()

	-- Create the Dual Labels --
	GUIObj:addDualLabel(GUIObj.InventoryInfoFlow, {"", {"gui-description.InventoryName"}, ": "},  MF.II.name, _mfOrange, _mfGreen)
	GUIObj:addDualLabel(GUIObj.InventoryInfoFlow, {"", {"gui-description.BelongsTo"}, ": "},  MF.player, _mfOrange, _mfGreen)
	GUIObj:addDualLabel(GUIObj.InventoryInfoFlow, {"", {"gui-description.InventoryCapacity"}, ": "}, Util.toRNumber(MF.II.usedCapacity) .. "/" .. Util.toRNumber(MF.II.maxCapacity) .. "  (" .. MF.II.usedCapacity .. "/" .. MF.II.maxCapacity .. ")", _mfOrange, _mfGreen)

end

-- Update the Inventory Info for an Item --
function GUI.updateInventoryInfo(GUIObj, id, type, name, amount)

	-- Get the GUI, MF and Player--
	local MF = GUIObj.MF

	-- Get the Inventory Item Flow --
	local inventoryItemFlow = GUIObj.InventoryItemFlow
	inventoryItemFlow.visible = true

	-- Clear the Flow --
	inventoryItemFlow.clear()

	-- Get the Variables --
	local text = nil
	local text2 = nil
	local count = nil
	local location = nil

	if type == "DT" then
		local deepTank = global.deepTankTable[id]
		if game.fluid_prototypes[deepTank.inventoryFluid] == nil then return end
		text = {"", {"gui-description.Fluid"}, ": "}
		text2 = Util.getLocFluidName(deepTank.inventoryFluid)
		count = deepTank.inventoryCount
		location = {"", {"gui-description.DeepTank"}, " ", deepTank.ID}
	elseif type == "DSR" then
		local deepStorage = global.deepStorageTable[id]
		if game.item_prototypes[deepStorage.inventoryItem] == nil then return end
		text = {"", {"gui-description.Item"}, ": "}
		text2 = Util.getLocItemName(deepStorage.inventoryItem)
		count = deepStorage.inventoryCount
		location = {"", {"gui-description.DeepStorage"}, " ", deepStorage.ID}
	elseif type == "INV" then
		if game.item_prototypes[name] == nil then return end
		text = {"", {"gui-description.Item"}, ": "}
		text2 = Util.getLocItemName(name)
		count = amount
		location = "Internal Inventory"
	else
		return
	end

	-- Create the Dual Labels --
	GUIObj:addDualLabel(inventoryItemFlow, text, text2, _mfOrange, _mfGreen)
	GUIObj:addDualLabel(inventoryItemFlow, {"", {"gui-description.Count"}, ": "}, count, _mfOrange, _mfGreen)
	GUIObj:addDualLabel(inventoryItemFlow, {"", {"gui-description.InventoryLocation"}, ": "}, location, _mfOrange, _mfGreen)

end