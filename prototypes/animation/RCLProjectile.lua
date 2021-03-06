-- RCL Projectiles --
function createRCLProjectile(ore)
	local ocOP = {}
	ocOP.name = "RCLProjectile:" .. ore.name
	ocOP.type = "projectile"
	ocOP.acceleration = 0
    local icon = ore.icon or ore.icons[1].icon
    local iconSize = ore.icon_size or ore.icons[1].icon_size
	ocOP.animation = {
		filename = icon,
		size = iconSize,
		draw_as_glow = true,
		frame_count = 1,
		scale = 1/iconSize*32
	}
	data:extend{ocOP}
end

for _, resource in pairs(data.raw.resource) do
	if resource.minable ~= nil then
		if resource.minable.result ~= nil then
			if data.raw.item[resource.minable.result] ~= nil then
				createRCLProjectile(data.raw.item[resource.minable.result])
			elseif data.raw.fluid[resource.minable.result] ~= nil then
				createRCLProjectile(data.raw.fluid[resource.minable.result])
			end
		elseif resource.minable.results ~= nil then
			for _, result in pairs(resource.minable.results) do
				if data.raw.item[result.name] ~= nil then
					createRCLProjectile(data.raw.item[result.name])
				elseif data.raw.fluid[result.name] ~= nil then
					createRCLProjectile(data.raw.fluid[result.name])
				end
			end
		end
	end
end