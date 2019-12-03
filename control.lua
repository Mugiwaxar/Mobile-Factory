require("utils/profiler.lua")
require("utils/settings.lua")
require("utils/functions.lua")
require("utils/surface.lua")
require("scripts/gui.lua")
require("scripts/gui-update.lua")
require("utils/cc-extension.lua")
require("scripts/game-update.lua")
require("utils/warptorio.lua")
require("scripts/objects/mobile-factory.lua")
require("scripts/objects/power-drain-pole.lua")
require("scripts/objects/ore-cleaner.lua")
require("scripts/objects/inventory.lua")
require("scripts/objects/data-center.lua")
require("scripts/objects/data-storage.lua")


-- When the mod init --
function onInit()
	-- Mobile Factory Object --
	global.MF = MF:new()
	global.MF.II = II:new("Internal Inventory")
	createMFSurface()
	createControlRoom()
	-- Module ID --
	global.IDModule = 0
	-- Current Entities Update --
	global.currentSilotPadChestUpdate = 1
	-- Ore Cleaner --
	global.oreCleaner = nil
	-- Fluid Extractor --
	global.fluidExtractor = nil
	global.fluidExtractorCharge = 0
	global.fluidExtractorPurity = 0
	-- Tables --
	global.playersTable = {}
	global.accTable = {}
	global.pdpTable = {}
	global.tankTable = {}
	global.dataCenterTable = {}
	global.matterSerializerTable = {}
	global.matterPrinterTable = {}
	global.dataStorageTable = {}
	global.oreSilotTable = {}
	global.oreSilotPadTable = {}
	global.lfpTable = {}
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
	-- Set Ore Cleaner Metatable --
	OC:rebuild(global.oreCleaner)
end

-- When a player joint the game --
function onPlayerJoint(event)
	local player = getPlayer(event.player_index)
	setPlayerVariable(player.name, "GUICreated", false)
end

-- When the configuration have changed --
function onConfigurationChanged()
	-- Update all GUI --
	for k, player in pairs(game.players) do
		createPlayerGui(player)
	end
	-- Update all Variables --
	updateValues()
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
script.on_event(defines.events.on_gui_click, buttonClicked)
script.on_event(defines.events.on_gui_elem_changed, onGuiElemChanged)
script.on_event(defines.events.on_gui_checked_state_changed, onGuiElemChanged)
script.on_event(defines.events.on_research_finished, technologyFinished)

-- Add command to insert Mobile Factory to the player inventory --
commands.add_command("GetMobileFactory", "Add the Mobile Factory to the player inventory", addMobileFactory)






