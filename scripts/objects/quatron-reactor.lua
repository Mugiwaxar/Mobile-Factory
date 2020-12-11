-- QUATRON REACTOR OBJECT --

-- Create the Quatron Reactor base Object --
QR = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	lightID = 0,
	updateTick = 60,
	lastUpdate = 0,
	quatronCharge = 0,
	quatronLevel = 1,
	quatronMax = 25000,
	quatronMaxInput = 0,
	quatronMaxOutput = 25000
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
    -- Draw the state Sprite --
	t.spriteID = rendering.draw_sprite{sprite="QuatronReactorSprite0", target=object, surface=object.surface, render_layer=129}
	t.lightID = rendering.draw_light{sprite="QuatronReactorSprite0", target=object, surface=object.surface, minimum_darkness=0}
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
	rendering.destroy(self.lightID)
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
	self:sendQuatron()

	-- Update the Sprite --
	local spriteNumber = math.ceil(self.quatronCharge/self.quatronMax*12)
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	self.spriteID = rendering.draw_sprite{sprite="QuatronReactorSprite" .. spriteNumber, target=self.ent, surface=self.ent.surface, render_layer=129}
	self.lightID = rendering.draw_light{sprite="QuatronReactorSprite" .. spriteNumber, target=self.ent, surface=self.ent.surface, minimum_darkness=0}
end

-- Tooltip Infos --
-- Apparently generator-based entities doesn't fire on_gui_opened on click, so it doesn't work.
function QR:getTooltipInfos(GUITable, mainFrame, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.InternalQuatronCube"}

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

		-- Create the Tite --
		GAPI.addSubtitle(GUITable, "", infoFrame, {"gui-description.Information"})
	
	end

	-- Get the Frame --
	local infoFrame = GUITable.vars.InformationFrame

	-- Clear the Frame --
	infoFrame.clear()

	-- Add the Quatron Charge --
    GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.QuatronCharge", Util.toRNumber(self.quatronCharge)}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", infoFrame, "", self.quatronCharge .. "/" .. self.quatronMax, false, _mfPurple, self.quatronCharge/self.quatronMax, 100)
	
	-- Create the Quatron Purity --
	GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.Quatronlevel", string.format("%.3f", self.quatronLevel)}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", infoFrame, "", "", false, _mfPurple, self.quatronLevel/20, 100)

	-- Add the Input/Output Speed Label --
	local outputLabel = GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.QuatronOutputSpeed", Util.toRNumber(self:maxOutput())}, _mfOrange)
	outputLabel.style.top_margin = 10

end

-- Transform the Fluid inside into Quatron --
function QR:burnFluid()

	-- Return if the Reactor is full --
	if self.quatronCharge >= self.quatronMax then return end

	-- Get the Fluid inside --
	local fluid = self.ent.fluidbox[1]
	if fluid == nil then return end

	-- Get the Quatron Level --
	local fluidName = fluid.name
	if string.match(fluidName, "LiquidQuatron") == nil then return end
	local level = tonumber((string.gsub(fluidName, "LiquidQuatron", "")))
	if level == nil then return end

	-- Get the amount of Fluid to remove --
	local fluidToRemove = math.min(fluid.amount, math.floor((self.quatronMax - self.quatronCharge) / _mfQuatronEnergyRate))
	if fluidToRemove < 1 then return end

	-- Remove the Fluid --
	local removed = self.ent.remove_fluid{name=fluidName, amount=fluidToRemove}
	self.ent.force.fluid_production_statistics.on_flow(fluidName, fluidToRemove * -1)

	-- Add the Quatron Energy to the Reactor --
	self:addQuatron(removed * _mfQuatronEnergyRate, level)
	
end

-- Send Quatron to nearby Quatron Users --
function QR:sendQuatron()

	-- Check Quatron Charge
	local selfQuatron = self.quatronCharge
	if selfQuatron <= 0 then return end

	-- Get all Entities arount --
	local area = {{self.ent.position.x-2.5, self.ent.position.y-2.5},{self.ent.position.x+2.5,self.ent.position.y+2.5}}
	local ents = self.ent.surface.find_entities_filtered{area=area, name=_mfQuatronShare}

	local selfQuatronLevel = self.quatronLevel

	-- Check all Entity --
	for _, ent in pairs(ents) do
		-- Look for valid Object --
		local obj = global.entsTable[ent.unit_number]
		if obj ~= nil and obj.entID ~= self.entID then
			local objQuatron = obj.quatronCharge
			local objQuatronLevel = obj.quatronLevel
			local objMaxQuatron = obj.quatronMax
			local objMaxInFlow = obj.quatronMaxInput
			if objQuatron < objMaxQuatron and objMaxInFlow > 0 then
				-- Calcule max flow --
				local missingQuatron = objMaxQuatron - objQuatron
				local quatronTransfer = math.min(selfQuatron, missingQuatron, objMaxInFlow)
				-- Transfer Quatron --
				quatronTransfer = obj:addQuatron(quatronTransfer, selfQuatronLevel)
				-- Remove Quatron --
				selfQuatron = selfQuatron - quatronTransfer
				if selfQuatron <= 0 then break end
			end
		end
	end

	self.quatronCharge = selfQuatron

end

-- Return the amount of Quatron --
function QR:quatron()
	return self.quatronCharge
end

-- Return the Quatron Buffer size --
function QR:maxQuatron()
	return self.quatronMax
end

-- Add Quatron (Return the amount added) --
function QR:addQuatron(amount, level)
	local added = math.min(amount, self.quatronMax - self.quatronCharge)
	if self.quatronCharge > 0 then
		mixQuatron(self, added, level)
	else
		self.quatronCharge = added
		self.quatronLevel = level
	end
	return added
end

-- Remove Quatron (Return the amount removed) --
function QR:removeQuatron(amount)
	local removed = math.min(amount, self.quatronCharge)
	self.quatronCharge = self.quatronCharge - removed
	return removed
end

-- Return the max input flow --
function QR:maxInput()
	return self.quatronMaxInput
end

-- Return the max output flow --
function QR:maxOutput()
	return self.quatronMaxOutput
end