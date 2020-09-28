if not global.allowMigration then return end
-- Store GUI inside MFPlayer --
for k, GUI in pairs(global.GUITable or {}) do
    -- Fix the Type error --
    GUI.MFPlayer = GUI.MFplayer
    GUI.MFplayer = nil
    -- Relocate the GUI Object --
    local playerIndex = GUI.gui.player_index
    local MFPlayer = getMFPlayer(playerIndex)
    MFPlayer.GUI = {}
    MFPlayer.GUI[GUI.gui.name] = GUI
end

-- Remove the old GUI Table --
global.GUITable = nil