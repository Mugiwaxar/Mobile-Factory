-- Read changed Options from the Options GUI --
function GUI.readOptions(option, player)
	local playerIndex = player.index

	local name = option.name

	-- Get the Mobile Factory and GUIObject --
	local MF = getMF(player.name)
	local GUIObj = global.GUITable["MFOptionGUI"..playerIndex]

	------------------- MF -------------------
	if name == "MFShareOpt" then
		MF.varTable.shareStructures = option.state
	end
	if name == "MFUseShareOpt" then
		MF.varTable.useSharedStructures = option.state
	end
	if name == "MFShareSettingOpt" then
		MF.varTable.allowToModify = option.state
	end

	------------------- GUI -------------------
	if name == "MainGuiDirectionSwitch" then
		GUIObj.MFplayer.varTable.MainGUIDirection = option.switch_state
		GUI.createMFMainGUI(player)
	end

	if string.match(name, "MGS") then
		local buttonName = split(name, ",")[2]
		GUIObj.MFplayer.varTable["Show" .. buttonName] = option.state
		GUI.updateMFMainGUI(global.GUITable["MFMainGUI"..playerIndex])
	end

	------------------- Game -------------------
	if name == "MiningJetDistanceOpt" then
		MF.varTable.jets.mjMaxDistance = tonumber(option.text)
		if MF.varTable.jets.mjMaxDistance == nil or MF.varTable.jets.mjMaxDistance <= 10 or MF.varTable.jets.mjMaxDistance > 1000 then
			--option.text = tostring(_MFMiningJetDefaultMaxDistance)
			MF.varTable.jets.mjMaxDistance = _MFMiningJetDefaultMaxDistance
		end
	end
	if name == "ConstructionJetDistanceOpt" then
		MF.varTable.jets.cjMaxDistance = tonumber(option.text)
		if MF.varTable.jets.cjMaxDistance == nil or MF.varTable.jets.cjMaxDistance <= 10 or MF.varTable.jets.cjMaxDistance > 1000 then
			--option.text = tostring(_MFConstructionJetDefaultMaxDistance)
			MF.varTable.jets.cjMaxDistance = _MFConstructionJetDefaultMaxDistance
		end
	end
	if name == "RepairJetDistanceOpt" then
		MF.varTable.jets.rjMaxDistance = tonumber(option.text)
		if MF.varTable.jets.rjMaxDistance == nil or MF.varTable.jets.rjMaxDistance <= 10 or MF.varTable.jets.rjMaxDistance > 1000 then
			--option.text = tostring(_MFRepairJetDefaultMaxDistance)
			MF.varTable.jets.rjMaxDistance = _MFRepairJetDefaultMaxDistance
		end
	end
	if name == "CombatJetDistanceOpt" then
		MF.varTable.jets.cbjMaxDistance = tonumber(option.text)
		if MF.varTable.jets.cbjMaxDistance == nil or MF.varTable.jets.cbjMaxDistance <= 10 or MF.varTable.jets.cbjMaxDistance > 1000 then
			--option.text = tostring(_MFCombatJetDefaultMaxDistance)
			MF.varTable.jets.cbjMaxDistance = _MFCombatJetDefaultMaxDistance
		end
	end
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
	if GUIObj ~= nil and GUIObj.gui ~= nil and GUIObj.gui.valid == true and option.type ~= "textfield" then
		GUI.updateOptionGUI(GUIObj)
	end
end