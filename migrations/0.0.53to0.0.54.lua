-- Remove the RedCross Fluid --
for k, tank in pairs(global.tankTable) do
	if tank.filter == "RedCross" then tank.filter = nil end
end