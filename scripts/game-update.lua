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
	if event.tick%_eventTick21 == 0 and global.MF ~= nil and global.MF.ent ~= nil and global.MF.ent.valid == true then
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
	-- Update --
	if event.tick%_eventTick5 == 0 then factoryTeleportBox() end
	if event.tick%_eventTick38 == 0 then updateAccumulators() end
	if event.tick%_eventTick64 == 0 then updateLogisticFluidPoles() end
	if event.tick%_eventTick45 == 0 then updateConstructionJet() end
	if event.tick%_eventTick41 == 0 then updateRepairJet() end
	if event.tick%_eventTick73 == 0 then updateCombatJet() end
	-- Update System --
	UpSys.update(event)
	updatePowerDrainPole(event)
end

-- Update base Mobile Factory Values --
function updateValues()
	if global.MF == nil then global.MF = MF:new() end
	if global.entsTable == nil then global.entsTable = {} end
	if global.upsysTickTable == nil then global.upsysTickTable = {} end
	if global.entsUpPerTick == nil then global.entsUpPerTick = _mfBaseUpdatePerTick end
	if global.upSysLastScan == nil then global.upSysLastScan = 0 end
	if global.IDModule == nil then global.IDModule = 0 end
	if global.dataNetworkID == nil then global.dataNetworkID = 0 end
	if global.mjMaxDistance == nil then global.mjMaxDistance = 200 end
	if global.cjMaxDistance == nil then global.cjMaxDistance = 200 end
	if global.rjMaxDistance == nil then global.rjMaxDistance = 200 end
	if global.cbjMaxDistance == nil then global.cbjMaxDistance= 200 end
	if global.constructionJetIndex == nil then global.constructionJetIndex = 0 end
	if global.repairJetIndex == nil then global.repairJetIndex = 0 end
	if global.accTable == nil then global.accTable = {} end
	if global.pdpTable == nil then global.pdpTable = {} end
	if global.lfpTable == nil then global.lfpTable = {} end
	if global.tankTable == nil then global.tankTable = {} end
	if global.deepStorageTable == nil then global.deepStorageTable = {} end
	if global.dataNetworkTable == nil then global.dataNetworkTable = {} end
	if global.matterSerializerTable == nil then global.matterSerializerTable = {} end
	if global.matterPrinterTable == nil then global.matterPrinterTable = {} end
	if global.dataCenterTable == nil then global.dataCenterTable = {} end
	if global.dataStorageTable == nil then global.dataStorageTable = {} end
	if global.wirelessDataTransmitterTable == nil then global.wirelessDataTransmitterTable = {} end
	if global.wirelessDataReceiverTable == nil then global.wirelessDataReceiverTable = {} end
	if global.energyCubesTable == nil then global.energyCubesTable = {} end
	if global.oreCleanerTable == nil then global.oreCleanerTable = {} end
	if global.fluidExtractorTable == nil then global.fluidExtractorTable = {} end
	if global.miningJetTable == nil then global.miningJetTable = {} end
	if global.jetFlagTable == nil then global.jetFlagTable = {} end
	if global.constructionJetTable == nil then global.constructionJetTable = {} end
	if global.constructionTable == nil then global.constructionTable = {} end
	if global.repairJetTable == nil then global.repairJetTable = {} end
	if global.repairTable == nil then global.repairTable = {} end
	if global.combatJetTable == nil then global.combatJetTable = {} end
	-- for k, j in pairs(global) do
		-- if type(j) == "table" then
			-- dprint(k .. ":" .. table_size(j))
		-- else
			-- dprint(k)
		-- end
	-- end
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
	if event.research.name == "DeepStorage" then createDeepStorageArea() end
	if event.research.name == "ConstructibleArea1" then createConstructibleArea1() end
end

function selectedEntityChanged(event)
	-- Get the Player --
	local player = getPlayer(event.player_index)
	-- Check the Player and the Entity --
	if player == nil or player.selected == nil or player.selected.valid == false or player.selected.unit_number == nil then return end
	-- Check if the Tooltip GUI exist --
	if player.gui.screen.mfTooltipGUI == nil or player.gui.screen.mfTooltipGUI.valid == false then return end
	-- Check if the Tooltip GUI is not locked --
	if player.gui.screen.mfTooltipGUI.mfTTGUIMenuBar.TTLockButton.sprite == "LockIconReed" then return end
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
	if event.entity.force.name ~= "player" then return end
	-- Check the Entity --
	if event.entity == nil or event.entity.valid == false then return end
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
	-- Test if this is in the Control Center --
	if event.entity.surface.name == _mfControlSurfaceName then
		event.entity.health = event.entity.prototype.max_health
	end
	-- Save the Entity inside the Repair table for Jet --
	if event.entity.health < event.entity.prototype.max_health then
		-- Check if the Entity is not already inside the table --
		for k, structure in pairs(global.repairTable) do
			if structure.ent ~= nil and structure.ent.valid == true and event.entity.unit_number == structure.ent.unit_number then
				return
			end
		end
		if table_size(global.repairTable) < 300 then
			table.insert(global.repairTable, {ent=event.entity})
		else
			game.print("Mobile Factory: To many damaged Entities inside the Repair Table")
		end
	end
end

-- Called after an Entity die --
function onGhostPlacedByDie(event)
	-- Raise event if a Blueprint is placed --
	if event.ghost ~= nil and event.ghost.valid == true then
		somethingWasPlaced({entity=event.ghost})
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

-- Update the Contruction Jets --
function updateConstructionJet()
	-- Check if the Technology is unlocked --
	if technologyUnlocked("ConstructionJet") == false then return end
	-- Check if there are something to do --
	if table_size(global.constructionTable) <= 0 then return end
	-- Check the Mobile Factory --
	if global.MF.ent == nil or global.MF.ent.valid == false then return end
	-- Get the Mobile Factory Trunk --
	local inv = global.MF.ent.get_inventory(defines.inventory.car_trunk)
	-- Check the Inventory --
	if inv == nil or inv.valid == false then return end
	-- Check if the index must be reinitialized --
	if global.constructionJetIndex > table_size(global.constructionTable) then
		global.constructionJetIndex = 0
	end
	for i = 1, _mfEntitiesScanedPerUpdate do
		global.constructionJetIndex = global.constructionJetIndex + 1
		if global.constructionJetIndex > table_size(global.constructionTable) then
			global.constructionJetIndex = 0
			return
		end
		-- Get the next Structure --
		local structure = global.constructionTable[global.constructionJetIndex]
		-- Check the Structure --
		if structure == nil or structure.ent == nil or structure.ent.valid == false then
			table.remove(global.constructionTable, global.constructionJetIndex)
			goto continue
		end
		if structure.ent.surface ~= global.MF.ent.surface then
			table.remove(global.constructionTable, global.constructionJetIndex)
			goto continue
		end
		if structure.mission == "Deconstruct" and structure.ent.prototype.items_to_place_this == nil then
			table.remove(global.constructionTable, global.constructionJetIndex)
			goto continue
		end
		if structure.mission == "Deconstruct" and structure.ent.to_be_deconstructed("player") == false then
			table.remove(global.constructionTable, global.constructionJetIndex)
			goto continue
		end
		-- Check the Distance --
		if Util.distance(structure.ent.position, global.MF.ent.position) > global.cjMaxDistance then goto continue end
		-- Check if there are no Jet already attributed to this Structure --
		if structure.jet ~= nil and structure.jet:valid() == true then goto continue end
		-- Remove a Jet from the Inventory --
		local removed = inv.remove({name="ConstructionJet", count=1})
		-- Check if the Jet exist --
		if removed <= 0 then return end
		if structure.mission == "Construct" then
			-- Remove the Item from the II --
			local removed = global.MF.II:getItem(structure.item, 1)
			-- Check if the Item exist --
			if removed <= 0 then 
				inv.insert({name="ConstructionJet", count=1})
				goto continue 
			end
		end
		-- Create the Jet --
		local entity = global.MF.ent.surface.create_entity{name="ConstructionJet", position=global.MF.ent.position, force="player"}
		global.constructionJetTable[entity.unit_number] = CJ:new(entity, structure)
		structure.jet = global.constructionJetTable[entity.unit_number]
		::continue::
	end
end

-- Update the Repair Jets --
function updateRepairJet()
	-- Check if the Technology is unlocked --
	if technologyUnlocked("RepairJet") == false then return end
	-- Check if there are something to do --
	if table_size(global.repairTable) <= 0 then return end
	-- Check the Mobile Factory --
	if global.MF.ent == nil or global.MF.ent.valid == false then return end
	-- Get the Mobile Factory Trunk --
	local inv = global.MF.ent.get_inventory(defines.inventory.car_trunk)
	-- Check the Inventory --
	if inv == nil or inv.valid == false then return end
	-- Check if the index must be reinitialized --
	if global.repairJetIndex > table_size(global.repairTable) then
		global.repairJetIndex = 0
	end
	for i = 1, _mfEntitiesScanedPerUpdate do
	global.repairJetIndex = global.repairJetIndex + 1
	if global.repairJetIndex > table_size(global.repairTable) then
		global.repairJetIndex = 0
		return
	end
	-- Get the next Structure --
	local structure = global.repairTable[global.repairJetIndex]
	if structure == nil or structure.ent == nil or structure.ent.valid == false then
		table.remove(global.repairTable, global.repairJetIndex)
		return
	end
	if structure.ent.surface ~= global.MF.ent.surface then
		table.remove(global.repairTable, global.repairJetIndex)
		return
	end
	if structure.ent.health >= structure.ent.prototype.max_health then
		table.remove(global.repairTable, global.repairJetIndex)
		return
	end
	-- Check the Distance --
	if Util.distance(structure.ent.position, global.MF.ent.position) > global.rjMaxDistance then return end
	-- Check if there are no Jet already attributed to this Structure --
	if structure.jet ~= nil and structure.jet:valid() == true then return end
	-- Remove a Jet from the Inventory --
	local removed = inv.remove({name="RepairJet", count=1})
	-- Check if the Jet exist --
	if removed <= 0 then return end
	local entity = global.MF.ent.surface.create_entity{name="RepairJet", position=global.MF.ent.position, force="player"}
	global.repairJetTable[entity.unit_number] = RJ:new(entity, structure)
	structure.jet = global.repairJetTable[entity.unit_number]
	end
end

-- Update Combat Jets --
function updateCombatJet()
	-- Check if the Technology is unlocked --
	if technologyUnlocked("CombatJet") == false then return end
	-- Check the Mobile Factory --
	if global.MF.ent == nil or global.MF.ent.valid == false then return end
	-- Get the Mobile Factory Trunk --
	local inv = global.MF.ent.get_inventory(defines.inventory.car_trunk)
	-- Check the Inventory --
	if inv == nil or inv.valid == false then return end
	-- Look for an Enemy --
	local enemy = global.MF.ent.surface.find_entities_filtered{position=global.MF.ent.position, radius=global.cbjMaxDistance, type="unit", force="enemy", limit=1}[1]
	-- Check the Entity --
	if enemy == nil or enemy.valid == false then return end
	-- Sent 5 Jets --
	for i = 1, 5 do
		-- Remove a Jet from the Inventory --
		local removed = inv.remove({name="CombatJet", count=1})
		-- Check if the Jet exist --
		if removed <= 0 then return end
		local entity = global.MF.ent.surface.create_entity{name="CombatJet", position=global.MF.ent.position, force="player"}
		global.repairJetTable[entity.unit_number] = CBJ:new(entity, enemy.position)
	end
end