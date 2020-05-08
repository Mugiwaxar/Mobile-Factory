-- Transfer Chest1 to Chest2 --
function Util.syncChest(chest1, chest2)
	local itemsTable = {}
	-- Get the Inventories --
	local inv1 = chest1.get_inventory(defines.inventory.chest)
	local inv2 = chest2.get_inventory(defines.inventory.chest)
	-- Itinerate the Inventory 1 --
	for item, count in pairs(inv1.get_contents()) do
		if itemsTable[item] ~= nil then
			itemsTable[item] = itemsTable[item] + count
		else
			itemsTable[item] = count
		end
	end
	-- Itinerate the Inventory 2 --
	for item, count in pairs(inv2.get_contents()) do
		if itemsTable[item] ~= nil then
			itemsTable[item] = itemsTable[item] + count
		else
			itemsTable[item] = count
		end
	end
	-- Clears Inventories --
	inv1.clear()
	inv2.clear()
	-- Fill the Inventories --
	for item, count in pairs(itemsTable) do
	local count1 = math.floor(count/2)
	local count2 = math.ceil(count/2)

		if count1 > 0 then
			inv1.insert({name=item, count=count1})
		end
		if count2 > 0 then
			inv2.insert({name=item, count=count2})
		end
	end
end

-- Transfer Tank1 to Tank2 --
function Util.syncTank(tank1, tank2)
	-- Check the Tanks --
	if tank1.fluidbox[1] == nil and tank2.fluidbox[1] == nil then return end
	-- Get Tanks Fluid --
	local t1FluidName = nil
	local t1FluidAmount = 0
	local t1FluidTemperature = nil
	local t2FluidName = nil
	local t2FluidAmount = 0
	local t2FluidTemperature = nil
	if tank1.fluidbox[1] ~= nil then
		t1FluidName = tank1.fluidbox[1].name
		t1FluidAmount = tank1.fluidbox[1].amount
		t1FluidTemperature = tank1.fluidbox[1].temperature

	end
	if tank2.fluidbox[1] ~= nil then
		t2FluidName = tank2.fluidbox[1].name
		t2FluidAmount = tank2.fluidbox[1].amount
		t2FluidTemperature = tank2.fluidbox[1].temperature
	end

	-- Clear the Tanks --
	tank1.clear_fluid_inside()
	tank2.clear_fluid_inside()

	-- Check the Fluids --
	if t1FluidName ~= nil and t2FluidName ~= nil and t1FluidName ~= t2FluidName then return end
	if t1FluidName == nil then t1FluidTemperature = t2FluidTemperature end
	if t2FluidName == nil then t2FluidTemperature = t1FluidTemperature end

	-- Calcul total Fluid --
	local fluidName = t1FluidName or t2FluidName
	local fluidAmount = math.floor((t1FluidAmount + t2FluidAmount) / 2)
	local fluidTemperature = math.floor((t1FluidTemperature + t2FluidTemperature) / 2)


	-- Check the Amount of Fluid --
	if fluidAmount <= 0 then return end

	-- Set Tanks Fluid --
	tank1.fluidbox[1] = {name=fluidName, amount=fluidAmount, temperature=fluidTemperature}
	tank2.fluidbox[1] = {name=fluidName, amount=fluidAmount, temperature=fluidTemperature}
end

-- Equilize the Energy between two Accumulators --
function Util.syncAccumulator(accu1, accu2)
	-- Calcul the total energy --	
	local totalEnergy = accu1.energy + accu2.energy
	-- Set the Energy of the Accumulators --
	accu1.energy = totalEnergy / 2
	accu2.energy = totalEnergy / 2
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

-- Round a Number --
function round(n)
	return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
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

-- Return the localised Entity Name --
function Util.getLocEntityName(entName)
	if game.entity_prototypes[entName] ~= nil then
		return game.entity_prototypes[entName].localised_name
	end
end

-- Return the localised Item Name --
function Util.getLocItemName(itemName)
	if game.item_prototypes[itemName] ~= nil then
		return game.item_prototypes[itemName].localised_name
	end
end

-- Return the localised Fluid Name --
function Util.getLocFluidName(fluidName)
	if game.fluid_prototypes[fluidName] ~= nil then
		return game.fluid_prototypes[fluidName].localised_name
	end
end

-- Check if an Object is valid --
function valid(obj)
	if obj == nil then return false end
	if getmetatable(obj) == nil then return false end
	if obj.valid == nil then return false end
	if type(obj.valid) == "boolean" then return obj.valid end
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
	return player.surface.find_non_colliding_position(MF.ent.name, player.position, 10, 1, true)
--[[
	-- Try to a position near the Player --
	if player.surface.can_place_entity{name=MF.ent.name, position={player.position.x+5, player.position.y}} == false then
		if player.surface.can_place_entity{name=MF.ent.name, position={player.position.x-5, player.position.y}} == false then
			if player.surface.can_place_entity{name=MF.ent.name, position={player.position.x, player.position.y+5}} == false then
				if player.surface.can_place_entity{MF.ent.name, position={player.position.x, player.position.y-5}} == false then
					player.print({"", {"gui-description.MFPlacedNoEnoughtSpace"}})
					return nil
				else return {player.position.x, player.position.y-5} end
			else return {player.position.x, player.position.y+5} end
		else return {player.position.x-5, player.position.y} end
	else return {player.position.x+5, player.position.y} end
--]]
end

-- Unlock a recipe for all Players --
function unlockRecipeForAll(recipeName, techCondition)
	if recipeName == nil then return end
	for k, force in pairs(game.forces) do
		if techCondition ~= nil and technologyUnlocked(techCondition, force) == true then
			force.recipes[recipeName].enabled = true
		end
	end
end

-- Test if player have this technologie unlocked --
function technologyUnlocked(name, force)
	if force == nil then force = game.forces["player"] end
	if force == nil then return false end
	if force.technologies[name] ~= nil and force.technologies[name].researched then return true end
	return false
end

-- Return the player object with his id --
function getPlayer(id)
	local player = nil
	return game.players[id]
end

-- Return the Player Mobile Factory --
function getMF(playerName)
	if playerName == nil then return nil
	elseif type(playerName) == "number" then return global.MFTable[game.players[playerName].name]
	elseif type(playerName) == "string" then return global.MFTable[playerName]
	else error("bad argument to getMF()") end
end

-- Return the MFPlayer Object --
function getMFPlayer(playerName)
	if playerName == nil then return nil
	elseif type(playerName) == "number" then return global.playersTable[game.players[playerName].name]
	elseif type(playerName) == "string" then return global.playersTable[playerName]
	else error("bad argument to getMFPlayer()") end
end

function Util.valueToObj(inTable, key, value)
	if value == nil then return nil end
	local Obj = nil
	for _, v in pairs(inTable) do
		if v.key == value then
			Obj = v
			break
		end
	end
	return Obj
end

-- Return the Player Force Name --
function getForce(playerName)
	return game.players[playerName].force
end

-- Get player specific variable --
function getPlayerVariable(playerName, variable)
	if global.playersTable == nil then global.playersTable = {} end
	local MFPlayer = getMFPlayer(playerName)
	if MFPlayer == nil then global.playersTable[playerName] = MFP:new(getPlayer(playerName)) end
	if MFPlayer.varTable == nil then MFPlayer.varTable = {} end
	return MFPlayer.varTable[variable]
end

-- Set player specific variable --
function setPlayerVariable(playerName, variable, value)
	if global.playersTable == nil then global.playersTable = {} end
	local MFPlayer = getMFPlayer(playerName)
	if MFPlayer == nil then global.playersTable[playerName] = MFP:new(getPlayer(playerName)) end
	if MFPlayer.varTable == nil then MFPlayer.varTable = {} end
	MFPlayer.varTable[variable] = value
end

-- Get a Data Network ID --
function getDataNetworkID()
	if global.dataNetworkID == nil then dataNetworkID = 0 end
	global.dataNetworkID = (global.dataNetworkID or 0) + 1
	return global.dataNetworkID
end

-- Try to find a lost Mobile Factory --
function findMF(player, MF)
	-- Number of Tank found --
	local mfFound = 0
	-- Last Tank found --
	local lastMFFound = nil
	-- Look for the Tank in all surfaces --
	for k, surface in pairs(game.surfaces) do
		for k2, entity in pairs(surface.find_entities_filtered{type="car"}) do
			if string.match(entity.name, "MobileFactory") and entity.last_user ~= nil and entity.last_user.name == player.name then
				mfFound = mfFound + 1
				lastMFFound = entity
			end
		end
	end
	-- Print the number of Tank found --
	player.print("Found " .. mfFound .. " Mobile Factory")
	-- Return the last Tank found --
	return lastMFFound
end

-- Define the Main Mobile Factory global variable --
function newMobileFactory(MF)
	-- Check the Mobile Factory --
	if MF == nil or MF.valid == false or MF.last_user == nil then return end
	-- Test if the Mobile Factory doesn't already exist --
	if global.MFTable[MF.last_user.name] ~= nil and global.MFTable[MF.last_user.name].ent ~= nil and global.MFTable[MF.last_user.name].valid == true then global.MFTable[MF.last_user.name].ent.destroy() end
	-- ReConstruct the MF Object --
	if global.MFTable[MF.last_user.name] == nil then
		global.MFTable[MF.last_user.name] = getMF("")
	end
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
	if MF.ent == nil or MF.ent.valid == false then
		-- Try to find it --
		tempMf = findMF(player, MF)
		if tempMf ~= nil and tempMf.valid == true then
			-- Found it, attach it to the MF object --
			player.print({"", {"gui-description.MFScanFound"}})
			newMobileFactory(tempMf)
		else
			-- Unable to find --
			player.print({"", {"gui-description.MFScanNotFound"}})
		end
	end
	-- If Factory Surface is lost --
	if MF.fS == nil or MF.fS.valid == false then
		-- Try to find it --
		tempSurface = game.get_surface(_mfSurfaceName .. player.name)
		if tempSurface ~= nil and tempSurface.valid == true then
			-- Surface found, attach it to the MF object --
			player.print({"", {"gui-description.FSFound"}})
			MF.fS = tempSurface
		else
			-- Unable to find, create a new one --
			player.print({"", {"gui-description.FSNotFound"}})
			createMFSurface(MF)
		end
	end
	-- If Control Center Surface is lost --
	if MF.ccS == nil or MF.ccS.valid == false then
		-- Try to find it --
		tempSurface = game.get_surface(_mfControlSurfaceName .. player.name)
		if tempSurface ~= nil and tempSurface.valid == true then
			-- Surface found, attach it to the MF object --
			player.print({"", {"gui-description.CCSFound"}})
			MF.ccS = tempSurface
		else
			-- Unable to find it, create a new one --
			player.print({"", {"gui-description.CCSNotFound"}})
			createControlRoom(MF)
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
				-- this check can somehow destroy Equalizer and kill player. See knownbugs.txt[1]
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
    -- Give player Mobile Factory at start --
	if settings.startup["MF-first-MF"].value == "player creation" then
		-- Add a Mobile Factory to the player inventaire --
		if inv.can_insert({name="MobileFactory"}) then
			-- Can insert --
			inv.insert({name="MobileFactory", count=1})
			player.print({"", {"gui-description.MFInsertedInsideInventory"}})
		else
			-- Can't insert --
			player.print({"", {"gui-description.MFNotInsertedInsideInventory"}})
		end
	end
	-- give Dimensional tiles, primarily for floor-is-lava --
	inv.insert({name="DimensionalTile", count=300})
end

-- Util: Create a frame from an Item --
function Util.itemToFrame(name, count, GUIObj, gui)
	-- Check value --
	if name == nil or count == nil or game.item_prototypes[name] == nil then return end
	-- Create the Button --
	local button = GUIObj:addButton("", gui, "item/" .. name, "item/" .. name, {"", Util.getLocItemName(name), ": ", Util.toRNumber(count)}, 37, true, true, count)
	button.style = "MF_Fake_Button_Blue"
	button.style.padding = 0
	button.style.margin = 0
end

-- Util: Create a frame from a Fluid --
function Util.fluidToFrame(name, count, GUIObj, gui)
	-- Check value --
	if name == nil or count == nil or game.fluid_prototypes[name] == nil then return end
	-- Create the Button --
	local button = GUIObj:addButton("", gui, "fluid/" .. name, "fluid/" .. name, {"", Util.getLocFluidName(name), ": ", Util.toRNumber(count)}, 37, true, true, count)
	button.style = "MF_Fake_Button_Purple"
	button.style.padding = 0
	button.style.margin = 0
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
	if number == nil then return 0 end
	local rNumber = number .. " "
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
	local link = nil
	if objGCN ~= nil then link = global.dataNetworkIDGreenTable[objGCN] end
	if objRCN ~= nil then link = global.dataNetworkIDRedTable[objRCN] end
	if link ~= nil and link.ent ~= nil then
		if Util.canUse(obj.player, link.ent) then return link end
	end
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

-- Return true if the Player is not inside a Mobile Factory --
function Util.isOutside(player)
	if player == nil then return true end
	if string.match(player.surface.name, _mfSurfaceName) then return false end
	if string.match(player.surface.name, _mfControlSurfaceName) then return false end
	return true
end

-- Check if the Player can interact with the Structure --
function Util.canUse(playerName, structure)
	if playerName == nil or structure == nil or structure.valid == false or structure.last_user == nil then return false end
	if playerName == structure.last_user.name then return true end
	local MF1 = getMF(playerName)
	local MF2 = getMF(structure.last_user.name)
	if MF1 ~= nil and MF2 ~= nil then
		if MF1.varTable.useSharedStructures == true and MF2.varTable.shareStructures == true then
			return true
		end
	end
	return false
end

-- Check if the Player can modify the Structure Settings --
function canModify(playerName, structure)
	if playerName == nil or structure == nil or structure.last_user == nil then return false end
	if playerName == structure.last_user.name then return true end
	local MF2 = getMF(structure.last_user.name)
	if MF2 ~= nil and MF2.varTable.allowToModify == true then
		return
	end
	return false
end

-- Check if We Have Necessary Tiles --
function checkNeededTiles()
	local tilesToCheck = {
		"BuildTile",
		"tutorial-grid",
		"VoidTile",
		"DimensionalTile",
	}

	for _, tile in pairs(tilesToCheck) do
		if game.tile_prototypes[tile] == nil then
			error("Missing "..tile..". This is likely because you have more than 255 tiles.")
		end
	end
end

function entityToBluePrintTags(entity, fromTable)
	local tags = nil
	local obj = fromTable[entity.unit_number]

	if obj and obj.settingsToTags then
		tags = obj:settingsToTags()
	end

	return tags
end