-- JUMP CHARGER OBJECT --

-- Create the Jump Charger base Object --
JC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	lightID = 0,
	updateTick = 240,
	lastUpdate = 0
}

-- Constructor --
function JC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = JC
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMFBySurface(object.surface)
	t.entID = object.unit_number
	-- Draw the Light Sprite --
	t.lightID = rendering.draw_light{sprite="JumpChargerL", target=object, surface=object.surface, minimum_darkness=0}
	-- Save the Jump Charger inside the Jump Drive Table --
	t.MF.jumpDriveObj.jumpChargerTable[object.unit_number] = t
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function JC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = JC
	setmetatable(object, mt)
end

-- Destructor --
function JC:remove()
    -- Destroy the Light --
    rendering.destroy(self.lightID)
    -- Remove from the Jump Drive Table --
    self.MF.jumpDriveObj.jumpChargerTable[self.ent.unit_number] = nil
    -- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function JC:valid()
    if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function JC:update()

	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick

	-- Check the Validity --
	if self.ent == nil or self.ent.valid == false then
		return
    end

    -- Draw the Light Sprite --
    if rendering.is_valid(self.lightID) == false then
        self.lightID = rendering.draw_light{sprite="JumpChargerL", target=self.ent, surface=self.ent.surface, minimum_darkness=0}
    end

end

-- Tooltip Infos --
function JC:getTooltipInfos(GUITable, mainFrame, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.JDTitle"}

		-- Create the Information Frame --
		local infoFrame = GAPI.addFrame(GUITable, "InformationFrame", mainFrame, "vertical", true)
		infoFrame.style = "MFFrame1"
		infoFrame.style.vertically_stretchable = true
		infoFrame.style.minimal_width = 200
		infoFrame.style.left_margin = 3
		infoFrame.style.left_padding = 3
		infoFrame.style.right_padding = 3

		-- Create the Tite --
		GAPI.addSubtitle(GUITable, "", infoFrame, {"gui-description.Information"})

		-- Add the Capacity added --
		GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.JCCapacityAdded", _chargeAddedPerJumpCharger}, _mfOrange)

		-- Add the Charge Rate added --
		GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.JChargeRateAdded", _chargeRateAddedPerJumpCharger}, _mfOrange)

	end

end