minetest.override_item("lucky_block:lucky_block", {
	tiles = {"skycraft_lucky_block.png"},
	inventory_image = minetest.inventorycube("skycraft_lucky_block.png"),
	light_source = nil,
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
	{"dro", {"mcl_core:dirt"}, 64},
	{"dro", discs, 1}
})
