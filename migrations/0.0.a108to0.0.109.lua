if not global.allowMigration then return end
-- Set all Factory surfaces to day/night cycle --
for k, MF in pairs(global.MFTable) do
    if MF.fS ~= nil then
        MF.fS.always_day = false
        MF.fS.daytime = game.get_surface("nauvis").daytime
    end
end