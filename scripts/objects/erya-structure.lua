-- -- ERYA STRUCTURE OBJECT --

-- -- Create the Erya Structure base object --
-- ES = {
-- 	ent = nil,
--     player = "",
--     MF = nil,
--     entID = 0,
--     animID = 0,
--     updateTick = 1200,
--     lastUpdate = 0,
--     freezeLayer = 0,
--     posTable = nil;
--     mistScale = 1
-- }

-- -- Constructor --
-- function ES:new(ent)
--     if ent == nil then return end
--     local t = {}
--     local mt = {}
--     setmetatable(t, mt)
--     mt.__index = ES
--     t.ent = ent
--     if ent.last_user == nil then return end
--     t.player = ent.last_user.name
--     t.MF = getMF(t.player)
--     t.entID = ent.unit_number
--     t.posTable = ES.createPosTable(ent)
--     return t
-- end

-- -- Reconstructor --
-- function ES:rebuild(object)
-- 	if object == nil then return end
-- 	local mt = {}
-- 	mt.__index = ES
-- 	setmetatable(object, mt)
-- end

-- -- Destructor --
-- function ES:remove()
-- 	-- Destroy the Animation --
--     rendering.destroy(self.animID)
--     -- Remove from the Erya Structure Table --
--     global.eryaTable[self.entID] = nil
-- end

-- -- Is valid --
-- function ES:valid()
-- 	if self.ent ~= nil and self.ent.valid then return true end
-- 	return false
-- end

-- -- Update --
-- function ES:update()

--     -- Set the lastUpdate variable --
-- 	self.lastUpdate = game.tick
	
-- 	-- Check the Validity --
-- 	if valid(self) == false then
-- 		self:remove()
-- 		return
--     end

--     if self.freezeLayer == 0 then
--         self.freezeLayer = 1
--         return
--     end

--     -- Render the Frozen Mist --
--     if self.mistScale < 30 then self.mistScale = self.mistScale + 0.3 end
--     self.animID = rendering.draw_animation{animation="FrozenMistA", target={self.ent.position.x,self.ent.position.y}, surface=self.ent.surface, render_layer=131, time_to_live=self.updateTick*2, x_scale=self.mistScale, y_scale=self.mistScale}
--     -- rendering.set_animation_offset(self.animID, 120*45 - (game.tick%120*45))

--     ------------------- Freeze one tile -------------------
--     -- Test if a tile will be frozen --
--     if math.random(0, self.freezeLayer) ~= 0 then return end
--     -- Check the freeze Table --
--     if self.freezeLayer > table_size(self.posTable) then
--         self.posTable = ES.createPosTable(self.ent)
--         self.freezeLayer = 1
--     end
--     if self.posTable[self.freezeLayer] == nil or table_size(self.posTable[self.freezeLayer]) <= 0 then
--         self.freezeLayer = self.freezeLayer + 1
--     end

--     -- Get a random number --
--     local randN = math.random(1, table_size(self.posTable[self.freezeLayer]))
--     local pos = self.posTable[self.freezeLayer][randN]

--     -- Check the position --
--     if pos ~= nil then
--         -- Create the Snow --
--         self.ent.surface.set_tiles({{name="MFSnowTile1", position=pos }})

--         -- Remove the Position from the Table --
--         if table_size(self.posTable[self.freezeLayer]) > 1 then
--             table.remove(self.posTable[self.freezeLayer], randN)
--         else
--             self.posTable[self.freezeLayer] = {}
--             self.freezeLayer = self.freezeLayer + 1
--         end
--     end
-- end

-- -- Create the Tiles position Table --
-- function ES.createPosTable(ent)
--     local posTable = {}
--     local layer = 0
--     local x = ent.position.x
--     local y = ent.position.y
--     for i=1, table_size(_mfEryaFrostlayer) do
--         posTable[i] = {}
--         for i2=1, table_size(_mfEryaFrostlayer[i]) do
--             table.insert(posTable[i], {x+_mfEryaFrostlayer[i][i2][1],y+_mfEryaFrostlayer[i][i2][2]})
--         end
--     end
--     return posTable
-- end