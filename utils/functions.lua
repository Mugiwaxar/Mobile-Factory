-- Put all items in inventory1 to inventory2 --
function synchronizeInventory(inventory1, inventory2, filter, ignoreDrone)
	-- Get the content of the Inventory 1 --
	local allItems = inventory1.get_contents()
	-- Itinerate all items --
	for item, amount in pairs(allItems) do
		-- Check if this is a drone --
		if ignoreDrone == true and (item == "MiningJet" or item == "ConstructionJet" or item == "RepairJet" or item == "CombatJet" )then
		else
			-- Test if there are a filter --
			if filter == nil or (filter ~= nil and filter == item) then 
				-- Insert items --
				local count = inventory2.insert({name=item, count=amount})
				-- Remove items from the Inventory 1 --
				if count > 0 then
					inventory1.remove({name=item, count=count})
				else
					break
				end
			end
		end
	end
end

-- Advenced print --
function dprint(v)
	game.print(serpent.block(v))
end

-- Print all Keys --
function dprintKeys(t)
	dprint("--- KEYS ---")
	for k, j in pairs(t) do
		dprint(k)
	end
	dprint("------------")
end

-- Return a splitted table of a string --
function split(str, char)
   char = "[^" .. char .."]+"
   local parts = {__index = table.insert}
   setmetatable(parts, parts)
   str:gsub(char, parts)
   setmetatable(parts, nil)
   parts.__index = nil
   return parts
end

-- Check if an Object is valid --
function valid(obj)
	if obj == nil then return false end
	if getmetatable(obj) == nil then return false end
	if obj.valid == nil then return false end
	if obj:valid() ~= true then return false end
	return true
end

-- Test if Mobile Factory can be placed near a player --
function mfPlaceable(player, MF)
	-- Make the Mobile Factory unable to be placed inside it --
	if string.match(player.surface.name, _mfSurfaceName) or string.match(player.surface.name, _mfControlSurfaceName) then
		player.print({"", {"gui-description.MFPlacedInsideFactory"}})
		return nil
	end
	-- Make the Mobile Factory unable to be placed inside a Factorissimo Structure --
	if string.match(player.surface.name, "Factory") then
		player.print({"", {"gui-description.MFPlacedInsideFactorissimo"}})
		return nil
	end
	-- Try to a position near the Player --
	if player.surface.can_place_entity{name=MF.ent.name, position={player.position.x+5, player.position.y}} == false then
		if player.surface.can_place_entity{MF.ent.name, position={player.position.x-5, player.position.y}} == false then
			if player.surface.can_place_entity{MF.ent.name, position={player.position.x, player.position.y+5}} == false then
				if player.surface.can_place_entity{MF.ent.name, position={player.position.x, player.position.y-5}} == false then
					player.print({"", {"gui-description.MFPlacedNoEnoughtSpace"}})
					return nil
				else return {player.position.x, player.position.y-5} end
			else return {player.position.x, player.position.y+5} end
		else return {player.position.x-5, player.position.y} end
	else return {player.position.x+5, player.position.y} end
end

-- Test if player have this technologie unlocked --
function technologyUnlocked(name)
	for _, force in pairs(game.forces) do
		if force.name == "player" and force.technologies[name] ~= nil and  force.technologies[name].researched then
			return true
		else
			return false
		end
	end
end

-- Return the player object with his id --
function getPlayer(id)
	return game.players[id]
end

-- Return the Player Mobile Factory --
function getMF(playerName)
	if playerName == nil then return nil end
	return global.MFTable[playerName]
end

-- Get player specific variable --
function getPlayerVariable(playerName, variable)
	if global.playersTable == nil then global.playersTable = {} end
	if global.playersTable[playerName] == nil then global.playersTable[playerName] = {} end
	return global.playersTable[playerName][variable]
end

-- Set player specific variable --
function setPlayerVariable(playerName, variable, value)
	if global.playersTable == nil then global.playersTable = {} end
	if global.playersTable[playerName] == nil then global.playersTable[playerName] = {} end
	global.playersTable[playerName][variable] = value
end

-- Get a Data Network ID --
function getDataNetworkID()
	if global.dataNetworkID == nil then dataNetworkID = 0 end
	global.dataNetworkID = (global.dataNetworkID or 0) + 1
	return global.dataNetworkID
end

-- Try to find a lost Mobile Factory --
-- function findMF(player, MF)
-- 	-- Number of Tank found --
-- 	local mfFound = 0
-- 	-- Last Tank found --
-- 	local lastMFFound = nil
-- 	-- Look for the Tank in all surfaces --
-- 	for k, surface in pairs(game.surfaces) do
-- 		for k2, entity in pairs(surface.find_entities_filtered{type="car"}) do
-- 			if string.match(entity.name, "MobileFactory") then
-- 				mfFound = mfFound + 1
-- 				lastMFFound = entity
-- 			end
-- 		end
-- 	end
-- 	-- Print the number of Tank found --
-- 	game.print("Found " .. mfFound .. " Mobile Factory")
-- 	-- Return the last Tank found --
-- 	return lastMFFound
-- end

-- Define the Main Mobile Factory global variable --
function newMobileFactory(MF)
	-- Check the Mobile Factory --
	if MF == nil or MF.valid == false or MF.last_user == nil then return end
	-- Test if the Mobile Factory doesn't already exist --
	if global.MFTable[MF.last_user.name] ~= nil and global.MFTable[MF.last_user.name].ent ~= nil and global.MFTable[MF.last_user.name].valid == true then global.MFTable[MF.last_user.name].ent.destroy() end
	-- ReConstruct the MF Object --
	global.MFTable[MF.last_user.name]:construct(MF)
	-- Check all Technologies --
	checkTechnologies(global.MFTable[MF.last_user.name])
end

-- If Mobile Factory or his surfaces are broken, try to fix them --
function fixMB(event)
	-- Get the Mobile Factory --
	local player = getPlayer(event.player_index)
	if player == nil then return end
	local MF = getMF(player.name)
	if MF == nil then return end
	-- If Mobile Factory is lost --
	-- if MF.ent == nil or MF.ent.valid == false then
	-- 	-- Try to find it --
	-- 	tempMf = findMF(player, MF)
	-- 	if tempMf ~= nil and tempMf.valid == true then
	-- 		-- Found it, attach it to the MF object --
	-- 		game.print({"", {"gui-description.MFScanFound"}})
	-- 		newMobileFactory(tempMf)
	-- 	else
	-- 		-- Unable to find --
	-- 		game.print({"", {"gui-description.MFScanNotFound"}})
	-- 	end
	-- end
	-- If Factory Surface is lost --
	if MF.fS == nil or MF.fS.valid == false then
		-- Try to find it --
		tempSurface = game.get_surface(_mfSurfaceName .. player.name)
		if tempSurface ~= nil and tempSurface.valid == true then
			-- Surface found, attach it to the MF object --
			game.print({"", {"gui-description.FSFound"}})
			MF.fS = tempSurface
		else
			-- Unable to find, create a new one --
			game.print({"", {"gui-description.FSNotFound"}})
			createMFSurface(MF)
		end
	end
	-- If Control Center Surface is lost --
	if MF.ccS == nil or MF.ccS.valid == false then
		-- Test if the Technology is unlocked --
		if technologyUnlocked("ControlCenter") == true then
			-- Try to find it --
			tempSurface = game.get_surface(_mfControlSurfaceName .. player.name)
			if tempSurface ~= nil and tempSurface.valid == true then
				-- Surface found, attach it to the MF object --
				game.print({"", {"gui-description.CCSFound"}})
				MF.ccS = tempSurface
			else
				-- Unable to find it, create a new one --
				game.print({"", {"gui-description.CCSNotFound"}})
				createControlRoom(MF)
			end
		end
	end
end
	
-- Call the mobile Factory near the player
function callMobileFactory(player)
	-- Get the Mobile Factory --
	local MF = getMF(player.name)
	-- Check if the Mobile Factory exist --
	if MF ~= nil and MF.ent == nil or MF.ent.valid == false then
		player.print({"", {"gui-description.MFLostOrDestroyed"}})
		return
	end
	-- Test if the Jump Drives are ready --
	if MF.jumpTimer > 0 then
		player.print({"", {"gui-description.MFJumpDriveRecharging"}})
		return
	end
	-- Try to find the best coords --
	local coords = mfPlaceable(player, MF)
	-- Return if any coords was found --
	if coords == nil then return end
	-- Teleport the Mobile Factory to the cords --
	MF.ent.teleport(coords, player.surface)
	-- Try to find the Mobile Factory if it is lost --
	if MF.ent == nil or MF.ent.valid == false then
		MF.ent = player.surface.find_entity("MobileFactory", coords)
	end
	-- Save the position --
	MF.lastSurface = MF.ent.surface
	MF.lastPosX = MF.ent.position.x
	MF.lastPosY = MF.ent.position.y
	-- Discharge the Jump Drives --
	MF.jumpTimer = MF.baseJumpTimer
end

-- Create Tiles at the given position and radius --
function createTilesAtPosition(position, radius, surface, tileName, force)
	-- Check all variables --
	if position == nil or radius == nil or surface == nil then return end
	if tileName == nil then tileName = "tutorial-grid" end
	-- Ajust the radius --
	radius = radius - 1
	-- Create all tiles --
	local tilesTable = {}
	for x = 0 - radius, radius do
		for y = 0 - radius, radius do
			posX = math.floor(position.x) + x
			posY = math.floor(position.y) + y
			tilesFind = surface.find_tiles_filtered{area={{posX, posY},{posX+1, posY+1}}}
			local replace = true
			for k, tile in pairs(tilesFind) do
				if tileName == "tutorial-grid" and tile.name ~= "VoidTile" then
					replace = false
				end
			end
			if force == true or replace == true then
				table.insert(tilesTable, {name=tileName, position={posX, posY}})
			end
		end
	end
	-- Set tiles --
	if table_size(tilesTable) > 0 then surface.set_tiles(tilesTable) end
end

-- Add a Mobile Factory to a player inventory --
function Util.addMobileFactory(player)
	-- Get the Player Inventory --
	local inv = player.get_main_inventory()
	-- Add a Mobile Factory to the player inventaire --
	if inv.can_insert({name="MobileFactory"}) then
		-- Can insert --
		inv.insert({name="MobileFactory", count=1})
		player.print({"", {"gui-description.MFInsertedInsideInventory"}})
	else
		-- Can't insert --
		player.print({"", {"gui-description.MFNotInsertedInsideInventory"}})
	end
	inv.insert({name="DimensionalTile", count=300})
end

-- Util: Create a frame from an Item --
function Util.itemToFrame(item, amount, guiElement)
	-- Check value --
	if item == nil or amount == nil or game.item_prototypes[item] == nil then return end
	-- Create the Frame --
	local frame = guiElement.add{type="frame", direction="horizontal"}
	frame.style.minimal_width = 75
	frame.style.margin = 0
	frame.style.padding = 0
	-- Add the Icon and the Tooltip to the frame --
	local sprite = frame.add{type="sprite", tooltip=game.item_prototypes[item].localised_name, sprite="item/" .. item}
	sprite.style.padding = 0
	sprite.style.margin = 0
	-- Add the amount label --
	local label = frame.add{type="label", caption=Util.toRNumber(amount)}
	label.style.padding = 0
	label.style.margin = 0
end

-- Util: Create a text Label from an Item --
function Util.itemToLabel(item, amount, guiElement)
	-- Check value --
	if item == nil or amount == nil then return end
	-- Create the Frame --
	local frame = guiElement.add{type="flow", direction="horizontal"}
	frame.style.margin = 0
	frame.style.padding = 0
	-- Add the Icon and the Tooltip to the frame --
	local sprite = frame.add{type="sprite", tooltip=game.item_prototypes[item].localised_name, sprite="item/" .. item}
	sprite.style.padding = 0
	sprite.style.margin = 0
	-- Add the amount label --
	local label = frame.add{type="label", caption=Util.toRNumber(amount)}
	label.style.padding = 0
	label.style.margin = 0
	label.style.font = "LabelFont"
end

-- Util: Randomize Table --
function Util.shuffle(array)
	for i = table_size(array), 2, -1 do
		local j = math.random(i)
		array[i], array[j] = array[j], array[i]
	end
	return array
end

-- Util: Get Object ID --
function Util.getEntID(array)
	local tmpArray = {}
	local id = 0
	local highId = 0
	for k, obj in pairs(array) do
		tmpArray[obj.ID] = obj
		if obj.ID > highId then
			highId = obj.ID
		end
	end
	id = table_size(tmpArray) + 1
	local i = 1
	while i < highId do
		if tmpArray[i] == nil then
			id = i
			break
		end
		i = i + 1
	end
	return id
end

-- Calcule the Distance between two Positions --
function Util.distance(position1, position2)
  local x1 = position1[1] or position1.x
  local y1 = position1[2] or position1.y
  local x2 = position2[1] or position2.x
  local y2 = position2[2] or position2.y
  return ((x1 - x2) ^ 2 + (y1 - y2) ^ 2) ^ 0.5
end

-- Transform big numbers to readable numbers --
function Util.toRNumber(number)
	local rNumber = number
	if number >= 1000 and number < 1000000 then
		rNumber = tostring(math.floor(number/10)/100) .. " k"
	elseif number >= 1000000 and number < 1000000000 then
		rNumber = tostring(math.floor(number/10000)/100) .. " M"
	elseif number >= 1000000000 then
		rNumber = tostring(math.floor(number/10000000)/100) .. " G"
	end
	return rNumber
end

-- Get the Green Circuit Network ID --
function Util.greenCNID(obj)
	if obj == nil or obj.ent == nil or obj.ent.valid == false then return nil end
	if obj.ent.get_circuit_network(defines.wire_type.green) ~= nil and obj.ent.get_circuit_network(defines.wire_type.green).valid == true and obj.ent.get_circuit_network(defines.wire_type.green) ~= 0 then
		return obj.ent.get_circuit_network(defines.wire_type.green).network_id
	end
	return nil
end

-- Get the Red Circuit Network ID --
function Util.redCNID(obj)
	if obj == nil or obj.ent == nil or obj.ent.valid == false then return nil end
	if obj.ent.get_circuit_network(defines.wire_type.red) ~= nil and obj.ent.get_circuit_network(defines.wire_type.red).valid == true and obj.ent.get_circuit_network(defines.wire_type.red) ~= 0 then
		return obj.ent.get_circuit_network(defines.wire_type.red).network_id
	end
	return nil
end

-- Check if the Object is connected with a Data Network and return it --
function Util.getConnectedDN(obj)
	-- Check the Object --
	if obj == nil or obj.ent == nil or obj.ent.valid == false then return nil end
	-- Get Green and Red Circuit Network ID --
	local objGCN = Util.greenCNID(obj)
	local objRCN = Util.redCNID(obj)
	-- Check if the Object is inside a Data Network --
	if objGCN ~= nil then return global.dataNetworkIDGreenTable[objGCN] end
	if objRCN ~= nil then return global.dataNetworkIDRedTable[objRCN] end
	return nil
end

-- Copy a Table --
function Util.copyTable(t1)
	local t2 = {}
	for k, j in pairs(t1 or {}) do
		t2[k] = j
	end
	return t2
end
























