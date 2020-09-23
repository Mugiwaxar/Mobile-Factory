-- Create the TP GUI --
function GUI.createTPGui(player)

	-- Create the GUI --
	local GUIObj = GUI.createGUI("MFTPGUI", getMFPlayer(player.name), "vertical", true, 0, 0)
    local TPGUI = GUIObj.gui
    
    -- Create the top Bar --
    GUI.createTopBar(GUIObj, 200)

    -- Create the Main Frame --
    local mainFrame = GUIObj:addFrame("MainFrame", TPGUI, "horizontal")

    
    -- Create the Information Title and Flow --
    local infoTitle = GUIObj:addTitledFrame("InformationTitle", mainFrame, "vertical", {"gui-description.Information"}, _mfOrange)
    GUIObj:addFlow("InformationFlow", infoTitle, "vertical", true)

    -- Create the Location Title and Scroll Pane --
    local localtionTitle = GUIObj:addTitledFrame("LocationTitle", mainFrame, "vertical", {"gui-description.JumpLocation"}, _mfOrange)
    local locPane = GUIObj:addScrollPane("LocationPane", localtionTitle, 500, true, "MF_JD_scroll_pan")
    locPane.style.minimal_height = 500
    locPane.style.minimal_width = 250
    locPane.style.vertically_stretchable = true

    -- Create the Add Location Title and Flow --
    local addLocaltionTitle = GUIObj:addTitledFrame("AddLocationTitle", mainFrame, "vertical", {"gui-description.AddLocation"}, _mfOrange)
    GUIObj:addFlow("AddLocationFlow", addLocaltionTitle, "vertical", true)
    GUIObj.addLocationFlowCreated = false

	-- Center the GUI --
    TPGUI.force_auto_center()
    
    -- Update the GUI --
    GUI.updateMFTPGUI(GUIObj)

	-- Update the GUI and return the GUI Object --
	return GUIObj

end

-- Update the TP GUI --
function GUI.updateMFTPGUI(GUIObj)
    GUI.updateInfo(GUIObj)
    GUI.updateLocation(GUIObj)
    GUI.updateAddLocation(GUIObj)
end

-- Update the Information --
function GUI.updateInfo(GUIObj)

    -- Get all Variables --
    local infoFlow = GUIObj.InformationFlow
    local MF = GUIObj.MF

    -- Clear the Flow --
    infoFlow.clear()

    -- Check the Mobile Factory --
    if MF.ent == nil or MF.ent.valid == false then
        GUIObj:addLabel("", infoFlow, {"gui-description.MFNotFound"}, _mfRed)
        return
    end

    -- Add Line --
    GUIObj:addLine("", infoFlow, "horizontal")

    -- Add the Jump Drive Statue --
    GUIObj:addDualLabel(infoFlow, {"",{"gui-description.JumpDriveStatue"}, ":"}, MF.jumpDriveObj.charge .. "/" .. MF.jumpDriveObj.maxCharge .. " (+" .. MF.jumpDriveObj.chargeRate .. "/s)", _mfOrange, _mfGreen)

    -- Add the Jump Charger Count --
    GUIObj:addDualLabel(infoFlow, {"",{"gui-description.JumpChargerCount"}, ":"}, table_size(MF.jumpDriveObj.jumpChargerTable), _mfOrange, _mfGreen)

    -- Add the Jump Drive Consumption --
    GUIObj:addDualLabel(infoFlow, {"",{"gui-description.JumpDriveConsumption"}, ":"}, Util.toRNumber(MF.jumpDriveObj.chargeRate * _mfJumpEnergyDrain) .. "W" , _mfOrange, _mfGreen)

     -- Add Line --
     GUIObj:addLine("", infoFlow, "horizontal")

    -- Add the World Position --
    GUIObj:addDualLabel(infoFlow, {"",{"gui-description.World"}, ":"}, MF.ent.surface.name, _mfOrange, _mfGreen)

    -- Add the Position X --
    GUIObj:addDualLabel(infoFlow, {"",{"gui-description.PosX"}, ":"}, MF.ent.position.x, _mfOrange, _mfGreen)

    -- Add the Position Y --
    GUIObj:addDualLabel(infoFlow, {"",{"gui-description.PosY"}, ":"}, MF.ent.position.y, _mfOrange, _mfGreen)

     -- Add Line --
     GUIObj:addLine("", infoFlow, "horizontal")

end

-- Update the Location --
function GUI.updateLocation(GUIObj)

    -- Get all Variables --
    local locPane = GUIObj.LocationPane
    local MF = GUIObj.MF

    -- Clear the Pane --
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
        local frame = GUIObj:addFrame("", locPane, "vertical")

        -- Create the Name Frame and Flow --
        local nameFrame = GUIObj:addFrame("", frame, "horizontal")
        local nameFlow = GUIObj:addFlow("", nameFrame, "horizontal")
        nameFlow.style.horizontal_align = "center"

        -- Add the Location Name --
        GUIObj:addLabel("", nameFlow, name, _mfOrange, "", false, "LabelFont2")

        -- Create the Information Flow --
        local infoFlow = GUIObj:addFlow("", frame, "horizontal")

        -- Add the TP Button --
        local icon = (loc.filter ~= nil and game.recipe_prototypes[loc.filter] ~= nil) and ("recipe/" .. loc.filter) or "MFJDIcon"
        local button = GUIObj:addButton("TPGUILoc," .. name, infoFlow, icon, icon, {"gui-description.StartJump"}, 40)
        button.style = canTP == true and "shortcut_bar_button_green" or "MF_Fake_Button_Red"
        button.style.padding = 0
	    button.style.margin = 0

        -- Create the Position Flow --
        local posFlow = GUIObj:addFlow("", infoFlow, "vertical")

        -- Add the Position --
        GUIObj:addDualLabel(posFlow, {"", {"gui-description.Position"}, ":"}, loc.surface.name .. " (" .. math.ceil(loc.posX) .. " ; " .. math.ceil(loc.posY) .. ")", _mfOrange, _mfGreen)

        -- Add the Cost --
        local cost = {"",tostring(distance), " ", {"gui-description.JumpCharge"}}
        if MF.ent.surface ~= loc.surface then
            cost = {"",tostring(distance), " ", {"gui-description.JumpCharge"}, " [color=purple]+1000[/color]"}
        end
        GUIObj:addDualLabel(posFlow, {"", {"gui-description.JumpCost"}, ":"}, cost, _mfOrange, _mfGreen)

        ::continue::

    end

end

-- Update the Add Location --
function GUI.updateAddLocation(GUIObj)

    -- Get all Variables --
    local locFlow = GUIObj.AddLocationFlow
    local MF = GUIObj.MF

    -- Check the Mobile Factory --
    if MF.ent == nil or MF.ent.valid == false then
        -- Clear the Flow --
        locFlow.clear()
        -- Remove the content --
        GUIObj:addLabel("", locFlow, {"gui-description.MFNotFound"}, _mfRed)
        GUIObj.addLocationFlowCreated = false
    elseif GUIObj.addLocationFlowCreated == false then

        -- Clear the Flow --
        locFlow.clear()
        GUIObj.addLocationFlowCreated = true

        -- Add the Location Label --
        GUIObj:addLabel("", locFlow, {"gui-description.AddLocationL"}, _mfOrange)

        -- Create the Add Location Flow --
        local addLocFlow = GUIObj:addFlow("", locFlow, "horizontal")

        -- Create the Add Location Text Field --
        local textField = GUIObj:addTextField("AddLocName", addLocFlow, "", {"gui-description.AddLocationTextTT"}, true)
        textField.style.width = 125

        -- Create the Add Location Filter --
        local filter = GUIObj:addFilter("AddLocFilter", addLocFlow, {"gui-description.AddLocationFilterTT"}, true, "recipe", 28)

        -- Create the Add Location Button --
        GUIObj:addButton("TPGUIAddLoc,", addLocFlow, "PlusIcon", "PlusIcon", {"gui-description.AddLocationButtonTT"}, 28)

        -- Add Line --
        GUIObj:addLine("", locFlow, "horizontal")

        -- Add all Information --
        GUIObj:addLabel("", locFlow, {"gui-description.Info1"}, _mfGreen)
        GUIObj:addLabel("", locFlow, {"gui-description.Info2"}, _mfGreen)
        GUIObj:addLabel("", locFlow, {"gui-description.Info3"}, _mfGreen)
        GUIObj:addLabel("", locFlow, {"gui-description.Info4"}, _mfGreen)


    end
end