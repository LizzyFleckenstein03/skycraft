local trees = {"", "dark", "jungle", "acacia", "spruce", "birch"}
for _, tree in pairs(trees) do
	local item = "mcl_core:" .. tree .. "leaves"
	local drop = minetest.registered_nodes[item].drop
	for _, mutant_tree in pairs(trees) do
		drop.items[#drop.items + 1] = {
			items = {"mcl_core:" .. mutant_tree .. "sapling"},
			rarity = 5000,
		}
	end
end

