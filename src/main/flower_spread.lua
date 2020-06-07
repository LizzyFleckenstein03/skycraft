minetest.register_abm({
	nodenames = {"mcl_core:dirt_with_grass"},
	interval = 300,
	chance = 100,
	action = function(pos, node)
		pos.y = pos.y + 1
		local light = minetest.get_node_light(pos) or 0
		if minetest.get_node(pos).name == "air" and light > 12 and not minetest.find_node_near(pos, 2, {"group:flora"}) then
			local flowers = {"mcl_flowers:blue_orchid", "mcl_flowers:azure_bluet", "mcl_flowers:allium", "mcl_flowers:tulip_white", "mcl_flowers:tulip_red", "mcl_flowers:tulip_pink", "mcl_flowers:tulip_orange", "mcl_flowers:oxeye_daisy", "mcl_flowers:dandelion", "mcl_flowers:poppy", "mcl_flowers:fern", "mcl_flowers:tallgrass", "mcl_flowers:double_tallgrass"}
			minetest.set_node(pos, {name = flowers[math.random(#flowers)]})
		end
	end
}) 
