-- Create the TP GUI --
function GUI.createTPGui(player)

    -- Get the MFPlayer --
	local MFPlayer = getMFPlayer(player.name)

    -- Create the GUI --
    local GUITable = GAPI.createBaseWindows(_mfGUIName.TPGUI, {"gui-description.MFTPGUITitle"}, MFPlayer, true, true, false, "vertical", "horizontal")
    local mainFrame = GUITable.vars.MainFrame

    -- Add the Close Button --
    GAPI.addCloseButton(GUITable)

    -- Create the Frames --
    local infoFrame = GAPI.addFrame(GUITable, "InfoFrame", mainFrame, "vertical", true)
    local locFrame = GAPI.addFrame(GUITable, "LocFrame", mainFrame, "vertical", true)
    local addLocFrame = GAPI.addFrame(GUITable, "AddLocFrame", mainFrame, "vertical", true)

    infoFrame.style = "MFFrame1"
	locFrame.style = "MFFrame1"
	addLocFrame.style = "MFFrame1"
    
    infoFrame.style.left_padding = 7
    infoFrame.style.right_padding = 7
    infoFrame.style.right_margin = 3
	locFrame.style.left_padding = 7
    locFrame.style.right_padding = 7
    locFrame.style.right_margin = 3
	addLocFrame.style.left_padding = 7
    addLocFrame.style.right_padding = 7
    
    infoFrame.style.vertically_stretchable = true
	locFrame.style.vertically_stretchable = true
    addLocFrame.style.vertically_stretchable = true

    -- Add the Location Title --
    GAPI.addSubtitle(GUITable, "", locFrame, {"gui-description.JumpLocation"})
    GAPI.addSubtitle(GUITable, "", addLocFrame, {"gui-description.AddLocation"})

    -- Create the Location ScroolPane --
    local locPane = GAPI.addScrollPane(GUITable, "LocScrollPane", locFrame, 700, true, "MF_TPGUI_scroll_pan")
    locPane.style.minimal_height = 350
    locPane.style.minimal_width = 250
    locPane.style.bottom_margin = 3

    -- Update the GUI --
    GUI.updateMFTPGUI(GUITable, true)

    -- Return the Table --
    return GUITable

end

-- Update the TP GUI --
function GUI.updateMFTPGUI(GUITable, justCreated)
    GUI.updateInfo(GUITable)
    GUI.updateLocation(GUITable)
    if justCreated == true then GUI.updateAddLocation(GUITable) end
end

-- Update the Information --
function GUI.updateInfo(GUITable)

    -- Get all Variables --
    local infoFrame = GUITable.vars.InfoFrame
    local MF = getCurrentMF(GUITable.MFPlayer)

    -- Clear the Flow --
    infoFrame.clear()

    -- Add the Title --
    GAPI.addSubtitle(GUITable, "", infoFrame, {"gui-description.Information"})

    -- Check the Mobile Factory --
    if MF.ent == nil or MF.ent.valid == false then
        GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.MFNotFound"}, _mfRed)
        return
    end

    -- Add the Jump Drive Subtitle --
    GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.JumpDriveSubTitle"}, nil, nil, false, nil, _mfLabelType.yellowTitle)

    -- Add the Jump Drive Statue --
    GAPI.addDualLabel(GUITable, infoFrame, {"",{"gui-description.JumpDriveStatue"}, ":"}, MF.jumpDriveObj.charge .. "/" .. MF.jumpDriveObj.maxCharge .. " (+" .. MF.jumpDriveObj.chargeRate .. "/s)", _mfOrange, _mfYellow)

    -- Add the Jump Charger Count --
    GAPI.addDualLabel(GUITable, infoFrame, {"",{"gui-description.JumpChargerCount"}, ":"}, table_size(MF.jumpDriveObj.jumpChargerTable), _mfOrange, _mfYellow)

    -- Add the Jump Drive Consumption --
    GAPI.addDualLabel(GUITable, infoFrame, {"",{"gui-description.JumpDriveConsumption"}, ":"}, Util.toRNumber(MF.jumpDriveObj.chargeRate * _mfJumpEnergyDrain) .. "W" , _mfOrange, _mfYellow)

    -- Add the Mobile Factory Subtitle --
    GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.MobileFactorySubtitle"}, nil, nil, false, nil, _mfLabelType.yellowTitle)

    -- Add the World Position --
    GAPI.addDualLabel(GUITable, infoFrame, {"",{"gui-description.World"}, ":"}, MF.ent.surface.name, _mfOrange, _mfYellow)

    -- Add the Position X --
    GAPI.addDualLabel(GUITable, infoFrame, {"",{"gui-description.PosX"}, ":"}, MF.ent.position.x, _mfOrange, _mfYellow)

    -- Add the Position Y --
    GAPI.addDualLabel(GUITable, infoFrame, {"",{"gui-description.PosY"}, ":"}, MF.ent.position.y, _mfOrange, _mfYellow)

end

-- Update the Location --
function GUI.updateLocation(GUITable)

    -- Get all Variables --
    local locPane = GUITable.vars.LocScrollPane
    local MF = getCurrentMF(GUITable.MFPlayer)

    -- Clear the ScrollPane --
    locPane.clear()

    -- Look for all Locations --
    if MF.jumpDriveObj.locationTable == nil then MF.jumpDriveObj.locationTable = {} end
    for name, loc in pairs(MF.jumpDriveObj.locationTable) do

        -- Check the Surface --
        if loc.surface == nil or game.surfaces[loc.surface.name] == nil then
            MF.jumpDriveObj.locationTable[name] = nil
            goto continue
        end

        -- Calculate the Distance --
        local distance = Util.distance(MF.ent.position, {loc.posX,loc.posY})
        distance = math.ceil(distance)
        local canTP = MF.jumpDriveObj:canTP(loc)

        -- Create the Frame --
        local frame = GAPI.addFrame(GUITable, "", locPane, "horizontal")

        -- Create the Flow --
        local flow = GAPI.addFlow(GUITable, "", frame, "horizontal")
        flow.style.vertical_align = "center"

        -- Add the TP Button --
        local icon = loc.filter ~= nil and ("recipe/" .. loc.filter) or "MFJDIcon"
        local button = GAPI.addButton(GUITable, "TP.GUI.Loc,", flow, icon, icon, {"gui-description.StartJump"}, 50, false, true, nil, nil, {loc=name})
        button.style = canTP == true and "shortcut_bar_button_green" or "MF_Fake_Button_Red"
        button.style.padding = 0
        button.style.margin = 0

        -- Create the Information Table --
        local infoTable = GAPI.addTable(GUITable, "", flow, 1)
        
        -- Add the Location Name --
        GAPI.addLabel(GUITable, "", infoTable, name, nil, "", false, nil, _mfLabelType.yellowTitle)

        -- Add the Position --
        GAPI.addDualLabel(GUITable, infoTable, {"", {"gui-description.Position"}, ":"}, loc.surface.name .. " (" .. math.ceil(loc.posX) .. " ; " .. math.ceil(loc.posY) .. ")", _mfOrange, _mfYellow)

        -- Add the Cost --
        local cost = {"",tostring(distance), " ", {"gui-description.JumpCharge"}}
        if MF.ent.surface ~= loc.surface then
            cost = {"",tostring(distance), " ", {"gui-description.JumpCharge"}, " [color=purple]+1000[/color]"}
        end
        GAPI.addDualLabel(GUITable, infoTable, {"", {"gui-description.JumpCost"}, ":"}, cost, _mfOrange, _mfYellow)

        ::continue::

    end

end

-- Update the Add Location --
function GUI.updateAddLocation(GUITable)

    -- Get all Variables --
    local locFrame = GUITable.vars.AddLocFrame
    local MF = getCurrentMF(GUITable.MFPlayer)

    -- Check the Mobile Factory --
    if MF.ent == nil or MF.ent.valid == false then
        -- Add the Mobile Factory no found Label --
        GAPI.addLabel(GUITable, "", locFrame, {"gui-description.MFNotFound"}, _mfRed)
        return
    end

    -- Add the Location Label --
    GAPI.addLabel(GUITable, "", locFrame, {"gui-description.AddLocationL"}, _mfOrange)

    -- Create the Add Location Flow --
    local addLocFlow = GAPI.addFlow(GUITable, "", locFrame, "horizontal")

    -- Create the Add Location Text Field --
    local textField = GAPI.addTextField(GUITable, "AddLocName", addLocFlow, "", {"gui-description.AddLocationTextTT"}, true)
    textField.style.width = 125

    -- Create the Add Location Filter --
    GAPI.addFilter(GUITable, "AddLocFilter", addLocFlow, {"gui-description.AddLocationFilterTT"}, true, "recipe", 28)

    -- Create the Add Location Button --
    GAPI.addButton(GUITable, "TP.GUI.AddLoc", addLocFlow, "PlusIcon", "PlusIcon", {"gui-description.AddLocationButtonTT"}, 28)

    -- Add Line --
    GAPI.addLine(GUITable, "", locFrame, "horizontal")

    -- Add all Information --
    GAPI.addLabel(GUITable, "", locFrame, {"gui-description.Info1"}, _mfWhite)
    GAPI.addLabel(GUITable, "", locFrame, {"gui-description.Info2"}, _mfWhite)
    GAPI.addLabel(GUITable, "", locFrame, {"gui-description.Info3"}, _mfWhite)
    GAPI.addLabel(GUITable, "", locFrame, {"gui-description.Info4"}, _mfWhite)

end

-- If the Player interacted with the GUI --
function GUI.TPMFGUIInteraction(event, MFPlayer, currentMF)

    -- Location Added --
    if string.match(event.element.name, "TP.GUI.AddLoc") then
        local GUITable = MFPlayer.GUI["MFTPGUI"]
        if GUITable.vars.AddLocName ~= nil and GUITable.vars.AddLocName ~= "" then
            local jumpDrive = currentMF.jumpDriveObj
            jumpDrive:addLocation(GUITable.vars.AddLocName.text, GUITable.vars.AddLocFilter.elem_value)
        end
        return
    end

    -- Start the Jump --
    if string.match(event.element.name, "TP.GUI.Loc") then
        local jumpDrive = currentMF.jumpDriveObj
        local location = event.element.tags.loc
        -- Start the Jump --
        if event.button == defines.mouse_button_type.left then
            jumpDrive:jump(location)
        end
        -- Remove a Location --
        if event.button == defines.mouse_button_type.right then
            jumpDrive:removeLocation(location)
        end
        return
    end

end