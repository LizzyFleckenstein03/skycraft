local function on_punch_or_rightclick(self, player)
	if player and player.is_player and player:is_player() then
		local name = player:get_player_name()
		if player:get_wielded_item():get_name() == "mcl_core:stick" and minetest.check_player_privs(name, {server = true}) then
			self.object:remove()
		else
			skycraft.join_skyblock(name)
		end
	end
	return false
end

mobs:register_mob("skycraft:join_skyblock", {
	nametag = "Join Skyblock",
	type = "npc",
	jump = false,
	armor = 0,
	stand_chance = 100,
	walk_chance = 0,
	collisionbox = {-0.3, -0.01, -0.3, 0.3, 1.94, 0.3},
	visual = "mesh",
	mesh = "character.b3d",
	textures = {
		{"mcl_skins_character_1.png"},
	},
	glow = 10,
	do_custom = function(self)
		self.object:set_yaw(math.pi * 1.5)
	end,
	on_rightclick = on_punch_or_rightclick,
	do_punch = on_punch_or_rightclick,
})
