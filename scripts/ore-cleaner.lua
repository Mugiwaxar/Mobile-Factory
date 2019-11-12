-- ORE CLEANER OBJECT --

OC = {
	ent = nil,
	purity = 0,
	charge = 0,
	totalCharge = 0,
	oreTable = nil,
	inventory = nil
}

-- Constructor --
function OC:new(object)
	if object == nil then return end
	t = {}
	mt = {}
	setmetatable(t, mt)
	mt.__index = OC
	t.ent = object
	return t
end

-- Remover --
function OC:remove()
	self.ent = nil
	self.oreTable = nil
	self.inventory = nil
end

-- Reconstructor --
function OC:rebuild(object)
	if object == nil then return end
	mt = {}
	mt.__index = OC
	setmetatable(object, mt)
end

-- Add a Quatron Charge --
function OC:addQuatron(level)
	self.charge = self.charge + 100
	self.purity = ((self.purity * self.totalCharge) + level) / (self.totalCharge + 1)
end

-- Scan surronding Ores --
function OC:scanOres(entity)
	-- Test if the Entity is valid --
	if entity == nil or entity.valid == false then return end
	-- Test if the Surface is valid --
	if entity.surface == nil then return end
	-- Get the name of the Ore under the Ore Cleaner --
	local resource = entity.surface.find_entities_filtered{position=entity.position, radius=1, type="resource", limit=1}
	-- Test if the Ore was found --
	if resource[1] == nil or resource[1].valid == false then return end
	-- Add all surrounding Ores and add them to the oreTable --
	self.oreTable = entity.surface.find_entities_filtered{position=entity.position, radius=_mfOreCleanerRadius, name=resource[1].name}
end

-- Update the Ore Cleaner --
function OC:update(event)
	-- Remove the Ore Cleaner if it no longer exist --
	if self.ent == nil then self:remove() return end
	if self.ent.valid == false then self:remove() return end
end

-- Collect surrounding Ores --
function OC:collectOres(event)
	-- Test if the Ore Cleaner and the Mobile Factory are valid --
	if global.oreCleaner == nil or global.MF == nil then return end
	if global.MF.ent.valid == false then return end
	-- Set the Ore Cleaner to nil if the Entity is no longer valid --
	if global.oreCleaner.ent ~= nil and global.oreCleaner.ent.valid == false then global.oreCleaner:remove() return end
	-- Set the Ore Cleaner Energy --
	global.oreCleaner.energy = 60
	
	
	
end




