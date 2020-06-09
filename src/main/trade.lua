skycraft.last_trade_id = 0

skycraft.player_trades = {}

skycraft.trade = {}

skycraft.trade.__index = skycraft.trade

function skycraft.trade:new(name1, name2)
	local o = {}
	setmetatable(o, self)
	o:start(name1, name2)
	return o
end

function skycraft.trade:start(name1, name2)
	skycraft.player_trades[name1] = self
	skycraft.player_trades[name2] = self
	self.players = {{name = name1, status = 1}, {name = name2, status = 1}}
	self.id = skycraft.last_trade_id + 1
	skycraft.last_trade_id = self.id
	self.inventory = minetest.create_detached_inventory(self:get_inventory_name(), {
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			local name = player:get_player_name()
			return (self:allow_access(from_list, name) and self:allow_access(to_list, name)) and count or 0
		end,
		allow_put = function(inv, listname, index, stack, player) return (self:allow_access(listname, player:get_player_name())) and stack:get_count() or 0 end,
		allow_take = function(inv, listname, index, stack, player) return (self:allow_access(listname, player:get_player_name())) and stack:get_count() or 0 end,
	})
	self.inventory:set_size("1", 12)
	self.inventory:set_size("2", 12)
	minetest.after(0.5, self.update_formspec, self)
end

function skycraft.trade:allow_access(list, name)
	for i, p in pairs(self.players) do
		if p.name == name and tonumber(list) == i and p.status == 1 then return true end
	end
	return false
end

function skycraft.trade:get_inventory_name()
	return "trade_" .. tostring(self.id)
end

function skycraft.trade:update_formspec()
	local invname = "detached:" .. self:get_inventory_name()
	local formspec = "size[10,9]list[current_player;main;1,5;8,4;]" .. mcl_formspec.get_itemslot_bg(1, 5, 8, 4)
	if self.canceled then
		formspec = formspec
			.. "label[4,3;Canceled]"
			.. "button_exit[3,4;3,1;exit;Exit]"
	elseif self.successfull then
		formspec = formspec
			.. "label[4,3;Successfull]"
			.. "button_exit[3,4;3,1;exit;Exit]"
	else
		local status_buttons = {"Confirm", "Exchange"}
		for i, p in pairs(self.players) do
			local x = tostring(3 + (i - 1) * 2)
			formspec = formspec
				.. "list[" .. invname .. ";" .. tostring(i) .. ";" .. tostring((i - 1) * 7) .. ",0;3,4;]"
				.. mcl_formspec.get_itemslot_bg((i - 1) * 7, 0, 3, 4)
				.. "label[" .. x .. ",0;" .. p.name .. "]"
				.. "button[" .. x .. ",2;2,1;cancel_" .. tostring(i) .. ";" .. "Cancel" .. "]"
			if status_buttons[p.status] then
				formspec = formspec
				.. "button[" .. x .. ",1;2,1;accept_" .. tostring(i) .. ";" .. status_buttons[p.status] .. "]"
			end
		end
	end
	for _, p in pairs(self.players) do
		minetest.show_formspec(p.name, "skycraft:trade", formspec)
	end
end

function skycraft.trade:give_inventory(name, list)
	local player = minetest.get_player_by_name(name)
	if not player then return end
	local inventory = player:get_inventory()
	local list_ref = self.inventory:get_list(list)
	for _, itemstack in pairs(list_ref) do
		inventory:add_item("main", itemstack)
		self.inventory:remove_item(list, itemstack)
	end
end

function skycraft.trade:cancel()
	for i, p in pairs(self.players) do
		self:give_inventory( p.name, tostring(i))
		skycraft.player_trades[p.name] = nil
	end
	self.canceled = true
end

function skycraft.trade:success()
	local list = {"2", "1"}
	for i, p in pairs(self.players) do
		self:give_inventory(p.name, list[i])
		skycraft.player_trades[p.name] = nil
	end
	self.successfull = true
end

function skycraft.trade:click_button(name, button)
	if button == "quit" then return self:cancel() end
	local action = button:split("_")[1]
	local num = tonumber(button:split("_")[2])
	for i, p in pairs(self.players) do
		if name == p.name and num == i then
			if action == "accept" then
				p.status = p.status + 1
			elseif action == "cancel" then
				self:cancel()
			end
			break
		end
	end
	local success = true
	for _, p in pairs(self.players) do
		if p.status < 3 then
			success = false
			break
		end
	end
	if success then self:success() end
	self:update_formspec()
end

minetest.register_on_leaveplayer(function(player)
	local t = skycraft.player_trades[player:get_player_name()]
	if t then t:cancel() end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "skycraft:trade" then
		local name = player:get_player_name()
		local t = skycraft.player_trades[name]
		if not t then return end
		for field, _ in pairs(fields) do
			t:click_button(name, field)
		end
	end
end)

skycraft.register_request_system("trade", "trade", "trading", "with", function(name1, name2)
	skycraft.trade:new(name1, name2)
end)
