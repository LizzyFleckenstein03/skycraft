function mcl_worlds.is_in_void(pos)
	local res = minetest.get_node(vector.floor(pos)).name == "mcl_core:void"
	return res, res
end 
