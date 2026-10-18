local floor = math.floor

local function tile_destroys_dropped_items(prototype)
	return prototype ~= nil and (prototype.name == "empty-space" or prototype.destroys_dropped_items == true)
end

local function apply_safety_filter(inserter)
	inserter.use_filters = true
	inserter.inserter_filter_mode = "whitelist"
	for i = 1, inserter.filter_slot_count do
		inserter.set_filter(i, nil)
	end
end

local target_entity_types = {
	["accumulator"] = true,
	["agricultural-tower"] = true,
	["ammo-turret"] = true,
	["arithmetic-combinator"] = true,
	["artillery-turret"] = true,
	["assembling-machine"] = true,
	["asteroid-collector"] = true,
	["beacon"] = true,
	["boiler"] = true,
	["burner-generator"] = true,
	["cargo-bay"] = true,
	["cargo-landing-pad"] = true,
	["constant-combinator"] = true,
	["container"] = true,
	["curved-rail-a"] = true,
	["curved-rail-b"] = true,
	["decider-combinator"] = true,
	["display-panel"] = true,
	["electric-energy-interface"] = true,
	["electric-pole"] = true,
	["electric-turret"] = true,
	["fluid-turret"] = true,
	["furnace"] = true,
	["fusion-generator"] = true,
	["fusion-reactor"] = true,
	["gate"] = true,
	["generator"] = true,
	["half-diagonal-rail"] = true,
	["heat-interface"] = true,
	["heat-pipe"] = true,
	["infinity-container"] = true,
	["infinity-pipe"] = true,
	["inserter"] = true,
	["lab"] = true,
	["lamp"] = true,
	["lane-splitter"] = true,
	["legacy-curved-rail"] = true,
	["legacy-straight-rail"] = true,
	["lightning-attractor"] = true,
	["linked-belt"] = true,
	["linked-container"] = true,
	["loader"] = true,
	["loader-1x1"] = true,
	["logistic-container"] = true,
	["market"] = true,
	["mining-drill"] = true,
	["offshore-pump"] = true,
	["pipe"] = true,
	["pipe-to-ground"] = true,
	["power-switch"] = true,
	["programmable-speaker"] = true,
	["proxy-container"] = true,
	["pump"] = true,
	["radar"] = true,
	["rail-chain-signal"] = true,
	["rail-ramp"] = true,
	["rail-signal"] = true,
	["rail-support"] = true,
	["reactor"] = true,
	["roboport"] = true,
	["rocket-silo"] = true,
	["selector-combinator"] = true,
	["solar-panel"] = true,
	["space-platform-hub"] = true,
	["splitter"] = true,
	["storage-tank"] = true,
	["straight-rail"] = true,
	["temporary-container"] = true,
	["thruster"] = true,
	["train-stop"] = true,
	["transport-belt"] = true,
	["turret"] = true,
	["underground-belt"] = true,
	["unit-spawner"] = true,
	["valve"] = true,
	["wall"] = true,
}

local function on_built_inserter(event)
	local player = game.get_player(event.player_index)
	if player == nil or player.is_cursor_blueprint() == true then
		return
	end

	--game.print({ "", "Player built an inserter." }, { game_state = false, skip = defines.print_skip.never })

	local inserter = event.entity

	if inserter.drop_target ~= nil and inserter.drop_target.to_be_deconstructed() ~= true then
		return
	end

	local drop = inserter.drop_position
	if drop == nil then return end
	local drop_x = drop.x or drop[1]
	local drop_y = drop.y or drop[2]
	local tile_x = floor(drop_x)
	local tile_y = floor(drop_y)

	local surface = inserter.surface

	local entities = surface.find_entities_filtered({ area = {{tile_x, tile_y}, {tile_x + 1, tile_y + 1}}, type = "entity-ghost" } )
	for _, entity in ipairs(entities) do
		if entity.type == "entity-ghost" and target_entity_types[entity.ghost_type] == true then
			return
		end
	end

	local tile = surface.get_tile(drop_x, drop_y)

	--[[
	--Unlike an inserter dropping into a ghost crafting machine, a ghost tile does not block an inserter from
	--dropping items through it into oblivion, so let's not actually consider this case.

	local tile_ghosts = tile.get_tile_ghosts()
	local top_tile_ghost = nil
	for _, ghost in ipairs(tile_ghosts) do
		if ghost.type == "tile-ghost" and ghost.ghost_type == "tile" then
			top_tile_ghost = prototypes.tile[ghost.ghost_name]
			break
		end
	end

	if top_tile_ghost ~= nil then
		if tile_destroys_dropped_items(top_tile_ghost) then
			apply_safety_filter(inserter)
		end
		return
	end
	]]

	if tile.to_be_deconstructed() == true then
		if tile_destroys_dropped_items(prototypes.tile[tile.hidden_tile]) then
			apply_safety_filter(inserter)
		end
		return
	end

	if tile_destroys_dropped_items(tile.prototype) == true then
		apply_safety_filter(inserter)
	end
end

local built_inserter_filter = {
	{
		filter = "type",
		type = "inserter",
	},
	{
		filter = "ghost_type",
		type = "inserter",
	},
}

script.on_event(defines.events.on_built_entity, on_built_inserter, built_inserter_filter)

