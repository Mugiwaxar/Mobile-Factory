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

-- Left passage Extension --
function createLeftPassage(surface)
	if surface == nil then return end
	createTilesSurface(surface, -90, -3, -10, 3, "tutorial-grid")
end

-- Right passage Extension --
function createRightPassage(surface)
	if surface == nil then return end
	createTilesSurface(surface, 10, -3, 90, 3, "tutorial-grid")
end

-- Top passage Extension 1 --
function createTopPassage1(surface)
	if surface == nil then return end
	createTilesSurface(surface, -10, -58, 10, -10, "tutorial-grid")
end

-- Create Factory to Control Center floor --
function updateFactoryFloorForCC(MF)
	if MF.fS == nil or MF.fS.valid == false then
		game.print("Surface error")
		return
	end
	local tilesTable = {}
	for x = -3, 2 do
	  for y = -34, -32 do
		table.insert(tilesTable, {name="refined-hazard-concrete-left",position={x,y}})
		end
	end
	MF.fS.set_tiles(tilesTable)
	-- Create Control Center surface --
	if MF.ccS == nil then createControlRoom(MF) end
	-- Valid the Technology --
	MF.varTable.tech.ControlCenter = true
end

-- Create Equalizer --
function createControlCenterEqualizer(MF)
	if MF.ccS == nil or MF.ccS.valid == false then
		game.print("Surface error")
		return
	end
	-- Create Equalizer tiles --
	createTilesSurface(MF.ccS, -6, -20, 6, -10, "tutorial-grid")
	-- Place the Equalizer --
	createEntity(MF.ccS, 1, -16, "Equalizer", getForce(MF.player).name).minable = nil
	-- Valid the Technology --
	MF.varTable.tech.UpgradeModules = true
end

-- Create Deep Storage Building Area --
function createDeepStorageArea(MF)
	createRightPassage(MF.ccS)
	createTilesSurface(MF.ccS, 10, -30, 90, -3, "BuildTile")
	-- Valid the Technology --
	MF.varTable.tech.DeepStorage = true
end

-- Create Deep Tank Building Area --
function createDeepTankArea(MF)
	createLeftPassage(MF.ccS)
	createTilesSurface(MF.ccS, -90, -30, -10, -3, "BuildTile")
	-- Valid the Technology --
	MF.varTable.tech.DeepTank = true
end

-- Create Constructible Area 1 --
function createConstructibleArea1(MF)
	createTopPassage1(MF.ccS)
	createTilesSurface(MF.ccS, 10, -58, 90, -30, "BuildTile")
	-- Valid the Technology --
	MF.varTable.tech.ConstructibleArea1 = true
end

-- Create Constructible Area 2 --
function createConstructibleArea2(MF)
	createTopPassage1(MF.ccS)
	createTilesSurface(MF.ccS, -90, -58, -10, -30, "BuildTile")
	-- Valid the Technology --
	MF.varTable.tech.ConstructibleArea2 = true
end
