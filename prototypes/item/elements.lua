------------------------------- ELEMENTS ---------------------------
require("prototypes/item/elements-functions.lua")


-- Oxygen --
createElement("mfOxygen", 8, "fluid", {207,218,255})
-- Hydrogen --
createElement("mfHydrogen", 1, "fluid", {255,249,50})
-- Chlorine --
createElement("mfChlorine", 17, "fluid", {224,255,100})
-- Sodium --
createElement("mfSodium", 11, "item", {196,196,196})
-- Salt --
createElement("mfSalt", 0, "item", {232,232,232})
-- Sodium hydroxide --
createElement("mfSodiumHydroxide", 0, "item", {232,232,232})
-- Uranium --
createElement("mfUranium", 92, "fluid", {42,234,0})

-- Electrolyze --
createRecipe("Electrolyze", {{"fluid", "water", 300}}, {{"fluid", "mfOxygen", 100},{"fluid", "mfHydrogen", 200}})
createRecipe("WaterReaction", {{"fluid", "mfOxygen", 100},{"fluid", "mfHydrogen", 200}}, {{"fluid", "water", 300}})
createTechnology("Electrolyze", {300, 2, {{"DimensionalSample",1}}}, {"DimensionalPlant"}, {"Electrolyze", "WaterReaction"})

-- Stone crushing --
createRecipe("StoneCrushing", {{"item", "stone", 1}}, {{"item", "mfSalt", 10}})
createTechnology("StoneCrushing", {350, 2, {{"DimensionalSample",1}}}, {"DimensionalPlant"}, {"StoneCrushing"})

-- Salt decomposition -
createRecipe("SaltDecomposition", {{"item", "mfSalt", 1}}, {{"fluid", "mfChlorine", 5},{"item", "mfSodium", 5}})
createTechnology("SaltDecomposition", {420, 2, {{"DimensionalSample",1}}}, {"StoneCrushing"}, {"SaltDecomposition"})

-- Sodium hydration --
createRecipe("SodiumHydration", {{"item", "mfSodium", 20}, {"fluid", "water", 20}}, {{"item", "mfSodiumHydroxide", 20}, {"fluid", "mfHydrogen", 20}})
createTechnology("SodiumHydration", {580, 2, {{"DimensionalSample",1}}}, {"SaltDecomposition"}, {"SodiumHydration"})

-- Uranium liquefaction --
createRecipe("UraniumLiquefaction", {{"item", "uranium-ore", 10}}, {{"fluid", "mfUranium", 10}})
createTechnology("UraniumLiquefaction", {520, 2, {{"DimensionalSample",1}}}, {"DimensionalPlant"}, {"UraniumLiquefaction"})

-- Logistic Science Pack --
createRecipe("LogisticSciencePack", {{"fluid", "mfHydrogen", 30}, {"fluid", "mfChlorine", 10}}, {{"item", "logistic-science-pack", 1}}, "SciencePack")
createTechnology("LogisticSciencePack", {600, 2, {{"DimensionalSample",1}}}, {"DimensionalPlant"}, {"LogisticSciencePack"})

-- Automation Science Pack --
createRecipe("AutomationSciencePack", {{"fluid", "mfOxygen", 50}, {"fluid", "DimensionalFluid", 70}, {"item", "mfSodiumHydroxide", 10}}, {{"item", "automation-science-pack", 1}}, "SciencePack")
createTechnology("AutomationSciencePack", {1000, 2, {{"DimensionalSample",1}}}, {"DimensionalPlant"}, {"AutomationSciencePack"})






