skycraft.ores = skycraft.random:new()
skycraft.ores:add_choice("mcl_core:cobble", 1000)
skycraft.ores:add_choice("mcl_core:stone", 200)
skycraft.ores:add_choice("mcl_core:stone_with_coal", 31)
skycraft.ores:add_choice("mcl_core:stone_with_iron", 25)
skycraft.ores:add_choice("mcl_core:stone_with_gold", 10)
skycraft.ores:add_choice("mcl_core:stone_with_lapis", 10)
skycraft.ores:add_choice("mcl_core:stone_with_redstone", 10)
skycraft.ores:add_choice("mcl_core:stone_with_diamond", 5)
skycraft.ores:calc_csum() 

minetest.register_on_mods_loaded(function()
	for k, v in pairs(minetest.registered_abms) do
		if v.label == "Lava cooling" then
			local old_func = v.action
			v.action = function(pos, node, active_object_count, active_object_count_wider)
				old_func(pos, node, active_object_count, active_object_count_wider)
				if minetest.get_node(pos).name == "mcl_core:cobble" then
					minetest.set_node(pos, {name = skycraft.ores:choose()})
				end
			end
			break
		end
	end
end)
