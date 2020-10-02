for id, obj in pairs(global.deepStorageTable or {}) do
	obj.entID = id
end
for id, obj in pairs(global.deepTankTable or {}) do
	obj.entID = id
end
for id, obj in pairs(global.fluidExtractorTable or {}) do
	obj.entID = id
end
for id, obj in pairs(global.networkAccessPointTable or {}) do
	obj.entID = id
end
for id, obj in pairs(global.oreCleanerTable or {}) do
	obj.entID = id
end