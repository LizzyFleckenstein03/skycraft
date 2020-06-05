skycraft = {}

do
	local file = io.open(minetest.get_worldpath() .. "/skycraft", "r")
	if file then
		skycraft.savedata = minetest.deserialize(file:read())
		file:close()
	else
		skycraft.savedata = {}
	end
end

function skycraft.get_far_node(pos)
	local node = minetest.get_node(pos)
	if node.name ~= "ignore" then
		return node
	end
	minetest.get_voxel_manip():read_from_map(pos, pos)
	return minetest.get_node(pos)
end

function skycraft.find_free_position_near(pos)
	local tries = {
		{x =  1, y =  0, z =  0},
		{x = -1, y =  0, z =  0},
		{x =  0, y =  0, z =  1},
		{x =  0, y =  0, z = -1},
	}
	for _, d in pairs(tries) do
		local p = vector.add(pos, d)
		if not minetest.registered_nodes[minetest.get_node(p).name].walkable then
			return p, true
		end
	end
	return pos, false
end

minetest.register_privilege("skycraft", "Use Skycraft commands")

minetest.register_on_shutdown(function()
	local file = io.open(minetest.get_worldpath() .. "/skycraft", "w")
	file:write(minetest.serialize(skycraft.savedata))
	file:close()
end)

do
	local modpath = minetest.get_modpath("skycraft")
	local modules = {"random", "commands", "ranks", "plots", "spawns", "map", "request", "tpa", "trade", "lobby", "money", "lucky_block", "nether_portal"}
	for _, m in pairs(modules) do
		dofile(modpath .. "/" .. m .. ".lua")
	end
end
