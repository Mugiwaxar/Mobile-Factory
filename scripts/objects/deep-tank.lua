-- DEEP TANK OBJECT --

-- Create the Deep Tank base object --
DTK = {
	ent = nil,
	player = "",
	MF = nil,
	updateTick = 80,
	lastUpdate = 0,
	inventoryFluid = nil,
	inventoryCount = 0,
	ID = 0,
	filter = nil
}

-- Constructor --
function DTK:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DTK
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.ID = Util.getEntID(global.deepTankTable)
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function DTK:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = DTK
	setmetatable(object, mt)
end

-- Destructor --
function DTK:remove()
end

-- Is valid --
function DTK:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Copy Settings --
function DTK:copySettings(obj)
	self.filter = obj.filter
end

-- Update --
function DTK:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end
	
	-- Remove the Fluid if it doesn't exist anymore --
	if game.fluid_prototypes[self.inventoryFluid] == nil then
		self.inventoryFluid = nil
		self.inventoryCount = 0
		return
	end
	
	-- Display the Item Icon --
	if self.inventoryFluid == nil then return end
	local sprite = "fluid/" .. self.inventoryFluid
	rendering.draw_sprite{sprite=sprite, target=self.ent, surface=self.ent.surface, time_to_live=self.updateTick + 1, target_offset={0,-0.35}, render_layer=131}
end

-- Tooltip Infos --
function DTK:getTooltipInfos(GUI)

	-- Create the Belongs to Label --
	local belongsToL = GUI.add{type="label", caption={"", {"gui-description.BelongsTo"}, ": ", self.player}}
	belongsToL.style.font = "LabelFont"
	belongsToL.style.font_color = _mfOrange

	-- Create the ID label --
	local IDL = GUI.add{type="label"}
	IDL.style.font = "LabelFont"
	IDL.caption = {"", {"gui-description.DeepTank"}, ": ", tostring(self.ID)}
	IDL.style.font_color = {92, 232, 54}

	-- Create the Inventory List --
	if self.inventoryFluid ~= nil and self.inventoryCount > 0 then
		Util.fluidToFrame(self.inventoryFluid, self.inventoryCount, GUI)
	end

	-- Create the Filter Display --
	if self.filter ~= nil and game.fluid_prototypes[self.filter] ~= nil then
		local fDisplayL = GUI.add{type="label"}
		fDisplayL.style.font = "LabelFont"
		fDisplayL.caption = {"", {"gui-description.Filter"}, ": "}
		fDisplayL.style.font_color = {92, 232, 54}
		fDisplayL.style.top_margin = 10

		local sprite = "fluid/" .. self.filter
		local fDisplayI = GUI.add{type="sprite", sprite=sprite}
		fDisplayI.tooltip = self.filter
	end

	if canModify(getPlayer(GUI.player_index).name, self.ent) == false then return end

	-- Add the Set Filter Button --
	local fButton = GUI.add{type="button", name = "MFInfos", caption={"", {"gui-description.SetFilter"}}}
	fButton.style.width = 100

end

-- Return the Fluid count present inside the Inventory --
function DTK:hasFluid(name)
	if self.inventoryFluid ~= nil and self.inventoryFluid == name then
		return self.inventoryCount
	end
	return 0
end

-- Return if the Fluid can be accepted --
function DTK:canAccept(name)
	if self.filter == nil then return false end
	if self.filter ~= nil and self.filter ~= name then return false end
    if self.inventoryFluid ~= nil and self.inventoryFluid ~= name then return false end
    if self.inventoryCount >= _dtMaxFluid then return false end
	return true
end

-- Add Items --
function DTK:addFluid(name, count)
	if self:canAccept(name) == true then
        self.inventoryFluid = name
        local maxAdded = _dtMaxFluid - self.inventoryCount
        local added = math.min(count, maxAdded)
		self.inventoryCount = self.inventoryCount + added
		return added
	end
	return 0
end

-- Remove Items --
function DTK:getFluid(name, count)
	if self.inventoryFluid ~= nil and self.inventoryFluid == name then
		local removed = math.min(count, self.inventoryCount)
		self.inventoryCount = self.inventoryCount - removed
		if self.inventoryCount == 0 then self.inventoryFluid = nil end
	end
	return 0
end