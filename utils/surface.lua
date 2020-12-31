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
	createTilesSurface(newSurface, -3, -4, 3, 4, "concrete")
    createTilesSurface(newSurface, -1, -1, 1, 1, "refined-hazard-concrete-right")
	-- Save variable --
	MF.fS = newSurface
	-- Create CC and apply researches if needed --
	--these functions should be rewritten so create control room->apply researches
	_G[_MFResearches["ControlCenter"]](MF)
end

-- Create the Mobile Factory Control room -
function createControlRoom(MF)
	-- Test if the surface is not already created --
	local testSurface = game.get_surface(_mfControlSurfaceName .. MF.player)
	if testSurface ~= nil then
		MF.ccS = testSurface
		return
	else
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
		-- Create Internal Power Cubes --
		local iec = createEntity(newSurface, 7, 6, "InternalEnergyCube", getMFPlayer(MF.playerIndex).ent.force)
		iec.last_user = MF.player
		if valid(MF.internalEnergyObj) == false then MF.internalEnergyObj = IEC:new(MF) end
		MF.internalEnergyObj:setEnt(iec)
		MF.internalEnergyObj:addEnergy(.5 * _mfInternalEnergyMax)
		-- Create Internal Quatron Cubes --
		local iqc = createEntity(newSurface, -7, 6, "InternalQuatronCube", getMFPlayer(MF.playerIndex).ent.force)
		iqc.last_user = MF.player
		if valid(MF.internalQuatronObj) == false then MF.internalQuatronObj = IQC:new(MF) end
		MF.internalQuatronObj:setEnt(iqc)
		-- Save variable --
		MF.ccS = newSurface
	end

	-- Apply Technologies if Needed --
	local force = getForce(MF.player)
	for research, func in pairs(_MFResearches) do
		if research ~= "ControlCenter" and Util.technologyUnlocked(research, force) then
			_G[func](MF)
		end
	end
end

-- Create a new Entity --
function createEntity(surface, posX, posY, entityName, force, player)
	if surface == nil then game.print("createEntity: Surface nul") return end
	if force == nil then force = "player" end
	return surface.create_entity{name=entityName, position={posX,posY}, force=force, player=player}
end

-- Create the Sync Area Surface --
-- function createSyncAreaMFSurface(surface, dirt)
-- 	local radius = _mfSyncAreaRadius + 1
-- 	validateSyncAreaTile()
-- 	if dirt == true then
-- 		createTilesSurface(surface, _mfSyncAreaPosition.x - radius, _mfSyncAreaPosition.y - radius, _mfSyncAreaPosition.x + radius, _mfSyncAreaPosition.y + radius, global.syncTile)
-- 	end
-- 	createTilesSurface(surface, _mfSyncAreaPosition.x - 2, _mfSyncAreaPosition.y - 4, _mfSyncAreaPosition.x + 2, _mfSyncAreaPosition.y + 4, "DimensionalTile")
-- 	createTilesSurface(surface, _mfSyncAreaPosition.x - 4, _mfSyncAreaPosition.y - 2, _mfSyncAreaPosition.x + 4, _mfSyncAreaPosition.y + 2, "DimensionalTile")
-- 	createTilesSurface(surface, _mfSyncAreaPosition.x - 3, _mfSyncAreaPosition.y - 3, _mfSyncAreaPosition.x + 3, _mfSyncAreaPosition.y + 3, "DimensionalTile")
-- 	createTilesSurface(surface, -1, -1, 1, 1, "refined-hazard-concrete-right")
-- end

-- function validateSyncAreaTile()
-- 	-- Workaround if Un-Inited, Simpler Than Migration --
-- 	if global.syncTile == nil then
-- 		global.syncTile = "dirt-7"
-- 	end
-- 	-- Workaround if Default Sync Tile dirt-7 Is Missing --
-- 	if game.tile_prototypes[global.syncTile] == nil then
-- 		global.syncTile = nil

-- 		-- Check for grass-1 First --
-- 		for tileName in pairs(game.tile_prototypes) do
-- 			-- Alien Biomes (or other mod) leaves grass-1 alone, but makes all dirt colorful
-- 			if string.find(tileName, "grass") then
-- 				global.syncTile = tileName
-- 				break
-- 			end
-- 		end

-- 		if global.syncTile == nil then
-- 			for tileName in pairs(game.tile_prototypes) do
-- 				if string.find(tileName, "dirt") then
-- 					global.syncTile = tileName
-- 					break
-- 				end
-- 			end			
-- 		end
-- 		if global.syncTile == nil then
-- 			error("Unable to find suitable tile for Sync Area.")
-- 		end
-- 	end
-- end