function mcl_spawn.get_world_spawn_pos()
	return skycraft.lobby_pos
end 
function mcl_spawn.get_spawn_pos(player)
	local name = player:get_player_name()
	local spawn, custom_spawn
	local bed_spawn = player:get_meta():get_string("mcl_beds:spawn")
	if bed_spawn and bed_spawn ~= "" then
		spawn, custom_spawn = minetest.string_to_pos(bed_spawn), true
	end
	if spawn and custom_spawn then
		local node_bed = skycraft.get_far_node(spawn)
		local node_up1 = skycraft.get_far_node(vector.add(spawn, {x = 0, y = 1, z = 0}))
		local node_up2 = skycraft.get_far_node(vector.add(spawn, {x = 0, y = 2, z = 0}))
		local bgroup = minetest.get_item_group(node_bed.name, "bed")
		local def1 = minetest.registered_nodes[node_up1.name]
		local def2 = minetest.registered_nodes[node_up2.name]
		if bgroup ~= 1 and bgroup ~= 2 or def1.walkable or def2.walkable or def1.damage_per_second and def1.damage_per_second > 0 or def2.damage_per_second and def2.damage_per_second > 0 then
			if bgroup ~= 1 and bgroup ~= 2 then
				mcl_spawn.set_spawn_pos(player, nil)
			end
			spawn, custom_spawn = nil, false
			minetest.chat_send_player(name, minetest.get_translator("mcl_beds")("Your spawn bed was missing or blocked."))
		end
	end
	if not spawn then
		spawn = mcl_spawn.get_world_spawn_pos(), false
	end
	local island_spawn = skycraft.get_spawn(player)
	if not custom_spawn and island_spawn then
		spawn = vector.add(island_spawn, skycraft.spawn_offset)
	end
	return spawn, custom_spawn
end
