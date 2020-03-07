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
	for k, MF in pairs(global.MFTable) do
		if MF.ent ~= nil and MF.ent.valid == true then
			MF.lastPosX = MF.ent.position.x
			MF.lastPosY = MF.ent.position.y
			MF.ent.teleport(MF.ent.position, new_surface["newsurface"].name)
			MF.ent = new_surface["newsurface"].find_entity({MF.lastPosX,MF.lastPosY})
		end
	end
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