-- Create the Deploy GUI --
function GUI.createDeployGUI(player)

    -- Get the MFPlayer and the Current MF --
    local MFPlayer = getMFPlayer(player.name)
    local MF = getCurrentMF(MFPlayer)

    -- Create the GUI --
    local GUITable = GAPI.createBaseWindows(_mfGUIName.DeployGUI, {"gui-description.DPGuiTitle"}, MFPlayer, true, true, false, "vertical", "vertical")
    local mainFrame = GUITable.vars.MainFrame

    -- Add the Close Button --
    GAPI.addCloseButton(GUITable)

    -- Add the Help Label --
    local label = GAPI.addLabel(GUITable, "", mainFrame, {"gui-description.DPHelpText"}, _mfWhite)
    label.style.maximal_width = 300
    label.style.single_line = false

    -- Create the Configuration Frame --
    local confFrame = GAPI.addFrame(GUITable, "", mainFrame, "vertical")
    confFrame.style = "MFFrame1"

    -- Add the Title --
    GAPI.addSubtitle(GUITable, "", confFrame, {"gui-description.DPConfTitle"})

    -- Create the Configuration Table --
    local confTable = GAPI.addTable(GUITable, "", confFrame, 3)

    ------ Create all Slots ------
    local buttonSize = 48

    -- Line 1 --
    GAPI.addFlow(GUITable, "", confTable, "vertical")
    local slotFlow1 = GAPI.addFlow(GUITable, "SlotFlow1", confTable, "horizontal")
    slotFlow1.style.horizontally_stretchable = true
    slotFlow1.style.horizontal_align = "center"
    local slot1 = GAPI.addButton(GUITable, "DP.GUI.Slot1", slotFlow1, nil, nil, {"gui-description.DPSlotTT", 1}, buttonSize, true, true, nil, nil, {slot=1})
    local slot2 = GAPI.addButton(GUITable, "DP.GUI.Slot2", slotFlow1, nil, nil, {"gui-description.DPSlotTT", 2}, buttonSize, true, true, nil, nil, {slot=2})
    local slot3 = GAPI.addButton(GUITable, "DP.GUI.Slot3", slotFlow1, nil, nil, {"gui-description.DPSlotTT", 3}, buttonSize, true, true, nil, nil, {slot=3})
    local slot4 = GAPI.addButton(GUITable, "DP.GUI.Slot4", slotFlow1, nil, nil, {"gui-description.DPSlotTT", 4}, buttonSize, true, true, nil, nil, {slot=4})
    GAPI.addFlow(GUITable, "", confTable, "vertical")

    -- Line 2 --
    local slotFlow2 = GAPI.addFlow(GUITable, "SlotFlow2", confTable, "vertical")
    slotFlow2.style.vertically_stretchable = true
    slotFlow2.style.vertical_align = "center"
    local slot5 = GAPI.addButton(GUITable, "DP.GUI.Slot5", slotFlow2, nil, nil, {"gui-description.DPSlotTT", 5}, buttonSize, true, true, nil, nil, {slot=5})
    local slot6 = GAPI.addButton(GUITable, "DP.GUI.Slot6", slotFlow2, nil, nil, {"gui-description.DPSlotTT", 6}, buttonSize, true, true, nil, nil, {slot=6})
    local slot7 = GAPI.addButton(GUITable, "DP.GUI.Slot7", slotFlow2, nil, nil, {"gui-description.DPSlotTT", 7}, buttonSize, true, true, nil, nil, {slot=7})
    local slot8 = GAPI.addButton(GUITable, "DP.GUI.Slot8", slotFlow2, nil, nil, {"gui-description.DPSlotTT", 8}, buttonSize, true, true, nil, nil, {slot=8})
    local slot9 = GAPI.addButton(GUITable, "DP.GUI.Slot9", slotFlow2, nil, nil, {"gui-description.DPSlotTT", 9}, buttonSize, true, true, nil, nil, {slot=9})
    local slot10 = GAPI.addButton(GUITable, "DP.GUI.Slot10", slotFlow2, nil, nil, {"gui-description.DPSlotTT", 10}, buttonSize, true, true, nil, nil, {slot=10})
    GAPI.addSprite(GUITable, "", confTable, "MFDeployE")
    local slotFlow3 = GAPI.addFlow(GUITable, "SlotFlow3", confTable, "vertical")
    slotFlow3.style.vertically_stretchable = true
    slotFlow3.style.vertical_align = "center"
    local slot11 = GAPI.addButton(GUITable, "DP.GUI.Slot11", slotFlow3, nil, nil, {"gui-description.DPSlotTT", 11}, buttonSize, true, true, nil, nil, {slot=11})
    local slot12 = GAPI.addButton(GUITable, "DP.GUI.Slot12", slotFlow3, nil, nil, {"gui-description.DPSlotTT", 12}, buttonSize, true, true, nil, nil, {slot=12})
    local slot13 = GAPI.addButton(GUITable, "DP.GUI.Slot13", slotFlow3, nil, nil, {"gui-description.DPSlotTT", 13}, buttonSize, true, true, nil, nil, {slot=13})
    local slot14 = GAPI.addButton(GUITable, "DP.GUI.Slot14", slotFlow3, nil, nil, {"gui-description.DPSlotTT", 14}, buttonSize, true, true, nil, nil, {slot=14})
    local slot15 = GAPI.addButton(GUITable, "DP.GUI.Slot15", slotFlow3, nil, nil, {"gui-description.DPSlotTT", 15}, buttonSize, true, true, nil, nil, {slot=15})
    local slot16 = GAPI.addButton(GUITable, "DP.GUI.Slot16", slotFlow3, nil, nil, {"gui-description.DPSlotTT", 16}, buttonSize, true, true, nil, nil, {slot=16})

    -- Line 3 --
    GAPI.addFlow(GUITable, "", confTable, "vertical")
    local slotFlow4 = GAPI.addFlow(GUITable, "SlotFlow4", confTable, "horizontal")
    slotFlow4.style.horizontally_stretchable = true
    slotFlow4.style.horizontal_align = "center"
    local slot17 = GAPI.addButton(GUITable, "DP.GUI.Slot17", slotFlow4, nil, nil, {"gui-description.DPSlotTT", 17}, buttonSize, true, true, nil, nil, {slot=17})
    local slot18 = GAPI.addButton(GUITable, "DP.GUI.Slot18", slotFlow4, nil, nil, {"gui-description.DPSlotTT", 18}, buttonSize, true, true, nil, nil, {slot=18})
    local slot19 = GAPI.addButton(GUITable, "DP.GUI.Slot19", slotFlow4, nil, nil, {"gui-description.DPSlotTT", 19}, buttonSize, true, true, nil, nil, {slot=19})
    local slot20 = GAPI.addButton(GUITable, "DP.GUI.Slot20", slotFlow4, nil, nil, {"gui-description.DPSlotTT", 20}, buttonSize, true, true, nil, nil, {slot=20})
    GAPI.addFlow(GUITable, "", confTable, "vertical")

    -- Disable not unlocked Slots --
    if technologyUnlocked("MFDSlot5", getForce(MF)) == false then slot5.enabled = false end
    if technologyUnlocked("MFDSlot6", getForce(MF)) == false then slot6.enabled = false end
    if technologyUnlocked("MFDSlot7", getForce(MF)) == false then slot7.enabled = false end
    if technologyUnlocked("MFDSlot8", getForce(MF)) == false then slot8.enabled = false end
    if technologyUnlocked("MFDSlot9", getForce(MF)) == false then slot9.enabled = false end
    if technologyUnlocked("MFDSlot10", getForce(MF)) == false then slot10.enabled = false end
    if technologyUnlocked("MFDSlot11", getForce(MF)) == false then slot11.enabled = false end
    if technologyUnlocked("MFDSlot12", getForce(MF)) == false then slot12.enabled = false end
    if technologyUnlocked("MFDSlot13", getForce(MF)) == false then slot13.enabled = false end
    if technologyUnlocked("MFDSlot14", getForce(MF)) == false then slot14.enabled = false end
    if technologyUnlocked("MFDSlot15", getForce(MF)) == false then slot15.enabled = false end
    if technologyUnlocked("MFDSlot16", getForce(MF)) == false then slot16.enabled = false end
    if technologyUnlocked("MFDSlot17", getForce(MF)) == false then slot17.enabled = false end
    if technologyUnlocked("MFDSlot18", getForce(MF)) == false then slot18.enabled = false end
    if technologyUnlocked("MFDSlot19", getForce(MF)) == false then slot19.enabled = false end
    if technologyUnlocked("MFDSlot20", getForce(MF)) == false then slot20.enabled = false end

    -- Add the Line --
    GAPI.addLine(GUITable, "", confFrame, "horizontal")

    -- Add the Reflesh Flow --
    local rflow = GAPI.addFlow(GUITable, "", confFrame, "horizontal")
    rflow.style.horizontal_align = "center"

    -- Add the Refresh Button --
    GAPI.addSimpleButton(GUITable, "DP.GUI.RefreshButton", rflow, {"gui-description.DPRefreshButton"}, {"gui-description.DPRefreshButtonTT"})

    -- Update the GUI --
    GUI.updateMFDeployGUI(GUITable)

    -- Return the Table --
    return GUITable

end

-- Update the GUI --
function GUI.updateMFDeployGUI(GUITable)

    -- Get the MF --
    local MF = getCurrentMF(GUITable.MFPlayer)

    -- Getting all Button Sprite --
    local sprite1 = MF.slots[1] ~= nil and "entity/" .. MF.slots[1].entity or nil
    local sprite2 = MF.slots[2] ~= nil and "entity/" .. MF.slots[2].entity or nil
    local sprite3 = MF.slots[3] ~= nil and "entity/" .. MF.slots[3].entity or nil
    local sprite4 = MF.slots[4] ~= nil and "entity/" .. MF.slots[4].entity or nil
    local sprite5 = MF.slots[5] ~= nil and "entity/" .. MF.slots[5].entity or nil
    local sprite6 = MF.slots[6] ~= nil and "entity/" .. MF.slots[6].entity or nil
    local sprite7 = MF.slots[7] ~= nil and "entity/" .. MF.slots[7].entity or nil
    local sprite8 = MF.slots[8] ~= nil and "entity/" .. MF.slots[8].entity or nil
    local sprite9 = MF.slots[9] ~= nil and "entity/" .. MF.slots[9].entity or nil
    local sprite10 = MF.slots[10] ~= nil and "entity/" .. MF.slots[10].entity or nil
    local sprite11 = MF.slots[11] ~= nil and "entity/" .. MF.slots[11].entity or nil
    local sprite12 = MF.slots[12] ~= nil and "entity/" .. MF.slots[12].entity or nil
    local sprite13 = MF.slots[13] ~= nil and "entity/" .. MF.slots[13].entity or nil
    local sprite14 = MF.slots[14] ~= nil and "entity/" .. MF.slots[14].entity or nil
    local sprite15 = MF.slots[15] ~= nil and "entity/" .. MF.slots[15].entity or nil
    local sprite16 = MF.slots[16] ~= nil and "entity/" .. MF.slots[16].entity or nil
    local sprite17 = MF.slots[17] ~= nil and "entity/" .. MF.slots[17].entity or nil
    local sprite18 = MF.slots[18] ~= nil and "entity/" .. MF.slots[18].entity or nil
    local sprite19 = MF.slots[19] ~= nil and "entity/" .. MF.slots[19].entity or nil
    local sprite20 = MF.slots[20] ~= nil and "entity/" .. MF.slots[20].entity or nil

    -- Update all Buttons --
    GUITable.vars["DP.GUI.Slot1"].sprite = sprite1
    GUITable.vars["DP.GUI.Slot2"].sprite = sprite2
    GUITable.vars["DP.GUI.Slot3"].sprite = sprite3
    GUITable.vars["DP.GUI.Slot4"].sprite = sprite4
    GUITable.vars["DP.GUI.Slot5"].sprite = sprite5
    GUITable.vars["DP.GUI.Slot6"].sprite = sprite6
    GUITable.vars["DP.GUI.Slot7"].sprite = sprite7
    GUITable.vars["DP.GUI.Slot8"].sprite = sprite8
    GUITable.vars["DP.GUI.Slot9"].sprite = sprite9
    GUITable.vars["DP.GUI.Slot10"].sprite = sprite10
    GUITable.vars["DP.GUI.Slot11"].sprite = sprite11
    GUITable.vars["DP.GUI.Slot12"].sprite = sprite12
    GUITable.vars["DP.GUI.Slot13"].sprite = sprite13
    GUITable.vars["DP.GUI.Slot14"].sprite = sprite14
    GUITable.vars["DP.GUI.Slot15"].sprite = sprite15
    GUITable.vars["DP.GUI.Slot16"].sprite = sprite16
    GUITable.vars["DP.GUI.Slot17"].sprite = sprite17
    GUITable.vars["DP.GUI.Slot18"].sprite = sprite18
    GUITable.vars["DP.GUI.Slot19"].sprite = sprite19
    GUITable.vars["DP.GUI.Slot20"].sprite = sprite20

end

function GUI.MFDPOpenSlotGUI(DPGUITable, MFPlayer, currentMF, slotNumber)

    -- Create the GUI --
    MFPlayer.GUI[_mfGUIName.SlotGUI] = GAPI.createBaseWindows(_mfGUIName.SlotGUI, {"gui-description.SlotGUITitle", slotNumber}, MFPlayer, true, true, false, "vertical", "vertical")
    local GUITable = MFPlayer.GUI[_mfGUIName.SlotGUI]
    local mainFrame = GUITable.vars.MainFrame

    -- Add the Close Button --
    GAPI.addCloseButton(GUITable)

    -- Create the Entities Flow --
    local entsFlow = GAPI.addFlow(GUITable, "", mainFrame, "vertical")
    local buttonSize = 50

    --------------------------------------- Add the Dimensional Belts ---------------------------------------
    GAPI.addLabel(GUITable, "", entsFlow, {"gui-description.Belts"}, nil, nil, false, nil, _mfLabelType.yellowTitle)
    local inputBeltsTable = GAPI.addTable(GUITable, "", entsFlow, 6)

    -- Add all Dimensinal Belts Input --
    local button1 = GAPI.addButton(GUITable, "DP.GUI.EntButton1", inputBeltsTable, "entity/DimensionalBelt1", "entity/DimensionalBelt1", { "", Util.getLocEntityName("DimensionalBelt1"), " [color=yellow]", {"gui-description.Input"}, "[/color]"}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalBelt1", way="input"})
    local button2 = GAPI.addButton(GUITable, "DP.GUI.EntButton2", inputBeltsTable, "entity/DimensionalBelt2", "entity/DimensionalBelt2", { "", Util.getLocEntityName("DimensionalBelt2"), " [color=yellow]", {"gui-description.Input"}, "[/color]"}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalBelt2", way="input"})
    local button3 = GAPI.addButton(GUITable, "DP.GUI.EntButton3", inputBeltsTable, "entity/DimensionalBelt3", "entity/DimensionalBelt3", { "", Util.getLocEntityName("DimensionalBelt3"), " [color=yellow]", {"gui-description.Input"}, "[/color]"}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalBelt3", way="input"})

    -- Disable needed Buttons --
    if technologyUnlocked("DimensionalBelt2", getForce(currentMF)) == false then
        button2.enabled = false
        button2.tooltip =  { "", Util.getLocEntityName("DimensionalBelt2"), " [color=yellow]", {"gui-description.Input"}, "[/color]", "\n[color=red]", {"gui-description.SlotGUINotUnlocked"}, "[/color]"}
    end
    if technologyUnlocked("DimensionalBelt3", getForce(currentMF)) == false then
        button3.enabled = false
        button3.tooltip = { "", Util.getLocEntityName("DimensionalBelt3"), " [color=yellow]", {"gui-description.Input"}, "[/color]", "\n[color=red]", {"gui-description.SlotGUINotUnlocked"}, "[/color]"}
    end

    -- Add all Dimensinal Belts Output --
    local button4 = GAPI.addButton(GUITable, "DP.GUI.EntButton4", inputBeltsTable, "entity/DimensionalBelt1", "entity/DimensionalBelt1", { "", Util.getLocEntityName("DimensionalBelt1"), " [color=yellow]", {"gui-description.Output"}, "[/color]"}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalBelt1", way="output"})
    local button5 = GAPI.addButton(GUITable, "DP.GUI.EntButton5", inputBeltsTable, "entity/DimensionalBelt2", "entity/DimensionalBelt2", { "", Util.getLocEntityName("DimensionalBelt2"), " [color=yellow]", {"gui-description.Output"}, "[/color]"}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalBelt2", way="output"})
    local button6 = GAPI.addButton(GUITable, "DP.GUI.EntButton6", inputBeltsTable, "entity/DimensionalBelt3", "entity/DimensionalBelt3", { "", Util.getLocEntityName("DimensionalBelt3"), " [color=yellow]", {"gui-description.Output"}, "[/color]"}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalBelt3", way="output"})
    button4.style.left_margin = 8

    -- Disable needed Buttons --
    if technologyUnlocked("DimensionalBelt2", getForce(currentMF)) == false then
        button5.enabled = false
        button5.tooltip =  { "", Util.getLocEntityName("DimensionalBelt2"), " [color=yellow]", {"gui-description.Output"}, "[/color]", "\n[color=red]", {"gui-description.SlotGUINotUnlocked"}, "[/color]"}
    end
    if technologyUnlocked("DimensionalBelt3", getForce(currentMF)) == false then
        button6.enabled = false
        button6.tooltip = { "", Util.getLocEntityName("DimensionalBelt3"), " [color=yellow]", {"gui-description.Output"}, "[/color]", "\n[color=red]", {"gui-description.SlotGUINotUnlocked"}, "[/color]"}
    end

    --------------------------------------- Add the Dimensional Pipes ---------------------------------------
    GAPI.addLabel(GUITable, "", entsFlow, {"gui-description.Pipes"}, nil, nil, false, nil, _mfLabelType.yellowTitle)
    local inputPipesTable = GAPI.addTable(GUITable, "", entsFlow, 6)

    -- Add all Dimensinal Pipes Input --
    local button7 = GAPI.addButton(GUITable, "DP.GUI.EntButton7", inputPipesTable, "entity/DimensionalPipe1", "entity/DimensionalPipe1", { "", Util.getLocEntityName("DimensionalPipe1"), " [color=yellow]", {"gui-description.Input"}, "[/color]"}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalPipe1", way="input"})
    local button8 = GAPI.addButton(GUITable, "DP.GUI.EntButton8", inputPipesTable, "entity/DimensionalPipe2", "entity/DimensionalPipe2", { "", Util.getLocEntityName("DimensionalPipe2"), " [color=yellow]", {"gui-description.Input"}, "[/color]"}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalPipe2", way="input"})
    local button9 = GAPI.addButton(GUITable, "DP.GUI.EntButton9", inputPipesTable, "entity/DimensionalPipe3", "entity/DimensionalPipe3", { "", Util.getLocEntityName("DimensionalPipe3"), " [color=yellow]", {"gui-description.Input"}, "[/color]"}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalPipe3", way="input"})

    -- Disable needed Buttons --
    if technologyUnlocked("DimensionalPipe2", getForce(currentMF)) == false then
        button8.enabled = false
        button8.tooltip =  { "", Util.getLocEntityName("DimensionalPipe2"), " [color=yellow]", {"gui-description.Input"}, "[/color]", "\n[color=red]", {"gui-description.SlotGUINotUnlocked"}, "[/color]"}
    end
    if technologyUnlocked("DimensionalPipe3", getForce(currentMF)) == false then
        button9.enabled = false
        button9.tooltip = { "", Util.getLocEntityName("DimensionalPipe3"), " [color=yellow]", {"gui-description.Input"}, "[/color]", "\n[color=red]", {"gui-description.SlotGUINotUnlocked"}, "[/color]"}
    end

    -- Add all Dimensinal Pipes Output --
    local button10 = GAPI.addButton(GUITable, "DP.GUI.EntButton10", inputPipesTable, "entity/DimensionalPipe1", "entity/DimensionalPipe1", { "", Util.getLocEntityName("DimensionalPipe1"), " [color=yellow]", {"gui-description.Output"}, "[/color]"}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalPipe1", way="output"})
    local button11 = GAPI.addButton(GUITable, "DP.GUI.EntButton11", inputPipesTable, "entity/DimensionalPipe2", "entity/DimensionalPipe2", { "", Util.getLocEntityName("DimensionalPipe2"), " [color=yellow]", {"gui-description.Output"}, "[/color]"}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalPipe2", way="output"})
    local button12 = GAPI.addButton(GUITable, "DP.GUI.EntButton12", inputPipesTable, "entity/DimensionalPipe3", "entity/DimensionalPipe3", { "", Util.getLocEntityName("DimensionalPipe3"), " [color=yellow]", {"gui-description.Output"}, "[/color]"}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalPipe3", way="output"})
    button10.style.left_margin = 8

    -- Disable needed Buttons --
    if technologyUnlocked("DimensionalPipe2", getForce(currentMF)) == false then
        button11.enabled = false
        button11.tooltip =  { "", Util.getLocEntityName("DimensionalPipe2"), " [color=yellow]", {"gui-description.Output"}, "[/color]", "\n[color=red]", {"gui-description.SlotGUINotUnlocked"}, "[/color]"}
    end
    if technologyUnlocked("DimensionalPipe3", getForce(currentMF)) == false then
        button12.enabled = false
        button12.tooltip = { "", Util.getLocEntityName("DimensionalPipe3"), " [color=yellow]", {"gui-description.Output"}, "[/color]", "\n[color=red]", {"gui-description.SlotGUINotUnlocked"}, "[/color]"}
    end

    --------------------------------------- Add the Dimensional Pole ---------------------------------------
    GAPI.addLabel(GUITable, "", entsFlow, {"gui-description.Poles"}, nil, nil, false, nil, _mfLabelType.yellowTitle)
    local inputPolesTable = GAPI.addTable(GUITable, "", entsFlow, 6)

    -- Add all Dimensinal Poles --
    local button13 = GAPI.addButton(GUITable, "DP.GUI.EntButton13", inputPolesTable, "entity/DimensionalPole1", "entity/DimensionalPole1", { "", Util.getLocEntityName("DimensionalPole1")}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalPole1", way="input"})
    local button14 = GAPI.addButton(GUITable, "DP.GUI.EntButton14", inputPolesTable, "entity/DimensionalPole2", "entity/DimensionalPole2", { "", Util.getLocEntityName("DimensionalPole2")}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalPole2", way="input"})
    local button15 = GAPI.addButton(GUITable, "DP.GUI.EntButton15", inputPolesTable, "entity/DimensionalPole3", "entity/DimensionalPole3", { "", Util.getLocEntityName("DimensionalPole3")}, buttonSize, false, true, nil, "MF_Button_Blue_GrayWhenDisabled", {slot=slotNumber, entity="DimensionalPole3", way="input"})

    -- Disable needed Buttons --
    if technologyUnlocked("DimensionalPole2", getForce(currentMF)) == false then
        button14.enabled = false
        button14.tooltip =  { "", Util.getLocEntityName("DimensionalPole2"), "\n[color=red]", {"gui-description.SlotGUINotUnlocked"}, "[/color]"}
    end
    if technologyUnlocked("DimensionalPole3", getForce(currentMF)) == false then
        button15.enabled = false
        button15.tooltip = { "", Util.getLocEntityName("DimensionalPole3"), "\n[color=red]", {"gui-description.SlotGUINotUnlocked"}, "[/color]"}
    end

end

-- If the Player interacted with the GUI --
function GUI.MFDPGUIInteraction(event, MFPlayer, currentMF)

    -- If a slot if Right Clicked --
    if string.match(event.element.name, "DP.GUI.Slot") and event.button == defines.mouse_button_type.right then
        currentMF.slots[event.element.tags.slot] = nil
        return
    end

    -- If a Slot is clicked --
    if string.match(event.element.name, "DP.GUI.Slot") then
        GUI.MFDPOpenSlotGUI(MFPlayer.GUI[_mfGUIName.DeployGUI], MFPlayer, currentMF, event.element.tags.slot)
        return
    end

    -- If the Refresh Button is clicked --
    if event.element.name == "DP.GUI.RefreshButton" then
        if currentMF.deployed == true then
            currentMF:repack()
            currentMF:deploy()
        end
        MFPlayer.GUI[_mfGUIName.DeployGUI].gui.destroy()
        MFPlayer.GUI[_mfGUIName.DeployGUI] = nil
        return
    end

    -- If an Entity is clicked --
    if string.match(event.element.name, "DP.GUI.EntButton") then
        currentMF.slots[event.element.tags.slot] = {entity=event.element.tags.entity, way=event.element.tags.way}
        MFPlayer.GUI[_mfGUIName.SlotGUI].gui.destroy()
        MFPlayer.GUI[_mfGUIName.SlotGUI] = nil
        return
    end

end