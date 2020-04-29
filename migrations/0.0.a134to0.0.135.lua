
for _, MF in pairs(global.MFTable) do
	if MF.varTable and MF.varTable.jets then
		MF.varTable.jets.cjTableSize = 1000
	end
end