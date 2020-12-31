-- Highlight Resources --
for k, ore in pairs(data.raw.resource) do
	ore.highlight = true
end

-- Make Dimensional Lab accept all materials --
if settings.startup["MF-lab-science-packs"].value == "all" then
	local inputsTable = {}
	for k, lab in pairs(data.raw.lab) do
		for k2, name in pairs(lab.inputs) do
			inputsTable[name] = name
		end
	end
	data.raw.lab.DimensionalLab.inputs = inputsTable

elseif settings.startup["MF-lab-science-packs"].value == "add vanilla" then
	local inputsTable = {}
	if data.raw.lab.lab then
		for _, name in pairs(data.raw.lab.DimensionalLab.inputs) do
			inputsTable[name] = name
		end
		for _, name in pairs(data.raw.lab.lab.inputs) do
			inputsTable[name] = name
		end
		data.raw.lab.DimensionalLab.inputs = inputsTable
	else
		log("Basic lab is missing, couldn't add science packs to Dimensional Lab.")
	end

elseif settings.startup["MF-lab-science-packs"].value == "dimensional only" then
	-- Do Nothing --
end

-- Space Exploration is breaking all Mobiles Factories Collision Mask, fixing that here --
if mods["space-exploration"] then
	log("Fixing Space Exploration Collition Mask")
	data.raw["simple-entity-with-owner"].MFDeploy.collision_mask = {"player-layer", "train-layer", "consider-tile-transitions", "layer-52", "not-colliding-with-itself", "layer-15"}
end