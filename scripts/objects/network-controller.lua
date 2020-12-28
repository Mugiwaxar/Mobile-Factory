-- NETWORK CONTROLLER OBJECT --

-- Create the Network Controller base object --
NC = {
	ent = nil,
	player = "",
	MF = nil,
	dataNetwork = nil,
    invObj = nil,
	animID = 0,
	updateTick = 300,
	lastUpdate = 0
}

-- Constructor --
function NC:new(ent)
	if ent == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = NC
	t.ent = ent
	if ent.last_user == nil then return end
	t.player = ent.last_user.name
    t.MF = getMF(t.player)
    t.dataNetwork = t.MF.dataNetwork
    t.invObj = t.MF.II
    t.MF.dataNetwork.networkController = t
	t.MF.II.networkController = t
    UpSys.addObj(t)
    t.animID = rendering.draw_animation{animation="NetworkControllerAn", target={ent.position.x,ent.position.y}, surface=ent.surface, render_layer=131}
	return t
end

-- Reconstructor --
function NC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = NC
	setmetatable(object, mt)
end

-- Destructor --
function NC:remove()
end

-- Is valid --
function NC:valid()
	return true
end

-- Update --
function NC:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick

    -- Create the Animation if Needed --
    if self.animID == 0 or rendering.is_valid(self.animID) == false then
        self.animID = rendering.draw_animation{animation="NetworkControllerAn", target={self.ent.position.x,self.ent.position.y}, surface=self.ent.surface, render_layer=131}
	end
	
end

-- Tooltip Infos --
function NC:getTooltipInfos(GUITable, mainFrame, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.NetworkController"}

		-- Set the Main Frame Height --
		mainFrame.style.height = 450

		-- Create the Connected Structures Frame --
		local conStructuresFrame = GAPI.addFrame(GUITable, "", mainFrame, "vertical")
		conStructuresFrame.style = "MFFrame1"
		conStructuresFrame.style.vertically_stretchable = true
		conStructuresFrame.style.minimal_width = 200
		conStructuresFrame.style.left_margin = 3
		conStructuresFrame.style.left_padding = 3
		conStructuresFrame.style.right_padding = 3

		-- Create the Tite --
		GAPI.addSubtitle(GUITable, "", conStructuresFrame, {"gui-description.NCConnectedNAP"})

		-- Create the Scroll Pane --
		local conStructuresSC = GAPI.addScrollPane(GUITable, "", conStructuresFrame, nil, false)
		conStructuresSC.style.vertically_stretchable = true
		conStructuresSC.style.bottom_margin = 3

		-- Create the Connected Structures Table --
		GAPI.addTable(GUITable, "ConnectedStructuresTable", conStructuresSC, 1, true)

	end

	-- Get the Connected Structures Table --
	local conStructuresTable = GUITable.vars.ConnectedStructuresTable

	-- Clear the Table --
	conStructuresTable.clear()

	-- Show the Connected Structures List --
	for _, obj in pairs(self.dataNetwork.networkAccessPointTable) do
		-- Check the Structure --
		if valid(obj) == true then
			-- Create the Label --
			GAPI.addLabel(GUITable, "", conStructuresTable, {"", obj.player, " ", Util.getLocEntityName(obj.ent.name)}, nil, {"", {"gui-description.mfPosition"}, ": ", obj.ent.position.x, ";", obj.ent.position.y, " - ", obj.ent.surface.name})
		end
	end

end