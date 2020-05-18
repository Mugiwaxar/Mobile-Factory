-- QUATRON REACTOR OBJECT --

-- Create the Quatron Reactor base Object --
QR = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	lightID = 0,
	updateTick = 60,
    lastUpdate = 0,
    internalQuatron = 0,
    maxInternalQuatron = 25000
}

-- Constructor --
function QR:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = QR
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
    UpSys.addObj(t)
    -- Draw the state Sprite --
	t.spriteID = rendering.draw_sprite{sprite="QuatronReactorSprite0", target=object, surface=object.surface, render_layer=129}
	self.lightID = rendering.draw_light{sprite="QuatronReactorSprite0", target=object, surface=object.surface, minimum_darkness=0}
	return t
end

-- Reconstructor --
function QR:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = QR
	setmetatable(object, mt)
end

-- Destructor --
function QR:remove()
	-- Destroy the Sprite --
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	self.ent = nil
end

-- Is valid --
function QR:valid()
	return true
end

-- Update --
function QR:update()

	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if self.ent == nil or self.ent.valid == false then
		return
    end

    -- Burn Fluid --
    self:burnFluid()

    -- Send Energy --
    self:sendEnergy()

    -- Update the Sprite --
	local spriteNumber = math.ceil(self:quatron()/self:maxQuatron()*12)
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	self.spriteID = rendering.draw_sprite{sprite="QuatronReactorSprite" .. spriteNumber, target=self.ent, surface=self.ent.surface, render_layer=129}
	self.lightID = rendering.draw_light{sprite="QuatronReactorSprite" .. spriteNumber, target=self.ent, surface=self.ent.surface, minimum_darkness=0}
    
end

-- Tooltip Infos --
-- function IQC:getTooltipInfos(GUI)
-- end

-- Transform the Fluid inside into Energy --
function QR:burnFluid()
    -- Return if the Reactor is full --
    if self:quatron() >= self:maxQuatron() then return end

    -- Get the Fluid inside --
    local fluid = self.ent.fluidbox[1]
    if fluid == nil then return end

    -- Get the Quatron Level --
    local fluidName = fluid.name
    if string.match(fluidName, "LiquidQuatron") == nil then return end
    level = string.gsub(fluidName, "LiquidQuatron", "")
    local level = tonumber(level)
    if level == nil then return end

    -- Get the amount of Fluid to remove --
    local fluidToRemove = math.min(fluid.amount, (self:maxQuatron() - self:quatron()) / (level), 500)
    fluidToRemove = math.ceil(fluidToRemove)

    -- Remove the Fluid --
    local removed = self.ent.remove_fluid{name=fluidName, amount=fluidToRemove}

    -- Add the Quatron --
    self:addQuatron(math.floor(removed * (level)))
    self.internalQuatron = math.floor(self.internalQuatron)
    if self:quatron() > self:maxQuatron() then self.internalQuatron = self.maxQuatron end
end

-- Send Energy to nearby Cubes --
function QR:sendEnergy()
    -- Check the Entity --
    if self.ent == nil or self.ent.valid == false then return end

    -- Get all Entities arount --
    local area = {{self.ent.position.x-2.5, self.ent.position.y-2.5},{self.ent.position.x+2.5,self.ent.position.y+2.5}}
    local ents = self.ent.surface.find_entities_filtered{area=area}

    -- Check all Entity --
    for k, ent in pairs(ents) do
        -- Look for valid Energy Cube --
        if ent ~= nil and ent.valid == true then
            local obj = global.entsTable[ent.unit_number]
            if ent.name == "InternalQuatronCube" then obj = self.MF.internalQuatronObj end
            if obj ~= nil and obj.ent ~= nil and obj.ent.valid == true and obj.ent.name ~= "QuatronReactor" and obj.addQuatron ~= nil then
                if obj:quatron() < obj:maxQuatron() then
                    -- Calcule max flow --
                    local maxEnergyTranfer = math.min(self:quatron(), obj:maxInput())
                    -- Transfer Energy --
                    local transfered = obj:addQuatron(maxEnergyTranfer)
                    -- Remove Energy --
                    self:removeQuatron(transfered)
                end
            end
        end
    end

end

-- Return the amount of Energy --
function QR:quatron()
	if self.ent ~= nil and self.ent.valid == true then
		return self.internalQuatron
	end
	return 0
end

-- Return the Energy Buffer size --
function QR:maxQuatron()
	if self.ent ~= nil and self.ent.valid == true then
		return self.maxInternalQuatron
	end
	return 1
end

-- Add Energy (Return the amount added) --
function QR:addQuatron(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local added = math.min(amount, self:maxQuatron() - self:quatron())
		self.internalQuatron = self.internalQuatron + added
		return added
	end
	return 0
end

-- Remove Energy (Return the amount removed) --
function QR:removeQuatron(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local removed = math.min(amount, self:quatron())
		self.internalQuatron = self.internalQuatron - removed
		return removed
	end
	return 0
end