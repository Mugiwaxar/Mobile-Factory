-- ENERGY CUBE OBJECT --

-- Create the Energy Cube base Object --
QC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	lightID = 0,
	consumption = 0,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil
}

-- Constructor --
function QC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = QC
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	-- Draw the Sprite --
	t.spriteID = rendering.draw_sprite{sprite="QuatronCubeSprite0", x_scale=1/7, y_scale=1/7, target=object, surface=object.surface, target_offset={0, -0.3}, render_layer=131}
	self.lightID = rendering.draw_light{sprite="QuatronCubeSprite0", scale=1/7, target=object, surface=object.surface, target_offset={0, -0.3}, minimum_darkness=0}
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function QC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = QC
	setmetatable(object, mt)
end

-- Destructor --
function QC:remove()
	-- Destroy the Sprite --
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	-- Remove from the Update System --
	UpSys.removeObj(self)
	-- Remove from the Data Network --
	if self.dataNetwork ~= nil and getmetatable(self.dataNetwork) ~= nil then
		self.dataNetwork:removeObject(self)
	end
end

-- Is valid --
function QC:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Tags to Settings --
function QC:tagToSettings(tags)
	self.ent.energy = tags.energy or 0
end

-- Settings to Tags --
function QC:settingsToTags(tags)
	if self.ent.energy > 0 then
		tags.set_tag("Infos", {energy=self.ent.energy})
		tags.custom_description = {"", tags.prototype.localised_description, {"item-description.QuatronCubeC", Util.toRNumber(math.floor(self.ent.energy))}}
	end
end

-- Update --
function QC:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end
	
	-- Update the Sprite --
	local spriteNumber = math.ceil(self.ent.energy/self.ent.prototype.electric_energy_source_prototype.buffer_capacity*10)
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	self.spriteID = rendering.draw_sprite{sprite="QuatronCubeSprite" .. spriteNumber, x_scale=1/7, y_scale=1/7, target=self.ent, surface=self.ent.surface, target_offset={0, -0.3}, render_layer=131}
	self.lightID = rendering.draw_light{sprite="QuatronCubeSprite" .. spriteNumber, scale=1/7, target=self.ent, surface=self.ent.surface, target_offset={0, -0.3}, minimum_darkness=0}

	-- Balance the Energy with neighboring Cubes --
	self:balance()

end


-- Tooltip Infos --
-- function QC:getTooltipInfos(GUI)
-- end


-- Balance the Energy with neighboring Cubes --
function QC:balance()

	-- Check the Entity --
	if self.ent == nil or self.ent.valid == false then return end

	-- Get all Accumulator arount --
	local area = {{self.ent.position.x-1.5, self.ent.position.y-1.5},{self.ent.position.x+1.5,self.ent.position.y+1.5}}
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
					local energyVariance = _mfQuatronCubes[obj.name] ~= nil and ((self:quatron() - obj:quatron()) / 2) or self:quatron()
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
function QC:quatron()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.energy
	end
	return 0
end

-- Return the Quatron Buffer size --
function QC:maxQuatron()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.electric_buffer_size
	end
	return 1
end

-- Add Quatron (Return the amount added) --
function QC:addQuatron(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local added = math.min(amount, self:maxQuatron() - self:quatron())
		self.ent.energy = self.ent.energy + added
		return added
	end
	return 0
end

-- Remove Quatron (Return the amount removed) --
function QC:removeQuatron(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local removed = math.min(amount, self:quatron())
		self.ent.energy = self.ent.energy - removed
		return removed
	end
	return 0
end

-- Return the max input flow --
function QC:maxInput()
	if self.ent ~= nil and self.ent.valid == true then
		return self:maxQuatron() / 10
	end
	return 0
end

-- Return the max output flow --
function QC:maxOutput()
	if self.ent ~= nil and self.ent.valid == true then
		return self:maxQuatron() / 10
	end
	return 0
end