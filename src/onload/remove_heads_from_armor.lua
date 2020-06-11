local armor_head = skycraft.armor_list["head"]
local heads = skycraft.head_list
for _, n in pairs(heads) do
	for k, v in pairs(armor_head) do
		if n == v then
			table.remove(armor_head, k)
			break
		end
	end
end 
