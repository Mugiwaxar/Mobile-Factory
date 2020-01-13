-- Create the MF object --
if global.mobileFactory ~= nil then
	global.upsysTickTable = {}
	global.entsTable = {}
	game.print("Mobile Factory to OOP Update")
	-- Copy all variables --
	global.MF = MF:new(global.mobileFactory)
	local MF = global.MF
	MF.fS = global.factorySurface
	MF.ccS = global.controlSurface
	MF.fChest = global.factoryChest
	MF.internalEnergy = global.mfInternalEnergy
	MF.maxInternalEnergy = global.mfInternalEnergyMax
	MF.jumpTimer = global.mfJumpTimer
	MF.baseJumpTimer = global.mfBaseJumpTimer
	MF.laserRadiusMultiplier = global.mfEnergyRadiusMult
	MF.laserDrainMultiplier = global.mfEnergyDrainMult
	MF.laserNumberMultiplier = global.mfEnergyLaserMult
	MF.energyLaserActivated = global.mfEnergyLaserActivated
	MF.fluidLaserActivated = global.mfFluidDrainLaserActivated
	MF.itemLaserActivated = global.mfItemDistributionActivated
	MF.internalEnergyDistributionActivated = global.mfEnergyDistributionActivated
	
	
	-- Set old variables to nil --
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
end