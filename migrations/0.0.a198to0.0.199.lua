for id, obj in pairs(global.networkAccessPointTable or {}) do
	obj.outOfQuatron = nil
end
for id, obj in pairs(global.quatronReactorTable or {}) do
	obj.quatronCharge = obj.internalQuatron
	obj.internalQuatron = nil
end
for id, obj in pairs(global.quatronLaserTable or {}) do
	if obj.ent and obj.ent.valid then
		obj.quatronCharge = obj.ent.energy
		obj.quatronMax = obj.ent.prototype.energy_usage
		obj.quatronMaxInput = obj.ent.prototype.energy_usage
		obj.quatronMaxOutput = obj.ent.prototype.energy_usage
	end
end
for id, obj in pairs(global.quatronCubesTable or {}) do
	if obj.ent and obj.ent.valid then
		obj.quatronCharge = obj.ent.energy
		obj.quatronMax = obj.ent.electric_buffer_size
		obj.quatronMaxInput = obj.ent.electric_buffer_size / 10
		obj.quatronMaxOutput = obj.ent.electric_buffer_size / 10
	end
end
for id, mf in pairs(global.MFTable or {}) do
	if mf.internalQuatronObj and mf.internalQuatronObj.ent and mf.internalQuatronObj.ent.valid then
		mf.internalQuatronObj.quatronCharge = mf.internalQuatronObj.ent.energy
		mf.internalQuatronObj.quatronMax = mf.internalQuatronObj.ent.electric_buffer_size
		mf.internalQuatronObj.quatronMaxInput = mf.internalQuatronObj.ent.electric_buffer_size / 10
		mf.internalQuatronObj.quatronMaxOutput = mf.internalQuatronObj.ent.electric_buffer_size / 10
	end
end
for id, obj in pairs(global.oreCleanerTable or {}) do
	obj.totalCharge = nil
	obj.quatronCharge = obj.charge
	obj.quatronLevel = obj.purity
end
for id, obj in pairs(global.fluidExtractorTable or {}) do
	obj.totalCharge = nil
	obj.quatronCharge = obj.charge
	obj.quatronLevel = obj.purity
end