-- Create the Jump Drive Object --
for k, mf in pairs(global.MFTable or {}) do
    mf.jumpDriveObj = JD:new(mf)
    -- Removing old unused Variables --
    mf.jumpTimer = nil
    mf.baseJumpTimer = nil
    mf.fChest = nil
end

-- Removing old unused Variables --
global.insertedMFInsideInventory = nil