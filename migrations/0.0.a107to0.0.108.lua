-- Save Internal Data Center inside MF object --
for k, dcmf in pairs(global.dataCenterTable) do
	if dcmf.invObj.isII and dcmf.ent.last_user.name ~= nil then
		local MF = getMF(dcmf.ent.last_user.name)
		if MF ~= nil then
			MF.dataCenter = dcmf
		end
	end
end