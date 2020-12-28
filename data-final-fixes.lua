-- Highlight Resources --
for k, ore in pairs(data.raw.resource) do
	ore.highlight = true
end

-- Make Dimensional Lab accept all materials --
local inputsTable = {}
if settings.startup["MF-lab-science-packs"].value == "all" then
	for k, lab in pairs(data.raw.lab) do
		for k2, name in pairs(lab.inputs) do
			inputsTable[name] = name
		end
	end
	data.raw.lab.DimensionalLab.inputs = inputsTable

elseif settings.startup["MF-lab-science-packs"].value == "add vanilla" then
	if data.raw.lab.lab then
		for k2, name in pairs(data.raw.lab.lab.inputs) do
			table.insert(data.raw.lab.DimensionalLab.inputs, name)
		end
	else
		log("Basic lab is missing, couldn't add science packs to Dimensional Lab.")
	end

elseif settings.startup["MF-lab-science-packs"].value == "dimensional only" then
	-- Do Nothing --
end

-- Space Exploration is breaking all Mobiles Factories Collision Mask, fixing that here --
if mods["space-exploration"] then
	log("Fixing Space Exploration Collition Mask")
	data.raw["simple-entity-with-owner"].MFDeploy.collision_mask = {"item-layer", "object-layer", "player-layer", "water-tile", "layer-52", "not-colliding-with-itself", "layer-15"}
end