function skycraft.get_money(player)
	return player:get_meta():get_int("skycraft:money")
end

function skycraft.set_money(player, value)
	player:get_meta():set_int("skycraft:money", value)
end

function skycraft.take_money(player, amount)
	local name = player:get_player_name()
	local money = skycraft.get_money(player)
	if amount > money then 
		return false, minetest.chat_send_player(name, "You don't have enough money!")
	end
	skycraft.set_money(player, money - amount)
	minetest.chat_send_player(name, minetest.colorize("#009EFF", "$" .. tostring(amount)) .. " taken from your account.")
	return true
end

function skycraft.give_money(player, amount)
	skycraft.set_money(player, skycraft.get_money(player) + amount)
	minetest.chat_send_player(player:get_player_name(), minetest.colorize("#009EFF", "$" .. tostring(amount)) .. " added to your account.")
end

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

local money_chatcommand_def = {
	description = "Show your balance",
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then return false, "You need to be online to use this command" end
		return true, "You have " .. minetest.colorize("#009EFF", "$" .. tostring(skycraft.get_money(player))) .. "."
	end
}

minetest.register_chatcommand("money", money_chatcommand_def)

minetest.register_chatcommand("balance", money_chatcommand_def)

minetest.register_on_newplayer(function(player)
	skycraft.give_money(player, 200)
end)

