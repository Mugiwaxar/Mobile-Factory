-- Create the Main GUI --
function GUI.createMFMainGUI(player)

	-- Get the MFPlayer --
	local MFPlayer = getMFPlayer(player.index)

	-- Check if the Player GUI Table exist --
	if MFPlayer.GUI == nil then MFPlayer.GUI = {} end

	-- Get the Old GUI Positions if it existed --
	local pos = {_mfMainGUIPosX, _mfMainGUIPosY}
	if MFPlayer.GUI[_mfGUIName.MainGUI] ~= nil and MFPlayer.GUI[_mfGUIName.MainGUI].gui ~= nil and MFPlayer.GUI[_mfGUIName.MainGUI].gui.valid == true and MFPlayer.GUI[_mfGUIName.MainGUI].gui.location ~= nil then
		pos = MFPlayer.GUI[_mfGUIName.MainGUI].gui.location
	end

	-- Remove the Old GUI if it exist --
	if MFPlayer.GUI[_mfGUIName.MainGUI] ~= nil and MFPlayer.GUI[_mfGUIName.MainGUI].gui ~= nil then
		if MFPlayer.GUI[_mfGUIName.MainGUI].gui.valid == true then
			MFPlayer.GUI[_mfGUIName.MainGUI].gui.destroy()
		end
		MFPlayer.GUI[_mfGUIName.MainGUI] = nil
	end

	-- Create the Main GUI --
	local table = GAPI.createBaseWindows(_mfGUIName.MainGUI, "", MFPlayer, false, false, false, "vertical")
	GAPI.setLocation(table.gui, pos[1], pos[2])
	table.vars.visible = true
	visible = table.vars.visible
	local gui = table.gui
	GAPI.setSize(gui, 1, 1)
	GAPI.setMinSize(gui, 1, 1)
	gui.auto_center = false
	gui.style.padding = 0
	gui.style.margin = 0

	-- Create the Frames and Flows --
	local MainFrame = GAPI.addFlow(table, "MainFrame", gui, "vertical", true)
	local TopBar = GAPI.addFlow(table, "TopBar", MainFrame, "horizontal", true)
	local ButtonsFrame = GAPI.addFlow(table, "ButtonsFrame", TopBar, "horizontal", true)
	GAPI.addTable(table, "ButtonsTable" ,ButtonsFrame, table.MFPlayer.varTable.mainGUIButtonsPerLine or 5, true)
	local InfoFrame = GAPI.addFrame(table, "InfoFrame", MainFrame, "vertical", true)

	MainFrame.style.horizontal_align  = "right"

	TopBar.style.right_margin = 3
	TopBar.style.left_margin = 5
	TopBar.style.top_margin = 2
	TopBar.style.bottom_margin = 0

	ButtonsFrame.style.horizontally_stretchable = true
	ButtonsFrame.style.horizontal_align  = "right"

	InfoFrame.style = "MFFrame1"
	InfoFrame.style.margin = 2
	InfoFrame.style.padding = 6
	InfoFrame.style.top_padding = 0
	InfoFrame.style.horizontally_stretchable = true

	-- Create the Drag Area --
	local buttonsSize = 14 + ( table.MFPlayer.varTable.MainButtonsSize or 5)
	local dragArea = GAPI.addEmptyWidget(table, "MainGUIDragArea", TopBar, gui, buttonsSize, buttonsSize)
	dragArea.style.left_margin = 0
	dragArea.style.right_margin = 0

	-- Make the GUI visible or not --
	InfoFrame.visible = visible

	-- Add the GUI to the Player Table --
	MFPlayer.GUI[_mfGUIName.MainGUI] = table

	-- Update the GUI and return the Table --
	GUI.updateMFMainGUI(table)
	return table

end

-- Update the Main GUI --
function GUI.updateMFMainGUI(table)

	-- Get MF, MFPlayer and Player --
	local MF = getCurrentMF(table.MFPlayer)
	local MFPlayer = table.MFPlayer
	local player = table.MFPlayer.ent

	-------------------------------------------------------- Get Buttons Variables --------------------------------------------------------
	local showCallMFButton = technologyUnlocked("JumpDrive", getForce(player.name))
	local syncAreaSprite = MF.syncAreaEnabled == true and "SyncAreaIcon" or "SyncAreaIconDisabled"
	local showFindMFButton = (MF.ent ~= nil and MF.ent.valid == false) and true or false
	local tpInsideSprite = MF.tpEnabled == true and "MFTPIcon" or "MFTPIconDisabled"
	local lockMFSprite = MF.locked == true and "LockMFCIcon" or "LockMFOIcon"
	local showEnergyDrainButton = technologyUnlocked("EnergyDrain1", getForce(player.name)) and true or false
	local energyDrainSprite = MF.energyLaserActivated == true and "EnergyDrainIcon" or "EnergyDrainIconDisabled"
	local showFluidDrainButton = technologyUnlocked("FluidDrain1", getForce(player.name)) and true or false
	local fluidDrainSprite = MF.fluidLaserActivated == true and "FluidDrainIcon" or "FluidDrainIconDisabled"
	local showItemDrainButton = technologyUnlocked("TechItemDrain", getForce(player.name)) and true or false
	local itemDrainSprite = MF.itemLaserActivated == true and "ItemDrainIcon" or "ItemDrainIconDisabled"
	local showQuatronDrainButton = technologyUnlocked("EnergyDrain1", getForce(player.name)) and technologyUnlocked("QuatronLogistic", getForce(player.name)) and true or false
	local quatronDrainSprite = MF.quatronLaserActivated == true and "QuatronIcon" or "QuatronIconDisabled"

	GUI.addButtonToMainGui(table, {name="PortOutsideButton", sprite="PortIcon", hovSprite="PortIcon", tooltip={"gui-description.teleportOutsideButton"}, save=false})
	GUI.addButtonToMainGui(table, {name="JumpDriveButton", sprite="MFJDIcon", hovSprite="MFJDIcon", tooltip={"gui-description.jumpDriveButton"}, save=false, visible=showCallMFButton})
	GUI.addButtonToMainGui(table, {name="SyncAreaButton", sprite=syncAreaSprite, hovSprite=syncAreaSprite, tooltip={"gui-description.syncAreaButton"}, save=false})
	GUI.addButtonToMainGui(table, {name="FindMFButton", sprite="MFIconExc", hovSprite="MFIconExc", tooltip={"gui-description.fixMFButton"}, save=false, visible=showFindMFButton})
	GUI.addButtonToMainGui(table, {name="TPInsideButton", sprite=tpInsideSprite, hovSprite=tpInsideSprite, tooltip={"gui-description.MFTPInside"}, save=false})
	GUI.addButtonToMainGui(table, {name="LockMFButton", sprite=lockMFSprite, hovSprite=lockMFSprite, tooltip={"gui-description.LockMF"}, save=false})
	GUI.addButtonToMainGui(table, {name="EnergyDrainButton", sprite=energyDrainSprite, hovSprite=energyDrainSprite, tooltip={"gui-description.mfEnergyDrainButton"}, save=false, visible=showEnergyDrainButton})
	GUI.addButtonToMainGui(table, {name="FluidDrainButton", sprite=fluidDrainSprite, hovSprite=fluidDrainSprite, tooltip={"gui-description.mfFluidDrainButton"}, save=false, visible=showFluidDrainButton})
	GUI.addButtonToMainGui(table, {name="ItemDrainButton", sprite=itemDrainSprite, hovSprite=itemDrainSprite, tooltip={"gui-description.mfItemDrainButton"}, save=false, visible=showItemDrainButton})
	GUI.addButtonToMainGui(table, {name="QuatronDrainButton", sprite=quatronDrainSprite, hovSprite=quatronDrainSprite, tooltip={"gui-description.mfQuatronDrainButton"}, save=false, visible=showQuatronDrainButton})

	-- Render All Buttons --
	GUI.renderMainGuiButtons(table)

	-- Clear the Frame --
	table.vars.InfoFrame.clear()

	-- Check if the GUI must be shown --
	if table.MFPlayer.varTable.MainGUIOpen == false then
		table.vars.InfoFrame.visible = false
		return
	else
		table.vars.InfoFrame.visible = true
	end

	-------------------------------------------------------- Get Information Variables --------------------------------------------------------
	local mfPositionText = {"", {"gui-description.mfPosition"}, ": [color=yellow]", {"gui-description.Unknow"}, "[/color]"}
	local time = Util.getRealTime(player.surface.daytime)
	local temperature = "Unknow"
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
		mfPositionText = {"", {"gui-description.mfPosition"}, ": [color=yellow](", math.floor(MF.ent.position.x), " ; ", math.floor(MF.ent.position.y), ")  ", MF.ent.surface.name, "[/color]"}
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

	-- Update Chunk Temperature --
	if MFPlayer.varTable.MainGUIShowTemperature == true and remote.interfaces["EryaCom"]["getChunkTemp"] ~= nil then
		temperature = remote.call("EryaCom", "getChunkTemp", player.surface.index, math.floor(player.position.x / 32), math.floor(player.position.y / 32))
	end

	-------------------------------------------------------- Update Information --------------------------------------------------------

	-- Show Values and Bars --
	if MFPlayer.varTable.MainGUIShowPositions ~= false then
		GAPI.addLabel(table, "PositionLabel", table.vars.InfoFrame, mfPositionText, _mfOrange, "Mobile Factory")
	end
	if MFPlayer.varTable.MainGUIShowTime == true then
		GAPI.addLabel(table, "TimeLabel", table.vars.InfoFrame, time, _mfGreen, "Mobile Factory")
	end
	if MFPlayer.varTable.MainGUIShowTemperature == true then
		GAPI.addLabel(table, "TempLabel", table.vars.InfoFrame, {"", {"gui-description.temp"}, " ", string.format("%.1f", temperature), " °C"}, _mfGreen, "Mobile Factory")
	end
	if MFPlayer.varTable.MainGUIShowHealthBar ~= false then
		GAPI.addProgressBar(table, "HealBar", table.vars.InfoFrame, "", mfHealthText, false, _mfRed, mfHealthValue)
	end
	if MFPlayer.varTable.MainGUIShowShieldBar ~= false then
		GAPI.addProgressBar(table, "ShieldBar", table.vars.InfoFrame, "", mfShieldText, false, _mfBlue, mfShielValue)
	end
	if MFPlayer.varTable.MainGUIShowEnergyBar ~= false then
		GAPI.addProgressBar(table, "EnergyBar", table.vars.InfoFrame, "", mfEnergyText, false, _mfYellow, mfEnergyValue)
	end
	if MFPlayer.varTable.MainGUIShowQuatronBar ~= false then
		GAPI.addProgressBar(table, "QuatronBar", table.vars.InfoFrame, "", mfQuatronText, false, _mfPurple, mfQuatronValue)
	end
	if MFPlayer.varTable.MainGUIShowJumpCharge ~= false then
		GAPI.addProgressBar(table, "JumpDriveBar", table.vars.InfoFrame, "", mfJumpDriveText, false, _mfOrange, mfJumpDriveValue)
	end

end

-- Add a Button to the Main GUI --
function GUI.addButtonToMainGui(table, button)
	if table.vars.buttonsTable == nil then table.vars.buttonsTable = {} end
	table.vars.buttonsTable[button.name] = button
end

-- Render all Buttons of the Main GUI --
function GUI.renderMainGuiButtons(table)
	-- Get the Flow --
	local flow = table.vars.ButtonsTable
	-- Clear the Flow --
	flow.clear()
	-- Get the Buttons Size --
	local buttonsSize = 14 + ( table.MFPlayer.varTable.MainButtonsSize or 5)
	-- Itinerate the Buttons Table --
	for _, button in pairs(table.vars.buttonsTable or {}) do
		if button.visible == false then goto continue end
		if table.MFPlayer.varTable["Show" .. button.name] == false then goto continue end
		-- Add the Button --
		GAPI.addButton(table, button.name, flow, button.sprite, button.hovSprite, button.tooltip, buttonsSize, button.save, true, nil, "frame_action_button")
		::continue::
	end
	-- Add the GUI Buttons --
	local arrowButtonSprite = "ArrowIconUp"
	local arrowButtonName = "MainGUIClose"
	if table.MFPlayer.varTable.MainGUIOpen == false then
		arrowButtonSprite = "ArrowIconDown"
		arrowButtonName = "MainGUIOpen"
	end
	
	-- Create the Right Buttons table --
	local buttonTable = GAPI.addTable(table, "RightButtonsTable", table.vars.ButtonsFrame, 3)

	GAPI.addButton(table, "MainGUIInfosButton", buttonTable, "MFIconI", "MFIconI", {"gui-description.MFInfosButton"}, buttonsSize, false, true, nil, "frame_action_button")
	GAPI.addButton(table, "MainGUIOptionButton", buttonTable, "OptionIcon", "OptionIcon", {"gui-description.optionButton"}, buttonsSize, false, true, nil, "frame_action_button")
	GAPI.addButton(table, arrowButtonName, buttonTable, arrowButtonSprite, arrowButtonSprite, {"gui-description.reduceButton"}, buttonsSize, false, true, nil, "frame_action_button")

end