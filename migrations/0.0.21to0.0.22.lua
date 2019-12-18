require("utils/functions.lua")
if global.mobileFactory ~= nil then
	global.mobileFactory.force = "player"
end

if global.controlSurface ~= nil then
	game.print("Migration 0.0.21 to 0.0.22 ")
	local tanks = global.controlSurface.find_entities({{-65,-17},{-9,-3}})
	local tank1Fname
	local tank1Famount = 0
	local tank2FName
	local tank2Famount = 0
	local tank3Name
	local tank3Famount = 0
	for k, tank in pairs(tanks) do
		-- Tank 1 MK1 --
		if tank.name == "StorageTank1MK1" then
			local fluid = tank.get_fluid_contents()
			if fluid ~= nil then
				for fName, fAmount in pairs(fluid) do
					tank1Fname = fName
					tank1Famount = fAmount
				end
			end
		end
		-- Tank 2 MK1 --
		if tank.name == "StorageTank2MK1" then
			local fluid = tank.get_fluid_contents()
			if fluid ~= nil then
				for fName, fAmount in pairs(fluid) do
					tank2Fname = fName
					tank2Famount = fAmount
				end
			end
		end
		-- Tank 3 MK1 --
		if tank.name == "StorageTank3MK1" then
			local fluid = tank.get_fluid_contents()
			if fluid ~= nil then
				for fName, fAmount in pairs(fluid) do
					tank3Fname = fName
					tank3Famount = fAmount
				end
			end
		end
		-- Tank 1 MK2 --
		if tank.name == "StorageTank1MK2" then
			local fluid = tank.get_fluid_contents()
			if fluid ~= nil then
				for fName, fAmount in pairs(fluid) do
					if fAmount > tank1Famount then
						tank1Fname = fName
						tank1Famount = fAmount
					end
				end
			end
		end
		-- Tank 2 MK2 --
		if tank.name == "StorageTank2MK2" then
			local fluid = tank.get_fluid_contents()
			if fluid ~= nil then
				for fName, fAmount in pairs(fluid) do
					if fAmount > tank2Famount then
						tank2Fname = fName
						tank2Famount = fAmount
					end
				end
			end
		end
		-- Tank 3 MK2 --
		if tank.name == "StorageTank3MK2" then
			local fluid = tank.get_fluid_contents()
			if fluid ~= nil then
				for fName, fAmount in pairs(fluid) do
					if fAmount > tank3Famount then
						tank3Fname = fName
						tank3Famount = fAmount
					end
				end
			end
		end
		tank.destroy()
	end
	
	-- Tank 1 --
	if technologyUnlocked("StorageTankMK2_1") == true then
		local entity = createEntity(global.controlSurface, -17, -9, "StorageTank1MK2", "player")
 		if tank1Famount > 0 then
			entity.insert_fluid({name=tank1Fname, amount=tank1Famount})
		end
		global.tankTable[1] = {name="StorageTank1MK2", position={-17,-9}}
	elseif technologyUnlocked("StorageTankMK1_1") then
		local entity = createEntity(global.controlSurface, -17, -9, "StorageTank1MK1", "player")
		if tank1Famount > 0 then
			entity.insert_fluid({name=tank1Fname, amount=tank1Famount})
		end
		global.tankTable[1] = {name="StorageTank1MK1", position={-17,-9}}
	end
		
	-- Tank 2 --
	if technologyUnlocked("StorageTankMK2_2") == true then
		local entity = createEntity(global.controlSurface, -35, -9, "StorageTank2MK2", "player")
		if tank2Famount > 0 then
			entity.insert_fluid({name=tank2Fname, amount=tank2Famount})
		end
		global.tankTable[2] = {name="StorageTank2MK2", position={-35,-9}}
	elseif technologyUnlocked("StorageTankMK1_2") then
		local entity = createEntity(global.controlSurface, -35, -9, "StorageTank2MK1", "player")
		if tank2Famount > 0 then
			entity.insert_fluid({name=tank2Fname, amount=tank2Famount})
		end
		global.tankTable[2] = {name="StorageTank2MK1", position={-35,-9}}
	end
	
	-- Tank 3 --
	if technologyUnlocked("StorageTankMK2_3") == true then
		local entity = createEntity(global.controlSurface, -53, -9, "StorageTank3MK2", "player")
		if tank3Famount > 0 then
			entity.insert_fluid({name=tank3Fname, amount=tank3Famount})
		end
		global.tankTable[3] = {name="StorageTank3MK2", position={-53,-9}}
	elseif technologyUnlocked("StorageTankMK1_3") then
		local entity = createEntity(global.controlSurface, -53, -9, "StorageTank3MK1", "player")
		if tank3Famount > 0 then
			entity.insert_fluid({name=tank3Fname, amount=tank3Famount})
		end
		global.tankTable[3] = {name="StorageTank3MK1", position={-53,-9}}
	end
end




