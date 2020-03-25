-- Update System --
_mfBaseUpdatePerTick = 100
_mfScanTicks = 100

-- Mobile Factory Surfaces name --
_mfSurfaceName = "mfSurface"
_mfControlSurfaceName = "ControlRoom"

-- Mobile Factory Energy --
_mfInternalEnergy = 1500000000
_mfInternalEnergyMax = 3000000000

-- Mobile Factory Shield --
_mfShieldChargeRate = 10
_mfShieldComsuption = 25000

-- Mobile Factory Lasers settings --
_mfBaseLaserRadius = 10
_mfBaseLaserNumber = 1

-- Mobile Factory Energy Drain settings --
_mfEnergyDrain = 10000000

-- Mobile Factory Fluid Drain settings --
_mfFluidDrain = 10000
_mfFluidConsomption = 10

-- Mobile Factory Item Drain settings --
_mfItemsDrain = 100
_mfBaseItemEnergyConsumption = 1000

-- Mobile Factory Jump Drive settings --
_mfBaseJumpTimer = 300
_mfJumpEnergyDrain = 1000000

-- Mobile Factory Fuel Burner settings --
_mfMaxFuelValue = 4000000
_mfFuelMultiplicator = 1

-- Mobile Factory Sync Area settings --
_mfSyncAreaPosition = {x=0, y=0}
_mfSyncAreaRadius = 10
_mfSyncAreaAllowedTypes =
{
    resource=true,
    container=true,
    ["storage-tank"]=true,
    accumulator=true

}

-- Mobile Factory Internal Distrubution --
_mfBaseEnergyAccSend = 1000000

-- Power Drain Pole settings --
_pdpEnergyRadius = 10
_pdpEnergyDrain = 1000000
_pdpEnergyLaser = 1

-- Deep Tank settings --
_dtMaxFluid = 10000000

-- Matter Serialization settings --
_mfBaseMaxItems = 10000
_mfDataStorageCapacity = 1000
_mfDCEnergyDrainPerUpdate = 100000
_mfDSEnergyDrainPerUpdate = 8000
_mfWDTEnergyDrainPerUpdate = 70000
_mfWDREnergyDrainPerUpdate = 30000
_mfMIEnergyDrainPerUpdate = 2500
_mfFIEnergyDrainPerUpdate = 4500

-- Ore Cleaner settings --
_mfOreCleanerMaxCharge = 1000
_mfOreCleanerRadius = 25
_mfOreCleanerOrePerExtraction = 10
_mfOreCleanerExtractionTicks = 20
_mfOreCleanerMaxDistance = 100

-- Fluid Extractor settings --
_mfFEFluidPerExtraction = 30
_mfFEMaxCharge = 1000
_mfFluidExtractorMaxDistance = 100

-- Mining Jet --
_mfMiningJetOrePerUpdate = 5
_mfMiningJetInventorySize = 100
_mfMiningJetEnergyNeeded = 2500000
_MFMiningJetDefaultMaxDistance = 200

-- Mining Jet Flag --
_mfMiningJetFlagMK1Radius = 1
_mfMiningJetFlagMK2Radius = 16
_mfMiningJetFlagMK3Radius = 50
_mfMiningJetFlagMK4Radius = 100

-- Construction/Repair Jet --
_mfEntitiesScanedPerUpdate = 30

-- Construction Jet --
_mfHPRepairedPerUpdate = -35
_mfConstructionJetEnergyNeeded = 2500000
_MFConstructionJetDefaultMaxDistance = 130

-- Repair Jet --
_mfRepairJetEnergyNeeded = 4000000
_MFRepairJetDefaultMaxDistance = 130

-- Combat Jet --
_mfCombatJetEnergyNeeded = 3200000
_MFCombatJetDefaultMaxDistance = 50

-- GUI Settings --
_GUIButtonsSize = 25

-- Erya --
_mfEryaFrostlayer = {}
_mfEryaFrostlayer[1] = {{0,0}}
_mfEryaFrostlayer[2] = {{-1,-1},{0,-1},{1,-1},{-1,0},{1,0},{-1,1},{0,1},{1,1}}
_mfEryaFrostlayer[3] = {{-2,-2},{-2,-1},{-2,0},{-2,1},{-2,2},{-1,-2},{-1,2},{0,-2},{0,2},{1,-2},{1,2},{2,-2},{2,-1},{2,0},{2,1},{2,2}}
_mfEryaFrostlayer[4] = {{-3,-3},{-3,-2},{-3,-1},{-3,0},{-3,1},{-3,2},{-3,3},{-2,-3},{-2,3},{-1,-3},{-1,3},{0,-3},{0,3},{1,-3},{1,3},{2,-3},{2,3},{3,-3},{3,-2},{3,-1},{3,0},{3,1},{3,2},{3,3}}
_mfEryaFrostlayer[5] = {{-4,-4},{-4,-3},{-4,-2},{-4,-1},{-4,0},{-4,1},{-4,2},{-4,3},{-4,4},{-3,-4},{-3,4},{-2,-4},{-2,4},{-1,-4},{-1,4},{0,-4},{0,4},{1,-4},{1,4},{2,-4},{2,4},{3,-4},{3,4},{4,-4},{4,-3},{4,-2},{4,-1},{4,0},{4,1},{4,2},{4,3},{4,4}}
_mfEryaFrostlayer[6] = {{-5,-5},{-5,-4},{-5,-3},{-5,-2},{-5,-1},{-5,0},{-5,1},{-5,2},{-5,3},{-5,4},{-5,5},{-4,-5},{-4,5},{-3,-5},{-3,5},{-2,-5},{-2,5},{-1,-5},{-1,5},{0,-5},{0,5},{1,-5},{1,5},{2,-5},{2,5},{3,-5},{3,5},{4,-5},{4,5},{5,-5},{5,-4},{5,-3},{5,-2},{5,-1},{5,0},{5,1},{5,2},{5,3},{5,4},{5,5}}

-- Entity GUI --
_mfTooltipGUI =
{
    DataCenter = "dataCenterTable",
    DataCenterMF = "dataCenterTable",
    DataStorage = "dataStorageTable",
    DeepStorage = "deepStorageTable",
    DeepTank = "deepTankTable",
    FluidExtractor = "fluidExtractorTable",
    OreCleaner = "oreCleanerTable",
    MatterInteractor = "matterInteractorTable",
    FluidInteractor = "fluidInteractorTable",
    WirelessDataTransmitter = "wirelessDataTransmitterTable",
    WirelessDataReceiver = "wirelessDataReceiverTable",
    MiningJetFlagMK1 = "jetFlagTable",
    MiningJetFlagMK2 = "jetFlagTable",
    MiningJetFlagMK3 = "jetFlagTable",
    MiningJetFlagMK4 = "jetFlagTable",
    MiningJet = "miningJetTable",
    ConstructionJet = "constructionJetTable",
    RepairJet = "repairJetTable",
    CombatJet = "combatJetTable"
}

-- Event Tick --
_eventTick5=5 -- Teleportation --
_eventTick27=27 -- Mobile Factory Fuel --
_eventTick30=30 -- Mobile Factory Sync Area
_eventTick38=38 -- Dimensional Accumulator --
_eventTick41=41 -- Repair Jets --
_eventTick45=45 -- Construction Jets --
_eventTick55=55 -- GUI --
_eventTick60=60 -- Mobile Factory Lasers/Jump Drive --
_eventTick73=73 -- Combat Jets --
_eventTick80=80 -- Mobile Factory Internal Inventory --
_eventTick90=90 -- Mobile Factory Entities Scan --
_eventTick110=110 -- Mining Jets --
_eventTick125=125 -- Mobile Factory Modules Scan --
_eventTick150=150 -- Floor Is Lava Update --
_eventTick242=242 -- Data Network ID Tables Check --
_eventTick1200=1200 -- Factory Pollution --

_mfWhite = {255,255,255}
_mfBlue = {108, 114, 229}
_mfGreen = {92, 232, 54}
_mfPurple = {155, 0, 168}
_mfRed = {231, 5, 5}
_mfOrange = {255, 131, 0}
_mfYellow = {244, 208, 63}