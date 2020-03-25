-- Repair Jet --

-- Create the Repair Jet base Object --
RJ = {
	ent = nil,
	player = "",
	MF = nil,
	updateTick = 60,
	lastUpdate = 0,
	target = nil,
	currentOrder = "Created", -- Created - GoEnt - Repair - GoMF - EnterMF --
	invalidStructure = false,
	MFFull = false,
	MFNotFound = false,
	isRepairing = false
}

-- Constructor --
function RJ:new(object, target)
	if object == nil then return end
	if target == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = RJ
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.target = target
	UpSys.addObj(t)
	t:update()
	return t
end

-- Reconstructor --
function RJ:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = RJ
	setmetatable(object, mt)
end

-- Destructor --
function RJ:remove()
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function RJ:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function RJ:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end
	
	-- Give a command to the Jet --
	if self.currentOrder == "Created" then
		self:goEnt()
		return
	end
	if self.currentOrder == "GoEnt" and self:isIddle() == true then
		self:repair()
	end
	if self.currentOrder == "Repair" and self.isRepairing == true then
		self:repair()
	end
	if self.currentOrder == "Build" and self:isIddle() == true then
		self:goMF()
		return
	end
	if self.currentOrder == "GoMF" and self:isIddle() == true then
		self:enterMF()
		return
	end
	if self.currentOrder == "EnterMF" and self:isIddle() == true then
		self:enterMF()
		return
	end
end

-- Tooltip Infos --
function RJ:getTooltipInfos(GUIObj, gui, justCreated)

	-- Create the Title --
	local frame = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Information"}, _mfOrange)

	-- Create the Current Work Label --
	GUIObj:addLabel("", frame, {"gui-description." .. self.currentOrder}, _mfOrange)

	-- Create the Mobile Factory Full Label --
	if self.MFFull == true then
		GUIObj:addLabel("", frame, {"gui-description.MFTrunkFull"}, _mfRed)
	end

	-- Create the Mobile Factory No Found Label --
	if self.MFNotFound == true then
		GUIObj:addLabel("", frame, {"gui-description.MFNotFound"}, _mfRed)
	end

	-- Create the Mission Label --
	if self.target ~= nil and self.target.ent ~= nil and self.target.ent.valid == true then
		GUIObj:addDualLabel(frame, {"", {"gui-description.Mission"}, ": "}, {"", {"gui-description.Repair"}, " ", {"entity-name." .. self.target.ent.name}}, _mfOrange, _mfGreen)
	end

	-- Create the Invalid Structure Label --
	if self.invalidStructure == true then
		GUIObj:addLabel("", frame, {"gui-description.InvalidStructure"}, _mfRed)
	end

end

-- Is the Jet Iddle ? --
function RJ:isIddle()
	if self.ent.command == nil then return true end
	if self.ent.command.type ~= 6 and self.ent.command.type ~= 9 or self.isRepairing == true then
		return false
	end
	return true
end

-- Go to the Structure --
function RJ:goEnt()
	-- Check the Structure --
	if self.target.ent == nil or self.target.ent.valid == false or self.target.ent.health >= self.target.ent.prototype.max_health then
		self:goMF()
		return
	end
	-- Go to the Structure --
	self.ent.set_command({type=defines.command.go_to_location, destination_entity=self.target.ent, radius=2})
	self.currentOrder = "GoEnt"
end

-- Repair the Structure --
function RJ:repair()
	-- Check the Structure --
	if self.target.ent == nil or self.target.ent.valid == false or self.target.ent.health >= self.target.ent.prototype.max_health then
		self:goMF()
		self.isRepairing = false
		return
	end
	-- Make the Beam --
	self.ent.surface.create_entity{name="BlueBeam", duration=15, position=self.ent.position, target=self.target.ent.position, source=self.ent.position}
	-- Repair the Structure --
	self.isRepairing = true
	self.currentOrder = "Repair"
	self.ent.set_command({type=defines.command.stop})
	self.target.ent.damage(_mfHPRepairedPerUpdate, self.ent.force)
end

-- Go Back to the Mobile Factory --
function RJ:goMF()
	-- Check if the Mobile Factory is still valid --
	if self.MF.ent == nil or self.MF.ent.valid == false then
		-- Say the Mobile Factory is not found --
		self.MFNotFound = true
		return
	else
		self.MFNotFound = false
	end
	-- Return to the Mobile Factory --
	self.ent.set_command({type=defines.command.go_to_location, destination_entity=self.MF.ent, radius=1})
	self.currentOrder = "GoMF"
end

-- Enter the Mobile Factory --
function RJ:enterMF()
	-- Check if the Mobile Factory is still valid --
	if self.MF.ent == nil or self.MF.ent.valid == false then
		-- Say the Mobile Factory is not found --
		self.MFNotFound = true
		return
	else
		self.MFNotFound = false
	end
	self.currentOrder = "EnterMF"
	
	-- Get the Mobile Factory Trunk --
	local inv = self.MF.ent.get_inventory(defines.inventory.car_trunk)
	
	-- Check the Inventory --
	if inv == nil or inv.valid == false then return end
	
	-- Stock the Jet --
	local stocked = inv.insert({name="RepairJet", count=1})
	
	-- No enought space inside the Mobile Factory Trunk --
	if stocked == 0 then
		self.MFFull = true
		return
	end
	
	-- Remove the Jet --
	global.constructionJetTable[self.ent.unit_number] = nil
	self:remove()
	self.ent.destroy()
end