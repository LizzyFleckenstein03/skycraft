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
	if maxp.y > 5000 or minp.y < 1000 then
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
end)
