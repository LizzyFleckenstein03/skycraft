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

minetest.clear_craft({output = "lucky_block:lucky_block"})

local discs = {}
for i=1, 8 do
	table.insert(discs, "mcl_jukebox:record_" .. tostring(i))
end

lucky_block:add_blocks({
	{"dro", {"mcl_core:dirt", "mcl_core:sand", "mcl_core:gravel"}, 100},
	{"dro", discs, 1}
})

