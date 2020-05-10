-- GUI OBJECT --

-- Create the GUI base object --
GO = {
    name = "",
    gui = nil,
    MF = nil,
    MFPlayer = "",
    elements = nil
}

-- Constructor --
function GO:new(name, MFPlayer, direction)
    local t = {}
    local mt = {}
    setmetatable(t, mt)
    mt.__index = indexFunction
    mt.__newindex = newIndexFunction
    t.name = name
    t.MF = MFPlayer.MF
    t.MFPlayer = MFPlayer
    t.elements = {}
    t:createGUI(MFPlayer.ent.gui.screen, name, direction)
    MFPlayer.GUI[t.name] = t
    return t
end

-- Index Function --
function indexFunction(self, key)
    if GO[key] ~= nil then return GO[key] end
    if self.gui[key] ~= nil then return self.gui[key] end
    if self.elements[key] ~= nil then return self.elements[key] end
end

-- New Index Function --
function newIndexFunction(self, key, value)
    if rawget(self, "gui") ~= nil and self.gui[key] ~= nil then
        rawget(self, "gui")[key] = value
        return
    end
    rawset(self, key, value)
end

-- Reconstructor --
function GO:rebuild(object)
    if object == nil then return end
    local mt = {}
    setmetatable(object, mt)
    mt.__index = indexFunction
    mt.__newindex = newIndexFunction
end

-- Create the GUI --
function GO:createGUI(gui, name, direction)
    if gui[name] ~= nil and gui[name].valid == true then gui[name].destroy() end
    self.gui = gui.add{type="frame", name=name, direction=direction}
    return self
end

-- Is valid --
function GO:valid()
    if self.gui == nil or self.gui.valid == false then return false end
    return true
end

-- Update --
function GO:update()
    if GUI["update" .. self.name] == nil then return end
    GUI["update" .. self.name](self)
end

-- Add a new Frame --
function GO:addFrame(name, gui, direction, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the frame --
	local frame = gui.add{type="frame", name=name, direction=direction}
	-- Set Style --
	frame.style.padding = 0
    frame.style.margin = 0
    frame.style.horizontally_stretchable = true
    -- Save the Frame inside the elements Table --
    if save == true then
        self.elements[name] = frame
    end
    return frame
end

-- Create a Title Label --
function GO:addTitledFrame(name, gui, direction, text, color, save)
    local frame = self:addFrame(name, gui, direction, save)
    frame.style.vertically_stretchable = true
    frame.style.horizontally_stretchable = true
    local titleFrame = self:addFrame("", frame, "horizontal")
    local titleFlow = self:addFlow("", titleFrame, "horizontal")
    local label = self:addLabel("", titleFlow, text, color, "", false, "TitleFont")
    titleFlow.style.horizontal_align = "center"
    return frame
end

-- Add a new Flow --
function GO:addFlow(name, gui, direction, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Flow --
	local flow = gui.add{type="flow", name=name, direction=direction}
	-- Set Style --
	flow.style.padding = 0
    flow.style.margin = 0
    flow.style.horizontally_stretchable = true
    -- Save the Flow inside the elements Table --
    if save == true then
        self.elements[name] = flow
    end
    return flow
end

-- Add a Tabbed Pane --
function GO:addTabbedPane(name, gui, text, tooltip, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Tabbed Pane --
    local tabbedPane = gui.add{type="tabbed-pane", name=name, caption=text, tooltip=tooltip}
    -- Set the Style --
    tabbedPane.style.margin = 0
    tabbedPane.style.padding = 0
    -- Save the Tabbed Pane inside the elements Table --
    if save == true then
        self.elements[name] = tabbedPane
    end
    return tabbedPane
end

-- Add a Tab --
function GO:addTab(name, gui, text, tooltip, save, selected)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Tabbed Pane --
    local tab = gui.add{type="tab", name=name .. "tab", caption=text, tooltip=tooltip}
    -- Create the Flow --
    local frame = gui.add{type="frame", name=name, direction="vertical"}
    -- Set the Style --
    tab.style.margin = 0
    tab.style.padding = 0
    frame.style.margin = 0
    frame.style.padding = 0
    frame.style.horizontally_stretchable = true
    frame.style.vertically_stretchable  = true
    -- Save the Tab inside the Tabed Pane --
    gui.add_tab(tab, frame)
    -- Select the Tab --
    if selected == true then gui.selected_tab_index = tab.index end
    -- Save the Tabbed Pane inside the elements Table --
    if save == true then
        self.elements[name] = frame
    end
    return frame
end

-- Add a new Table --
function GO:addTable(name, gui, column)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Table --
    local table = gui.add{type="table", name=name, column_count=column}
    -- Set Style --
	table.style.padding = 0
    table.style.margin = 0
    table.style.cell_padding = 0
    table.style.horizontal_spacing  = 0
    table.style.horizontal_spacing  = 0
    table.style.vertical_spacing  = 0
    -- Save the Flow inside the elements Table --
    if table == true then
        self.elements[name] = table
    end
    return table
end

-- Add a new Scrool Pane --
function GO:addScrollPane(name, gui, size, save, style)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Scrool Pane --
    local scrollPane = gui.add{type="scroll-pane", name=name, horizontal_scroll_policy="never", vertical_scroll_policy="always"}
    -- Set Style --
    if style ~= nil then scrollPane.style = style end
    scrollPane.style.padding = 0
    scrollPane.style.margin = 0
    scrollPane.style.maximal_height = size
    scrollPane.style.horizontally_stretchable = true
    if save == true then
        self.elements[name] = scrollPane
    end
    return scrollPane
end

-- Add a new Draggable Space --
function GO:addEmptyWidget(name, gui, parent, sizeX, sizeY, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
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
    if save == true then
        self.elements[name] = emptyWidget
    end
    return emptyWidget
end

-- Add a new Button --
function GO:addButton(name, gui, sprite, hovSprite, tooltip, size, save, visible, count)
    if visible == false then return end
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
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
    button.style.maximal_width = size
	button.style.maximal_height = size
	button.style.padding = 0
    button.style.margin = 0
    -- Save the Button inside the elements Table --
    if save == true then
        self.elements[name] = button
    end
    return button
end

-- Add a new Simple Button --
function GO:addSimpleButton(name, gui, text, tooltip, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    local button = gui.add{type="button", name=name, caption=text, tooltip=tooltip}

    if save == true then
        self.elements[name] = button
    end
    return button
end

-- Add a CheckBox --
function GO:addCheckBox(name, gui, text, tooltip, state, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the CheckBox --
    local checkBox = gui.add{type="checkbox", name=name, caption=text, tooltip=tooltip, state=state or false}
    -- Save the Check Box inside the elements Table --
    if save == true then
        self.elements[name] = checkBox
    end
    return checkBox
end

-- Add a Switch --
function GO:addSwitch(name, gui, text1, text2, tooltip1, tooltip2, state, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Switch --
    local switch = gui.add{type="switch", name=name, switch_state=state or "left", left_label_caption=text1, right_label_caption=text2, left_label_tooltip=tooltip1, right_label_tooltip=tooltip2}
    -- Save the Switch inside the elements Table --
     if save == true then
        self.elements[name] = switch
    end
    return switch
end

-- Add a new Line --
function GO:addLine(name, gui, direction, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Line --
    local line = gui.add{type="line", name=name, direction=direction}
    -- Save the Line inside the elements Table --
    if save == true then
        self.elements[name] = line
    end
    return line
end

-- Add a new Label --
function GO:addLabel(name, gui, text, color, tooltip, save, font)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Label --
    local label = gui.add{type="label", name=name, caption=text, tooltip=tooltip}
    -- Set the Text Color --
    label.style.font = font or "LabelFont"
    label.style.font_color = color or _mfBlue
    -- Save the Label inside the elements Table --
    if save == true then
        self.elements[name] = label
    end
    return label
end

-- Add a dual Label --
function GO:addDualLabel(gui, text1, text2, color1, color2, font, tooltip1, tooltip2, name, save)
    -- Create the Frame --
    local flow = self:addFlow("", gui, "horizontal")
    self:addLabel("Label1", flow, text1, color1, tooltip1, false, font)
    self:addLabel("Label2", flow, text2, color2, tooltip2, false, font)
    if save == true then
        self.elements[name] = flow
    end
    return flow
end

-- Add a new Text Field --
function GO:addTextField(name, gui, text, tooltip, save, numeric, allowDecimal, allowNegative, isPassword)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    local textField = gui.add{type="textfield", name=name, text=text, tooltip=tooltip, numeric=numeric or false, allow_decimal=allowDecimal or false, allow_negative=allowNegative or false, is_password=isPassword or false}
    if save == true then
        self.elements[name] = textField
    end
    return textField
end

-- Add a Drop Down --
function GO:addDropDown(name, gui, items, selected, save, tooltip)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    local dropDown = gui.add{type="drop-down", name=name, items=items, selected_index=selected, tooltip=tooltip}
    dropDown.style.maximal_width = 200
    -- Save the Drop Down inside the elements Table --
    if save == true then
        self.elements[name] = dropDown
    end
    return dropDown
end

-- Add a new Progress Bar --
function GO:addProgressBar(name, gui, text, tooltip, save, color, value, size)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Progress Bar --
	local progressBar = gui.add{type="progressbar", name=name, caption=text, tooltip=tooltip}
    -- Set the Progress Bar Color --
    if color ~= nil then progressBar.style.color = color end
    -- Set the Progress Bar Size --
    progressBar.style.maximal_width = size or 100
    -- Set the Progress Bar value --
    if value ~= nil then progressBar.value = value end
    -- Save the Progress Bar inside the elements Table --
    if save == true then
        self.elements[name] = progressBar
    end
    return progressBar
end

-- Add a new Filter --
function GO:addFilter(name, gui, tooltip, save, elemType, size)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Filter --
    local filter = gui.add{type="choose-elem-button", name=name, tooltip=tooltip, elem_type=elemType}
    filter.style.height = size
    filter.style.width = size
    -- Save the Filter inside the elements Table --
    if save == true then
        self.elements[name] = filter
    end
    return filter
end

-- Add a new Sprite --
function GO:addSprite(name, gui, path, tooltip, save)
    -- Check if this Element doesn't exist --
    if gui[name] ~= nil then gui[name].destroy() end
    -- Create the Sprite --
    local sprite = gui.add{type="sprite", name=name, sprite=path, tooltip=tooltip}
    sprite.style.padding = 0
    sprite.style.margin = 0
    -- Save the Spite inside the elements Table --
    if save == true then
        self.elements[name] = sprite
    end
    return sprite
end

-- Create Item Frame --
function GO:addItemFrame(item, amount, gui)
    -- Check the Item --
    if game.item_prototypes[item] == nil then return end
    -- Create the Frame --
    local frame = self:addFrame("", gui, "horizontal")
    -- Create the Sprite --
    self:addSprite(item, frame, "item/" .. item, game.item_prototypes[item].localised_name)
    -- Create the amount Label --
    self:addLabel("", frame, Util.toRNumber(amount))
    return frame
end

-- Create a Data Network Frame --
function GO:addDataNetworkFrame(gui, obj)
    if valid(obj.dataNetwork) == true then
		return obj.dataNetwork:getTooltipInfos(self, gui, obj)
	else
        self:addTitledFrame("", gui, "vertical", {"gui-description.DNNoLinked"}, _mfRed)
        return false
	end
end

-- Create a Data Network Inventory Frame --
function createDNInventoryFrame(GUIObj, gui, MFPlayer, buttonFirstName, inventory, columnsNumber, showDeepTank, showDeepStorage, showInventory, filter)

    -- Create the Table --
    local table = GUIObj:addTable("", gui, columnsNumber or 5)

    -- Look for all Deep Tank --
    if showDeepTank == true then
        for k, deepTank in pairs(global.deepTankTable) do
            -- Check if the Deep Tank Belong to the Player --
            if deepTank.player ~= MFPlayer.name then goto continue end
            -- Get Variables --
            local name = deepTank.inventoryFluid or deepTank.filter
            local count = deepTank.inventoryCount or 0
            -- Check the Item --
		    if name == nil or game.fluid_prototypes[name] == nil then goto continue end
            -- Check the Filter --
            if MFPlayer.varTable.tmpLocal ~= nil and Util.getLocFluidName(name)[1] ~= nil then
                local locName = MFPlayer.varTable.tmpLocal[Util.getLocFluidName(name)[1]]
                if filter ~= nil and filter ~= "" and locName ~= nil and MFPlayer.varTable.tmpLocal ~= nil and string.match(string.lower(locName), string.lower(filter)) == nil then goto continue end
            end
            -- Create the Button --
            local buttonName = buttonFirstName .. "BDT" .. "," .. deepTank.ent.unit_number
            local button = GUIObj:addButton(buttonName, table, "fluid/" .. name, "fluid/" .. name, {"", Util.getLocFluidName(name), ": ", Util.toRNumber(count)}, 37, true, true, count)
            button.style = "MF_Purple_Button_Purple"
            button.style.padding = 0
            button.style.margin = 0
            ::continue::
        end
    end

    -- Look for all Deep Storage --
    if showDeepStorage == true then
        for k, deepStorage in pairs(global.deepStorageTable) do
            -- Check if the Deep Storage Belong to the Player --
            if deepStorage.player ~= MFPlayer.name then goto continue end
            -- Get Variables --
            local name = deepStorage.inventoryItem or deepStorage.filter
            local count = deepStorage.inventoryCount or 0
            -- Check the Item --
            if name == nil or game.item_prototypes[name] == nil then goto continue end
            -- Check the Filter --
            if MFPlayer.varTable.tmpLocal ~= nil and Util.getLocItemName(name)[1] ~= nil then
                local locName = MFPlayer.varTable.tmpLocal[Util.getLocItemName(name)[1]]
                if filter ~= nil and filter ~= "" and locName ~= nil and MFPlayer.varTable.tmpLocal ~= nil and string.match(string.lower(locName), string.lower(filter)) == nil then goto continue end
            end
            -- Create the Button --
            local buttonName = buttonFirstName .. "BDSR" .. "," .. deepStorage.ent.unit_number
            local button = GUIObj:addButton(buttonName, table, "item/" .. name, "item/" .. name, {"", Util.getLocItemName(name), ": ", Util.toRNumber(count)}, 37, true, true, count)
            button.style = "shortcut_bar_button_green"
            button.style.padding = 0
            button.style.margin = 0
            ::continue::
        end
    end

    -- Look for all Items --
    if showInventory == true then
        for name, count in pairs(inventory.inventory) do
            -- Check the Item --
            if name == nil or count == nil or count == 0 or game.item_prototypes[name] == nil then goto continue  end
            -- Check the Filter --
            if MFPlayer.varTable.tmpLocal ~= nil and Util.getLocItemName(name)[1] ~= nil then
                local locName = MFPlayer.varTable.tmpLocal[Util.getLocItemName(name)[1]]
                if filter ~= nil and filter ~= "" and locName ~= nil and MFPlayer.varTable.tmpLocal ~= nil and string.match(string.lower(locName), string.lower(filter)) == nil then goto continue end
            end
            -- Create the Button --
            local buttonName = buttonFirstName .. "BINV" .. "," .. name .. "," .. count
            local button = GUIObj:addButton(buttonName, table, "item/" .. name, "item/" .. name, {"", Util.getLocItemName(name), ": ", Util.toRNumber(count)}, 37, true, true, count)
            button.style = "shortcut_bar_button_blue"
            button.style.padding = 0
            button.style.margin = 0
            ::continue::
        end
    end
end

function createPlayerInventoryFrame(GUIObj, gui, MFPlayer, columnsNumber, buttonFirstName, filter)

    -- Create the Table --
    local table = GUIObj:addTable("", gui, columnsNumber or 5)

    -- Look for all Items --
    for name, count in pairs(MFPlayer.ent.get_main_inventory().get_contents()) do
        -- Check the Item --
        if name == nil or count == nil or count == 0 or game.item_prototypes[name] == nil then goto continue  end
        -- Check the Filter --
        if MFPlayer.varTable.tmpLocal ~= nil and Util.getLocItemName(name)[1] ~= nil then
            local locName = MFPlayer.varTable.tmpLocal[Util.getLocItemName(name)[1]]
            if filter ~= nil and filter ~= "" and locName ~= nil and MFPlayer.varTable.tmpLocal ~= nil and string.match(string.lower(locName), string.lower(filter)) == nil then goto continue end
        end
        -- Create the Button --
        local buttonName = buttonFirstName .. "BPINV" .. "," .. name .. "," .. count
        local button = GUIObj:addButton(buttonName, table, "item/" .. name, "item/" .. name, {"", Util.getLocItemName(name), ": ", Util.toRNumber(count)}, 37, true, true, count)
        button.style = "shortcut_bar_button_blue"
        button.style.padding = 0
        button.style.margin = 0
        ::continue::
    end

end