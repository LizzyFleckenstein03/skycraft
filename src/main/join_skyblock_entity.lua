local function on_punch_or_rightclick(self, player)
	if not player:is_player() then return end
	local name = player:get_player_name()
	if player:get_wielded_item():get_name() ~= "skycraft:god_stick" then
		skycraft.join_skyblock(name)
	else
		self.object:remove()
	end
end

local function on_activate(self)
	self.object:set_pos({x = 17, y = 10000.5, z = 0,})
	self.object:set_yaw(math.pi * 1.5)
	self.object:set_nametag_attributes({color = "#00B59A", text = "Join Skyblock"})
	self.object:set_animation({x = 0, y = 79}, 30, 0)
	self.object:set_armor_groups({immortal = 1})
end

minetest.register_entity("skycraft:join_skyblock", {
	initial_properties = {
		collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.75, 0.3},
		visual = "mesh",
		mesh = "character.b3d",
		textures = {"character.png"},
	},
	on_punch = on_punch_or_rightclick,
	on_rightclick = on_punch_or_rightclick,
	on_activate = on_activate,
})
