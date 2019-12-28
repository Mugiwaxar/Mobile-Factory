-- FLUID EXTRACTEUR OBJECT --

FE = {
	ent = nil,
	purity = 0,
	charge = 0,
	totalCharge = 0,
	updateTick = 60,
	lastUpdate = 0
}

-- Constructor --
function FE:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = FE
	t.ent = object
	return t
end

-- Reconstructor --
function FE:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = FE
	setmetatable(object, mt)
end

-- Destructor --
function FE:remove()
end

-- Is valid --
function FE:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function FE:update(event)
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Check if the Fluid Extractor is valid --
	if self:valid() == false then return end
	-- The Fluid Extractor can work only if the Mobile Factory Entity is valid --
	if global.MF.ent == nil or global.MF.ent.valid == false then return end
	-- Extract Fluid --
	self:extractFluids(event)
end

-- Tooltip Infos --
function FE:getTooltipInfos(GUI)
	--------------- Make the Frame ----------------
	local feFrame = GUI.add{type="frame", direction="vertical"}
	feFrame.style.width = 150
	-- Make the Fluid Extractor Frame visible if Fluid Extractor is placed --
		
	-- Create Labels and Bares --
	local nameLabel = feFrame.add{type="label", caption={"", {"gui-description.FluidExtractor"}}}
	local SpeedLabel = feFrame.add{type="label", caption={"", {"gui-description.Speed"}, ": ", self:fluidPerExtraction(), " u/s"}}
	local ChargeLabel = feFrame.add{type="label", caption={"", {"gui-description.Charge"}, ": ", self.charge}}
	local ChargeBar = feFrame.add{type="progressbar", value=self.charge/_mfFEMaxCharge}
	local PurityLabel = feFrame.add{type="label", caption={"", {"gui-description.Purity"}, ": ", self.purity}}
	local PurityBar = feFrame.add{type="progressbar", value=self.purity/100}

	-- Update Style --
	nameLabel.style.font = "LabelFont"
	nameLabel.style.bottom_margin = 7
	SpeedLabel.style.font = "LabelFont"
	ChargeLabel.style.font = "LabelFont"
	PurityLabel.style.font = "LabelFont"
	nameLabel.style.font_color = {108, 114, 229}
	SpeedLabel.style.font_color = {39,239,0}
	ChargeLabel.style.font_color = {39,239,0}
	ChargeBar.style.color = {176,50,176}
	PurityLabel.style.font_color = {39,239,0}
	PurityBar.style.color = {255, 255, 255}
end

-- Add a Quatron Charge --
function FE:addQuatron(level)
	self.totalCharge = self.totalCharge + 1
	self.charge = self.charge + 100
	self.purity = math.ceil(((self.purity * self.totalCharge) + level) / (self.totalCharge + 1))
end

-- Get the number of Fluid per extraction --
function FE:fluidPerExtraction()
	return math.floor(self.purity * _mfFEFluidPerExtraction)
end

-- Get the module ID inside --
function FE:getModuleID()
	-- Test if the Fluid Extractor is valid --
	if self:valid() == false then return true end
	-- Get the Inventory --
	local inventory = self.ent.get_module_inventory()
	-- Test if the Inventory is valid --
	if inventory == nil then return 0 end
	-- Look for the Module --
	local moduleID = inventory[1]
	-- Test if the Module is valid --
	if moduleID == nil then return 0 end
	if moduleID.valid == false then return 0 end
	if moduleID.valid_for_read == false then return 0 end
	-- Look for the Module name --
	local moduleName = moduleID.name
	-- Test if the Module name is valid --
	if moduleName == nil then return 0 end
	-- Look for the ID --
	if string.match(moduleName, "ModuleID") then
		ID = tonumber(string.sub(moduleName, -1))
	end
	-- Test if the ID is valid --
	if ID == nil then return 0 end
	-- Return the ID --
	return ID
end

-- Extract Fluids --
function FE:extractFluids(event)
	-- Get the Module ID --
	local moduleID = self:getModuleID()
	-- Check the ModuleID --
	if moduleID == nil or moduleID == 0 then return end
	-- Check the Quatron Charge --
	if self.charge < 10 then return end
	-- Get the Fluid Path --
	local resource = self.ent.surface.find_entities_filtered{position=self.ent.position, radius=1, type="resource", limit=1}
	resource = resource[1]
	if resource == nil or resource.valid == false then return end
	-- Calcule the amount that can be extracted --
	local amount = math.min(resource.amount, self:fluidPerExtraction())
	-- Find the Focused Tank and Filter --
	if global.tankTable == nil or global.tankTable[moduleID] == nil then return end
	local filter = global.tankTable[moduleID].filter
	local tank = global.tankTable[moduleID].ent
	if filter == nil or tank == nil then return end
	-- Test if the Filter accept this Fluid --
	if resource.name ~= filter then return end
	-- Send the Fluid to the Tank --
	local amountAdded = tank.insert_fluid({name=resource.name, amount=amount})
	-- Test if Fluid was sended --
	if amountAdded > 0 then
		self.charge = self.charge - 10
		-- Make a Beam --
		self.ent.surface.create_entity{name="BigPurpleBeam", duration=59, position=self.ent.position, target=global.MF.ent.position, source=self.ent.position}
		-- Remove amount from the FluidPath --
		resource.amount = math.max(resource.amount - amountAdded, 1)
		-- Remove the FluidPath if amount == 0 --
		if resource.amount < 2 then
			resource.destroy()
		end
	end
end




