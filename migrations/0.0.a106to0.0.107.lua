if global.allowMigration == false then return end
-- Recreate the Control Center Teleportation Floor --
for k, MF in pairs(global.MFTable) do
    local tilesTable = {}
	for x = -3, 2 do
	  for y = -34, -32 do
		table.insert(tilesTable, {name="refined-hazard-concrete-left",position={x,y}})
		end
	end
	MF.fS.set_tiles(tilesTable)
end