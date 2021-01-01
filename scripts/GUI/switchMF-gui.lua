-- Create the SwitchMF GUI --
function GUI.createSwitchMFGUI(player)
    
    -- Create the Main Window --
    local GUITable = GAPI.createBaseWindows(_mfGUIName.SwitchMF, {"gui-description.MFSwitchMFGUITitle"}, getMFPlayer(player.name), true, false)
    GAPI.setSize(GUITable.gui, 100, 100)

    -- Add the Close Button --
    GAPI.addCloseButton(GUITable)

    -- Create the List Information --
    local infoLabel = GAPI.addLabel(GUITable, "", GUITable.gui, {"gui-description.SwitchMFInfo"}, _mfWhite)
    infoLabel.style.single_line = false
    infoLabel.style.maximal_width = 270

    -- Create the Line --
    GAPI.addLine(GUITable, "", GUITable.gui, "horizontal")

    -- Create the Change Name Frame --
    local changeNameFlow = GAPI.addFlow(GUITable, "", GUITable.gui, "horizontal")
    changeNameFlow.style.horizontally_stretchable = true
    changeNameFlow.style.horizontal_align = "center"
    changeNameFlow.style.bottom_margin = 3

    -- Create the Change Name Textfield --
    local textField = GAPI.addTextField(GUITable, "SwitchMFChangeNameTextField", changeNameFlow, GUITable.MFPlayer.MF.name or "", {"gui-description.MFChangeNameTT"}, true)
    textField.style.horizontally_stretchable = true

    -- Create the Change Name Button --
    local button = GAPI.addSimpleButton(GUITable, "Swi.GUI.ChangeNameButton", changeNameFlow, {"gui-description.Change"})
    button.style.width = 78
    button.style.top_margin = 1

    -- Create the Main Frame --
    local mainFrame = GAPI.addFrame(GUITable, "MainFrame", GUITable.gui, "vertical", true)
    mainFrame.style = "MFFrame2"

    -- Create the Mobile Factory List Scroll Pane --
    local listScrollPane = GAPI.addScrollPane(GUITable, "MFListScrollPane", mainFrame, nil, true)
    listScrollPane.style = "MF_SwtichGUI_scroll_pan"
    listScrollPane.style.top_padding = 3
    listScrollPane.style.height = 400

    -- Update the GUI --
    GUI.updateMFSwitchMFGUI(GUITable, true)
    
    -- Return the Gui Table --
    return GUITable
end

-- Update the SwitchMF GUI --
function GUI.updateMFSwitchMFGUI(GUITable, justCreated)

    -- Get the Mobile Factory List Frame --
    local listFrame = GUITable.vars.MFListScrollPane

    -- Clear the Frame --
    listFrame.clear()

    -- Create the List Table --
    local listTable = GAPI.addTable(GUITable, "ListTable", listFrame, 1)

    -- Create the List --
    for k, MF2 in pairs(global.MFTable) do

        -- Create the Frame and the Flow --
        local frame = GAPI.addFrame(GUITable, "", listTable, "horizontal")
        local flow = GAPI.addFlow(GUITable, "", frame, "horizontal")
        frame.style.left_margin = 3
        frame.style.right_margin = 3
        flow.style.vertical_align = "center"

        -- Add the Select Button --
        local buttonStyle = "shortcut_bar_button_green"
        local buttonTooltip = {"", "[color=green]", {"gui-description.SelectMFTT1"}, "[/color]"}

        -- Change the Button if the Player is not allowed to use this Mobile Factory --
        if canUse(GUITable.MFPlayer, MF2) == false then
            buttonStyle = "MF_Fake_Button_Red"
            buttonTooltip = {"", "[color=red]", {"gui-description.SelectMFTT2"}, "[/color]"}
        end
        local icon = (MF2.ent ~= nil and MF2.ent.valid == true) and MF2.ent.name or "MobileFactory"
        GAPI.addButton(GUITable, "Swi.GUI.SwitchButton", flow, "item/" .. icon, "item/" .. icon, buttonTooltip, 50, false, true, nil, buttonStyle, {ID=k})

        -- Create the Info Table --
        local InfoTable = GAPI.addTable(GUITable, "", flow, 1)

        --Add the Name --
        local nameLabel = GAPI.addLabel(GUITable, "", InfoTable, MF2.name, _mfBlue, MF2.player, false, nil, _mfLabelType.yellowTitle)
        nameLabel.style.top_padding = 0
        nameLabel.style.top_margin = 0

        -- Add the Position --
        local mfPositionText = {"", {"gui-description.mfPosition"}, ": [color=yellow]", {"gui-description.Unknow"}, "[/color]"}
        if MF2.ent ~= nil and MF2.ent.valid == true then
            mfPositionText = {"", {"gui-description.mfPosition"}, ": [color=yellow](", math.floor(MF2.ent.position.x), " ; ", math.floor(MF2.ent.position.y), ")  ", MF2.ent.surface.name, "[/color]"}
        end
        local posLabel = GAPI.addLabel(GUITable, "PositionLabel", InfoTable, mfPositionText, _mfOrange, "Mobile Factory")
        posLabel.style.top_padding = 0
        posLabel.style.top_margin = 0

        -- Add all Information Bars --
        local barsTable = GAPI.addTable(GUITable, "", InfoTable, 5)
        barsTable.style.horizontally_stretchable = false
        barsTable.style.bottom_padding = 3

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

        if MF2.ent ~= nil and MF2.ent.valid == true then
            mfHealthValue = MF2.ent.health / MF2.ent.prototype.max_health
            mfHealthText = {"", {"gui-description.mfHealth"}, ": ", math.floor(MF2.ent.health), "/", MF2.ent.prototype.max_health}
            mfShielValue = 0
            mfShieldText = {"", {"gui-description.mfShield"}, ": ", 0}
            if MF2:maxShield() > 0 then
                mfShielValue = MF2:shield() / MF2:maxShield()
                mfShieldText = {"", {"gui-description.mfShield"}, ": ", math.floor(MF2:shield()), "/", MF2:maxShield()}
            end
            mfEnergyValue = 1 - (math.floor(100 - MF2.internalEnergyObj:energy() / MF2.internalEnergyObj:maxEnergy() * 100)) / 100
            mfEnergyText = {"", {"gui-description.mfEnergyCharge"}, ": ", Util.toRNumber(MF2.internalEnergyObj:energy()), "J/", Util.toRNumber(MF2.internalEnergyObj:maxEnergy()), "J"}
            mfQuatronValue = 1 - (math.floor(100 - MF2.internalQuatronObj.quatronCharge / MF2.internalQuatronObj.quatronMax * 100)) / 100
            mfQuatronText = {"", {"gui-description.mQuatronCharge"}, ": ", Util.toRNumber(MF2.internalQuatronObj.quatronCharge), "/", Util.toRNumber(MF2.internalQuatronObj.quatronMax), " (", {"gui-description.mQuatronPurity"}, ": ",  string.format("%.3f", MF2.internalQuatronObj.quatronLevel), ")"}
            mfJumpDriveValue = (math.floor(MF2.jumpDriveObj.charge / MF2.jumpDriveObj.maxCharge * 100)) / 100
            mfJumpDriveText = {"", {"gui-description.mfJumpCharge"}, ": ", MF2.jumpDriveObj.charge, "/", MF2.jumpDriveObj.maxCharge, " (", MF2.jumpDriveObj.chargeRate, "/s)"}
        end

        local bar1 = GAPI.addProgressBar(GUITable, "HealBar", barsTable, "", mfHealthText, false, _mfRed, mfHealthValue)
        local bar2 = GAPI.addProgressBar(GUITable, "ShieldBar", barsTable, "", mfShieldText, false, _mfBlue, mfShielValue)
        local bar3 = GAPI.addProgressBar(GUITable, "EnergyBar", barsTable, "", mfEnergyText, false, _mfYellow, mfEnergyValue)
        local bar4 = GAPI.addProgressBar(GUITable, "QuatronBar", barsTable, "", mfQuatronText, false, _mfPurple, mfQuatronValue)
        local bar5 = GAPI.addProgressBar(GUITable, "JumpDriveBar", barsTable, "", mfJumpDriveText, false, _mfOrange, mfJumpDriveValue)

        bar1.style.width = 40
        bar2.style.width = 40
        bar3.style.width = 40
        bar4.style.width = 40
        bar5.style.width = 40
    end

end

-- If the Player interacted with the GUI --
function GUI.switchMFGUIInteraction(event, player, MFPlayer)

    -- Change the Mobile Factory Name --
    if string.match(event.element.name, "Swi.GUI.ChangeNameButton") then
        -- Get the Name --
        local text = MFPlayer.GUI[_mfGUIName.SwitchMF].vars.SwitchMFChangeNameTextField.text
        -- Check if the Name is not the same Name --
        if text == MF.name then
            player.print({"gui-description.ChangeNameSameName"})
            return
        end
        -- Check if the Name is more than three Characters and less than 30 Characters --
        if string.len(text) < 3 or string.len(text) > 30 then
            player.print({"gui-description.ChangeNameCharNumberError"})
            return
        end
        -- Check if the Name is not already used --
        for _, MF2 in pairs(global.MFTable) do
            if MF2.name == text then
                player.print({"gui-description.ChangeNameAlreadyUsed"})
                return
            end
        end
        -- Change the Name --
        MF.name = text
        player.print({"", {"gui-description.ChangeNameChanged"}, " ", text})
        return
	end

    -- Open the Camera GUI --
    if string.match(event.element.name, "Swi.GUI.SwitchButton") and event.button == defines.mouse_button_type.right then
        -- Get the Mobile Factory ID --
		local ID = event.element.tags.ID
        -- Check if the Player is allowed to use this Mobile Factory --
		if canUse(MFPlayer, global.MFTable[ID]) == false then
			player.print({"gui-description.NotAllowedMF"})
			return
		end
        -- Check if another Camera have to be closed --
        if MFPlayer.GUI[_mfGUIName.CameraGUI] ~= nil and MFPlayer.GUI[_mfGUIName.CameraGUI].gui ~= nil and MFPlayer.GUI[_mfGUIName.CameraGUI].gui.valid == true then
            MFPlayer.GUI[_mfGUIName.CameraGUI].gui.destroy()
            MFPlayer.GUI[_mfGUIName.CameraGUI] = nil
        end
        -- Create the Camera Windows --
        MFPlayer.GUI[_mfGUIName.CameraGUI] = GAPI.createCamera(MFPlayer, _mfGUIName.CameraGUI, global.MFTable[ID].name, global.MFTable[ID].ent, 300, 0.5)
        return
    end

    -- Change the current Mobile Factory --
    if string.match(event.element.name, "Swi.GUI.SwitchButton") then
		-- Get the Mobile Factory ID --
		local ID = event.element.tags.ID
		-- Check if the Player is allowed to use this Mobile Factory --
		if canUse(MFPlayer, global.MFTable[ID]) == false then
			player.print({"gui-description.NotAllowedMF"})
			return
		end
		-- Change the Current Mobile Factory --
		MFPlayer.currentMF = global.MFTable[ID]
		-- Display the Message --
		player.print({"", {"gui-description.CurrentMFChanged"}, " ", MFPlayer.currentMF.name})
        return
	end

end