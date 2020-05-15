
-- Apply Settings Stored in Ghost Tags --
function objApplyTags(obj, tags)
	if tags and valid(obj) and obj.tagsToSettings then
		obj:tagsToSettings(tags)
	end
end

-- Save the Matter Interactor in a table --
function placedMatterInteractor(event)
	if global.matterInteractorTable == nil then global.matterInteractorTable = {} end
	local newMI = MI:new(event.created_entity)
	global.matterInteractorTable[event.created_entity.unit_number] = newMI
	objApplyTags(newMI, event.tags)
end

-- Save the Fluid Interactor in a table --
function placedFluidInteractor(event)
	if global.fluidInteractorTable == nil then global.fluidInteractorTable = {} end
	local newFI = FI:new(event.created_entity)
	global.fluidInteractorTable[event.created_entity.unit_number] = newFI
	objApplyTags(newFI, event.tags)
end

-- Save the Data Assembler in a table --
function placedDataAssembler(event)
	if global.dataAssemblerTable == nil then global.dataAssemblerTable = {} end
	global.dataAssemblerTable[event.created_entity.unit_number] = DA:new(event.created_entity)
end

-- Save the Network Explorer in a table --
function placedNetworkExplorer(event)
	if global.networkExplorerTable == nil then global.networkExplorerTable = {} end
	global.networkExplorerTable[event.created_entity.unit_number] = NE:new(event.created_entity)
end

-- Save the Data Center in a table --
function placedDataCenter(event)
	if global.dataCenterTable == nil then global.dataCenterTable = {} end
	global.dataCenterTable[event.created_entity.unit_number] = DC:new(event.created_entity)
end

-- Save the Data Center MF --
function placedDataCenterMF(event, MF)
	if global.dataCenterTable == nil then global.dataCenterTable = {} end
	global.dataCenterTable[event.created_entity.unit_number] = DCMF:new(event.created_entity)
	if MF ~= nil then MF.dataCenter = global.dataCenterTable[event.created_entity.unit_number] end
end

-- Save the Data Storage in a table --
function placedDataStorage(event)
	if global.dataStorageTable == nil then global.dataStorageTable = {} end
	global.dataStorageTable[event.created_entity.unit_number] = DS:new(event.created_entity)
end

-- Save the Wireless Data Transmitter in a table --
function placedWirelessDataTransmitter(event)
	if global.wirelessDataTransmitterTable == nil then global.wirelessDataTransmitterTable = {} end
	global.wirelessDataTransmitterTable[event.created_entity.unit_number] = WDT:new(event.created_entity)
end

-- Save the Wireless Data Receiver in a table --
function placedWirelessDataReceiver(event)
	if global.wirelessDataReceiverTable == nil then global.wirelessDataReceiverTable = {} end
	global.wirelessDataReceiverTable[event.created_entity.unit_number] = WDR:new(event.created_entity)
end

-- Save the Energy Cube in a table --
function placedEnergyCube(event)
	if global.energyCubesTable == nil then global.energyCubesTable = {} end
	global.energyCubesTable[event.created_entity.unit_number] = EC:new(event.created_entity)
end

-- Save the Energy Laser in a table --
function placedEnergyLaser(event)
	if global.energyLaserTable == nil then global.energyLaserTable = {} end
	global.energyLaserTable[event.created_entity.unit_number] = EL:new(event.created_entity)
end

-- Save the Ore Cleaner --
function placedOreCleaner(event)
	if global.oreCleanerTable == nil then global.oreCleanerTable = {} end
	global.oreCleanerTable[event.created_entity.unit_number] = OC:new(event.created_entity)
end

-- Save the Fluid Extractor --
function placedFluidExtractor(event)
	if global.fluidExtractorTable == nil then global.fluidExtractorTable = {} end
	global.fluidExtractorTable[event.created_entity.unit_number] = FE:new(event.created_entity)
end

-- Save the Jet Flag --
function placedJetFlag(event)
	if global.jetFlagTable == nil then global.jetFlagTable = {} end
	global.jetFlagTable[event.created_entity.unit_number] = MJF:new(event.created_entity)
end

-- Save the Deep Storage --
function placedDeepStorage(event)
	if global.deepStorageTable == nil then global.deepStorageTable = {} end
	local newDSR = DSR:new(event.created_entity)
	global.deepStorageTable[event.created_entity.unit_number] = newDSR
	objApplyTags(newDSR, event.tags)
end

-- Save the Deep Tank --
function placedDeepTank(event)
	if global.deepTankTable == nil then global.deepTankTable = {} end
	local newDTK = DTK:new(event.created_entity)
	global.deepTankTable[event.created_entity.unit_number] = newDTK
	objApplyTags(newDTK, event.tags)
end

-- Save the Erya Structure --
function placedEryaStructure(event)
	if global.eryaTable == nil then global.eryaTable  = {} end
	global.eryaTable[event.created_entity.unit_number] = ES:new(event.created_entity)
end

-- Remove the Matter Interactor from the table --
function removedMatterInteractor(event)
	if global.matterInteractorTable == nil then global.matterInteractorTable = {} return end
	if global.matterInteractorTable[event.entity.unit_number] ~= nil then global.matterInteractorTable[event.entity.unit_number]:remove() end
	global.matterInteractorTable[event.entity.unit_number] = nil
end

-- Remove the Fluid Interactor from the table --
function removedFluidInteractor(event)
	if global.fluidInteractorTable == nil then global.fluidInteractorTable = {} return end
	if global.fluidInteractorTable[event.entity.unit_number] ~= nil then global.fluidInteractorTable[event.entity.unit_number]:remove() end
	global.fluidInteractorTable[event.entity.unit_number] = nil
end

-- Remove the Data Assembler from the table --
function removedDataAssembler(event)
	if global.dataAssemblerTable == nil then global.dataAssemblerTable = {} return end
	if global.dataAssemblerTable[event.entity.unit_number] ~= nil then global.dataAssemblerTable[event.entity.unit_number]:remove() end
	global.dataAssemblerTable[event.entity.unit_number] = nil
end

-- Remove the Network Explorer from the table --
function removedNetworkExplorer(event)
	if global.networkExplorerTable == nil then global.networkExplorerTable = {} return end
	if global.networkExplorerTable[event.entity.unit_number] ~= nil then global.networkExplorerTable[event.entity.unit_number]:remove() end
	global.networkExplorerTable[event.entity.unit_number] = nil
end

-- Remove the Data Center from the table --
function removedDataCenter(event)
	if global.dataCenterTable == nil then global.dataCenterTable = {} return end
	if global.dataCenterTable[event.entity.unit_number] ~= nil then global.dataCenterTable[event.entity.unit_number]:remove() end
	global.dataCenterTable[event.entity.unit_number] = nil
end

-- Remove the Data Center MF from the table --
function removedDataCenterMF(event)
	if global.dataCenterTable == nil then global.dataCenterTable = {} return end
	if global.dataCenterTable[event.entity.unit_number] ~= nil then global.dataCenterTable[event.entity.unit_number]:remove() end
	global.dataCenterTable[event.entity.unit_number] = nil
end

-- Remove the Data Storage from the table --
function removedDataStorage(event)
	if global.dataStorageTable == nil then global.dataStorageTable = {} return end
	if global.dataStorageTable[event.entity.unit_number] ~= nil then global.dataStorageTable[event.entity.unit_number]:remove() end
	global.dataStorageTable[event.entity.unit_number] = nil
end

-- Remove the Wireless Data Transmitter from the table --
function removedWirelessDataTransmitter(event)
	if global.wirelessDataTransmitterTable == nil then global.wirelessDataTransmitterTable = {} return end
	if global.wirelessDataTransmitterTable[event.entity.unit_number] ~= nil then global.wirelessDataTransmitterTable[event.entity.unit_number]:remove() end
	global.wirelessDataTransmitterTable[event.entity.unit_number] = nil
end

-- Remove the Wireless Data Receiver from the table --
function removedWirelessDataReceiver(event)
	if global.wirelessDataReceiverTable == nil then global.wirelessDataReceiverTable = {} return end
	if global.wirelessDataReceiverTable[event.entity.unit_number] ~= nil then global.wirelessDataReceiverTable[event.entity.unit_number]:remove() end
	global.wirelessDataReceiverTable[event.entity.unit_number] = nil
end

-- Remove the Energy Cube from the table --
function removedEnergyCube(event)
	if global.energyCubesTable == nil then global.energyCubesTable = {} return end
	if global.energyCubesTable[event.entity.unit_number] ~= nil then global.energyCubesTable[event.entity.unit_number]:remove() end
	global.energyCubesTable[event.entity.unit_number] = nil
end

-- Remove the Energy Laser from the table --
function removedEnergyLaser(event)
	if global.energyLaserTable == nil then global.energyLaserTable = {} return end
	if global.energyLaserTable[event.entity.unit_number] ~= nil then global.energyLaserTable[event.entity.unit_number]:remove() end
	global.energyLaserTable[event.entity.unit_number] = nil
end

-- Remove the Ore Cleaner from the table --
function removedOreCleaner(event)
	if global.oreCleanerTable == nil then global.oreCleanerTable = {} return end
	if global.oreCleanerTable[event.entity.unit_number] ~= nil then global.oreCleanerTable[event.entity.unit_number]:remove() end
	global.oreCleanerTable[event.entity.unit_number] = nil
end

-- Remove the Fluid Extractor from the table --
function removedFluidExtractor(event)
	if global.fluidExtractorTable == nil then global.fluidExtractorTable = {} return end
	if global.fluidExtractorTable[event.entity.unit_number] ~= nil then global.fluidExtractorTable[event.entity.unit_number]:remove() end
	global.fluidExtractorTable[event.entity.unit_number] = nil
end

-- Remove the Jet Flag from the table --
function removedJetFlag(event)
	if global.jetFlagTable == nil then global.jetFlagTable = {} return end
	if global.jetFlagTable[event.entity.unit_number] ~= nil then global.jetFlagTable[event.entity.unit_number]:remove() end
	global.jetFlagTable[event.entity.unit_number] = nil
end

-- Remove the Deep Storage from the table --
function removedDeepStorage(event)
	if global.deepStorageTable == nil then global.deepStorageTable = {} return end
	if global.deepStorageTable[event.entity.unit_number] ~= nil then global.deepStorageTable[event.entity.unit_number]:remove() end
	global.deepStorageTable[event.entity.unit_number] = nil
end

-- Remove the Deep Tank from the table --
function removedDeepTank(event)
	if global.deepTankTable == nil then global.deepTankTable = {} return end
	if global.deepTankTable[event.entity.unit_number] ~= nil then global.deepTankTable[event.entity.unit_number]:remove() end
	global.deepTankTable[event.entity.unit_number] = nil
end

-- Remove the Erya Structure from the table --
function removedEryaStructure(event)
	if global.eryaTable == nil then global.eryaTable = {} return end
	if global.eryaTable[event.entity.unit_number] ~= nil then global.eryaTable[event.entity.unit_number]:remove() end
	global.eryaTable[event.entity.unit_number] = nil
end