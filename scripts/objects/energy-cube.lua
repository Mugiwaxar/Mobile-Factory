-- ENERGY CUBE OBJECT --

-- Create the Energy Cube base Object --
EC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	consumption = 0,
	updateTick = 60,
	lastUpdate = 0
}

-- Constructor --
function EC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = EC
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function EC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = EC
	setmetatable(object, mt)
end

-- Destructor --
function EC:remove()
	-- Destroy the Sprite --
	rendering.destroy(self.spriteID)
	-- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function EC:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Item Tags To Content --
function EC:itemTagsToContent(tags)
	self.ent.energy = tags.energy or 0
end

-- Content to Item Tags --
function EC:contentToItemTags(tags)
	if self.ent.energy > 0 then
		tags.set_tag("Infos", {energy=self.ent.energy})
		tags.custom_description = {"", tags.prototype.localised_description, {"item-description.EnergyCubeC", Util.toRNumber(math.floor(self.ent.energy))}, "J"}
	end
end

-- Update --
function EC:update()

	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick

	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end

	-- Update the Sprite --
	local spriteNumber = math.ceil(self.ent.energy/self.ent.prototype.electric_energy_source_prototype.buffer_capacity*16)
	rendering.destroy(self.spriteID)
	self.spriteID = rendering.draw_sprite{sprite="CubeChargeSprite" .. spriteNumber, x_scale=1/7, y_scale=1/7, target=self.ent, surface=self.ent.surface, target_offset={0, -0.3}, render_layer=131}

	-- Balance the Energy with neighboring Cubes --
	EI.shareEnergy(self)

end


-- Tooltip Infos --
function EC:getTooltipInfos(GUITable, mainFrame, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.EnergyCube"}

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