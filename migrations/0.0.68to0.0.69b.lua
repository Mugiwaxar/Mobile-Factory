-- Unlock all Mining Flags recipes --
if technologyUnlocked("MiningJet") then
	game.forces["player"].recipes["MiningJetFlagMK1"].enabled = true
	game.forces["player"].recipes["MiningJetFlagMK2"].enabled = true
	game.forces["player"].recipes["MiningJetFlagMK3"].enabled = true
	game.forces["player"].recipes["MiningJetFlagMK4"].enabled = true
end

-- Remove Mining Jets --
if global.MF ~= nil and global.MF.ent ~= nil and global.miningJetTable ~= nil then
	-- Get the Mobile Factory Trunk --
	local inv = global.MF.ent.get_inventory(defines.inventory.car_trunk)
	-- Check the Inventory --
	if inv ~= nil and inv.valid == true then
		for k, jet in pairs(global.miningJetTable) do
			inv.insert({name="MiningJet", count=1})
			jet.ent.destroy()
		end
	end
end
global.miningJetTable = {}

-- Check the last Entities scan --
if global.upSysLastScan == nil then global.upSysLastScan = 0 end
-- Remove the Upsys Index --
global.upSysIndex = nil
-- Create the Upsys tick Table --
global.upsysTickTable = {}