pcall(require,'__debugadapter__/debugadapter.lua')

GUI = {}
Util = {}
UpSys = {}
Erya = {}

require("utils/profiler.lua")
require("utils/settings.lua")
require("utils/functions.lua")
require("utils/surface.lua")
require("scripts/GUI/gui.lua")
require("utils/cc-extension.lua")
require("scripts/game-update.lua")
require("utils/warptorio.lua")
require("scripts/objects/mobile-factory.lua")
require("scripts/objects/gui-object.lua")
require("scripts/objects/power-drain-pole.lua")
require("scripts/objects/ore-cleaner.lua")
require("scripts/objects/fluid-extractor.lua")
require("scripts/objects/inventory.lua")
require("scripts/objects/data-network.lua")
require("scripts/objects/data-center.lua")
require("scripts/objects/data-center-mf.lua")
require("scripts/objects/data-storage.lua")
require("scripts/objects/matter-interactor.lua")
require("scripts/objects/fluid-interactor.lua")
require("scripts/objects/wireless-data-transmitter.lua")
require("scripts/objects/wireless-data-receiver.lua")
require("scripts/objects/energy-cube.lua")
require("scripts/objects/mining-jet.lua")
require("scripts/objects/mining-jet-flag.lua")
require("scripts/objects/construction-jet.lua")
require("scripts/objects/repair-jet.lua")
require("scripts/objects/combat-jet.lua")
require("scripts/objects/deep-storage.lua")
require("scripts/objects/deep-tank.lua")
require("scripts/objects/MFPlayer.lua")
require("scripts/objects/erya-structure.lua")

-- When the mod init --
function onInit()
	-- Update System --
	global.entsTable = {}
	global.upsysTickTable = {}
	global.entsUpPerTick = _mfBaseUpdatePerTick
	global.upSysLastScan = 0
	global.insertedMFInsideInventory = false
	global.updateEryaIndex = 1
	-- Data Network --
	global.dataNetworkID = 0
	-- Construction Jet Update --
	global.constructionJetIndex = 0
	-- Repair Jet Update --
	global.repairJetIndex = 0
	-- Research --
	for _, force in pairs(game.forces) do
		if settings.startup["MF-initial-research-complete"] and settings.startup["MF-initial-research-complete"].value == true then
			force.technologies["DimensionalOre"].researched = true
		end
	end
	-- Floor Is Lava --
	global.floorIsLavaActivated = false
	-- Tables --
	global.playersTable = {}
	global.MFTable = {}
	global.GUITable = {}
	global.accTable = {}
	global.pdpTable = {}
	global.dataNetworkTable = {}
	global.dataNetworkIDGreenTable = {}
	global.dataNetworkIDRedTable = {}
	global.dataCenterTable = {}
	global.matterInteractorTable = {}
	global.fluidInteractorTable = {}
	global.dataStorageTable = {}
	global.wirelessDataTransmitterTable = {}
	global.wirelessDataReceiverTable = {}
	global.energyCubesTable = {}
	global.deepStorageTable = {}
	global.deepTankTable = {}
	global.oreCleanerTable = {}
	global.fluidExtractorTable = {}
	global.miningJetTable = {}
	global.jetFlagTable = {}
	global.constructionJetTable = {}
	global.constructionTable = {}
	global.repairJetTable = {}
	global.repairTable = {}
	global.combatJetTable = {}
	global.eryaTable = {}
	global.eryaIndexedTable = {}
    global.syncTile = "dirt-7"
	-- Validate the Tile Used for the Sync Area --
	validateSyncAreaTile()
	-- Ensure All Needed Tiles are Present --
	checkNeededTiles()
end

-- When a save is loaded --
function onLoad()
	-- Add Warptorio Compatibility --
	warptorio()
	-- Set MFPlayer Metatables --
	for k, mfplayer in  pairs(global.playersTable or {}) do
		MFP:rebuild(mfplayer)
	end
	-- Set MF Metatables --
	for k, mf in  pairs(global.MFTable or {}) do
		MF:rebuild(mf)
	end
	-- Set GUI Objects Metatables --
	for k, go in pairs(global.GUITable or {}) do
		GO:rebuild(go)
	end
	-- Set PDP Metatables --
	for k, pdp in  pairs(global.pdpTable or {}) do
		PDP:rebuild(pdp)
	end
	-- Set DataCenter Metatables --
	for k, dc in  pairs(global.dataCenterTable or {}) do
		if dc.invObj.isII then
			DCMF:rebuild(dc)
		else
			DC:rebuild(dc)
		end
	end
	-- Set DataStorage Metatables --
	for k, ds in  pairs(global.dataStorageTable or {}) do
		DS:rebuild(ds)
	end
	-- Set MatterInteractor Metatables --
	for k, mi in pairs(global.matterInteractorTable or {}) do
		MI:rebuild(mi)
	end
	-- Set FluidInteractor Metatables --
	for k, fi in pairs(global.fluidInteractorTable or {}) do
		FI:rebuild(fi)
	end
	-- Set Wireless Data Transmitter Metatables --
	for k, wdt in pairs(global.wirelessDataTransmitterTable or {}) do
		WDT:rebuild(wdt)
	end
	-- Set Wireless Data Receiver Metatables --
	for k, wdr in pairs(global.wirelessDataReceiverTable or {}) do
		WDR:rebuild(wdr)
	end
	-- Set EnergyCube Metatables --
	for k, ec in pairs(global.energyCubesTable or {}) do
		EC:rebuild(ec)
	end
	-- Set Ore Cleaner Metatable --
	for k, oc in pairs(global.oreCleanerTable or {}) do
		OC:rebuild(oc)
	end
	-- Set Fluid Extractor Metatables --
	for k, fe in pairs(global.fluidExtractorTable or {}) do
		FE:rebuild(fe)
	end
	-- Set The Mining Jet Metatables --
	for k, mj in pairs(global.miningJetTable or {}) do
		MJ:rebuild(mj)
	end
	-- Set The Jet Flag Metatables --
	for k, mjf in pairs(global.jetFlagTable or {}) do
		MJF:rebuild(mjf)
	end
	-- Set The Construction Jet Metatables --
	for k, cj in pairs(global.constructionJetTable or {}) do
		CJ:rebuild(cj)
	end
	-- Set The Repair Jet Metatables --
	for k, rj in pairs(global.repairJetTable or {}) do
		RJ:rebuild(rj)
	end
	-- Set The Combat Jet Metatables --
	for k, cbj in pairs(global.combatJetTable or {}) do
		CBJ:rebuild(cbj)
	end
	-- Set The Deep Storage Metatables --
	for k, dsr in pairs(global.deepStorageTable or {}) do
		DSR:rebuild(dsr)
	end
	-- Set The Deep Tank Metatables --
	for k, dtk in pairs(global.deepTankTable or {}) do
		DTK:rebuild(dtk)
	end
	-- Set Erya Structures Metatables --
	for k, es in pairs(global.eryaTable or {}) do
		ES:rebuild(es)
	end
end

-- When the configuration has changed --
function onConfigurationChanged()
	-- Update all Variables --
	updateValues()
	-- Recreate the Main GUI --
	for k, player in pairs(game.players) do
		GUI.createMFMainGUI(player)
	end

	-- Validate the Tile Used for the Sync Area --
	validateSyncAreaTile()
	-- Ensure All Needed Tiles are Present --
	checkNeededTiles()
end

-- Filters --
_mfEntityFilter = {
	{filter = "type", type = "unit", invert = true},
	{filter = "type", type = "tree", mode = "and", invert = true},
	{filter = "type", type = "unit-spawner", mode = "and", invert = true},
	{filter = "type", type = "turret", mode = "and", invert = true},
	{filter = "type", type = "fish", mode = "and", invert = true}
}

_mfEntityFilterWithCBJ = {
	{filter = "type", type = "unit", invert = true},
	{filter = "type", type = "tree", mode = "and", invert = true},
	{filter = "type", type = "simple-entity", mode = "and", invert = true},
	{filter = "type", type = "unit-spawner", mode = "and", invert = true},
	{filter = "type", type = "turret", mode = "and", invert = true},
	{filter = "type", type = "fish", mode = "and", invert = true},
	{filter = "name", name = "CombatJet", mode = "or"}
}

local function onForceCreated(event)
  local force = event.force

  if force.valid and settings.startup["MF-initial-research-complete"] and settings.startup["MF-initial-research-complete"].value == true then
    force.technologies["DimensionalOre"].researched = true
  end
end

local function onPlayerSetupBlueprint(event)
	local player = game.players[event.player_index]
	local mapping = event.mapping.get()
	local bp = player.blueprint_to_setup
	if bp.valid_for_read == false then
		local cursor = player.cursor_stack
		if cursor and cursor.valid_for_read and cursor.name == "blueprint" then
			bp = cursor
			--return
		end
	end
	if bp == nil or bp.valid_for_read == false then return end

	local nameToTable = {
		["MatterInteractor"] = "matterInteractorTable",
		["FluidInteractor"] = "fluidInteractorTable",
		["WirelessDataReceiver"] = "wirelessDataReceiverTable",
		["OreCleaner"] = "oreCleanerTable",
		["DeepStorage"] = "deepStorageTable",
		["DeepTank"] = "deepTankTable",
	}

	for index, ent in pairs(mapping) do
		local saveTable = nameToTable[ent.name]
		if ent.valid == true and saveTable ~= nil then
			if global[saveTable] == nil then
				-- Create Table If Nothing Was Ever Placed --
				global[saveTable] = {}
			end
			saveTable = global[saveTable]
			local tags = entityToBluePrintTags(ent, saveTable)
			if tags ~= nil then
				for tag, value in pairs(tags) do
					bp.set_blueprint_entity_tag(index, tag, value)
				end
			end
		end
    end
end

-- Events --
script.on_init(onInit)
script.on_load(onLoad)
script.on_configuration_changed(onConfigurationChanged)
script.on_event(defines.events.on_player_created, initPlayer)
script.on_event(defines.events.on_player_joined_game, initPlayer)
script.on_event(defines.events.on_player_driving_changed_state, playerDriveStatChange)
script.on_event(defines.events.on_tick, onTick)
script.on_event(defines.events.on_entity_damaged, onEntityDamaged, _mfEntityFilterWithCBJ)
script.on_event(defines.events.on_built_entity, onPlayerBuildSomething)
script.on_event(defines.events.on_player_built_tile, onPlayerBuildSomething)
script.on_event(defines.events.script_raised_built, onPlayerBuildSomething)
script.on_event(defines.events.script_raised_revive, onPlayerBuildSomething)
script.on_event(defines.events.on_robot_built_entity, onRobotBuildSomething)
script.on_event(defines.events.on_robot_built_tile, onRobotBuildSomething)
script.on_event(defines.events.on_player_mined_entity, onPlayerRemoveSomethings)
script.on_event(defines.events.on_player_mined_tile, onPlayerRemoveSomethings)
script.on_event(defines.events.on_robot_mined_entity, onRobotRemoveSomething)
script.on_event(defines.events.on_robot_mined_tile, onRobotRemoveSomething)
script.on_event(defines.events.script_raised_destroy, onPlayerRemoveSomethings)
script.on_event(defines.events.on_entity_died, onEntityIsDestroyed, _mfEntityFilter)
script.on_event(defines.events.on_post_entity_died, onGhostPlacedByDie, _mfEntityFilter)
script.on_event(defines.events.on_gui_opened, GUI.guiOpened)
script.on_event(defines.events.on_gui_closed, GUI.guiClosed)
script.on_event(defines.events.on_gui_click, GUI.buttonClicked)
script.on_event(defines.events.on_gui_elem_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_checked_state_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_selection_state_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_text_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_switch_state_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_selected_tab_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_research_finished, technologyFinished)
script.on_event(defines.events.on_selected_entity_changed, selectedEntityChanged)
script.on_event(defines.events.on_marked_for_deconstruction, markedForDeconstruction)
script.on_event(defines.events.on_entity_settings_pasted, settingsPasted)
script.on_event(defines.events.on_force_created, onForceCreated)
script.on_event(defines.events.on_player_setup_blueprint, onPlayerSetupBlueprint)
script.on_event("OpenTTGUI", onShortcut)

-- Add command to insert Mobile Factory to the player inventory --
-- commands.add_command("GetMobileFactory", "Add the Mobile Factory to the player inventory", addMobileFactory)
