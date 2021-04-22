require("utils/players-teleportation.lua")
require("utils/surface")
require("utils/functions.lua")
require("scripts/update-system.lua")
require("utils/place-and-remove.lua")


-- Update all entities --
function updateEntities(event)
	-- Update System --
	UpSys.update(event)
	updateAllRCL()
end

-- Check all Technologies of a Player Mobile Factory --
function checkTechnologies(MF)
	local force = getForce(MF.player)
	for research, func in pairs(_MFResearches) do
		if Util.technologyUnlocked(research, force) == true and MF.varTable.tech[research] ~= true then _G[func](MF) end
	end
end

-- Called after an Entity die --
function Event.ghostPlacedByDie(event)
	-- Raise event if a Blueprint is placed --
	if event.ghost ~= nil and event.ghost.valid == true then
		Event.somethingWasPlaced({entity=event.ghost})
	end
end

-- Damage all Players that aren't on a safe position --
function updateFloorIsLava()
	-- Take all Players --
	for _, player in pairs(game.players) do
		-- Check the Player --
		if player.character == nil then return end
		-- Check the Surface --
		if string.match(player.surface.name, _mfSurfaceName) or string.match(player.surface.name, _mfControlSurfaceName) or string.match(player.surface.name, "Factory") then return end
		-- Check the Tile --
		local tile = player.surface.get_tile(player.position.x, player.position.y)
		if tile ~= nil and tile.valid == true and tile.name ~= "DimensionalTile" then
			player.character.damage(50, "neutral", "fire")
		end
	end
end

-- Update all Mobile Factory Internal Lights --
function updateIndoorLights()
	for _, MF in pairs(global.MFTable) do
		if EI.energy(MF.internalEnergyObj) > 0 then
			MF.fS.daytime = 0
			MF.ccS.daytime = 0
		else
			MF.fS.daytime = 0.5
			MF.ccS.daytime = 0.5
		end
	end
end

-- Update all Resources Collectors --
function updateAllRCL()
	for _, rcl in pairs(global.ResourceCollectorTable) do
		if game.tick - rcl.lastUpdate > _mfRCLUpdateTick then
			RCL.update(rcl)
		end
	end
end