-- Create the Jump Drive Object --
for k, mf in pairs(global.MFTable or {}) do
    global.playersTable.Mugiwaxar.varTable.
    mf.jumpDriveObj = JD:new(mf)
    -- Removing old unused Variables --
    mf.jumpTimer = nil
    mf.baseJumpTimer = nil
    mf.fChest = nil
end

-- Removing old unused Variables --
global.insertedMFInsideInventory = nil