minetest.registered_entities["mobs_mc:villager"].on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
	if puncher:get_wielded_item():get_name() ~= "skycraft:god_stick" then 
		minetest.chat_send_player(puncher:get_player_name(), minetest.colorize("#FF6737", "Hey! Sorry, you can't hit that here!"))
	else
		self.object:remove()
	end
end
