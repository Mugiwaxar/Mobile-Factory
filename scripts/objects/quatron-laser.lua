-- QUATRON LASER OBJECT --

-- Create the Quatron Laser base Object --
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
	focusedObj = nil,
	quatronCharge = 0,
	quatronLevel = 1,
	quatronMax = 0,
	quatronMaxInput = 0,
	quatronMaxOutput = 0
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
	-- Get prototype data
	t.quatronCharge = object.energy
	t.quatronMax = object.electric_buffer_size
	t.quatronMaxInput = object.electric_buffer_size
	-- Create the Beam --
	t:getBeamPosition()
	t.beam = object.surface.create_entity{name="IddleBeam", position=t.beamPosA, target_position=t.beamPosB, source=t.beamPosA}
	UpSys.addObj(t)
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

	-- Update Quatron indication
	self.ent.energy = self.quatronCharge

	-- Look for an Entity to recharge --
	if self.checkTick < game.tick - self.lastCheck then
		self.lastCheck = game.tick
		self:findEntity()
	end

	-- Only Act If QL Has More Than 100 J --
	if self.quatronCharge < 100 then return end

	-- Send Quatron to the Focused Entity --
	self:sendQuatron()
end

-- Tooltip Infos --
function QL:getTooltipInfos(GUIObj, gui, justCreated)

	-- Get the Flow --
	local informationFlow = GUIObj.InformationFlow

	if justCreated == true then
		-- Create the Information Title --
		local informationTitle = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Information"}, _mfOrange)
		informationFlow = GUIObj:addFlow("InformationFlow", informationTitle, "vertical", true)
	end

	-- Clear the Flow --
	informationFlow.clear()

	-- Create the Quatron Charge --
	GUIObj:addDualLabel(informationFlow, {"", {"gui-description.Charge"}, ": "}, math.floor(self.quatronCharge), _mfOrange, _mfGreen)
	GUIObj:addProgressBar("", informationFlow, "", "", false, _mfPurple, self.quatronCharge/self.quatronMax, 100)

	-- Create the Quatron Purity --
	GUIObj:addDualLabel(informationFlow, {"", {"gui-description.Purity"}, ": "}, string.format("%.3f", self.quatronLevel), _mfOrange, _mfGreen)
	GUIObj:addProgressBar("", informationFlow, "", "", false, _mfPurple, self.quatronLevel/20, 100)
end

-- Send Quatron to the Focused Entity --
function QL:sendQuatron()
	-- Check the Entity --
	local obj = self.focusedObj
	-- Internal cubes can be valid, but still nil
	if valid(obj) == false or obj.ent == nil then return end
	if string.match(obj.ent.name, "MobileFactory") then obj = obj.internalQuatronObj end
	if obj.quatronCharge >= obj.quatronMax then return end

	-- Send Quatron to the Entity --
	local quatronTransfer = math.min(self.quatronCharge, obj.quatronMax - obj.quatronCharge, obj.quatronMaxInput)
	if quatronTransfer > 0 then
		-- Add the Quatron --
		obj:addQuatron(quatronTransfer, self.quatronLevel)
		-- Remove Quatron --
		self.quatronCharge = self.quatronCharge - quatronTransfer
		-- Create the Beam --
		self.ent.surface.create_entity{name="MK1QuatronSendBeam", duration=5, position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
	end
end

-- Look for an Entity to recharge --
function QL:findEntity()
	-- Save and Remove the Focused Entity --
	local oldFocus = self.focusedObj
	local newFocus = nil

	-- Get all Entities inside the Area to scan --
	local area = self:getCheckArea()
	local ents = self.ent.surface.find_entities_filtered{area=area, name=_mfQuatronAndMF}

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
	if oldFocus ~= nil and newFocus ~= nil and oldFocus.entID == newFocus.entID then return end

	-- Create the new Beam --
	self:getBeamPosition()
	if self.focusedObj == nil then
		self.beam.destroy()
		self.beam = self.ent.surface.create_entity{name="IddleBeam", position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
	else
		self.beam.destroy()
		self.beam = self.ent.surface.create_entity{name="MK1QuatronConnectedBeam", position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
	end
end

-- Return the amount of Quatron --
function QL:quatron()
	return self.quatronCharge
end

-- Return the Quatron Buffer size --
function QL:maxQuatron()
	return self.quatronMax
end

-- Add Quatron (Return the amount added) --
function QL:addQuatron(amount, level)
	local added = math.min(amount, self.quatronMax - self.quatronCharge)
	if self.quatronCharge > 0 then
		mixQuatron(self, added, level)
	else
		self.quatronCharge = added
		self.quatronLevel = level
	end
	return added
end

-- Remove Quatron (Return the amount removed) --
function QL:removeQuatron(amount)
	local removed = math.min(amount, self.quatronCharge)
	self.quatronCharge = self.quatronCharge - removed
	return removed
end

-- Return the max input flow --
function QL:maxInput()
	return self.quatronMaxInput
end

-- Return the max output flow --
function QL:maxOutput()
	return self.quatronMaxOutput
end

-- Return where the Beam end must be positioned --
function QL:getBeamPosition()
	local pos = self.ent.position
	local dir = self.ent.direction
	local fPosX = nil
	local fPosY = nil
	if valid(self.focusedObj) then
		fPosX = self.focusedObj.ent.position.x
		fPosY = self.focusedObj.ent.position.y
	end
	if dir == defines.direction.north then
		self.beamPosA = {x = pos.x, y = pos.y - 0.5}
		self.beamPosB = {x = pos.x, y = (fPosY or (pos.y - 64)) - 0.5}
	elseif dir == defines.direction.east then
		self.beamPosA = {x = pos.x + 0.2, y = pos.y - 0.2}
		self.beamPosB = {x = (fPosX or (pos.x + 64)) + 0.2, y = pos.y - 0.2}
	elseif dir ==  defines.direction.south then
		self.beamPosA = {x = pos.x, y = pos.y}
		self.beamPosB = {x = pos.x, y = fPosY or (pos.y + 64)}
	elseif dir == defines.direction.west then
		self.beamPosA = {x = pos.x - 0.2, y = pos.y - 0.2}
		self.beamPosB = {x = (fPosX or (pos.x - 64)) - 0.2, y = pos.y - 0.2}
	else
		self.beamPosA = pos
		self.beamPosB = pos
	end
end

-- Return the Check Area --
function QL:getCheckArea()
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