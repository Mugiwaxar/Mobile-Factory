-- ENERGY LASER OBJECT --

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
	-- Create the Beam --
	t:getBeamPosition()
	t.beam = object.surface.create_entity{name="IddleBeam", position=t.beamPosA, target_position=t.beamPosB, source=t.beamPosA}
	UpSys.addObj(t)
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

	-- Look for an Entity to recharge --
	if self.checkTick < game.tick - self.lastCheck then
		self.lastCheck = game.tick
		self:findEntity()
	end

	-- Only Act If EL Has More Than 100 kJ --
	if self.ent.energy < 1e5 then return end

	-- Send Energy to the Focused Entity --
	self:sendEnergy()
end

-- Tooltip Infos --
function EL:getTooltipInfos(GUI)
end

-- Send Energy to the Focused Entity --
function EL:sendEnergy()
	-- Check the Entity --
	local obj = self.focusedObj
	-- Internal cubes can be valid, but still nil
	if valid(obj) == false or obj.ent == nil then return end
	if string.match(obj.ent.name, "MobileFactory") then obj = obj.internalEnergyObj end

	local objEnergy = obj.ent.energy
	local objMaxEnergy = obj.ent.electric_buffer_size
	if objEnergy >= objMaxEnergy then return end

	-- Send Energy to the Entity --
	local selfEnergy = self.ent.energy
	local energyTransfer = math.min(selfEnergy, objMaxEnergy - objEnergy, obj:maxInput() * self.updateTick)
	if energyTransfer > 0  then
		-- Remove the Energy --
		self.ent.energy = selfEnergy - energyTransfer
		-- Add the Energy --
		obj.ent.energy = objEnergy + energyTransfer
		-- Create the Beam --
		self.ent.surface.create_entity{name="MK1SendBeam", duration=5, position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
	end
end

-- Look for an Entity to recharge --
function EL:findEntity()
	-- Save and Remove the Focused Entity --
	local oldFocus = self.focusedObj
	local newFocus = nil

	-- Get all Entities inside the Area to scan --
	local area = self:getCheckArea()
	local ents = self.ent.surface.find_entities_filtered{area=area, name=_mfEnergyAndMF}

	local selfPosition = self.ent.position
	local focusedPosition = nil

	-- Get the closest --
	for k, ent in pairs(ents) do
		local obj = global.entsTable[ent.unit_number]
		if obj ~= nil then
			if newFocus == nil or Util.distance(selfPosition, ent.position) < Util.distance(selfPosition, focusedPosition) then
				newFocus = obj
				focusedPosition = newFocus.ent.position
			end
		end
	end
	self.focusedObj = newFocus

	-- Same target --
	if oldFocus ~= nil and newFocus ~= nil and oldFocus.entID == newFocus.entID and string.match(newFocus.ent.name, "MobileFactory") == false then return end

	-- Create the new Beam --
	self:getBeamPosition()
	if self.focusedObj == nil then
		self.beam.destroy()
		self.beam = self.ent.surface.create_entity{name="IddleBeam", position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
	else
		self.beam.destroy()
		self.beam = self.ent.surface.create_entity{name="MK1ConnectedBeam", position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
	end
end

-- Return the amount of Energy --
function EL:energy()
	return self.ent.energy
end

-- Return the Energy Buffer size --
function EL:maxEnergy()
	return self.ent.electric_buffer_size
end

-- Add Energy (Return the amount added) --
function EL:addEnergy(amount)
	local added = math.min(amount, self.ent.electric_buffer_size - self.ent.energy)
	self.ent.energy = self.ent.energy + added
	return added
end

-- Remove Energy (Return the amount removed) --
function EL:removeEnergy(amount)
	local removed = math.min(amount, self.ent.energy)
	self.ent.energy = self.ent.energy - removed
	return removed
end

-- Return the max input flow --
function EL:maxInput()
	return self.ent.electric_buffer_size
end

-- Return the max output flow --
function EL:maxOutput()
	return 0
end

-- Return where the Beam end must be positioned --
function EL:getBeamPosition()
	local pos = self.ent.position
	local dir = self.ent.direction
	local fPosX = nil
	local fPosY = nil
	local entWidth = 0
	local entHeight = 0
	if valid(self.focusedObj) then
		fPosX = self.focusedObj.ent.position.x
		fPosY = self.focusedObj.ent.position.y
		local entBB = self.focusedObj.ent.bounding_box
		entWidth = entBB.right_bottom.x - entBB.left_top.x
		entHeight = entBB.right_bottom.y - entBB.left_top.y
	end
	if dir == defines.direction.north then
		self.beamPosA = {x = pos.x, y = pos.y - 0.5}
		self.beamPosB = {x = pos.x, y = (fPosY or (pos.y - 64)) - 0.5 + entHeight/2}
	elseif dir == defines.direction.east then
		self.beamPosA = {x = pos.x + 0.2, y = pos.y - 0.2}
		self.beamPosB = {x = (fPosX or (pos.x + 64)) + 0.2 - entWidth/2, y = pos.y - 0.2}
	elseif dir ==  defines.direction.south then
		self.beamPosA = {x = pos.x, y = pos.y}
		self.beamPosB = {x = pos.x, y = (fPosY or (pos.y + 64)) - entHeight/2}
	elseif dir == defines.direction.west then
		self.beamPosA = {x = pos.x - 0.2, y = pos.y - 0.2}
		self.beamPosB = {x = (fPosX or (pos.x - 64)) - 0.2 + entWidth/2, y = pos.y - 0.2}
	else
		self.beamPosA = pos
		self.beamPosB = pos
	end
end

-- Return the Check Area --
function EL:getCheckArea()
	local ent = self.ent
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