-- ENERGY DISPENSER OBJECT --

-- Create the Energy Dispenser base Object --
ED =  {
    ent = nil,
    accEnt = nil,
    player = "",
    MF = "",
    entID = 0,
    pole = nil,
    poleID = 0,
    updateTick = 150,
    lastUpdate = 0
}

-- Constructor --
function ED:new(object)
    if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = ED
    t.ent = object.surface.create_entity{name="EnergyDispenserAcc", position=object.position, force=object.force, player=object.last_user}
    t.entID = t.ent.unit_number
    t.pole = object
    t.poleID = object.unit_number
    if object.last_user.name == nil then return end
    t.player = object.last_user.name
	t.MF = getMF(t.player)
	UpSys.addObj(t)
    return t
end

-- Reconstructor --
function ED:rebuild(object)
    if object == nil then return end
	local mt = {}
	mt.__index = ED
	setmetatable(object, mt)
end

-- Destructor --
function ED:remove()
    -- Remove the Fake Accumulator --
    if self.pole ~= nil and self.pole.valid == true then self.pole.destroy() end
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function ED:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function ED:update()
    -- Set the lastUpdate variable --
    self.lastUpdate = game.tick

    -- Check the Validity --
    if valid(self) == false then
        self:remove()
        return
    end

    -- Check if the Pole was removed --
    if self.pole ~= nil and self.pole.valid == false then
        self.ent.destroy()
        self:remove()
    end
end

-- Tooltip Infos --
-- function ED:getTooltipInfos(GUITable, mainFrame, justCreated)

-- end