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
	local GUITable = GAPI.createBaseWindows(_mfGUIName.MainGUI, "", MFPlayer, false, false, false, "vertical")
	GAPI.setLocation(GUITable.gui, pos[1], pos[2])
	GUITable.vars.visible = true
	visible = GUITable.vars.visible
	local gui = GUITable.gui
	GAPI.setSize(gui, 1, 1)
	GAPI.setMinSize(gui, 1, 1)
	gui.auto_center = false
	gui.style.padding = 0
	gui.style.margin = 0

	-- Create the Frames and Flows --
	local MainFrame = GAPI.addFlow(GUITable, "MainFrame", gui, "vertical", true)
	local TopBar = GAPI.addFlow(GUITable, "TopBar", MainFrame, "horizontal", true)
	local ButtonsFrame = GAPI.addFlow(GUITable, "ButtonsFrame", TopBar, "horizontal", true)
	GAPI.addTable(GUITable, "ButtonsTable" ,ButtonsFrame, GUITable.MFPlayer.varTable.mainGUIButtonsPerLine or 5, true)
	local InfoFrame = GAPI.addFrame(GUITable, "InfoFrame", MainFrame, "vertical", true)

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
	local buttonsSize = 14 + ( GUITable.MFPlayer.varTable.MainButtonsSize or 5)
	local dragArea = GAPI.addEmptyWidget(GUITable, "MainGUIDragArea", TopBar, gui, buttonsSize, buttonsSize)
	dragArea.style.left_margin = 0
	dragArea.style.right_margin = 0

	-- Make the GUI visible or not --
	InfoFrame.visible = visible

	-- Add the GUI to the Player Table --
	MFPlayer.GUI[_mfGUIName.MainGUI] = GUITable

	-- Update the GUI and return the Table --
	GUI.updateMFMainGUI(GUITable)
	return GUITable

end

-- Update the Main GUI --
function GUI.updateMFMainGUI(GUITable)

	-- Get MF, MFPlayer and Player --
	local MF = getCurrentMF(GUITable.MFPlayer)
	local MFPlayer = GUITable.MFPlayer
	local player = GUITable.MFPlayer.ent

	-------------------------------------------------------- Get Buttons Variables --------------------------------------------------------
	-- local syncAreaSprite = MF.syncAreaEnabled == true and "SyncAreaIcon" or "SyncAreaIconDisabled"
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
	local showDeployButton = technologyUnlocked("MFDeploy", getForce(MF)) and true or false
	local showCallMFButton = technologyUnlocked("JumpDrive", getForce(MF)) and true or false

	GUI.addButtonToMainGui(GUITable, {name="PortOutsideButton", sprite="PortIcon", hovSprite="PortIcon", tooltip={"gui-description.teleportOutsideButton"}, save=false})
	-- GUI.addButtonToMainGui(GUITable, {name="SyncAreaButton", sprite=syncAreaSprite, hovSprite=syncAreaSprite, tooltip={"gui-description.syncAreaButton"}, save=false})
	GUI.addButtonToMainGui(GUITable, {name="FindMFButton", sprite="MFIconExc", hovSprite="MFIconExc", tooltip={"gui-description.fixMFButton"}, save=false, visible=showFindMFButton})
	GUI.addButtonToMainGui(GUITable, {name="TPInsideButton", sprite=tpInsideSprite, hovSprite=tpInsideSprite, tooltip={"gui-description.MFTPInside"}, save=false})
	GUI.addButtonToMainGui(GUITable, {name="LockMFButton", sprite=lockMFSprite, hovSprite=lockMFSprite, tooltip={"gui-description.LockMF"}, save=false})
	GUI.addButtonToMainGui(GUITable, {name="EnergyDrainButton", sprite=energyDrainSprite, hovSprite=energyDrainSprite, tooltip={"gui-description.mfEnergyDrainButton"}, save=false, visible=showEnergyDrainButton})
	GUI.addButtonToMainGui(GUITable, {name="FluidDrainButton", sprite=fluidDrainSprite, hovSprite=fluidDrainSprite, tooltip={"gui-description.mfFluidDrainButton"}, save=false, visible=showFluidDrainButton})
	GUI.addButtonToMainGui(GUITable, {name="ItemDrainButton", sprite=itemDrainSprite, hovSprite=itemDrainSprite, tooltip={"gui-description.mfItemDrainButton"}, save=false, visible=showItemDrainButton})
	GUI.addButtonToMainGui(GUITable, {name="QuatronDrainButton", sprite=quatronDrainSprite, hovSprite=quatronDrainSprite, tooltip={"gui-description.mfQuatronDrainButton"}, save=false, visible=showQuatronDrainButton})
	GUI.addButtonToMainGui(GUITable, {name="MFDeployButton", sprite="MFDeploy", hovSprite="MFDeploy", tooltip={"gui-description.DeployButtonTT"}, save=false, visible=showDeployButton})
	GUI.addButtonToMainGui(GUITable, {name="JumpDriveButton", sprite="MFJDIcon", hovSprite="MFJDIcon", tooltip={"gui-description.jumpDriveButton"}, save=false, visible=showCallMFButton})

	-- Render All Buttons --
	GUI.renderMainGuiButtons(GUITable)

	-- Clear the Frame --
	GUITable.vars.InfoFrame.clear()

	-- Check if the GUI must be shown --
	if GUITable.MFPlayer.varTable.MainGUIOpen == false then
		GUITable.vars.InfoFrame.visible = false
		return
	else
		GUITable.vars.InfoFrame.visible = true
	end

	-------------------------------------------------------- Get Information Variables --------------------------------------------------------
	local mfPositionText = {"", {"gui-description.mfPosition"}, ": [color=yellow]", {"gui-description.Unknow"}, "[/color]"}
	local time = { "", {"gui-description.Time"}, " [color=yellow]", Util.getRealTime(player.surface.daytime), "[/color]"}
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
	local infoTable = GAPI.addTable(GUITable, "", GUITable.vars.InfoFrame, 1)
	if MFPlayer.varTable.MainGUIShowPositions ~= false then
		GAPI.addLabel(GUITable, "PositionLabel", infoTable, mfPositionText, _mfOrange, "Mobile Factory")
	end
	if MFPlayer.varTable.MainGUIShowTime == true then
		GAPI.addLabel(GUITable, "TimeLabel", infoTable, time, _mfOrange, "Mobile Factory")
	end
	if MFPlayer.varTable.MainGUIShowTemperature == true then
		GAPI.addLabel(GUITable, "TempLabel", infoTable, {"", {"gui-description.temp"}, " [color=yellow]", string.format("%.1f", temperature), " °C[/color]"}, _mfOrange, "Mobile Factory")
	end
	if MFPlayer.varTable.MainGUIShowHealthBar ~= false then
		GAPI.addProgressBar(GUITable, "HealBar", GUITable.vars.InfoFrame, "", mfHealthText, false, _mfRed, mfHealthValue)
	end
	if MFPlayer.varTable.MainGUIShowShieldBar ~= false then
		GAPI.addProgressBar(GUITable, "ShieldBar", GUITable.vars.InfoFrame, "", mfShieldText, false, _mfBlue, mfShielValue)
	end
	if MFPlayer.varTable.MainGUIShowEnergyBar ~= false then
		GAPI.addProgressBar(GUITable, "EnergyBar", GUITable.vars.InfoFrame, "", mfEnergyText, false, _mfYellow, mfEnergyValue)
	end
	if MFPlayer.varTable.MainGUIShowQuatronBar ~= false then
		GAPI.addProgressBar(GUITable, "QuatronBar", GUITable.vars.InfoFrame, "", mfQuatronText, false, _mfPurple, mfQuatronValue)
	end
	if MFPlayer.varTable.MainGUIShowJumpCharge ~= false then
		GAPI.addProgressBar(GUITable, "JumpDriveBar", GUITable.vars.InfoFrame, "", mfJumpDriveText, false, _mfOrange, mfJumpDriveValue)
	end

end

-- Add a Button to the Main GUI --
function GUI.addButtonToMainGui(GUITable, button)
	if GUITable.vars.buttonsTable == nil then GUITable.vars.buttonsTable = {} end
	GUITable.vars.buttonsTable[button.name] = button
end

-- Render all Buttons of the Main GUI --
function GUI.renderMainGuiButtons(GUITable)
	-- Get the Flow --
	local flow = GUITable.vars.ButtonsTable
	-- Clear the Flow --
	flow.clear()
	-- Get the Buttons Size --
	local buttonsSize = 14 + ( GUITable.MFPlayer.varTable.MainButtonsSize or 5)
	-- Itinerate the Buttons Table --
	for _, button in pairs(GUITable.vars.buttonsTable or {}) do
		if button.visible == false then goto continue end
		if GUITable.MFPlayer.varTable["Show" .. button.name] == false then goto continue end
		-- Add the Button --
		GAPI.addButton(GUITable, button.name, flow, button.sprite, button.hovSprite, button.tooltip, buttonsSize, button.save, true, nil, "frame_action_button")
		::continue::
	end
	-- Add the GUI Buttons --
	local arrowButtonSprite = "ArrowIconUp"
	local arrowButtonName = "MainGUIClose"
	if GUITable.MFPlayer.varTable.MainGUIOpen == false then
		arrowButtonSprite = "ArrowIconDown"
		arrowButtonName = "MainGUIOpen"
	end
	
	-- Create the Right Buttons table --
	local buttonTable = GAPI.addTable(GUITable, "RightButtonsTable", GUITable.vars.ButtonsFrame, 3)

	GAPI.addButton(GUITable, "MainGUIInfosButton", buttonTable, "MFIconI", "MFIconI", {"gui-description.MFInfosButton"}, buttonsSize, false, true, nil, "frame_action_button")
	GAPI.addButton(GUITable, "MainGUIOptionButton", buttonTable, "OptionIcon", "OptionIcon", {"gui-description.optionButton"}, buttonsSize, false, true, nil, "frame_action_button")
	GAPI.addButton(GUITable, arrowButtonName, buttonTable, arrowButtonSprite, arrowButtonSprite, {"gui-description.reduceButton"}, buttonsSize, false, true, nil, "frame_action_button")

end