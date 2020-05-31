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
	-- Create Control Center surface --
	if valid(MF.ccS) == false then
		MF.ccS = nil
		createControlRoom(MF)
	end

	if technologyUnlocked("ControlCenter", getForce(MF.player)) == true then
		--will overwrite other tiles that are placed
		createTilesSurface(MF.fS, -3, -34, 3, -32, "refined-hazard-concrete-left")
		-- Validate the Technology --
		MF.varTable.tech.ControlCenter = true
	end
end

-- Create the Network Controller Area --
function createNetworkControllerArea(MF)
	createRightPassage(MF.ccS)
	createTilesSurface(MF.ccS, 10, 3, 90, 10, "BuildTile")
	local ent = createEntity(MF.ccS, 14, 6, "NetworkController", getMFPlayer(MF.playerIndex).ent.force, MF.playerIndex)
	MF.networkController = NC:new(ent)
end

-- Create the Jump Drive --
function createJumpDriveArea(MF)
	createTilesSurface(MF.ccS, -90, 3, -10, 10, "BuildTile")
	local jd = createEntity(MF.ccS, -14, 6, "JumpDrive", getMFPlayer(MF.playerIndex).ent.force)
	jd.last_user = MF.player
	MF.jumpDriveObj.ent = jd
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