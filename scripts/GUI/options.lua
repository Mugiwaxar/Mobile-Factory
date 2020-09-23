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
	if name == "MainGuiDirectionSwitch" then
		GUIObj.MFPlayer.varTable.MainGUIDirection = option.switch_state
		GUI.createMFMainGUI(player)
	end

	if string.match(name, "MGS") then
		local buttonName = split(name, ",")[2]
		GUIObj.MFPlayer.varTable["Show" .. buttonName] = option.state
		GUI.updateMFMainGUI(MFPlayer.GUI["MFMainGUI"])
	end

	------------------- Game -------------------
	-- if name == "MiningJetDistanceOpt" then
	-- 	MF.varTable.jets.mjMaxDistance = tonumber(option.text)
	-- 	if MF.varTable.jets.mjMaxDistance == nil or MF.varTable.jets.mjMaxDistance <= 10 or MF.varTable.jets.mjMaxDistance > 1000 then
	-- 		--option.text = tostring(_MFMiningJetDefaultMaxDistance)
	-- 		MF.varTable.jets.mjMaxDistance = _MFMiningJetDefaultMaxDistance
	-- 	end
	-- end
	-- if name == "ConstructionJetDistanceOpt" then
	-- 	MF.varTable.jets.cjMaxDistance = tonumber(option.text)
	-- 	if MF.varTable.jets.cjMaxDistance == nil or MF.varTable.jets.cjMaxDistance <= 10 or MF.varTable.jets.cjMaxDistance > 1000 then
	-- 		--option.text = tostring(_MFConstructionJetDefaultMaxDistance)
	-- 		MF.varTable.jets.cjMaxDistance = _MFConstructionJetDefaultMaxDistance
	-- 	end
	-- end
	-- if name == "RepairJetDistanceOpt" then
	-- 	MF.varTable.jets.rjMaxDistance = tonumber(option.text)
	-- 	if MF.varTable.jets.rjMaxDistance == nil or MF.varTable.jets.rjMaxDistance <= 10 or MF.varTable.jets.rjMaxDistance > 1000 then
	-- 		--option.text = tostring(_MFRepairJetDefaultMaxDistance)
	-- 		MF.varTable.jets.rjMaxDistance = _MFRepairJetDefaultMaxDistance
	-- 	end
	-- end
	-- if name == "CombatJetDistanceOpt" then
	-- 	MF.varTable.jets.cbjMaxDistance = tonumber(option.text)
	-- 	if MF.varTable.jets.cbjMaxDistance == nil or MF.varTable.jets.cbjMaxDistance <= 10 or MF.varTable.jets.cbjMaxDistance > 1000 then
	-- 		--option.text = tostring(_MFCombatJetDefaultMaxDistance)
	-- 		MF.varTable.jets.cbjMaxDistance = _MFCombatJetDefaultMaxDistance
	-- 	end
	-- end
	-- if name == "ConstructionJetTableSizeOpt" then
	-- 	MF.varTable.jets.cjTableSize = tonumber(option.text)
	-- 	if MF.varTable.jets.cjTableSize == nil or MF.varTable.jets.cjTableSize < 1000 or MF.varTable.jets.cjTableSize > 25000 then
	-- 		MF.varTable.jets.cjTableSize = _MFConstructionJetDefaultTableSize
	-- 	end
	-- end
	if name == "FloorIsLavaOpt" then
		global.floorIsLavaActivated = option.state
		if global.floorIsLavaActivated == true then
			game.print({"gui-description.FloorIsLavaActivated"})
		else
			game.print({"gui-description.FloorIsLavaDeactivated"})
		end
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

	------------------- Update the Option GUI -------------------
	if GUIObj ~= nil and GUIObj.gui ~= nil and GUIObj.gui.valid == true and option.type ~= "textfield" and option.type ~= "drop-down" then
		GUI.updateOptionGUI(GUIObj)
	end
end