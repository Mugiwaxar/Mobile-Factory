local function merge(list)
	local ret = {}
	for _, array in pairs(list) do
		for _, value in pairs(array) do
			table.insert(ret, value)
		end
	end
	return ret
end

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

-- Mobile Factory Quatron Drain settings --
_mfQuatronDrain = 1000

-- Mobile Factory Energy Drain settings --
_mfEnergyDrain = 10000000

-- Mobile Factory Fluid Drain settings --
_mfFluidDrain = 10000
_mfFluidConsomption = 10

-- Mobile Factory Item Drain settings --
_mfItemsDrain = 100
_mfBaseItemEnergyConsumption = 1000

-- Mobile Factory Jump Drive settings --
_mfMaxJumpCharge = 500
_mfJumpEnergyDrain = 300000

-- Mobile Factory Fuel Burner settings --
_mfMaxFuelValue = 4000000
_mfFuelMultiplicator = 1

-- Mobile Factory Sync Area settings --
-- _mfSyncAreaPosition = {x=0, y=0}
-- _mfSyncAreaRadius = 10
-- _mfSyncAreaAllowedTypes =
-- {
-- 	resource=true,
-- 	container=true,
-- 	["logistic-container"]=true,
-- 	["storage-tank"]=true,
-- 	accumulator=true
-- }

-- Mobile Factory Sync Area extra entity information needed --
-- _mfSyncAreaExtraDetails = {
-- 	["item-entity"] = {["stack"] = "stack"},
-- 	["entity-ghost"] = {["inner_name"] = "ghost_name"},
-- 	["tile-ghost"] = {["inner_name"] = "ghost_name"},
-- }

-- Mobile Factory Sync Area, ignored for collision, entity types --
-- _mfSyncAreaIgnoredTypes = {
-- 	beam = true,
-- 	["flying-text"] = true,
-- 	["fire"] = true,
-- 	["particle"] = true,
--     ["projectile"] = true,
-- 	["highlight-box"] = true,
-- 	["speech-bubble"] = true,
-- 	["item-request-proxy"] = true,
-- 	["sticker"] = true,
-- }

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
_mfNAPQuatronCapacity = 1000
_mfNAPAreaSize = 50
_mfNAPQuatronDrainPerUpdate = 15
_mfMIQuatronDrainPerUpdate = 8
_mfFIQuatronDrainPerUpdate = 8
_mfNEQuatronDrainPerUpdate = 3
_mfDAQuatronDrainPerUpdate = 1
_mfQuatronScalePower = 1.3
_mfQuatronReactorMaxEnergyCapacity = 25000
_mfQuatronReactorMaxOutput = 5000
_mfQuatronMaxFluidBurntPerOperation = 1000

-- Ore Cleaner settings --
_mfOreCleanerMaxCharge = 1000
_mfOreCleanerRadius = 25
_mfOreCleanerOrePerExtraction = 5
_mfOreCleanerExtractionTicks = 20
_mfOreCleanerMaxDistance = 100

-- Fluid Extractor settings --
_mfFEFluidPerExtraction = 15
_mfFEMaxCharge = 1000
_mfFluidExtractorMaxDistance = 100

-- Unlocked Technology Functions --
_MFResearches = {}
_MFResearches["ControlCenter"] = "updateFactoryFloorForCC"
_MFResearches["DeepStorage"] = "createDeepStorageArea"
_MFResearches["DeepTank"] = "createDeepTankArea"
_MFResearches["ConstructibleArea1"] = "createConstructibleArea1"
_MFResearches["ConstructibleArea2"] = "createConstructibleArea2"
_MFResearches["MatterSerialization"] = "createNetworkControllerArea"
_MFResearches["JumpDrive"] = "createJumpDriveArea"

-- Entity Lists --
_mfEnergyShare =
{
	"InternalEnergyCube",
	"EnergyCubeMK1",
	"EnergyLaser1"
}

_mfQuatronShare =
{
	"InternalQuatronCube",
	"QuatronCubeMK1",
	"QuatronLaser1",
	"QuatronReactor",
	"NetworkAccessPoint",
	"OreCleaner",
	"FluidExtractor"
}

_mfMobileFactories =
{
	"MobileFactory",
	"GTMobileFactory",
	"HMobileFactory"
}

_mfEnergyAndMF = merge{_mfEnergyShare, _mfMobileFactories}
_mfQuatronAndMF = merge{_mfQuatronShare, _mfMobileFactories}

-- GUI Settings --
_GUIButtonsSize = 15
_mfGUIDragAreaSize = 25
_mfGUICloseButtonSize = 20
_mfDefaultGuiHeight = 10
_mfDefaultGuiWidth = 10
_mfMainGUIPosX = 300
_mfMainGUIPosY = 0
_mfInfoGUIButtonsSize = 25

-- GUI Name List --
_mfGUIName =
{
	MainGUI = "MFMainGUI",
	InfoGUI = "MFInfoGUI",
	OptionGUI = "MFOptionGUI",
	TooltipGUI = "MFTooltipGUI",
	SwitchMF = "MFSwitchMFGUI",
	TPGUI = "MFTPGUI",
	DeployGUI = "MFDeployGUI",
	SlotGUI = "MFSlotGUI",
	RecipeGUI = "MFRecipeGUI",
	RecipeInfoGUI = "MFRecipeInfoGUI"
}

-- Entity GUI --
_mfTooltipGUI =
{
    DataStorage = "dataStorageTable",
    DeepStorage = "deepStorageTable",
    DeepTank = "deepTankTable",
    FluidExtractor = "fluidExtractorTable",
    OreCleaner = "oreCleanerTable",
    MatterInteractor = "matterInteractorTable",
    FluidInteractor = "fluidInteractorTable",
    DataAssembler = "dataAssemblerTable",
    NetworkExplorer = "networkExplorerTable",
    -- MiningJetFlagMK1 = "jetFlagTable",
    -- MiningJetFlagMK2 = "jetFlagTable",
    -- MiningJetFlagMK3 = "jetFlagTable",
    -- MiningJetFlagMK4 = "jetFlagTable",
    -- MiningJet = "miningJetTable",
    -- ConstructionJet = "constructionJetTable",
    -- RepairJet = "repairJetTable",
    -- CombatJet = "combatJetTable",
	NetworkController = "entsTable",
	QuatronReactor = "entsTable"
}

-- Event Tick --
_eventTick5=5 -- Teleportation --
_eventTick7=7 -- Data Assembler GUI Progress Bars --
_eventTick15=15 -- Mobile Factory Deployment --
_eventTick27=27 -- Mobile Factory Fuel --
-- _eventTick30=30 -- Mobile Factory Sync Area
_eventTick49=49 -- Mobile Factory Lights --
_eventTick55=55 -- GUI --
_eventTick60=60 -- Mobile Factory Lasers/Jump Drive --
_eventTick80=80 -- Mobile Factory Internal Inventory --
_eventTick90=90 -- Mobile Factory Entities Scan --
_eventTick125=125 -- Mobile Factory Modules Scan --
_eventTick150=150 -- Floor Is Lava Update --
_eventTick1200=1200 -- Factory Pollution --

-- Colors --
_mfWhite = {255,255,255}
_mfBlue = {108, 114, 229}
_mfGreen = {92, 232, 54}
_mfPurple = {155, 0, 168}
_mfRed = {231, 5, 5}
_mfOrange = {255, 131, 0}
_mfYellow = {244, 208, 63}

-- Table of Label Style --
_mfLabelType =
{
	yellowTitle = "yellow_label"
}

-- Table of Recipes Unlocked by Initial Research --
_MFStartingRecipes = {"MobileFactory", "DimensionalTile", "mfStone"}