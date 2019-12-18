require("utils/players-teleportation.lua")
require("utils/surface")
require("utils/saved-tables.lua")
require("utils/functions.lua")
require("scripts/update-system.lua")
require("utils/place-and-remove.lua")

-- One each game tick --
function onTick(event)
	if global.MF == nil then return end
	-- Synchronize Tank chest with Factory Chest --
	if event.tick%_eventTick20 == 0 and global.MF ~= nil and global.MF.ent ~= nil and global.MF.ent.valid == true then
		global.MF:syncFChest()
	end
	-- Update all entities --
	updateEntities(event)
	-- Update all GUI --
	if event.tick%_eventTick55 == 0 then GUI.updateAllGUIs() end
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
	-- Update System --
	UpSys.update(event)
	-- Update --
	if event.tick%_eventTick5 == 0 then factoryTeleportBox() end
	if event.tick%_eventTick38 == 0 then updateAccumulators() end
	if event.tick%_eventTick64 == 0 then updateLogisticFluidPoles() end
	-- if event.tick%_eventTick110 == 0 then updateProvidersPad() end
	-- if event.tick%_eventTick115 == 0 then updateRequesterPad() end
	if event.tick%_eventTick59 == 0 then updateFluidExtractor() end
	updatePowerDrainPole(event)
	updateOreSilotPad()
end

-- Update base Mobile Factory Values --
function updateValues()
	if global.MF == nil then global.MF = MF:new() end
	if global.entsTable == nil then global.entsTable = {} end
	if global.entsUpPerTick == nil then global.entsUpPerTick = _mfBaseUpdatePerTick end
	if global.upSysIndex == nil then global.upSysIndex = 1 end
	if global.upSysLastScan == nil then global.upSysLastScan = 0 end
	if global.IDModule == nil then global.IDModule = 0 end
	if global.accTable == nil then global.accTable = {} end
	if global.pdpTable == nil then global.pdpTable = {} end
	if global.lfpTable == nil then global.lfpTable = {} end
	if global.tankTable == nil then global.tankTable = {} end
	if global.oreSilotTable == nil then global.oreSilotTable = {} end
	if global.oreSilotPadTable == nil then global.oreSitolPadTable = {} end
	if global.currentSilotPadChestUpdate == nil then global.currentSilotPadChestUpdate = 1 end
	if global.fluidExtractorCharge == nil then global.fluidExtractorCharge = 0 end
	if global.fluidExtractorPurity == nil then global.fluidExtractorPurity = 0 end
	if global.matterSerializerTable == nil then global.matterSerializerTable = {} end
	if global.matterPrinterTable == nil then global.matterPrinterTable = {} end
	if global.dataCenterTable == nil then global.dataCenterTable = {} end
	if global.dataStorageTable == nil then global.dataStorageTable = {} end
	if global.energyCubesTable == nil then global.energyCubesTable = {} end
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

function selectedEntityChanged(event)
	-- Get the Player --
	local player = getPlayer(event.player_index)
	-- Check the Player and the Entity --
	if player == nil or player.selected == nil or player.selected.valid == false then return end
	-- Check if the Tooltip GUI exist --
	if player.gui.screen.mfTooltipGUI == nil or player.gui.screen.mfTooltipGUI.valid == false then return end
	-- Check if the Tooltip GUI is not locked --
	if player.gui.screen.mfTooltipGUI.mfTTGUIMenuBar.TTLockButton.sprite == "LockIconReed" then return end
	-- Save the Entity ID --
	setPlayerVariable(player.name, "lastEntitySelected", player.selected.unit_number)
	-- Update the Tooltip GUI --
	GUI.updateTooltip(player, player.selected.unit_number)
end

-- Update teleportation box --
function factoryTeleportBox()
	-- Check the Mobile Factory --
	if global.MF.ent == nil then return end
	if global.MF.ent.valid == false then return end
	-- Mobile Factory Vehicule --
	if global.MF.tpEnabled == true then
		local mfB = global.MF.ent.bounding_box
		local entities = global.MF.ent.surface.find_entities_filtered{area={{mfB.left_top.x-0.5,mfB.left_top.y-0.5},{mfB.right_bottom.x+0.5, mfB.right_bottom.y+0.5}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerInside(entity.player)
		end
	end
	-- Factory to Outside --
	if global.MF.fS ~= nil then
		local entities = global.MF.fS.find_entities_filtered{area={{-1,-1},{1,1}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerOutside(entity.player)
		end
	end
	-- Factory to Control Center --
	if technologyUnlocked("ControlCenter") == true and global.MF.fS ~= nil and global.MF.fS ~= nil then
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
		if event.entity ~= nil and event.entity.valid == true and string.match(event.entity.name, "MobileFactory") then
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
	somethingWasPlaced(event, false)
end

-- When a robot build something --
function onRobotBuildSomething(event)
	somethingWasPlaced(event, true)
end

-- When a player remove something --
function onPlayerRemoveSomethings(event)
	somethingWasRemoved(event)
end

-- When a robot remove something --
function onRobotRemoveSomething(event)
	somethingWasRemoved(event)
end

-- When an Entity is destroyed --
function onEntityIsDestroyed(event)
	somethingWasRemoved(event)
end

-- Watch damages --
function onEntityDamaged(event)
	-- Test if this is the Mobile Factory --
	if event.entity.name == "MobileFactory" then
		-- Drain Shield --
		-- if global.MF.shield > 0 and global.MF.ent ~= nil and global.MF.ent.valid == true then
			-- local drain = math.min(global.MF.shield, event.final_damage_amount)
			-- global.MF.shield = global.MF.shield - drain
			-- global.MF.ent.health = global.MF.ent.health + drain
		-- end
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

-- Upgrade a Tank to MK2 --
function upgradeTank(id)
	if global.MF.ccS == nil or global.tankTable == nil  then return end
	-- Get the tank ID --
	local tankId = global.tankTable[id]
	if tankId == nil then return end
	-- Get The Tank --
	local tank = global.tankTable[id].ent
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
		local newTank = global.MF.ccS.create_entity{name="StorageTank".. id .."MK2", position=tank.position, force="player"}
		-- Fill the fluid --
		newTank.insert_fluid({name=name, amount=amount})
		-- Save the tank --
		global.tankTable[id].ent = newTank
	else
		-- Create the new tank --
		local newTank = global.MF.ccS.create_entity{name="StorageTank".. id .."MK2", position=tank.position, force="player"}
		-- Save the tank --
		global.tankTable[id].ent = newTank
	end
	-- Destroy the old Tank --
	tank.destroy()
end

-- Send all Pollution outside --
function updatePollution()
	-- Test if the Mobile Factory is valid --
	if global.MF == nil or global.MF.fS == nil or global.MF.ent == nil then return end
	if global.MF.ent.valid == false then return end
	if global.MF.ent.surface == nil then return end
	-- Get the total amount of Pollution --
	local totalPollution = global.MF.fS.get_total_pollution()
	if totalPollution ~= nil then
		-- Create Pollution outside the Factory --
		global.MF.ent.surface.pollute(global.MF.ent.position, totalPollution)
		-- Clear the Factory Pollution --
		global.MF.fS.clear_pollution()
	end
end







