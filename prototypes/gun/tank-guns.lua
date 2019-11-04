-- The modified weapons of the tank --

-- Canon --
tcn = table.deepcopy(data.raw.gun["tank-cannon"])
tcn.name = "mfTank-cannon"
tcn["attack_parameters"]["range"] = data.raw.gun["tank-cannon"]["attack_parameters"]["range"] + 30
data:extend{tcn}

-- Flame Thrower --
tft = table.deepcopy(data.raw.gun["tank-flamethrower"])
tft.name = "mfTank-flamethrower"
tft["attack_parameters"]["range"] = data.raw.gun["tank-flamethrower"]["attack_parameters"]["range"] + 30
data:extend{tft}

-- Machine Gun --
tmg = table.deepcopy(data.raw.gun["tank-machine-gun"])
tmg.name = "mfTank-machine-gun"
tmg["attack_parameters"]["range"] = data.raw.gun["tank-machine-gun"]["attack_parameters"]["range"] + 30
data:extend{tmg}