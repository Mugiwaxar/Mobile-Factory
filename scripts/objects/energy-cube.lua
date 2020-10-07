-- ENERGY CUBE OBJECT --

-- Create the Energy Cube base Object --
EC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	lightID = 0,
	consumption = 0,
	updateTick = 60,
	lastUpdate = 0
}

-- Constructor --
function EC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = EC
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	-- Draw the Sprite --
	t.spriteID = rendering.draw_sprite{sprite="EnergyCubeMK1Sprite0", x_scale=1/7, y_scale=1/7, target=object, surface=object.surface, target_offset={0, -0.3}, render_layer=131}
	self.lightID = rendering.draw_light{sprite="EnergyCubeMK1Sprite0", scale=1/7, target=object, surface=object.surface, target_offset={0, -0.3}, minimum_darkness=0}
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function EC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = EC
	setmetatable(object, mt)
end

-- Destructor --
function EC:remove()
	-- Destroy the Sprite --
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function EC:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Item Tags To Content --
function EC:itemTagsToContent(tags)
	self.ent.energy = tags.energy or 0
end

-- Content to Item Tags --
function EC:contentToItemTags(tags)
	if self.ent.energy > 0 then
		tags.set_tag("Infos", {energy=self.ent.energy})
		tags.custom_description = {"", tags.prototype.localised_description, {"item-description.EnergyCubeC", Util.toRNumber(math.floor(self.ent.energy))}, "J"}
	end
end

-- Update --
function EC:update()
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
	self.spriteID = rendering.draw_sprite{sprite="EnergyCubeMK1Sprite" .. spriteNumber, x_scale=1/7, y_scale=1/7, target=self.ent, surface=self.ent.surface, target_offset={0, -0.3}, render_layer=131}
	self.lightID = rendering.draw_light{sprite="EnergyCubeMK1Sprite" .. spriteNumber, scale=1/7, target=self.ent, surface=self.ent.surface, target_offset={0, -0.3}, minimum_darkness=0}

	-- Balance the Energy with neighboring Cubes --
	self:balance()
end


-- Tooltip Infos --
-- function EC:getTooltipInfos(GUI)
-- end


-- Balance the Energy with neighboring Cubes --
function EC:balance()
	-- Get all Accumulator arount --
	local area = {{self.ent.position.x-1.5, self.ent.position.y-1.5},{self.ent.position.x+1.5,self.ent.position.y+1.5}}
	local ents = self.ent.surface.find_entities_filtered{area=area, name=_mfEnergyShare}

	-- Return if nothing found
	if next(ents) == nil then return end

	local selfMaxOutFlow = self.ent.electric_output_flow_limit * self.updateTick
	local selfMaxInFlow = self.ent.electric_input_flow_limit * self.updateTick
	local selfEnergy = self.ent.energy
	local selfMaxEnergy = self.ent.electric_buffer_size

	-- Check all Accumulator --
	for k, ent in pairs(ents) do
		-- Look for valid Energy Cube --
		local obj = global.entsTable[ent.unit_number]
		if obj ~= nil then
			local objEnergy = obj.ent.energy
			local objMaxEnergy = obj.ent.electric_buffer_size
			if selfEnergy > objEnergy and objEnergy < objMaxEnergy then
				-- Calcule max flow --
				local energyVariance = (selfEnergy - objEnergy) / 2
				local missingEnergy = objMaxEnergy - objEnergy
				local objMaxInFlow = obj:maxInput() * self.updateTick
				local energyTransfer = math.min(energyVariance, missingEnergy, selfMaxOutFlow, objMaxInFlow)
				-- Transfer Energy --
				obj.ent.energy = objEnergy + energyTransfer
				-- Remove Energy --
				selfEnergy = selfEnergy - energyTransfer
			elseif selfEnergy < objEnergy and selfEnergy < selfMaxEnergy then
				-- Calcule max flow --
				local energyVariance = (objEnergy - selfEnergy) / 2
				local missingEnergy = selfMaxEnergy - selfEnergy
				local objMaxOutFlow = obj:maxOutput() * self.updateTick
				local energyTransfer = math.min(energyVariance, missingEnergy, selfMaxInFlow, objMaxOutFlow)
				-- Transfer Energy --
				selfEnergy = selfEnergy + energyTransfer
				-- Remove Energy --
				obj.ent.energy = objEnergy - energyTransfer
			end
		end
	end

	self.ent.energy = selfEnergy
end

-- Return the amount of Energy --
function EC:energy()
	return self.ent.energy
end

-- Return the Energy Buffer size --
function EC:maxEnergy()
	return self.ent.electric_buffer_size
end

-- Add Energy (Return the amount added) --
function EC:addEnergy(amount)
	local added = math.min(amount, self.ent.electric_buffer_size - self.ent.energy)
	self.ent.energy = self.ent.energy + added
	return added
end

-- Remove Energy (Return the amount removed) --
function EC:removeEnergy(amount)
	local removed = math.min(amount, self.ent.energy)
	self.ent.energy = self.ent.energy - removed
	return removed
end

-- Return the max input flow --
function EC:maxInput()
	return self.ent.electric_input_flow_limit
end

-- Return the max output flow --
function EC:maxOutput()
	return self.ent.electric_output_flow_limit
end