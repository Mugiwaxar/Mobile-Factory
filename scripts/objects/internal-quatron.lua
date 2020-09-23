-- INTERNAL QUATRON OBJECT --

-- Create the Internal Quatron base Object --
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
	self.spriteID = rendering.draw_sprite{sprite="QuatronCubeSprite0", x_scale=1/2.25, y_scale=1/2.25, target=object, surface=object.surface, render_layer=130}
	self.lightID = rendering.draw_light{sprite="QuatronCubeSprite0", scale=1/2.25, target=object, surface=object.surface, minimum_darkness=0}
	-- Update the UpSys --
	UpSys.scanObjs() -- Make old save crash --
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

-- Tags to Settings --
function IQC:tagToSettings(tags)
	self.ent.energy = tags.energy or 0
end

-- Settings to Tags --
function IQC:settingsToTags(tags)
	if self.ent.energy <= 0 then return end
	tags.set_tag("Infos", {energy=self.ent.energy})
	tags.custom_description = {"", tags.prototype.localised_description, {"item-description.QuatronCubeC", Util.toRNumber(math.floor(self.ent.energy))}}
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
	self.spriteID = rendering.draw_sprite{sprite="QuatronCubeSprite" .. spriteNumber, x_scale=1/2.25, y_scale=1/2.25, target=self.ent, surface=self.ent.surface, render_layer=130}
	self.lightID = rendering.draw_light{sprite="QuatronCubeSprite" .. spriteNumber, scale=1/2.25, target=self.ent, surface=self.ent.surface, minimum_darkness=0}
	
	-- Balance the Energy with neighboring Cubes --
	self:balance()

end

-- Tooltip Infos --
-- function IQC:getTooltipInfos(GUI)
-- end

-- Balance the Energy with neighboring Cubes --
function IQC:balance()

	-- Check the Entity --
	if self.ent == nil or self.ent.valid == false then return end

	-- Get all Accumulator arount --
	local area = {{self.ent.position.x-3.5, self.ent.position.y-2.5},{self.ent.position.x+3.5,self.ent.position.y+4.5}}
	-- local ents = self.ent.surface.find_entities_filtered{area=area, type="accumulator"}
	local ents = self.ent.surface.find_entities_filtered{area=area}

	-- Check all Accumulator --
	for k, ent in pairs(ents) do
		-- Look for valid Energy Cube --
		-- if ent ~= nil and ent.valid == true and _mfQuatronCubes[ent.name] == true then
		if ent ~= nil and ent.valid == true then
			local obj = global.entsTable[ent.unit_number]
			if obj ~= nil and obj.ent ~= nil and obj.ent.valid == true and obj.addQuatron ~= nil then
				if self:quatron() > obj:quatron() and obj:quatron() < obj:maxQuatron() and obj:maxInput() > 0 then
					-- Calcule max flow --
					local energyVariance = (self:quatron() - obj:quatron()) / 2
					local maxEnergyTranfer = math.min(energyVariance, self:quatron(), self:maxOutput(), obj:maxInput())
					-- Transfer Energy --
					local transfered = obj:addQuatron(maxEnergyTranfer)
					-- Remove Energy --
					self:removeQuatron(transfered)
                elseif self:quatron() < obj:quatron() and self:quatron() < self:maxQuatron() and obj:maxOutput() > 0 then
					-- Calcule max flow --
					local energyVariance = (obj:quatron() - self:quatron()) / 2
					local maxEnergyTranfer = math.min(energyVariance, obj:quatron(), self:maxInput(), obj:maxOutput())
					-- Transfer Energy --
					local transfered = self:addQuatron(maxEnergyTranfer)
					-- Remove Energy --
					obj:removeQuatron(transfered)
				end
			end
		end
	end

end

-- Return the amount of Quatron --
function IQC:quatron()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.energy
	end
	return 0
end

-- Return the Quatron Buffer size --
function IQC:maxQuatron()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.electric_buffer_size
	end
	return 1
end

-- Add Quatron (Return the amount added) --
function IQC:addQuatron(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local added = math.min(amount, self:maxQuatron() - self:quatron())
		self.ent.energy = self.ent.energy + added
		return added
	end
	return 0
end

-- Remove Quatron (Return the amount removed) --
function IQC:removeQuatron(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local removed = math.min(amount, self:quatron())
		self.ent.energy = self.ent.energy - removed
		return removed
	end
	return 0
end

-- Return the max input flow --
function IQC:maxInput()
	if self.ent ~= nil and self.ent.valid == true then
		return self:maxQuatron() / 10
	end
	return 0
end

-- Return the max output flow --
function IQC:maxOutput()
	if self.ent ~= nil and self.ent.valid == true then
		return self:maxQuatron() / 10
	end
	return 0
end