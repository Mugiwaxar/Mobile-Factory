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
	MF.fS = newSurface
	-- Place the Factory Chest --
	MF.fChest = createEntity(MF.fS, -0, -7, "FactoryChest", getForce(MF.player).name)
	MF.fChest.last_user = MF.player
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
	-- Save variable --
	MF.ccS = newSurface
	-- Create Entities --
	local dimSub = createEntity(MF.ccS, -2, 10, "DimensionalSubstation", getForce(MF.player).name)
	dimSub.minable = nil
	dimSub.last_user = MF.player
	local DimAcc = createEntity(MF.ccS, 2, 12, "DimensionalAccumulator", getForce(MF.player).name)
	DimAcc.minable = nil
	DimAcc.last_user = MF.player
end

-- Create a new Entity --
function createEntity(surface, posX, posY, entityName, force)
	if surface == nil then game.print("createEntity: Surface nul") return end
	if force == nil then force = "player" end
	return surface.create_entity{name=entityName, position={posX,posY}, force=force}
end