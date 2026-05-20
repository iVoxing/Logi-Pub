
OutputLogMessage("\nD4 temp for ALL classes and ALL seasons. ")


local keys = {
	lmb = 1, mmb = 2, rmb = 3, 
	act = 4, swi = 5, msg = 6, drp = 7, 
	dpidn = 8, dpiup = 9, pik = 10, buy = 11, 
	g4 = 4, g5 = 5, g6 = 6, g7 = 7,
	skill_1 = "f", skill_2 = "s", skill_3 = "e", skill_4 = "v",
	stand = "a", move = "d", clear = "b", inventory = "i", dash = "w",
	paragon = "p", map = "m", tp = "t", potion = "z", tasks = "l",
	indicator = "capslock",	screenshot = "f12",
}


function mdf_check()
	local mdf_state = 0
	if IsModifierPressed("ctrl") 	then mdf_state = mdf_state + 1 end
	if IsModifierPressed("shift") 	then mdf_state = mdf_state + 2 end
	if IsModifierPressed("alt") 	then mdf_state = mdf_state + 4 end
	if IsMouseButtonPressed(4) 	then mdf_state = mdf_state + 8 end
	if IsMouseButtonPressed(5) 	then mdf_state = mdf_state + 16 end
	if IsMouseButtonPressed(3) 	then mdf_state = mdf_state + 32 end
	return mdf_state
end


function rsleep(min, max)
	Sleep(math.random(min, max))
end


-- 狀態設置
_is = {
	stand 	= false,
	move	= false,
	lmb_dn	= false,
	rmb_dn	= false,
}


function set_stand_on(dl)
	dl = math.max(dl or 5, 5) -- 實測 5 比較合適，太低不起作用
	if not _is.stand then
		PressKey(keys.stand)
		Sleep(dl)
		_is.stand = true
	end
end

function set_stand_off()
	if _is.stand then
		ReleaseKey(keys.stand)
		rsleep(3, 5)
		_is.stand = false
	end
end

function set_move_on()
	if not _is.move then
		PressKey(keys.move)
		_is.move = true
	end
end

function set_move_off()
	if _is.move then
		ReleaseKey(keys.move)
		_is.move = false
		Sleep(5)
		PressAndReleaseKey(keys.move) -- 增加這句，解決了停止循環後，按移動但角色行動停滯的情況。停滯原因應該是 ReleaseKey 實際作用在按下移動鍵之後，相當於又取消了移動，有了這句就一切 OK
	end
end

function set_lmb_down()
	if not _is.lmb_dn then
		PressMouseButton(1)
		_is.lmb_dn = true
	end
end

function set_lmb_up()
	if _is.lmb_dn then
		ReleaseMouseButton(1)
		_is.lmb_dn = false
	end
end

function set_rmb_down()
	if not _is.rmb_dn then
		PressMouseButton(3)
		_is.rmb_dn = true
	end
end

function set_rmb_up()
	if _is.rmb_dn then
		ReleaseMouseButton(3)
		_is.rmb_dn = false
	end
end


function refresh(sk)
	
	function PARK(key)
		PressKey(key)
		rsleep(5, 10)
		ReleaseKey(key)
		rsleep(5, 10)
		PressAndReleaseKey(keys.move)
		rsleep(5, 10)
	end

	function PARMB(key)
		PressMouseButton(key)
		rsleep(5, 10)
		ReleaseMouseButton(key)
		rsleep(5, 10)
		PressAndReleaseKey(keys.move)
		rsleep(5, 10)
	end

	sk.timer = sk.timer or 0
	sk.rp_time = sk.rp_time or 50

	local func = {
		string 	= sk.foo or PARK,
		number 	= sk.foo or PARMB,
	}	
	
	if GetRunningTime() - sk.timer > sk.rp_time then
		func[type(sk.key)](sk.key)
		sk.timer = GetRunningTime()
	end

end


local swi_is_on	= false	-- 控制是否循环
local is_rmb_rfd = false

function swi_loop()
	swi_is_on = not swi_is_on
end


event_map = {
	MOUSE_BUTTON_PRESSED = {
		[2] = swi_loop,
		[4] = swi_loop,
	},
	G_PRESSED = {
	},
}


local skill = {
	lmb	= {rp_time = 50, key = 1,},
	rmb	= {rp_time = 50, key = 3,},
	mov = {rp_time = 50, key = keys.move,},
	das	= {rp_time = 50, key = keys.dash,},
	[1] = {rp_time = 50, key = keys.skill_1,},
	[2] = {rp_time = 50, key = keys.skill_2,},
	[3] = {rp_time = 50, key = keys.skill_3,},
	[4] = {rp_time = 50, key = keys.skill_4,},
}


function loop_play(mdf)

	function play_main()
		refresh(skill.rmb)
		refresh(skill.lmb)
		refresh(skill[1])
		refresh(skill[3])
		refresh(skill[4])
	end

	function play_alt()
		play_main()
		refresh(skill[2])
	end

	function play_rmb()
		if not is_rmb_rfd then
			skill.rmb.timer = GetRunningTime()
			is_rmb_rfd = true
		end
		play_main()
	end

	function play_none()
		is_rmb_rfd = false
		swi_is_on = false
	end

	local func = {
		[0] 	= play_none,
		[8] 	= play_main,
		[10] 	= play_alt,
		[32] 	= play_rmb,
		[40] 	= play_rmb,
	}
	if func[mdf] then func[mdf]() end

end


function OnEvent(event, arg, family)
	--OutputLogMessage("\n"..event.." "..arg)

	local func = event_map[event]
	if type(func) == "table" then
		func = func[arg]
	end
	if type(func) == "function" then
		func()
	end

	while swi_is_on do
		Sleep(5)	-- reduce %CPU and wait mdf_state
		loop_play(mdf_check())
	end

end
