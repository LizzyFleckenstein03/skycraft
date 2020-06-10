function skycraft.sell(player, item, money)
	local inv = player:get_inventory()
	if not inv:contains_item("main", item) then return minetest.chat_send_player(player:get_player_name(), "You don't have enough items!") end
	inv:remove_item("main", item)
	skycraft.give_money(player, money)
end

function skycraft.buy(player, item, money)
	local inv = player:get_inventory()
	if not inv:room_for_item("main", item) then return minetest.chat_send_player(player:get_player_name(), "You don't have enough space in your inventory!") end
	if not skycraft.take_money(player, money) then return end
	inv:add_item("main", item)
end 
