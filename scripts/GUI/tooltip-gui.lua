-- Create the Tooltip GUI --
function GUI.createTooltipGUI(gui, player)
	-- Verify if the Tooltip GUI exist, else destroy it --
	if gui.screen.mfTooltipGUI ~= nil and gui.screen.mfTooltipGUI.valid == true then
		gui.screen.mfTooltipGUI.destroy()
	end
	
	-- Create the GUI --
	local mfTooltipGUI = gui.screen.add{type="frame", name="mfTooltipGUI", direction="vertical"}
	
	-- Calcule the position --
	local resolutionWidth = player.display_resolution.width  / player.display_scale
	local resolutionHeight = player.display_resolution.height  / player.display_scale
	local posX = resolutionWidth / 100 * 80
	local posY = resolutionHeight / 100 * 25
	local width = 157
	local height = 300
	
	-- Set the GUI position end style --
	mfTooltipGUI.caption = {"gui-description.tooltipGUI"}
	mfTooltipGUI.location = {posX, posY}
	mfTooltipGUI.style.minimal_width = width
	mfTooltipGUI.style.maximal_height = height
	-- mfTooltipGUI.style.height = height
	mfTooltipGUI.style.padding = 0
	mfTooltipGUI.style.margin = 0
	mfTooltipGUI.visible = false
	
	-- Create the Menu Bar --
	local mfTTGUIMenuBar = mfTooltipGUI.add{type="flow", name="mfTTGUIMenuBar", direction="horizontal"}
	-- Set Style --
	mfTTGUIMenuBar.style.minimal_width = width - 15
	mfTTGUIMenuBar.style.padding = 0
	mfTTGUIMenuBar.style.margin = 0
	mfTTGUIMenuBar.style.horizontal_align = "right"
	mfTTGUIMenuBar.style.vertical_align = "top"
	
	-- Add the lock Button to top Flow --
	mfTTGUIMenuBar.add{
		type="sprite-button",
		name="TTLockButton",
		sprite="LockIcon",
		resize_to_sprite=false,
		tooltip={"gui-description.TTLockButton"}
	}
	-- Set style --
	mfTTGUIMenuBar.TTLockButton.style.maximal_width = 15
	mfTTGUIMenuBar.TTLockButton.style.maximal_height = 15
	mfTTGUIMenuBar.TTLockButton.style.padding = 0
	
	-- Add the move Button to top Flow --
	mfTTGUIMenuBar.add{
		type="sprite-button",
		name="TTMoveButton",
		sprite="MoveIcon",
		hovered_sprite="MoveIconOv",
		resize_to_sprite=false,
		tooltip={"gui-description.moveGuiFrameButton"}
	}
	-- Set style --
	mfTTGUIMenuBar.TTMoveButton.style.maximal_width = 15
	mfTTGUIMenuBar.TTMoveButton.style.maximal_height = 15
	mfTTGUIMenuBar.TTMoveButton.style.padding = 0
	
	-- Add the close Button to top Flow --
	mfTTGUIMenuBar.add{
		type="sprite-button",
		name="TTCloseButton",
		sprite="CloseIcon",
		resize_to_sprite=false,
		tooltip={"gui-description.closeButton"}
	}
	-- Set style --
	mfTTGUIMenuBar.TTCloseButton.style.maximal_width = 15
	mfTTGUIMenuBar.TTCloseButton.style.maximal_height = 15
	mfTTGUIMenuBar.TTCloseButton.style.padding = 0
	mfTTGUIMenuBar.TTCloseButton.style.margin = 0
	
	-- Add the Main Frame --
	local mainTooltipFrame = mfTooltipGUI.add{type="frame", name="mainTooltipFrame", direction="vertical"}
	mainTooltipFrame.style.minimal_width = width - 8
	-- mainTooltipFrame.style.height = height - 60
	mainTooltipFrame.style.padding = 0
	mainTooltipFrame.style.margin = 0
	
	-- Add the Main ScrollPane --
	local mainTooltipScrollPane = mainTooltipFrame.add{type="scroll-pane", name="mainTooltipScrollPane", direction="vertical"}
	mainTooltipScrollPane.style.minimal_width = width - 15
	-- mainTooltipScrollPane.style.height = height - 68
	mainTooltipScrollPane.style.padding = 0
	mainTooltipScrollPane.style.margin = 0
	
end

-- Update the tooltip with a new Entity --
function GUI.updateTooltip(player, objID)
	-- Check the variables --
	if player == nil or objID == nil then return end
	-- Check if the Player Tooltip GUI is not null and visible --
	if player.gui.screen.mfTooltipGUI == nil or player.gui.screen.mfTooltipGUI.visible == false then return end
	-- Look for the Object associated with the Entity --
	for k, obj in pairs(global.entsTable) do
		-- Check the Object --
		if obj ~= nil and obj.ent ~= nil and obj.ent.valid == true and obj.ent.unit_number == objID then
			-- Check if the Object can return a Frame --
			if obj.getTooltipInfos ~= nil then
				-- Clear the Tooltip GUI --
				player.gui.screen.mfTooltipGUI.mainTooltipFrame.mainTooltipScrollPane.clear()
				-- Update the GUI --
				obj:getTooltipInfos(player.gui.screen.mfTooltipGUI.mainTooltipFrame.mainTooltipScrollPane)
			end
		end
	end
end





























