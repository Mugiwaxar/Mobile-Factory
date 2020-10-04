if not global.allowMigration then return end
-- Surfaces readjustment --
for k, MF in pairs(global.MFTable or {}) do
    -- Create the Sync Area inside the Factory --
    createTilesSurface(MF.fS, _mfSyncAreaPosition.x - _mfSyncAreaRadius, _mfSyncAreaPosition.y - _mfSyncAreaRadius, _mfSyncAreaPosition.x + _mfSyncAreaRadius, _mfSyncAreaPosition.y + _mfSyncAreaRadius, "dirt-7")
    createSyncAreaMFSurface(MF.fS, true)
    -- Recreate the Factory to Control Center TP Area --
    createTilesSurface(MF.fS, -4, -36, 4, -30, "tutorial-grid")
    createTilesSurface(MF.fS, -3, -34, 3, -32, "refined-hazard-concrete-left")
    -- Recreate the Control Center to Factory TP Area --
    createTilesSurface(MF.ccS, -3, 4, 3, 8, "tutorial-grid")
    createTilesSurface(MF.ccS, -3, 5, 3, 7, "refined-hazard-concrete-right")
    -- Remove the Accumulator and the Substation inside the Control Center --
    createTilesSurface(MF.ccS, -4, 10, 4, 14, "VoidTile")
    -- Remove wrong Tiles inside the Control Center --
    createTilesSurface(MF.ccS, -92, -30, -90, 3, "VoidTile")
    -- Remove the Factory Chest/Factory Tank --
    MF.mChest = nil
    MF.fTank = nil
end

-- Unlock the Matter Interactor/ Fluid Interactor --
unlockRecipeForAll("MatterInteractor", "MatterSerialization")
unlockRecipeForAll("FluidInteractor", "DeepTank")

-- Send the Matter Serializer/Printer message --
if table_size(global.matterSerializerTable or {}) > 0 or table_size(global.matterPrinterTable or {}) > 0 then
    game.print("#####################################################################################")
    game.print("The 0.0.116 update removed the Matter Serializer/Printer")
    game.print("Now, you have to use the Matter Interactor instead (Configurable with the Tooltip GUI")
    game.print("##################################################################################### ")
end

--  Remove unused Tables --
global.matterSerializerTable = nil
global.matterPrinterTable = nil