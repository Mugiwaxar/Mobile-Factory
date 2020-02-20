require("utils/functions.lua")

-- Teleport the player inside the Mobile Factory --
function teleportPlayerInside(player, MF)
	if player == nil then return end
	if MF == nil then return end
	-- Check if the Player can enter --
	if player.name ~= MF.player and MF.locked == true then return end
	-- Check Internal Surface and Player --
	if MF.fS == nil then player.print({"", {"gui-description.FSLost"}}) return end
	-- Save the visited Factory once variable --
	if MF.ent ~= nil and MF.ent.last_user ~= nil and player.name == MF.ent.last_user.name then
		setPlayerVariable(player.name, "VisitedFactory", true)
	end
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
	if MF.fS.can_place_entity{name="character", position = position} then
		player.teleport(position, MF.fS)
	elseif MF.fS.can_place_entity{name="character", position = {2, 0}} then
		player.teleport({2,0}, MF.fS)
	elseif MF.fS.can_place_entity{name="character", position = {-2, 0}} then
		player.teleport({-2,0}, MF.fS)
	elseif MF.fS.can_place_entity{name="character", position = {0, 2}} then
		player.teleport({0,2}, MF.fS)
	else
		player.teleport({0,-2}, MF.fS)
	end
	-- Play the sound --
	player.surface.play_sound{path="MFEnter", position=player.position}
	-- Save the Mobile Factory last surface and position --
	MF.lastSurface = MF.ent.surface
	MF.lastPosX = MF.ent.position.X
	MF.lastPosY = MF.ent.position.Y
end

-- Teleport the player outside the Mobile Factory --
function teleportPlayerOutside(player)
	-- Find the Mobile Factory --
	local MF = nil
	for k, mf in pairs(global.MFTable) do
		if mf.fS ~= nil and mf.fS.valid == true and mf.fS.name == player.surface.name then
			MF = mf
		end
		if mf.ccS ~= nil and mf.ccS.valid == true and mf.ccS.name == player.surface.name then
			MF = mf
		end
	end
	if MF == nil then return end
	-- Check if the Player is on the right Surface --
	if string.match(player.surface.name, _mfSurfaceName) == nil and string.match(player.surface.name, _mfControlSurfaceName) == nil then return end
	if MF == nil then return end
	-- Check if the Mobile Factory Vehicle is valid --
	if MF.ent == nil or MF.ent.valid == false then
		-- Unable to find the Mobile Factory --
		player.print({"", {"gui-description.MFTeleportToLastPos"}}) 
		if MF.lastSurface ~= nil then
			-- Teleport the Player to the last know position --
			player.teleport({MF.lastPosX,MF.lastPosY}, MF.lastSurface)
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
		position = {MF.ent.position.x, MF.ent.position.y -5}
	elseif direction == defines.direction.northeast or direction == defines.direction.east or direction == defines.direction.southeast then
		position = {MF.ent.position.x + 2, MF.ent.position.y}
	elseif direction == defines.direction.south then
		position = {MF.ent.position.x, MF.ent.position.y + 5}
	else
		position = {MF.ent.position.x -5, MF.ent.position.y}
	end
	-- Teleport the Player --
	if MF.ent.surface.can_place_entity{name="character", position=position} then
		player.teleport(position, MF.ent.surface)
	elseif MF.ent.surface.can_place_entity{name="character", position = {MF.ent.position.x + 5, MF.ent.position.y}} then
		player.teleport({MF.ent.position.x + 5, MF.ent.position.y}, MF.ent.surface)
	elseif MF.ent.surface.can_place_entity{name="character", position = {MF.ent.position.x -5, MF.ent.position.y}} then
		player.teleport({MF.ent.position.x - 5, MF.ent.position.y}, MF.ent.surface)
	elseif MF.ent.surface.can_place_entity{name="character", position = {MF.ent.position.x, MF.ent.position.y - 7}} then
		player.teleport({MF.ent.position.x, MF.ent.position.y - 7}, MF.ent.surface)
	else
		player.teleport({MF.ent.position.x, MF.ent.position.y + 7}, MF.ent.surface)
	end
	-- Play the sound --
	player.surface.play_sound{path="MFLeave", position=player.position}
end

-- Teleport the player from the Factory to the Control Center --
function teleportPlayerToControlCenter(player, MF)
	-- Check the Player --
	if player == nil then return end
	if MF == nil then return end
	-- Check if the Control Center Surface is valid --
	if MF.ccS == nil then game.print({"", {"gui-description.CCSLost"}}) return end
	-- Teleport the Player --
	player.teleport({0,4}, MF.ccS)
	-- Play the sound --
	player.surface.play_sound{path="MFEnter", position=player.position}
end

-- Teleport the player from Control Center to the Factory --
function teleportPlayerToFactory(player, MF)
	-- Check the Player --
	if player == nil then return end
	if MF == nil then return end
	-- Check if the Factory Surface is valid --
	if MF.fS == nil then player.print({"", {"gui-description.FSLost"}}) return end
	-- Teleport the Player --
	player.teleport({0,-30}, MF.fS)
	-- Play the sound --
	player.surface.play_sound{path="MFEnter", position=player.position}
end