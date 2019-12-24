require("scripts/objects/inventory.lua")

-- Print update message --
if global.inventoryTable ~= nil and table_size(global.inventoryTable) > 0 then
	game.print("#################################################################################################################")
	game.print("Mobile Factory: In this Update, all the Internal Inventory logistic was changed.")
	game.print("The Inventory/Provider/Requester Pad was removed, and replaced by Matter Serializer/Printer and Data Storage.")
	game.print("Replaced all Inventory/Provider/Requester Pads by Iron Chests")
	game.print("################################################################################################################# ")
	game.print(" ")
	game.print("  ")
end

-- Unlock Matter Serialization recipes --
if technologyUnlocked("MatterSerialization") then
	game.forces["player"].recipes["DataCenter"].enabled = true
	game.forces["player"].recipes["DataCenterMF"].enabled = true
	game.forces["player"].recipes["DataStorage"].enabled = true
	game.forces["player"].recipes["MatterSerializer"].enabled = true
	game.forces["player"].recipes["MatterPrinter"].enabled = true
	game.forces["player"].recipes["EnergyCubeMK1"].enabled = true
end

-- Set MF surface to day and alway day --
if global.MF ~= nil and global.MF.fS ~= nil then
global.MF.fS.always_day = true
global.MF.fS.daytime = 0
end
if global.MF ~= nil and global.MF.ccS ~= nil then
global.MF.ccS.always_day = true
global.MF.ccS.daytime = 0
end

-- Internal Inventory to OOP --
if global.MF.II == nil then
	-- Create II and tables --
	global.MF.II = INV:new("Internal Inventory")
	global.MF.II.inventory = {}
	global.MF.II.inventory = {}
	global.MF.II.dataStoragesTable = {}
	global.dataStorageTable = {}
	global.dataCenterTable = {}
	global.matterSerializerTable = {}
	global.matterPrinterTable = {}
	-- Copy Internal Inventory --
	if global.inventoryTable ~= nil then
		for k, i in pairs(global.inventoryTable) do
			global.MF.II.inventory[i.name] = i.amount
		end
	end
	-- Delete old tables and values --
	global.inventoryTable = nil
	global.inventoryPadTable = nil
	global.providerPadTable = nil
	global.requesterPadTable = nil
	global.mfInventoryItems = nil
	global.mfInventoryTypes = nil
	global.mfInventoryMaxItem = nil
	global.mfInventoryMaxTypes = nil
end