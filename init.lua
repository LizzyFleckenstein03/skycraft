skycraft = {}

do
	local file = io.open(minetest.get_worldpath() .. "/skycraft", "r")
	if file then
		skycraft.savedata = minetest.deserialize(file:read())
		file:close()
	else
		skycraft.savedata = {}
	end
end

minetest.register_on_shutdown(function()
	local file = io.open(minetest.get_worldpath() .. "/skycraft", "w")
	file:write(minetest.serialize(skycraft.savedata))
	file:close()
end)

minetest.register_privilege("skycraft", "Use Skycraft commands")

local modules = {
	common = {"common", "random" , "request"},
	main = {"commands", "flower_spread", "lobby", "lucky_block", "mapgen", "money", "plots", "ranks", "spawns", "tpa", "trade"},
	onload = {"lava_cooling", "lobby_load", "nether_portal", "sapling_mutation", "shop", "spawn", "void"}
}
local modpath = minetest.get_modpath("skycraft")
local function load_module(m)
	for _, f in pairs(modules[m]) do
		dofile(modpath .. "/src/" .. m .. "/" .. f .. ".lua")
	end
end
load_module("common")
load_module("main")
minetest.register_on_mods_loaded(function()
	load_module("onload")
end)

