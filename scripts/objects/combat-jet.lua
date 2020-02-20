-- COMBAT JET --

-- Create the Combat Jet base Object --
CBJ = {
	ent = nil,
	player = "",
	MF = nil,
	updateTick = 60,
	lastUpdate = 0,
	target = nil,
	currentOrder = "Created", -- Created - GoEnt - Fight - GoMF - EnterMF --
	MFFull = false,
	MFNotFound = false
}

-- Constructor --
function CBJ:new(object, target)
	if object == nil then return end
	if target == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = CBJ
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
function CBJ:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = CBJ
	setmetatable(object, mt)
end

-- Destructor --
function CBJ:remove()
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function CBJ:valid()
	if self.ent ~= nil and self.ent.valid == true then return true end
	return false
end

-- Update --
function CBJ:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
    end


	-- Give a command to the Jet --
	if self.ent.health <= 600 and self.currentOrder == "Fight" then
        self:goMF(defines.distraction.none)
        return
    end
	if self.currentOrder == "Created" then
		self:fight()
		return
    end
    if self.currentOrder == "Fight" and self:isIddle() == true then
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
function CBJ:getTooltipInfos(GUI)

	-- Create the Belongs to Label --
	local belongsToL = GUI.add{type="label", caption={"", {"gui-description.BelongsTo"}, ": ", self.player}}
	belongsToL.style.font = "LabelFont"
	belongsToL.style.font_color = _mfOrange

	-- Create the Current Work Label --
	local work = GUI.add{type="label", caption={"", {"gui-description." .. self.currentOrder}}}
	work.style.font = "LabelFont"
	work.style.font_color = _mfBlue
    
    -- Create the Mission Label --
	if self.target ~= nil then
		local mission = GUI.add{type="label", caption={"",{"gui-description.Defend"}, ": {", self.target.x, ";", self.target.y, "}"}}
		mission.style.font = "LabelFont"
		mission.style.font_color = _mfGreen
	end
	
	-- Create the Mobile Factory Full Label --
	if self.MFFull == true then
		local mfFull = GUI.add{type="label", caption={"", {"gui-description.MFTrunkFull"}}}
		mfFull.style.font = "LabelFont"
		mfFull.style.font_color = _mfRed
	end
	
	-- Create the Mobile Factory No Found Label --
	if self.MFNotFound == true then
		local mfNoFound = GUI.add{type="label", caption={"", {"gui-description.MFNotFound"}}}
		mfNoFound.style.font = "LabelFont"
		mfNoFound.style.font_color = _mfRed
	end
end

-- Is the Jet Iddle ? --
function CBJ:isIddle()
	if self.ent.command == nil then return true end
	if self.ent.command.type ~= 6 and self.ent.command.type ~= 9 then
		return false
	end
	return true
end

-- Go to the Position --
function CBJ:fight()
    -- Check the Target --
    if self.target == nil then return end
    -- Fight --
    self.ent.set_command({type=defines.command.attack_area, destination=self.target, radius=self.MF.varTable.jets.cbjMaxDistance})
    self.currentOrder = "Fight"
end

-- Go Back to the Mobile Factory --
function CBJ:goMF(distraction)
	-- Check if the Mobile Factory is still valid --
	if self.MF.ent == nil or self.MF.ent.valid == false then
		-- Say the Mobile Factory is not found --
		self.MFNotFound = true
		return
	else
		self.MFNotFound = false
	end
	-- Return to the Mobile Factory --
	self.ent.set_command({type=defines.command.go_to_location, destination_entity=self.MF.ent, radius=1, distraction=distraction})
	self.currentOrder = "GoMF"
end

-- Enter the Mobile Factory --
function CBJ:enterMF()
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
	local stocked = inv.insert({name="CombatJet", count=1})
	
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