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
	inventoryTemperature = 15,
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
	if t.MF and t.MF.dataNetwork then
		t.MF.dataNetwork.DTKTable[object.unit_number] = t
	end
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
	-- Remove from the Update System --
	UpSys.removeObj(self)
	-- Remove from the MF Object --
	self.MF.dataNetwork.DTKTable[self.ent.unit_number] = nil
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

-- Item Tags to Content --
function DTK:itemTagsToContent(tags)
	self.inventoryFluid = tags.inventoryFluid or nil
	self.inventoryCount = tags.inventoryCount or 0
	self.filter = tags.filter or nil
	self.inventoryTemperature = tags.inventoryTemperature or 15
end

-- Content to Item Tags --
function DTK:contentToItemTags(tags)
	if self.inventoryFluid ~= nil or self.filter ~= nil then
		tags.set_tag("Infos", {inventoryFluid=self.inventoryFluid, inventoryCount=self.inventoryCount, filter=self.filter, inventoryTemperature=self.inventoryTemperature})
		tags.custom_description = {"", tags.prototype.localised_description, {"item-description.DeepTankC", self.inventoryFluid or self.filter, self.inventoryCount or 0, self.inventoryTemperature or 15}}
	end
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
	if self.inventoryFluid ~= nil and game.fluid_prototypes[self.inventoryFluid] == nil then
		self.inventoryFluid = nil
		self.inventoryCount = 0
		self.inventoryTemperature = 0
		return
	end

	-- Remove the Fluid Filter if it doesn't exist anymore --
	if self.filter ~= nil and game.fluid_prototypes[self.filter] == nil then
		self.filter = nil
		return
	end
	
	-- Display the Item Icon --
	if self.inventoryFluid == nil and self.filter == nil then return end
	local sprite = "fluid/" .. (self.inventoryFluid or self.filter)
	rendering.draw_sprite{sprite=sprite, target=self.ent, surface=self.ent.surface, time_to_live=self.updateTick + 1, target_offset={0,-0.35}, render_layer=131}
end

-- Tooltip Infos --
function DTK:getTooltipInfos(GUIObj, gui, justCreated)

	-- Get the Flow --
	local inventoryFlow = GUIObj.InventoryFlow

	if justCreated == true then

		-- Create the Inventory Title --
		local inventoryTitle = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Inventory"}, _mfOrange)
		inventoryFlow = GUIObj:addFlow("InventoryFlow", inventoryTitle, "vertical", true)

		-- Create the Settings Title --
		local settingTitle = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Settings"}, _mfOrange)

		-- Create the Filter Selection Label and Filter --
		GUIObj:addLabel("", settingTitle, {"gui-description.ChangeFilter"}, _mfOrange)
		GUIObj:addFilter("TF" .. tostring(self.ent.unit_number), settingTitle, {"gui-description.FilterSelect"}, true, "fluid", 40)

	end

	-- Clear the Flow --
	inventoryFlow.clear()

	-- Create the Fluid Frame --
	if self.inventoryFluid ~= nil or self.filter ~= nil then
		Util.fluidToFrame(self.inventoryFluid or self.filter, self.inventoryCount or 0, GUIObj, inventoryFlow)
	end

	-- Create the Fluid Name Label --
	local fluidName = Util.getLocFluidName(self.inventoryFluid) or Util.getLocFluidName(self.filter) or {"gui-description.Empty"}
	GUIObj:addDualLabel(inventoryFlow, {"", {"gui-description.FluidName"}, ":"}, fluidName, _mfOrange, _mfGreen)

	-- Create the Fluid Amount Label --
	local fluidAmount = self.inventoryCount or 0
	GUIObj:addDualLabel(inventoryFlow, {"", {"gui-description.Amount"}, ":"}, Util.toRNumber(fluidAmount) .. "/" .. Util.toRNumber(_dtMaxFluid), _mfOrange, _mfGreen, nil, nil, fluidAmount .. "/" .. _dtMaxFluid)

	-- Create the Filter Label --
	local filterName = Util.getLocFluidName(self.filter) or {"gui-description.None"}
	GUIObj:addDualLabel(inventoryFlow, {"", {"gui-description.Filter"}, ":"}, filterName, _mfOrange, _mfGreen)

	-- Update the Filter --
	if game.fluid_prototypes[self.filter] ~= nil and GUIObj["TF" .. tostring(self.ent.unit_number)] ~= nil then
		GUIObj["TF" .. tostring(self.ent.unit_number)].elem_value = self.filter
	end

end

-- Return the Fluid count present inside the Inventory --
function DTK:hasFluid(name)
	if self.inventoryFluid ~= nil and self.inventoryFluid == name then
		return self.inventoryCount
	end
	return 0
end

-- Return if the Fluid can be accepted --
function DTK:canAccept(fluid)
	if self.filter == nil then return false end
	if self.filter ~= nil and self.filter ~= fluid.name then return false end
    if self.inventoryFluid ~= nil and self.inventoryFluid ~= fluid.name then return false end
	if self.inventoryCount >= _dtMaxFluid then return false end
	if fluid.amount ~= nil and fluid.amount > _dtMaxFluid - self.inventoryCount then return false end
	return true
end

-- Add Fluid --
function DTK:addFluid(fluid)
	if self:canAccept(fluid) == true then
        self.inventoryFluid = fluid.name
        local maxAdded = _dtMaxFluid - self.inventoryCount
        local added = math.min(fluid.amount, maxAdded)
		-- fluid.temperature should always be non-nil, 15 is default temperature
		self.inventoryTemperature = (self.inventoryTemperature * self.inventoryCount + added * fluid.temperature) / (self.inventoryCount + added)
		self.inventoryCount = self.inventoryCount + added
		return added
	end
	return 0
end

-- Remove Items --
function DTK:getFluid(fluid)
	if self.inventoryFluid ~= nil and self.inventoryFluid == fluid.name then
		local removed = math.min(fluid.amount, self.inventoryCount)
		self.inventoryCount = self.inventoryCount - removed
		if self.inventoryCount == 0 then self.inventoryFluid = nil end
	end
	return 0
end

-- Settings To Blueprint Tags --
function DTK:settingsToBlueprintTags()
	local tags = {}
	tags["selfFilter"] = self.filter
	return tags
end

-- Blueprint Tags To Settings --
function DTK:blueprintTagsToSettings(tags)
	self.filter = tags["selfFilter"]
end