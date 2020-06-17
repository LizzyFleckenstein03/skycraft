local spawner_def = minetest.registered_nodes["mcl_mobspawners:spawner"]
local old_on_place = spawner_def.on_place

function spawner_def.on_place(itemstack, placer, pointed_thing)
	local name = placer:get_player_name()
	local privs = minetest.get_player_privs(name)
	privs.maphack = true
	minetest.set_player_privs(name, privs)
	old_on_place(itemstack, placer, pointed_thing)
	privs.maphack = nil
	minetest.set_player_privs(name, privs)
	return player:get_wielded_item()
end

spawner_def.drop = "mcl_mobspawners:spawner"
