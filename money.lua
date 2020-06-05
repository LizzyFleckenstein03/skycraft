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

minetest.register_on_mods_loaded(function()
	for nodename, nodedef in pairs(minetest.registered_nodes) do
		if nodename:find("mcl_signs:") then
			minetest.override_item(nodename, {
				on_rightclick = function(pos, node, player, itemstack, pointed_thing)
					if pos.y < 5000 then return end
					local text = minetest.get_meta(pos):get_string("text") or ""
					local lines = text:split("\n")
					local action, amount, price = lines[1], lines[2], lines[3]
					print(action, amount, price)
					if not (action and amount and price) then return end
					price = string.gsub(price, "%$", "")
					price = tonumber(price)
					amount = string.gsub(amount, "x", "")
					amount = tonumber(amount)
					print(action, amount, price)
					if not (amount and price) then return end
					local func, frameoffset
					if action == "Buy" then
						func, frameoffset = skycraft.buy, -1
					elseif action == "Sell" then
						func, frameoffset = skycraft.sell, 1
					else
						return
					end
					local framepos = vector.add(pos, {x = 0, y = frameoffset, z = 0})
					if minetest.get_node(framepos).name ~= "mcl_itemframes:item_frame" then return end
					local inv = minetest.get_meta(framepos):get_inventory()
					if inv:is_empty("main") then return end
					local itemstack = inv:get_stack("main", 1)
					func(player, itemstack:get_name() .. " " .. tostring(amount), price)
				end,
			})
		end
	end
end)
