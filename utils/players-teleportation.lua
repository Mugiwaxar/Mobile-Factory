require("utils/functions.lua")

-- Teleport the player inside the Mobile Factory --
function teleportPlayerInside(player)
	if global.MF.fS == nil then game.print("Factory surface lost") return end
	if player == nil then return end
	setPlayerVariable(player.name, "VisitedFactory", true)
	-- newMobileFactory(global.MF)
	local direction = player.walking_state.direction
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
		
	player.surface.play_sound{path="MFEnter", position=player.position}
	global.MF.lastSurface = global.MF.ent.surface
end

-- Teleport the player outside the Mobile Factory --
function teleportPlayerOutside(player)
	if player.surface.name ~= _mfSurfaceName and player.surface.name ~= _mfControlSurfaceName then return end
	if global.MF == nil or global.MF.ent.valid == false then
		player.print("Unable to find the Mobile Factory vehicle (Destroyed? Changed surface?), teleporting to spawn point") 
		if global.MF.lastSurface ~= nil then
			player.teleport({0,0}, global.MF.lastSurface)
		else
			player.teleport({0,0}, "nauvis")
		end
		return
	end
	local direction = player.walking_state.direction
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
	
	player.surface.play_sound{path="MFLeave", position=player.position}
end

-- Teleport the player from the Factory to the Control Center --
function teleportPlayerToControlCenter(player)
	if global.MF.ccS == nil then game.print("Control Center surface lost") return end
	player.teleport({0,4}, global.MF.ccS)
	player.surface.play_sound{path="MFEnter", position=player.position}
end

-- Teleport the player from Control Center to the Factory --
function teleportPlayerToFactory(player)
	if global.MF.fS == nil then game.print("Factory surface lost") return end
	player.teleport({0,-30}, global.MF.fS)
	player.surface.play_sound{path="MFEnter", position=player.position}
end