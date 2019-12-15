-- ENERGY CUBE OBJECT --

-- Create the Energy Cube base Object --
EC = {
	ent = nil,
	spriteID = 0,
	linkedDC = nil,
	updateTick = 60,
	lastUpdate = 0,
	GCNID = 0,
	RCNID = 0
}

-- Constructor --
function EC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = EC
	t.ent = object
	-- Draw the Sprite --
	t.spriteID = rendering.draw_sprite{sprite="EnergyCubeMK1Sprite0", x_scale=1/325*(33*3), y_scale=1/325*(33*3), target=object, surface=object.surface, target_offset={0, -0.3}}
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
end

-- Is valid --
function EC:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function EC:update()
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
	
	-- Update the Sprite --
	local spriteNumber = math.ceil(self.ent.energy/self.ent.prototype.electric_energy_source_prototype.buffer_capacity*10)
	rendering.destroy(self.spriteID)
	self.spriteID = rendering.draw_sprite{sprite="EnergyCubeMK1Sprite" .. spriteNumber, x_scale=1/325*(33*3), y_scale=1/325*(33*3), target=self.ent, surface=self.ent.surface, target_offset={0, -0.3}}
end


-- Tooltip Infos --
function EC:getTooltipInfos(GUI)
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






















