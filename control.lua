require("utils/settings.lua")
require("utils/functions.lua")
require("utils/surface.lua")
require("utils/gui.lua")
require("utils/gui-update.lua")
require("utils/cc-extension.lua")
require("utils/game-update.lua")
require("utils/warptorio.lua")
require("scripts/objects/mobile-factory.lua")
require("scripts/objects/power-drain-pole.lua")
require("scripts/objects/ore-cleaner.lua")


-- When the mod init --
function onInit()
	-- Mobile Factory Object --
	global.MF = nil
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
	-- Internal Inventory --
	global.mfInventoryItems = 0
	global.mfInventoryTypes = 0
	global.mfInventoryMaxItem = _mfBaseMaxItems
	global.mfInventoryMaxTypes = _mfBaseMaxTypes
	-- Tables --
	global.playersTable = {}
	global.accTable = {}
	global.pdpTable = {}
	global.tankTable = {}
	global.oreSilotTable = {}
	global.oreSilotPadTable = {}
	global.lfpTable = {}
	global.inventoryTable = {}
	global.providerPadTable = {}
	global.requesterPadTable = {}
	global.inventoryPadTable = {}
end

-- When a save is loaded --
function onLoad()
	-- Add Warptorio Compatibility --
	warptorio()
	-- Set MF Metatables --
	MF:rebuild(global.MF)
	-- Set PDP Metatables --
	for k, pdp in  pairs(global.pdpTable) do
		PDP:rebuild(pdp)
	end
	-- Set Ore Cleaner Metatables --
	OC:rebuild(global.oreCleaner)
end

-- When a player joint the game --
function onPlayerJoint(event)
	local player = getPlayer(event.player_index)
	setPlayerVariable(player.name, "GUICreated", false)
end

-- When the configuration have changed --
function onConfigurationChanged()
	for k, player in pairs(game.players) do
		createPlayerGui(player)
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
script.on_event(defines.events.on_robot_built_entity, onRobotBuildSomething)
script.on_event(defines.events.on_player_mined_entity, onPlayerRemoveSomethings)
script.on_event(defines.events.on_robot_mined_entity, onRobotRemoveSomething)
script.on_event(defines.events.on_entity_died, onEntityIsDestroyed)
script.on_event(defines.events.on_gui_click, buttonClicked)
script.on_event(defines.events.on_gui_elem_changed, onGuiElemChanged)
script.on_event(defines.events.on_research_finished, technologyFinished)

-- Add command to insert Mobile Factory to the player inventory --
commands.add_command("GetMobileFactory", "Add the Mobile Factory to the player inventory", addMobileFactory)






