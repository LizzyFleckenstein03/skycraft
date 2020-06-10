skycraft.alpha = false

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if skycraft.alpha and not minetest.check_player_privs(name, {protection_bypass = true}) then
		minetest.kick_player(name, "Thanks for Joining this Server! But you can not play here yet, we are still busy building the server. We would like to see you again as soon as the alpha phase is over!")
	end
end)
