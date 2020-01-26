require("utils/functions.lua")

-- Teleport the player inside the Mobile Factory --
function teleportPlayerInside(player)
	-- Check Internal Surface and Player --
	if global.MF.fS == nil then game.print("Factory surface lost") return end
	if player == nil then return end
	-- Save the visited Factory once variable --
	setPlayerVariable(player.name, "VisitedFactory", true)
	-- Get the Player direction --
	local direction = player.walking_state.direction
	-- Calcul the future position --
	local position
	if direction == defines.direction.north then
		position = {0,-2}
	elseif direction == defines.direction.northeast or direction == defines.direction.east or direction == defines.direction.southeast then
		position = {2,0}
	elseif direction == defines.direction.south then
		position = {0,2}
	else
		position = {-2,0}
	end
	--Test where the Player can be teleported and teleport the Player --
	if global.MF.fS.can_place_entity{name="character", position = position} then
		player.teleport(position, global.MF.fS)
	elseif global.MF.fS.can_place_entity{name="character", position = {2, 0}} then
		player.teleport({2,0}, global.MF.fS)
	elseif global.MF.fS.can_place_entity{name="character", position = {-2, 0}} then
		player.teleport({-2,0}, global.MF.fS)
	elseif global.MF.fS.can_place_entity{name="character", position = {0, 2}} then
		player.teleport({0,2}, global.MF.fS)
	else
		player.teleport({0,-2}, global.MF.fS)
	end
	-- Play the sound --
	player.surface.play_sound{path="MFEnter", position=player.position}
	-- Save the Mobile Factory last surface and position --
	global.MF.lastSurface = global.MF.ent.surface
	global.MF.lastPosX = global.MF.ent.position.X
	global.MF.lastPosY = global.MF.ent.position.Y
end

-- Teleport the player outside the Mobile Factory --
function teleportPlayerOutside(player)
	-- Check if the Player is on the right Surface --
	if player.surface.name ~= _mfSurfaceName and player.surface.name ~= _mfControlSurfaceName then return end
	-- Check if the Mobile Factory Vehicle is valid --
	if global.MF == nil or global.MF.ent.valid == false then
		-- Unable to find the Mobile Factory --
		player.print("Unable to find the Mobile Factory vehicle (Destroyed? Changed surface?), teleporting to spawn point") 
		if global.MF.lastSurface ~= nil then
			-- Teleport the Player to the last know position --
			player.teleport({0,0}, global.MF.lastSurface)
		else
			-- Teleport the Player to the spawm point --
			player.teleport({0,0}, "nauvis")
		end
		return
	end
	-- Get the Player direction --
	local direction = player.walking_state.direction
	-- Calcul the future position --
	local position
	if direction == defines.direction.north then
		position = {global.MF.ent.position.x, global.MF.ent.position.y -5}
	elseif direction == defines.direction.northeast or direction == defines.direction.east or direction == defines.direction.southeast then
		position = {global.MF.ent.position.x + 2, global.MF.ent.position.y}
	elseif direction == defines.direction.south then
		position = {global.MF.ent.position.x, global.MF.ent.position.y + 5}
	else
		position = {global.MF.ent.position.x -5, global.MF.ent.position.y}
	end
	-- Teleport the Player --
	if global.MF.ent.surface.can_place_entity{name="character", position=position} then
		player.teleport(position, global.MF.ent.surface)
	elseif global.MF.ent.surface.can_place_entity{name="character", position = {global.MF.ent.position.x + 5, global.MF.ent.position.y}} then
		player.teleport({global.MF.ent.position.x + 5, global.MF.ent.position.y}, global.MF.ent.surface)
	elseif global.MF.ent.surface.can_place_entity{name="character", position = {global.MF.ent.position.x -5, global.MF.ent.position.y}} then
		player.teleport({global.MF.ent.position.x - 5, global.MF.ent.position.y}, global.MF.ent.surface)
	elseif global.MF.ent.surface.can_place_entity{name="character", position = {global.MF.ent.position.x, global.MF.ent.position.y - 7}} then
		player.teleport({global.MF.ent.position.x, global.MF.ent.position.y - 7}, global.MF.ent.surface)
	else
		player.teleport({global.MF.ent.position.x, global.MF.ent.position.y + 7}, global.MF.ent.surface)
	end
	-- Play the sound --
	player.surface.play_sound{path="MFLeave", position=player.position}
end

-- Teleport the player from the Factory to the Control Center --
function teleportPlayerToControlCenter(player)
	-- Check the Player --
	if player == nil then return end
	-- Check if the Control Center Surface is valid --
	if global.MF.ccS == nil then game.print("Control Center surface lost") return end
	-- Teleport the Player --
	player.teleport({0,4}, global.MF.ccS)
	-- Play the sound --
	player.surface.play_sound{path="MFEnter", position=player.position}
end

-- Teleport the player from Control Center to the Factory --
function teleportPlayerToFactory(player)
	-- Check if the Factory Surface is valid --
	if global.MF.fS == nil then game.print("Factory surface lost") return end
	-- Teleport the Player --
	player.teleport({0,-30}, global.MF.fS)
	-- Play the sound --
	player.surface.play_sound{path="MFEnter", position=player.position}
end