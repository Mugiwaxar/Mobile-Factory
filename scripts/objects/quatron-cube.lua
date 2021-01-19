-- QUATRON CUBE OBJECT --

-- Create the Quatron Cube base Object --
QC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	consumption = 0,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
	energyLevel = 1
}

-- Constructor --
function QC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = QC
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	-- Draw the Sprite --
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function QC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = QC
	setmetatable(object, mt)
end

-- Destructor --
function QC:remove()
	-- Destroy the Sprite --
	rendering.destroy(self.spriteID)
	-- Remove from the Update System --
	UpSys.removeObj(self)
	-- Remove from the Data Network --
	if self.dataNetwork ~= nil and getmetatable(self.dataNetwork) ~= nil then
		self.dataNetwork:removeObject(self)
	end
end

-- Is valid --
function QC:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Item Tags to Content --
function QC:itemTagsToContent(tags)
	self.ent.energy = tags.energy or 0
	self.energyLevel = tags.purity or 1
end

-- Content to Item Tags --
function QC:contentToItemTags(tags)
	if EI.energy(self) <= 0 then return end
	tags.set_tag("Infos", {energy=self.ent.energy, purity=EI.energyLevel(self)})
	tags.custom_description = {"", tags.prototype.localised_description, {"item-description.QuatronCubeC", math.floor(self.ent.energy), string.format("%.3f", EI.energyLevel(self))}}
end

-- Update --
function QC:update()

	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick

	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end

	-- Update the Sprite --
	local spriteNumber = math.ceil(EI.energy(self)/EI.maxEnergy(self)*16)
	rendering.destroy(self.spriteID)
	self.spriteID = rendering.draw_sprite{sprite="CubeChargeSprite" .. spriteNumber, x_scale=1/7, y_scale=1/7, target=self.ent, surface=self.ent.surface, target_offset={0, -0.3}, render_layer=131}

	-- Balance the Quatron with neighboring Quatron Users --
	EI.shareEnergy(self)

end


-- Tooltip Infos --
function QC:getTooltipInfos(GUITable, mainFrame, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.QuatronCube"}

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
	local inputLabel = GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.QuatronInputSpeed", Util.toRNumber(EI.speed(self))}, _mfOrange)
	inputLabel.style.top_margin = 10
	GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.QuatronOutputSpeed", Util.toRNumber(EI.speed(self))}, _mfOrange)

end