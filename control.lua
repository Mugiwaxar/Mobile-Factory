pcall(require,'__debugadapter__/debugadapter.lua')

GUI = {}
Util = {}
UpSys = {}

require("utils/profiler.lua")
require("utils/settings.lua")
require("utils/functions.lua")
require("utils/surface.lua")
require("utils/cc-extension.lua")
require("utils/warptorio.lua")
require("utils/remote.lua")
require("scripts/GUI/gui.lua")
require("scripts/game-update.lua")
require("scripts/objects/mobile-factory.lua")
require("scripts/objects/gui-object.lua")
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

	-- Tables --
	global.constructionTable = global.constructionTable or {}
	global.repairTable = global.repairTable or {}
	-- global.eryaIndexedTable = global.eryaIndexedTable or {}

	-- Create the Objects Table --
	Util.createTableList()

	-- Rebuild all Objects --
	for k, obj in pairs(global.objTable) do
		if obj.tableName and obj.tag and _G[obj.tag].refresh then
			for objKey, entry in pairs(global[obj.tableName]) do
				_G[obj.tag]:refresh(entry)
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
	for k, MFPlayer in pairs(global.MFPlayer or {}) do
		GUI.createMFMainGUI(MFPlayer.ent)
	end

	-- Add Warptorio Compatibility --
	warptorio()
end

function onLoad(event)
	
	-- Rebuild all Objects --
	for k, obj in pairs(global.objTable) do
		if obj.tableName ~= nil and obj.tag ~= nil then
			for objKey, entry in pairs(global[obj.tableName] or {}) do
				if _G[obj.tag] ~= nil then
					_G[obj.tag]:rebuild(entry)
				end
			end
		end
	end

	-- Add Warptorio Compatibility --
	warptorio()

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

local function onForceCreated(event)
  local force = event.force

  if force.valid and settings.startup["MF-initial-research-complete"] and settings.startup["MF-initial-research-complete"].value == true then
    force.technologies["DimensionalOre"].researched = true
  end
end

local function onPlayerChangedForce(event)
	local player = getPlayer(event.player_index)
    if not (player and player.valid) then return end

    local MFPlayer = getMFPlayer(player.name)
    if not (MFPlayer and MFPlayer:valid()) then return end

    local MF = getMF(player.name)
    if not (MF and MF:valid()) then return end

    if MF.ent and MF.ent.valid then MF.ent.force = player.force end
    if MF.fS and MF.fS.valid then
      local oldForceEntities = MF.fS.find_entities_filtered{force = event.force}
      local newForce = player.force
      for _, ent in pairs(oldForceEntities) do
        ent.force = newForce
      end
    end

    if MF.ccS and MF.ccS.valid then
      local oldForceEntities = MF.ccS.find_entities_filtered{force = event.force}
      local newForce = player.force
      for _, ent in pairs(oldForceEntities) do
        ent.force = newForce 
      end
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

	for index, ent in pairs(mapping) do
		local saveTable = _mfTooltipGUI[ent.name]
		if ent.valid == true and saveTable ~= nil then
			if global[saveTable] == nil then
				-- Create Table If Nothing Was Ever Placed --
				global[saveTable] = {}
			end
			saveTable = global[saveTable]
			local tags = entityToBlueprintTags(ent, saveTable)
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
script.on_load(onLoad)
script.on_event(defines.events.on_cutscene_cancelled, initPlayer)
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
script.on_event(defines.events.on_entity_cloned, somethingWasPlaced)
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
script.on_event(defines.events.on_player_changed_force, onPlayerChangedForce)
script.on_event(defines.events.on_player_setup_blueprint, onPlayerSetupBlueprint)
script.on_event(defines.events.on_string_translated, onStringTranslated)
script.on_event("OpenTTGUI", onShortcut)

-- Add command to insert Mobile Factory to the player inventory --
-- commands.add_command("GetMobileFactory", "Add the Mobile Factory to the player inventory", addMobileFactory)

-- Debug Commands --
local addDebugCommands = true
if addDebugCommands == true then
local function MFResetGUIs(event)
	for playerIndex, player in pairs(game.players) do
		local logString = "\n"
		logString = logString.."Checking player: "..player.name
		if player.connected == true then
			logString = logString.."\nPlayer is connected."
		else
			logString = logString.."\nPlayer is not connected."
		end

		local MFPlayer = getMFPlayer(playerIndex)
		if MFPlayer ~= nil then
			logString = logString.."\nPlayer has an MFPlayer"
			local MFGui = MFPlayer.GUI["MFMainGUI"]
			if MFGui ~= nil then
				logString = logString.."\nMFMainGUI exists, attempting to destroy and recreate."
				MFGui.destroy()
			else
				logString = logString.."\nMFMainGUI does not exist, attempting to recreate."
			end
			GUI.createMFMainGUI(player)
		else
			logString = logString.."\nPlayer does not have an MFPlayer."			
		end
	end
	log(logString)
end
commands.add_command("MF_reset_guis", "reset the GUIS for Mobile Factory players", MFResetGUIs)

end -- end addDebugCommands check