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

-- Right passage Extension 1 --
function createRightPassage1(surface)
	if surface == nil then return end
	createTilesSurface(surface, 10, -3, 26, 3, "tutorial-grid")
end

-- Right passage Extension 2 --
function createRightPassage2(surface)
	createRightPassage1(surface)
	if surface == nil then return end
	createTilesSurface(surface, 26, -3, 42, 3, "tutorial-grid")
end

-- Right passage Extension 3 --
function createRightPassage3(surface)
	createRightPassage2(surface)
	if surface == nil then return end
	createTilesSurface(surface, 42, -3, 58, 3, "tutorial-grid")
end

-- Right passage Extension 4 --
function createRightPassage4(surface)
	createRightPassage3(surface)
	if surface == nil then return end
	createTilesSurface(surface, 58, -3, 74, 3, "tutorial-grid")
end

-- Right passage Extension 5 --
function createRightPassage5(surface)
	createRightPassage4(surface)
	if surface == nil then return end
	createTilesSurface(surface, 74, -3, 90, 3, "tutorial-grid")
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
	global.tankTable[1] = {name="StorageTank1MK1", position={-17,-9}}
end

-- Create MK1 tank 2 --
function createMK1Tank2()
	createLeftPassage2(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, -35, -9, "StorageTank2MK1", "player")
	global.tankTable[2] = {name="StorageTank2MK1", position={-35,-9}}
end

-- Create MK1 tank 3 --
function createMK1Tank3()
	createLeftPassage3(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, -53, -9, "StorageTank3MK1", "player")
	global.tankTable[3] = {name="StorageTank3MK1", position={-53,-9}}
end

-- Create MK1 tank 4 --
function createMK1Tank4()
	createLeftPassage4(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, -71, -9, "StorageTank4MK1", "player")
	global.tankTable[4] = {name="StorageTank4MK1", position={-71,-9}}
end

-- Create MK1 tank 5 --
function createMK1Tank5()
	createLeftPassage5(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, -89, -9, "StorageTank5MK1", "player")
	global.tankTable[5] = {name="StorageTank5MK1", position={-89,-9}}
end

-- Create Ore Silot 1 --
function createOreSilot1()
	createRightPassage1(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, 18, -11, "OreSilot1", "player")
	global.oreSilotTable[1] = entity
end

-- Create Ore Silot 2 --
function createOreSilot2() --
	createRightPassage2(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, 34, -11, "OreSilot2", "player")
	global.oreSilotTable[2] = entity
end

-- Create Ore Silot 3 --
function createOreSilot3() --
	createRightPassage3(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, 50, -11, "OreSilot3", "player")
	global.oreSilotTable[3] = entity
end

-- Create Ore Silot 4 --
function createOreSilot4() --
	createRightPassage4(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, 66, -11, "OreSilot4", "player")
	global.oreSilotTable[4] = entity
end

-- Create Ore Silot 5 --
function createOreSilot5() --
	createRightPassage5(global.MF.ccS)
	local entity = createEntity(global.MF.ccS, 80, -11, "OreSilot5", "player")
	global.oreSilotTable[5] = entity
end

-- Create Constructible Area 1 --
function createConstructibleArea1()
	createTopPassage1(global.MF.ccS)
	createTilesSurface(global.MF.ccS, 10, -50, 16, -46, "tutorial-grid")
	createTilesSurface(global.MF.ccS, 16, -58, 36, -38, "BuildTile")
end





