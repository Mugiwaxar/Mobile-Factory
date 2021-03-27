-- INTERNAL ENERGY OBJECT --

-- Create the Internal Energy base Object --
IEC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	updateTick = 60,
	lastUpdate = 0
}

-- Constructor --
function IEC:new(MF)
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = IEC
	t.player = MF.player
	t.MF = MF
	UpSys.addObj(t)
	return t
end

-- Set an Internal Energy Cube --
function IEC:setEnt(object)
	if object == nil then return end
	if object.last_user == nil then return end
	self.ent = object
	self.entID = object.unit_number
	-- Update the UpSys --
	--UpSys.scanObjs() -- Make old save crash --
	UpSys.addObject(self)
end

-- Reconstructor --
function IEC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = IEC
	setmetatable(object, mt)
end

-- Destructor --
function IEC:remove()
	self.ent = nil
end

-- Is valid --
function IEC:valid()
	return true
end

-- Item Tags to Content --
function IEC:itemTagsToContent(tags)
	self.ent.energy = tags.energy or 0
end

-- Content to Item Tags --
function IEC:contentToItemTags(tags)
	if self.ent.energy <= 0 then return end
	tags.set_tag("Infos", {energy=self.ent.energy})
	tags.custom_description = {"", tags.prototype.localised_description, {"item-description.EnergyCubeC", Util.toRNumber(math.floor(self.ent.energy))}}
end

-- Update --
function IEC:update()

	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick

	-- Check the Validity --
	if self.ent == nil or self.ent.valid == false then
		return
	end

	-- Update the Sprite --
	local spriteNumber = math.ceil(self.ent.energy/self.ent.prototype.electric_energy_source_prototype.buffer_capacity*16)
	rendering.destroy(self.spriteID)
	self.spriteID = rendering.draw_sprite{sprite="CubeChargeSprite" .. spriteNumber, x_scale=1/2.25, y_scale=1/2.25, target=self.ent, surface=self.ent.surface, render_layer=130}

	-- Balance the Energy with neighboring Cubes --
	EI.shareEnergy(self)

end

-- Tooltip Infos --
function IEC:getTooltipInfos(GUITable, mainFrame, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.InternalEnergyCube"}

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

	-- Add the Energy level --
    GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.EnergyLevel", Util.toRNumber(EI.energy(self))}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", infoFrame, "", math.floor(EI.energy(self)) .. "/" .. EI.maxEnergy(self), false, _mfBlue, EI.energy(self)/EI.maxEnergy(self), 100)

	-- Add the Input/Output Speed Label --
	local inputLabel = GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.EnergyInputSpeed", Util.toRNumber(EI.speed(self))}, _mfOrange)
	inputLabel.style.top_margin = 10
	GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.EnergyOutputSpeed", Util.toRNumber(EI.speed(self))}, _mfOrange)

end