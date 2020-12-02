---------------------------------- The GUI API to create GUI easily ----------------------------------

-- Create a Window --
function GAPI.createBaseWindows(name, title, MFPlayer, showTitle, showMainFrame, isScroolPane, windowsDirection, mainFrameDirection)
    if MFPlayer == nil then return end
    if MFPlayer.ent.gui.screen[name] ~= nil and MFPlayer.ent.gui.screen[name].valid == true then MFPlayer.ent.gui.screen[name].destroy() end
    if MFPlayer.ent.gui.screen[name] ~= nil and MFPlayer.ent.gui.screen[name].valid == false then MFPlayer.ent.gui.screen[name] = nil end
    local table = {title=title, MFPlayer=MFPlayer, vars={}}
    table.gui = MFPlayer.ent.gui.screen.add{type="frame", name=name, direction=windowsDirection or "vertical"}
    table.gui.style.padding = 5
    table.gui.style.top_padding = 0
    table.gui.style.margin = 0
    if showTitle ~= false then GAPI.createTitle(table) end
    if showMainFrame ~= false then
        local mainFrame = nil
        if isScroolPane ~= true then
            mainFrame = GAPI.addFrame(table, "MainFrame", table.gui, mainFrameDirection or "vertical", true)
            mainFrame.style = "invisible_frame"
        else
            mainFrame = GAPI.addScrollPane(table, "MainFrame", table.gui, nil, true)
            -- mainFrame.style = "tab_scroll_pane_with_extra_padding"
        end
        mainFrame.style.vertically_stretchable = true
    end
    GAPI.setGeometry(table.gui, nil, nil, _mfDefaultGuiHeight, _mfDefaultGuiWidth)
    GAPI.centerWindow(table.gui)
    return table
end

-- Set the Element Geometry --
function GAPI.setGeometry(Gui, posX, posY, minHeight, minWidth, maxHeight, maxWidth, height, width)
    if Gui == nil then return end
    if posX ~= nil then Gui.location = {posX, Gui.location.y} end
    if posY ~= nil then Gui.location = {Gui.location.x, posY} end
    if minHeight ~= nil then Gui.style.minimal_height = minHeight end
    if minWidth ~= nil then Gui.style.minimal_width = minWidth end
    if maxHeight ~= nil then Gui.style.minimal_height = maxHeight end
    if maxWidth ~= nil then Gui.style.maximal_height = maxWidth end
    if height ~= nil then Gui.style.natural_height = height end
    if width ~= nil then Gui.style.natural_width = width end
end

-- Set the Element Location --
function GAPI.setLocation(Gui, posX, posY)
    if Gui == nil then return end
    if posX ~= nil then Gui.location = {posX, Gui.location.y} end
    if posY ~= nil then Gui.location = {Gui.location.x, posY} end
end

-- Set the Element Normal Size --
function GAPI.setSize(Gui, height, width)
    if height ~= nil then Gui.style.natural_height = height end
    if width ~= nil then Gui.style.natural_width = width end
end

-- Set the Element Minimum Size --
function GAPI.setMinSize(Gui, minHeight, minWidth)
    if Gui == nil then return end
    if minHeight ~= nil then Gui.style.minimal_height = minHeight end
    if minWidth ~= nil then Gui.style.minimal_width = minWidth end
end

-- Set the Element Maximum Size --
function GAPI.setMaxSize(Gui, maxHeight, maxWidth)
    if Gui == nil then return end
    if maxHeight ~= nil then Gui.style.minimal_height = maxHeight end
    if maxWidth ~= nil then Gui.style.maximal_height = maxWidth end
end

-- Set all Sizes of the Element --
function GAPI.setAllSize(Gui, height, width)
    GAPI.setSize(Gui, height, width)
    GAPI.setMinSize(Gui, height, width)
    GAPI.setMaxSize(Gui, height, width)
end

-- Center the Window --
function GAPI.centerWindow(Gui)
    Gui.force_auto_center()
end

-- Add the Title to the Window --
function GAPI.createTitle(table)
    -- Create the Menu Bar --
    local topBarFlow = GAPI.addFlow(table, "topBarFlow", table.gui, "horizontal", true)
    topBarFlow.style.vertical_align = "center"
    topBarFlow.style.padding = 0
    topBarFlow.style.margin = 0
	-- Add the Title Label --
	local barTitle = table.title or {"gui-description." .. table.gui.name .. "Title"}
	GAPI.addLabel(table, "", topBarFlow, barTitle, _mfOrange, nil, false, "TitleFont")
	-- Add the Draggable Area --
    local dragArea = GAPI.addEmptyWidget(table, "", topBarFlow, table.gui, _mfGUIDragAreaSize)
    dragArea.style.left_margin = 8
    dragArea.style.right_margin = 8
    dragArea.style.minimal_width = 30
end

-- Add a close Button --
function GAPI.addCloseButton(table)
    local button = GAPI.addButton(table, table.gui.name.. "CloseButton", table.vars.topBarFlow, "CloseIcon", "CloseIcon", {"gui-description.closeButton"}, _mfGUICloseButtonSize)
    button.style = "frame_action_button"
end

-- Add a new Frame --
function GAPI.addFrame(table, name, gui, direction, save)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the frame --
	local frame = gui.add{type="frame", name=name, direction=direction}
	-- Set Style --
	frame.style.padding = 0
    frame.style.margin = 0
    frame.style.horizontally_stretchable = true
    -- Save the Frame inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = frame
    end
    return frame
end

-- Create a Title Label --
function GAPI.addTitledFrame(table, name, gui, direction, text, color, save)
    local titleFrame = GAPI.addFrame(table, nil, gui, "horizontal")
    titleFrame.style.horizontally_stretchable = true
    local titleFlow = GAPI.addFlow(table, nil, titleFrame, "horizontal")
    GAPI.addLabel(table, name .. "Label", titleFlow, text, color, "", save, "TitleFont")
    titleFlow.style.horizontal_align = "center"
    return titleFrame
end

-- Create a Subtitle --
function GAPI.addSubtitle(table, name, gui, text, save)
    local flow = GAPI.addFlow(table, name .. "Flow", gui, "vertical", save)
    flow.style.horizontal_align = "center"
    flow.style.vertically_stretchable = false
    GAPI.addLine(table, "", flow, "horizontal")
    local label = GAPI.addLabel(table, name .. "Label", flow, text, nil, nil, false, nil, _mfLabelType.yellowTitle)
    label.style.left_margin = 10
    label.style.right_margin = 10
    GAPI.addLine(table, "", flow, "horizontal")
end

-- Add a new Flow --
function GAPI.addFlow(table, name, gui, direction, save)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Flow --
	local flow = gui.add{type="flow", name=name, direction=direction}
	-- Set Style --
	flow.style.padding = 0
    flow.style.margin = 0
    flow.style.horizontally_stretchable = true
    -- Save the Flow inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = flow
    end
    return flow
end

-- Add a new Scroll Pane --
function GAPI.addScrollPane(table, name, gui, size, save, style, policy)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Scrool Pane --
    local scrollPane = gui.add{type="scroll-pane", name=name, horizontal_scroll_policy="never", vertical_scroll_policy=policy or "always"}
    -- Set Style --
    if style ~= nil then scrollPane.style = style end
    scrollPane.style.padding = 0
    scrollPane.style.margin = 0
    scrollPane.style.maximal_height = size
    scrollPane.style.horizontally_stretchable = true
    if table ~= nil and save == true then
        table.vars[name] = scrollPane
    end
    return scrollPane
end

-- Add a Tabbed Pane --
function GAPI.addTabbedPane(table, name, gui, text, tooltip, save, selectedIndex)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Tabbed Pane --
    local tabbedPane = gui.add{type="tabbed-pane", name=name, caption=text, tooltip=tooltip}
    -- Set the Style --
    tabbedPane.style.margin = 0
    tabbedPane.style.padding = 0
    -- Set the Selected Tab --
    tabbedPane.selected_tab_index = selectedIndex or 1
    -- Save the Tabbed Pane inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = tabbedPane
    end
    return tabbedPane
end

-- Add a Tab --
function GAPI.addTab(table, name, gui, text, tooltip, save)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Tabbed Pane --
    local tab = gui.add{type="tab", name=name .. "tab", caption=text, tooltip=tooltip}
    -- Create the Flow --
    local flow = gui.add{type="flow", name=name, direction="vertical"}
    -- Set the Style --
    tab.style.margin = 0
    tab.style.padding = 0
    flow.style.margin = 0
    flow.style.padding = 0
    flow.style.horizontally_stretchable = true
    flow.style.vertically_stretchable  = true
    -- Save the Tab inside the Tabed Pane --
    gui.add_tab(tab, flow)
    -- Save the Tabbed Pane inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = flow
    end
    return flow
end

-- Add a new Table --
function GAPI.addTable(table, name, gui, column, save)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Table --
    local tableGUI = gui.add{type="table", name=name, column_count=column}
    -- Set Style --
	tableGUI.style.padding = 0
    tableGUI.style.margin = 0
    tableGUI.style.cell_padding = 0
    tableGUI.style.horizontal_spacing  = 0
    tableGUI.style.horizontal_spacing  = 0
    tableGUI.style.vertical_spacing  = 0
    -- Save the Flow inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = tableGUI
    end
    return tableGUI
end

-- Add a new Draggable Space --
function GAPI.addEmptyWidget(table, name, gui, parent, sizeX, sizeY, save)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Empty Widget --
    local emptyWidget = gui.add{type="empty-widget", name=name, style='draggable_space'}
    -- Set Style --
    emptyWidget.drag_target = parent
    if sizeX ~= nil then emptyWidget.style.height = sizeX end
    if sizeY ~= nil then emptyWidget.style.width = sizeY end
    emptyWidget.style.padding = 0
    emptyWidget.style.margin = 0
    emptyWidget.style.horizontally_stretchable = true
    -- Save the Empty Widget inside the elements Table --
    if table ~= nil and save == true then
        table.elements[name] = emptyWidget
    end
    return emptyWidget
end

-- Add a new Label --
function GAPI.addLabel(table, name, gui, text, color, tooltip, save, font, style)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Label --
    local label = gui.add{type="label", name=name, caption=text, tooltip=tooltip}
    if style ~= nil then
        -- Set the Style --
        label.style = style
    else
        -- Set the Text font and Color --
        label.style.font = font or "LabelFont"
        label.style.font_color = color or _mfBlue
    end
    -- Save the Label inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = label
    end
    return label
end

-- Add a dual Label --
function GAPI.addDualLabel(table, gui, text1, text2, color1, color2, font, tooltip1, tooltip2, name, save)
    -- Create the Frame --
    local flow = GAPI.addFlow(table, "", gui, "horizontal")
    GAPI.addLabel(table, "Label1", flow, text1, color1, tooltip1, false, font)
    GAPI.addLabel(table, "Label2", flow, text2, color2, tooltip2, false, font)
    if table ~= nil and save == true then
        table.vars[name] = flow
    end
    return flow
end

-- Add a new Text Field --
function GAPI.addTextField(table, name, gui, text, tooltip, save, numeric, allowDecimal, allowNegative, isPassword)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    local textField = gui.add{type="textfield", name=name, text=text, tooltip=tooltip, numeric=numeric or false, allow_decimal=allowDecimal or false, allow_negative=allowNegative or false, is_password=isPassword or false}
    if table ~= nil and save == true then
        table.vars[name] = textField
    end
    return textField
end

-- Add a new Button --
function GAPI.addButton(table, name, gui, sprite, hovSprite, tooltip, size, save, visible, count, style)
    if visible == false then return end
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    -- Create the Button --
    local button = gui.add{
		type="sprite-button",
		name=name,
		sprite=sprite,
		hovered_sprite=hovSprite,
		resize_to_sprite=false,
        tooltip=tooltip,
        number=count
    }
    -- Set the Style --
    if style ~= nil then button.style = style end
        button.style.minimal_width = size
        button.style.maximal_width = size
        button.style.minimal_height = size
        button.style.maximal_height = size
        button.style.padding = 0
        button.style.margin = 0
    -- Save the Button inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = button
    end
    return button
end

-- Add a new Simple Button --
function GAPI.addSimpleButton(table, name, gui, text, tooltip, save)
    -- Check if this Element doesn't exist --
    if name ~= nil and name ~= "" and gui[name] ~= nil then gui[name].destroy() end
    local button = gui.add{type="button", name=name, caption=text, tooltip=tooltip}

    if table ~= nil and save == true then
        table.vars[name] = button
    end
    return button
end

-- Add a CheckBox --
function GAPI.addCheckBox(table, name, gui, text, tooltip, state, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the CheckBox --
    local checkBox = gui.add{type="checkbox", name=name, caption=text, tooltip=tooltip, state=state or false}
    -- Save the Check Box inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = checkBox
    end
    return checkBox
end

-- Add a Switch --
function GAPI.addSwitch(table, name, gui, text1, text2, tooltip1, tooltip2, state, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Switch --
    local switch = gui.add{type="switch", name=name, switch_state=state or "left", left_label_caption=text1, right_label_caption=text2, left_label_tooltip=tooltip1, right_label_tooltip=tooltip2}
    -- Save the Switch inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = switch
    end
    return switch
end

-- Add a new Line --
function GAPI.addLine(table, name, gui, direction, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Line --
    local line = gui.add{type="line", name=name, direction=direction}
    -- Save the Line inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = line
    end
    return line
end

-- Add a Drop Down --
function GAPI.addDropDown(table, name, gui, items, selected, save, tooltip)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    local dropDown = gui.add{type="drop-down", name=name, items=items, selected_index=selected, tooltip=tooltip}
    dropDown.style.maximal_width = 200
    -- Save the Drop Down inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = dropDown
    end
    return dropDown
end

-- Add a new Progress Bar --
function GAPI.addProgressBar(table, name, gui, text, tooltip, save, color, value, size)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Progress Bar --
	local progressBar = gui.add{type="progressbar", name=name, caption=text, tooltip=tooltip}
    -- Set the Progress Bar Color --
    if color ~= nil then progressBar.style.color = color end
    -- Set the Progress Bar Size --
    if size ~= nil then progressBar.style.maximal_width = size end
    progressBar.style.horizontally_stretchable = true
    -- Set the Progress Bar value --
    if value ~= nil then progressBar.value = value end
    -- Save the Progress Bar inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = progressBar
    end
    return progressBar
end

-- Add a new Filter --
function GAPI.addFilter(table, name, gui, tooltip, save, elemType, size)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Filter --
    local filter = gui.add{type="choose-elem-button", name=name, tooltip=tooltip, elem_type=elemType}
    filter.style.height = size
    filter.style.width = size
    -- Save the Filter inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = filter
    end
    return filter
end

-- Add a new Sprite --
function GAPI.addSprite(table, name, gui, path, tooltip, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Sprite --
    local sprite = gui.add{type="sprite", name=name, sprite=path, tooltip=tooltip}
    sprite.style.padding = 0
    sprite.style.margin = 0
    -- Save the Spite inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = sprite
    end
    return sprite
end

-- Create Item Frame --
function GAPI.addItemFrame(table, name, item, amount, gui, save)
    -- Create the Frame --
    local frame = GAPI.addFrame(name, gui, "horizontal")
    -- Create the Sprite --
    GAPI.addSprite(item, frame, "item/" .. item, game.item_prototypes[item].localised_name)
    -- Create the amount Label --
    GAPI.addLabel("", frame, Util.toRNumber(amount))
    -- Save the Spite inside the elements Table --
    if table ~= nil and save == true then
        table.vars[name] = frame
    end
    return frame
end