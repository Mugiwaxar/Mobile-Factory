-- Read changed Options from the Options GUI --
function GUI.readOptions(option, player)

	-- Get all needed variables --
	local playerIndex = player.index
	local MFPlayer = getMFPlayer(playerIndex)
	local name = option.name
	local MF = getMF(player.name)
	local GUITable = MFPlayer.GUI["MFOptionGUI"]

	------------------- MF -------------------
	if name == "Opt.GUI.AddAllowedPlayer" then
		local selectedPlayer = GUITable.vars.AllowedPlayersDD.items[GUITable.vars.AllowedPlayersDD.selected_index]
		if selectedPlayer == nil or game.players[selectedPlayer] == nil then return end
		MF.varTable.allowedPlayers[game.players[selectedPlayer].index] = true
	end

	if name == "Opt.GUI.RemoveAllowedPlayer" then
		local selectedPlayer = GUITable.vars.AllowedPlayersDD.items[GUITable.vars.AllowedPlayersDD.selected_index]
		if selectedPlayer == nil or game.players[selectedPlayer] == nil then return end
		MF.varTable.allowedPlayers[game.players[selectedPlayer].index] = false
	end

	------------------- GUI -------------------

	if string.match(name, "Opt.GUI.MainGUIButtonsVisible") then
		local buttonName = option.tags.name
		GUITable.MFPlayer.varTable["Show" .. buttonName] = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "Opt.GUI.MainButtonsSize") then
		local size = option.selected_index
		GUITable.MFPlayer.varTable.MainButtonsSize = size
		GUI.createMFMainGUI(MFPlayer.ent)
	end

	if string.match(name, "Opt.GUI.MainGUIButtonsPerLine") then
		local size = option.selected_index
		GUITable.MFPlayer.varTable.mainGUIButtonsPerLine = size
		GUI.createMFMainGUI(MFPlayer.ent)
	end

	if string.match(name, "Opt.GUI.MainGUIShowPositions") then
		GUITable.MFPlayer.varTable.MainGUIShowPositions = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "Opt.GUI.MainGUIShowTime") then
		GUITable.MFPlayer.varTable.MainGUIShowTime = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "Opt.GUI.MainGUIShowTemperature") then
		GUITable.MFPlayer.varTable.MainGUIShowTemperature = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "Opt.GUI.MainGUIShowHealthBar") then
		GUITable.MFPlayer.varTable.MainGUIShowHealthBar = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "Opt.GUI.MainGUIShowShieldBar") then
		GUITable.MFPlayer.varTable.MainGUIShowShieldBar = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "Opt.GUI.MainGUIShowEnergyBar") then
		GUITable.MFPlayer.varTable.MainGUIShowEnergyBar = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "Opt.GUI.MainGUIShowQuatronBar") then
		GUITable.MFPlayer.varTable.MainGUIShowQuatronBar = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "Opt.GUI.MainGUIShowJumpCharge") then
		GUITable.MFPlayer.varTable.MainGUIShowJumpCharge = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	------------------- Game -------------------
	if name == "Opt.GUI.FloorIsLavaOpt" then
		global.floorIsLavaActivated = option.state
		if global.floorIsLavaActivated == true then
			game.print({"gui-description.FloorIsLavaActivated"})
		else
			game.print({"gui-description.FloorIsLavaDeactivated"})
		end
	end

	if name == "Opt.GUI.AddDARecipeToBlackList" then
		local selectedCategory = GUITable.vars.blacklistDAList.items[GUITable.vars.blacklistDAList.selected_index]
		if selectedCategory == nil then return end
		global.dataAssemblerBlacklist[selectedCategory] = true
	end
	if name == "Opt.GUI.RemoveDARecipeFromBlackList" then
		local selectedCategory = GUITable.vars.blacklistDAList.items[GUITable.vars.blacklistDAList.selected_index]
		if selectedCategory == nil then return end
		global.dataAssemblerBlacklist[selectedCategory] = nil
	end

	------------------- Performances -------------------
	if name == "Opt.GUI.UpdatePerTickOpt" then
		local number = tonumber(option.text)
		if number == nil then return end
		number = math.max(number, 10)
		number = math.min(number, 10000)
		global.entsUpPerTick = number
		game.print({"", {"gui-description.EntitiesUpdatePerTickNumber"}, " ", number})
	end

	if name == "Opt.GUI.UseVanillaRecipeSelector" then
		global.useVanillaChooseElem = option.state
	end

	------------------- Update the Option GUI -------------------
	if GUITable ~= nil and GUITable.gui ~= nil and GUITable.gui.valid == true and option.type ~= "textfield" and option.type ~= "drop-down" then
		GUI.updateOptionGUI(GUITable)
	end

end