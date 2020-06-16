local groupcaps = {times = {0, 0, 0}, uses = 0, maxlevel = 3}

minetest.register_tool("skycraft:god_stick", {
    description = "God Stick",
    inventory_image = "mcl_mobitems_blaze_rod.png",
    range = 100,
    tool_capabilities = {
        max_drop_level = 1,
        groupcaps= {
            not_in_creative_inventory = groupcaps,
            oddly_breakable_by_hand = groupcaps,
            pickaxey = groupcaps,
            axey = groupcaps,
            shovely = groupcaps,
            fleshy = groupcaps,
            handy = groupcaps,
        },
        damage_groups = {fleshy = 1000},
    }
})

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	if hitter:get_wielded_item():get_name() == "skycraft:god_stick" then
		lightning.strike(player:get_pos())
		minetest.after(0.25, minetest.ban_player, player:get_player_name())
		return true
	end
end)

