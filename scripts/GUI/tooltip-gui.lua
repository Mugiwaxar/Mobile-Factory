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
	GUIObj.MainScrollPane.style.maximal_height = 800

	-- Add the Main Flow --
	GUIObj:addFlow("MainFlow", mainSrollPane, "horizontal", true)

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
	if justCreated == true then
		GUIObj.MainFlow.clear()
	end

	-- Add the Object GUI --
	GUIObj.currentObject:getTooltipInfos(GUIObj, GUIObj.MainFlow, justCreated)

end