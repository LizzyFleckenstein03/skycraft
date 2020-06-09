minetest.register_lbm({
	name = "skycraft:netherrack_fix",
	nodenames = {"mcl_core:stone"},
	action = function(pos)
		if pos.y < -28000 then
			minetest.set_node(pos, {name = "mcl_nether:netherrack"})
		end
	end
}) 
