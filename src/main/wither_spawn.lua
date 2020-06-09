local dim = {"x", "z"}

for _, d in pairs(dim) do
	skycraft.load_schem("wither_spawn_" .. d)
end

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if newnode.name == "mcl_heads:wither_skeleton" then
		for _, d in pairs(dim) do
			for i = 0, 2 do
				local p = vector.add(pos, {x = 0, y = -2, z = 0, [d] = -i})
				local schemname = "wither_spawn_" .. d
				if skycraft.check_schem(p, schemname) then
					skycraft.remove_schem(p, schemname)
					minetest.add_entity(vector.add(p, {x = 0, y = 1, z = 0, [d] = 1}), "mobs_mc:wither")
				end
			end
		end
	end
end)
 
