-- Highlight Resources --
for k, ore in pairs(data.raw.resource) do
	ore.highlight = true
end

-- Make Dimensional Lab accept all materials --
local inputsTable = {}
for k, lab in pairs(data.raw.lab) do
	for k2, name in pairs(lab.inputs) do
		inputsTable[name] = name
	end
end
data.raw.lab.DimensionalLab.inputs = inputsTable