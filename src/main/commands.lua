minetest.register_chatcommand("message", {
	params = "<message>[|<color>[|<player>]]",
	description = "Send a optional colored message as the server to one or all players.",
	privs = {server = true},
	func = function(name, param)
		local param_list = param:split("|")
		param_list[1] = minetest.colorize(param_list[2] or "#FFFFFF", param_list[1])
		if param_list[3] then
			minetest.chat_send_player(param_list[3], param_list[1])
		else
			minetest.chat_send_all(param_list[1])
		end
	end,
})

minetest.register_chatcommand("wielded", {
	params = "",
	description = "Print Itemstring of wielded Item",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
        if player then
            local item = player:get_wielded_item()
            if item then 
                minetest.chat_send_player(name, item:get_name())
            end
        end
	end,
})

minetest.register_chatcommand("sudo", {
	description = "Force other players to run commands",
	params = "<player> <command> <arguments...>",
	privs = {server = true},
	func = function(name, param)
		local target = param:split(" ")[1]
		local command = param:split(" ")[2]
		local argumentsdisp
		local cmddef = minetest.chatcommands
		local _, _, arguments = string.match(param, "([^ ]+) ([^ ]+) (.+)")
		if not arguments then arguments = "" end
		if target and command then
			if cmddef[command] then
				if minetest.get_player_by_name(target) then
					if arguments == "" then argumentsdisp = arguments else argumentsdisp = " " .. arguments end
					cmddef[command].func(target, arguments)
				else
					minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Player."))
				end
			else
				minetest.chat_send_player(name, minetest.colorize("#FF0000", "Nonexistant Command."))
			end
		else
			minetest.chat_send_player(name, minetest.colorize("#FF0000", "Invalid Usage."))
		end
	end
})
