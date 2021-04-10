-- Create all Objects Table --
function createTableList()
	global.objTable = {}
	addObject{tableName="playersTable", tag="MFP", objName="MFPlayer", noPlaced=true, noUpsys=true}
	addObject{tableName="MFTable", tag="MF", objName="MF", noPlaced=true}
	addObject{tableName="matterInteractorTable", tag="MI", objName="MatterInteractor"}
	addObject{tableName="fluidInteractorTable", tag="FI", objName="FluidInteractor"}
	addObject{tableName="dataAssemblerTable", tag="DA", objName="DataAssembler"}
	addObject{tableName="networkExplorerTable", tag="NE", objName="NetworkExplorer"}
	addObject{tableName="dataStorageTable", tag="DS", objName="DataStorage", canInCC=true}
	addObject{tableName="jumpChargerTable", tag="JC", objName="JumpCharger", canInCC=true}
	addObject{tableName="networkAccessPointTable", tag="NAP", objName="NetworkAccessPoint"}
	addObject{tableName="energyCubesTable", tag="EC", objName="EnergyCubeMK1"}
	addObject{tableName="energyCubesTable", tag="EC", objName="EnergyCubeMK2"}
	addObject{tableName="energyCubesTable", tag="EC", objName="EnergyCubeMK3"}
	addObject{tableName="energyLaserTable", tag="EL", objName="EnergyLaser1"}
	addObject{tableName="energyLaserTable", tag="EL", objName="EnergyLaser2"}
	addObject{tableName="energyLaserTable", tag="EL", objName="EnergyLaser3"}
	addObject{tableName="quatronCubesTable", tag="QC", objName="QuatronCubeMK1"}
	addObject{tableName="quatronCubesTable", tag="QC", objName="QuatronCubeMK2"}
	addObject{tableName="quatronCubesTable", tag="QC", objName="QuatronCubeMK3"}
	addObject{tableName="quatronLaserTable", tag="QL", objName="QuatronLaser1"}
	addObject{tableName="quatronLaserTable", tag="QL", objName="QuatronLaser2"}
	addObject{tableName="quatronLaserTable", tag="QL", objName="QuatronLaser3"}
	addObject{tableName="quatronReactorTable", tag="QR", objName="QuatronReactor"}
	addObject{tableName="deepStorageTable", tag="DSR", objName="DeepStorage", canInCC=true}
	addObject{tableName="deepTankTable", tag="DTK", objName="DeepTank", canInCC=true}
	addObject{tableName="oreCleanerTable", tag="OC", objName="OreCleaner"}
	addObject{tableName="fluidExtractorTable", tag="FE", objName="FluidExtractor", noInside=true}
	addObject{tableName="resourceCatcher", tag="RC", objName="ResourceCatcher"}
	addObject{objName="InternalEnergyCube", noUpsys=true, canInCCAnywhere=true, noOutside=true}
	addObject{objName="InternalQuatronCube", noUpsys=true, canInCCAnywhere=true, noOutside=true}
	addObject{tableName= "energyDispenserTable", tag="ED", objName="EnergyDispenser"}
end

-- Add an Object to the System --
-- {tableName, tag, objName, noUpsys, noOutside, noInside, canInCC, canInCCAnywhere, noPlaced} --
function addObject(table)
	-- Check the objTable --
	if global.objTable == nil then global.objTable = {} end
	-- Add the Object --
	global.objTable[table.objName] = table
	-- Create the Global Table if needed --
	if table.tableName ~= nil and global[table.tableName] == nil then global[table.tableName] = {} end
end

-- Transfer Chest1 to Chest2 --
function syncChest(chest1, chest2)
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
function syncTank(tank1, tank2)
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
function syncEnergy(accu1, accu2)
	-- Calcul the total energy --
	local totalEnergy = accu1.energy + accu2.energy
	-- Set the Energy of the Accumulators --
	accu1.energy = math.ceil(totalEnergy / 2)
	accu2.energy = math.floor(totalEnergy / 2)
end

-- Equilize the Quatron between two Accumulators --
function syncQuatron(accu1, accu2)
	local obj1 = global.entsTable[accu1.unit_number]
	local obj2 = global.entsTable[accu2.unit_number]
	-- Calcul the total quatron --
	local totalCharge = EI.energy(obj1) + EI.energy(obj2)
	if totalCharge <= 0 then return end

	local effectiveCharge = EI.energy(obj1) * math.pow(EI.energy(obj1), _mfQuatronScalePower) + EI.energy(obj2) * math.pow(EI.energy(obj2), _mfQuatronScalePower)
	local effectiveLevel = math.pow(effectiveCharge / totalCharge, 1/_mfQuatronScalePower)
	-- Set the Quatron of the Accumulators --
	accu1.energy = math.ceil(totalCharge / 2)
	accu2.energy = math.floor(totalCharge / 2)
	obj1.energyLevel = effectiveLevel
	obj2.energyLevel = effectiveLevel
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

-- Return the Player Mobile Factory --
function getMF(player)
	if player == nil then return nil
	elseif type(player) == "number" then return global.MFTable[game.players[player].name]
	elseif type(player) == "string" then return global.MFTable[player]
	else error("bad argument to getMF()") end
end

-- Return the Current Selected Mobile Factory --
function getCurrentMF(player)
	if player == nil then return nil
	elseif type(player) == "number" then return global.playersTable[game.players[player].name].currentMF or global.playersTable[game.players[player].name].MF
	elseif type(player) == "string" then return global.playersTable[player].currentMF or global.playersTable[player].MF
	elseif type(player) == "table" then return player.currentMF or player.MF end
end

-- Return the MFPlayer Object --
function getMFPlayer(player)
	if player == nil then return nil
	elseif type(player) == "number" then return global.playersTable[game.players[player].name]
	elseif type(player) == "string" then return global.playersTable[player]
	else error("bad argument to getMFPlayer()") end
end

-- Return an MF Floor Name, and the MFPlayer Name as a Second Return, If on an MF Surface --
function getMFFloor(surfaceName)
	if surfaceName == nil then return nil, nil end
	local MFSurfaces = {
		_mfSurfaceName = "mfSurface",
		_mfControlSurfaceName = "ControlRoom",
	}

	for _, v in pairs(MFSurfaces) do
		local MFFloor, playerName = string.match(surfaceName, "^("..v..")(.*)$")
		if MFFloor then return MFFloor, playerName end
	end
	return nil, nil
end

function findNearestMF(surface, position)
	if type(surface) == "string" or type(surface) == "number" then surfaceName = game.surfaces[surface] end
	if type(surface) ~= "table" or surface.object_name ~= "LuaSurface" then error("invalid argument - surface") end
	if type(position) ~= "table" then error("invalid argument - position") end
	local pX = position.x or position[1]
	local pY = position.y or position[2]
	if pX == nil or pY == nil then
		error("nearestMF() - invalid position table")
	end
	local nearestMFObj = nil
	local d2 = math.huge
	for _, MF in pairs(global.MFTable) do
		local MFEnt = MF.ent
		if MFEnt and MFEnt.valid and MFEnt.surface == surface then
			local MFPos = MFEnt.position
			local MFX = MFPos.x
			local MFY = MFPos.y
			local dist2 = (pX - MFX)^2 + (pY - MFY)^2
			if dist2 < d2 then
				d2 = dist2
				nearestMFObj = MF
			end
		end
	end
	return nearestMFObj
end

function valueToObj(inTable, key, value)
	if type(inTable) ~= "table" or key == nil or value == nil then return end
	for _, obj in pairs(inTable) do
		if obj[key] == value then
			return obj
		end
	end
	return nil
end

-- Return the Player Force --
function getForce(player)
	-- In case player is a Mobile Factory Object --
	if type(player) == "table" then
		local MF = player
		player = MF.playerIndex
	end
	if game.players[player] ~= nil then
		return game.players[player].force
	end
end

-- Return the Mobile Factory from a LuaSurface --
function getMFBySurface(surface)
	for _, MF in pairs(global.MFTable) do
		if MF.fS == surface or MF.ccS == surface then
			return MF
		end
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
function fixMB(event, MF)
	-- Get the Mobile Factory --
	local player = getPlayer(event.player_index)
	if player == nil then return end
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



-- Add a Mobile Factory to a player inventory --
function addMobileFactory(player)
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

-- Get Object ID --
function getEntID(array)
	local tmpArray = {}
	local id = 0
	local highId = 0
	for _, obj in pairs(array) do
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

-- Return true if the Player is not inside a Mobile Factory --
function isOutside(player)
	if player == nil then return true end
	if string.match(player.surface.name, _mfSurfaceName) then return false end
	if string.match(player.surface.name, _mfControlSurfaceName) then return false end
	return true
end

-- Check if the Player can interact with the Structure --
function canUse(MFPlayer, obj)
	if obj.player == MFPlayer.name then return true end
	if obj.MF then
		if obj.MF.varTable.allowedPlayers[MFPlayer.index] == true then return true end
	elseif obj.varTable then
		if obj.varTable.allowedPlayers[MFPlayer.index] == true then return true end
	end
	return false
end

-- Check if we have necessary Tiles --
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

-- Create the Ores Products list for the Ore Cleaner --
function createProductsList()
	-- Create the Ore Products Table --
	global.oresProductsTable = {}
	for _, prototype in pairs(game.entity_prototypes) do
		if prototype.type == "resource" and prototype.mineable_properties ~= nil and prototype.mineable_properties.products ~= nil then
			local productsTable = {}
			for _, product in pairs(prototype.mineable_properties.products) do
				table.insert(productsTable, {name=product.name, type=product.type, amount=product.amount, min=product.amount_min, max=product.amount_max, probability=product.probability})
			end
			global.oresProductsTable[prototype.name] = productsTable
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

function slotToPos(slotNumber, x, y)
	if slotNumber == 1 then return {x-2,y-4} end
	if slotNumber == 2 then return {x-1,y-4} end
	if slotNumber == 3 then return {x,y-4} end
	if slotNumber == 4 then return {x+1,y-4} end
	if slotNumber == 5 then return {x-3,y-3} end
	if slotNumber == 6 then return {x-3,y-2} end
	if slotNumber == 7 then return {x-3,y-1} end
	if slotNumber == 8 then return {x-3,y} end
	if slotNumber == 9 then return {x-3,y+1} end
	if slotNumber == 10 then return {x-3,y+2} end
	if slotNumber == 11 then return {x+2,y-3} end
	if slotNumber == 12 then return {x+2,y-2} end
	if slotNumber == 13 then return {x+2,y-1} end
	if slotNumber == 14 then return {x+2,y} end
	if slotNumber == 15 then return {x+2,y+1} end
	if slotNumber == 16 then return {x+2,y+2} end
	if slotNumber == 17 then return {x-2,y+3} end
	if slotNumber == 18 then return {x-1,y+3} end
	if slotNumber == 19 then return {x,y+3} end
	if slotNumber == 20 then return {x+1,y+3} end
end

function slotToDirection(slotNumber, entity)
	local direction = nil
	if slotNumber == 1 then direction = defines.direction.north end
	if slotNumber == 2 then direction = defines.direction.north end
	if slotNumber == 3 then direction = defines.direction.north end
	if slotNumber == 4 then direction = defines.direction.north end
	if slotNumber == 5 then direction = defines.direction.west end
	if slotNumber == 6 then direction = defines.direction.west end
	if slotNumber == 7 then direction = defines.direction.west end
	if slotNumber == 8 then direction = defines.direction.west end
	if slotNumber == 9 then direction = defines.direction.west end
	if slotNumber == 10 then direction = defines.direction.west end
	if slotNumber == 11 then direction = defines.direction.east end
	if slotNumber == 12 then direction = defines.direction.east end
	if slotNumber == 13 then direction = defines.direction.east end
	if slotNumber == 14 then direction = defines.direction.east end
	if slotNumber == 15 then direction = defines.direction.east end
	if slotNumber == 16 then direction = defines.direction.east end
	if slotNumber == 17 then direction = defines.direction.south end
	if slotNumber == 18 then direction = defines.direction.south end
	if slotNumber == 19 then direction = defines.direction.south end
	if slotNumber == 20 then direction = defines.direction.south end

	if string.match(entity, "Belt") then
		if direction == defines.direction.north then direction = defines.direction.south
		elseif direction == defines.direction.west then direction = defines.direction.east
		elseif direction == defines.direction.east then direction = defines.direction.west
		elseif direction == defines.direction.south then direction = defines.direction.north end
	end

	return direction
end