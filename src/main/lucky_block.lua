skycraft.glazed_terracotta_list = {}

local old_on_dig = minetest.registered_nodes["lucky_block:lucky_block"].on_dig

minetest.override_item("lucky_block:lucky_block", {
	tiles = {"skycraft_lucky_block.png"},
	inventory_image = minetest.inventorycube("skycraft_lucky_block.png"),
	light_source = nil,
	on_dig = function(pos, node, digger)
		if not minetest.is_protected(pos, digger) then old_on_dig(pos, node, digger) end
	end
})

minetest.override_item("lucky_block:void_mirror", {
	tiles = {"default_glass.png^[brighten"},
})

minetest.register_alias_force("lucky_block:super_lucky_block", "lucky_block:lucky_block")

lucky_block:add_blocks({
	{"dro", {"mcl_core:goldblock", "mcl_core:gold_ingot", "mcl_core:gold_nugget"}, 256},
	{"dro", {"mcl_core:dirt", "mcl_core:sand", "mcl_core:gravel"}, 64},
	{"spw", "mobs_mc:zombie", 5},
	{"spw", "mobs_mc:husk", 5},
	{"spw", "mobs_mc:spider", 4},
	{"spw", "mobs_mc:cave_spider", 4},
	{"spw", "mobs_mc:skeleton", 2},
	{"spw", "mobs_mc:stray", 2},
	{"spw", "mobs_mc:creeper", 1},
	{"spw", "mobs_mc:enderman", 1},
	{"spw", "mobs_mc:mooshroom", 1},
	{"spw", "mobs_mc:slime_big", 1},
	{"spw", "mobs_mc:bat", 10},
	{"nod", "mcl_cake:cake"},
	{"nod", "mcl_farming:pumpkin"},
	{"dro", skycraft.register_group_list("music_record"), 1},
	{"dro", skycraft.register_group_list("horse_armor"), 1},
	{"nod", skycraft.register_group_list("glazed_terracotta")},
	{"nod", skycraft.register_group_list("hardened_clay")},
	{"nod", skycraft.register_group_list("concrete")},
	{"cus", skycraft.place_and_fill_armor_stand},
})
