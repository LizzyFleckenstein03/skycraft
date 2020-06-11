skycraft.register_group_list("flower")
skycraft.group_lists["flower"] = {"mcl_flowers:fern", "mcl_flowers:double_fern", "mcl_flowers:tallgrass", "mcl_flowers:double_grass"}
local flower_list = skycraft.get_group_list("flower")
minetest.register_abm({
	nodenames = {"mcl_core:dirt_with_grass"},
	interval = 300,
	chance = 100,
	action = function(pos, node)
		pos.y = pos.y + 1
		local light = minetest.get_node_light(pos) or 0
		if minetest.get_node(pos).name == "air" and light > 12 and not minetest.find_node_near(pos, 2, {"group:flower"}) then
			minetest.set_node(pos, {name = flower_list[math.random(#flower_list)]})
		end
	end
}) 
