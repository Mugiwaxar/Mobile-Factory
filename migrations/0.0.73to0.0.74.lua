-- Remove wrong Selected Inventories --
for k, ms in pairs(global.matterSerializerTable or {}) do
	if ms.selectedInv ~= nil and ms.selectedInv.name ~= nil then
		 ms.selectedInv = 0
	end
end
for k, mp in pairs(global.matterPrinterTable or {}) do
	if mp.selectedInv ~= nil and mp.selectedInv.name ~= nil then
		 mp.selectedInv = 0
	end
end
for k, oc in pairs(global.oreCleanerTable or {}) do
	if oc.selectedInv ~= nil and oc.selectedInv.name ~= nil then
		 oc.selectedInv = 0
	end
end
for k, jf in pairs(global.jetFlagTable or {}) do
	if jf.selectedInv ~= nil and jf.selectedInv.name ~= nil then
		 jf.selectedInv = 0
	end
end