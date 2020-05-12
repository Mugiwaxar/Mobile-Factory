-- CONSTRUCTION JET --

-- Create the Construction Jet base Object --
CJ = {
	ent = nil,
	player = "",
	MF = nil,
	updateTick = 60,
	lastUpdate = 0,
	target = nil,
	currentOrder = "Created", -- Created - GoEnt - Build - GoMF - EnterMF --
	inventoryItem = nil,
	invalidStructure = false,
	MFFull = false,
	MFNotFound = false,
	TargetInventoryFull = false
}

-- Constructor --
function CJ:new(object, target)
	if object == nil then return end
	if target == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = CJ
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.target = target
	if target.mission == "Construct" then
		t.inventoryItem = target.item
	end
	UpSys.addObj(t)
	t:update()
	return t
end

-- Reconstructor --
function CJ:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = CJ
	setmetatable(object, mt)
end

-- Destructor --
function CJ:remove()
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function CJ:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function CJ:update()
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
		if self.target.mission == "Construct" then
			self:build()
		elseif self.target.mission == "Deconstruct" then
			self:deconstruct()
		end
		return
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
function CJ:getTooltipInfos(GUIObj, gui, justCreated)

	-- Clear the GUI --
	gui.clear()

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
	if self.target ~= nil then
		GUIObj:addDualLabel(frame, {"", {"gui-description.Mission"}, ": "}, {"", {"gui-description." .. self.target.mission}, " ", {"entity-name." .. self.target.name}}, _mfOrange, _mfGreen)
	end

	-- Create the Invalid Structure Label --
	if self.invalidStructure == true then
		GUIObj:addLabel("", frame, {"gui-description.InvalidStructure"}, _mfRed)
	end

	-- Create the Inventory Full Label --
	if self.TargetInventoryFull == true then
		GUIObj:addLabel("", frame, {"gui-description.TargetInventoryFull"}, _mfRed)
	end

	-- Create the Inventory Title --
	local invFrame = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Inventory"}, _mfOrange)

	-- Create the Items Table --
	local table = GUIObj:addTable("", invFrame, 5)

	-- Create the Inventory List --
	if self.inventoryItem ~= nil then
		-- Check the Item --
		if self.inventoryItem == nil or game.item_prototypes[self.inventoryItem] == nil then goto continue end
		-- Create the Button
		Util.itemToFrame(self.inventoryItem, 1, GUIObj, table)
		::continue::
	end
	
end

-- Is the Jet Iddle ? --
function CJ:isIddle()
	if self.ent.command == nil then return true end
	if self.ent.command.type ~= 6 and self.ent.command.type ~= 9 then
		return false
	end
	return true
end

-- Go to the Structure --
function CJ:goEnt()
	-- Check the Structure --
	if self.target.mission == "Construct" and (self.target.ent == nil or self.target.ent.valid == false) then
		self:goMF()
		return
	end
	if self.target.mission == "Deconstruct" and (self.target.ent == nil or self.target.ent.valid == false or self.target.ent.to_be_deconstructed == false) then
		self:goMF()
		return
	end
	-- Go to the Structure --
	self.ent.set_command({type=defines.command.go_to_location, destination_entity=self.target.ent, radius=2})
	self.currentOrder = "GoEnt"
end

-- Build the Structure --
function CJ:build()
	-- Check the Structure --
	if self.target.ent == nil or self.target.ent.valid == false then
		self:goMF()
		return
	end
	self.currentOrder = "Build"
	self.ent.set_command({type=defines.command.stop})
--[[
	-- Destroy the Gost --
	self.target.ent.destroy()
--]]
	-- Revive the Ghost (Preserves recipes, modules, etc) --
	local _, ent = self.target.ent.revive({raise_revive = true})
	-- Empty the Inventory --
	self.inventoryItem = nil
	-- Make the Beam --
	if ent then -- a ghost can be placed underneath a cliff... one exception where the ghost won't be revived correctly
		self.ent.surface.create_entity{name="GreenBeam", duration=15, position=self.ent.position, target=ent.position, source=self.ent.position}
	end
	-- Return to the Mobile Factory --
	self:goMF()
end

-- Remove the Structure --
function CJ:deconstruct()
	if self.target.ent == nil or self.target.ent.valid == false or self.target.ent.to_be_deconstructed(self.target.ent.force) == false then
		self:goMF()
		return
	end
	self.currentOrder = "Build"
	-- Add the Item inside the Inventory --
	self.inventoryItem = self.target.ent.prototype.items_to_place_this[1].name
	-- Raise the Event --
	script.raise_event(defines.events.script_raised_destroy, {entity=self.target.ent})
	-- Make the Beam --
	self.ent.surface.create_entity{name="GreenBeam", duration=15, position=self.ent.position, target=self.target.ent.position, source=self.ent.position}
	-- Destroy the Structure --
	self.target.ent.destroy()
	-- Return to the Mobile Factory --
	self:goMF()
end

-- Go Back to the Mobile Factory --
function CJ:goMF()
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
function CJ:enterMF()
	-- Check if the Mobile Factory is still valid --
	if self.MF.ent == nil or self.MF.ent.valid == false then
		-- Say the Mobile Factory is not found --
		self.MFNotFound = true
		return
	else
		self.MFNotFound = false
	end
	self.currentOrder = "EnterMF"
	
	-- Empty the Inventory --
	if self.inventoryItem ~= nil then
		local added = self.MF.II:addItem(self.inventoryItem, 1)
		-- Check if the Inventory was stored --
		if added <= 0 then
			self.TargetInventoryFull = true
			return
		else
			self.TargetInventoryFull = false
			self.inventoryItem = nil
			-- Create the Laser --
			self.ent.surface.create_entity{name="GreenBeam", duration=12, position=self.ent.position, target=self.MF.ent.position, source=self.ent.position}
		end		
	end
	
	-- Get the Mobile Factory Trunk --
	local inv = self.MF.ent.get_inventory(defines.inventory.car_trunk)
	
	-- Check the Inventory --
	if inv == nil or inv.valid == false then return end
	
	-- Stock the Jet --
	local stocked = inv.insert({name="ConstructionJet", count=1})
	
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















