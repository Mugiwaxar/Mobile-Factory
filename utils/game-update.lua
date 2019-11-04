require("utils/players-teleportation.lua")
require("utils/surface")
require("utils/saved-tables.lua")
require("utils/functions.lua")
require("utils/entities-update.lua")

-- One each game tick --
function onTick(event)
	if global.MF == nil then return end
	-- Update all Variables --
	if event.tick%_eventTick4 == 0 then updateValues() end
	-- Update all entities --
	updateEntities(event)
	-- Synchronize Tank chest with Factory Chest --
	if event.tick%_eventTick20 == 0 and global.MF ~= nil and global.MF.ent ~= nil and global.MF.ent.valid == true then
		global.MF:syncFChest()
	end
	-- Update all GUI --
	if event.tick%_eventTick55 == 0 then updateAllGUIs() end
	-- Update Modules Variable inside de Equalizer --
	if event.tick%_eventTick125 == 0 then scanModules(event) end
	-- Update the Jump Drives --
	if event.tick%_eventTick60 == 0 and global.MF.jumpTimer > 0 and global.MF.internalEnergy > _mfJumpEnergyDrain then
		global.MF.jumpTimer = global.MF.jumpTimer -1
		global.MF.internalEnergy = global.MF.internalEnergy - _mfJumpEnergyDrain
	end
	-- Update Pollution --
	if event.tick%_eventTick1200 == 0 then updatePollution() end
end

-- Update all entities --
function updateEntities(event)
	-- Verify Mobile Factory --
	if global.MF == nil then return end
	if global.MF.ent.valid == false then return end
	-- Update --
	if event.tick%_eventTick5 == 0 then factoryTeleportBox() end
	if event.tick%_eventTick60 == 0 then global.MF:updateLasers() end
	if event.tick%1 == 0 then global.MF:updateShield(event.tick) end
	if event.tick%_eventTick38 == 0 then updateAccumulators() end
	if event.tick%_eventTick63 == 0 then updatePowerDrainPole() end
	if event.tick%_eventTick64 == 0 then updateLogisticFluidPoles() end
	if event.tick%_eventTick110 == 0 then updateProvidersPad() end
	if event.tick%_eventTick115 == 0 then updateRequesterPad() end
	if event.tick%_eventTick120 == 0 then updateOreCleaner() end
	if event.tick%_eventTick59 == 0 then updateFluidExtractor() end
	updateOreSilotPad()
end

-- Update base Mobile Factory Values --
function updateValues()
	-- Energy Lasers --
	if global.IDModule == nil then global.IDModule = 0 end
	-- Accumulators table --
	if global.accTable == nil then global.accTable = {} end
	-- Power Drain Poles table --
	if global.pdpTable == nil then global.pdpTable = {} end
	-- Logistic Fluid Pole --
	if global.lfpTable == nil then global.lfpTable = {} end
	-- Tanks --
	if global.tankTable == nil then global.tankTable = {} end
	-- Ore Silot --
	if global.oreSilotTable == nil then global.oreSilotTable = {} end
	if global.oreSilotPadTable == nil then global.oreSitolPadTable = {} end
	if global.currentSilotPadChestUpdate == nil then global.currentSilotPadChestUpdate = 1 end
	-- Inventory --
	if global.inventoryTable == nil then global.inventoryTable = {} end
	if global.mfInventoryItems == nil then global.mfInventoryItems = 0 end
	if global.mfInventoryTypes == nil then global.mfInventoryTypes = 0 end
	if global.mfInventoryMaxItem == nil then global.mfInventoryMaxItem = _mfBaseMaxItems end
	if global.mfInventoryMaxTypes == nil then global.mfInventoryMaxTypes = _mfBaseMaxTypes end
	if global.providerPadTable == nil then global.providerPadTable = {} end
	if global.requesterPadTable == nil then global.requesterPadTable = {} end
	if global.inventoryPadTable == nil then global.inventoryPadTable = {} end
	-- Ore Cleaner --
	if global.oreCleanerCharge == nil then global.oreCleanerCharge = 0 end
	if global.oreCleanerPurity == nil then global.oreCleanerPurity = 0 end
	if global.oreTable == nil then global.oreTable = {} end
	-- Fluid Extractor --
	if global.fluidExtractorCharge == nil then global.fluidExtractorCharge = 0 end
	if global.fluidExtractorPurity == nil then global.fluidExtractorPurity = 0 end
end

-- When a technology is finished --
function technologyFinished(event)
	if event.research.name == "ControlCenter" then updateFactoryFloorForCC() end
	if event.research.name == "UpgradeModules" then createControlCenterEqualizer() end
	if event.research.name == "StorageTankMK1_1" then createMK1Tank1() end
	if event.research.name == "StorageTankMK1_2" then createMK1Tank2() end
	if event.research.name == "StorageTankMK1_3" then createMK1Tank3() end
	if event.research.name == "StorageTankMK1_4" then createMK1Tank4() end
	if event.research.name == "StorageTankMK1_5" then createMK1Tank5() end
	if event.research.name == "StorageTankMK2_1" then upgradeTank(1) end
	if event.research.name == "StorageTankMK2_2" then upgradeTank(2) end
	if event.research.name == "StorageTankMK2_3" then upgradeTank(3) end
	if event.research.name == "StorageTankMK2_4" then upgradeTank(4) end
	if event.research.name == "StorageTankMK2_5" then upgradeTank(5) end
	if event.research.name == "OreSilot1" then createOreSilot1() end
	if event.research.name == "OreSilot2" then createOreSilot2() end
	if event.research.name == "OreSilot3" then createOreSilot3() end
	if event.research.name == "OreSilot4" then createOreSilot4() end
	if event.research.name == "OreSilot5" then createOreSilot5() end
	if event.research.name == "ConstructibleArea1" then createConstructibleArea1() end
end

-- Update teleportation box --
function factoryTeleportBox()
	-- Mobile Factory Vehicule --
	local mfB = global.MF.ent.bounding_box
	local entities = global.MF.ent.surface.find_entities_filtered{area={{mfB.left_top.x-0.5,mfB.left_top.y-0.5},{mfB.right_bottom.x+0.5, mfB.right_bottom.y+0.5}}, type="character"}
	for k, entity in pairs(entities) do
		teleportPlayerInside(entity.player)
	end
	-- Factory to Outside --
	if global.MF.fS ~= nil then
		local entities = global.MF.fS.find_entities_filtered{area={{-1,-1},{1,1}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerOutside(entity.player)
		end
	end
	-- Factory to Control Center --
	if global.MF.fS ~= nil and global.MF.fS ~= nil then
		local entities = global.MF.fS.find_entities_filtered{area={{-3,-34},{3,-31}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerToControlCenter(entity.player)
		end
	end
	-- Control Center to Factory --
	if technologyUnlocked("ControlCenter") == true and global.MF.ccS ~= nil and global.MF.fS~= nil then
		local entities = global.MF.ccS.find_entities_filtered{area={{-3,5},{3,8}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerToFactory(entity.player)
		end
	end
end

-- Scan modules inside the Equalizer --
function scanModules(event)
	if technologyUnlocked("UpgradeModules") == false then return end
	if global.MF.ccS == nil then return end
	local equalizer = global.MF.ccS.find_entity("Equalizer", {1, -16})
	if equalizer == nil or equalizer.valid == false then return end
	local powerMD = 0
	local efficiencyMD = 0
	local focusMD = 0
	local tankMDS
	for name, count in pairs(equalizer.get_inventory(defines.inventory.beacon_modules).get_contents()) do
		if name == "EnergyPowerModule" then powerMD = powerMD + count end
		if name == "EnergyEfficiencyModule" then efficiencyMD = efficiencyMD + count end
		if name == "EnergyFocusModule" then focusMD = focusMD + count end
		if string.match(name, "ModuleID") then tankMDS = name end
	end
	if tankMDS ~= nil then
		tankMD = split(tankMDS, "D")[2]
		global.IDModule = tonumber(tankMD)
	else
		global.IDModule = 0
	end
	global.MF.laserRadiusMultiplier = powerMD
	global.MF.laserDrainMultiplier = efficiencyMD
	global.MF.laserNumberMultiplier = focusMD
end

-- If player entered or living a vehicle --
function playerDriveStatChange(event)
	-- Teleport the player out of reach from Mobile Factoty teleport box --
	local player = getPlayer(event.player_index)
	if player ~= nil and player.valid == true then
		if event.entity ~= nil and event.entity.valid == true and event.entity.name == "MobileFactory" then
			if event.entity.get_driver() == nil and global.MF ~= nil and global.MF.ent.valid == true and global.MF.ent.surface ~= nil then
				if global.MF.ent.surface.can_place_entity{name="character", position = {global.MF.ent.position.x + 5, global.MF.ent.position.y}} then
					player.teleport({global.MF.ent.position.x + 5, global.MF.ent.position.y}, global.MF.ent.surface)
				elseif global.MF.ent.surface.can_place_entity{name="character", position = {global.MF.ent.position.x -5, global.MF.ent.position.y}} then
					player.teleport({global.MF.ent.position.x - 5, global.MF.ent.position.y}, global.MF.ent.surface)
				elseif global.MF.ent.surface.can_place_entity{name="character", position = {global.MF.ent.position.x, global.MF.ent.position.y - 7}} then
					player.teleport({global.MF.ent.position.x, global.MF.ent.position.y - 7}, global.MF.ent.surface)
				else
					player.teleport({global.MF.ent.position.x, global.MF.ent.position.y + 7}, global.MF.ent.surface)
				end
			end
		end
	end
end

-- Create a Mobile Factory if any exist when a player joint the game --
function onPlayerCreated(event)
	addMobileFactory(event)
	setPlayerVariable(getPlayer(event.player_index).name, "VisitedFactory", false)
	game.forces["player"].technologies["DimensionalOre"].researched = true
end

-- When a player build something --
function onPlayerBuildSomething(event)
	-- Prevent to place multiple Mobile Factory --
	local player = getPlayer(event.player_index)
	if event.created_entity == nil or event.created_entity.valid == false or player == nil or player.valid == false then return end
	if event.created_entity.name == "MobileFactory" then
		if global.MF ~= nil then
			player.print("Unable to place more than one Mobile Factory ")
			event.created_entity.destroy()
			return
		else
			newMobileFactory(event.created_entity)
			createMFSurface()
		end
	end
	-- Prevent to place listed entities outside the Mobile Factory --
	-- Item --
	if player.surface.name ~= _mfSurfaceName then
		if canBePlacedOutside(event.created_entity.name) == false then
			player.print("You can only place the " .. event.created_entity.name .. " inside the Mobile Factory")
			event.created_entity.destroy()
			if event.stack ~= nil and event.stack.valid_for_read == true then
				player.get_main_inventory().insert(event.stack)
			end
			return
		end
	end
	-- Ghost --
	if player.surface.name ~= _mfSurfaceName and event.stack ~= nil and event.stack.valid_for_read == true and event.created_entity.name == "entity-ghost" then
		if canBePlacedOutside(event.stack.name) == false then
			player.print("You can only place this " .. event.stack.name .. " inside the Mobile Factory")
			event.created_entity.destroy()
			return
		end
	end
	-- Blueprint --
	if player.surface.name ~= _mfSurfaceName and event.stack ~= nil and event.stack.valid_for_read == true and event.stack.is_blueprint then
		if canBePlacedOutside(event.created_entity.ghost_name) == false then
			player.print("You can only place this " .. event.stack.name .. " inside the Mobile Factory")
			event.created_entity.destroy()
			return
		end
	end
	-- Allow to place things in the Control Center --
	if event.created_entity.name == "InventoryPad" and player.surface.name == _mfControlSurfaceName then
		local tile = player.surface.find_tiles_filtered{position=event.created_entity.position, radius=1, limit=1}
		if tile[1] ~= nil and tile[1].valid == true and tile[1].name == "BuildTile" then
			placedInventoryPad(event)
			return
		end
	end
	if event.created_entity.name == "InventoryPad" then
		player.print("You can only place the " .. event.created_entity.name .. " inside the Control Center Constructible area")
		event.created_entity.destroy()
		if event.stack ~= nil and event.stack.valid_for_read == true then
			player.get_main_inventory().insert(event.stack)
		end
		return
	end
	-- Prevent to place things in the Control Center --
	if player.surface.name == _mfControlSurfaceName then
		player.print("You can place that here")
		event.created_entity.destroy()
		if event.stack ~= nil and event.stack.valid_for_read == true then
			player.get_main_inventory().insert(event.stack)
		end
		return
	end
	-- Save the Factory Chest --
	if event.created_entity.name == "FactoryChest" then
		if global.MF.fChest ~= nil then
			game.print("Unable to place more than one Factory Chest")
			event.created_entity.destroy()
			if event.stack ~= nil and event.stack.valid_for_read == true then
				player.get_main_inventory().insert(event.stack)
			end
			return
		else
			global.MF.fChest = event.created_entity
		end
	end
	-- Save the Dimensional Accumulator --
	if event.created_entity.name == "DimensionalAccumulator" then
		placedDimensionalAccumulator(event)
	end
	-- Save the Power Drain Pole --
	if event.created_entity.name == "PowerDrainPole" then
		placedPowerDrainPole(event)
	end
	-- Save the Logistic Fluid Pole --
	if event.created_entity.name == "LogisticFluidPole" then
		placedLogisticPowerPole(event)
	end
	-- Save the Provider Pad --
	if event.created_entity.name == "ProviderPad" then
		placedProviderPad(event)
	end
	-- Save the Requester Pad --
	if event.created_entity.name == "RequesterPad" then
		placedRequesterPad(event)
	end
	-- Save the Ore Silot Pad --
	if string.match(event.created_entity.name, "OreSilotPad") then
		placedOreSilotPad(event)
	end
	-- Save the Ore Cleaner --
	if event.created_entity.name == "OreCleaner" then
		if global.oreCleaner ~= nil then
			game.print("Unable to place more than one Ore Cleaner")
			event.created_entity.destroy()
			if event.stack ~= nil and event.stack.valid_for_read == true then
				player.get_main_inventory().insert(event.stack)
			end
			return
		else
			global.oreCleaner = event.created_entity	
			global.oreCleanerCharge = 0
			global.oreCleanerPurity = 0
			scanOre(event.created_entity)
		end
	end
	-- Save the Fluid Extractor --
	if event.created_entity.name == "FluidExtractor" then
		if global.fluidExtractor ~= nil then
			game.print("Unable to place more than one Fluid Extractor")
			event.created_entity.destroy()
			if event.stack ~= nil and event.stack.valid_for_read == true then
				player.get_main_inventory().insert(event.stack)
			end
			return
		else
			global.fluidExtractor = event.created_entity	
			global.fluidExtractorCharge = 0
			global.fluidExtractorPurity = 0
		end
	end
end

-- When a robot build something --
function onRobotBuildSomething(event)
	if event.created_entity == nil or event.created_entity.valid == false then return end
	-- Save the Factory Chest --
	if event.created_entity.name == "FactoryChest" then
		if global.MF.fChest ~= nil then
			game.print("Unable to place more than one Factory Chest")
			event.created_entity.destroy()
			return
		else
			global.MF.fChest = event.created_entity
		end
	end
	-- Save the Dimensional Accumulator --
	if event.created_entity.name == "DimensionalAccumulator" then
		placedDimensionalAccumulator(event)
	end
	-- Save the Power Drain Pole --
	if event.created_entity.name == "PowerDrainPole" then
		placedPowerDrainPole(event)
	end
	-- Save the Logistic Fluid Pole --
	if event.created_entity == "LogisticFluidPole" then
		placedLogisticPowerPole(event)
	end
	-- Save the Provider Pad --
	if event.created_entity.name == "ProviderPad" then
		placedProviderPad(event)
	end
	-- Save the Requester Pad --
	if event.created_entity.name == "RequesterPad" then
		placedRequesterPad(event)
	end
	-- Save the Ore Silot Pad --
	if string.match(event.created_entity.name, "OreSilotPad") then
		placedOreSilotPad(event)
	end
	-- Save the Ore Cleaner --
	if event.created_entity.name == "OreCleaner" then
		if global.oreCleaner ~= nil then
			game.print("Unable to place more than one Ore Cleaner")
			event.created_entity.destroy()
			return
		else
			global.oreCleaner = event.created_entity	
			global.oreCleanerCharge = 0
			global.oreCleanerPurity = 0
			scanOre(event.created_entity)
		end
	end
	-- Save the Fluid Extractor --
	if event.created_entity.name == "FluidExtractor" then
		if global.fluidExtractor ~= nil then
			game.print("Unable to place more than one Fluid Extractor")
			event.created_entity.destroy()
			return
		else
			global.fluidExtractor = event.created_entity	
			global.fluidExtractorCharge = 0
			global.fluidExtractorPurity = 0
		end
	end
end

-- When a player remove something --
function onPlayerRemoveSomethings(event)
	if event.entity == nil or event.entity.valid == false then return end
	-- Remove the Factory Chest --
	if event.entity.name == "FactoryChest" then
		global.MF.fChest = nil
	end
	-- Remove the Dimensional Accumulator --
	if event.entity.name == "DimensionalAccumulator" then
		removedDimensionalAccumulator(event)
	end
	-- Remove the Power Drain Pole --
	if event.entity.name == "PowerDrainPole" then
		removedPowerDrainPole(event)
	end
	-- Remove the Logistic Fluid Pole --
	if event.entity.name == "LogisticFluidPole" then
		removedLogisticPowerPole(event)
	end
	-- Remove the Provider Pad --
	if event.entity.name == "ProviderPad" then
		removedProviderPad(event)
	end
	-- Remove the Requester Pad --
	if event.entity.name == "RequesterPad" then
		removedRequesterPad(event)
	end
	-- Remove the Ore Silot Pad --
	if string.match(event.entity.name, "OreSilotPad") then
		removedOreSilotPad(event)
	end
	-- Remove the Inventory Pad --
	if event.entity.name == "InventoryPad" then
		removedInventoryPad(event)
	end
	-- Remove the Ore Cleaner --
	if event.entity.name == "OreCleaner" then
		global.oreCleaner = nil	
		global.oreCleanerCharge = 0
		global.oreCleanerPurity = 0
		global.oreTable = {}
	end
	-- Remove the Fluid Extractor --
	if event.entity.name == "FluidExtractor" then
		global.fluidExtractor = nil	
		global.fluidExtractorCharge = 0
		global.fluidExtractorPurity = 0
	end
end

-- When a robot remove something --
function onRobotRemoveSomething(event)
	if event.entity == nil or event.entity.valid == false then return end
	-- Remove the Factory Chest --
	if event.entity.name == "FactoryChest" then
		global.MF.fChest = nil
	end
	-- Remove the Dimensional Accumulator --
	if event.entity.name == "DimensionalAccumulator" then
		removedDimensionalAccumulator(event)
	end
	-- Remove the Power Drain Pole --
	if event.entity.name == "PowerDrainPole" then
		removedPowerDrainPole(event)
	end
	-- Remove the Logistic Fluid Pole --
	if event.entity.name == "LogisticFluidPole" then
		removedLogisticPowerPole(event)
	end
	-- Remove the Provider Pad --
	if event.entity.name == "ProviderPad" then
		removedProviderPad(event)
	end
	-- Remove the Requester Pad --
	if event.entity.name == "RequesterPad" then
		removedRequesterPad(event)
	end
	-- Remove the Ore Silot Pad --
	if string.match(event.entity.name, "OreSilotPad") then
		removedOreSilotPad(event)
	end
	-- Remove the Inventory Pad --
	if event.entity.name == "InventoryPad" then
		removedInventoryPad(event)
	end
	-- Remove the Ore Cleaner --
	if event.entity.name == "OreCleaner" then
		global.oreCleaner = nil
		global.oreCleanerCharge = 0
		global.oreCleanerPurity = 0
		global.oreTable = {}
	end
	-- Remove the Fluid Extractor --
	if event.entity.name == "FluidExtractor" then
		global.fluidExtractor = nil	
		global.fluidExtractorCharge = 0
		global.fluidExtractorPurity = 0
	end
end

-- Watch damages --
function onEntityDamaged(event)
	-- Test if this is the Mobile Factory --
	if event.entity.name == "MobileFactory" then
		-- Drain Shield --
		if global.MF.shield > 0 and global.MF.ent ~= nil and global.MF.ent.valid == true then
			local drain = math.min(global.MF.shield, event.final_damage_amount)
			global.MF.shield = global.MF.shield - drain
			global.MF.ent.health = global.MF.ent.health + drain
		end
		-- Heal Low message --
		if event.entity.health < 1000 then
			game.print("Mobile Factory heal low")
		end
	end
	-- Test if this is the Factory Chest --
	if event.entity.name == "FactoryChest" then
		event.entity.health = event.entity.prototype.max_health
	end
	-- Test if this is in Control Center --
	if event.entity.surface.name == _mfControlSurfaceName then
		event.entity.health = event.entity.prototype.max_health
	end

end

--[[
-- When player use a Capsule --
function onPlayerUseCapsule(event)
	-- Tile Capsule --
	if event.item.name == "TileCapsule1" or event.item.name == "TileCapsule2" or event.item.name == "TileCapsule3" then
			local player = getPlayer(event.player_index)
	if player.surface.name ~= _mfSurfaceName then
		player.print("Tile capsule can only be used inside the Mobile Factory room")
		return
	end
	if event.item.name == "TileCapsule1" then
		createTilesAtPosition(event.position, 1, player.surface)
	elseif event.item.name == "TileCapsule2" then
		createTilesAtPosition(event.position, 3, player.surface)
	elseif event.item.name == "TileCapsule3" then
		createTilesAtPosition(event.position, 5, player.surface)
	end
	end
end
--]]

-- Upgrade a Tank to MK2 --
function upgradeTank(id)
	if global.MF.ccS == nil or global.tankTable == nil  then return end
	-- Get the tank ID --
	local tankId = global.tankTable[id]
	if tankId == nil then return end
	-- Get The Tank --
	local tank = global.MF.ccS.find_entity(tankId.name, tankId.position)
	-- Test if there are fluid inside --
	if tank.get_fluid_count() > 0 then 
		local fluid = tank.get_fluid_contents()
		local name
		local amount
		-- Get the fluid --
		for n, a in pairs(fluid) do
			name = n
			amount = a
		end
		if name == nil or amount == nil then game.print("upgradeTank() error for id: " .. id) return end
		-- Create the new tank --
		local newTank = global.MF.ccS.create_entity{name="StorageTank".. id .."MK2", position=tankId.position, force="player"}
		-- Fill the fluid --
		newTank.insert_fluid({name=name, amount=amount})
		-- Save the tank --
		global.tankTable[id].name = newTank.name
	else
		-- Create the new tank --
		local newTank = global.MF.ccS.create_entity{name="StorageTank".. id .."MK2", position=tankId.position, force="player"}
		-- Save the tank --
		global.tankTable[id].name = newTank.name
	end
	-- Destroy the old Tank --
	tank.destroy()
end

-- Send all Pollution outside --
function updatePollution()
	-- Test if Mobile Factory Surfaces exist --
	if global.MF == nil or global.MF.fS == nil or global.MF.ent.surface == nil then return end
	-- Get the total amount of Pollution --
	local totalPollution = global.MF.fS.get_total_pollution()
	if totalPollution ~= nil then
		-- Create Pollution outside the Factory --
		global.MF.ent.surface.pollute(global.MF.ent.position, totalPollution)
		-- Clear the Factory Pollution --
		global.MF.fS.clear_pollution()
	end
end







