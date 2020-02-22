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
function createRightPassage(MF)
	if MF.ccS == nil then return end
	createTilesSurface(MF.ccS, 10, -3, 90, 3, "tutorial-grid")
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

-- Create MK1 Tank 1 --
function createMK1Tank1(MF)
	createLeftPassage1(MF.ccS)
	local entity = createEntity(MF.ccS, -17, -9, "StorageTank1MK1", getForce(MF.player).name)
	MF.varTable.tanks[1] = {ent=entity}
	-- Valid the Technology --
	MF.varTable.tech.StorageTankMK11 = true
end

-- Create MK1 tank 2 --
function createMK1Tank2(MF)
	createLeftPassage2(MF.ccS)
	local entity = createEntity(MF.ccS, -35, -9, "StorageTank2MK1", getForce(MF.player).name)
	MF.varTable.tanks[2] = {ent=entity}
	-- Valid the Technology --
	MF.varTable.tech.StorageTankMK12 = true
end

-- Create MK1 tank 3 --
function createMK1Tank3(MF)
	createLeftPassage3(MF.ccS)
	local entity = createEntity(MF.ccS, -53, -9, "StorageTank3MK1", getForce(MF.player).name)
	MF.varTable.tanks[3] = {ent=entity}
	-- Valid the Technology --
	MF.varTable.tech.StorageTankMK13 = true
end

-- Create MK1 tank 4 --
function createMK1Tank4(MF)
	createLeftPassage4(MF.ccS)
	local entity = createEntity(MF.ccS, -71, -9, "StorageTank4MK1", getForce(MF.player).name)
	MF.varTable.tanks[4] = {ent=entity}
	-- Valid the Technology --
	MF.varTable.tech.StorageTankMK14 = true
end

-- Create MK1 tank 5 --
function createMK1Tank5(MF)
	createLeftPassage5(MF.ccS)
	local entity = createEntity(MF.ccS, -89, -9, "StorageTank5MK1", getForce(MF.player).name)
	MF.varTable.tanks[5] = {ent=entity}
	-- Valid the Technology --
	MF.varTable.tech.StorageTankMK15 = true
end

-- Upgrade a Tank to MK2 --
function upgradeTank(id, MF)
	if MF.ccS == nil or MF.varTable.tanks == nil then return end
	-- Get the tank ID --
	local tankId = MF.varTable.tanks[id]
	if tankId == nil then return end
	-- Get The Tank --
	local tank = MF.varTable.tanks[id].ent
	-- Test if there are fluid inside --
	if tank.get_fluid_count() > 0 then 
		local fluid = tank.get_fluid_contents()
		local name
		local amount
		-- Get the fluid --
		for n, a in pairs(fluid) do
			name = n
			amount = a
		end
		if name == nil or amount == nil then game.print("upgradeTank() error for id: " .. id) return end
		-- Create the new tank --
		local newTank = MF.ccS.create_entity{name="StorageTank".. id .."MK2", position=tank.position, force=getForce(MF.player).name}
		-- Fill the fluid --
		newTank.insert_fluid({name=name, amount=amount})
		-- Save the tank --
		MF.varTable.tanks[id].ent = newTank
	else
		-- Create the new tank --
		local newTank = MF.ccS.create_entity{name="StorageTank".. id .."MK2", position=tank.position, force=getForce(MF.player).name}
		-- Save the tank --
		MF.varTable.tanks[id].ent = newTank
	end
	-- Destroy the old Tank --
	tank.destroy()
	-- Valid the Technology --
	MF.varTable.tech["StorageTankMK2" .. id] = true
end

-- Create Deep Storage Building Area --
function createDeepStorageArea(MF)
	createRightPassage(MF)
	createTilesSurface(MF.ccS, 10, -30, 90, -3, "BuildTile")
	-- Valid the Technology --
	MF.varTable.tech.DeepStorage = true
end

-- Create Constructible Area 1 --
function createConstructibleArea1(MF)
	createTopPassage1(MF.ccS)
	createTilesSurface(MF.ccS, 10, -58, 90, -30, "BuildTile")
	-- Valid the Technology --
	MF.varTable.tech.ConstructibleArea1 = true
end