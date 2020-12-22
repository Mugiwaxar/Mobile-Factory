------------------------------- ELEMENTS ---------------------------
require("prototypes/item/elements-functions.lua")


-- Oxygen --
createElement("mfOxygen", 8, "fluid", {207,218,255})
-- Hydrogen --
createElement("mfHydrogen", 1, "fluid", {255,249,50},"30kJ")
-- Chlorine --
createElement("mfChlorine", 17, "fluid", {224,255,100})
-- Sodium --
createElement("mfSodium", 11, "item", {196,196,196})
-- Silicon --
createElement("mfSilicon", 14, "item", {196,196,196})
-- Salt water 
createElement("mfSaltWater", 17, "fluid", {224,255,100})
-- Salt --
createElement("mfSalt", 0, "item", {232,232,232})
-- Sodium hydroxide --
createElement("mfSodiumHydroxide", 0, "item", {232,232,232})
-- Graphite --
createElement("mfGraphite", 6, "item", {232,232,232})
-- Uranium --
createElement("mfUranium", 92, "fluid", {42,234,0})
-- Clorodin --
createElement("mfClorodin", 0, "item", {42,234,0})
-- Hydroxyclorodin --
createElement("mfHydroxyclorodin", 0, "item", {42,234,0})
-- Nanopore Silicon --
createElement("mfNanoporeSilicon", 0, "item", {42,234,0})
-- Sand --
createElement("mfSand", 0, "item", {42,234,0})
-- Fluoroclorodin --
createElement("mfFluorodin", 0, "fluid", {42,234,0})
-- FluoroclorodinII --
createElement("mfFluorodinII", 0, "fluid", {42,234,0})
-- FluoroclorodinIII --
createElement("mfFluorodinIII", 0, "fluid", {42,234,0})


-- Fluoroclorodin -- 
createRecipe("mfFluorodin", {{"fluid", "DimensionalFluid", 50}, {"fluid", "mfUranium", 50}, {"item", "mfNanoporeSilicon", 10}}, {{"fluid", "mfFluorodin", 100}},2)
createTechnology("mfFluorodin", {300, 2, {{"DimensionalSample",1}}}, {"UraniumLiquefaction"}, {"mfFluorodin"})

-- FluoroclorodinII -- 
createRecipe("mfFluorodinII", {{"fluid", "mfFluorodin", 50}, {"fluid", "mfUranium", 50}, {"item", "mfNanoporeSilicon", 5}}, {{"fluid", "mfFluorodinII", 100}},2)
createTechnology("mfFluorodinII", {300, 2, {{"DimensionalSample",1}}}, {"mfFluorodin"}, {"mfFluorodinII"})

-- FluoroclorodinIII -- 
createRecipe("mfFluorodinIII", {{"fluid", "mfFluorodinII", 50}, {"fluid", "mfUranium", 50}, {"item", "mfNanoporeSilicon", 5}}, {{"fluid", "mfFluorodinIII", 100}},2)
createTechnology("mfFluorodinIII", {300, 2, {{"DimensionalSample",1}}}, {"mfFluorodinII"}, {"mfFluorodinIII"})

-- Nanopore Silicon --
createRecipe("mfNanoporeSilicon", {{"item", "mfSilicon", 8},{"fluid", "mfOxygen", 10}}, {{"item", "mfNanoporeSilicon", 2}})
createTechnology("mfNanoporeSilicon", {300, 2, {{"DimensionalSample",1}}}, {"mfSilicon"}, {"mfNanoporeSilicon"})

-- Clorodin -- 
createRecipe("mfClorodin", {{"item", "DimensionalOre", 20},{"fluid", "mfChlorine", 11}}, {{"item", "mfClorodin", 25}})
createTechnology("mfClorodin", {300, 2, {{"DimensionalSample",1}}}, {"SaltDecomposition"}, {"mfClorodin"})

-- Hydroxyclorodin --
createRecipe("mfHydroxyclorodin", {{"item", "mfClorodin", 11},{"fluid", "water", 20}}, {{"item", "mfHydroxyclorodin", 20},{"fluid", "mfHydrogen",3}})
createTechnology("mfHydroxyclorodin", {300, 2, {{"DimensionalSample",1}}}, {"mfClorodin"}, {"mfHydroxyclorodin"})

-- Electrolyze --
createRecipe("Electrolyze", {{"fluid", "water", 18}}, {{"fluid", "mfOxygen", 16},{"fluid", "mfHydrogen", 2}},2)
createRecipe("WaterReaction", {{"fluid", "mfOxygen", 100},{"fluid", "mfHydrogen", 200}}, {{"fluid", "water", 1000}})
createTechnology("Electrolyze", {300, 2, {{"DimensionalSample",1}}}, {"DimensionalPlant"}, {"Electrolyze", "WaterReaction"})

-- Silicon --
createRecipe("mfSilicon", {{"item", "mfSand", 31}}, {{"fluid", "mfOxygen", 8},{"item", "mfSilicon", 14},{"item", "iron-ore", 1}})
createTechnology("mfSilicon", {420, 2, {{"DimensionalSample",1}}}, {"SaltDecomposition"}, {"mfSilicon"})

-- Salt decomposition -
createRecipe("StoneCrushing", {{"item", "stone", 16},{"fluid", "water", 57}}, {{"fluid", "mfSaltWater", 60},{"item", "mfSand", 13}})
createRecipe("mfSalt", {{"fluid", "mfSaltWater", 600}}, {{"item", "mfSalt", 29}},2)
createRecipe("SaltDecomposition", {{"item", "mfSalt", 58}}, {{"fluid", "mfChlorine", 35},{"item", "mfSodium", 23}},10)
createTechnology("SaltDecomposition", {420, 2, {{"DimensionalSample",1}}}, {"DimensionalPlant"}, {"SaltDecomposition", "mfSalt", "StoneCrushing"})

-- Graphite Composition--
createRecipe("mfGraphite", {{"item", "coal", 10}},{{"item", "mfGraphite", 6},{"item", "sulfur", 1},{"fluid", "water", 3}})
createTechnology("mfGraphite", {420, 2, {{"DimensionalSample",1}}}, {"DimensionalPlant"}, {"mfGraphite"})

-- Sodium hydration --
createRecipe("SodiumHydration", {{"item", "mfSodium", 23}, {"fluid", "water", 18}}, {{"item", "mfSodiumHydroxide", 40}, {"fluid", "mfHydrogen", 1}})
createTechnology("SodiumHydration", {580, 2, {{"DimensionalSample",1}}}, {"SaltDecomposition"}, {"SodiumHydration"})

-- Uranium liquefaction --
createRecipe("UraniumLiquefaction", {{"item", "uranium-ore", 5},{"fluid", "DimensionalFluid", 5}}, {{"fluid", "mfUranium", 10}})
createTechnology("UraniumLiquefaction", {520, 2, {{"DimensionalSample",1}}}, {"DimensionalPlant"}, {"UraniumLiquefaction"})

-- Logistic Science Pack --
createRecipe("LogisticSciencePack", {{"fluid", "mfHydrogen", 30}, {"fluid", "mfChlorine", 10}}, {{"item", "logistic-science-pack", 1}})
createTechnology("LogisticSciencePack", {600, 2, {{"DimensionalSample",1}}}, {"DimensionalPlant"}, {"LogisticSciencePack"})

-- Automation Science Pack --
createRecipe("AutomationSciencePack", {{"fluid", "mfOxygen", 50}, {"fluid", "DimensionalFluid", 70}, {"item", "mfSodiumHydroxide", 10}}, {{"item", "automation-science-pack", 1}})
createTechnology("AutomationSciencePack", {1000, 2, {{"DimensionalSample",1}}}, {"DimensionalPlant"}, {"AutomationSciencePack"})






