-- Create the SwitchMF GUI --
function GUI.createSwitchMFGUI(player)

    -- Create the GUI --
    local GUIObj = GUI.createGUI("MFSwitchMFGUI", getMFPlayer(player.name), "vertical", true, 0, 0)
    local switchMFGUI = GUIObj.gui

    -- Create the top Bar --
    GUI.createTopBar(GUIObj, 100)

    -- Create the Main Frame --
    local scrollPane = GUIObj:addScrollPane("MFSwitchGUIScrollPane", switchMFGUI, 500, true)
    scrollPane.style.minimal_height = 300

    -- Center the GUI --
    switchMFGUI.force_auto_center()

    -- Update the GUI --
    GUI.updateMFSwitchMFGUI(GUIObj, true)

    -- Return the GUI Object --
    return GUIObj

end

-- Update the SwitchMF GUI --
function GUI.updateMFSwitchMFGUI(GUIObj, justCreated)

    -- Get all Variables --
    local mainPane = GUIObj.MFSwitchGUIScrollPane
    local MF = GUIObj.MF

    if justCreated == true then

        -- Create the Name Frame --
        local nameFrame = GUIObj:addFrame("", mainPane, "vertical")

        -- Create the Name Frame Text --
        GUIObj:addLabel("", nameFrame, {"gui-description.MFName"}, nil, {"gui-description.MFNameTT"}, false, "LabelFont2")

        -- Create the Change Name Frame --
        local changeNameFlow = GUIObj:addFlow("", nameFrame, "horizontal")

        -- Create the Change Name Textfield --
        GUIObj:addTextField("SwitchMFChangeNameTextField", changeNameFlow, MF.name or "", {"gui-description.MFChangeNameTT"}, true)

        -- Create the Change Name Button --
        GUIObj:addSimpleButton("SwitchMFChangeNameButton", changeNameFlow, {"gui-description.Change"})

    end

    -- Create the Mobile Factory list Frame --
    local listFrame = GUIObj.MFListFrame or GUIObj:addFrame("MFListFrame", mainPane, "vertical", true)

    -- Clear the Frame --
    listFrame.clear()

    -- Create the List --
    for k, MF2 in pairs(global.MFTable) do
        -- Create the Flow --
        local MFFlow = GUIObj:addFlow("", listFrame, "horizontal")
        -- Add the Select Button --
        local button = GUIObj:addSimpleButton("SwitchMFSwitchButton," .. k, MFFlow, {"gui-description.Select"}, {"gui-description.SelectMFTT1"})
        -- Disable the Button if the Player is not allowed to use this Mobile Factory --
        if Util.canUse(GUIObj.MFPlayer, MF2) == false then
            button.enabled = false
            button.tooltip = {"gui-description.SelectMFTT2"}
        end
        --Add the Name --
        GUIObj:addLabel("", MFFlow, MF2.name, _mfGreen, MF2.player, false, "LabelFont2")
    end

    
end