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
	global.matterSerializerTable[event.created_entity.unit_number] = event.created_entity
end

-- Save the Matter Printer in a table --
function placedMatterPrinter(event)
	if global.matterPrinterTable == nil then global.matterPrinterTable = {} end
	global.matterPrinterTable[event.created_entity.unit_number] = event.created_entity
end

-- Save the Data Center in a table --
function placedDataCenter(event)
	if global.dataCenterTable == nil then global.dataCenterTable = {} end
	global.dataCenterTable[event.created_entity.unit_number] = DC:new(event.created_entity)
end

-- Save Data Storage in a table --
function placedDataStorage(event)
	if global.dataStorageTable == nil then global.dataStorageTable = {} end
	global.dataStorageTable[event.created_entity.unit_number] = DS:new(event.created_entity)
end

-- Save Ore Silot Pads in a table --
function placedOreSilotPad(event)
	if global.oreSilotPadTable == nil then global.oreSilotPadTable = {} end
	global.oreSilotPadTable[event.created_entity.unit_number] = event.created_entity
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
	global.matterSerializerTable[event.entity.unit_number] = nil
end

-- Remove the Matter Printer from the table --
function removedMatterPrinter(event)
	if global.matterPrinterTable == nil then global.matterPrinterTable = {} return end
	global.matterPrinterTable[event.entity.unit_number] = nil
end

-- Remove the Data Center from the table --
function removedDataCenter(event)
	if global.dataCenterTable == nil then global.dataCenterTable = {} return end
	if global.dataCenterTable[event.entity.unit_number] ~= nil then global.dataCenterTable[event.entity.unit_number]:remove() end
	global.dataCenterTable[event.entity.unit_number] = nil
end

-- Remove Data Storage from the table --
function removedDataStorage(event)
	if global.dataStorageTable == nil then global.dataStorageTable = {} return end
	if global.dataStorageTable[event.entity.unit_number] ~= nil then global.dataStorageTable[event.entity.unit_number]:remove() end
	global.dataStorageTable[event.entity.unit_number] = nil
end

-- Remove Ore Silot Pad from the table --
function removedOreSilotPad(event)
	if global.oreSilotPadTable == nil then global.oreSilotPadTable = {} return end
	global.oreSilotPadTable[event.entity.unit_number] = nil
end

















