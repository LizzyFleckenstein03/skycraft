skycraft.savedata.plots = skycraft.savedata.plots or {}

skycraft.savedata.player_plotids = skycraft.savedata.player_plotids or {}

skycraft.savedata.pos_plotids = skycraft.savedata.pos_plotids or {}

skycraft.savedata.spiral = skycraft.savedata.spiral or {
	x = 0,
	y = 0,
	d = 1,
	m = 1,
	s = true,
}

function skycraft.get_new_spiral_pos()
	local sp = skycraft.savedata.spiral
	local rpos = {x = sp.x, z = sp.y}
	if sp.s then
		sp.x = sp.x + sp.d
		if not (2 * sp.x * sp.d < sp.m) then
			sp.s = false
		end
	else
		sp.y = sp.y + sp.d
		if not (2 * sp.y * sp.d < sp.m) then
			sp.s = true
			sp.d = -1 * sp.d
			sp.m = sp.m + 1
		end
	end
	return rpos
end

function skycraft.get_plot_pos_string(pos)
	return tostring(pos.x) .. "," .. tostring(pos.z)
end

function skycraft.get_plot_at_pos(pos)
	return skycraft.savedata.plots[skycraft.savedata.pos_plotids[skycraft.get_plot_pos_string(vector.floor(vector.divide(pos, 62)))]]
end

function skycraft.get_plot_by_player(name)
	return skycraft.savedata.plots[skycraft.savedata.player_plotids[name]]
end

function skycraft.claim_plot(name)
	local plots = skycraft.savedata.plots
	local plot = skycraft.get_new_spiral_pos()
	plot.owner = name
	plot.members = {}
	plots[#plots + 1] = plot
	skycraft.savedata.player_plotids[name] = #plots
	skycraft.savedata.pos_plotids[skycraft.get_plot_pos_string(plot)] = #plots
	return plot
end

local plot_commands = {
	gui = function(name, message)
		message = message or ""
		local plot = skycraft.get_plot_by_player(name)
		local esc = minetest.formspec_escape
		local formspec = "size[8,10]"
			.. "label[2.5,0;" .. esc("-- Plot interface --") .. "]"
			.. "label[0,1;" .. esc(message or "") .. "]"
			.. "label[0,2;" .. esc("Members:") .. "]"
			.. "button_exit[2.5,9.2;3,0.5;close;" .. esc("Close") .. "]"
			.. "field_close_on_enter[add_member_input;false]"
		
		local n = 0
		for i, member in pairs(plot.members) do
			formspec = formspec
				.. "button[" .. (n % 4 * 2)
				.. "," .. math.floor(n / 4 + 3)
				.. ";1.5,.5;;" .. esc(member) .. "]"
				.. "button[" .. (n % 4 * 2 + 1.25) .. ","
				.. math.floor(n / 4 + 3)
				.. ";.75,.5;remove_member_" .. tostring(i) .. ";X]"
			n = i
		end
		formspec = formspec
			.. "field[" .. (n % 4 * 2 + 1 / 3) .. ","
			.. (math.floor(n / 4 + 3) + 1 / 3 - 0.02)
			.. ";1.433,.5;add_member_input;;]"
			.."button[" .. (n % 4 * 2 + 1.25) .. ","
			.. math.floor(n / 4 + 3) .. ";.75,.5;add_member;+]"
		minetest.show_formspec(name, "skycraft:plot_gui", formspec)
	end,
	help = function(name)
		local c = {
			{"", "Open the GUI"},
			{"gui", "Open the GUI"},
			{"help", "Show this help"},
			{"add_member <member>", "Add a player to your plot's members (Grant him/her permission to build on your island)"},
			{"remove_member <member>", "Remove a player from your plot's members (Revoke him/her permission to build on your island)"},
			{"list_members <member>", "List the members of your plot"},
			{"home", "Warp to your home plot (Only works if you aren't there already)"},
		}
		for k, v in pairs(c) do c[k] = minetest.colorize("#FFF83D", "/plot " .. v[1]) .. ": " .. v[2] end
		return true, table.concat(c, "\n")
	end,
	add_member = function(name, member)
		if not member then return false, "Usage: /plot add_member <member>" end
		local plot = skycraft.get_plot_by_player(name)
		if not plot then return false, "You don't have a plot yet" end
		local index = table.indexof(plot.members, member)
		if index ~= -1 then return false, member .. " is already a member of your plot" end
		table.insert(plot.members, member)
		return true, member .. " added to plot members"
	end,
	remove_member = function(name, member)
		if not member then return false, "Usage: /plot remove_member <member>" end
		local plot = skycraft.get_plot_by_player(name)
		if not plot then return false, "You don't have a plot yet" end
		local index = table.indexof(plot.members, member)
		if index == -1 then return false, member .. " isn't a member of your plot" end
		table.remove(plot.members, index)
		return true, member .. " removed from plot members"
	end,
	list_members = function(name, member)
		local plot = skycraft.get_plot_by_player(name)
		if not plot then return false, "You don't have a plot yet" end
		if #plot.members == 0 then return true, "You plot has no members" end
		return true, "Plot members: " .. table.concat(plot.members, ", ")
	end,
	home = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then return false, "You have to be online to use this command" end
		local pos = player:get_pos()
		if pos.y > 5000 then return false, "You are not on the Skyblock map. Use /skyblock to get there" end
		if pos.y < -100 then return false, "You can only use this command in the Overworld" end
		local plot = skycraft.get_plot_at_pos(pos)
		if plot and plot.owner == name then return false, "You are already on your home plot" end
		skycraft.spawn_player(name)
		return true, "Warped to your home plot"
	end
}

local plot_chatcommand_def = {
	description = "Manage your plot. See /plot help for help",
	param = "[<command> [...]]",
	privs = {skycraft = true},
	func = function(name, param)
		local cmd = param:split(" ")[1] or "gui"
		local cmd_param = param:split(" ")[2]
		local cmd_func = plot_commands[cmd]
		if not cmd_func then return false, "Invalid command /plot " .. param .. ". See /plot help for help" end
		return cmd_func(name, cmd_param)
	end
}

minetest.register_chatcommand("p", plot_chatcommand_def)

minetest.register_chatcommand("plot", plot_chatcommand_def)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "skycraft:plot_gui" then return end
	local name = player:get_player_name()
	local _, message
	for i, member in pairs(skycraft.get_plot_by_player(name).members) do
		if fields["remove_member_" .. tostring(i)] then
			_, message = plot_commands.remove_member(name, member)
		end
	end
	if fields.add_member and fields.add_member_input ~= "" then
		_, message = plot_commands.add_member(name, fields.add_member_input)
	end
	if not fields.close and not fields.quit then
		plot_commands.gui(name, message)
	end
end)

local old_is_protected = minetest.is_protected
function minetest.is_protected(pos, name)
	local plot = skycraft.get_plot_at_pos(pos) or {members = {}}
	if pos.y > 5000 or (pos.y < 1000 and pos.y > -100) or plot.owner ~= name and table.indexof(plot.members, name) == -1 then
		return not minetest.check_player_privs(name, {protection_bypass = true})
	else
		return old_is_protected(pos, name)
	end
end
