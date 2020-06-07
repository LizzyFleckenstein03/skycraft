skycraft.ores = skycraft.random:new()
skycraft.ores:add_choice("mcl_core:cobble", 1000)
skycraft.ores:add_choice("mcl_core:stone", 200)
skycraft.ores:add_choice("mcl_core:stone_with_coal", 31)
skycraft.ores:add_choice("mcl_core:stone_with_iron", 25)
skycraft.ores:add_choice("mcl_core:stone_with_gold", 10)
skycraft.ores:add_choice("mcl_core:stone_with_lapis", 10)
skycraft.ores:add_choice("mcl_core:stone_with_redstone", 10)
skycraft.ores:add_choice("mcl_core:stone_with_diamond", 5)
skycraft.ores:calc_csum()

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

minetest.register_on_generated(function(minp, maxp)
	if maxp.y < 1000 or minp.y > 5000 then return end
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})
	local void_id = minetest.get_content_id("mcl_core:void")
	local barrier_id = minetest.get_content_id("mcl_core:barrier")
	for x = minp.x, maxp.x do
		for z = minp.z, maxp.z do
			local barrier = (math.mod(x, 62) == 0 or math.mod(z, 62) == 0)
			local void = (maxp.y < 1500)
			if barrier or void then
				for y = minp.y, maxp.y do
					local p_pos = area:index(x, y, z)
					data[p_pos] = barrier and barrier_id or void_id
				end
			end
		end
	end
	if maxp.y > 5000 then--or minp.y < 1000 then
		for x = minp.x, maxp.x do
			for z = minp.z, maxp.z do
				local y = (maxp.y > 5000) and 1000 or 5000
				local p_pos = area:index(x, y, z)
				data[p_pos] = barrier_id
			end
		end
	end
	vm:set_data(data)
	vm:calc_lighting()
	vm:update_liquids()
	vm:write_to_map()
end)

minetest.register_on_mods_loaded(function()
	function mcl_worlds.is_in_void(pos)
		local res = minetest.get_node(vector.floor(pos)).name == "mcl_core:void"
		return res, res
	end
	for k, v in pairs(minetest.registered_abms) do
		if v.label == "Lava cooling" then
			local old_func = v.action
			v.action = function(pos, node, active_object_count, active_object_count_wider)
				old_func(pos, node, active_object_count, active_object_count_wider)
				if minetest.get_node(pos).name == "mcl_core:cobble" then
					minetest.set_node(pos, {name = skycraft.ores:choose()})
				end
			end
			break
		end
	end
end)
