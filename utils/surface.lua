-------------- SURFACES UTILITIES -------------------

-- Create the Mobile Factory internal surface --
function createMFSurface(MF)
	-- Test if the surface is not already created --
	local testSurface = game.get_surface(_mfSurfaceName .. MF.player)
	if testSurface ~= nil then MF.fS = testSurface return end
	-- Create settings --
	local mfSurfaceSettings = {
		default_enable_all_autoplace_controls = false,
		property_expression_names = {cliffiness = 0},
		peaceful_mode = true,
		autoplace_settings = {tile = {settings = { ["VoidTile"] = {frequency="normal", size="normal", richness="normal"} }}},
		starting_area = "none",
	}
	-- Set surface setting --
	local newSurface = game.create_surface(_mfSurfaceName .. MF.player, mfSurfaceSettings)
	newSurface.always_day = false
	newSurface.daytime = game.get_surface("nauvis").daytime
	newSurface.wind_speed = 0
	-- Generate surface --
	newSurface.request_to_generate_chunks({0,0},4)
	newSurface.force_generate_chunk_requests()
	-- Set tiles --
	createTilesSurface(newSurface, -50, -50, 50, 50, "tutorial-grid")
	createTilesSurface(newSurface, _mfSyncAreaPosition.x - _mfSyncAreaRadius, _mfSyncAreaPosition.y - _mfSyncAreaRadius, _mfSyncAreaPosition.x + _mfSyncAreaRadius, _mfSyncAreaPosition.y + _mfSyncAreaRadius, "dirt-7")
	createTilesSurface(newSurface, _mfSyncAreaPosition.x - 2, _mfSyncAreaPosition.y - 4, _mfSyncAreaPosition.x + 2, _mfSyncAreaPosition.y + 4, "DimensionalTile")
	createTilesSurface(newSurface, -2, -2, 2, 2, "refined-hazard-concrete-right")
	-- Save variable --
	MF.fS = newSurface
end

-- Create the Mobile Factory Control room -
function createControlRoom(MF)
	-- Test if the surface is not already created --
	local testSurface = game.get_surface(_mfControlSurfaceName .. MF.player)
	if testSurface ~= nil then MF.ccS = testSurface return end
	-- Create settings --
	local mfSurfaceSettings = {
		default_enable_all_autoplace_controls = false,
		property_expression_names = {cliffiness = 0},
		peaceful_mode = true,
		autoplace_settings = {tile = {settings = { ["VoidTile"] = {frequency="normal", size="normal", richness="normal"} }}},
		starting_area = "none",
	}
	-- Set surface setting --
	local newSurface = game.create_surface(_mfControlSurfaceName .. MF.player, mfSurfaceSettings)
	newSurface.always_day = false
	newSurface.daytime = game.get_surface("nauvis").daytime
	newSurface.wind_speed = 0
	-- Regenerate surface --
	newSurface.request_to_generate_chunks({0,0},1)
	newSurface.force_generate_chunk_requests()
	-- Set tiles --
	createTilesSurface(newSurface, -10, -10, 10, 10, "tutorial-grid")
	-- Set TP tiles --
	createTilesSurface(newSurface, -3, 5, 3, 7, "refined-hazard-concrete-right")
	-- Remove unwanted tiles --
	local newTiles = newSurface.find_tiles_filtered{area={{-100,-100},{100,100}}}
	-- Save variable --
	MF.ccS = newSurface
end

-- Create a new Entity --
function createEntity(surface, posX, posY, entityName, force)
	if surface == nil then game.print("createEntity: Surface nul") return end
	if force == nil then force = "player" end
	return surface.create_entity{name=entityName, position={posX,posY}, force=force}
end

-- Create the Sync Area Surface --
function createSyncAreaMFSurface(surface, dirt)
	local radius = _mfSyncAreaRadius + 1
	if dirt == true then
		createTilesSurface(surface, _mfSyncAreaPosition.x - radius, _mfSyncAreaPosition.y - radius, _mfSyncAreaPosition.x + radius, _mfSyncAreaPosition.y + radius, "dirt-7")
	end
	createTilesSurface(surface, _mfSyncAreaPosition.x - 2, _mfSyncAreaPosition.y - 4, _mfSyncAreaPosition.x + 2, _mfSyncAreaPosition.y + 4, "DimensionalTile")
	createTilesSurface(surface, _mfSyncAreaPosition.x - 4, _mfSyncAreaPosition.y - 2, _mfSyncAreaPosition.x + 4, _mfSyncAreaPosition.y + 2, "DimensionalTile")
	createTilesSurface(surface, _mfSyncAreaPosition.x - 3, _mfSyncAreaPosition.y - 3, _mfSyncAreaPosition.x + 3, _mfSyncAreaPosition.y + 3, "DimensionalTile")
	createTilesSurface(surface, -1, -1, 1, 1, "refined-hazard-concrete-right")
end