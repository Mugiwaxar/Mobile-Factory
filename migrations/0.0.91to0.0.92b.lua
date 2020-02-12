-- Clear Data Network --
for k, DN in pairs(global.dataNetworkTable) do
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
for k, obj in pairs (global.matterSerializerTable) do
	if obj.ent ~= nil and obj.ent.valid == true then
		obj.entID = obj.ent.unit_number
	end
end
for k, obj in pairs (global.matterPrinterTable) do
	if obj.ent ~= nil and obj.ent.valid == true then
		obj.entID = obj.ent.unit_number
	end
end
for k, obj in pairs (global.dataStorageTable) do
	if obj.ent ~= nil and obj.ent.valid == true then
		obj.entID = obj.ent.unit_number
	end
end
for k, obj in pairs (global.wirelessDataTransmitterTable) do
	if obj.ent ~= nil and obj.ent.valid == true then
		obj.entID = obj.ent.unit_number
	end
end
for k, obj in pairs (global.wirelessDataReceiverTable) do
	if obj.ent ~= nil and obj.ent.valid == true then
		obj.entID = obj.ent.unit_number
	end
end
for k, obj in pairs (global.energyCubesTable) do
	if obj.ent ~= nil and obj.ent.valid == true then
		obj.entID = obj.ent.unit_number
	end
end