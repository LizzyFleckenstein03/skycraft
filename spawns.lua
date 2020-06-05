skycraft.spawn_offset = {x = 3, y = 2, z = 0}

skycraft.starter_mobs = {"mobs_mc:cow", "mobs_mc:sheep", "mobs_mc:pig"}

do
	local file = io.open(minetest.get_modpath("skycraft") .. "/schems/island.we", "r")
	skycraft.island_schem = file:read()
	file:close()
end

skycraft.savedata.spawns = skycraft.savedata.spawns or {} 

function skycraft.get_spawn(player)
	local strpos = player:get_meta():get_string("skycraft:spawn")
	if not strpos == "" then return end
	return minetest.string_to_pos(strpos)
end

function skycraft.set_spawn(player, pos)
	player:get_meta():set_string("skycraft:spawn", minetest.pos_to_string(pos))
end

function skycraft.spawn_player(player)
	local spawn = skycraft.get_spawn(player)
	local name = player:get_player_name()
	if not spawn then
		local plot = skycraft.claim_plot(name)
		spawn = {x = plot.x * 62 + 31, z = plot.z * 62 + 31, y = math.random(1600, 2000)}
		minetest.chat_send_player(name, "Creating Island ...")
		skycraft.set_spawn(player, spawn)
		local physics = player:get_physics_override()
		player:set_physics_override({gravity = 0})
		minetest.after(5, function()
			worldedit.deserialize(vector.add(spawn, {x = -6, y = -6, z = -4}), skycraft.island_schem)
			local nametag = name .. "'s Friend"
			local entity = minetest.add_entity(vector.add(spawn, {x = -4.5, y = 1, z = 1.5}), skycraft.starter_mobs[math.random(#skycraft.starter_mobs)])
			entity:get_luaentity().nametag = nametag
			entity:set_properties({nametag = nametag})
			player:set_physics_override(physics)
		end)
	end
	player:set_pos(vector.add(spawn, skycraft.spawn_offset))
end

minetest.register_on_respawnplayer(function(player)
	local spawn = mcl_spawn.get_spawn_pos(player)
	player:set_pos(spawn)
	return true
end)

minetest.register_on_mods_loaded(function()
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
end)
