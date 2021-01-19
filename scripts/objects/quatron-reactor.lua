-- QUATRON REACTOR OBJECT --

-- Create the Quatron Reactor base Object --
QR = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	updateTick = 60,
	lastUpdate = 0,
	energyCharge = 0,
	energyLevel = 1,
	energyBuffer = _mfQuatronReactorMaxEnergyCapacity
}

-- Constructor --
function QR:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = QR
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
    UpSys.addObj(t)
	return t
end

-- Reconstructor --
function QR:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = QR
	setmetatable(object, mt)
end

-- Destructor --
function QR:remove()
	-- Destroy the Sprite --
	rendering.destroy(self.spriteID)
	self.ent = nil
end

-- Is valid --
function QR:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function QR:update()

	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick

	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end

	-- Burn Fluid --
	self:burnFluid()

	-- Send Quatron --
	EI.shareEnergy(self)

	-- Update the Sprite --
	local spriteNumber = math.ceil(EI.energy(self)/EI.maxEnergy(self)*9)
	rendering.destroy(self.spriteID)
	self.spriteID = rendering.draw_sprite{sprite="QuatronReactorSprite" .. spriteNumber, target=self.ent, surface=self.ent.surface, render_layer=129}

end

-- Tooltip Infos --
function QR:getTooltipInfos(GUITable, mainFrame, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.QuatronReactor"}

		-- Set the Main Frame Height --
		-- mainFrame.style.height = 100
		
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

	-- Add the Quatron Charge --
    GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.QuatronCharge", Util.toRNumber(EI.energy(self))}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", infoFrame, "", EI.energy(self) .. "/" .. EI.maxEnergy(self), false, _mfPurple, EI.energy(self)/EI.maxEnergy(self), 100)
	
	-- Create the Quatron Purity --
	GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.Quatronlevel", string.format("%.3f", EI.energyLevel(self))}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", infoFrame, "", "", false, _mfPurple, EI.energyLevel(self)/20, 100)

	-- Add the Input/Output Speed Label --
	local speedLabel = GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.QuatronReactorSpeed", _mfQuatronMaxFluidBurntPerOperation}, _mfOrange)
	speedLabel.style.top_margin = 10
	GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.QuatronOutputSpeed", Util.toRNumber(EI.speed(self))}, _mfOrange)

end

-- Transform the Fluid inside into Quatron --
function QR:burnFluid()

	-- Return if the Reactor is full --
	if EI.missingEnergy(self) <= 0 then return end

	-- Get the Fluid inside --
	local fluid = self.ent.fluidbox[1]
	if fluid == nil then return end

	-- Get the Quatron Level --
	local fluidName = fluid.name
	if string.match(fluidName, "LiquidQuatron") == nil then return end
	local level = tonumber((string.gsub(fluidName, "LiquidQuatron", "")))
	if level == nil then return end

	-- Get the amount of Fluid to remove --
	local fluidToRemove = math.min(fluid.amount, math.floor((EI.maxEnergy(self) - EI.energy(self))), _mfQuatronMaxFluidBurntPerOperation)
	if fluidToRemove < 1 then return end

	-- Remove the Fluid --
	local removed = self.ent.remove_fluid{name=fluidName, amount=fluidToRemove}
	self.ent.force.fluid_production_statistics.on_flow(fluidName, fluidToRemove * -1)

	-- Add the Quatron Energy to the Reactor --
	EI.addEnergy(self, removed, level)

end