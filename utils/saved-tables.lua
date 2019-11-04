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

-- Save the Provider Pad in a table --
function placedProviderPad(event)
	if global.providerPadTable == nil then global.providerPadTable = {} end
	global.providerPadTable[event.created_entity.unit_number] = event.created_entity
end

-- Save the Requester Pad in a table --
function placedRequesterPad(event)
	if global.requesterPadTable == nil then global.requesterPadTable = {} end
	global.requesterPadTable[event.created_entity.unit_number] = event.created_entity
end

-- Save Ore Silot Pads in a table --
function placedOreSilotPad(event)
	if global.oreSilotPadTable == nil then global.oreSilotPadTable = {} end
	global.oreSilotPadTable[event.created_entity.unit_number] = event.created_entity
end

-- Save Inventory Pad in a table --
function placedInventoryPad(event)
	if global.inventoryPadTable == nil then global.inventoryPadTable = {} end
	global.inventoryPadTable[event.created_entity.unit_number] = event.created_entity
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

-- Remove the Provider Pad from the table --
function removedProviderPad(event)
	if global.providerPadTable == nil then global.providerPadTable = {} return end
	global.providerPadTable[event.entity.unit_number] = nil
end

-- Remove the Requester Pad from the table --
function removedRequesterPad(event)
	if global.requesterPadTable == nil then global.requesterPadTable = {} return end
	global.requesterPadTable[event.entity.unit_number] = nil
end

-- Remove Ore Silot Pad from the table --
function removedOreSilotPad(event)
	if global.oreSilotPadTable == nil then global.oreSilotPadTable = {} return end
	global.oreSilotPadTable[event.entity.unit_number] = nil
end

-- Remove Inventory Pad from the table --
function removedInventoryPad(event)
	if global.inventoryPadTable == nil then global.inventoryPadTable = {} return end
	global.inventoryPadTable[event.entity.unit_number] = nil
end

















