-- Return the global Object --
function getGlobal()
    return global
end

-- Return the MFTable --
function getMFTable()
    return global.MFTable
end

-- Return name list of all Users with a Mobile Factory --
function getMFUsersList()
    local MFUsersList = {}
    for k, _ in pairs(global.MFTable) do
        table.insert(MFUsersList, k)
    end
    return MFUsersList
end

-- Return a MF Object from its owner name --
function getMFObj(name)
    return global.MFTable[name]
end

-- Return a MF Entity from its owner name --
function getMFEnt(name)
    if global.MFTable[name] ~= nil then
        return global.MFTable[name].ent
    end
end

-- Return a MF Energy from its owner name --
function getMFEnergy(name)
    if global.MFTable[name] ~= nil then
        return global.MFTable[name].internalEnergyObj:energy()
    end
    return 0
end

-- Remove Energy from a MF from its owner name --
function removeMFEnergy(name, amount)
    if global.MFTable[name] ~= nil then
        return global.MFTable[name].internalEnergyObj:removeEnergy(amount)
    end
    return 0
end

-- Check if the Data Network has this Item --
function hasItems(name, item)
    if global.MFTable[name] ~= nil then
        return global.MFTable[name].dataNetwork:hasItem(item)
    end
    return 0
end

-- Add Items to the Data Network --
function addItems(name, item, amount)
    if global.MFTable[name] ~= nil then
        return global.MFTable[name].dataNetwork:addItems(item, amount)
    end
    return 0
end

-- Remove Items from the Data Network --
function takeItems(name, item, amount)
    if global.MFTable[name] ~= nil then
        return global.MFTable[name].dataNetwork:getItem(item, amount)
    end
    return 0
end

-- Add or remove crafting category to Data Assembler blacklist
function blacklistDACategory(category, value)
	if global.dataAssemblerBlacklist ~= nil then
		if value then
			global.dataAssemblerBlacklist[category] = true
		else
			global.dataAssemblerBlacklist[category] = nil
		end
	end
end

-- Add the MFCom Interface --
remote.add_interface("MFCom", {
    getGlobal=getGlobal,
    getMFTable=getMFTable,
    getMFUsersList=getMFUsersList,
    getMFObj=getMFObj,
    getMFEnt=getMFEnt,
    getMFEnergy=getMFEnergy,
    removeMFEnergy=removeMFEnergy,
    hasItems=hasItems,
    addItems=addItems,
    takeItems=takeItems,
    blacklistDACategory=blacklistDACategory
})