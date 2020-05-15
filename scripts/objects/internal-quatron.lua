-- INTERNAL QUATRON OBJECT --

-- Create the Internal Energy base Object --
IQC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	lightID = 0,
	updateTick = 60,
	lastUpdate = 0
}

-- Constructor --
function IQC:new(MF)
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = IQC
	t.player = MF.player
	t.MF = MF
	UpSys.addObj(t)
	return t
end

-- Set an Internal Energy Cube --
function IQC:setEnt(object)
	if object == nil then return end
	if object.last_user == nil then return end
	self.ent = object
	self.entID = object.unit_number
	-- Draw the Sprite --
	self.spriteID = rendering.draw_sprite{sprite="QuatronCubeSprite0", x_scale=1/2.25, y_scale=1/2.25, target=object, surface=object.surface, render_layer=131}
	self.lightID = rendering.draw_light{sprite="QuatronCubeSprite0", scale=1/2.25, target=object, surface=object.surface, minimum_darkness=0}
end

-- Reconstructor --
function IQC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = IQC
	setmetatable(object, mt)
end

-- Destructor --
function IQC:remove()
	-- Destroy the Sprite --
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	self.ent = nil
end

-- Is valid --
function IQC:valid()
	return true
end

-- Update --
function IQC:update()

	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if self.ent == nil or self.ent.valid == false then
		return
    end

    -- Update the Sprite --
	local spriteNumber = math.ceil(self.ent.energy/self.ent.prototype.electric_energy_source_prototype.buffer_capacity*10)
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	self.spriteID = rendering.draw_sprite{sprite="QuatronCubeSprite" .. spriteNumber, x_scale=1/2.25, y_scale=1/2.25, target=self.ent, surface=self.ent.surface, render_layer=131}
	self.lightID = rendering.draw_light{sprite="QuatronCubeSprite" .. spriteNumber, scale=1/2.25, target=self.ent, surface=self.ent.surface, minimum_darkness=0}
    
end

-- Tooltip Infos --
-- function IQC:getTooltipInfos(GUI)
-- end

-- Return the amount of Energy --
function IQC:quatron()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.energy
	end
	return 0
end

-- Return the Energy Buffer size --
function IQC:maxQuatron()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.electric_buffer_size
	end
	return 1
end

-- Add Energy (Return the amount added) --
function IQC:addQuatron(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local added = math.min(amount, self:maxQuatron() - self:quatron())
		self.ent.energy = self.ent.energy + added
		return added
	end
	return 0
end

-- Remove Energy (Return the amount removed) --
function IQC:removeQuatron(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local removed = math.min(amount, self:quatron())
		self.ent.energy = self.ent.energy - removed
		return removed
	end
	return 0
end