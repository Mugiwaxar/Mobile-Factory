-- INTERNAL ENERGY CUBE OBJECT --

-- Create the Internal Energy Cube base Object --
IEC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	updateTick = 60,
	lastUpdate = 0
}

-- Constructor --
function IEC:new(MF)
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = IEC
	t.player = MF.player
	t.MF = MF
	UpSys.addObj(t)
	return t
end

-- Set an Internal Energy Cube --
function IEC:setEnt(object)
	if object == nil then return end
	if object.last_user == nil then return end
	self.ent = object
	self.entID = object.unit_number
	-- Draw the Sprite --
	self.spriteID = rendering.draw_sprite{sprite="EnergyCubeMK1Sprite0", x_scale=1/2.25, y_scale=1/2.25, target=object, surface=object.surface, render_layer=131}
end

-- Reconstructor --
function IEC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = IEC
	setmetatable(object, mt)
end

-- Destructor --
function IEC:remove()
	-- Destroy the Sprite --
	rendering.destroy(self.spriteID)
	self.ent = nil
end

-- Is valid --
function IEC:valid()
	return true
end

-- Update --
function IEC:update()

	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if self.ent == nil or self.ent.valid == false then
		return
    end

    -- Update the Sprite --
	local spriteNumber = math.ceil(self.ent.energy/self.ent.prototype.electric_energy_source_prototype.buffer_capacity*10)
	rendering.destroy(self.spriteID)
    self.spriteID = rendering.draw_sprite{sprite="EnergyCubeMK1Sprite" .. spriteNumber, x_scale=1/2.25, y_scale=1/2.25, target=self.ent, surface=self.ent.surface, render_layer=131}
    
end

-- Tooltip Infos --
-- function IEC:getTooltipInfos(GUI)
-- end

-- Return the amount of Energy --
function IEC:energy()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.energy
	end
	return 0
end

-- Return the Energy Buffer size --
function IEC:maxEnergy()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.electric_buffer_size
	end
	return 1
end

-- Add Energy (Return the amount added) --
function IEC:addEnergy(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local added = math.min(amount, self:maxEnergy() - self:energy())
		self.ent.energy = self.ent.energy + added
		return added
	end
	return 0
end

-- Remove Energy (Return the amount removed) --
function IEC:removeEnergy(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local removed = math.min(amount, self:energy())
		self.ent.energy = self.ent.energy - removed
		return removed
	end
	return 0
end