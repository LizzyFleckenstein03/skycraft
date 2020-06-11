for nodename, nodedef in pairs(minetest.registered_items) do
	for group, grouplist in pairs(skycraft.group_lists) do
		if nodedef.groups[group] and nodedef.groups[group] > 0 then
			table.insert(grouplist, nodename)
		end
	end
end
