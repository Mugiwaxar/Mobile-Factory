-- TEMP CHEST --

-- Entity --
tcE = table.deepcopy(data.raw.container["iron-chest"])
tcE.type = "container"
tcE.name = "TempChest"
tcE.order = "zzz"
tcE.flags = {}
tcE.minable = {mining_time = 0.8}
tcE.max_health = 9999
tcE.fast_replaceable_group = nil
tcE.inventory_size = 300
data:extend{tcE}