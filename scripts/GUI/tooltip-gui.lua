-- Create the Tooltip GUI --
function GUI.createTooltipGUI(player, obj)

	-- -- Check the Entity --
	if valid(obj) == false then return end

	-- Get the MFPlayer --
	local MFPlayer = getMFPlayer(player.name)

	-- Create the GUI --
	local GUITable = GAPI.createBaseWindows(_mfGUIName.TooltipGUI, getCurrentMF(MFPlayer).name, MFPlayer, true, true, false, "vertical", "horizontal")

	-- Add the Close Button --
	GAPI.addCloseButton(GUITable)

	-- Save the Object --
	GUITable.vars.currentObject = obj

	-- Update the GUI --
	GUI.updateMFTooltipGUI(GUITable, true)

	-- Return the GUI --
	return GUITable
	
end

-- Update the Tooltip GUI --
function GUI.updateMFTooltipGUI(GUIObj, justCreated)

	-- Check the Object --
	if valid(GUIObj.vars.currentObject) == false or GUIObj.vars.currentObject.getTooltipInfos == nil then return end

	-- Add the Object GUI --
	GUIObj.vars.currentObject:getTooltipInfos(GUIObj, GUIObj.vars.MainFrame, justCreated)

end