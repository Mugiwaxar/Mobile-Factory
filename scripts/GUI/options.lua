-- Read changed Options from the Options GUI --
function GUI.readOptions(option, player)
	
	-- Get all needed variables --
	local playerIndex = player.index
	local MFPlayer = getMFPlayer(playerIndex)
	local name = option.name
	local MF = getMF(player.name)
	local GUIObj = MFPlayer.GUI["MFOptionGUI"]

	------------------- MF -------------------
	if name == "PermOtpAdd" then
		local selectedPlayer = GUIObj.POptPlayersList.items[GUIObj.POptPlayersList.selected_index]
		if selectedPlayer == nil or game.players[selectedPlayer] == nil then return end
		MF.varTable.allowedPlayers[game.players[selectedPlayer].index] = true
	end
	if name == "PermOtpRemove" then
		local selectedPlayer = GUIObj.POptPlayersList.items[GUIObj.POptPlayersList.selected_index]
		if selectedPlayer == nil or game.players[selectedPlayer] == nil then return end
		MF.varTable.allowedPlayers[game.players[selectedPlayer].index] = false
	end

	------------------- GUI -------------------

	if string.match(name, "MGS") then
		local buttonName = split(name, ",")[2]
		GUIObj.MFPlayer.varTable["Show" .. buttonName] = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainButtonsSize") then
		local size = option.selected_index
		GUIObj.MFPlayer.varTable.MainButtonsSize = size
		GUI.createMFMainGUI(MFPlayer.ent)
	end

	if string.match(name, "MainGUIShowPositions") then
		GUIObj.MFPlayer.varTable.MainGUIShowPositions = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainGUIShowTime") then
		GUIObj.MFPlayer.varTable.MainGUIShowTime = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end
	
	if string.match(name, "MainGUIShowTemperature") then
		GUIObj.MFPlayer.varTable.MainGUIShowTemperature = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainGUIShowHealthBar") then
		GUIObj.MFPlayer.varTable.MainGUIShowHealthBar = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainGUIShowShieldBar") then
		GUIObj.MFPlayer.varTable.MainGUIShowShieldBar = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainGUIShowEnergyBar") then
		GUIObj.MFPlayer.varTable.MainGUIShowEnergyBar = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainGUIShowQuatronBar") then
		GUIObj.MFPlayer.varTable.MainGUIShowQuatronBar = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	if string.match(name, "MainGUIShowJumpCharge") then
		GUIObj.MFPlayer.varTable.MainGUIShowJumpCharge = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end
	
	if name == "FloorIsLavaOpt" then
		global.floorIsLavaActivated = option.state
		if global.floorIsLavaActivated == true then
			game.print({"gui-description.FloorIsLavaActivated"})
		else
			game.print({"gui-description.FloorIsLavaDeactivated"})
		end
	end

	if name == "blacklistDAAdd" then
		local selectedCategory = GUIObj.blacklistDAList.items[GUIObj.blacklistDAList.selected_index]
		if selectedCategory == nil then return end
		global.dataAssemblerBlacklist[selectedCategory] = true
	end
	if name == "blacklistDARem" then
		local selectedCategory = GUIObj.blacklistDAList.items[GUIObj.blacklistDAList.selected_index]
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
	if GUIObj ~= nil and GUIObj.gui ~= nil and GUIObj.gui.valid == true and option.type ~= "textfield" and option.type ~= "drop-down" then
		GUI.updateOptionGUI(GUIObj)
	end
end