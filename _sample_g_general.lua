-- sample only

_keys = {
	lmb = 1, mmb = 2, rmb = 3, 
	act = 4, swi = 5, msg = 6, drp = 7, dpidn = 8, dpiup = 9, pik = 10, buy = 11, 
	g4 = 4, g5 = 5, g6 = 6, g7 = 7,
	skill_1 = "1", skill_2 = "2", skill_3 = "3", skill_4 = "4",
	stand = "a", move = "c", clear = "x", inventory = "i", paragon = "p", map = "m", tp = "t",
	indicator = "capslock",
	screenshot = "f12",
}
-- delay_test = false -- test virtual delay offset, true for test, false for don't test

-- my_load defined in profile script
my_load("_g_vars")

local x, y = 1, 2

function screen_test()
	local screen_table = {
		[0] = {	-- 16:9 only
			--center
			mid 			= {32768, 32768},
			p_tab 			= {{20832, 28618, 36575, 44601}, 6800},
			p_add 			= {43500, {37171, 31522, 26056, 20347}},
			p_reset 		= {32819, 44520},
			p_accept 		= {28311, 49500},
			a1_icon 		= {25135, 37475},
			a1_town 		= {34697, 29336},
			a2_icon 		= {37088, 31462},
			a2_town 		= {35380, 47618},
			leave_team 		= {29004, 39867},	-- not tested!
			role_ori 		= {32768, 30700},
			-- right
			grid_start 		= {48747, 35470},
			grid_end 		= {64272, 50608},
			accept_invite 	= {0, 0},			-- not ready
			-- left
			leave_game 		= {7923, 29275},
			start_game 		= {8192, 31457},
			cube_material 	= {24576, 51882},
			cube_accept 	= {8190, 50060},
			cube_previous 	= {2000, 50500},
			cube_next 		= {2900, 50500},
			cube_grid_1 	= {7078, 24576},
			mate_2_icon 	= {2151, 15063},
			mate_2_tp 		= {4781, 23566},
			flwer_icon 		= {5243, 2752},
			flwer_dismiss 	= {9503, 9699},
		},
		[1050] = {
			--center
			mid				= {840, 525},
			p_tab			= {{534, 734, 938, 1143}, 151},
			p_add			= {1115, {588, 507, 428, 346}},
			p_reset			= {841, 694},
			p_accept		= {726, 766},
			a1_icon			= {644, 593},
			a1_town			= {889, 476},
			a2_icon			= {951, 506},
			a2_town			= {907, 739},
			leave_team		= {744, 627},	-- not tested!
			role_ori		= {840, 495},
			-- right	
			grid_start		= {1250, 564},
			grid_end		= {1648, 782},
			accept_invite	= {0, 0},
			-- left
			leave_game		= {203, 475},
			start_game		= {210, 506},
			cube_material	= {630, 801},
			cube_accept		= {210, 774},
			cube_previous 	= {51, 781},
			cube_next 		= {74, 781},
			cube_grid_1		= {181, 407},
			mate_2_icon		= {55, 270},
			mate_2_tp		= {123, 392},
			flwer_icon		= {134, 92},
			flwer_dismiss	= {244, 192},
		},
		[1440] = {
			--center
			mid 			= {1720, 720},
			p_tab 			= {{1254, 1558, 1869, 2182}, 149},
			p_add 			= {2139, {817, 693, 573, 447}},
			p_reset 		= {1722, 978},
			p_accept 		= {1546, 1088},
			a1_icon 		= {1422, 823},
			a1_town 		= {1795, 645},
			a2_icon 		= {1889, 691},
			a2_town 		= {1822, 1046},
			leave_team 		= {1573, 876},	-- not tested!
			role_ori 		= {1720, 675},
			-- right
			grid_start 		= {2784, 779},
			grid_end 		= {3391, 1112},
			accept_invite 	= {3186, 1236},
			-- left
			leave_game 		= {309, 643},
			start_game 		= {320, 691},
			cube_material 	= {960, 1140},
			cube_accept 	= {320, 1100},
			cube_previous 	= {780, 1110},
			cube_next 		= {1130, 1110},
			cube_grid_1 	= {276, 540},
			mate_2_icon 	= {84, 331},
			mate_2_tp 		= {187, 518},
			flwer_icon 		= {205, 60},
			flwer_dismiss 	= {371, 213},
		},
	}
	if not _this_screen then
		AbortMacro()
		_ori = {nil, nil}
		_ori[x], _ori[y] = GetMousePosition()
		MoveMouseToVirtual(0, 0)
		Sleep(10)
		_screen_test = {nil, nil}
		_screen_test[x], _screen_test[y] = GetMousePosition()
		_this_screen = screen_table[_screen_test[y]]
		MoveMouseToVirtual(_ori[x], math.abs(_screen_test[y] - _ori[y]))
	end
	OutputLogMessage("\nScreen: ".._screen_test[y])
end

-- just for dual players
-- not in use since S21
function app_switch() -- tab for win, gui for mac
	local alt_or_gui = "lgui"
	if _screen_test[y] == 0 then
		alt_or_gui = "lalt"
	end
	PressKey(alt_or_gui)
	Sleep(20)
	PressAndReleaseKey("tab", alt_or_gui)
	Sleep(20)
	PressAndReleaseKey("enter")
end

function macro_pause()
	AbortMacro()
	local key_table = {swi_key, act_key}
	for i, k in pairs(key_table) do
		if type(k) == "string" then
			ReleaseKey(k)
		end
	end
end

function macro_stop()
	macro_pause()
	swi_is_on = false
	act_is_on = false
end

-- NEED TO rewrite
function macro_resume()
	local macro_table = {
		swi = {flag = swi_is_on, macro = swi_macro, key = swi_key},
		act = {flag = act_is_on, macro = act_macro, key = act_key},
	}
	for i, k in ipairs(macro_table) do
		if k.flag then
			if k.macro then
				AbortMacro()
				PlayMacro(k.macro)	-- ATTENTION: only last one macro can be played
			elseif k.key then
				PressKey(k.key)
			else
				return
			end
		end
	end
end

-- depend on Alfred Powerpack
-- shortcut workflow MUST be defined
function play_sound(sound_name)
	screen_test()
	if _screen_test[y] ~= 0 and _alfred_on then
		local sound_table = {glass = "g", hero = "h", ping = "p"}
		PressKey("lctrl", "lshift", "lalt", "lgui")	-- depend on alfred workflow setting
		Sleep(10)
		PressAndReleaseKey(sound_table[sound_name])
		ReleaseKey("lctrl", "lshift", "lalt", "lgui")
	end
end

-- NOTE: must call by mdf key in a keylockon loop
function dismiss_follower()
	AbortMacro()
	screen_test()
	local icon = _this_screen.flwer_icon
	local dsms = _this_screen.flwer_dismiss
	MoveMouseToVirtual(icon[x], icon[y])
	Sleep(20)
	PressAndReleaseMouseButton(3)
	Sleep(100)
	MoveMouseToVirtual(dsms[x], dsms[y])
	Sleep(20)
	PressAndReleaseMouseButton(1)
end

function resume_game()
	macro_stop()					-- must have this line
	screen_test()
	Sleep(100)
	PressAndReleaseKey("escape")	-- press esc and keys.clear, ensure STASH case to be closed
	Sleep(10)
	PressAndReleaseKey(_keys.clear)	-- keypress must be set!
	Sleep(10)
	PressAndReleaseKey("escape")	-- open exit game UI
	Sleep(100)
	MoveMouseToVirtual(_this_screen.leave_game[x], _this_screen.leave_game[y])
	Sleep(10)
	PressAndReleaseMouseButton(1)
	Sleep(3000)
	local stgx, stgy = _this_screen.start_game[x], _this_screen.start_game[y]
	local n = 7				-- in town
	if mdf_check() > 0 then -- not in town, press and hold any modifier untill sound heared
		n = 17
		play_sound("glass")
	end
	Sleep(2000)
	for i = 1, n do	-- repeating left click to ensure clicking success while save time
		MoveMouseToVirtual(stgx, stgy)
		Sleep(10)
		PressAndReleaseMouseButton(1)
		Sleep(500)
	end
	MoveMouseToVirtual(_this_screen.mid[x], _this_screen.mid[y])
end

_dl_in_grid = 0	-- old value is 1, changed for LGHUB version

-- x: 1~10, y: 1~6
function grid_loop(start_x, start_y, end_x, end_y, func_pre, func_grid, func_post, g_size)
	end_y = _drp_y_end or end_y or 6
	local gsz = g_size or 2
	local loop_on = false
	if gsz == 3 then
		gsz = 1
		loop_on = true
	end
	screen_test()
	local this_screen = _this_screen
	-- 3534 bug not fixed, MoveMouseToVirtual not accept floot number
	local gp_x = math.floor((this_screen.grid_end[x] - this_screen.grid_start[x]) / 9)
	local gp_y = math.floor((this_screen.grid_end[y] - this_screen.grid_start[y]) / 5)

	function loop_check()
		if mdf_check() == gsz or loop_on then
			return true
		end
	end

	function func_in_loop(g_x, g_y)
		local x1 = this_screen.grid_start[x] + gp_x * (g_x - 1)
		local y1 = this_screen.grid_start[y] + gp_y * (g_y - 1) * gsz
		if ((g_x == start_x and g_y >= start_y) or (g_x > start_x and g_x < end_x) or (g_x == end_x and g_y <= end_y)) and loop_check() then
			MoveMouseToVirtual(x1, y1)
			func_grid()
		end
	end

	func_pre()

	if gsz == 1 then
		for gx = 1, 10 do
			for gy = 1, 6 do
				func_in_loop(gx, gy)
			end
		end
	elseif gsz == 2 then
		for gy = 1, 3 do
			for gx = 1, 10 do
				func_in_loop(gx, gy)
			end
		end
	end

	func_post()
	
	MoveMouseToVirtual(this_screen.mid[x], this_screen.mid[y])
end

-- switch not in use since S21
function drop(s_x, s_y, e_x, e_y, leave)
	-- 1 drop and switch
	-- 2 drop, leave and switch
	-- 3 drop only, don't leave nor switch
	-- default as 3
	leave = leave or 3
	local keys = _keys
	local this_screen = _this_screen
	function drop_pre()
		--say666()	-- just kidding, don't care
		PressAndReleaseKey(keys.clear)
		Sleep(5)
		PressAndReleaseKey(keys.inventory)
		Sleep(5)
		PressKey(keys.stand)
	end
	function drop_grid()
		local dl = _dl_in_grid
		Sleep(dl)
		PressAndReleaseMouseButton(1)
		Sleep(dl)
		MoveMouseToVirtual(this_screen.mid[x], this_screen.mid_y)
		Sleep(dl)
		PressAndReleaseMouseButton(1)
		Sleep(dl)
	end
	function drop_post()
		ReleaseKey(keys.stand)
		if leave == 2 then
			Sleep(10)
			PressAndReleaseKey("escape")
			Sleep(10)
			PressAndReleaseKey("escape")
			MoveMouseToVirtual(this_screen.leave_game[x], this_screen.leave_game[y])
			Sleep(10)
			PressAndReleaseMouseButton(1)
			Sleep(10)
		end
		if leave ~= 3 then
			app_switch()
		end
	end
	mdf_wait()
	grid_loop(s_x, s_y, e_x, e_y, drop_pre, drop_grid, drop_post, 3)
end

function salvage_all(s_x, s_y, e_x, e_y)
	function pre_salv()
		macro_stop()
	end
	function salvage_grid()
		for i = 1, 2 do
			local dl = _dl_in_grid
			Sleep(dl)
			PressAndReleaseMouseButton(1)
			Sleep(dl)
			PressAndReleaseKey("Enter")
		end
	end
	function post_salv()
		PressAndReleaseKey("escape")
		Sleep(10)
		PressAndReleaseKey(_keys.clear)
		Sleep(10)
		PressAndReleaseKey(_keys.inventory)
		if _alt_keep then
			Sleep(10)
			PressAndReleaseKey("lalt")
		end
	end
	mdf_wait()
	grid_loop(s_x, s_y, e_x, e_y, pre_salv, salvage_grid, post_salv, 3)
end

function paragon_allot()
	screen_test()
	my_load("_g_vars")
	local this_screen	= _this_screen
	local keys 			= _keys
	
	local paragon_level = _paragon_level or 3000
	local pl 		= pl_set								-- pl_set set in profile
	local p_l_tab_1 = paragon_level - 600					-- points avable in TAB1 Core
	local pwr_cntrl = math.floor(pl.power / 50)
	local spd_cntrl = math.floor(pl.speed / 50)
	local spd_shtft = math.floor((pl.speed - spd_cntrl * 50) / 5)
	local spd_click = (pl.speed - spd_cntrl * 50 - spd_shtft * 5) / 0.5
	local vit_cntrl = math.ceil(pl.vitality / 500)
	local int_cntrl = math.ceil((p_l_tab_1 - 100 - pl.vitality / 5) / 100)
	local ard_cntrl = math.floor(pl.area_damage / 50)						

	local pwr_press = {pwr_cntrl, 0, 0}
	local spd_press = {spd_cntrl, spd_shtft, spd_click}
	local vit_press = {vit_cntrl, 0, 0}
	local int_press = {int_cntrl, 0, 0}
	local dft_press = {1, 0, 0}
	local ard_press = {ard_cntrl, 0, 0}

	local p_tab_do = {
		[1] = {pwr_press, spd_press, vit_press, int_press},
		[4] = {dft_press, dft_press, dft_press, ard_press},
	}

	local dia_clear = false

	function goto_tab(tab_id)
		MoveMouseToVirtual(this_screen.p_tab[x][tab_id], this_screen.p_tab[y])
		PressAndReleaseMouseButton(1)
		Sleep(10)
	end

	function click_reset_button(p_tab_id)
		goto_tab(p_tab_id)
		MoveMouseToVirtual(this_screen.p_reset[x], this_screen.p_reset[y])
		PressAndReleaseMouseButton(1)
		Sleep(10)
	end
	
	function click_add_button(add_id, add_press)
		MoveMouseToVirtual(this_screen.p_add[x], this_screen.p_add[y][add_id])
		Sleep(20)
		local mdf_press = {"lctrl", "lshift", keys.stand}
		for k = 1, 3 do
			if add_press[k] > 0 then
				PressKey(mdf_press[k])
				Sleep(20)
				for i = 1, add_press[k] do
					PressAndReleaseMouseButton(1)
					Sleep(10)
				end
				ReleaseKey(mdf_press[k])
			end
		end
	end

	function pre_allot()
		PressKey(keys.stand)
		Sleep(50)
		PressAndReleaseKey(keys.clear)
		Sleep(10)
		PressAndReleaseKey(keys.paragon)
		Sleep(10)
	end

	function fast_allot()
		mdf_wait()
		dia_clear = true
		Sleep(50)
		MoveMouseToVirtual(this_screen.p_tab[x][1], this_screen.p_tab[y])
		Sleep(10)
		PressAndReleaseMouseButton(1)
		Sleep(20)
		MoveMouseToVirtual(this_screen.p_add[x], this_screen.p_add[y][4])
		PressKey("lctrl")
		Sleep(10)
		PressAndReleaseMouseButton(1)
		--Sleep(10)
		ReleaseKey("lctrl")
	end

	function low_allot()
		mdf_wait()
		my_load("_g_low_pa")
		local flow = _low_pa_flow
		for tid = 1, 4 do
			goto_tab(tid)
			for a_tbl = 1, 4 do
				MoveMouseToVirtual(this_screen.p_add[x], this_screen.p_add[y][flow[tid][a_tbl]])
				--Sleep(20)
				PressKey("lctrl")
				Sleep(10)
				PressAndReleaseMouseButton(1)
				ReleaseKey("lctrl")
			end
		end
	end

	function high_allot()
		for t = 4, 1, -1 do
			if p_tab_do[t] then
				click_reset_button(t)
				for i = 1, 4 do
					click_add_button(i, p_tab_do[t][i])
				end
			end
		end
	end

	function post_allot(m_sw, m_name)
		MoveMouseToVirtual(this_screen.p_accept[x], this_screen.p_accept[y])
		Sleep(10)
		PressAndReleaseMouseButton(1)
		Sleep(10)
		MoveMouseToVirtual(_ori[x], math.abs(_screen_test[y] - _ori[y]))
		ReleaseKey(keys.stand)
		if m_sw and m_name then
			AbortMacro()
			PlayMacro(m_name)
		end
	end

	pre_allot()

	-- allot
	if IsModifierPressed("lctrl") then
		fast_allot()
	else
		if _paragon_level <= 800 then
			low_allot()
		else
			high_allot()
		end
	end

	post_allot(nil, nil)
	if dia_clear then
		PressAndReleaseKey(keys.clear)
	end
end

-- grid: Inventory grid
function grid_mdf(mdf_state)
	function salvage_single()
		Sleep(1)
		PressAndReleaseMouseButton(1)
		Sleep(1)
		PressAndReleaseKey("enter")
		Sleep(1)
		PressAndReleaseMouseButton(1)
		Sleep(1)
		PressAndReleaseKey("enter")
		Sleep(1)
	end
	local func = {
		[0] = salvage_single,
		--[1] = function() drop(2, 1, 10, 6, 1) end,
		--[2] = function() drop(2, 1, 10, 6, 2) end,
		[3] = function() drop(2, 1, 10, 6, 3) end,
		[4] = function() salvage_all(1, 1, 10, 6) end,
		[7] = function() alfred_help("gr") end,
	}
	mdf_wait()
	if func[mdf_state] then func[mdf_state]() end
end

-- tp: TransPort
function tp_mdf(mdf_state)
	screen_test()
	local dl = 10
	function town_portal()
		macro_stop()
		Sleep(dl)
		PressAndReleaseKey(_keys.tp)
	end
	function tp_2_town(act_id)
		macro_stop()
		local act = _this_screen["a"..act_id.."_icon"]
		local twn = _this_screen["a"..act_id.."_town"]
		PressAndReleaseKey(_keys.clear)
		Sleep(50)
		PressAndReleaseKey(_keys.map)
		Sleep(dl)
		PressAndReleaseMouseButton(3)
		Sleep(dl)
		MoveMouseToVirtual(act[x], act[y])
		Sleep(dl)
		PressAndReleaseMouseButton(1)
		Sleep(dl)
		MoveMouseToVirtual(twn[x], twn[y])
		Sleep(dl)
		PressAndReleaseMouseButton(1)
	end
	function tp_2_mate()
		-- for 2 mates team, or target must be mate 1 (2nd character)
		app_switch()
		Sleep(50)
		MoveMouseToVirtual(_this_screen.mate_2_icon[x], _this_screen.mate_2_icon[y])
		Sleep(dl)
		PressAndReleaseMouseButton(3)
		Sleep(50)
		MoveMouseToVirtual(_this_screen.mate_2_tp[x], _this_screen.mate_2_tp[y])
		Sleep(dl)
		PressAndReleaseMouseButton(1)
	end
	function tp_2_mate_1()
		-- for 2 mates team, or target must be mate 1 (2nd character)
		macro_stop()
		tp_2_mate()
	end
	function tp_2_me()
	-- only for 2 mates team, or target must be mate 2
		macro_pause()
		tp_2_mate()
		Sleep(dl)
		app_switch()
		Sleep(dl)
		macro_resume()
	end
	function tp_safe()
		-- must have HOMING PADS in grid 10,6
		-- ATTENTION: Homing pads here, risks being salvaged by salvage_all(x1,y1,10,6)
		-- so, this function force to set _drp_y_end = 4
		_drp_y_end = 4
		macro_stop()
		PressAndReleaseKey(_keys.clear)
		--screen_test()
		local dl = 5
		local grid_end = _this_screen.grid_end
		PressAndReleaseKey(_keys.clear)
		Sleep(dl)
		PressAndReleaseKey(_keys.inventory)
		Sleep(dl)
		MoveMouseToVirtual(grid_end[x], grid_end[y])
		Sleep(dl)
		PressAndReleaseMouseButton(3)
		Sleep(dl)
		PressAndReleaseKey(_keys.tp)
		Sleep(5500)
		MoveMouseToVirtual(grid_end[x], grid_end[y])
		Sleep(dl)
		PressAndReleaseMouseButton(3)
		Sleep(dl)
	end
	function tp_help()
		alfred_help("tp")
	end
	function no_func()
		return
	end
	local func = {
		[0] = town_portal,	
		[1] = function () tp_2_town(1)	end,
		[2] = function () tp_2_town(2)	end,
		[3] = no_func, --tp_2_me,
		[4] = tp_2_mate_1,
		[5] = tp_safe,
		[6] = no_func,
		[7] = tp_help,
	}
	-- mdf check MUST have, or app_switch may cause other mdf call
	mdf_wait()
	if func[mdf_state] then func[mdf_state]() end
end

function mdf_check()
	local mdf_state = 0
	if IsModifierPressed("ctrl")	then mdf_state = mdf_state + 1 end
	if IsModifierPressed("shift") 	then mdf_state = mdf_state + 2 end
	if IsModifierPressed("alt") 	then mdf_state = mdf_state + 4 end
	return mdf_state
end

function mdf_wait()
	local mdf_ck = mdf_check
	local mdf = mdf_ck()
	while mdf ~= 0 do
		mdf = mdf_ck()
	end
end

function cube_mdf(mdf)
	screen_test()
	local mt = _this_screen.cube_material
	local ok = _this_screen.cube_accept
	local pr = _this_screen.cube_previous
	local nx = _this_screen.cube_next
	function cube_do()
		local dl = 17	-- 30? 20?
		Sleep(dl)
		PressAndReleaseMouseButton(3)
		Sleep(dl)
		MoveMouseToVirtual(mt[x], mt[y]) 	-- material
		Sleep(dl)
		PressAndReleaseMouseButton(1)
		Sleep(dl)
		MoveMouseToVirtual(ok[x], ok[y]) 	-- upgrade / accept
		Sleep(dl)
		PressAndReleaseMouseButton(1)
		Sleep(dl)							-- ???
		MoveMouseToVirtual(pr[x], pr[y])	-- previous
		Sleep(dl)
		PressAndReleaseMouseButton(1)
		Sleep(280)							-- ???
		MoveMouseToVirtual(nx[x], nx[y])	-- next
		Sleep(dl)
		PressAndReleaseMouseButton(1)
		Sleep(dl)
	end
	function cube_pre()
		macro_stop()
	end
	function cube_post()
		return
	end
	function cube_single()
		local gx, gy = GetMousePosition()
		cube_do()
		MoveMouseToVirtual(gx, math.abs(_screen_test[y] - gy))
	end
	function cube_all(gsize)
		--PressAndReleaseKey("o")
		--Sleep(100)
		grid_loop(1, 1, 10, 6, cube_pre, cube_do, cube_post, gsize)
	end
	local func = {
		[0] = cube_single,
		[1] = function () cube_all(1) end,
		[2] = function () cube_all(2) end,
	}
	if func[mdf] then func[mdf]() end
end

function say(txt)
	local PARK = PressAndReleaseKey
	local STRS = string.sub	-- not tested.
	local dec_table = {
		[" "] = 57,
		["-"] = 12,
		[","] = 51,
		["."] = 52,
		[";"] = 39,
	}
	local dl = 10
	macro_pause()
	PARK("enter")
	Sleep(dl)
	PARK(53)
	Sleep(dl)
	PARK(_keys.paragon)
	Sleep(dl)
	PARK("enter")
	Sleep(dl)
	local sym, sym_dec
	for i = 1, #txt do
		sym = STRS(txt, i, i)
		sym_dec = dec_table[sym]
		if sym_dec then
			sym = sym_dec
		end
		PARK(sym)
		Sleep(dl)
	end
	Sleep(50)	-- maybe longer
	PARK("enter")
	Sleep(dl)
	macro_resume()
end

function say666() -- kidding...
	if math.fmod(GetRunningTime(), 100) == 66 then
		say("66666")
	else
		return
	end
end

function say_mdf(mdf_state)
	mdf_wait()
	screen_test()
	local msg_table = {
		[0] = "1",
		[1] = "33333",
		[2] = "11111",
		[3] = "333 great map",
		[4] = "333 good map",
		[5] = "tower found",
		[6] = "Keep tower",	
		[7] = "4444",
	}
	-- mac with alfred, message auto expansion MUST defined in Alfred Snippets -- NOT STABLE!!!
	if _screen_test[y] ~= 0 and _alfred_on then
		msg_table[3] = "d3m3"	-- 333 顶级图
		msg_table[4] = "d3m4"	-- 333 好图
		msg_table[5] = "d3m5"	-- 有塔
		msg_table[6] = "d3m6"	-- 留塔
	end
	if msg_table[mdf_state] then say(msg_table[mdf_state]) end
end

-- MUST have a Alfred Workflow: d3h{query}
-- new version, call by shortcut key
function alfred_help(msg)
	screen_test()
	if _screen_test[y] ~= 0 then
		msg = msg or "else"
		macro_pause()
		Sleep(10)
		PressKey("lalt", "lgui")
		Sleep(10)
		PressAndReleaseKey("t")
		ReleaseKey("lalt", "lgui")
		--mdf_wait()
		for i = 1, #msg do
			PressAndReleaseKey(string.sub(msg, i, i))
			Sleep(10)
		end
		Sleep(30)
		PressAndReleaseKey("enter")
		Sleep(10)
		macro_resume()
	end
end

-- new version, call by shortcut key
-- depend on Alfred Workflow: D3 vars
function alfred_d3v(msg)
	screen_test()
	if _screen_test[y] ~= 0 then
		msg = msg or ""
		macro_pause()
		Sleep(10)
		PressKey("lalt", "lgui")
		Sleep(10)
		PressAndReleaseKey("v")
		ReleaseKey("lalt", "lgui")
		--mdf_wait()
		for i = 1, #msg do
			PressAndReleaseKey(string.sub(msg, i, i))
			Sleep(10)
		end
		macro_resume()
	end
end

gfunc = {
	m =	{func = PressAndReleaseKey, delay = 0, r_func = false, restart_macro = false, arg = _keys.map,},
	tab = {func = PressAndReleaseKey, delay = 0, r_func = PressAndReleaseKey, restart_macro = true, arg = "tab"},
}

function gk_press(arg, rls_time, macro_rsm)
	gk_arg = arg
	rls_time = rls_time or false
	if rls_time and type(rls_time) ~= "number" then
		rls_time = 0
	end
	gk_macro_rsm = macro_rsm or false
	if macro_rsm then
		macro_pause()
	else
		macro_stop()
	end
	PressAndReleaseKey(arg)
	if rls_time then
		gk_timer = nil
		if rls_time > 0 then
			gk_rls_time = rls_time
			gk_timer = GetRunningTime()
		end
		gk_release = function()
			if (not gk_timer) or (GetRunningTime() - gk_timer >= gk_rls_time) then
				PressAndReleaseKey(gk_arg)
				gk_arg = nil
				gk_rls_time = nil
				gk_timer = nil
			end
			if gk_macro_rsm then
				macro_resume()
				gk_macro_rsm = nil
			end
			gk_release = nil
		end
	elseif macro_rsm then
		macro_resume()
	end
end

-- Call mode:
-- gk_map[family][arg]()
-- family, arg: OnEvent func paramaters
gk_map = {
	["lhc"] = {	-- for G13, not use now
		[2] = gfunc.m,
		[7] = function() tp_mdf(mdf_check()) end,
		[9] = function() say_mdf(mdf_check()) end,
		[14] = gfunc.tab,
		[26] = paragon_allot,
	},
	["kb"] = {	-- for GPro, G913TKL
		[1] = function() tp_mdf(1) end,
		[2] = function() tp_mdf(2) end,
		--[3] = gfunc.m,
		--[3] = function() gk_press(_keys.map) end,
		--[3] = function() play_sound("glass") end,
		--[3] = function() gk_press("tab",true,true) end,
		[4] = function() cube_mdf(mdf_check()) end,
		[5] = function() tp_mdf(mdf_check()) end,
		[6] = resume_game,
		[7] = function() say_mdf(mdf_check()) end,
		[8] = function() grid_mdf(mdf_check()) end,
		[9] = paragon_allot,
	},
	[""] = {	-- for G613, maybe in office? NOTE: test this family name first!
		[1] = function() tp_mdf(1) end,
		[2] = function() tp_mdf(2) end,
	},
}

screen_test() -- get screen pixel