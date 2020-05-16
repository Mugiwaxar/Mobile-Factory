-- INTERNAL ENERGY OBJECT --

-- Create the Internal Energy base Object --
IEC = {
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
	self.lightID = rendering.draw_light{sprite="EnergyCubeMK1Sprite0", scale=1/2.25, target=object, surface=object.surface, minimum_darkness=0}
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
	rendering.destroy(self.lightID)
	self.ent = nil
end

-- Is valid --
function IEC:valid()
	return true
end

-- Tags to Settings --
function IEC:tagToSettings(tags)
	self.ent.energy = tags.energy or 0
end

-- Settings to Tags --
function IEC:settingsToTags(tags)
	if self.ent.energy <= 0 then return end
	tags.set_tag("Infos", {energy=self.ent.energy})
	tags.custom_description = {"", tags.prototype.localised_description, {"item-description.EnergyCubeC", Util.toRNumber(math.floor(self.ent.energy))}}
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
	rendering.destroy(self.lightID)
	self.spriteID = rendering.draw_sprite{sprite="EnergyCubeMK1Sprite" .. spriteNumber, x_scale=1/2.25, y_scale=1/2.25, target=self.ent, surface=self.ent.surface, render_layer=131}
	self.lightID = rendering.draw_light{sprite="EnergyCubeMK1Sprite" .. spriteNumber, scale=1/2.25, target=self.ent, surface=self.ent.surface, minimum_darkness=0}
	
	-- Balance the Energy with neighboring Cubes --
	-- self:balance()

end
 
-- Tooltip Infos --
-- function IEC:getTooltipInfos(GUI)
-- end

-- Balance the Energy with neighboring Cubes --
function IEC:balance()

	-- Check the Entity --
	if self.ent == nil or self.ent.valid == false then return end

	-- Get all Accumulator arount --
	local area = {{self.ent.position.x-3.5, self.ent.position.y-2.5},{self.ent.position.x+3.5,self.ent.position.y+4.5}}
	local ents = self.ent.surface.find_entities_filtered{area=area, type="accumulator"}

	-- Check all Accumulator --
	for k, ent in pairs(ents) do
		-- Look for valid Energy Cube --
		if ent ~= nil and ent.valid == true and ent ~= self.ent and (ent.name == "EnergyCubeMK1" or "InternalPowerCube") then
			local obj = global.entsTable[ent.unit_number]
			if valid(obj) then
				if self:energy() > obj:energy() and obj:energy() < obj:maxEnergy() then
					-- Calcule max flow --
					local energyVariance = (self:energy() - obj:energy()) / 2
					local maxEnergyTranfer = math.min(energyVariance, self:energy(), self:maxOutput()*self.updateTick, obj:maxInput()*self.updateTick)
					-- Transfer Energy --
					local transfered = obj:addEnergy(maxEnergyTranfer)
					-- Remove Energy --
					self:removeEnergy(transfered)
				elseif self:energy() < obj:energy() and self:energy() < self:maxEnergy() then
					-- Calcule max flow --
					local energyVariance = (obj:energy() - self:energy()) / 2
					local maxEnergyTranfer = math.min(energyVariance, obj:energy(), self:maxInput()*self.updateTick, obj:maxOutput()*self.updateTick)
					-- Transfer Energy --
					local transfered = self:addEnergy(maxEnergyTranfer)
					-- Remove Energy --
					obj:removeEnergy(transfered)
				end
			end
		end
	end

end

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

-- Return the max input flow --
function IEC:maxInput()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.electric_input_flow_limit
	end
	return 0
end

-- Return the max output flow --
function IEC:maxOutput()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.electric_output_flow_limit
	end
	return 0
end