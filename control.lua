GUI = {}
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
require("scripts/objects/data-center.lua")
require("scripts/objects/data-center-mf.lua")
require("scripts/objects/data-storage.lua")
require("scripts/objects/matter-serializer.lua")
require("scripts/objects/matter-printer.lua")
require("scripts/objects/energy-cube.lua")

-- When the mod init --
function onInit()
	-- Mobile Factory Object --
	global.MF = MF:new()
	global.MF.II = INV:new("Internal Inventory")
	global.MF.II.isII = true
	createMFSurface()
	createControlRoom()
	-- Update System --
	global.entsTable = {}
	global.entsUpPerTick = _mfBaseUpdatePerTick
	global.upSysIndex = 1
	global.upSysLastScan = 0
	-- Module ID --
	global.IDModule = 0
	-- Current Entities Update --
	global.currentSilotPadChestUpdate = 1
	-- Tables --
	global.playersTable = {}
	global.accTable = {}
	global.pdpTable = {}
	global.tankTable = {}
	global.dataCenterTable = {}
	global.matterSerializerTable = {}
	global.matterPrinterTable = {}
	global.dataStorageTable = {}
	global.energyCubesTable = {}
	global.oreSilotTable = {}
	global.lfpTable = {}
	global.fluidExtractorTable = {}
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
	-- Set EnergyCube Metatables --
	for k, ec in pairs(global.energyCubesTable or {}) do
		EC:rebuild(ec)
	end
	-- Set Ore Cleaner Metatable --
	OC:rebuild(global.oreCleaner)
	-- Set Fluid Extractor Metatables --
	for k, fe in pairs(global.fluidExtractorTable or {}) do
		FE:rebuild(fe)
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

-- Event --
script.on_init(onInit)
script.on_load(onLoad)
script.on_configuration_changed(onConfigurationChanged)
script.on_event(defines.events.on_player_joined_game, onPlayerJoint)
script.on_event(defines.events.on_player_driving_changed_state, playerDriveStatChange)
script.on_event(defines.events.on_player_created, onPlayerCreated)
script.on_event(defines.events.on_tick, onTick)
script.on_event(defines.events.on_entity_damaged, onEntityDamaged)
script.on_event(defines.events.on_built_entity, onPlayerBuildSomething)
script.on_event(defines.events.on_player_built_tile, onPlayerBuildSomething)
script.on_event(defines.events.on_robot_built_entity, onRobotBuildSomething)
script.on_event(defines.events.on_robot_built_tile, onRobotBuildSomething)
script.on_event(defines.events.on_player_mined_entity, onPlayerRemoveSomethings)
script.on_event(defines.events.on_player_mined_tile, onPlayerRemoveSomethings)
script.on_event(defines.events.on_robot_mined_entity, onRobotRemoveSomething)
script.on_event(defines.events.on_robot_mined_tile, onRobotRemoveSomething)
script.on_event(defines.events.on_entity_died, onEntityIsDestroyed)
script.on_event(defines.events.on_gui_click, GUI.buttonClicked)
script.on_event(defines.events.on_gui_elem_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_checked_state_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_gui_text_changed, GUI.onGuiElemChanged)
script.on_event(defines.events.on_research_finished, technologyFinished)
script.on_event(defines.events.on_selected_entity_changed, selectedEntityChanged)

-- Add command to insert Mobile Factory to the player inventory --
commands.add_command("GetMobileFactory", "Add the Mobile Factory to the player inventory", addMobileFactory)






