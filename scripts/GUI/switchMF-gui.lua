-- Create the SwitchMF GUI --
function GUI.createSwitchMFGUI(player)
    
    -- Create the Main Window --
    local table = GAPI.createBaseWindows(_mfGUIName.SwitchMF, {"gui-description.MFSwitchMFGUITitle"}, getMFPlayer(player.name), true, false)
    GAPI.setMinSize(table.gui, 600)

    -- Add the Close Button --
    GAPI.addCloseButton(table)

    -- Create the Line --
    -- GAPI.addLine(table, "", table.gui, "horizontal")

    -- Create the List Information --
    local infoLabel = GAPI.addLabel(table, "", table.gui, {"gui-description.SwitchMFInfo"}, _mfWhite)
    infoLabel.style.single_line = false
    infoLabel.style.maximal_width = 270

    -- Create the Line --
    GAPI.addLine(table, "", table.gui, "horizontal")

    -- Create the Change Name Frame --
    local changeNameFlow = GAPI.addFlow(table, "", table.gui, "horizontal")
    changeNameFlow.style.horizontally_stretchable = true
    changeNameFlow.style.horizontal_align = "center"
    changeNameFlow.style.bottom_margin = 3

    -- Create the Change Name Textfield --
    local textField = GAPI.addTextField(table, "SwitchMFChangeNameTextField", changeNameFlow, table.MFPlayer.MF.name or "", {"gui-description.MFChangeNameTT"}, true)
    textField.style.horizontally_stretchable = true

    -- Create the Change Name Button --
    local button = GAPI.addSimpleButton(table, "SwitchMFChangeNameButton", changeNameFlow, {"gui-description.Change"})
    button.style.width = 78
    button.style.top_margin = 1

    -- Create the Main Frame --
    local mainFrame = GAPI.addFrame(table, "MainFrame", table.gui, "vertical", true)
    mainFrame.style = "MFFrame1"

    -- Create the Mobile Factory List Scroll Pane --
    local listScrollPane = GAPI.addScrollPane(table, "MFListScrollPane", mainFrame, nil, true, nil, "auto")
    listScrollPane.style = "MF_SwtichGUI_scroll_pan"
    listScrollPane.style.top_padding = 3
    listScrollPane.style.vertically_stretchable = true

    -- Update the GUI --
    GUI.updateMFSwitchMFGUI(table, true)
    
    -- Return the Gui Table --
    return table
end

-- Update the SwitchMF GUI --
function GUI.updateMFSwitchMFGUI(table, justCreated)

    -- Get the Mobile Factory List Frame --
    local listFrame = table.vars.MFListScrollPane

    -- Clear the Frame --
    listFrame.clear()

    -- Create the List Table --
    local listTable = GAPI.addTable(table, "ListTable", listFrame, 1)

    -- Create the List --
    for k, MF2 in pairs(global.MFTable) do

        -- Create the Frame and the Flow --
        local frame = GAPI.addFrame(table, "", listTable, "horizontal")
        local flow = GAPI.addFlow(table, "", frame, "horizontal")
        frame.style.left_margin = 3
        frame.style.right_margin = 3
        flow.style.vertical_align = "center"

        -- Add the Select Button --
        local buttonStyle = "shortcut_bar_button_green"
        local buttonTooltip = {"gui-description.SelectMFTT1"}

        -- Change the Button if the Player is not allowed to use this Mobile Factory --
        if Util.canUse(table.MFPlayer, MF2) == false then
            buttonStyle = "MF_Fake_Button_Red"
            buttonTooltip = {"gui-description.SelectMFTT2"}
        end
        local icon = (MF2.ent ~= nil and MF2.ent.valid == true) and MF2.ent.name or "MobileFactory"
        GAPI.addButton(table, "SwitchMFSwitchButton," .. k, flow, "item/" .. icon, "item/" .. icon, buttonTooltip, 50, false, true, nil, buttonStyle)

        -- Create the Info Table --
        local InfoTable = GAPI.addTable(table, "", flow, 1)

        --Add the Name --
        local nameLabel = GAPI.addLabel(table, "", InfoTable, MF2.name, _mfBlue, MF2.player, false, nil, "yellow_label")
        nameLabel.style.top_padding = 0
        nameLabel.style.top_margin = 0

        -- Add the Position --
        local mfPositionText = {"", {"gui-description.mfPosition"}, ": [color=yellow]", {"gui-description.Unknow"}, "[/color]"}
        if MF2.ent ~= nil and MF2.ent.valid == true then
            mfPositionText = {"", {"gui-description.mfPosition"}, ": [color=yellow](", math.floor(MF2.ent.position.x), " ; ", math.floor(MF2.ent.position.y), ")  ", MF2.ent.surface.name, "[/color]"}
        end
        local posLabel = GAPI.addLabel(table, "PositionLabel", InfoTable, mfPositionText, _mfOrange, "Mobile Factory")
        posLabel.style.top_padding = 0
        posLabel.style.top_margin = 0

        -- Add all Information Bars --
        local barsTable = GAPI.addTable(table, "", InfoTable, 5)
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

        local bar1 = GAPI.addProgressBar(table, "HealBar", barsTable, "", mfHealthText, false, _mfRed, mfHealthValue)
        local bar2 = GAPI.addProgressBar(table, "ShieldBar", barsTable, "", mfShieldText, false, _mfBlue, mfShielValue)
        local bar3 = GAPI.addProgressBar(table, "EnergyBar", barsTable, "", mfEnergyText, false, _mfYellow, mfEnergyValue)
        local bar4 = GAPI.addProgressBar(table, "QuatronBar", barsTable, "", mfQuatronText, false, _mfPurple, mfQuatronValue)
        local bar5 = GAPI.addProgressBar(table, "JumpDriveBar", barsTable, "", mfJumpDriveText, false, _mfOrange, mfJumpDriveValue)

        bar1.style.width = 40
        bar2.style.width = 40
        bar3.style.width = 40
        bar4.style.width = 40
        bar5.style.width = 40
    end

end