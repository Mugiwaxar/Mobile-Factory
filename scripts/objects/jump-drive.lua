-- JUMP DRIVE OBJECT --

-- Create the Jump Drive base Object --
JD = {
	ent = nil,
	player = "",
	MF = nil,
    charge = 0,
	maxCharge = _mfMaxJumpCharge,
	chargeRate = 0,
	jumpChargerTable = nil,
	locationTable = nil, -- [name]{surface, posX, posY, filter}
    lightID = 0,
    chargeSpriteID = 0,
    chargeLightID = 0,
	updateTick = 60,
	lastUpdate = 0
}

-- Constructor --
function JD:new(MF)
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = JD
	t.player = MF.player
	t.MF = MF
	t.jumpChargerTable = {}
	t.locationTable = {}
    UpSys.addObj(t)
	return t
end

-- Reconstructor --
function JD:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = JD
	setmetatable(object, mt)
end

-- Destructor --
function JD:remove()
end

-- Is valid --
function JD:valid()
	return true
end

-- Update --
function JD:update()

	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if self.ent == nil or self.ent.valid == false then
		return
    end

    -- Set the Entity Energy --
    self.ent.energy = math.min(self.ent.prototype.electric_energy_source_prototype.buffer_capacity, self.charge / self.maxCharge * 100)

    -- Update the Charge Sprite --
	local spriteNumber = math.ceil(self.ent.energy/self.ent.prototype.electric_energy_source_prototype.buffer_capacity*16)
	rendering.destroy(self.chargeSpriteID)
    rendering.destroy(self.chargeLightID)
    if spriteNumber ~= 0 then
		rendering.destroy(self.spriteID or 0)
		self.spriteID = rendering.draw_sprite{sprite="CubeChargeSprite" .. spriteNumber, x_scale=1/2.25, y_scale=1/2.25, target=self.ent, surface=self.ent.surface, render_layer=130}
	end

	-- Check the jumpChargerTable --
	for k, jumpCharger in pairs(self.jumpChargerTable) do
		if valid(jumpCharger) == false then
			self.jumpChargerTable[k] = nil
		end
	end

	-- Calculate the Capacity --
	self.maxCharge = _mfMaxJumpCharge + (table_size(self.jumpChargerTable)*_chargeAddedPerJumpCharger)

	-- Calculate the Charge rate --
	self.chargeRate = 1 + (table_size(self.jumpChargerTable)*_chargeRateAddedPerJumpCharger)

	-- Update the Jump Drives --
	if self.charge < self.maxCharge and self.MF.internalEnergyObj:energy() > (_mfJumpEnergyDrain * self.chargeRate) then
		self.charge = self.charge + self.chargeRate
		self.MF.internalEnergyObj:removeEnergy(_mfJumpEnergyDrain * self.chargeRate)
		self.charge = math.min(self.charge, self.maxCharge)
	end


end
 
-- Tooltip Infos --
function JD:getTooltipInfos(GUITable, mainFrame, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.JDTitle"}

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

	-- Add the Jump Charge --
	GAPI.addLabel(GUITable, "ChargeLabel", infoFrame, {"gui-description.JDCharge", self.charge, self.maxCharge}, _mfOrange, nil, true)
	GAPI.addProgressBar(GUITable, "ChargeBar", infoFrame, "", self.charge .. "/" .. self.maxCharge, true, _mfOrange, self.charge/self.maxCharge, 100)

	-- Add the Jump Charger count --
	local label = GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.JDJCCount", table_size(self.jumpChargerTable)}, _mfOrange)
	label.style.top_margin = 10

	-- Add the Charge Rate --
	GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.JDChargeRate", self.chargeRate}, _mfOrange)

end

-- Add a Location --
function JD:addLocation(name, filter)
	-- Check the Name --
	if name == nil or name == "" then return end
	-- Check if the Name doesn't exist --
	if self.locationTable[name] ~= nil then
		getPlayer(self.MF.playerIndex).print({"gui-description.NameConflict"})
		return
	end
	-- Check the Mobile Factory --
	if self.MF.ent == nil or self.MF.ent.valid == false then return end
	-- Add the Location --
	self.locationTable[name] = {surface=self.MF.ent.surface, posX=self.MF.ent.position.x, posY=self.MF.ent.position.y, filter=filter}
end

-- Remove a Location --
function JD:removeLocation(name)
	-- Check the Name --
	if name == nil or name == "" then return end
	-- Remove the Location --
	self.locationTable[name] = nil
end

-- Check if the Mobile Factory can Teleport to the Location --
function JD:canTP(location)
	-- Calculate the Distance --
	local distance = Util.distance(self.MF.ent.position, {location.posX,location.posY})
	distance = math.ceil(distance)
	-- Check the Jump Charge --
	if distance > self.charge then return false end
	-- Check the World --
	if self.MF.ent.surface ~= location.surface and self.MF.internalQuatronObj.quatronCharge < 1000 then return false end
	-- All is OK --
	return true
end

-- Start the Jump --
function JD:jump(locationName)
	-- Get the Location --
	local location = self.locationTable[locationName]
	if location == nil then return end
	-- Check everything --
	if self.MF.ent == nil or self.MF.ent.valid == false or location == nil or self:canTP(location) == false then return end
	-- Teleport --
	self.MF:TPMobileFactoryPart1(location)
end