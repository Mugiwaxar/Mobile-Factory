if not global.allowMigration then return end
-- Clear Data Network --
for k, DN in pairs(global.dataNetworkTable or {}) do
	DN.GCNTable = nil
	DN.RCNTable = nil
	DN.entitiesTable = {}
	DN.wirelessReceiverTable = {}
	DN.energyCubeTable = {}
	DN.dataStorageTable = {}
	if DN.dataCenter ~= nil and DN.dataCenter.ent ~= nil and DN.dataCenter.ent.valid == true then
		DN.entitiesTable[DN.dataCenter.ent.unit_number] = DN.dataCenter
	end
end

-- Set Entities ID --
for k, obj in pairs (global.matterSerializerTable or {}) do
	if obj.ent ~= nil and obj.ent.valid == true then
		obj.entID = obj.ent.unit_number
	end
end
for k, obj in pairs (global.matterPrinterTable or {}) do
	if obj.ent ~= nil and obj.ent.valid == true then
		obj.entID = obj.ent.unit_number
	end
end
for k, obj in pairs (global.dataStorageTable or {}) do
	if obj.ent ~= nil and obj.ent.valid == true then
		obj.entID = obj.ent.unit_number
	end
end
for k, obj in pairs (global.wirelessDataTransmitterTable or {}) do
	if obj.ent ~= nil and obj.ent.valid == true then
		obj.entID = obj.ent.unit_number
	end
end
for k, obj in pairs (global.wirelessDataReceiverTable or {}) do
	if obj.ent ~= nil and obj.ent.valid == true then
		obj.entID = obj.ent.unit_number
	end
end
for k, obj in pairs (global.energyCubesTable or {}) do
	if obj.ent ~= nil and obj.ent.valid == true then
		obj.entID = obj.ent.unit_number
	end
end