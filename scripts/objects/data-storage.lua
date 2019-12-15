-- DATA STORAGE OBJECT --

-- Create the Data Storage base object --
DS = {
	ent = nil,
	animID = 0,
	active = false,
	linkedDC = nil,
	updateTick = 80,
	lastUpdate = 0,
	GCNID = 0,
	RCNID = 0
}

-- Constructor --
function DS:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = DS
	t.ent = object
	return t
end

-- Reconstructor --
function DS:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = DS
	setmetatable(object, mt)
end

-- Destructor --
function DS:remove()
	-- Destroy the Animation --
	rendering.destroy(self.animID)
end

-- Is valid --
function DS:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function DS:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check if the Entity is valid --
	if self.ent == nil or self.ent.valid == false then return end

	-- Check if the Entity is inside a Green Circuit Network --
	if self.ent.get_circuit_network(defines.wire_type.green) ~= nil and self.ent.get_circuit_network(defines.wire_type.green).valid == true then
		self.GCNID = self.ent.get_circuit_network(defines.wire_type.green).network_id
	else
		self.GCNID = 0
	end
	
	-- Check if the Entity is inside a Red Circuit Network --
	if self.ent.get_circuit_network(defines.wire_type.red) ~= nil and self.ent.get_circuit_network(defines.wire_type.red).valid == true then
		self.RCNID = self.ent.get_circuit_network(defines.wire_type.red).network_id
	else
		self.RCNID = 0
	end
	
	-- Set the Data Center Inactive --
	self:setActive(false)
	
	-- Check if a Data Center was Found and activate the Data Storage --
	if self.linkedDC ~= nil and self.linkedDC.active then
		if self.linkedDC:sameCN(self) then
			self:setActive(true)
		end
	end
	
end

-- Tooltip Infos --
function DS:getTooltipInfos(GUI)
	-- Create the text and style variables --
	local text = ""
	local style = {}
	-- Check if the Data Storage is linked with a Data Center --
	if self.linkedDC ~= nil and getmetatable(self.linkedDC) ~= nil and self.linkedDC:valid() == true and self.linkedDC.active then
		text = {"", {"gui-description.LinkedTo"}, ": ", self.linkedDC.invObj.name}
		style = {92, 232, 54}
	else
		text = {"gui-description.Unlinked"}
		style = {231, 5, 5}
	end
	-- Create the Link label --
	local link = GUI.add{type="label"}
	link.style.font = "LabelFont"
	link.caption = text
	link.style.font_color = style
end

-- Set Active --
function DS:setActive(set)
	self.active = set
	if set == true then
		-- Create the Animation if it doesn't exist --
		if self.animID == 0 then
			self.animID = rendering.draw_animation{animation="DataStorageA", target={self.ent.position.x,self.ent.position.y-1.2}, surface=self.ent.surface}
		end
	else
		-- Destroy the Animation --
		rendering.destroy(self.animID)
		self.animID = 0
	end
end














