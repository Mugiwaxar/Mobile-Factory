-- INTERNAL QUATRON OBJECT --

-- Create the Internal Quatron base Object --
IQC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	updateTick = 60,
	lastUpdate = 0,
	energyLevel = 1,
}

-- Constructor --
function IQC:new(MF)
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = IQC
	t.player = MF.player
	t.MF = MF
	UpSys.addObj(t)
	return t
end

-- Set an Internal Quatron Cube --
function IQC:setEnt(object)
	if object == nil then return end
	if object.last_user == nil then return end
	self.ent = object
	self.entID = object.unit_number
	-- Update the UpSys --
	--UpSys.scanObjs() -- Make old save crash --
	UpSys.addObject(self)
end

-- Reconstructor --
function IQC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = IQC
	setmetatable(object, mt)
end

-- Destructor --
function IQC:remove()
	-- Purge Quatron, as IQC Object stays valid even without entity
	self.quatronMax = nil
	-- Destroy the Sprite --
	rendering.destroy(self.lightID)
	self.ent = nil
end

-- Is valid --
function IQC:valid()
	return true
end

-- Item Tags to Content --
function IQC:itemTagsToContent(tags)
	self.ent.energy = tags.energy or 0
	self.energyLevel = tags.purity or 1
end

-- Content to Item Tags --
function IQC:contentToItemTags(tags)
	if EI.energy(self) <= 0 then return end
	tags.set_tag("Infos", {energy=self.ent.energy, purity=EI.energyLevel(self)})
	tags.custom_description = {"", tags.prototype.localised_description, {"item-description.QuatronCubeC", Util.toRNumber(self.ent.energy), string.format("%.3f", EI.energyLevel(self))}}
end

-- Update --
function IQC:update()

	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick

	-- Check the Validity --
	if self.ent == nil or self.ent.valid == false then
		return
	end

	-- Update the Sprite --
	local spriteNumber = math.ceil(EI.energy(self)/EI.maxEnergy(self)*16)
	rendering.destroy(self.spriteID)
	self.spriteID = rendering.draw_sprite{sprite="CubeChargeSprite" .. spriteNumber, x_scale=1/2.25, y_scale=1/2.25, target=self.ent, surface=self.ent.surface, render_layer=130}

	-- Balance the Quatron with neighboring Quatron Users --
	EI.shareEnergy(self)

end

-- Tooltip Infos --
function IQC:getTooltipInfos(GUITable, mainFrame, justCreated)

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