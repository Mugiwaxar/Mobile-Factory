-------------- SURFACES UTILITIES -------------------

-- Create the Mobile Factory internal surface --
function createMFSurface()

	-- Test if the surface is not already created --
	local testSurface = game.get_surface(_mfSurfaceName)
	if testSurface ~= nil then global.MF.fS = testSurface return end
	-- Create settings --
	local mfSurfaceSettings = {
		peaceful_mode = true,
		autoplace_settings={entity={treat_missing_as_default=false},tile={treat_missing_as_default=true},decorative={treat_missing_as_default=false}},
		starting_area = "none",
		width = 1,
		height = 1
	}
	-- Set surface setting --
	local newSurface = game.create_surface(_mfSurfaceName, mfSurfaceSettings)
	newSurface.always_day = true
	newSurface.daytime = 0
	newSurface.wind_speed = 0
	-- Generate surface --
	newSurface.request_to_generate_chunks({0,0},4)
	newSurface.force_generate_chunk_requests()
	-- Set tiles --
	createTilesSurface(newSurface, -50, -50, 50, 50, "tutorial-grid")
	createTilesSurface(newSurface, -3, -3, 3, 3, "refined-concrete")
	createTilesSurface(newSurface, -1, -1, 1, 1, "refined-hazard-concrete-left")
	-- Save variable --
	global.MF.fS = newSurface
	-- Place the Factory Chest --
	global.MF.fChest = createEntity(global.MF.fS, -0, -7, "FactoryChest", "player")
end

-- Create the Mobile Factory Control room -
function createControlRoom()
	-- Test if the surface is not already created --
	local testSurface = game.get_surface(_mfControlSurfaceName)
	if testSurface ~= nil then global.MF.ccS = testSurface return end
	-- Create settings --
	local mfSurfaceSettings = {
		peaceful_mode = true,
		autoplace_settings={entity={treat_missing_as_default=false},tile={treat_missing_as_default=true},decorative={treat_missing_as_default=false}},
		starting_area = "none",
		width = 1,
		height = 1
	}
	-- Set surface setting --
	local newSurface = game.create_surface(_mfControlSurfaceName, mfSurfaceSettings)
	newSurface.always_day = true
	newSurface.daytime = 0
	newSurface.wind_speed = 0
	-- Regenerate surface --
	newSurface.request_to_generate_chunks({0,0},1)
	newSurface.force_generate_chunk_requests()
	-- Set tiles --
	createTilesSurface(newSurface, -10, -10, 10, 10, "tutorial-grid")
	-- Set TP tiles --
	createTilesSurface(newSurface, -3, 5, 2, 7, "refined-hazard-concrete-right")
	-- Set Accumulator/Substation tiles --
	createTilesSurface(newSurface, -4, 10, 3, 13, "tutorial-grid")
	-- Remove unwanted tiles --
	local newTiles = newSurface.find_tiles_filtered{area={{-100,-100},{100,100}}}
	for k, tile in pairs(newTiles) do
		if tile.name ~= "tutorial-grid" and tile.name ~= "refined-hazard-concrete-right" then
			newSurface.set_tiles({{name="out-of-map", position=tile.position}})
		end
	end
	-- Save variable --
	global.MF.ccS = newSurface
	-- Create Entities --
	createEntity(global.MF.ccS, -2, 10, "DimensionalSubstation", "player").minable = nil
	createEntity(global.MF.ccS, 2, 12, "DimensionalAccumulator", "player").minable = nil
	
end

-- Create Factory to Control Center floor --
function updateFactoryFloorForCC()
	if global.MF.fS == nil or global.MF.fS.valid == false then
		game.print("Surface error")
		return
	end
	local tilesTable = {}
	for x = -3, 2 do
	  for y = -34, -32 do
		table.insert(tilesTable, {name="refined-hazard-concrete-left",position={x,y}})
		end
	end
	global.MF.fS.set_tiles(tilesTable)
	-- Create Control Center surface --
	if global.MF.ccS == nil then createControlRoom() end
end

-- Create a new Entity --
function createEntity(surface, posX, posY, entityName, force)
	if surface == nil then game.print("createEntity: Surface nul") return end
	if force == nil then force = "player" end
	return surface.create_entity{name=entityName, position={posX,posY}, force=force}
end


















