local old_get_grass_block_type = mcl_core.get_grass_block_type
function mcl_core.get_grass_block_type(pos)
	if pos.y > 5000 then
		return {name="mcl_core:dirt_with_grass", param2=0}
	end
	return old_get_grass_block_type(pos)
end
