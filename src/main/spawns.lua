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
