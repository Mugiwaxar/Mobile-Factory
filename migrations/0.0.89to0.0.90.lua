if global.MF ~= nil and global.MF.fS ~= nil then
    local mapSetting = {
		default_enable_all_autoplace_controls = false,
		property_expression_names = {cliffiness = 0},
		peaceful_mode = true,
		autoplace_settings = {tile = {settings = { ["VoidTile"] = {frequency="normal", size="normal", richness="normal"} }}},
		starting_area = "none",
		width = 0,
		height = 0
	}
    global.MF.fS.map_gen_settings = mapSetting
end

if global.MF ~= nil and global.MF.ccS ~= nil then
    local mapSetting = {
		default_enable_all_autoplace_controls = false,
		property_expression_names = {cliffiness = 0},
		peaceful_mode = true,
		autoplace_settings = {tile = {settings = { ["VoidTile"] = {frequency="normal", size="normal", richness="normal"} }}},
		starting_area = "none",
		width = 0,
		height = 0
	}
    global.MF.ccS.map_gen_settings = mapSetting
end