-- Convert Dimensional Tanks to Deep Tank and create the Constructible Area --
for k, MF in pairs(global.MFTable) do
    if MF.varTable.tanks ~= nil and table_size(MF.varTable.tanks) > 0 then
        createTilesSurface(MF.ccS, -90, -27, -10, -15, "BuildTile")
        for k2, tank in pairs(MF.varTable.tanks) do
            local ent = createEntity(MF.ccS, tank.ent.position.x, tank.ent.position.y - 10, "DeepTank", getForce(MF.player).name)
            ent.last_user = MF.player
            placedDeepTank({created_entity = ent})
            local obj = global.deepTankTable[ent.unit_number]
            local fluid = nil
            local amount = nil
            local filter = tank.filter
            for k3, i in pairs(tank.ent.get_fluid_contents()) do
				fluid = k3
				amount = math.floor(i)
            end
            obj.inventoryFluid = fluid
            obj.inventoryCount = amount
            obj.filter = filter
            tank.ent.destroy()
            local player = getPlayer(MF.player)
            player.force.technologies["DeepTank"].researched = true
            createDeepTankArea(MF)
        end
    end
    createTilesSurface(MF.ccS, -92, -3, -90, 3, "VoidTile")
    createTilesSurface(MF.ccS, -4, 10, 3, 14, "VoidTile")
    MF.varTable.tanks = nil
end