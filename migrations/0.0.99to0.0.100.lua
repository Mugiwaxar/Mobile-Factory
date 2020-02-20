-- Set last user and Force for the default created Entities inside the Mobile Factory --
for k, MF in pairs(global.MFTable) do
    if MF.fChest ~= nil then
        MF.fChest.last_user = MF.player
        MF.fChest.force = getForce(MF.player)
    end
    local ents = MF.ccS.find_entities_filtered{}
    for k2, ent in pairs(ents) do
        ent.last_user = MF.player
        ent.force = getForce(MF.player)
    end
end