-- Restore Mobile Factory --
if global.MobileFactory ~= nil and global.MobileFactory.valid == true then
	global.mobileFactory = global.MobileFactory
	global.MobileFactory = nil
end

-- Restaure Factory Surface--
if global.mfInsideSurface ~= nil and global.mfInsideSurface.valid == true then
	global.factorySurface = global.mfInsideSurface
	global.mfInsideSurface = nil
end

-- Restore Factory Chest --
if global.FactoryChest ~= nil and global.FactoryChest.valid == true then
	global.factoryChest = global.FactoryChest
	global.FactoryChest = nil
end

-- Remove useless variable --
global.mfBaseEnergyAccSend = nil