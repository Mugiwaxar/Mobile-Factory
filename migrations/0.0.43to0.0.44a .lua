-- CC Tanks Migration --
if global.tankTable ~= nil and table_size(global.tankTable) > 0 then
	game.print("Update Tank Table ...")
	-- Update all Tanks --
	for k, tank in pairs(global.tankTable) do
		-- Update the Tank --
		global.tankTable[k].ent = global.MF.ccS.find_entity(tank.name, tank.position)
		global.tankTable[k].name = nil
		global.tankTable[k].position = nil
	end
	game.print("Done!")
end