local distanceVars = {
  ["MiningJet"] = "mj",
  ["ConstructionJet"] = "cj",
  ["RepairJet"] = "rj",
  ["CombatJet"] = "cbj"
}

local MF = nil
local jet = nil
local prefix = nil
local jetkey = nil
for _, MF in pairs(global.MFTable) do
	if MF.varTable and MF.varTable.jets then
		for jet, prefix in pairs(distanceVars) do
			jetkey = prefix.."MaxDistance"
			if MF.varTable.jets[jetkey] == nil or MF.varTable.jets[jetkey] <= 10 or MF.varTable.jets[jetkey] > 1000 then
				log(jet .. " distance out of bounds, changing to " .. _G["_MF"..jet.."DefaultMaxDistance"])
				MF.varTable.jets[jetkey] = _G["_MF"..jet.."DefaultMaxDistance"]
			end
		end
	end
end