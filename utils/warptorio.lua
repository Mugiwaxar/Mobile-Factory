function warptorio()
-- Warptorio2 compatibility --
	if remote.interfaces["warptorio2"] then 
		--remote.call("warptorio2","insert_warp_blacklist","Mobile_Factory","MobileFactory")
		script.on_event(remote.call("warptorio2", "get_event", "on_warp"), beforeWarp)
		script.on_event(remote.call("warptorio2","get_event", "on_post_warp"), afterWarp)
	end
end

-- Called before a Warptorio2 Warp --
function beforeWarp(new_surface, new_planet_table, old_surface, old_planet_table)
	for k, MF in pairs(global.MFTable) do
		if MF.ent ~= nil and MF.ent.valid == true then
			MF.ent.teleport(MF.ent.position, new_surface["newsurface"].name)
		end
	end
end

-- Called after a Warptorio2 Warp --
function afterWarp(new_surface, new_planet_table)
end