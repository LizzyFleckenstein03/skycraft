local armor_parts = {"head", "torso", "legs", "feet"}
skycraft.armor_list = {}
for _, n in pairs(armor_parts) do
	skycraft.armor_list[n] = skycraft.register_group_list("armor_" .. n)
end
skycraft.head_list = skycraft.register_group_list("head")

function skycraft.place_and_fill_armor_stand(pos, player)
	minetest.set_node(pos, {name = "mcl_armor_stand:armor_stand"})
	local nodedef = minetest.registered_nodes["mcl_armor_stand:armor_stand"]
	local node = minetest.get_node(pos)
	local armor_pieces = {}
	for _, n in pairs(armor_parts) do
		local piece_list = skycraft.armor_list[n]
		table.insert(armor_pieces, ItemStack(piece_list[math.random(#piece_list)]))
	end
	local function equip_armor(i)
		local piece = armor_pieces[i]
		if not piece then return end
		nodedef.on_rightclick(pos, node, player, ItemStack(piece))
		minetest.after(0.5, equip_armor, i + 1)
	end
	minetest.after(0.5, equip_armor, 1)
end 

minetest.register_chatcommand("armorstand", {
	description = "Spawn an armor stand at your position and fill it with random armor",
	privs = {server = true},
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then return false, "You have to be online to use this command" end
		skycraft.place_and_fill_armor_stand(vector.floor(player:get_pos()), player)
		return true, "Armor stand spawned, equipping."
	end
})

