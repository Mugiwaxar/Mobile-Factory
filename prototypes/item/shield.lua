-- MOBILE FACTORY SHIELD --


------- Shield -------
-- Item --
local shI = {}
shI.type = "item"
shI.name = "mfShieldEquipment"
shI.icon = "__Mobile_Factory_Graphics__/graphics/effects/shield.png"
shI.placed_as_equipment_result = "mfShieldEquipment"
shI.icon_size = 556
shI.subgroup = "MobileFactory"
shI.order = "z"
shI.stack_size = 1
data:extend{shI}

-- Equipement --
local shE = {}
shE.name = "mfShieldEquipment"
shE.type = "energy-shield-equipment"
shE.energy_per_shield = "1J"
shE.max_shield_value = 1000
shE.categories = {"mfEquipments"}
shE.sprite = {filename="__Mobile_Factory_Graphics__/graphics/effects/shield.png", size=556}
shE.shape = {width=3, height=3, type="full"}
shE.energy_source = 
{
	type="electric",
	usage_priority="tertiary",
	input_flow_limit="0J",
	output_flow_limit="0J",
	buffer_capacity="0J"
}
data:extend{shE}

-- Recipe --
local shR = {}
shR.type = "recipe"
shR.name = "mfShieldEquipment"
shR.energy_required = 5
shR.enabled = false
shR.ingredients =
    {
		{"CrystalizedCircuit", 50}
    }
shR.result = "mfShieldEquipment"
data:extend{shR}

-- Technology --
local shT = {}
shT.name = "MFShield"
shT.type = "technology"
shT.icon = "__Mobile_Factory_Graphics__/graphics/icons/shield.png"
shT.icon_size = 64
shT.unit = {
	count = 5,
	time = 60,
	ingredients={
		{"DimensionalSample", 200},
		{"DimensionalCrystal", 5}
	}
}
shT.prerequisites =  {"DimensionalCrystal"}
shT.effects = {{type="unlock-recipe", recipe="mfShieldEquipment"}}
data:extend{shT}