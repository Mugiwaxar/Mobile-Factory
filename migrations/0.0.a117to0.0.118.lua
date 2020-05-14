-- Remove old GUIs --
for k, player in pairs(game.players) do
    if player.gui.screen.mfGUI ~= nil then player.gui.screen.mfGUI.destroy() end
    if player.gui.screen.mfInfoGUI ~= nil then player.gui.screen.mfInfoGUI.destroy() end
    if player.gui.screen.mfOptionGUI ~= nil then player.gui.screen.mfOptionGUI.destroy() end
    if player.gui.screen.mfTooltipGUI ~= nil then player.gui.screen.mfTooltipGUI.destroy() end
end

-- Set the new GUI Variables --
for k, MFPlayer in pairs(global.playersTable) do
    MFPlayer.varTable.ShowEnergyDrainButton = false
    MFPlayer.varTable.ShowFluidDrainButton = false
    MFPlayer.varTable.ShowItemDrainButton = false
    MFPlayer.varTable.ShowItemDrainButton = false
    MFPlayer.varTable.ShowSendQuatronButton = false
end