--Used only to generate the thumbnail image.

local item_sounds = require("__base__.prototypes.item_sounds")

data:extend
({
	{
		type = "item",
		name = "filter-blacklist-item",
		icon = "__inserter-safety-filter__/thumbnail-filter-blacklist-item.png",
		subgroup = "raw-resource",
		order = "b[filter-blacklist-item]",
		inventory_move_sound = item_sounds.planner_inventory_move,
		pick_sound = item_sounds.planner_inventory_pickup,
		drop_sound = item_sounds.planner_inventory_move,
		stack_size = 100,
		weight = 1 * kg
	},
})
