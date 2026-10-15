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

local function on_built_inserter(event)
	local player = game.get_player(event.player_index)
	if player == nil or player.is_cursor_blueprint() == true then
		return
	end

	--game.print({ "", "Player built an inserter." }, { game_state = false, skip = defines.print_skip.never })

	local inserter = event.entity
	local drop = inserter.drop_position
	if drop == nil then return end
	local surface = inserter.surface
	local tile = surface.get_tile(drop.x or drop[1], drop.y or drop[2])

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
	else]]if tile.to_be_deconstructed() == true then
		if tile_destroys_dropped_items(prototypes.tile[tile.hidden_tile]) then
			apply_safety_filter(inserter)
		end
	elseif tile_destroys_dropped_items(tile.prototype) then
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

