function skycraft.register_request_system(sysname, action, progressive, preposition, func)
	local action_capital = (action:sub(1, 1)):upper() .. action:sub(2)

	local request_list = {}

	minetest.register_on_leaveplayer(function(name)
		request_list[name] = nil
	end)

	minetest.register_chatcommand(sysname, {
		description = "Request to " .. action .. " " .. preposition .. " another player",
		params = "<player>",
		privs = {skycraft = true},
		func = function(name, param)
			if param == "" then
				return false, "Usage: /" .. sysname .. " <player>"
			end
			if not minetest.get_player_by_name(param) then
				return false, "There is no player by that name. Keep in mind this is case-sensitive, and the player must be online"
			end
			request_list[param] = name
			minetest.after(60, function()
				if request_list[param] then
					minetest.chat_send_player(name, "Request timed-out.")
					minetest.chat_send_player(param, "Request timed-out.")
					request_list[param] = nil
				end
			end)
			minetest.chat_send_player(param, name .. " is requesting to " .. action .. " " .. preposition .. " you. /" .. sysname .. "accept to accept")
			return true, action_capital .. " request sent! It will timeout in 60 seconds."
		end
	})

	minetest.register_chatcommand(sysname .. "accept", {
		description = "Accept " .. action .. " request from another player",
		privs = {skycraft = true},
		func = function(name)
			if not minetest.get_player_by_name(name) then return false, "You have to be online to use this command" end
			local other = request_list[name]
			if not other then return false, "Usage: /" .. sysname .. "accept allows you to accept " .. action .. " requests sent to you by other players" end
			if not minetest.get_player_by_name(other) then return false, other .. " doesn't exist, or just disconnected/left (by timeout)." end
			minetest.chat_send_player(other, action_capital .. " request accepted!")
			func(name, other)
			request_list[name] = nil
			return true, other .. " is " .. progressive .. " " .. preposition .. " you."
		end
	})

	minetest.register_chatcommand(sysname .. "deny", {
		description = "Deny " .. action .." request from another player",
		privs = {skycraft = true},
		func = function(name)
			local other = request_list[name]
			if not other then return false, "Usage: /" .. sysname .. "deny allows you to deny " .. action .. " requests sent to you by other players." end
			minetest.chat_send_player(other, action_capital .. " request denied.")
			request_list[name] = nil
			return false, "You denied the " .. action .. " request " .. other .. " sent you."
		end
	})
 
end
