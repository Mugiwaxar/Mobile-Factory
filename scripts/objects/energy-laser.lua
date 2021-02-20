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

	-- Send Energy to the Focused Entity --
	self:nextLaser()

end

-- Tooltip Infos --
function EL:getTooltipInfos(GUITable, mainFrame, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.EnergyLaser"}

		-- Create the Information Frame --
		local infoFrame = GAPI.addFrame(GUITable, "InformationFrame", mainFrame, "vertical", true)
		infoFrame.style = "MFFrame1"
		infoFrame.style.vertically_stretchable = true
		infoFrame.style.minimal_width = 200
		infoFrame.style.left_margin = 3
		infoFrame.style.left_padding = 3
		infoFrame.style.right_padding = 3

	end

	-- Get the Frame --
	local infoFrame = GUITable.vars.InformationFrame

	-- Clear the Frame --
	infoFrame.clear()

	-- Create the Tite --
	GAPI.addSubtitle(GUITable, "", infoFrame, {"gui-description.Information"})

	-- Add the Input/Output Speed Label --
	GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.EnergyInputSpeed", Util.toRNumber(EI.speed(self))}, _mfOrange)
	GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.EnergyOutputSpeed", Util.toRNumber(EI.speed(self))}, _mfOrange)

end

-- Look for an Entity to recharge --
function EL:findEntity()

	-- Get all Entities inside the Area to scan --
	local area = self:getCheckArea()
	local ents = self.ent.surface.find_entities_filtered{area=area}

	local selfPosition = self.ent.position
	local nearestEnt = nil

	-- Get the closest Entity --
	for _, ent in pairs(ents) do
		if ent ~= nil and ent.valid == true then
			if (nearestEnt == nil or Util.distance(selfPosition, ent.position) < Util.distance(selfPosition, nearestEnt.position)) and string.match(ent.name, "Beam") == nil then
				nearestEnt = ent
			end
		end
	end

	if nearestEnt ~= nil and global.entsTable[nearestEnt.unit_number] ~= nil and ((_mfEnergyStructures[nearestEnt.name] ~= nil and _mfEnergyStructures[nearestEnt.name].canAccept == true) or string.match(nearestEnt.name, "MobileFactory") or string.match(nearestEnt.name, "EnergyLaser")  ) then
		-- Get the Object --
		local obj = global.entsTable[nearestEnt.unit_number]
		-- Same target --
		if self.focusedObj ~= nil and self.focusedObj.entID == obj.entID and string.match(obj.ent.name, "MobileFactory") == false then return end
		-- Save the Object --
		self.focusedObj = obj
		-- Create the new Beam --
		self:getBeamPosition(obj.ent)
		self.beam.destroy()
		self.beam = self.ent.surface.create_entity{name="MK1ConnectedBeam", position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
	elseif nearestEnt~= nil then
		-- Remove the old focused Entity --
		self.focusedObj = nil
		-- Create the Beam --
		self:getBeamPosition(nearestEnt)
		self.beam.destroy()
		self.beam = self.ent.surface.create_entity{name="IddleBeam", position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
	elseif nearestEnt == nil then
		-- Remove the old focused Entity --
		self.focusedObj = nil
		-- Create the Beam --
		self:getBeamPosition()
		self.beam.destroy()
		self.beam = self.ent.surface.create_entity{name="IddleBeam", position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
	end

end

-- Send Energy to the next Laser --
function EL:nextLaser(lastLaser, eiFound, slowerLaserSpeed)

	-- Get the Receiver --
	local receiver = self.focusedObj

	-- Check the Target --
	if receiver == nil or receiver.ent == nil or receiver.ent.valid == false then return false end

	-- Check if this is a Mobile Factory --
    if string.match(receiver.ent.name, "MobileFactory") then
		receiver = receiver.internalEnergyObj
		if receiver == nil or receiver.valid == false then return false end
	end

	-- Get the Target type --
	local defTable = _mfEnergyStructures[receiver.ent.name]
	if defTable == nil then return false end

	-- Check if this is the First Laser --
	if lastLaser == nil then
		-- Get a EI around --
		local ei = EI.findEIStructures(self, true)
		-- Check the EI --
		if ei == nil or ei.ent == nil or ei.ent.valid == false then return false end
		-- Set this Laser as the slower --
		slowerLaserSpeed = EI.speed(self)
		-- Check the next Target --
		if defTable.canAccept == true then
			local sent = EI.sendEnergy(ei, receiver, slowerLaserSpeed)
			if sent > 0 then
				self.ent.surface.create_entity{name="MK1SendBeam", duration=5, position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
				return true
			end
		elseif string.match(receiver.ent.name, "Laser") then
			if receiver:nextLaser(self, ei, slowerLaserSpeed) then
				self.ent.surface.create_entity{name="MK1SendBeam", duration=5, position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
				return true
			end
		end
	end

	-- If this is not the First Laser --
	if lastLaser ~= nil then
		-- Set if this is the slower Laser --
		slowerLaserSpeed = math.min(slowerLaserSpeed, EI.speed(self))
		-- Check if this is another Laser --
		if defTable.canAccept == true then
			if EI.sendEnergy(eiFound, self.focusedObj, slowerLaserSpeed) > 0 then
				self.ent.surface.create_entity{name="MK1SendBeam", duration=5, position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
				return true
			end
		elseif string.match(self.focusedObj.ent.name, "Laser") then
			if self.focusedObj:nextLaser(self, eiFound, slowerLaserSpeed) == true then
				self.ent.surface.create_entity{name="MK1SendBeam", duration=5, position=self.beamPosA, target_position=self.beamPosB, source=self.beamPosA}
				return true
			end
		end
	end

	return false

end

-- Return where the Beam end must be positioned --
function EL:getBeamPosition(focus)
	local pos = self.ent.position
	local dir = self.ent.direction
	local fPosX = nil
	local fPosY = nil
	local entWidth = 0
	local entHeight = 0
	if focus ~= nil then
		fPosX = focus.position.x
		fPosY = focus.position.y
		local entBB = focus.bounding_box
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