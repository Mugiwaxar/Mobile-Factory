pcall(require,'__debugadapter__/debugadapter.lua')

GUI = GUI or {}
UpSys = UpSys or {}
Event = Event or {}

require("utils/profiler.lua")
require("utils/settings.lua")
require("__MF_Base__/scripts/Util.lua")
require("__MF_Base__/scripts/GUI-API.lua")
require("__MF_Base__/scripts/Energy-Interface.lua")
require("utils/surface.lua")
require("utils/cc-extension.lua")
require("utils/remote.lua")
require("scripts/GUI/gui.lua")
require("scripts/game-update.lua")
require("scripts/events.lua")
require("scripts/objects/mobile-factory.lua")
require("scripts/objects/ore-cleaner.lua")
require("scripts/objects/fluid-extractor.lua")
require("scripts/objects/data-network.lua")
require("scripts/objects/network-controller.lua")
require("scripts/objects/network-access-point.lua")
require("scripts/objects/data-storage.lua")
require("scripts/objects/matter-interactor.lua")
require("scripts/objects/fluid-interactor.lua")
require("scripts/objects/data-assembler.lua")
require("scripts/objects/network-explorer.lua")
require("scripts/objects/internal-inventory.lua")
require("scripts/objects/internal-energy.lua")
require("scripts/objects/internal-quatron.lua")
require("scripts/objects/jump-drive.lua")
require("scripts/objects/jump-charger.lua")
require("scripts/objects/energy-cube.lua")
require("scripts/objects/energy-laser.lua")
require("scripts/objects/quatron-cube.lua")
require("scripts/objects/quatron-laser.lua")
require("scripts/objects/quatron-reactor.lua")
require("scripts/objects/deep-storage.lua")
require("scripts/objects/deep-tank.lua")
require("scripts/objects/MFPlayer.lua")
require("scripts/objects/resource-catcher.lua")
require("scripts/objects/energy-dispenser.lua")

-- When the mod init --
function onInit()

	-- Check if mod being initialized for the very first time
	-- This *need* to be at the very begginng of on_init callback
	global.allowMigration = ( next(global) ~= nil )

	-- Update System --
	global.entsTable = global.entsTable or {}
	global.upsysTickTable = global.upsysTickTable or {}
	global.entsUpPerTick = global.entsUpPerTick or _mfBaseUpdatePerTick
	global.upSysLastScan = global.upSysLastScan or 0
	-- Performance
	global.useVanillaChooseElem = global.useVanillaChooseElem or false
	-- Data Network --
	global.dataNetworkID = global.dataNetworkID or 0
	global.dataAssemblerBlacklist = global.dataAssemblerBlacklist or {}
	-- Floor Is Lava --
	global.floorIsLavaActivated = global.floorIsLavaActivated or false
	-- Research --
	for _, force in pairs(game.forces) do
		if settings.startup["MF-initial-research-complete"] and settings.startup["MF-initial-research-complete"].value == true then
			force.technologies["DimensionalOre"].researched = true
		end
	end

	-- Create the Objects Table --
	createTableList()
	-- Migrate all Objects --
	for _, obj in pairs(global.objTable) do
		if obj.tableName and obj.tag then
			if _G[obj.tag].refresh then
				for _, entry in pairs(global[obj.tableName]) do
					entry:refresh()
				end
			end
			if _G[obj.tag].validate then
				for _, entry in pairs(global[obj.tableName]) do
					entry:validate()
				end
			end
		end
	end

	-- global.syncTile = global.syncTile or "dirt-7"
	-- Validate the Tile Used for the Sync Area --
	-- validateSyncAreaTile()
	-- Ensure All Needed Tiles are Present --
	checkNeededTiles()
	createProductsList()

	-- Remove Existing Render Objects --
	rendering.clear("Mobile_Factory")

	-- Create all MFPlayers if needed --
	if global.playersTable == nil then global.playersTable = {} end
	for _, player in pairs(game.players) do
		Event.initPlayer({player_index = player.index})
	end

	-- Recreate GUIs --
	for _, MFPlayer in pairs(global.playersTable or {}) do
		if MFPlayer.ent ~= nil and MFPlayer.ent.valid == true then
			GUI.createMFMainGUI(MFPlayer.ent)
		else
			--destroy the gui object properly
		end
	end

	-- Validate MF Fuel --
	global.MFFuel = nil
	local expectedFuels = _MFVehicleFuelsByName
	local baseMF = game.entity_prototypes["MobileFactory"]
	for fuelName in pairs(expectedFuels) do
		local fuel = game.item_prototypes[fuelName]
		if fuel ~= nil
			and fuel.fuel_value and fuel.fuel_value > 0
			and baseMF ~= nil and baseMF.burner_prototype ~= nil
			and baseMF.burner_prototype.fuel_categories[fuel.fuel_category]
		then
			global.MFFuel = fuel
			_MFVehicleFuelPrototype = fuel
		end
	end
end

function onLoad(event)
	-- Rebuild all Objects --
	for _, obj in pairs(global.objTable) do
		if obj.tableName ~= nil and obj.tag ~= nil and _G[obj.tag] ~= nil then
			for _, entry in pairs(global[obj.tableName] or {}) do
				_G[obj.tag]:rebuild(entry)
			end
		end
	end
	_MFVehicleFuelPrototype = global.MFFuel
end

-- Filters --
_mfEntityFilter = {
	{filter = "type", type = "unit", invert = true},
	{filter = "type", type = "tree", mode = "and", invert = true},
	{filter = "type", type = "simple-entity", mode = "and", invert = true},
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
	{filter = "type", type = "fish", mode = "and", invert = true}
}

-- When a player join the game --
function initAPlayer(event)
	if mfCall(Event.initPlayer, event) == true then
		if event.player_index ~= nil and game.players[event.player_index] ~= nil and game.players[event.player_index].name ~= nil then
			game.print({"gui-description.initAPlayer_PlayerInitFailed", game.players[event.player_index].name})
		else
			game.print({"gui-description.initAPlayer_PlayerInitFailed", {"gui-description.Unknow"}})
		end
	end
end

-- If player entered or living a vehicle --
function onPlayerDriveStatChange(event)
	mfCall(Event.playerDriveStatChange, event)
end

-- On every Tick --
function onTick(event)
	mfCall(Event.tick, event)
end

-- Watch damages --
function onEntityDamaged(event)
	mfCall(Event.entityDamaged, event)
end

-- Called when something is placed --
function whenSomethingWasPlaced(event)
	if mfCall(Event.somethingWasPlaced, event) == true then
		game.print({"gui-description.whenSomethingWasPlaced_Failed"})
		local entity = event.created_entity or event.entity or event.destination
		if entity ~= nil and entity.valid == true then
			entity.destroy()
		end
	end
end

-- When something is cloned --
function whenSomethingWasCloned(event)
	mfCall(Event.somethingWasCloned, event)
end

-- When something is removed or destroyed --
function whenSomethingWasRemoved(event)
	mfCall(Event.somethingWasRemoved, event)
end

-- Called after an Entity die --
function onGhostPlacedByDie(event)
	if mfCall(Event.ghostPlacedByDie, event) == true then
		game.print({"gui-description.onGhostPlacedByDie_Failed"})
		if event.ghost ~= nil and event.ghost.valid == true then
			event.ghost.destroy()
		end
	end
end

-- Called when a GUI is Opened --
function onGuiOpened(event)
	mfCall(GUI.guiOpened, event)
end

-- A GUI was closed --
function onGuiClosed(event)
	mfCall(GUI.guiClosed, event)
end

-- When a GUI Button is clicked --
function onButtonClicked(event)
	if mfCall(GUI.buttonClicked, event) == true then
		getPlayer(event.player_index).print({"gui-description.updatingGUI_Failed"})
		mfCall(Event.clearGUI, event)
	end
end

-- When a GUI Element changed --
function onGuiElemChanged(event)
	if mfCall(GUI.onGuiElemChanged, event) == true then
		getPlayer(event.player_index).print({"gui-description.updatingGUI_Failed"})
		mfCall(Event.clearGUI, event)
	end
end

-- When a technology is finished --
function onTechnologyFinished(event)
	mfCall(Event.technologyFinished, event)
end

-- Called when a Player select an Entity --
function onSelectedEntityChanged(event)
	mfCall(Event.selectedEntityChanged, event)
end

-- Called when a Setting is pasted --
function onSettingsPasted(event)
	mfCall(Event.settingsPasted, event)
end

-- Called when a new Force is created --
function onForceCreated(event)
	mfCall(Event.forceCreated, event)
end

-- Called when a Player changed his team --
function onPlayerChangedForce(event)
	mfCall(Event.playerChangedForce, event)
end

-- Called when a Player settup a Blueprint --
function onPlayerSetupBlueprint(event)
	mfCall(Event.playerSetupBlueprint, event)
end

-- Called when a Localized Name is requested --
function onStringTranslated(event)
	mfCall(GUI.onStringTranslated, event)
end

-- Called when a Entity is rotated --
function onEntityRotated(event)
	mfCall(Event.entityRotated, event)
end

-- Called when a Shortcut is pressed --
function onShortcutPressed(event)
	mfCall(Event.onShortcut, event)
end

-- Called when the MFCleanGUI is sent --
function clearAllGUI(event)
	mfCall(Event.clearGUI, event)
end

-- Events --
script.on_init(onInit)
script.on_configuration_changed(onInit)
script.on_load(onLoad)
script.on_event(defines.events.on_cutscene_cancelled, initAPlayer)
script.on_event(defines.events.on_player_created, initAPlayer)
script.on_event(defines.events.on_player_joined_game, initAPlayer)
--script.on_event(defines.events.on_player_removed, RemoveAPlayer)
script.on_event(defines.events.on_player_driving_changed_state, onPlayerDriveStatChange)
script.on_event(defines.events.on_tick, onTick)
script.on_event(defines.events.on_entity_damaged, onEntityDamaged, _mfEntityFilterWithCBJ)
script.on_event(defines.events.on_built_entity, whenSomethingWasPlaced)
script.on_event(defines.events.on_player_built_tile, whenSomethingWasPlaced)
script.on_event(defines.events.script_raised_built, whenSomethingWasPlaced)
script.on_event(defines.events.script_raised_revive, whenSomethingWasPlaced)
script.on_event(defines.events.on_robot_built_entity, whenSomethingWasPlaced)
script.on_event(defines.events.on_robot_built_tile, whenSomethingWasPlaced)
script.on_event(defines.events.on_entity_cloned, whenSomethingWasCloned)
script.on_event(defines.events.on_player_mined_entity, whenSomethingWasRemoved)
script.on_event(defines.events.on_player_mined_tile, whenSomethingWasRemoved)
script.on_event(defines.events.on_robot_mined_entity, whenSomethingWasRemoved)
script.on_event(defines.events.on_robot_mined_tile, whenSomethingWasRemoved)
script.on_event(defines.events.script_raised_destroy, whenSomethingWasRemoved)
script.on_event(defines.events.on_entity_died, whenSomethingWasRemoved, _mfEntityFilter)
script.on_event(defines.events.on_post_entity_died, onGhostPlacedByDie, _mfEntityFilter)
script.on_event(defines.events.on_gui_opened, onGuiOpened)
script.on_event(defines.events.on_gui_closed, onGuiClosed)
script.on_event(defines.events.on_gui_click, onButtonClicked)
script.on_event(defines.events.on_gui_elem_changed, onGuiElemChanged)
script.on_event(defines.events.on_gui_checked_state_changed, onGuiElemChanged)
script.on_event(defines.events.on_gui_selection_state_changed, onGuiElemChanged)
script.on_event(defines.events.on_gui_text_changed, onGuiElemChanged)
script.on_event(defines.events.on_gui_switch_state_changed, onGuiElemChanged)
script.on_event(defines.events.on_gui_selected_tab_changed, onGuiElemChanged)
script.on_event(defines.events.on_research_finished, onTechnologyFinished)
script.on_event(defines.events.on_selected_entity_changed, onSelectedEntityChanged)
script.on_event(defines.events.on_entity_settings_pasted, onSettingsPasted)
script.on_event(defines.events.on_force_created, onForceCreated)
script.on_event(defines.events.on_player_changed_force, onPlayerChangedForce)
script.on_event(defines.events.on_player_setup_blueprint, onPlayerSetupBlueprint)
script.on_event(defines.events.on_string_translated, onStringTranslated)
script.on_event(defines.events.on_player_rotated_entity, onEntityRotated)
script.on_event("OpenTTGUI", onShortcutPressed)
script.on_event("CloseGUI", onShortcutPressed)

-- Add the Clean GUI Command --
commands.add_command("MFClearGUI", "Clean all Mobile Factory GUIs", clearAllGUI)

-- Debug Commands --
local addDebugCommands = true
if addDebugCommands == true then

end -- end addDebugCommands check