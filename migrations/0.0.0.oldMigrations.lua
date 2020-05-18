-- To OOP --
if global.MobileFactory ~= nil then
	global.MF = MF:new()
	local MF = global.MF
	MF:construct(global.MobileFactory)
	MF.fS = global.mfInsideSurface
	MF.ccS = global.controlSurface
	MF.fChest = global.factoryChest
	-- MF.internalEnergy = global.mfInternalEnergy
	-- MF.maxInternalEnergy = global.mfInternalEnergyMax
	MF.jumpTimer = global.mfJumpTimer
	MF.baseJumpTimer = global.mfBaseJumpTimer
	MF.laserRadiusMultiplier = global.mfEnergyRadiusMult
	MF.laserDrainMultiplier = global.mfEnergyDrainMult
	MF.laserNumberMultiplier = global.mfEnergyLaserMult
	MF.energyLaserActivated = global.mfEnergyLaserActivated
	MF.fluidLaserActivated = global.mfFluidDrainLaserActivated
	MF.itemLaserActivated = global.mfItemDistributionActivated
end
if global.MF ~= nil and global.MF.II == nil then
	global.MF.II = INV:new("Internal Inventory")
	global.MF.II.inventory = {}
	-- Copy Internal Inventory --
	if global.inventoryTable ~= nil then
		for k, i in pairs(global.inventoryTable) do
			global.MF.II.inventory[i.name] = i.amount
		end
	end
end

-- Create the Objects Table --
Util.createTableList()

-- Create all Table --
for k, obj in pairs(global.objTable) do
    if obj.tableName ~= nil and global[obj.tableName] == nil then
        global[obj.tableName] = {}
    end
end

-- Add new Values --
if global.upSysLastScan == nil then global.upSysLastScan = 0 end
if global.entsUpPerTick == nil then global.entsUpPerTick = _mfBaseUpdatePerTick end
if global.entsTable == nil then global.entsTable = {} end
if global.upsysTickTable == nil then global.upsysTickTable = {} end
if global.insertedMFInsideInventory == nil then global.insertedMFInsideInventory = false end
if global.updateEryaIndex == nil then global.updateEryaIndex = 1 end
if global.eryaIndexedTable == nil then global.eryaIndexedTable = {} end
if global.constructionJetIndex == nil then global.constructionJetIndex = 0 end
if global.repairJetIndex == nil then global.repairJetIndex = 0 end
if global.floorIsLavaActivated == nil then global.floorIsLavaActivated = false end
if global.dataNetworkID == nil then global.dataNetworkID = 0 end
if global.dataNetworkTable == nil then global.dataNetworkTable = {} end
if global.dataNetworkIDGreenTable == nil then global.dataNetworkIDGreenTable = {} end
if global.dataNetworkIDRedTable == nil then global.dataNetworkIDRedTable = {} end
if global.constructionTable == nil then global.constructionTable = {} end
if global.repairTable == nil then global.repairTable = {} end

-- Unlocking Recipes --
unlockRecipeForAll("DimensionalOre")
unlockRecipeForAll("mfShieldEquipment", "MFShield")
unlockRecipeForAll("DataCenter", "MatterSerialization")
unlockRecipeForAll("DataCenterMF", "MatterSerialization")
unlockRecipeForAll("DataStorage", "MatterSerialization")
unlockRecipeForAll("EnergyCubeMK1", "MatterSerialization")
unlockRecipeForAll("MachineFrame2", "DimensionalOreSmelting")
unlockRecipeForAll("MachineFrame3", "DimensionalCrystal")
unlockRecipeForAll("CrystalizedCircuit", "DimensionalCrystal")
unlockRecipeForAll("MiningJetFlagMK1", "MiningJet")
unlockRecipeForAll("MiningJetFlagMK2", "MiningJet")
unlockRecipeForAll("MiningJetFlagMK3", "MiningJet")
unlockRecipeForAll("MiningJetFlagMK4", "MiningJet")

-- Set MF surface to day and alway day --
if global.MF ~= nil and global.MF.fS ~= nil then
	global.MF.fS.always_day = true
	global.MF.fS.daytime = 0
	end
if global.MF ~= nil and global.MF.ccS ~= nil then
	global.MF.ccS.always_day = true
	global.MF.ccS.daytime = 0
end

-- Remove the RedCross Fluid --
for k, tank in pairs(global.tankTable or {}) do
	if tank.filter == "RedCross" then tank.filter = nil end
end

-- Ore Silo to Deep Storage Update --
if table_size(global.oreSilotTable or {}) > 0 then
	-- Unlock the Deep Storage Technology --
	-- createDeepStorageArea(global.MF)
	game.forces["player"].recipes["DeepStorage"].enabled = true
	-- Remove the Ore Silo table --
	global.oreSilotTable = {}
end

-- Change Map Settings --
if global.MF ~= nil and global.MF.fS ~= nil then
    local mapSetting = {
		default_enable_all_autoplace_controls = false,
		property_expression_names = {cliffiness = 0},
		peaceful_mode = true,
		autoplace_settings = {tile = {settings = { ["VoidTile"] = {frequency="normal", size="normal", richness="normal"} }}},
		starting_area = "none",
		width = 0,
		height = 0
	}
    global.MF.fS.map_gen_settings = mapSetting
end
if global.MF ~= nil and global.MF.ccS ~= nil then
    local mapSetting = {
		default_enable_all_autoplace_controls = false,
		property_expression_names = {cliffiness = 0},
		peaceful_mode = true,
		autoplace_settings = {tile = {settings = { ["VoidTile"] = {frequency="normal", size="normal", richness="normal"} }}},
		starting_area = "none",
		width = 0,
		height = 0
	}
    global.MF.ccS.map_gen_settings = mapSetting
end

-- Removing unused old Variables --
global.mfBaseEnergyAccSend = nil
global.MobileFactory = nil
global.mfInsideSurface = nil
global.FactoryChest = nil
global.mobileFactory = nil
global.factorySurface = nil
global.controlSurface = nil
global.factoryChest = nil
global.mfInternalEnergy = nil
global.mfInternalEnergyMax = nil
global.mfJumpTimer = nil
global.mfBaseJumpTimer = nil
global.mfEnergyRadiusMult = nil
global.mfEnergyDrainMult = nil
global.mfEnergyLaserMult = nil
global.mfEnergyLaserActivated = nil
global.mfFluidDrainLaserActivated = nil
global.mfItemDistributionActivated = nil
global.mfEnergyDistributionActivated = nil
global.inventoryTable = nil
global.inventoryPadTable = nil
global.providerPadTable = nil
global.requesterPadTable = nil
global.mfInventoryItems = nil
global.mfInventoryTypes = nil
global.mfInventoryMaxItem = nil
global.mfInventoryMaxTypes = nil
global.fluidExtractorCharge = nil
global.fluidExtractorPurity = nil
global.fluidExtractor = nil
global.oreCleaner = nil
global.oreSilotPadTable = nil
global.upSysIndex = nil
global.oreSilotTable = nil
global.IDModule = nil