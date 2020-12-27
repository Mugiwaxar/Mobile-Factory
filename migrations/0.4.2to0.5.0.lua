-- Remove the SyncArea -- (Unclone all Entities like Chests, Tanks or Accumulors means to much work - they have to be empty, I consider these as a gift)
game.print("Mobile Factory: The SyncArea has been replaced by the Mobile Factory Deployment. This can be unlocked through its corresponding Technology")
for _, MF in pairs(global.MFTable or {}) do
    -- Destroy the Cercle Render --
    rendering.destroy(MF.syncAreaID)
	rendering.destroy(MF.syncAreaInsideID)
    -- Unclone all Ressources --
    for _, ents in pairs(MF.clonedResourcesTable) do
        local ent = ents.cloned
    	if ent ~= nil and ent.valid == true and ent.type == "resource" then
            ent.destroy()
        end
    end
    -- Set unused values to nil --
    MF.syncAreaID = nil
	MF.syncAreaInsideID = nil
	MF.syncAreaScanned = nil
    MF.clonedResourcesTable = nil
    -- Remove the Area inside the Factory --
    local radius = 11
    createTilesSurface(MF.fS, 0 - radius, 0 - radius, 0 + radius, 0 + radius, "tutorial-grid")
    createTilesSurface(MF.fS, -3, -4, 3, 4, "concrete")
    createTilesSurface(MF.fS, -1, -1, 1, 1, "refined-hazard-concrete-right")
end