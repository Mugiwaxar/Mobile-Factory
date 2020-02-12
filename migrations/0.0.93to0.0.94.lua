-- Clear Wireless Data Transmitters Signals --
for k, DT in pairs(global.wirelessDataTransmitterTable or {}) do
	DT.lastSignal = {}
	if DT.ent ~= nil and DT.ent.valid == true and DT.ent.get_control_behavior() ~= nil then
		dprint("nil")
		DT.ent.get_control_behavior().parameters = nil
	end
end

-- Clear Wireless Data Receivers Signals --
for k, DR in pairs(global.wirelessDataReceiverTable or {}) do
	DR.lastSignal = {}
	if DR.ent ~= nil and DR.ent.valid == true and DR.ent.get_control_behavior() ~= nil then
		DR.ent.get_control_behavior().parameters = nil
	end
end

-- Clear the Data Network Signal Table --
for K, DN in pairs(global.dataNetworkTable or {}) do
	DN.signalsTable = {}
end