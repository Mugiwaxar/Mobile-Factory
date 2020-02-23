for k, MF in pairs(global.MFTable) do
    -- Unlock the Control Center Area --
    if technologyUnlocked("ConstructibleArea1") then
        createConstructibleArea1(MF)
    end
    if technologyUnlocked("DeepStorage") then
        createDeepStorageArea(MF)
    end
    local tilesTable = {}
	for x = -3, 2 do
	  for y = -34, -32 do
		table.insert(tilesTable, {name="refined-hazard-concrete-left",position={x,y}})
		end
	end
    if MF.fS ~= nil then
        createTilesSurface(MF.fS, -50, -50, 50, 50, "tutorial-grid")
	    createTilesSurface(MF.fS, -3, -3, 3, 3, "refined-concrete")
	    createTilesSurface(MF.fS, -1, -1, 1, 1, "refined-hazard-concrete-left")
    end
end