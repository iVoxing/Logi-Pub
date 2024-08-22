OutputLogMessage("\nD4 S5 Druid LandSlide Storm, Sample LUA. ")
--
_keys = {
	lmb = 1, mmb = 2, rmb = 3, 
	skill_1 = "f", skill_2 = "s", skill_3 = "e", skill_4 = "v",
	stand = "a", move = "d", tasks = "l",
}

x, y = 1, 2

_this_screen = { -- 3440/1440
	screen_centr	= {32768, 32768},
	btn_reset_dg	= {58865, 52920},
	btn_centr_ok	= {31176, 39030},
	lower_left		= {5793, 60115},
	lower_right		= {62448, 60115},
	lower_middle	= {30395, 56381},
	upper_left		= {5793, 5602},
	upper_right		= {62448, 5602},
	upper_middle	= {29823, 11613},
	icon_kyo		= {19056, 46043},
	icon_tow		= {25097, 27325},
	icon_iwe		= {38627, 32289},
	icon_zar		= {9376, 45906},
}

function mdf_check()
	local mdf_state = 0
	if IsModifierPressed("ctrl") 	then mdf_state = mdf_state + 1	end
	if IsModifierPressed("shift") 	then mdf_state = mdf_state + 2 end
	if IsModifierPressed("alt") 	then mdf_state = mdf_state + 4 end
	if IsMouseButtonPressed(4) 		then mdf_state = mdf_state + 8 end
	if IsMouseButtonPressed(5) 		then mdf_state = mdf_state + 16 end
	return mdf_state
end

function mdf_wait()
	local mdf_ck = mdf_check
	local mdf = mdf_ck()
	while mdf ~= 0 do
		mdf = mdf_ck()
		Sleep(1)
	end
end

function click_on(pos, slp1, btn, slp2)
	-- pos 是必須值，為一個包含 x，y 坐標值的表
	-- 其他幾個值非必須，各有其缺省值
	MoveMouseToVirtual(pos[x], pos[y])
	Sleep(slp1 or 10)
	PressAndReleaseMouseButton(btn or 1)
	Sleep(slp2 or 0)
end

function set_stand_on(dl)
	dl = dl or 5
	if not stand_on then
		PressKey(_keys.stand)
		Sleep(dl)
		stand_on = true
	end
end
function set_stand_off()
	if stand_on then
		ReleaseKey(_keys.stand)
		stand_on = false
	end
end
function set_move_on()
	if not move_on then
		PressKey(_keys.move)
		move_on = true
	end
end
function set_move_off()
	if move_on then
		ReleaseKey(_keys.move)
		move_on = false
	end
end
function set_lmb_down()
	if not lmb_down then
		PressMouseButton(1)
		lmb_down = true
	end
end
function set_lmb_up()
	if lmb_down then
		ReleaseMouseButton(1)
		lmb_down = false
	end
end
function set_rmb_down()
	if not rmb_down then
		PressMouseButton(3)
		rmb_down = true
	end
end
function set_rmb_up()
	if rmb_down then
		ReleaseMouseButton(3)
		rmb_down = false
	end
end

function refresh(sk)
	sk.timer = sk.timer or 0
	local func = {
		string 	= sk.foo or PressAndReleaseKey,
		number 	= sk.foo or PressAndReleaseMouseButton,
	}
	setmetatable(func, {__index = function() return "\ndo nothing. " end})
	if GetRunningTime() - sk.timer > sk.rp_time then
		func[type(sk.key)](sk.key)
		sk.timer = GetRunningTime()
	end
end

-- click_on function in _g_general_0
function reset_dg()
	PressAndReleaseKey(_keys.tasks)
	Sleep(100)
	click_on(_this_screen.btn_reset_dg, 20, 1, 100)
	click_on(_this_screen.btn_centr_ok, 20, 1, 100)
	PressAndReleaseKey("escape")
end

-- transport to termini
function tp_2(termini, act_list)
	local test_t_mark
	--test_t_mark = GetRunningTime()
	-- dl 大小会影响操作，可能跟延迟有关，注意调适
	-- dl = 5 操作不成功
	-- 应该不需要都设为 30，有优化余地，但比较无所谓
	-- 目前總耗時約 750ms
	local dl = 30
	local ma = 1
	local drag_pt = {
		[1] = "lower_left",
		[2] = "lower_right",
		[3] = "lower_middle",
		[4] = "upper_left",
		[5] = "upper_right",
		[6] = "upper_middle",
	}
	function mouse_act(idx)
		local foo = {
			[1] = PressMouseButton,
			[-1] = ReleaseMouseButton,
		}
		local pt = _this_screen[drag_pt[idx]]
		MoveMouseToVirtual(pt[x], pt[y])
		Sleep(dl)
		foo[ma](1)
		ma = ma * -1
		Sleep(dl)	-- 感觉可以省略
	end
	-- 滚轮缩放三次
	for i = 1, 3 do
		MoveMouseWheel(-3)
		Sleep(dl)	-- 感觉可以优化
	end
	-- 拖动地图到预期位置
	for i = 1, #act_list do
		mouse_act(act_list[i])
	end
	click_on(_this_screen[termini], dl, 1, dl)
	click_on(_this_screen.btn_centr_ok, dl, 1, dl)
	if test_t_mark then
		local t_running = GetRunningTime() - test_t_mark
		OutputLogMessage("\ntp_2 running time: "..t_running.."ms.\n")
	end
end

-- transport to tree of whispers 秘语之树
function tp_2_tow()
	local termini = "icon_tow"
	local act_list = {2, 4, 2, 4, 2, 4, 6, 3}
	tp_2(termini, act_list)
end

-- transport to iron wolves encampment 铁狼营地
function tp_2_iwe()
	local termini = "icon_iwe"
	local act_list = {1, 5, 1, 5, 1, 5, 6, 3}
	tp_2(termini, act_list)
end

-- transport to iron Zarbinzet (S5) 扎宾泽特
function tp_2_zar()
	local termini = "icon_zar"
	local act_list = {2, 4, 2, 4, 2, 4, 6, 3}
	tp_2(termini, act_list)
end


-- transport to Kyovashad 基奥瓦沙
function tp_2_kyo()
	local termini = "icon_kyo"
	local act_list = {5, 1, 5, 1, 5, 1, 3, 6}
	tp_2(termini, act_list)
end

function drop_single()
	local dl = 50
	local ptx, pty = GetMousePosition()
	Sleep(dl)
	PressAndReleaseMouseButton(1)
	Sleep(dl)
	click_on(_this_screen.screen_centr, dl, 1, dl)
	Sleep(dl)
	MoveMouseToVirtual(ptx, pty)
end

function swi_loop()
	swi_is_on = not swi_is_on
end

function get_xy()
	arg = arg or 5
	local px, py = GetMousePosition()
	OutputLogMessage("\nG"..arg..":\t"..px.."\t"..py.."\n")
end

function tp_mdf(mdf_state)
	mdf_state = mdf_state or mdf_check()
	local func = {
		[0] = get_xy,
		[1] = tp_2_kyo,
		[2] = tp_2_tow,
		[4] = tp_2_zar,
	}
	mdf_wait()
	if func[mdf_state] then func[mdf_state]() end	
end

event_map = {
	MOUSE_BUTTON_PRESSED = {
		[4] = swi_loop,
		[5] = tp_mdf,
		[8] = tp_mdf,
	},
	G_PRESSED = {
		[1] = tp_2_kyo,
		[4] = reset_dg,
		[5] = tp_2_tow,
		[6] = tp_2_zar,
		[8] = drop_single,
	},
}

swi_is_on	= false
loop_idle	= false
t6 = 300

local skill = {
	lmb	= {rp_time = 20, key = 1,},
	rmb = {rp_time = t6, key = 3,},
	[1] = {rp_time = 50, key = _keys.skill_1,},
	[2] = {rp_time = 50, key = _keys.skill_2,},
	[3] = {rp_time = 50, key = _keys.skill_3,},
	[4] = {rp_time = 50, key = _keys.skill_4,},
}

function loop_play(mdf)
	last_mdf = last_mdf or mdf
	function loop_idle_check(tm)
		tm = tm or 1000
		loop_idle = loop_idle or GetRunningTime()
		if GetRunningTime() - loop_idle > tm then
			loop_idle = false
			swi_is_on = false
		end
	end
	function play_main()
		loop_idle = false
		refresh(skill[1])
		refresh(skill[3])
		set_rmb_down()
		loop_done = true
	end
	function play_alt()
		loop_idle = false
		set_stand_on()
		refresh(skill[1])
		refresh(skill[3])
		refresh(skill.rmb)
		refresh(skill.lmb)
		loop_done = true
	end
	function play_none()
		if loop_done then
			loop_done = false
			loop_idle = false
			swi_is_on = false
			set_rmb_up()
			set_stand_off()
		else
			loop_idle_check()
		end
	end
	local func = {
		[0] = play_none,
		[8] = play_main,
		[10] = play_alt,
	}
	if last_mdf ~= mdf and last_mdf * mdf > 0 then
		loop_done = false
		loop_idle = false
		set_rmb_up()
		set_stand_off()
	end
	last_mdf = mdf
	if func[mdf] then func[mdf]() end
end

function OnEvent(event, arg, family)
	--OutputLogMessage("\n"..event.." "..arg)
	if event == "PROFILE_DEACTIVED" then
		swi_is_on = false
		loop_idle = false
	end
	local func = event_map[event]
	if func then
		if type(func) == "function" then
			func()
		elseif type(func) == "table" then
			func = event_map[event][arg]
			if func and type(func) == "function" then
				func()
			end
		end
	end
	while swi_is_on do
		loop_play(mdf_check())
		Sleep(1)	-- reduce LGHUB %CPU 
	end
end
