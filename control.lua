pcall(require,'__debugadapter__/debugadapter.lua')

GUI = {}
Util = {}
UpSys = {}

require("utils/profiler.lua")
require("utils/settings.lua")
require("utils/functions.lua")
require("utils/surface.lua")
require("scripts/GUI/gui.lua")
require("utils/cc-extension.lua")
require("scripts/game-update.lua")
require("utils/warptorio.lua")
require("scripts/objects/mobile-factory.lua")
require("scripts/objects/power-drain-pole.lua")
require("scripts/objects/ore-cleaner.lua")
require("scripts/objects/fluid-extractor.lua")
require("scripts/objects/inventory.lua")
require("scripts/objects/data-network.lua")
require("scripts/objects/data-center.lua")
require("scripts/objects/data-center-mf.lua")
require("scripts/objects/data-storage.lua")
require("scripts/objects/matter-serializer.lua")
require("scripts/objects/matter-printer.lua")
require("scripts/objects/wireless-data-transmitter.lua")
require("scripts/objects/wireless-data-receiver.lua")
require("scripts/objects/energy-cube.lua")
require("scripts/objects/mining-jet.lua")
require("scripts/objects/mining-jet-flag.lua")
require("scripts/objects/construction-jet.lua")
require("scripts/objects/repair-jet.lua")
require("scripts/objects/combat-jet.lua")
require("scripts/objects/deep-storage.lua")

-- When the mod init --
function onInit()
	-- Update System --
	global.entsTable = {}
	global.upsysTickTable = {}
	global.entsUpPerTick = _mfBaseUpdatePerTick
	global.upSysLastScan = 0
	-- Mobile Factory Object --
	global.MF = MF:new()
	global.MF.II = INV:new("Internal Inventory")
	global.MF.II.isII = true
	createMFSurface()
	createControlRoom()
	-- Module ID --
	global.IDModule = 0
	-- Data Network --
	global.dataNetworkID = 0
	-- Jets Options --
	global.mjMaxDistance = 200
	global.cjMaxDistance = 200
	global.rjMaxDistance = 200
	global.cbjMaxDistance = 200
	-- Construction Jet Update --
	global.constructionJetIndex = 0
	-- Repair Jet Update --
	global.repairJetIndex = 0
	-- Tables --
	global.playersTable = {}
	global.accTable = {}
	global.pdpTable = {}
	global.tankTable = {}
	global.dataNetworkTable = {}
	global.dataCenterTable = {}
	global.matterSerializerTable = {}
	global.matterPrinterTable = {}
	global.dataStorageTable = {}
	global.wirelessDataTransmitterTable = {}
	global.wirelessDataReceiverTable = {}
	global.energyCubesTable = {}
	global.deepStorageTable = {}
	global.lfpTable = {}
	global.oreCleanerTable = {}
	global.fluidExtractorTable = {}
	global.miningJetTable = {}
	global.jetFlagTable = {}
	global.constructionJetTable = {}
	global.constructionTable = {}
	global.repairJetTable = {}
	global.repairTable = {}
	global.combatJetTable = {}
end

-- When a save is loaded --
function onLoad()
	-- Add Warptorio Compatibility --
	warptorio()
	-- Set MF Metatable --
	MF:rebuild(global.MF)
	-- Set PDP Metatables --
	for k, pdp in  pairs(global.pdpTable or {}) do
		PDP:rebuild(pdp)
	end
	-- Set DataCenter Metatables --
	for k, dc in  pairs(global.dataCenterTable or {}) do
		DC:rebuild(dc)
	end
	-- Set DataCenterMF Metatable --
	if global.MF.dataCenter ~= nil then
		DCMF:rebuild(global.MF.dataCenter)
	end
	-- Set DataStorage Metatables --
	for k, ds in  pairs(global.dataStorageTable or {}) do
		DS:rebuild(ds)
	end
	-- Set MatterSerializer Metatables --
	for k, ms in pairs(global.matterSerializerTable or {}) do
		MS:rebuild(ms)
	end
	-- Set MatterPrinter Metatables --
	for k, mp in pairs(global.matterPrinterTable or {}) do
		MP:rebuild(mp)
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
end

-- When a player joint the game --
function onPlayerJoint(event)
	local player = getPlayer(event.player_index)
	setPlayerVariable(player.name, "GUICreated", false)
end

-- When the configuration have changed --
function onConfigurationChanged()
	-- Update all Variables --
	updateValues()
	-- Update all GUI --
	for k, player in pairs(game.players) do
		GUI.createPlayerGui(player)
	end
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

-- Events --
script.on_init(onInit)
script.on_load(onLoad)
script.on_configuration_changed(onConfigurationChanged)
script.on_event(defines.events.on_player_joined_game, onPlayerJoint)
script.on_event(defines.events.on_player_driving_changed_state, playerDriveStatChange)
script.on_event(defines.events.on_player_created, onPlayerCreated)
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
script.on_event(defines.events.on_gui_click, GUI.buttonClicked)
script.on_event(defines.events.on_gui_elem_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_checked_state_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_selection_state_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_text_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_research_finished, technologyFinished)
script.on_event(defines.events.on_selected_entity_changed, selectedEntityChanged)
script.on_event(defines.events.on_marked_for_deconstruction, markedForDeconstruction)

-- Add command to insert Mobile Factory to the player inventory --
commands.add_command("GetMobileFactory", "Add the Mobile Factory to the player inventory", addMobileFactory)






