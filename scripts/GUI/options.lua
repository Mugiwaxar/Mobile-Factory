-- Read changed Options from the Options GUI --
function GUI.readOptions(option, player)
	
	-- Get all needed variables --
	local playerIndex = player.index
	local MFPlayer = getMFPlayer(playerIndex)
	local name = option.name
	local MF = getMF(player.name)
	local GUITable = MFPlayer.GUI["MFOptionGUI"]

	------------------- MF -------------------
	if name == "AddAllowedPlayerButton" then
		local selectedPlayer = GUITable.vars.AllowedPlayersDD.items[GUITable.vars.AllowedPlayersDD.selected_index]
		if selectedPlayer == nil or game.players[selectedPlayer] == nil then return end
		MF.varTable.allowedPlayers[game.players[selectedPlayer].index] = true
	end
	if name == "RemoveAllowedPlayerButton" then
		local selectedPlayer = GUITable.vars.AllowedPlayersDD.items[GUITable.vars.AllowedPlayersDD.selected_index]
		if selectedPlayer == nil or game.players[selectedPlayer] == nil then return end
		MF.varTable.allowedPlayers[game.players[selectedPlayer].index] = false
	end

	------------------- GUI -------------------

	if string.match(name, "MGS") then
		local buttonName = option.tags.name
		GUITable.MFPlayer.varTable["Show" .. buttonName] = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainButtonsSize") then
		local size = option.selected_index
		GUITable.MFPlayer.varTable.MainButtonsSize = size
		GUI.createMFMainGUI(MFPlayer.ent)
	end

	if string.match(name, "MainGUIButtonsPerLine") then
		local size = option.selected_index
		GUITable.MFPlayer.varTable.mainGUIButtonsPerLine = size
		GUI.createMFMainGUI(MFPlayer.ent)
	end

	if string.match(name, "MainGUIShowPositions") then
		GUITable.MFPlayer.varTable.MainGUIShowPositions = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainGUIShowTime") then
		GUITable.MFPlayer.varTable.MainGUIShowTime = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end
	
	if string.match(name, "MainGUIShowTemperature") then
		GUITable.MFPlayer.varTable.MainGUIShowTemperature = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainGUIShowHealthBar") then
		GUITable.MFPlayer.varTable.MainGUIShowHealthBar = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainGUIShowShieldBar") then
		GUITable.MFPlayer.varTable.MainGUIShowShieldBar = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainGUIShowEnergyBar") then
		GUITable.MFPlayer.varTable.MainGUIShowEnergyBar = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainGUIShowQuatronBar") then
		GUITable.MFPlayer.varTable.MainGUIShowQuatronBar = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainGUIShowJumpCharge") then
		GUITable.MFPlayer.varTable.MainGUIShowJumpCharge = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end
	
	------------------- Game -------------------
	if name == "FloorIsLavaOpt" then
		global.floorIsLavaActivated = option.state
		if global.floorIsLavaActivated == true then
			game.print({"gui-description.FloorIsLavaActivated"})
		else
			game.print({"gui-description.FloorIsLavaDeactivated"})
		end
	end

	if name == "blacklistDAAdd" then
		local selectedCategory = GUITable.vars.blacklistDAList.items[GUITable.vars.blacklistDAList.selected_index]
		if selectedCategory == nil then return end
		global.dataAssemblerBlacklist[selectedCategory] = true
	end
	if name == "blacklistDARem" then
		local selectedCategory = GUITable.vars.blacklistDAList.items[GUITable.vars.blacklistDAList.selected_index]
		if selectedCategory == nil then return end
		global.dataAssemblerBlacklist[selectedCategory] = nil
	end

	------------------- Performances -------------------
	if name == "UpdatePerTickOpt" then
		local number = tonumber(option.text)
		if number == nil then return end
		number = math.max(number, 10)
		number = math.min(number, 10000)
		global.entsUpPerTick = number
		game.print({"", {"gui-description.EntitiesUpdatePerTickNumber"}, " ", number})
	end

	if name == "useVanillaChooseElem" then
		global.useVanillaChooseElem = option.state
	end

	------------------- Update the Option GUI -------------------
	if GUITable ~= nil and GUITable.gui ~= nil and GUITable.gui.valid == true and option.type ~= "textfield" and option.type ~= "drop-down" then
		GUI.updateOptionGUI(GUITable)
	end
end