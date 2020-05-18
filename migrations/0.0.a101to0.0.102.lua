-- Create a MF object and MFPlayer Object for every Players and set the Beginning Technology to unlocked --
if global.playersTable == nil then global.playersTable = {} end
if global.MFTable == nil then global.MFTable = {} end
if global.upsysTickTable == nil then global.upsysTickTable = {} end
if global.entsTable == nil then global.entsTable = {} end
for k, player in pairs(game.players) do
    if global.playersTable[player.name] == nil then
        global.playersTable[player.name] = MFP:new(player)
		Util.addMobileFactory(player)
		setPlayerVariable(player.name, "GotInventory", true)
    end
    if global.MFTable[player.name] == nil then
        local MF = MF:new()
        global.MFTable[player.name] = MF
        MF.playerIndex = player.index
		MF.II = INV:new("Internal Inventory")
		MF.II.MF = MF
		MF.II.isII = true
		MF.player = player.name
		createMFSurface(MF)
        createControlRoom(MF)
        global.playersTable[player.name].MF = MF
    end
    player.force.technologies["DimensionalOre"].researched = true
end