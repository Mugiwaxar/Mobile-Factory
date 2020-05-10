local key = nil
local MFPlayer = nil
local GUIObj = nil
local playerIndex = nil
local player = nil
local MF

for key, MFPlayer in pairs(global.playersTable or {}) do
	if MFPlayer.playerIndex == nil and MFPlayer.name ~= nil then
		player = getPlayer(MFPlayer.name) -- names are not unique! only indices are!
		MFPlayer.index = player.index
	end
end

for _, MF in pairs(global.MFTable or {}) do
	if MF.playerIndex == nil then
		player = getPlayer(MF.player)
		MF.playerIndex = player.index
	end
end


-- Not needed anymore, GUI are stored inside MFPlayer --

-- local newGUIObjs = {}

-- for key, GUIObj in pairs(global.GUITable or {}) do
-- 	if string.match(key, "%d$") == nil then
-- 		if GUIObj.gui and GUIObj.gui.valid then
-- 			playerIndex = GUIObj.gui.player_index
-- 			newGUIObjs[key..playerIndex] = GUIObj
-- 		end
-- 		global.GUITable[key] = nil
-- 	end
-- end

-- for key, GUIObj in pairs(newGUIObjs or {}) do
-- 	global.GUITable[key] = GUIObj
-- end