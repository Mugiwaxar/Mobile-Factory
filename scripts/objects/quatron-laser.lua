-- QUATRON LASER OBJECT --

-- Create the Energy Laser base Object --
QL = {
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
function QL:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = QL
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	UpSys.addObj(t)
	-- Create the Beam --
	t.beam = t.ent.surface.create_entity{name="IddleBeam", position= QL.getBeamPositionA(t), target_position=QL.getBeamPositionB(t), source=QL.getBeamPositionA(t)}
	return t
end

-- Reconstructor --
function QL:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = QL
	setmetatable(object, mt)
end

-- Destructor --
function QL:remove()
	-- Remove the Beam --
	if self.beam ~= nil and self.beam.valid == true then
		self.beam.destroy()
	end
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function QL:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function QL:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end

	-- Look for Quatron from neighboring Cubes --
	self:findQuatron()

	-- Send Quatron to the Focused Entity --
	self:sendQuatron()

	-- Look for an Entity to recharge --
	if self.checkTick < game.tick - self.lastCheck then
		self.lastCheck = game.tick
		self:findEntity()
	end

end

-- Tooltip Infos --
function QL:getTooltipInfos(GUI)
end

-- Look for Energy from neighboring Cubes --
function QL:findQuatron()

	-- Check the Entity --
	if self.ent == nil or self.ent.valid == false then return end

	-- Get all Accumulator arount --
	local area = {{self.ent.position.x-1.5, self.ent.position.y-1.5},{self.ent.position.x+1.5,self.ent.position.y+1.5}}
	local ents = self.ent.surface.find_entities_filtered{area=area, type="accumulator"}

	-- Check all Accumulator --
	for k, ent in pairs(ents) do
		-- Look for valid Energy Cube --
		if ent ~= nil and ent.valid == true and ent ~= self.ent and _mfQuatronCubes[ent.name] == true then
			local obj = global.entsTable[ent.unit_number]
			if obj ~= nil and obj.ent ~= nil and obj.ent.valid == true then
				if self:quatron() < self:maxQuatron() then
					-- Calcule max flow --
					local amount = self:maxQuatron() - self:quatron()
					local maxEnergyTranfer = math.min(amount, obj:quatron(), self:maxInput()*self.updateTick, obj:maxOutput()*self.updateTick)
					-- Transfer Energy --
					local transfered = self:addQuatron(maxEnergyTranfer)
					-- Remove Energy --
					obj:removeQuatron(transfered)
				end
			end
		end
	end

end

-- Send Quatron to the Focused Entity --
function QL:sendQuatron()

	-- Check the Entity --
	local obj = self.focusedObj
	if obj ~= nil and obj.ent ~= nil and obj.ent.valid == true and string.match(obj.ent.name, "MobileFactory") then obj = obj.internalQuatronObj end
	if obj == nil or obj.ent == nil or obj.ent.valid == false or obj:quatron() >= obj:maxQuatron() or self:quatron() <= 0 then return end

	-- Send Energy to the Entity --
	local amount = math.min(self:quatron(), self:maxOutput()*self.updateTick, (obj:maxQuatron() - obj:quatron()), obj:maxInput()*self.updateTick)
	if amount > 0  then
		-- Remove the Energy --
		self:removeQuatron(amount)
		-- Add the Energy --
		obj:addQuatron(amount)
		-- Create the Beam --
		-- self.beam.destroy()
		-- self.beam = self.ent.surface.create_entity{name="MK1QuatronConnectedBeam", position= QL.getBeamPositionA(self), target_position=QL.getBeamPositionB(self), source=QL.getBeamPositionA(self)}
		self.ent.surface.create_entity{name="MK1QuatronSendBeam", duration=5, position= QL.getBeamPositionA(self), target_position=QL.getBeamPositionB(self), source=QL.getBeamPositionA(self)}
	end
end

-- Look for an Entity to recharge --
function QL:findEntity()

	-- Save Remove the Focused Entity --
	local oldObj = self.focusedObj
	self.focusedObj = nil

	-- Get all Entities inside the Area to scan --
	local area = QL.getCheckErea(self)
	local ents = self.ent.surface.find_entities_filtered{area=area}

	-- Get the closest --
	for k, ent in pairs(ents) do
		local obj = global.entsTable[ent.unit_number]
		if obj ~= nil and obj.ent ~= nil and obj.ent.valid == true and (obj.addQuatron ~= nil or string.match(obj.ent.name, "MobileFactory")) then
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
		self.beam = self.ent.surface.create_entity{name="IddleBeam", position= QL.getBeamPositionA(self), target_position=QL.getBeamPositionB(self), source=QL.getBeamPositionA(self)}
	elseif oldObj ~= nil and oldObj.ent ~= nil and oldObj.ent.valid == true and oldObj ~= self.focusedObj then
		self.beam.destroy()
		self.beam = self.ent.surface.create_entity{name="MK1QuatronConnectedBeam", position= QL.getBeamPositionA(self), target_position=QL.getBeamPositionB(self), source=QL.getBeamPositionA(self)}
	elseif self.focusedObj ~= nil and self.focusedObj.ent ~= nil and self.focusedObj.ent.valid == true then
		self.beam.destroy()
		self.beam = self.ent.surface.create_entity{name="MK1QuatronConnectedBeam", position= QL.getBeamPositionA(self), target_position=QL.getBeamPositionB(self), source=QL.getBeamPositionA(self)}
	end

end

-- Return the amount of Quatron --
function QL:quatron()
	if self.ent ~= nil and self.ent.valid == true then
		-- Only Act If EL Has More Than 100 J -- 
		if self.ent.energy < 100 then return 0 end
		return self.ent.energy
	end
	return 0
end

-- Return the Quatron Buffer size --
function QL:maxQuatron()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.prototype.energy_usage
	end
	return 1
end

-- Add Quatron (Return the amount added) --
function QL:addQuatron(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local added = math.min(amount, self:maxQuatron() - self:quatron())
		self.ent.energy = self.ent.energy + added
		return added
	end
	return 0
end

-- Remove Quatron (Return the amount removed) --
function QL:removeQuatron(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local removed = math.min(amount, self:quatron())
		self.ent.energy = self.ent.energy - removed
		return removed
	end
	return 0
end

-- Return the max input flow --
function QL:maxInput()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.prototype.energy_usage
	end
	return 0
end

-- Return the max output flow --
function QL:maxOutput()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.prototype.energy_usage
	end
	return 0
end

-- Return where the Beam start must be positioned --
function QL.getBeamPositionA(obj)
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
function QL.getBeamPositionB(obj)
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
function QL.getCheckErea(obj)
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