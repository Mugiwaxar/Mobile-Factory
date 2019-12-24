-- Loaders are unable to work anymore on the FactoryChest, place a new one --
if global.MobileFactory ~= nil and global.MobileFactory.valid == true
	and global.mfInsideSurface ~= nil and global.mfInsideSurface.valid == true 
	and global.FactoryChest ~= nil and global.FactoryChest.valid == true then
	local inventory1 = global.FactoryChest.get_inventory(defines.inventory.chest)
	itemsTable = {}
	
	for i = 1, 30 do
		if inventory1.is_empty() then break end
		table.insert(itemsTable, {name=inventory1[i].name, count=inventory1[i].count})
		inventory1.remove(inventory1[i])
	end
	
	global.FactoryChest.destroy()
	global.FactoryChest = global.mfInsideSurface.create_entity{
			name="FactoryChest",
			position={-2,-2},
			force="player"
	}
	inventory1 = global.FactoryChest.get_inventory(defines.inventory.chest)
	
	for k, itemStack in pairs(itemsTable) do
		inventory1.insert(itemStack)
	end
end
		