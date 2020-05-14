require("utils/players-teleportation.lua")
require("utils/surface")
require("utils/saved-tables.lua")
require("utils/functions.lua")
require("scripts/update-system.lua")
require("utils/place-and-remove.lua")

-- One each game tick --
function onTick(event)
	-- Update all Mobile Factory --
	for k, MF in pairs(global.MFTable) do
		if MF ~= nil then
			MF:update(event)
		end
	end
	-- Update all entities --
	updateEntities(event)
	-- Update all Erya Structures --
	Erya.updateEryaStructures(event)
	-- Update all GUI --
	GUI.updateAllGUIs()
	-- Update the Floor Is Lava --
	if event.tick%_eventTick150 == 0 and global.floorIsLavaActivated == true then updateFloorIsLava() end
end

-- Update all entities --
function updateEntities(event)
	-- Update --
	if event.tick%_eventTick110 == 0 then updateMiningJet() end
	if event.tick%_eventTick45 == 0 then updateConstructionJet() end
	if event.tick%_eventTick41 == 0 then updateRepairJet() end
	if event.tick%_eventTick73 == 0 then updateCombatJet() end
	if event.tick%_eventTick242 == 0 then checkDataNetworkID() end
	-- Update System --
	UpSys.update(event)
end

-- Update base Mobile Factory Values --
function updateValues()
	if global.insertedMFInsideInventory == nil then global.insertedMFInsideInventory = true end
	if global.entsTable == nil then global.entsTable = {} end
	if global.upsysTickTable == nil then global.upsysTickTable = {} end
	if global.entsUpPerTick == nil then global.entsUpPerTick = _mfBaseUpdatePerTick end
	if global.upSysLastScan == nil then global.upSysLastScan = 0 end
	if global.updateEryaIndex == nil then global.updateEryaIndex = 1 end
	if global.dataNetworkID == nil then global.dataNetworkID = 0 end
	if global.constructionJetIndex == nil then global.constructionJetIndex = 0 end
	if global.repairJetIndex == nil then global.repairJetIndex = 0 end
	if global.floorIsLavaActivated == nil then global.floorIsLavaActivated = false end
	if global.playersTable == nil then global.playersTable = {} end
	if global.MFTable == nil then global.MFTable = {} end
	if global.deepStorageTable == nil then global.deepStorageTable = {} end
	if global.deepTankTable == nil then global.deepTankTable = {} end
	if global.dataNetworkTable == nil then global.dataNetworkTable = {} end
	if global.dataNetworkIDGreenTable == nil then global.dataNetworkIDGreenTable = {} end
	if global.dataNetworkIDRedTable == nil then global.dataNetworkIDRedTable = {} end
	if global.matterInteractorTable == nil then global.matterInteractorTable = {} end
	if global.fluidInteractorTable == nil then global.fluidInteractorTable = {} end
	if global.dataAssemblerTable == nil then global.dataAssemblerTable = {} end
	if global.networkExplorerTable == nil then global.networkExplorerTable = {} end
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
	if global.eryaTable == nil then global.eryaTable = {} end
	if global.eryaIndexedTable == nil then global.eryaIndexedTable = {} end
	-- Delete all Animations and Sprites --
	rendering.clear("Mobile_Factory")

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
	local func = _MFResearches[event.research.name]
	if func == nil then return end
	for index, player in pairs(game.players) do
		if player.valid == true then -- should always be valid?
			local mfPlayer = getMFPlayer(player.name)
			if valid(mfPlayer) and valid(mfPlayer.MF) and event.research.force == player.force then
				func(mfPlayer.MF)
			end
		end
	end
end

-- Check all Technologies of a Player Mobile Factory --
function checkTechnologies(MF)
	local force = getForce(MF.player)
	for research, func in pairs(_MFResearches) do
		if technologyUnlocked(research, force) == true and MF.varTable.tech[research] ~= true then func(MF) end
	end
end

function selectedEntityChanged(event)
	-- Get the Player --
	local player = getPlayer(event.player_index)
	-- Check the Player and the Entity --
	if player == nil or player.selected == nil or player.selected.valid == false or player.selected.unit_number == nil then return end
	-- Check if the Tooltip GUI exist --
	if player.gui.screen.mfTooltipGUI == nil or player.gui.screen.mfTooltipGUI.valid == false then return end
	-- Check if the Tooltip GUI is not locked --
	if getPlayerVariable(player.name, "TTGUILocked") == true then return end
	-- Update the Tooltip GUI --
	GUI.updateTooltip(player, player.selected)
end

-- If player entered or living a vehicle --
function playerDriveStatChange(event)
	-- Teleport the player out of reach from Mobile Factoty teleport box --
	local player = getPlayer(event.player_index)
	local entity = event.entity
	if entity == nil or entity.valid == false or player == nil or player.valid == false or string.find(entity.name, "MobileFactory") == nil then return end
	if entity.surface.can_place_entity{name="character", position = {entity.position.x + 5, entity.position.y}} then
		player.teleport({entity.position.x + 5, entity.position.y}, entity.surface)
	elseif entity.surface.can_place_entity{name="character", position = {entity.position.x -5, entity.position.y}} then
		player.teleport({entity.position.x - 5, entity.position.y}, entity.surface)
	elseif entity.surface.can_place_entity{name="character", position = {entity.position.x, entity.position.y - 7}} then
		player.teleport({entity.position.x, entity.position.y - 7}, entity.surface)
	else
		player.teleport({entity.position.x, entity.position.y + 7}, entity.surface)
	end
end

-- When a player join the game --
function initPlayer(event)
	local player = getPlayer(event.player_index)
	if player == nil then return end
	--player.force.technologies["DimensionalOre"].researched = true
	if getMFPlayer(player.name) == nil then
		global.playersTable[player.name] = MFP:new(player)
		-- Mobile Factory Object --
		local MF = MF:new()
		global.MFTable[player.name] = MF
		MF.internalEnergyObj = IEC:new(MF)
		MF.internalQuatronObj = IQC:new(MF)
		MF.II = INV:new("Internal Inventory")
		MF.II.MF = MF
		MF.II.isII = true
		MF.playerIndex = player.index
		MF.player = player.name
		createMFSurface(MF)
		createControlRoom(MF)
		global.playersTable[player.name].MF = MF
		Util.addMobileFactory(player)
		setPlayerVariable(player.name, "GotInventory", true)
		GUI.createMFMainGUI(player)
	end
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
	if event.entity.force.name == "enemy" or event.entity.force.name == "neutral" then return end
	-- Check the Entity --
	if event.entity == nil or event.entity.valid == false then return end
	-- Command to the Jet to return to the Mobile Factory if its life is low --
	if event.entity.name == "CombatJet" then
		local obj = global.combatJetTable[event.entity.unit_number]
		if valid(obj) == true and event.entity.health < 600 and obj.currentOrder == "Fight" then
			obj:goMF(defines.distraction.none)
		end
		return
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
		if table_size(global.repairTable) < 1000 then
			table.insert(global.repairTable, {ent=event.entity})
		else
			game.print("Mobile Factory: To many damaged Entities inside the Repair Table")
			global.repairTable = {}
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

-- Called when a Setting is pasted --
function settingsPasted(event)
	-- Check the Entities --
	if event.source == nil or event.source.valid == false then return end
	if event.destination == nil or event.destination.valid == false then return end

	-- Get the Objects --
	local o1 = nil
	local o2 = nil
	for k, obj in pairs(global.entsTable) do
		if valid(obj) == true and obj.ent ~= nil and obj.ent.valid == true then
			if obj.ent.unit_number == event.source.unit_number then o1 = obj end
			if obj.ent.unit_number == event.destination.unit_number then o2 = obj end
		end
	end

	-- Check the Objects --
	if o1 == nil then return end
	if o2 == nil then return end
	if o1.ent.name ~= o2.ent.name then return end

	-- Copy the Settings --
	if o2.copySettings ~= nil then
		o2:copySettings(o1)
	end
end

-- Called when a Shortcut is pressed --
function onShortcut(event)
	local player = getPlayer(event.player_index)
	-- Tooltip GUI Key --
	if event.input_name == "OpenTTGUI" then
		local ent = player.selected
		if ent ~= nil and ent.valid == true and _mfTooltipGUI[ent.name] ~= nil then
			event.entity = ent
			GUI.guiOpened(event)
		end
	end
end

-- Damage all Players that aren't on a safe position --
function updateFloorIsLava()
	-- Take all Players --
	for k, player in pairs(game.players) do
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

-- Update the Mining Jets --
function updateMiningJet()
	-- Check if there are something to do --
	if table_size(global.jetFlagTable) <= 0 then return end
	for k, flag in pairs(global.jetFlagTable) do
		-- Check the Flag --
		if valid(flag) == false then goto continue end
		-- Check the Mobile Factory --
		if flag.MF == nil or valid(flag.MF) == false then goto continue end
		if flag.MF.ent == nil or flag.MF.ent.valid == false then goto continue end
		if flag.MF.varTable.jets.mjMaxDistance == nil then flag.MF.varTable.jets.mjMaxDistance = _MFMiningJetDefaultMaxDistance end
		-- Get the Mobile Factory Trunk --
		local inv = flag.MF.ent.get_inventory(defines.inventory.car_trunk)
		-- Check the Inventory --
		if inv == nil or inv.valid == false then return end
		-- Check the Distance --
		if Util.distance(flag.ent.position, flag.MF.ent.position) > flag.MF.varTable.jets.mjMaxDistance then goto continue end
		-- Check if there are Ores left --
		if table_size(flag.oreTable) <= 0 then goto continue end
		-- Check if there are enought space inside the Targeted Inventory --
		if flag.TargetInventoryFull == true then goto continue end
		-- Request Jet --
		for i = 1, table_size(flag.oreTable) do
			-- Check the Energy --
			if flag.MF.internalEnergyObj:energy() < _mfMiningJetEnergyNeeded then return end
			-- Get an Ore Path --
			local orePath = flag:getOrePath()
			-- Check the Ore Path --
			if orePath == nil or orePath.valid == false or orePath.amount <= 0 then
				flag:removeOrePath(orePath)
			else
				-- Remove a Jet from the Inventory --
				local removed = inv.remove({name="MiningJet", count=1})
				-- Check if the Jet exist --
				if removed <= 0 then goto continue end
				-- Remove the Energy --
				flag.MF.internalEnergyObj:removeEnergy(_mfMiningJetEnergyNeeded)
				-- Create the Entity --
				local entity = flag.MF.ent.surface.create_entity{name="MiningJet", position=flag.MF.ent.position, force=flag.MF.ent.force, player=flag.MF.player}
				global.miningJetTable[entity.unit_number] = MJ:new(entity, orePath, flag)
			end
			-- Stop if there are 5 Jets out --
			if i >= 5 then goto continue end
		end
		::continue::
	end
end

-- Update the Construction Jets --
function updateConstructionJet()
	-- Check if there are something to do --
	if table_size(global.constructionTable) <= 0 then return end
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
		if structure == nil or structure.ent == nil or structure.ent.valid == false then
			table.remove(global.constructionTable, global.constructionJetIndex)
			goto continue
		end
		-- Check the Structure Owner --
		if structure.ent.last_user == nil then goto continue end
		-- Get the Mobile Factory --
		local MF = global.MFTable[structure.ent.last_user.name]
		-- Check the Mobile Factory --
		if MF == nil or MF.ent == nil or MF.ent.valid == false then goto continue end
		if MF.varTable.jets.cjMaxDistance == nil then MF.varTable.jets.cjMaxDistance = _MFConstructionJetDefaultMaxDistance end
		-- Check the Structure and Mobile Factory Owner --
		if structure.ent.last_user.name ~= MF.player then goto continue end
		-- Check the Energy --
		if MF.internalEnergyObj:energy() < _mfConstructionJetEnergyNeeded then goto continue end
		-- Get the Mobile Factory Trunk --
		local inv = MF.ent.get_inventory(defines.inventory.car_trunk)
		-- Check the Inventory --
		if inv == nil or inv.valid == false then goto continue end
		-- Check the Structure --
		if structure.ent.surface ~= MF.ent.surface then
			table.remove(global.constructionTable, global.constructionJetIndex)
			goto continue
		end
		if structure.mission == "Deconstruct" and structure.ent.prototype.items_to_place_this == nil then
			table.remove(global.constructionTable, global.constructionJetIndex)
			goto continue
		end
		if structure.mission == "Deconstruct" and structure.ent.to_be_deconstructed(MF.ent.force) == false then
			table.remove(global.constructionTable, global.constructionJetIndex)
			goto continue
		end
		-- Check the Distance --
		if Util.distance(structure.ent.position, MF.ent.position) > MF.varTable.jets.cjMaxDistance then goto continue end
		-- Check if there are no Jet already attributed to this Structure --
		if valid(structure.jet) == true then goto continue end
		-- Remove a Jet from the Inventory --
		local removed = inv.remove({name="ConstructionJet", count=1})
		-- Check if the Jet exist --
		if removed <= 0 then goto continue end
		if structure.mission == "Construct" then
			-- Remove the Item from the II --
			local removed = MF.II:getItem(structure.item, 1)
			-- Check if the Item exist --
			if removed <= 0 then
				inv.insert({name="ConstructionJet", count=1})
				goto continue
			end
		end
		-- Remove the Energy --
		MF.internalEnergyObj:removeEnergy(_mfConstructionJetEnergyNeeded)
		-- Create the Jet --
		local entity = MF.ent.surface.create_entity{name="ConstructionJet", position=MF.ent.position, force=MF.ent.force, player=MF.player}
		global.constructionJetTable[entity.unit_number] = CJ:new(entity, structure)
		structure.jet = global.constructionJetTable[entity.unit_number]
		::continue::
	end
end

-- Update the Repair Jets --
function updateRepairJet()
	-- Check if there are something to do --
	if table_size(global.repairTable) <= 0 then return end
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
			goto continue
		end
		-- Check the Structure Owner --
		if structure.ent.last_user == nil then goto continue end
		-- Get the Mobile Factory --
		local MF = global.MFTable[structure.ent.last_user.name]
		-- Check the Mobile Factory --
		if MF == nil or MF.ent == nil or MF.ent.valid == false then return end
		if MF.varTable.jets.rjMaxDistance == nil then MF.varTable.jets.rjMaxDistance = _MFRepairJetDefaultMaxDistance end
		-- Check the Structure and Mobile Factory Owner --
		if structure.ent.last_user.name ~= MF.player then goto continue end
		-- Check the Energy --
		if MF.internalEnergyObj:energy() < _mfRepairJetEnergyNeeded then return end
		-- Get the Mobile Factory Trunk --
		local inv = MF.ent.get_inventory(defines.inventory.car_trunk)
		-- Check the Inventory --
		if inv == nil or inv.valid == false then return end
		-- Check the Structure Surface --
		if structure.ent.surface ~= MF.ent.surface then
			table.remove(global.repairTable, global.repairJetIndex)
			goto continue
		end
		if structure.ent.health >= structure.ent.prototype.max_health then
			table.remove(global.repairTable, global.repairJetIndex)
			goto continue
		end
		-- Check the Distance --
		if Util.distance(structure.ent.position, MF.ent.position) > MF.varTable.jets.rjMaxDistance then return end
		-- Check if there are no Jet already attributed to this Structure --
		if valid(structure.jet) then goto continue end
		-- Remove a Jet from the Inventory --
		local removed = inv.remove({name="RepairJet", count=1})
		-- Check if the Jet exist --
		if removed <= 0 then goto continue end
		-- Remove the Energy --
		MF.internalEnergyObj:removeEnergy(_mfRepairJetEnergyNeeded)
		-- Create the Jet --
		local entity = MF.ent.surface.create_entity{name="RepairJet", position=MF.ent.position, force=MF.ent.force, player=MF.player}
		global.repairJetTable[entity.unit_number] = RJ:new(entity, structure)
		structure.jet = global.repairJetTable[entity.unit_number]
		::continue::
	end
end

-- Update Combat Jets --
function updateCombatJet()
	-- Itinerate all Mobile Factories --
	for k, MF in pairs(global.MFTable) do
		-- Check the Mobile Factory --
		if MF == nil or MF.ent == nil or MF.ent.valid == false then goto continue end
		if MF.varTable.jets.cbjMaxDistance == nil then MF.varTable.jets.cbjMaxDistance = _MFCombatJetDefaultMaxDistance end
		-- Get the Mobile Factory Trunk --
		local inv = MF.ent.get_inventory(defines.inventory.car_trunk)
		-- Check the Inventory --
		if inv == nil or inv.valid == false then goto continue end
		-- Look for an Enemy --
		local enemy = MF.ent.surface.find_nearest_enemy{position=MF.ent.position, max_distance =MF.varTable.jets.cbjMaxDistance, force=MF.ent.force}
		-- Check the Entity --
		if enemy == nil or enemy.valid == false then goto continue end
		-- Sent 5 Jets --
		for i = 1, 5 do
			-- Check the Energy --
			if MF.internalEnergyObj:energy() < _mfCombatJetEnergyNeeded then goto continue end
			-- Remove a Jet from the Inventory --
			local removed = inv.remove({name="CombatJet", count=1})
			-- Check if the Jet exist --
			if removed <= 0 then goto continue end
			-- Remove the Energy --
			MF.internalEnergyObj:removeEnergy(_mfCombatJetEnergyNeeded)
			-- Create the Jet --
			local entity = MF.ent.surface.create_entity{name="CombatJet", position=MF.ent.position, force=MF.ent.force, player=MF.player}
			global.combatJetTable[entity.unit_number] = CBJ:new(entity, enemy.position)
		end
		::continue::
	end
end

-- Check Data Network ID Tables --
function checkDataNetworkID()
	-- Check Green IDs --
	for id, obj in pairs(global.dataNetworkIDGreenTable) do
		if valid(obj) == false or Util.greenCNID(obj) ~= id then
			global.dataNetworkIDGreenTable[id] = nil
		end
	end
	-- Check Red IDs --
	for id, obj in pairs(global.dataNetworkIDRedTable) do
		if valid(obj) == false or Util.redCNID(obj) ~= id then
			global.dataNetworkIDRedTable[id] = nil
		end
	end
end