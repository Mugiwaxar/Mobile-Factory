if global.matterInteractorTable == nil then return end

for _, MI in pairs(global.matterInteractorTable) do
	if MI.selectedPlayer == nil then
		if valid(MI.selectedInv) == true then
			MI.selectedPlayer = MI.selectedInv.player
		else
			MI.selectedPlayer = MI.player
		end
	end
end