----------------------------- Quatron------------------------
require("prototypes/item/quatron-functions.lua")

createQuatron(1, {{"fluid", "DimensionalFluid", 100}, {"fluid", "mfHydrogen",250}})
createQuatron(3, {{"item", "Quatron1",1}, {"item", "stone",10}}, 1)
createQuatron(5, {{"item", "Quatron3",1}, {"fluid", "water",250}}, 3)
createQuatron(7, {{"item", "Quatron5",1}, {"fluid", "mfOxygen",400}}, 5)
createQuatron(10, {{"item", "Quatron7",1}, {"item", "DimensionalCrystal",1}}, 7)
createQuatron(13, {{"item", "Quatron10",1}, {"fluid", "mfChlorine", 100}}, 10)
createQuatron(15, {{"item", "Quatron13",1}, {"item", "mfSodiumHydroxide", 100}}, 13)
createQuatron(20, {{"item", "Quatron15",1}, {"fluid", "mfUranium", 150}}, 15)