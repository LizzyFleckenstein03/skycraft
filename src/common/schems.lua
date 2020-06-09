skycraft.schems = {}

function skycraft.get_schem(schemname)
	return skycraft.schems[schemname].data
end

function skycraft.get_schem_raw(schemname)
	return skycraft.schems[schemname].raw
end

function skycraft.load_schem(schemname)
	local schem = {}
	local file = io.open(skycraft.modpath .. "/schems/" .. schemname .. ".we", "r")
	schem.raw = file:read()
	file:seek("set")
	local _, _, contents = file:read("*number", 1, "*all")
	file:close()
	schem.data = minetest.deserialize(contents)
	skycraft.schems[schemname] = schem
end

function skycraft.check_schem(pos, schemname)
	local schem = skycraft.get_schem(schemname)
	for _, n in pairs(schem) do
		if minetest.get_node(vector.add(pos, n)).name ~= n.name then
			return false
		end
	end
	return true
end

function skycraft.remove_schem(pos, schemname)
	local schem = skycraft.get_schem(schemname)
	for _, n in pairs(schem) do
		minetest.remove_node(vector.add(pos, n))
	end
end

function skycraft.add_schem(pos, schemname)
	local schem_raw = skycraft.get_schem_raw(schemname)
	worldedit.deserialize(pos, schem_raw)
end
