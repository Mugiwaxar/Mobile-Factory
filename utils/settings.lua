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
_mfWaterDrainPerSecond = 10000

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

-- Mobile Factory Internal Distrubution --
_mfBaseEnergyAccSend = 1000000

-- Power Drain Pole settings --
_pdpEnergyRadius = 10
_pdpEnergyDrain = 1000000
_pdpEnergyLaser = 1

-- Logistic Fluid Pole settings --
_lfpFluidRadius = 10
_lfpFluidDrain = 10000
_lfpFluidLaser = 1
_lfpFluidConsomption = 10

-- Matter Serialization settings --
_mfBaseMaxItems = 10000
_mfDataStorageCapacity = 1000
_mfDCEnergyDrainPerUpdate = 100000
_mfDSEnergyDrainPerUpdate = 8000
_mfMSEnergyDrainPerUpdate = 3000
_mfMPEnergyDrainPerUpdate = 3000
_mfWDTEnergyDrainPerUpdate = 70000
_mfWDREnergyDrainPerUpdate = 30000

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

-- Event Tick --
_eventTick5=5 -- Teleportation --
_eventTick21=21 -- Factory Chest --
_eventTick27=27 -- Mobile Factory Fuel --
_eventTick38=38 -- Dimensional Accumulator --
_eventTick41=41 -- Repair Jets --
_eventTick45=45 -- Construction Jets --
_eventTick55=55 -- GUI --
_eventTick60=60 -- Mobile Factory Lasers/Jump Drive --
_eventTick64=64 -- Logistic Fluid Poles --
_eventTick73=73 -- Combat Jets --
_eventTick80=80 -- Mobile Factory Internal Inventory --
_eventTick90=90 -- Mobile Factory Entities Scan --
_eventTick110=110 -- Mining Jets --
_eventTick125=125 -- Mobile Factory Modules Scan --
_eventTick150=150 -- Floor Is Lava Update --
_eventTick242=242 -- Data Network ID Tables Check --
_eventTick1200=1200 -- Factory Pollution --

_mfBlue = {108, 114, 229}
_mfGreen = {92, 232, 54}
_mfPurple = {155, 0, 168}
_mfRed = {231, 5, 5}
_mfOrange = {211, 84, 0}