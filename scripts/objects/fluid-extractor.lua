-- FLUID EXTRACTEUR OBJECT --

FE = {
	ent = nil,
	player = "",
	MF = nil,
	purity = 0,
	charge = 0,
	totalCharge = 0,
	updateTick = 60,
	lastUpdate = 0;
	selectedDimTank = nil,
	mfTooFar = false
}

-- Constructor --
function FE:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = FE
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	UpSys.addObj(t)
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
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function FE:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Copy Settings --
function FE:copySettings(obj)
	self.selectedDimTank = obj.selectedDimTank
end

-- Update --
function FE:update(event)
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end
	-- The Fluid Extractor can work only if the Mobile Factory Entity is valid --
	if self.MF.ent == nil or self.MF.ent.valid == false then return end
	-- Check the Surface --
	if self.ent.surface ~= self.MF.ent.surface then return end
	-- Check the Distance --
	if Util.distance(self.ent.position, self.MF.ent.position) > _mfOreCleanerMaxDistance then
		self.MFTooFar = true
	else
		self.MFTooFar = false
		-- Extract Fluid --
		self:extractFluids(event)
	end
end

-- Tooltip Infos --
function FE:getTooltipInfos(GUI)

	--------------- Make the Frame ----------------
	local feFrame = GUI.add{type="frame", direction="vertical"}
	feFrame.style.width = 150

	-- Create the Belongs to Label --
	local belongsToL = feFrame.add{type="label", caption={"", {"gui-description.BelongsTo"}, ": ", self.player}}
	belongsToL.style.font = "LabelFont"
	belongsToL.style.font_color = _mfOrange
		
	-- Create Labels and Bares --
	local nameLabel = feFrame.add{type="label", caption={"", {"gui-description.FluidExtractor"}}}
	local SpeedLabel = feFrame.add{type="label", caption={"", {"gui-description.Speed"}, ": ", self:fluidPerExtraction(), " u/s"}}
	local ChargeLabel = feFrame.add{type="label", caption={"", {"gui-description.Charge"}, ": ", self.charge}}
	local ChargeBar = feFrame.add{type="progressbar", value=self.charge/_mfFEMaxCharge}
	local PurityLabel = feFrame.add{type="label", caption={"", {"gui-description.Purity"}, ": ", self.purity}}
	local PurityBar = feFrame.add{type="progressbar", value=self.purity/100}
	local targetLabel = feFrame.add{type="label", caption={"", {"gui-description.FETarget"}, ":"}}

	-- Update Style --
	nameLabel.style.bottom_margin = 5
	SpeedLabel.style.font = "LabelFont"
	ChargeLabel.style.font = "LabelFont"
	PurityLabel.style.font = "LabelFont"
	targetLabel.style.top_margin = 7
	targetLabel.style.font = "LabelFont"
	nameLabel.style.font_color = {108, 114, 229}
	SpeedLabel.style.font_color = {39,239,0}
	ChargeLabel.style.font_color = {39,239,0}
	ChargeBar.style.color = {176,50,176}
	PurityLabel.style.font_color = {39,239,0}
	PurityBar.style.color = {255, 255, 255}
	targetLabel.style.font_color = {108, 114, 229}
	
	-- Create the Mobile Factory Too Far Label --
	if self.MFTooFar == true then
		local mfTooFarL = feFrame.add{type="label", caption={"", {"gui-description.MFTooFar"}}}
		mfTooFarL.style.font = "LabelFont"
		mfTooFarL.style.font_color = _mfRed
	end
	
	-- Create the Dimensional Tank Selection --
	local dimTanks = {{"gui-description.Any"}}
	local selectedIndex = 1
	local i = 1
	for k, dimTank in pairs(self.MF.varTable.tanks) do
		if dimTank ~= nil then
			i = i + 1
			dimTanks[k+1] = tostring(k)
			if self.selectedDimTank == dimTank then
				selectedIndex = i
			end
		end
	end
	if selectedIndex ~= nil and selectedIndex > table_size(dimTanks) then selectedIndex = nil end
	local dimTankSelection = feFrame.add{type="list-box", name="FE" .. self.ent.unit_number, items=dimTanks, selected_index=selectedIndex}
	dimTankSelection.style.width = 50
end

-- Change the Targeted Dimensional Tank --
function FE:changeDimTank(ID)
	-- Check the ID --
	if ID == nil then self.selectedDimTank = nil end
	-- Select the Ore Silo --
	self.selectedDimTank = nil
	for k, dimTank in pairs(self.MF.varTable.tanks) do
		if dimTank ~= nil and dimTank.ent ~= nil and dimTank.ent.valid == true then
			if ID == k then
				self.selectedDimTank = dimTank
			end
		end
	end
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

-- Extract Fluids --
function FE:extractFluids(event)
	-- Check the Quatron Charge --
	if self.charge < 10 then return end
	-- Get the Fluid Path --
	local resource = self.ent.surface.find_entities_filtered{position=self.ent.position, radius=1, type="resource", limit=1}
	resource = resource[1]
	if resource == nil or resource.valid == false then return end
	-- Calcule the amount that can be extracted --
	local amount = math.min(resource.amount, self:fluidPerExtraction())
	-- Find the Focused Tank and Filter --
	if self.selectedDimTank == nil then return end
	local filter = self.selectedDimTank.filter
	local tank = self.selectedDimTank.ent
	if filter == nil or tank == nil then return end
	-- Test if the Filter accept this Fluid --
	if resource.name ~= filter then return end
	-- Send the Fluid to the Tank --
	local amountAdded = tank.insert_fluid({name=resource.name, amount=amount})
	-- Test if Fluid was sended --
	if amountAdded > 0 then
		self.charge = self.charge - 10
		-- Make a Beam --
		self.ent.surface.create_entity{name="BigPurpleBeam", duration=59, position=self.ent.position, target=self.MF.ent.position, source=self.ent.position}
		-- Remove amount from the FluidPath --
		resource.amount = math.max(resource.amount - amountAdded, 1)
		-- Remove the FluidPath if amount == 0 --
		if resource.amount < 2 then
			resource.destroy()
		end
	end
end




