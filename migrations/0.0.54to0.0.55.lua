-- Set the Mobile Factory Internal Inventory to II --
if global.MF ~= nil and global.MF.II ~= nil then
	global.MF.II.isII = true
	global.MF.II.CCInventory = {}
end

-- Remove the Ore Silo Pad Table --
	global.oreSilotPadTable = nil