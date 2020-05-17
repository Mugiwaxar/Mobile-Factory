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
require("scripts/objects/ore-cleaner.lua")
require("scripts/objects/fluid-extractor.lua")
require("scripts/objects/inventory.lua")
require("scripts/objects/data-network.lua")
require("scripts/objects/data-center.lua")
require("scripts/objects/data-center-mf.lua")
require("scripts/objects/data-storage.lua")
require("scripts/objects/matter-interactor.lua")
require("scripts/objects/fluid-interactor.lua")
require("scripts/objects/data-assembler.lua")
require("scripts/objects/network-explorer.lua")
require("scripts/objects/wireless-data-transmitter.lua")
require("scripts/objects/wireless-data-receiver.lua")
require("scripts/objects/internal-energy.lua")
require("scripts/objects/internal-quatron.lua")
require("scripts/objects/energy-cube.lua")
require("scripts/objects/energy-laser.lua")
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
	global.entsTable = global.entsTable or {}
	global.upsysTickTable = global.upsysTickTable or {}
	global.entsUpPerTick = global.entsUpPerTick or _mfBaseUpdatePerTick
	global.upSysLastScan = global.upSysLastScan or 0
	-- Inventory --
	global.insertedMFInsideInventory = global.insertedMFInsideInventory or false
	-- Erya --
	global.updateEryaIndex = global.updateEryaIndex or 1
	-- Data Network --
	global.dataNetworkID = global.dataNetworkID or 0
	-- Construction Jet Update --
	global.constructionJetIndex = global.constructionJetIndex or 0
	-- Repair Jet Update --
	global.repairJetIndex = global.repairJetIndex or 0
	-- Floor Is Lava --
	global.floorIsLavaActivated = global.floorIsLavaActivated or false
	-- Research --
	for _, force in pairs(game.forces) do
		if settings.startup["MF-initial-research-complete"] and settings.startup["MF-initial-research-complete"].value == true then
			force.technologies["DimensionalOre"].researched = true
		end
	end

	-- Tables --
	global.dataNetworkTable = global.dataNetworkTable or {}
	global.dataNetworkIDGreenTable = global.dataNetworkIDGreenTable or {}
	global.dataNetworkIDRedTable = global.dataNetworkIDRedTable or {}
	global.constructionTable = global.constructionTable or {}
	global.repairTable = global.repairTable or {}
	global.eryaIndexedTable = global.eryaIndexedTable or {}

	-- Create the Objects Table --
	Util.createTableList()

	-- Rebuild all Objects --
	for k, obj in pairs(global.objTable) do
		if obj.tableName ~= nil and obj.tag ~= nil then
			--should validate that we are using the right table for the obj

			--these separate functions can be merged, eventually
			-- Rebuild and Refresh Objects so All Needed Values are Present --
			for objKey, entry in pairs(global[obj.tableName]) do
				if entry.invObj ~= nil and entry.invObj.isII ~= true then
					DC:rebuild(entry)
				else
					_G[obj.tag]:rebuild(entry)
				end

				if _G[obj.tag].refresh then
					_G[obj.tag].refresh(entry)
				end
			end
		end
	end

    global.syncTile = global.syncTile or "dirt-7"
	-- Validate the Tile Used for the Sync Area --
	validateSyncAreaTile()
	-- Ensure All Needed Tiles are Present --
	checkNeededTiles()

	-- Remove Existing Render Objects --
	rendering.clear("Mobile_Factory")

	-- Recreate GUIs --
	for k, player in pairs(game.players) do
		GUI.createMFMainGUI(player)
	end

	-- Debug --
	--[[
	for k, j in pairs(global) do
		if type(j) == "table" then
			dprint(k .. ":" .. table_size(j))
		else
			dprint(k)
		end
	end
	--]]

	-- Add Warptorio Compatibility --
	warptorio()
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
script.on_configuration_changed(onInit)
script.on_event(defines.events.on_player_created, initPlayer)
script.on_event(defines.events.on_player_joined_game, initPlayer)
script.on_event(defines.events.on_player_driving_changed_state, playerDriveStatChange)
script.on_event(defines.events.on_tick, onTick)
script.on_event(defines.events.on_entity_damaged, onEntityDamaged, _mfEntityFilterWithCBJ)
script.on_event(defines.events.on_built_entity, somethingWasPlaced)
script.on_event(defines.events.on_player_built_tile, somethingWasPlaced)
script.on_event(defines.events.script_raised_built, somethingWasPlaced)
script.on_event(defines.events.script_raised_revive, somethingWasPlaced)
script.on_event(defines.events.on_robot_built_entity, somethingWasPlaced)
script.on_event(defines.events.on_robot_built_tile, somethingWasPlaced)
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
script.on_event(defines.events.on_string_translated, onStringTranslated)
script.on_event("OpenTTGUI", onShortcut)

-- Add command to insert Mobile Factory to the player inventory --
-- commands.add_command("GetMobileFactory", "Add the Mobile Factory to the player inventory", addMobileFactory)
