-- Create the SwitchMF GUI --
function GUI.createSwitchMFGUI(player)
    
    -- Create the Main Window --
    local table = GAPI.createBaseWindows(_mfGUIName.SwitchMF, {"gui-description.MFSwitchMFGUITitle"}, getMFPlayer(player.name))

    -- Add the Close Button --
    GAPI.addCloseButton(table)

    -- Update the GUI --
    GUI.updateMFSwitchMFGUI(table, true)
    
    -- Return the Gui Table --
    return table
end

-- Update the SwitchMF GUI --
function GUI.updateMFSwitchMFGUI(table, justCreated)

    -- Get all Variables --
    local mainPane = table.vars.MainFrame
    local MF = table.MFPlayer.MF

    if justCreated == true then

        -- Create the Name Frame --
        local nameFrame = GAPI.addFrame(table, "", mainPane, "vertical")

        -- Create the Name Frame Text --
        GAPI.addLabel(table, "", nameFrame, {"gui-description.MFName"}, nil, {"gui-description.MFNameTT"}, false, nil, "bold_green_label")

        -- Create the Change Name Frame --
        local changeNameFlow = GAPI.addFlow(table, "", nameFrame, "horizontal")

        -- Create the Change Name Button --
        local button = GAPI.addSimpleButton(table, "SwitchMFChangeNameButton", changeNameFlow, {"gui-description.Change"})
        button.style.width = 70

        -- Create the Change Name Textfield --
        local textField = GAPI.addTextField(table, "SwitchMFChangeNameTextField", changeNameFlow, MF.name or "", {"gui-description.MFChangeNameTT"}, true)
        textField.style.horizontally_stretchable = true

    end

    -- Create the Mobile Factory list Frame --
    local listFrame = table.vars.MFListFrame or GAPI.addScrollPane(table, "MFListFrame", mainPane, nil, true, nil, "auto")
    listFrame.style.vertically_stretchable = true

    -- Clear the Frame --
    listFrame.clear()

    -- Create the List --
    for k, MF2 in pairs(global.MFTable) do
        -- Create the Flow --
        local MFFrame = GAPI.addFrame(table, "", listFrame, "horizontal")
        -- Add the Select Button --
        local button = GAPI.addSimpleButton(table, "SwitchMFSwitchButton," .. k, MFFrame, {"gui-description.Select"}, {"gui-description.SelectMFTT1"})
        button.style.width = 70
        -- Disable the Button if the Player is not allowed to use this Mobile Factory --
        if Util.canUse(table.MFPlayer, MF2) == false then
            button.enabled = false
            button.tooltip = {"gui-description.SelectMFTT2"}
        end
        -- Add the Icon --
        local icon = (MF2.ent ~= nil and MF2.ent.valid == true) and MF2.ent.name or "MobileFactory"
        GAPI.addSprite(table, "", MFFrame, "item/" .. icon)
        --Add the Name --
        GAPI.addLabel(table, "", MFFrame, MF2.name, _mfBlue, MF2.player, false, "LabelFont2")
    end

end