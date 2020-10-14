-- Create all Objects Table --
function Util.createTableList()
	global.objTable = {}
	Util.addObject{tableName="playersTable", tag="MFP", objName="MFPlayer", noPlaced=true, noUpsys=true}
	Util.addObject{tableName="MFTable", tag="MF", objName="MF", noPlaced=true}
	-- Util.addObject{tableName="eryaTable", tag="ES", objName="Erya"}
	Util.addObject{tableName="matterInteractorTable", tag="MI", objName="MatterInteractor"}
	Util.addObject{tableName="fluidInteractorTable", tag="FI", objName="FluidInteractor"}
	Util.addObject{tableName="dataAssemblerTable", tag="DA", objName="DataAssembler"}
	Util.addObject{tableName="networkExplorerTable", tag="NE", objName="NetworkExplorer"}
	Util.addObject{tableName="dataStorageTable", tag="DS", objName="DataStorage", canInCC=true}
	Util.addObject{tableName="jumpChargerTable", tag="JC", objName="JumpCharger", canInCC=true}
	Util.addObject{tableName="networkAccessPointTable", tag="NAP", objName="NetworkAccessPoint"}
	Util.addObject{tableName="energyCubesTable", tag="EC", objName="EnergyCubeMK1"}
	Util.addObject{tableName="energyLaserTable", tag="EL", objName="EnergyLaser1"}
	Util.addObject{tableName="quatronCubesTable", tag="QC", objName="QuatronCubeMK1"}
	Util.addObject{tableName="quatronLaserTable", tag="QL", objName="QuatronLaser1"}
	Util.addObject{tableName="quatronReactorTable", tag="QR", objName="QuatronReactor"}
	Util.addObject{tableName="deepStorageTable", tag="DSR", objName="DeepStorage", canInCC=true}
	Util.addObject{tableName="deepTankTable", tag="DTK", objName="DeepTank", canInCC=true}
	Util.addObject{tableName="oreCleanerTable", tag="OC", objName="OreCleaner", noInside=true}
	Util.addObject{tableName="fluidExtractorTable", tag="FE", objName="FluidExtractor", noInside=true}
	Util.addObject{tableName="resourceCatcher", tag="RC", objName="ResourceCatcher"}
	Util.addObject{objName="InternalEnergyCube", noUpsys=true, canInCCAnywhere=true, noOutside=true}
	Util.addObject{objName="InternalQuatronCube", noUpsys=true, canInCCAnywhere=true, noOutside=true}
end

-- Add an Object to the System --
-- {tableName, tag, objName, noUpsys, noOutside, noInside, canInCC, canInCCAnywhere, noPlaced} --
function Util.addObject(table)
	-- Check the objTable --
	if global.objTable == nil then global.objTable = {} end
	-- Add the Object --
	global.objTable[table.objName] = table
	-- Create the Global Table if needed --
	if table.tableName ~= nil and global[table.tableName] == nil then global[table.tableName] = {} end
end

-- Transfer Chest1 to Chest2 --
function Util.syncChest(chest1, chest2)
	local itemsDiff = {}
	-- Get the Inventories --
	local inv1 = chest1.get_inventory(defines.inventory.chest)
	local inv2 = chest2.get_inventory(defines.inventory.chest)

	-- Itinerate the Inventory 1 --
	for i = 1, #inv1 do
		local stack = inv1[i]
		-- Count only items with no uniq data(excluding items with tags, inventory, blueprints, etc)
		if stack.valid_for_read == true and stack.item_number == nil then
			local name = stack.name
			if itemsDiff[name] ~= nil then
				itemsDiff[name] = itemsDiff[name] + stack.count / 2
			else
				itemsDiff[name] = stack.count / 2
			end
		end
	end

	-- Itinerate the Inventory 2 --
	for i = 1, #inv2 do
		local stack = inv2[i]
		-- Count only items with no uniq data(excluding items with tags, inventory, blueprints, etc)
		if stack.valid_for_read == true and stack.item_number == nil then
			local name = stack.name
			if itemsDiff[name] ~= nil then
				itemsDiff[name] = itemsDiff[name] - stack.count / 2
			else
				itemsDiff[name] = stack.count / 2 * -1
			end
		end
	end

	-- Balance the Inventories --
	local somethingMoved = 0
	for item, count in pairs(itemsDiff) do
		count = math.floor(count)
		if count < -1 then
			local inserted = inv1.insert{name=item, count=math.abs(count)}
			if inserted > 0 then
				somethingMoved = inv2.remove{name=item, count=inserted}
			end
		elseif count > 1 then
			local inserted = inv2.insert{name=item, count=count}
			if inserted > 0 then
				somethingMoved = inv1.remove{name=item, count=inserted}
			end
		end
	end

	-- Sort inventories if something was moved
	if somethingMoved > 0 then
		-- Temporaly unset bars, as items in red slots doesn't sort
		local bar1 = inv1.get_bar()
		local bar2 = inv2.get_bar()
		inv1.set_bar()
		inv2.set_bar()
		inv1.sort_and_merge()
		inv2.sort_and_merge()
		inv1.set_bar(bar1)
		inv2.set_bar(bar2)
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
function Util.syncEnergy(accu1, accu2)
	-- Calcul the total energy --
	local totalEnergy = accu1.energy + accu2.energy
	-- Set the Energy of the Accumulators --
	accu1.energy = totalEnergy / 2
	accu2.energy = totalEnergy / 2
end

-- Equilize the Quatron between two Accumulators --
function Util.syncQuatron(accu1, accu2)
	local obj1 = global.entsTable[accu1.unit_number]
	local obj2 = global.entsTable[accu2.unit_number]
	-- Calcul the total quatron --
	local effectiveCharge = obj1.quatronCharge * math.pow(obj1.quatronLevel, _mfQuatronScalePower) + obj2.quatronCharge * math.pow(obj2.quatronLevel, _mfQuatronScalePower)
	local totalCharge = obj1.quatronCharge + obj2.quatronCharge
	local effectiveLevel = math.pow(effectiveCharge / totalCharge, 1/_mfQuatronScalePower)
	-- Set the Quatron of the Accumulators --
	obj1.quatronCharge = totalCharge / 2
	obj2.quatronCharge = totalCharge / 2
	obj1.quatronLevel = effectiveLevel
	obj2.quatronLevel = effectiveLevel
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

-- Return the localised Recipe Name --
function Util.getLocRecipeName(recipeName)
	if game.recipe_prototypes[recipeName] ~= nil then
		return game.recipe_prototypes[recipeName].localised_name
	end
end

-- Reset an Animation --
function Util.resetAnimation(animId, totalFrame)
	local animSpeed = rendering.get_animation_speed(animId)
	local currentFrame = math.floor((game.tick * animSpeed) % totalFrame)
	rendering.set_animation_offset(animId, 0 - currentFrame)
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
	if type(inTable) ~= "table" or key == nil or value == nil then return end
	for _, obj in pairs(inTable) do
		if obj[key] == value then
			return obj
		end
	end
	return nil
end

-- Return the Player Force --
function getForce(playerName)
	if game.players[playerName] ~= nil then
		return game.players[playerName].force
	end
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

-- Calcule the distance in Tiles between two Positions --
function Util.distanceByTiles(position1, position2)
	local x1 = position1[1] or position1.x
	local y1 = position1[2] or position1.y
	local x2 = position2[1] or position2.x
	local y2 = position2[2] or position2.y
	return math.max(math.abs(x1-x2), math.abs(y1-y2))
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
function Util.canUse(MFPlayer, obj)
	if obj.player == MFPlayer.name then return true end
	if obj.MF then
		if obj.MF.varTable.allowedPlayers[MFPlayer.index] == true then return true end
	elseif obj.varTable then
		if obj.varTable.allowedPlayers[MFPlayer.index] == true then return true end
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

function entityToBlueprintTags(entity, fromTable)
	local tags = nil
	local obj = fromTable[entity.unit_number]

	if obj and obj.settingsToBlueprintTags then
		tags = obj:settingsToBlueprintTags()
	end

	return tags
end

function mixQuatron(obj, newCharge, newLevel)
	local effectiveCharge = obj.quatronCharge * math.pow(obj.quatronLevel, _mfQuatronScalePower) + newCharge * math.pow(newLevel, _mfQuatronScalePower)
	obj.quatronCharge = obj.quatronCharge + newCharge
	obj.quatronLevel = math.pow(effectiveCharge / obj.quatronCharge, 1/_mfQuatronScalePower)
end