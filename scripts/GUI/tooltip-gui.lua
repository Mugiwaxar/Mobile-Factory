-- Create the Tooltip GUI --
function GUI.createTooltipGUI(player, obj)

	-- Check the Entity --
	if valid(obj) == false then return end

	-- Create the GUI --
	local GUIObj = GUI.createGUI("MFTooltipGUI", getMFPlayer(player.name), "vertical", true)

	-- Save the Object --
	GUIObj.currentObject = obj

	-- Create the top Bar --
	GUI.createTopBar(GUIObj, 50, Util.getLocEntityName(obj.ent.name))

	-- Add the Main Scroll Pane --
	local mainSrollPane = GUIObj:addScrollPane("MainScrollPane", GUIObj.gui, 350, true)
	GUIObj.MainScrollPane.style.minimal_height = 50

	-- Add the Infos Flow --
	GUIObj:addFlow("InfosFrame", mainSrollPane, "vertical", true)

	-- Add the Settings Flow --
	GUIObj:addFlow("SettingsFrame", mainSrollPane, "vertical", true)
	GUIObj.SettingsFrame.visible = false

	-- Update the GUI --
	GUI.updateMFTooltipGUI(GUIObj, true)

	-- Center the GUI --
	GUIObj.force_auto_center()

	-- Return the GUI --
	return GUIObj
	
end

-- Update the Tooltip GUI --
function GUI.updateMFTooltipGUI(GUIObj, justCreated)

	-- Check the Object --
	if valid(GUIObj.currentObject) == false or GUIObj.currentObject.getTooltipInfos == nil then return end

	-- Clear the Info Flow Pane --
	GUIObj.InfosFrame.clear()

	-- Add the Object GUI --
	GUIObj.currentObject:getTooltipInfos(GUIObj, GUIObj.InfosFrame, justCreated)

end