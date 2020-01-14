------------------------ Control Center Extension ------------------------

-- Create tile Surface --
function createTilesSurface(surface, x1, y1, x2, y2, tile)
	if surface == nil then return end
	local tilesTable = {}
	for x = x1, x2-1 do
	  for y = y1, y2-1 do
		table.insert(tilesTable, {name=tile,position={x,y}})
		end
	end
	surface.set_tiles(tilesTable) 
end

-- Left passage Extension 1 --
function createLeftPassage1(surface)
	if surface == nil then return end
	createTilesSurface(surface, -22, -3, -10, 3, "tutorial-grid")
end

-- Left passage Extension 2 --
function createLeftPassage2(surface)
	createLeftPassage1(surface)
	if surface == nil then return end
	createTilesSurface(surface, -41, -3, -22, 3, "tutorial-grid")
	createTilesSurface(surface, -28, -15, -22, -3, "tutorial-grid")
end

-- Left passage Extension 3 --
function createLeftPassage3(surface)
	createLeftPassage2(surface)
	if surface == nil then return end
	createTilesSurface(surface, -58, -3, -41, 3, "tutorial-grid")
	createTilesSurface(surface, -46, -15, -40, -3, "tutorial-grid")
end

-- Left passage Extension 4 --
function createLeftPassage4(surface)
	createLeftPassage3(surface)
	if surface == nil then return end
	createTilesSurface(surface, -75, -3, -58, 3, "tutorial-grid")
	createTilesSurface(surface, -64, -15, -58, -3, "tutorial-grid")
end

-- Left passage Extension 5 --
function createLeftPassage5(surface)
	createLeftPassage4(surface)
	if surface == nil then return end
	createTilesSurface(surface, -92, -3, -75, 3, "tutorial-grid")
	createTilesSurface(surface, -82, -15, -76, -3, "tutorial-grid")
end

-- Right passage Extension --
function createRightPassage()
	if global.MF.ccS == nil then return end
	createTilesSurface(global.MF.ccS, 10, -3, 90, 3, "tutorial-grid")
end

-- Top passage Extension 1 --
function createTopPassage1(surface)
	if surface == nil then return end
	createTilesSurface(surface, -10, -50, 10, -10, "tutorial-grid")
end

-- Create Equalizer --
function createControlCenterEqualizer()
	if global.MF.ccS == nil or global.MF.ccS.valid == false then
		game.print("Surface error")
		return
	end
	-- Create Equalizer tiles --
	createTilesSurface(global.MF.ccS, -6, -20, 6, -10, "tutorial-grid")
	-- Place the Equalizer --
	createEntity(global.MF.ccS, 1, -16, "Equalizer").minable = nil
end

-- Create MK1 Tank 1 --
function createMK1Tank1()
	createLeftPassage1(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, -17, -9, "StorageTank1MK1", "player")
	global.tankTable[1] = {ent=entity}
end

-- Create MK1 tank 2 --
function createMK1Tank2()
	createLeftPassage2(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, -35, -9, "StorageTank2MK1", "player")
	global.tankTable[2] = {ent=entity}
end

-- Create MK1 tank 3 --
function createMK1Tank3()
	createLeftPassage3(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, -53, -9, "StorageTank3MK1", "player")
	global.tankTable[3] = {ent=entity}
end

-- Create MK1 tank 4 --
function createMK1Tank4()
	createLeftPassage4(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, -71, -9, "StorageTank4MK1", "player")
	global.tankTable[4] = {ent=entity}
end

-- Create MK1 tank 5 --
function createMK1Tank5()
	createLeftPassage5(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, -89, -9, "StorageTank5MK1", "player")
	global.tankTable[5] = {ent=entity}
end

-- Create Deep Storage Building Area --
function createDeepStorageArea()
	createRightPassage()
	createTilesSurface(global.MF.ccS, 10, -30, 90, -3, "BuildTile")
end

-- Create Constructible Area 1 --
function createConstructibleArea1()
	createTopPassage1(global.MF.ccS)
	createTilesSurface(global.MF.ccS, 10, -50, 16, -46, "tutorial-grid")
	createTilesSurface(global.MF.ccS, 16, -58, 36, -38, "BuildTile")
end





