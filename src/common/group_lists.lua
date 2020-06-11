skycraft.group_lists = {}

function skycraft.register_group_list(group)
	local grouplist = {}
	skycraft.group_lists[group] = grouplist
	return grouplist
end

function skycraft.get_group_list(group)
	return skycraft.group_lists[group] or {}
end

function skycraft.insert_group_list(item, group)
	table.insert(skycraft.get_group_list(group), item)
end
