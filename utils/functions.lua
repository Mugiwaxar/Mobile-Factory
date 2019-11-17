-- Put all items in inventory1 to inventory2 --
function synchronizeInventory(inventory1, inventory2, filter)
	-- Get the content of the Inventory 1 --
	local allItems = inventory1.get_contents()
	-- Itinerate all items --
	for item, amount in pairs(allItems) do
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

-- Advenced print --
function dprint(v)
	game.print(serpent.block(v))
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

-- Test if Mobile Factory can be placed near a player --
function mfPlaceable(player)
	-- Make the Mobile Factory unable to be placed inside it --
	if player.surface.name == _mfSurfaceName or player.surface.name == _mfControlSurfaceName then
		player.print("Mobile factory can't be placed in the Mobile Factory!")
		return nil
	end
	-- Make the Mobile Factory unable to be placed inside a Factorissimo Structure --
	if string.match(player.surface.name, "Factory") then
		player.print("Mobile Factory can't be placed inside Factorissimo structures")
		return nil
	end
	-- Try to a position near the Player --
	if player.surface.can_place_entity{name="MobileFactory", position={player.position.x+5, player.position.y}} == false then
		if player.surface.can_place_entity{name="MobileFactory", position={player.position.x-5, player.position.y}} == false then
			if player.surface.can_place_entity{name="MobileFactory", position={player.position.x, player.position.y+5}} == false then
				if player.surface.can_place_entity{name="MobileFactory", position={player.position.x, player.position.y-5}} == false then
					player.print("Unable to place Mobile Factory: No enought space")
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


-- Try to find a lost Mobile Factory --
function findMF()
	-- Number of Tank found --
	local mfFound = 0
	-- Last Tank found --
	local lastMFFound = nil
	-- Look for the Tank in all the surface --
	for k, surface in pairs(game.surfaces) do
		for k, entity in pairs(surface.find_entities_filtered{name="MobileFactory"}) do
			mfFound = mfFound + 1
			lastMFFound = entity
		end
	end
	-- Print the number of Tank found --
	game.print("Found " .. mfFound .. " Mobile Factory")
	-- Return the last Tank found --
	return lastMFFound
end

------------------------------------- TO DELETE ? The FC can now be removed --------------------------------
-- Try to find a lost Mobile Factory Chest --
-- function findFMChest(surfaceName)
	-- local chestFound = 0
	-- local lastChestFound = nil
	-- local surface = game.get_surface(surfaceName)
	-- if surface == nil then
		-- return nil
	-- end
	-- for k, entity in pairs(surface.find_entities_filtered{name="FactoryChest"}) do
		-- chestFound = chestFound + 1
		-- lastChestFound = entity
	-- end
	-- game.print("Found " .. chestFound .. " Factory Chest")
	-- return lastChestFound
-- end
-------------------------------------------------------------------------------------------------------------

-- Define the Main Mobile Factory global variable--
function newMobileFactory(mf)
	-- Test if the Mobile Factory doesn't already exist --
	if global.MF ~= nil and global.MF.ent ~= nil then global.MF.ent.destroy() end
	-- Set the new one --
	global.MF = MF:new(mf)
	if global.MF.fS == nil then createMFSurface() end
end

-- Add a Mobile Factory to a player inventory --
function addMobileFactory(event)
	-- Get the Player Object --
	local player = getPlayer(event.player_index)
	-- Get the Player Inventory --
	local inv = player.get_main_inventory()
	-- Add a Mobile Factory to the player inventaire --
	if inv.can_insert({name="MobileFactory"}) then
		-- Can insert --
		inv.insert({name="MobileFactory", count=1})
		player.print("Inserted Mobile Factory in player inventory")
	else
		-- Can't insert --
		player.print("Can not insert Mobile Factory to the player inventory")
	end
end
	
-- If Mobile Factory or his surfaces are broken, try to fix them --
function fixMB(event)
	-- If Mobile Factory is lost --
	if global.MF == nil or global.MF.ent.valid == false then
		-- Try to find it --
		tempMf = findMF()
		if tempMf ~= nil and tempMf.valid == true then
			-- Found it, attach it to the MF object --
			game.print("Mobile Factory found!")
			newMobileFactory(tempMf)
		else
			-- Unable to find, send a new one to the Player Inventory --
			game.print("Unable to find the Mobile Factory, new one is placed in your inventory")
			addMobileFactory(event)
		end
	end
	-- If Factory Surface is lost --
	if global.MF.fS == nil or global.MF.fS.valid == false then
		-- Try to find it --
		tempSurface = game.get_surface(_mfSurfaceName)
		if tempSurface ~= nil and tempSurface.valid == true then
			-- Surface found, attach it to the MF object --
			game.print("Factory surface found")
			global.MF.fS = tempSurface
		else
			-- Unable to find, create a new one --
			game.print("Unable to find the Factory surface, creating a new one")
			createMFSurface()
		end
	end
	-- If Control Center Surface is lost --
	if global.MF.ccS == nil or global.MF.ccS.valid == false then
		-- Test if the Technology is unlocked --
		if technologyUnlocked("ControlCenter") == true then
			-- Try to find it --
			tempSurface = game.get_surface(_mfControlSurfaceName)
			if tempSurface ~= nil and tempSurface.valid == true then
				-- Surface found, attach it to the MF object --
				game.print("Factory control center")
				global.MF.ccS = tempSurface
			else
				-- Unable to find it, create a new one --
				game.print("Unable to find the Control Center surface, creating a new one")
				createControlRoom()
			end
		end
	end
end
		
-- Call the mobile Factory near the player
function callMobileFactory(player)
	-- Test if the Jump Drives are ready --
	if global.MF.jumpTimer > 0 then
		player.print("Unable to call Mobile Factory, jump drive is recharging")
		return
	end
	-- Try to find the best coords --
	local coords = mfPlaceable(player)
	-- Return if any coords was found --
	if coords == nil then return end
	-- Create a new Mobile Factory if it's not existing --
	if global.MF == nil or global.MF.ent.valid == false then
		player.print("Factory was lost or destroyed, creating a new one")
		global.MF = player.surface.create_entity{name="MobileFactory", position = coords, force="player"}
	----------------------------- To remove? Vehicle can now be teleported between surface -------------------------------------
	-- elseif player.surface.name ~= global.MF.ent.surface.name then
		-- player.print("Factory are in another surface, creating a new one")
		-- newMobileFactory(player.surface.create_entity{name="MobileFactory", position = coords, force="player"})
	-----------------------------------------------------------------------------------------------------------------------------
	else
		-- Teleport the Mobile Factory to the cords --
		global.MF.ent.teleport(coords, player.surface)
		-- Try to find the Mobile Factory if it is lost --
		if global.MF.ent == nil or global.MF.ent.valid == false then
			global.MF.ent = player.surface.find_entity("MobileFactory", coords)
		end
		-- Save the position --
		global.MF.lastSurface = global.MF.ent.surface
		global.MF.lastPosX = global.MF.ent.position.x
		global.MF.lastPosY = global.MF.ent.position.y
	end
	-- Discharge the Jump Drives --
	global.MF.jumpTimer = global.MF.baseJumpTimer
end

-- Create Tiles at the given position and radius --
function createTilesAtPosition(position, radius, surface)
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
				if tile.name ~= "out-of-map" then
					replace = false
				end
			end
			if replace == true then
				table.insert(tilesTable, {name="tutorial-grid", position={posX, posY}})
			end
		end
	end
	-- Set tiles --
	if table_size(tilesTable) > 0 then surface.set_tiles(tilesTable) end
end

-- Add itemStack to the Internal Inventory --
function addItemStackToII(itemStack)
	if global.providerPadTable == nil then return end
	if itemStack == nil or itemStack.name == nil or itemStack.count == nil then return 0 end
	-- Try to store Inside Inventory Pad --
	if global.inventoryPadTable ~= nil then
		for k, chest in pairs(global.inventoryPadTable) do
			-- Get the Filter --
			local filter = chest.get_request_slot(1)
			-- Test if the Filter Match the Item --
			if filter ~= nil and filter.name == itemStack.name then
				-- Get the Chest Inventory --
				local inv = chest.get_inventory(defines.inventory.chest)
				-- Insert the Stack --
				if inv ~= nil and inv.valid == true then
					local amount = inv.insert({name=itemStack.name, count=itemStack.count})
					-- Test if the amount is > 0 --
					if amount > 0 then
						-- Drain energy
						global.MF.internalEnergy = global.MF.internalEnergy - amount * _mfItemsDrain
						-- Return the amount --
						return amount
					end
				end
			end
		end
	end
	-- Get the number of Type in the Internal Inventory --
	global.mfInventoryTypes = table_size(global.inventoryTable)
	-- Calcule the remaining Type place --
	local mfInvTypeRPlace = global.mfInventoryMaxTypes - global.mfInventoryTypes
	-- Get the number of Items in the Internal Inventory --
	global.mfInventoryItems = 0
	for k, items in pairs(global.inventoryTable) do
		global.mfInventoryItems = global.mfInventoryItems + items.amount
	end
	-- Calcule the remaining Item place --
	local mfInvItemsRPlace = global.mfInventoryMaxItem - global.mfInventoryItems
	-- Return 0 if there are no remaining place --
	if mfInvItemsRPlace <= 0 then return 0 end
	-- Verify if an ItemStack with the same name exist --
	for k, items in pairs(global.inventoryTable) do
		-- If item find --
		if items.name == itemStack.name then
			-- Calcule the amount possible --
			local amount = math.min(mfInvItemsRPlace, itemStack.count)
			-- Add items --
			items.amount = items.amount + amount
			-- Set the variable --
			global.mfInventoryItems = global.mfInventoryItems + amount
			-- Drain energy
			global.MF.internalEnergy = global.MF.internalEnergy - amount * _mfItemsDrain
			-- Return the amount Placed
			return amount
		end
	end
	-- Return if there are no place for a new Type --
	if mfInvTypeRPlace <= 0 then return 0 end
	-- Calcule the amount possible --
	local amount = math.min(mfInvItemsRPlace, itemStack.count)
	-- Add items --
	table.insert(global.inventoryTable, {name=itemStack.name, amount=amount})
	-- Update the variables --
	global.mfInventoryItems = global.mfInventoryItems + amount
	global.mfInventoryTypes = global.mfInventoryTypes + 1
	-- Return the amount placed
	return amount
end

-- Remove items from the Internal Storage to inventory --
function removeItemsFromII(itemName, inv)
	if itemName == nil or inv == nil or inv.valid == false then return end
	-- Get the max stack size --
	local maxStackSize = game.item_prototypes[itemName].stack_size
	-- Try to remove ItemStack from Inventory Pad --
	if global.inventoryPadTable ~= nil then
		for k, chest in pairs(global.inventoryPadTable) do
			-- Get the Chest Inventory --
			local chestInv = chest.get_inventory(defines.inventory.chest)
			-- Test if the Inventory is not empty --
			if chestInv.is_empty() == false then
				-- Remove the stack --
				if chestInv ~= nil and chestInv.valid == true then
					local amount = chestInv.remove({name=itemName, count=maxStackSize})
					-- Test if something get removed --
					if amount > 0 then
						-- Insert Stack to the Inventory --
						local insertedAmount = inv.insert({name=itemName, count=amount})
						-- Test if they are Items left --
						if insertedAmount < amount then
							-- Resend back to the first Inventory --
							chestInv.insert({name=itemName, count=amount-insertedAmount})
						end
						-- Drain energy
						global.MF.internalEnergy = global.MF.internalEnergy - insertedAmount * _mfItemsDrain
						-- Return --
						return
					end
				end
			end
		end
	end
	-- Look if the item exist in the Internal Inventory --
	for k, item in pairs(global.inventoryTable) do
		-- Test the name --
		if item.name == itemName then
			-- Get the amount that can be returned --
			local amount = math.min(item.amount, maxStackSize)
			-- Try to place the stack in the Chest Inventory --
			local insertedAmount = inv.insert({name=item.name, count=amount})
			-- Remove from Internal Inventory --
			item.amount = item.amount - insertedAmount
			-- Remove the item from the internal Inventory if empty --
			if item.amount <= 0 then
				global.inventoryTable[k] = nil
				-- Update the variable --
				global.mfInventoryTypes = global.mfInventoryTypes - 1
			end
			-- Update the variable --
			global.mfInventoryItems = global.mfInventoryItems - insertedAmount
			-- Drain energy
			global.MF.internalEnergy = global.MF.internalEnergy - insertedAmount * _mfItemsDrain
		end
	end
end

-- Test if item Exist in the Internal Inventory and return the amount --
function countItemFromII(itemName)
	if itemName == nil or global.inventoryTable == nil then return 0 end
	-- Itinerate the Table --
	for k, item in pairs(global.inventoryTable) do
		-- Test if Item names matches --
		if item.name == itemName then
			-- Return the amount --
			return item.amount
		end
	end
	return 0
end

-- Direct Remove Item from Internal Inventory --
function directRemoveItemFromII(itemName, amount)
	if itemName == nil or global.inventoryTable == nil then return end
	-- Itinerate the Table --
	for k, item in pairs(global.inventoryTable) do
		-- Test if Item exist --
		if item.name == itemName then
			item.amount = item.amount - amount
			-- Remove the item from the internal Inventory if empty --
			if item.amount <= 0 then
				global.inventoryTable[k] = nil
				-- Update the variable --
				global.mfInventoryTypes = global.mfInventoryTypes - 1
			end
			-- Update the variable --
			global.mfInventoryItems = global.mfInventoryItems - amount
			-- Drain energy
			global.MF.internalEnergy = global.MF.internalEnergy - amount * _mfBaseItemEnergyConsumption
		end
	end
end