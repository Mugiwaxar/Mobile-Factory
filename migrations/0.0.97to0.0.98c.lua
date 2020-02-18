-- Set all Mobile Factory Objects to belongs to the first Player --
if global.MF == nil or global.MF == {} then goto continue end
global.MFTable = {}
if global.MF ~= nil and global.MF.II ~= nil then
	global.MF.II.MF = global.MF
	if global.MF.dataCenter ~= nil and global.MF.dataCenter.ent ~= nil and global.MF.dataCenter.ent.valid == true then
		if global.dataCenterTable == nil then global.dataCenterTable = {} end
		global.dataCenterTable[global.MF.dataCenter.ent.unit_number] = global.MF.dataCenter
	end
end
for name, j in pairs(global.playersTable or {}) do
	if name ~= nil then
		-- Register the Mobile Factory inside the MFTable --
		global.MF.player = name
		global.MFTable[name] = global.MF
		-- Register all Objects --
		for k, obj in pairs(global.entsTable or {}) do
			if obj.ent ~= nil and obj.ent.valid == true and string.match(obj.ent.name, "MobileFactory") == nil then
				obj.player = name
				obj.MF = global.MF
			end
		end
		break
	end
end

-- Set all Technology Variables --
global.MF.varTable = {}
global.MF.varTable.tech = {}
if technologyUnlocked("ControlCenter") == true then global.MF.varTable.tech.ControlCenter = true end
if technologyUnlocked("UpgradeModules") == true then global.MF.varTable.tech.UpgradeModules = true end
if technologyUnlocked("StorageTankMK1_1") == true then global.MF.varTable.tech.StorageTankMK11 = true end
if technologyUnlocked("StorageTankMK1_2") == true then global.MF.varTable.tech.StorageTankMK12 = true end
if technologyUnlocked("StorageTankMK1_3") == true then global.MF.varTable.tech.StorageTankMK13 = true end
if technologyUnlocked("StorageTankMK1_4") == true then global.MF.varTable.tech.StorageTankMK14 = true end
if technologyUnlocked("StorageTankMK1_5") == true then global.MF.varTable.tech.StorageTankMK15 = true end
if technologyUnlocked("StorageTankMK2_1") == true then global.MF.varTable.tech.StorageTankMK21 = true end
if technologyUnlocked("StorageTankMK2_2") == true then global.MF.varTable.tech.StorageTankMK22 = true end
if technologyUnlocked("StorageTankMK2_3") == true then global.MF.varTable.tech.StorageTankMK23 = true end
if technologyUnlocked("StorageTankMK2_4") == true then global.MF.varTable.tech.StorageTankMK24 = true end
if technologyUnlocked("StorageTankMK2_5") == true then global.MF.varTable.tech.StorageTankMK25 = true end
if technologyUnlocked("DeepStorage") == true then global.MF.varTable.tech.DeepStorage = true end
if technologyUnlocked("ConstructibleArea1") == true then global.MF.varTable.tech.ConstructibleArea1 = true end

-- Save all Dimensional Tank --
global.MF.varTable.tanks = {}
if global.tankTable[1] ~= nil then global.MF.varTable.tanks[1] = Util.copyTable(global.tankTable[1]) end
if global.tankTable[2] ~= nil then global.MF.varTable.tanks[2] = Util.copyTable(global.tankTable[2]) end
if global.tankTable[3] ~= nil then global.MF.varTable.tanks[3] = Util.copyTable(global.tankTable[3]) end
if global.tankTable[4] ~= nil then global.MF.varTable.tanks[4] = Util.copyTable(global.tankTable[4]) end
if global.tankTable[5] ~= nil then global.MF.varTable.tanks[5] = Util.copyTable(global.tankTable[5]) end

::continue::
-- Remove old Variables and Tables --
global.MF = nil
global.tankTable = nil

-- Set the Mobile Factories Surfaces Name --
for k, MF in pairs(global.MFTable or {}) do
	if MF.player ~= nil and MF.fS ~= nil and MF.fS.valid == true then
		MF.fS.name = _mfSurfaceName .. MF.player
	end
	if MF.player ~= nil and MF.ccS ~= nil and MF.ccS.valid == true then
		MF.ccS.name = _mfControlSurfaceName .. MF.player
	end
end

-- Set GotInventory Value --
for k, player in pairs(global.playersTable or {}) do
	player["GotInventory"] = true
end

-- Set Jets Max Distance --
for k, MF in pairs(global.MFTable or {}) do
	if MF.varTable.jets == nil then
		MF.varTable.jets = {}
		MF.varTable.jets.mjMaxDistance = global.mjMaxDistance or _MFMiningJetDefaultMaxDistance
		MF.varTable.jets.cjMaxDistance = global.cjMaxDistance or  _MFConstructionJetDefaultMaxDistance
		MF.varTable.jets.rjMaxDistance = global.rjMaxDistance or  _MFRepairJetDefaultMaxDistance
		MF.varTable.jets.cbjMaxDistance = global.cbjMaxDistance or  _MFCombatJetDefaultMaxDistance
	end
end

-- Remove old Jets Distances --
global.mjMaxDistance = nil
global.cjMaxDistance = nil
global.rjMaxDistance = nil
global.cbjMaxDistance = nil