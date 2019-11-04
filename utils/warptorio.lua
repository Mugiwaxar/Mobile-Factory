function warptorio()
-- Warptorio2 compatibility --
	if remote.interfaces["warptorio2"] then 
		--remote.call("warptorio2","insert_warp_blacklist","Mobile_Factory","MobileFactory")
		script.on_event(remote.call("warptorio2","event_warp"), beforeWarp)
		script.on_event(remote.call("warptorio2","event_post_warp"), afterWarp)
	end
end

-- Called before a Warptorio2 Warp --
function beforeWarp(new_surface, new_planet_table, old_surface, old_planet_table)
	global.MF.lastPosX = global.MF.ent.position.x
	global.MF.lastPosY = global.MF.ent.position.y
	-- global.MF.ent = nil
	global.MF.ent.teleport(global.MF.ent.position, new_surface["newsurface"].name)
	global.MF.ent = new_surface["newsurface"].find_entity("MobileFactory", {global.MF.lastPosX,global.MF.lastPosY})
end

-- Called after a Warptorio2 Warp --
function afterWarp(new_surface, new_planet_table)
	-- global.MF.ent = new_surface["newsurface"].find_entity("MobileFactory", {global.MF.lastPosX,global.MF.lastPosY})
	-- if global.MF.ent == nil then
		-- game.print("Mobile Factory lost")
		-- game.print("You can get a new one with the command /GetMobileFactory")
	-- else
		-- newMobileFactory(global.MF)
	-- end
end