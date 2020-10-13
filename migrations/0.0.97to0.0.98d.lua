if global.allowMigration == false then return end
-- Set all Mobile Factory Objects to belongs to the first Player --
local player = nil
global.MFTable = {}
if global.MF == nil or global.MF == {} then goto continue end
if global.MF ~= nil and global.MF.II ~= nil then
	global.MF.II.MF = global.MF
	if global.MF.dataCenter ~= nil and global.MF.dataCenter.ent ~= nil and global.MF.dataCenter.ent.valid == true then
		if global.dataCenterTable == nil then global.dataCenterTable = {} end
		global.dataCenterTable[global.MF.dataCenter.ent.unit_number] = global.MF.dataCenter
	end
end
-- Try to find a player --
if global.MF.ent ~= nil and global.MF.ent.last_user ~= nil then player = global.MF.ent.last_user end
if player == nil then player = game.players[1] end
global.MF.player = player.name
global.MFTable[player.name] = global.MF
for k, obj in pairs(global.entsTable or {}) do
	if obj.ent ~= nil and obj.ent.valid == true and string.match(obj.ent.name, "MobileFactory") == nil then
		obj.player = player.name
		obj.MF = global.MF
	end
end


-- Set all Technology Variables --
global.MF.varTable = {}
global.MF.varTable.tech = {}
if technologyUnlocked("ControlCenter") == true then global.MF.varTable.tech.ControlCenter = true end
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
if global.tankTable ~= nil then
	if global.tankTable[1] ~= nil then global.MF.varTable.tanks[1] = Util.copyTable(global.tankTable[1]) end
	if global.tankTable[2] ~= nil then global.MF.varTable.tanks[2] = Util.copyTable(global.tankTable[2]) end
	if global.tankTable[3] ~= nil then global.MF.varTable.tanks[3] = Util.copyTable(global.tankTable[3]) end
	if global.tankTable[4] ~= nil then global.MF.varTable.tanks[4] = Util.copyTable(global.tankTable[4]) end
	if global.tankTable[5] ~= nil then global.MF.varTable.tanks[5] = Util.copyTable(global.tankTable[5]) end
end

::continue::
-- Remove old Variables and Tables --
global.MF = nil
global.tankTable = nil

-- Set the Mobile Factories Surfaces Name --
for k, MF in pairs(global.MFTable or {}) do
	if MF.player ~= nil and MF.player ~= "" and MF.fS ~= nil and MF.fS.valid == true then
		local newName = _mfSurfaceName .. MF.player
		if MF.fS.name ~= newName then MF.fS.name = newName end
	end
	if MF.player ~= nil and MF.player ~= "" and MF.ccS ~= nil and MF.ccS.valid == true then
		local newName = _mfControlSurfaceName .. MF.player
		if MF.ccS.name ~= newName then MF.ccS.name = _mfControlSurfaceName .. MF.player end
	end
end

-- Create all Players Object --
for k, player2 in pairs(game.players) do
	local playerTable = global.playersTable[player2.name]
	local MFPlayer = MFP:new(player2)
	MFPlayer.MF = getMF(player2.name)
	if playerTable ~= nil then MFPlayer.varTable = playerTable end
	global.playersTable[player2.name] = MFPlayer
	setPlayerVariable(player2.name, "GotInventory", true)
end

-- Set all Players Last Selected Entity to nil --
for k, player2 in pairs(global.playersTable or {}) do
	setPlayerVariable(k, "lastEntitySelected", nil)
end