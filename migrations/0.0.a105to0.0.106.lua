if not global.allowMigration then return end
for k, MF in pairs(global.MFTable) do
    -- Unlock the Control Center Area --
    if technologyUnlocked("ControlCenter") then
		updateFactoryFloorForCC(MF)
	end
    if technologyUnlocked("ConstructibleArea1") then
        createConstructibleArea1(MF)
    end
    if technologyUnlocked("DeepStorage") then
        createDeepStorageArea(MF)
    end
    if MF.fS ~= nil then
        createTilesSurface(MF.fS, -50, -50, 50, 50, "tutorial-grid")
	    createTilesSurface(MF.fS, -3, -3, 3, 3, "refined-concrete")
	    createTilesSurface(MF.fS, -1, -1, 1, 1, "refined-hazard-concrete-left")
    end
end