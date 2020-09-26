-- RESOURCE CATCHER OBJECT --

-- List of Water Tile --
local waterTileList = {deepwater=true, ["deepwater-green"]=true, water=true, ["water-green"]=true,
                      ["water-mud"]=true, ["water-shallow"]=true}

-- Create the Resource Catcher base Object --
RC = {
    ent = nil,
    entID = 0,
	player = "",
	MF = nil,
    lightID = 0,
    spriteID = 0,
    updateTick = 100,
    justCreated = true,
    filled = false,
    haveResource = false,
    resourceName = nil,
    resourceAmount = nil,
	lastUpdate = 0
}

-- Constructor --
function RC:new(ent)
	local t = {}
	local mt = {}
	setmetatable(t, mt)
    mt.__index = RC
    t.ent = ent
    t.entID = ent.unit_number
    t.player = ent.last_user.name
    t.MF = getMF(t.player)
    -- Draw the Light Sprite --
    t.lightID = rendering.draw_light{sprite="ResourceCatcher", target=t.ent, surface=t.ent.surface, minimum_darkness=0}
    UpSys.addObj(t)
	return t
end

-- Reconstructor --
function RC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = RC
	setmetatable(object, mt)
end

-- Destructor --
function RC:remove()
    -- Destroy the Light --
    rendering.destroy(self.lightID)
    rendering.destroy(self.spriteID)
    -- Remove from the Update System --
	UpSys.removeObj(self)
end

-- Is valid --
function RC:valid()
    if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Update --
function RC:update()

	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	
	-- Check the Validity --
	if self.ent == nil or self.ent.valid == false then
		return
    end

    -- Draw the Green Sprite if needed --
    if self.haveResource == true then
        self.spriteID = rendering.draw_sprite{sprite="ResourceCatcher", target=self.ent, surface=self.ent.surface}
    end

    -- Allow to Update next time --
    if self.justCreated == true then
        self.justCreated = false
        return
    end

    -- Check if the Resource Catcher already has a Resource inside --
    if self.haveResource == true then
        -- Check if there is a Dimensionnal Tile below --
        local tile = self.ent.surface.get_tile(self.ent.position.x, self.ent.position.y)
        if tile ~= nil and tile.valid == true and tile.name == "DimensionalTile" then
            if game.tile_prototypes[self.resourceName] ~= nil then
                -- If this is a Tile --
                self.ent.surface.set_tiles({{name=self.resourceName, position=self.ent.position}})
                self.ent.destroy()
                return
            elseif game.entity_prototypes[self.resourceName] ~= nil then
                -- If this is a Resource, check if the Position is valid --
                if self.ent.surface.can_place_entity{name=self.resourceName, position=self.ent.position} then
                    -- Create the Entity --
                    self.ent.surface.create_entity{name=self.resourceName, position=self.ent.position, amount=self.resourceAmount}
                    self.ent.destroy()
                    return
                else
                    -- The Resource can't be placed here --
                    game.players[self.player].create_local_flying_text{text={"info.CantPlaceResourceHere"}, position=self.ent.position}
                end
            else
                -- The resource doesn't exist anymore --
                game.players[self.player].create_local_flying_text{text={"info.ResourceMissing"}, position=self.ent.position}
            end
        else
            -- The Resource Catcher is not on a Dimensional Tile --
            game.players[self.player].create_local_flying_text{text={"info.NoDimTile"}, position=self.ent.position}
        end
        return
    end

    -- Stop Updating if the Resource Catcher is filled --
    if self.filled == true then return end

    -- Create the Variables --
    local isTile = false
    local resource = nil

    -- Try to find Water --
    local tile = self.ent.surface.get_tile(self.ent.position.x, self.ent.position.y)
    if tile ~= nil and tile.valid == true and waterTileList[tile.name] == true then
        isTile = true
        resource = tile
    end

    -- Try to find a Ore/Fluid Path --
    if resource == nil then
        local path = self.ent.surface.find_entities_filtered{position=self.ent.position, type="resource", limit=1}
        if path[1] ~= nil and path[1].valid == true then resource = path[1] end
    end

    -- Check the Ressource --
    if resource ~= nil and (game.tile_prototypes[resource.name] ~= nil or game.entity_prototypes[resource.name] ~= nil) then
        if game.players[self.player] ~= nil then
            -- Create the Text and remove the Resource (Exept Water) --
            local text = ""
            if isTile == true or resource.amount == nil or resource.amount <= 0 then
                self.resourceName = resource.name
                text = {"", game.tile_prototypes[resource.name].localised_name, " ", {"info.Caught"}}
            else
                self.resourceName = resource.name
                self.resourceAmount = resource.amount
                text = {"", resource.amount, " ", game.entity_prototypes[resource.name].localised_name, " ", {"info.Caught"}}
                resource.destroy()
            end
            game.players[self.player].create_local_flying_text{text=text, position=self.ent.position}
        end
    else
        -- If no Resource was found --
        local text = {"", {"info.NoCatch"}}
        game.players[self.player].create_local_flying_text{text=text, position=self.ent.position}
        return
    end


    -- Create the Smoke --
    self.ent.surface.create_trivial_smoke{name="nuclear-smoke", position=self.ent.position}

    -- Draw the Green Sprite --
    self.spriteID = rendering.draw_sprite{sprite="ResourceCatcher", target=self.ent, surface=self.ent.surface}

    -- Set the Resource Catcher filled --
    self.filled = true

end

-- Item Tags to Content --
function RC:itemTagsToContent(tags)
    self.resourceName = tags.resourceName
    self.resourceAmount = tags.resourceAmount
    if self.resourceName ~= nil then
        self.haveResource = true
        self.filled = true
    end
end

-- Content to Item Tags --
function RC:contentToItemTags(tags)
    -- Get the Resource Localized Name --
    local locResourceName = ""
    if game.tile_prototypes[self.resourceName] ~= nil then
        -- Get the Tile Name --
        locResourceName = game.tile_prototypes[self.resourceName].localised_name
    elseif game.entity_prototypes[self.resourceName] ~= nil then
        -- Get the Resource Name --
        locResourceName = game.entity_prototypes[self.resourceName].localised_name
    else
        -- The Prototype doesn't exist anymore --
        return
    end
    -- Create the Tooltips --
    if self.resourceAmount == nil then
        tags.set_tag("Infos", {resourceName=self.resourceName})
        tags.custom_description = {"", tags.prototype.localised_description, {"item-description.ResourceCatcherC1", locResourceName}}
    else
        tags.set_tag("Infos", {resourceName=self.resourceName, resourceAmount=self.resourceAmount})
        tags.custom_description = {"", tags.prototype.localised_description, {"item-description.ResourceCatcherC2", locResourceName, Util.toRNumber(self.resourceAmount)}}
    end
end
 
-- Tooltip Infos --
-- function RC:getTooltipInfos(GUI)
-- end