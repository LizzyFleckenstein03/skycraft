minetest.register_on_mods_loaded(function()
	local old_light_nether_portal = mcl_portals.light_nether_portal
	function mcl_portals.light_nether_portal(pos)
		if mcl_worlds.pos_to_dimension(pos) == "nether" then
			return false
		else
			return old_light_nether_portal(pos)
		end
	end 
end)
