-- Energy LASER OBJECT --

-- Create the Energy Laser base Object --
EL = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	updateTick = 60,
	lastUpdate = 0,
	checkTick = 180,
	lastCheck = 0,
	beam = nil,
	beamPosA = nil,
	beamPosB = nil,
	focusedObj = nil
}

-- Constructor --
function EL:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = EL
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	UpSys.addObj(t)
	-- Create the Beam --
	t.beam = t.ent.surface.create_entity{name="IddleBeam", position= EL.getBeamPositionA(t), target_position=EL.getBeamPositionB(t), source=EL.getBeamPositionA(t)}
	return t
end

-- Reconstructor --
function EL:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = EL
	setmetatable(object, mt)
end

-- Destructor --
function EL:remove()
	-- Remove the Beam --
	if self.beam ~= nil and self.beam.valid == true then
		self.beam.destroy()
	end
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function EL:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function EL:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end

	-- Look for Energy from neighboring Cubes --
	self:findPower()

	-- Send Energy to the Focused Entity --
	self:sendEnergy()

	-- Look for an Entity to recharge --
	if self.checkTick < game.tick - self.lastCheck then
		self.lastCheck = game.tick
		self:findEntity()
	end

end

-- Tooltip Infos --
function EL:getTooltipInfos(GUI)
end

-- Look for Energy from neighboring Cubes --
function EL:findPower()

	-- Check the Entity --
	if self.ent == nil or self.ent.valid == false then return end

	-- Get all Accumulator arount --
	local area = {{self.ent.position.x-1.5, self.ent.position.y-1.5},{self.ent.position.x+1.5,self.ent.position.y+1.5}}
	local ents = self.ent.surface.find_entities_filtered{area=area, type="accumulator"}

	-- Check all Accumulator --
	for k, ent in pairs(ents) do
		-- Look for valid Energy Cube --
		if ent ~= nil and ent.valid == true and ent ~= self.ent and (ent.name == "EnergyCubeMK1" or "InternalPowerCube") then
			local obj = global.entsTable[ent.unit_number]
			if obj.ent ~= nil and obj.ent.valid == true then
				if self:energy() < self:maxEnergy() then
					-- Calcule max flow --
					local amount = self:maxEnergy() - self:energy()
					local maxEnergyTranfer = math.min(amount, obj:energy(), self:maxInput()*self.updateTick, obj:maxOutput()*self.updateTick)
					-- Transfer Energy --
					local transfered = self:addEnergy(maxEnergyTranfer)
					-- Remove Energy --
					obj:removeEnergy(transfered)
				end
			end
		end
	end

end

-- Send Energy to the Focused Entity --
function EL:sendEnergy()

	-- Check the Entity --
	local obj = self.focusedObj
	if obj ~= nil and obj.ent ~= nil and obj.ent.valid == true and string.match(obj.ent.name, "MobileFactory") then obj = obj.internalEnergyObj end
	if obj == nil or obj.ent == nil or obj.ent.valid == false or obj:energy() >= obj:maxEnergy() or self:energy() <= 0 then return end

	-- Send Energy to the Entity --
	local amount = math.min(self:energy(), self:maxOutput()*self.updateTick, (obj:maxEnergy() - obj:energy()), obj:maxInput()*self.updateTick)
	if amount > 0  then
		-- Remove the Energy --
		self:removeEnergy(amount)
		-- Add the Energy --
		obj:addEnergy(amount)
		-- Create the Beam --
		self.beam.destroy()
		self.ent.surface.create_entity{name="MK1SendBeam", duration=5, position= EL.getBeamPositionA(self), target_position=EL.getBeamPositionB(self), source=EL.getBeamPositionA(self)}
		self.beam = self.ent.surface.create_entity{name="MK1ConnectedBeam", position= EL.getBeamPositionA(self), target_position=EL.getBeamPositionB(self), source=EL.getBeamPositionA(self)}
	end


end

-- Look for an Entity to recharge --
function EL:findEntity()

	-- Save Remove the Focused Entity --
	local oldObj = self.focusedObj
	self.focusedObj = nil

	-- Get all Entities inside the Area to scan --
	local area = EL.getCheckErea(self)
	local ents = self.ent.surface.find_entities_filtered{area=area}

	-- Get the closest --
	for k, ent in pairs(ents) do
		local obj = global.entsTable[ent.unit_number]
		if obj ~= nil and obj.ent ~= nil and obj.ent.valid == true and (obj.addEnergy ~= nil or string.match(obj.ent.name, "MobileFactory")) then
			if self.focusedObj == nil or self.focusedObj.ent == nil or self.focusedObj.ent.valid == false then
				self.focusedObj = obj
			elseif Util.distance(self.ent.position, ent.position) < Util.distance(self.ent.position, self.focusedObj.ent.position) then
				self.focusedObj = obj
			end
		end
	end

	-- Create the new Beam --
	if self.focusedObj == nil or self.focusedObj.ent == nil or self.focusedObj.ent.valid == false then
		self.beam.destroy()
		self.beam = self.ent.surface.create_entity{name="IddleBeam", position= EL.getBeamPositionA(self), target_position=EL.getBeamPositionB(self), source=EL.getBeamPositionA(self)}
	elseif oldObj ~= nil and oldObj.ent ~= nil and oldObj.ent.valid == true and oldObj ~= self.focusedObj then
		self.beam.destroy()
		self.beam = self.ent.surface.create_entity{name="MK1ConnectedBeam", position= EL.getBeamPositionA(self), target_position=EL.getBeamPositionB(self), source=EL.getBeamPositionA(self)}
	end

end

-- Return the amount of Energy --
function EL:energy()
	if self.ent ~= nil and self.ent.valid == true then
		if self.ent.energy < 1000 then self.ent.energy = 0 end
		return self.ent.energy
	end
	return 0
end

-- Return the Energy Buffer size --
function EL:maxEnergy()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.prototype.energy_usage
	end
	return 1
end

-- Add Energy (Return the amount added) --
function EL:addEnergy(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local added = math.min(amount, self:maxEnergy() - self:energy())
		self.ent.energy = self.ent.energy + added
		return added
	end
	return 0
end

-- Remove Energy (Return the amount removed) --
function EL:removeEnergy(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local removed = math.min(amount, self:energy())
		self.ent.energy = self.ent.energy - removed
		return removed
	end
	return 0
end

-- Return the max input flow --
function EL:maxInput()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.prototype.energy_usage
	end
	return 0
end

-- Return the max output flow --
function EL:maxOutput()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.prototype.energy_usage
	end
	return 0
end

-- Return where the Beam start must be positioned --
function EL.getBeamPositionA(obj)
	local ent = obj.ent
	if ent.direction == defines.direction.north then
		obj.beamPosA = {x=ent.position.x, y=ent.position.y-0.5}
		return obj.beamPosA
	elseif ent.direction ==  defines.direction.east then
		obj.beamPosA = {x=ent.position.x+0.2, y=ent.position.y-0.2}
		return obj.beamPosA
	elseif ent.direction ==  defines.direction.south then
		obj.beamPosA = {x=ent.position.x, y=ent.position.y}
		return obj.beamPosA
	elseif ent.direction == defines.direction.west then
		obj.beamPosA = {x=ent.position.x-0.2, y=ent.position.y-0.2}
		return obj.beamPosA
	end
	return ent.position
end

-- Return where the Beam end must be positioned --
function EL.getBeamPositionB(obj)
	local ent = obj.ent
	local fPosX = nil
	local fPosY = nil
	if valid(obj.focusedObj) then
		fPosX = obj.focusedObj.ent.position.x
		fPosY = obj.focusedObj.ent.position.y
	end
	if ent.direction == defines.direction.north then
		obj.beamPosB = {x=obj.beamPosA.x, y= fPosY or (obj.beamPosA.y - 64)}
		return obj.beamPosB
	elseif ent.direction ==  defines.direction.east then
		obj.beamPosB = {x= fPosX or (obj.beamPosA.x + 64), y=obj.beamPosA.y}
		return obj.beamPosB
	elseif ent.direction ==  defines.direction.south then
		obj.beamPosB = {x=obj.beamPosA.x, y= fPosY or (obj.beamPosA.y + 64)}
		return obj.beamPosB
	elseif ent.direction == defines.direction.west then
		obj.beamPosB = {x= fPosX or (obj.beamPosA.x - 64), y=obj.beamPosA.y}
		return obj.beamPosB
	end
	return ent.position
end

-- Return the Check Area --
function EL.getCheckErea(obj)
	local ent = obj.ent
	if ent.direction == defines.direction.north then
		return {{ent.position.x-0.5, ent.position.y-64},{ent.position.x+0.5, ent.position.y-1}}
	elseif ent.direction ==  defines.direction.east then
		return {{ent.position.x+1, ent.position.y-0.5},{ent.position.x+64, ent.position.y+0.5}}
	elseif ent.direction ==  defines.direction.south then
		return {{ent.position.x-0.5, ent.position.y+1},{ent.position.x+0.5, ent.position.y+64}}
	elseif ent.direction == defines.direction.west then
		return {{ent.position.x-64, ent.position.y-0.5},{ent.position.x-1, ent.position.y+0.5}}
	end
	return {{0,0},{0,0}}
end