if not global.allowMigration then return end
for _, MF in pairs(global.MFTable) do
	if MF.playerIndex == nil then
		player = getPlayer(MF.player)
		MF.playerIndex = player.index
	end
end