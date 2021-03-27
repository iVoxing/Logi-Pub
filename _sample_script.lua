-- copy content to script editor in LGS or LGHUB

local path = {
	mac = lua_files_path_on_mac, -- such as "/Users/username/Dropbox/Logi/" 
	win = lua_files_path_on_win, -- such as "D:\\Dropbox\\Logi\\"
}

function my_load(file)
	local f = loadfile(path.mac..file..".lua")
	if not f then
		f = loadfile(path.win..file..".lua")
	end
	return f()
end

my_load("_sample_g_vars")
my_load("_sample_profile")
