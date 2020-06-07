local file = io.open("modules.txt", "w")
file:write("return {")
local modules = io.popen("ls src"):lines()
for m in modules do
	local files = io.popen("ls src/" .. m):lines()
	file:write(m .. "={")
	for f in files do
		file:write("\"" .. string.gsub(f, ".lua", "") .. "\",")
	end
	file:write("},")
end
file:write("}")
file:close()
