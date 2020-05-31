-- JUMP CHARGER OBJECT --

-- Create the Jump Charger base Object --
JC = {
    ent = nil,
    entID = 0,
	player = "",
	MF = nil,
    lightID = 0,
	updateTick = 240,
	lastUpdate = 0
}

-- Constructor --
function JC:new(ent)
	local t = {}
	local mt = {}
	setmetatable(t, mt)
    mt.__index = JC
    t.ent = ent
    t.entID = ent.unit_number
    t.player = ent.last_user.name
    t.MF = getMF(t.player)
    -- Draw the Light Sprite --
    t.lightID = rendering.draw_light{sprite="JumpChargerL", target=t.ent, surface=t.ent.surface, minimum_darkness=0}
    -- Save the Jump Charger inside the Jump Drive Table --
    t.MF.jumpDriveObj.jumpChargerTable[ent.unit_number] = t
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
	return true
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
-- function JC:getTooltipInfos(GUI)
-- end