-- Save the Dimensional Accumulator in a table --
function placedDimensionalAccumulator(event)
	if global.accTable == nil then global.accTable = {} end
	global.accTable[event.created_entity.unit_number] = event.created_entity
end

-- Save the Drain Power Pole --
function placedPowerDrainPole(event)
	if global.pdpTable == nil then global.pdpTable = {} end
	global.pdpTable[event.created_entity.unit_number] = PDP:new(event.created_entity)
end

-- Save the Logistic Fluid Pole in a table --
function placedLogisticPowerPole(event)
	if global.lfpTable == nil then global.lfpTable = {} end
	global.lfpTable[event.created_entity.unit_number] = event.created_entity
end

-- Save the Matter Serializer in a table --
function placedMatterSerializer(event)
	if global.matterSerializerTable == nil then global.matterSerializerTable = {} end
	global.matterSerializerTable[event.created_entity.unit_number] = MS:new(event.created_entity)
end

-- Save the Matter Printer in a table --
function placedMatterPrinter(event)
	if global.matterPrinterTable == nil then global.matterPrinterTable = {} end
	global.matterPrinterTable[event.created_entity.unit_number] = MP:new(event.created_entity)
end

-- Save the Data Center in a table --
function placedDataCenter(event)
	if global.dataCenterTable == nil then global.dataCenterTable = {} end
	global.dataCenterTable[event.created_entity.unit_number] = DC:new(event.created_entity)
end

-- Save the Data Center MF --
function placedDataCenterMF(event)
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
	global.deepStorageTable[event.created_entity.unit_number] = DSR:new(event.created_entity)
end

-- Save the Erya Structure --
function placedEryaStructure(event)
	if global.eryaTable == nil then global.eryaTable  = {} end
	global.eryaTable[event.created_entity.unit_number] = ES:new(event.created_entity)
end



-- Remove the Dimensional Accumulator from the table --
function removedDimensionalAccumulator(event)
	if global.accTable == nil then global.accTable = {} return end
	global.accTable[event.entity.unit_number] = nil
end

-- Remove the Power Drain Pole from the table --
function removedPowerDrainPole(event)
	if global.pdpTable == nil then global.pdpTable = {} return end
	global.pdpTable[event.entity.unit_number] = nil
end

-- Remove the Logistic Fluid Pole from the table --
function removedLogisticPowerPole(event)
	if global.lfpTable == nil then global.lfpTable = {} return end
	global.lfpTable[event.entity.unit_number] = nil
end

-- Remove the Matter Serializer from the table --
function removedMatterSerializer(event)
	if global.matterSerializerTable == nil then global.matterSerializerTable = {} return end
	if global.matterSerializerTable[event.entity.unit_number] ~= nil then global.matterSerializerTable[event.entity.unit_number]:remove() end
	global.matterSerializerTable[event.entity.unit_number] = nil
end

-- Remove the Matter Printer from the table --
function removedMatterPrinter(event)
	if global.matterPrinterTable == nil then global.matterPrinterTable = {} return end
	if global.matterPrinterTable[event.entity.unit_number] ~= nil then global.matterPrinterTable[event.entity.unit_number]:remove() end
	global.matterPrinterTable[event.entity.unit_number] = nil
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

-- Remove the Erya Structure from the table --
function removedEryaStructure(event)
	if global.eryaTable == nil then global.eryaTable = {} return end
	if global.eryaTable[event.entity.unit_number] ~= nil then global.eryaTable[event.entity.unit_number]:remove() end
	global.eryaTable[event.entity.unit_number] = nil
end