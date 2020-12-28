-- INTERNAL ENERGY OBJECT --

-- Create the Internal Energy base Object --
IEC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	lightID = 0,
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
	-- Draw the Sprite --
	self.spriteID = rendering.draw_sprite{sprite="EnergyCubeMK1Sprite0", x_scale=1/2.25, y_scale=1/2.25, target=object, surface=object.surface, render_layer=130}
	self.lightID = rendering.draw_light{sprite="EnergyCubeMK1Sprite0", scale=1/2.25, target=object, surface=object.surface, minimum_darkness=0}
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
	-- Destroy the Sprite --
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
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
	local spriteNumber = math.ceil(self.ent.energy/self.ent.prototype.electric_energy_source_prototype.buffer_capacity*10)
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	self.spriteID = rendering.draw_sprite{sprite="EnergyCubeMK1Sprite" .. spriteNumber, x_scale=1/2.25, y_scale=1/2.25, target=self.ent, surface=self.ent.surface, render_layer=130}
	self.lightID = rendering.draw_light{sprite="EnergyCubeMK1Sprite" .. spriteNumber, scale=1/2.25, target=self.ent, surface=self.ent.surface, minimum_darkness=0}

	-- Balance the Energy with neighboring Cubes --
	self:balance()
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
    GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.EnergyLevel", Util.toRNumber(self:energy())}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", infoFrame, "", math.floor(self:energy()) .. "/" .. self:maxEnergy(), false, _mfPurple, self:energy()/self:maxEnergy(), 100)

	-- Add the Input/Output Speed Label --
	local inputLabel = GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.EnergyInputSpeed", Util.toRNumber(self:maxInput())}, _mfOrange)
	inputLabel.style.top_margin = 10
	GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.EnergyOutputSpeed", Util.toRNumber(self:maxOutput())}, _mfOrange)

end

-- Balance the Energy with neighboring Cubes --
function IEC:balance()
	-- Get all Accumulator arount --
	local area = {{self.ent.position.x-3.5, self.ent.position.y-2.5},{self.ent.position.x+3.5,self.ent.position.y+4.5}}
	local ents = self.ent.surface.find_entities_filtered{area=area, name=_mfEnergyShare}

	local selfMaxOutFlow = self.ent.electric_output_flow_limit * self.updateTick
	local selfEnergy = self.ent.energy

	-- Check all Accumulator --
	for k, ent in pairs(ents) do
		-- Look for valid Energy Cube --
		local obj = global.entsTable[ent.unit_number]
		if obj ~= nil and obj.entID ~= self.entID then
			local isAcc = ent.type == "accumulator"
			local objEnergy = obj.ent.energy
			local objMaxEnergy = obj.ent.electric_buffer_size
			local objMaxInFlow = obj:maxInput() * self.updateTick
			local shareThreshold = isAcc and objEnergy or 0
			if selfEnergy > shareThreshold and objEnergy < objMaxEnergy and objMaxInFlow > 0 then
				-- Calcule max flow --
				local energyVariance = isAcc and math.floor((selfEnergy - objEnergy) / 2) or selfEnergy
				local missingEnergy = objMaxEnergy - objEnergy
				local energyTransfer = math.min(energyVariance, missingEnergy, selfMaxOutFlow, objMaxInFlow)
				-- Transfer Energy --
				obj.ent.energy = objEnergy + energyTransfer
				-- Remove Energy --
				selfEnergy = selfEnergy - energyTransfer
			end
		end
	end

	self.ent.energy = selfEnergy
end

-- Return the amount of Energy --
function IEC:energy()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.energy
	end
	return 0
end

-- Return the Energy Buffer size --
function IEC:maxEnergy()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.electric_buffer_size
	end
	return 1
end

-- Add Energy (Return the amount added) --
function IEC:addEnergy(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local added = math.min(amount, self.ent.electric_buffer_size - self.ent.energy)
		self.ent.energy = self.ent.energy + added
		return added
	end
	return 0
end

-- Remove Energy (Return the amount removed) --
function IEC:removeEnergy(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local removed = math.min(amount, self.ent.energy)
		self.ent.energy = self.ent.energy - removed
		return removed
	end
	return 0
end

-- Return the max input flow --
function IEC:maxInput()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.electric_input_flow_limit
	end
	return 0
end

-- Return the max output flow --
function IEC:maxOutput()
	if self.ent ~= nil and self.ent.valid == true then
		return self.ent.electric_output_flow_limit
	end
	return 0
end
