for nodename, nodedef in pairs(minetest.registered_nodes) do
	if nodename:find("mcl_signs:") then
		minetest.override_item(nodename, {
			on_rightclick = function(pos, node, player, itemstack, pointed_thing)
				if pos.y < 5000 then return end
				local text = minetest.get_meta(pos):get_string("text") or ""
				local lines = text:split("\n")
				local action, amount, price = lines[1], lines[2], lines[3]
				if not (action and amount and price) then return end
				price = string.gsub(price, "%$", "")
				price = tonumber(price)
				amount = string.gsub(amount, "x", "")
				amount = tonumber(amount)
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
				return player:get_wielded_item()
			end,
		})
	end
end
 
