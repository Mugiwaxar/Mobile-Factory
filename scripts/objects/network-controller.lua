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
function NC:getTooltipInfos(GUIObj, gui, justCreated)

	-- Create the Data Network Frame --
	GUIObj:addDataNetworkFrame(gui, self)

	-- Get the ScrollPane --
	local inventoryScrollPane = GUIObj.inventoryScrollPane

	if justCreated == true then

		-- Create the Inventory Scroll Pane --
		inventoryScrollPane = GUIObj:addScrollPane("inventoryScrollPane", gui, 400, true)

	end

	-- Clear the ScrollPane --
	inventoryScrollPane.clear()

	-- Create the Inventory Frame --
	self.invObj:getTooltipInfos(GUIObj, inventoryScrollPane)

end