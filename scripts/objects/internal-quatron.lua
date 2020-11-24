-- INTERNAL QUATRON OBJECT --

-- Create the Internal Quatron base Object --
IQC = {
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
	quatronMax = 1,
	quatronMaxInput = 0,
	quatronMaxOutput = 0
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
	-- Get prototype data
	self.quatronCharge = object.energy
	self.quatronMax = object.electric_buffer_size
	self.quatronMaxInput = object.electric_buffer_size / 10
	self.quatronMaxOutput = object.electric_buffer_size / 10
	-- Draw the Sprite --
	self.spriteID = rendering.draw_sprite{sprite="QuatronCubeSprite0", x_scale=1/2.25, y_scale=1/2.25, target=object, surface=object.surface, render_layer=130}
	self.lightID = rendering.draw_light{sprite="QuatronCubeSprite0", scale=1/2.25, target=object, surface=object.surface, minimum_darkness=0}
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
	self.quatronCharge = nil
	self.quatronMax = nil
	-- Destroy the Sprite --
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	self.ent = nil
end

-- Is valid --
function IQC:valid()
	return true
end

-- Item Tags to Content --
function IQC:itemTagsToContent(tags)
	self.quatronCharge = tags.energy or 0
	self.quatronLevel = tags.purity or 1
	self.ent.energy = self.quatronCharge
end

-- Content to Item Tags --
function IQC:contentToItemTags(tags)
	if self.quatronCharge <= 0 then return end
	tags.set_tag("Infos", {energy=self.quatronCharge, purity=self.quatronLevel})
	tags.custom_description = {"", tags.prototype.localised_description, {"item-description.QuatronCubeC", math.floor(self.quatronCharge), string.format("%.3f", self.quatronLevel)}}
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
	local spriteNumber = math.ceil(self.quatronCharge/self.quatronMax*10)
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	self.spriteID = rendering.draw_sprite{sprite="QuatronCubeSprite" .. spriteNumber, x_scale=1/2.25, y_scale=1/2.25, target=self.ent, surface=self.ent.surface, render_layer=130}
	self.lightID = rendering.draw_light{sprite="QuatronCubeSprite" .. spriteNumber, scale=1/2.25, target=self.ent, surface=self.ent.surface, minimum_darkness=0}

	-- Balance the Quatron with neighboring Quatron Users --
	self:balance()
end

-- Tooltip Infos --
function IQC:getTooltipInfos(GUIObj, gui, justCreated)

	-- Get the Flow --
	local informationFlow = GUIObj.InformationFlow

	if justCreated == true then
		-- Create the Information Title --
		local informationTitle = GUIObj:addTitledFrame("", gui, "vertical", {"gui-description.Information"}, _mfOrange)
		informationFlow = GUIObj:addFlow("InformationFlow", informationTitle, "vertical", true)
	end

	-- Clear the Flow --
	informationFlow.clear()

	-- Create the Quatron Charge --
	GUIObj:addDualLabel(informationFlow, {"", {"gui-description.Charge"}, ": "}, math.floor(self.quatronCharge), _mfOrange, _mfGreen)
	GUIObj:addProgressBar("", informationFlow, "", "", false, _mfPurple, self.quatronCharge/self.quatronMax, 100)

	-- Create the Quatron Purity --
	GUIObj:addDualLabel(informationFlow, {"", {"gui-description.Purity"}, ": "}, string.format("%.3f", self.quatronLevel), _mfOrange, _mfGreen)
	GUIObj:addProgressBar("", informationFlow, "", "", false, _mfPurple, self.quatronLevel/20, 100)
end

-- Balance the Quatron with neighboring Quatron Users --
function IQC:balance()
	-- Get all Accumulator arount --
	local area = {{self.ent.position.x-3.5, self.ent.position.y-2.5},{self.ent.position.x+3.5,self.ent.position.y+4.5}}
	local ents = self.ent.surface.find_entities_filtered{area=area, name=_mfQuatronShare}

	local selfMaxOutFlow = self.quatronMaxOutput
	local selfQuatron = self.quatronCharge
	local selfQuatronLevel = self.quatronLevel

	-- Check all Accumulator --
	for k, ent in pairs(ents) do
		-- Look for valid Quatron User --
		local obj = global.entsTable[ent.unit_number]
		if obj ~= nil and obj.entID ~= self.entID then
			local isAcc = ent.type == "accumulator"
			local objQuatron = obj.quatronCharge
			local objMaxQuatron = obj.quatronMax
			local objMaxInFlow = obj.quatronMaxInput
			local shareThreshold = isAcc and objQuatron or 0
			if selfQuatron > shareThreshold and objQuatron < objMaxQuatron and objMaxInFlow > 0 then
				-- Calcule max flow --
				local quatronVariance = isAcc and math.floor((selfQuatron - objQuatron) / 2) or selfQuatron
				local missingQuatron = objMaxQuatron - objQuatron
				local quatronTransfer = math.min(quatronVariance, missingQuatron, selfMaxOutFlow, objMaxInFlow)
				-- Transfer Quatron --
				quatronTransfer = obj:addQuatron(quatronTransfer, selfQuatronLevel)
				-- Remove Quatron --
				selfQuatron = selfQuatron - quatronTransfer
			end
		end
	end

	self.quatronCharge = selfQuatron
	self.ent.energy = selfQuatron
end

-- Return the amount of Quatron --
function IQC:quatron()
	if self.ent ~= nil and self.ent.valid == true then
		return self.quatronCharge
	end
	return 0
end

-- Return the Quatron Buffer size --
function IQC:maxQuatron()
	if self.ent ~= nil and self.ent.valid == true then
		return self.quatronMax
	end
	return 1
end

-- Add Quatron (Return the amount added) --
function IQC:addQuatron(amount, level)
	if self.ent ~= nil and self.ent.valid == true then
		local added = math.min(amount, self.quatronMax - self.quatronCharge)
		if self.quatronCharge > 0 then
			mixQuatron(self, added, level)
		else
			self.quatronCharge = added
			self.quatronLevel = level
		end
		return added
	end
	return 0
end

-- Remove Quatron (Return the amount removed) --
function IQC:removeQuatron(amount)
	if self.ent ~= nil and self.ent.valid == true then
		local removed = math.min(amount, self.quatronCharge)
		self.quatronCharge = self.quatronCharge - removed
		return removed
	end
	return 0
end

-- Return the max input flow --
function IQC:maxInput()
	if self.ent ~= nil and self.ent.valid == true then
		return self.quatronMaxInput
	end
	return 0
end

-- Return the max output flow --
function IQC:maxOutput()
	return self.quatronMaxOutput
end
