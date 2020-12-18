-- DH Gears of Dreadlands Set
-- Entangling and Hungering
-- S22 only, independ on the fourth cube extraction (Odyssey's End)

-- skill
--		1 		Hungering Arrow / Entangling Shot
--		2 		Vengeance
--		3 		Preparation
--		4 		Shadow Power / Smoke Screen
--		left	Entangling Shot / Hungering Arrow
--		right	Strafe

-- Play:
--		Press Capslock on (Mac only)
--		Press G5 to start
--		Press and hold Alt 			to run, evade, or open doors etc
--		Press and hold Ctrl 		to play Hungering Shot
--		Press and hold Ctrl + Alt	to play Entangling Shot

-- Strategy:
--		Play Entangling shot at Physics 2nd or 3rd, then Play Hungering shot at Cold 0
--		or always play Entangling shot untill Cold period

-- NOT TESTED EVER!!!

pl_set = {
	power		= 50,
	speed		= 25,
	vitality	= 2000,
	area_damage = 50,
}

function my_load(file)
	local f = loadfile("/Users/iVox/Dropbox/12 Setting/Logi/"..file..".lua")
	if not f then
		f = loadfile("D:\\Dropbox\\12 Setting\\Logi\\"..file..".lua")
	end
	return f()
end
my_load("_g_general")

local keys 		= _keys
local swi_is_on = false	
local sk_4_rpt 	= 5000		-- smoke: 50, 	shadow: 5000
local t0		= -20000	
local gain_mom
local rf_pause	= false
local stand_on	= false
local rmb_down	= false
local tab_down	= false
local move_on	= false

local skill = {
	[1] = {timer = t0, rp_time = 500, 		key = keys.skill_1,},		-- Entangle
	[2] = {timer = t0, rp_time = 50, 		key = keys.skill_2,},		-- Vengeance
	[3] = {timer = t0, rp_time = 50, 		key = keys.skill_3,},		-- Preparation
	[4] = {timer = t0, rp_time = sk_4_rpt,	key = keys.skill_4,},		-- Shadow
}

function mdf_ck()
 	local mdf_state = 0
 	if IsModifierPressed("ctrl")	then mdf_state = mdf_state + 1 end
 	if IsModifierPressed("shift")	then mdf_state = mdf_state + 2 end
 	if IsModifierPressed("alt")		then mdf_state = mdf_state + 4 end
 	if IsMouseButtonPressed(4)		then mdf_state = mdf_state + 8 end
 	if IsMouseButtonPressed(5)		then mdf_state = mdf_state + 16 end
 	return mdf_state
end

function refresh(sk)
	local stand_dly = 5
	if GetRunningTime() - sk.timer >= sk.rp_time then
		if type(sk.key) == "string" then
			PressAndReleaseKey(sk.key)
			if sk.key == "enter" then
				PressAndReleaseKey("escape")
			end
		else
			if sk.key == 1 then
				PressKey(keys.stand)
				Sleep(stand_dly)
				PressAndReleaseMouseButton(1)
				Sleep(stand_dly)
				ReleaseKey(keys.stand)
			else
				PressAndReleaseMouseButton(sk.key)
			end
		end
		sk.timer = GetRunningTime()
	end
end

function gain_momentum()
	if gain_mom then
		refresh(skill[2])
		refresh(skill[4])
		PressKey(keys.stand)
		Sleep(100)
		PressMouseButton(1)
		Sleep(2000)
		ReleaseMouseButton(1)
		ReleaseKey(keys.stand)
		gain_mom = nil		
	end
end

function play_mdf(mdf)
	local mb1_dl = 18	-- 16, 17, 18, 484, 485, 18 may be the best
	function set_stand_off()
		if stand_on then
			ReleaseKey(keys.stand)
			stand_on = false
		end
	end
	function set_stand_on()
		if not stand_on then
			PressKey(keys.stand)
			stand_on = true
		end
	end
	function set_move_on()
		if not move_on then
			PressKey(keys.move)
			move_on = true
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
	function play_EnS()
		set_rmb_down()
		refresh(skill[1])
		refresh(skill[2])
		refresh(skill[3])
		refresh(skill[4])
	end
	function play_HnS()
		set_rmb_down()
		refresh(skill[2])
		refresh(skill[3])
		refresh(skill[4])
		PressAndReleaseMouseButton(1)
		Sleep(mb1_dl)
	end
	function g_pause()
		if not rf_pause then
			PressAndReleaseKey(keys.clear)
			Sleep(20)
			PressAndReleaseKey("escape")
			Sleep(100)
			PressAndReleaseKey("enter")
			rf_pause = true
		end
	end
	function g_resume()
		if rf_pause then
			PressAndReleaseKey("escape")
			Sleep(10)
			PressAndReleaseKey("escape")
			rf_pause = false
		end
	end
	function map_on()
		if not tab_down then
			PressAndReleaseKey("tab")
			Sleep(20)
			tab_down = true
		end
	end
	function map_off()
		if tab_down then
			PressAndReleaseKey("tab")
			Sleep(20)
			tab_down = false
		end
	end
	function no_action()
		g_resume()
		map_off()
		set_stand_off()
		set_rmb_up()
	end
	function main_HnS()
		set_stand_on()
		play_HnS()
	end
	function free_HnS()
		set_stand_off()
		play_HnS()		
	end

	local func = {
		[0]		= no_action,
		[1]		= main_HnS,
		[2]		= play_EnS,
		[4]		= free_HnS,
		[5]		= play_EnS,
		[8]		= g_pause,		-- ATTENTION: confirm G4 set to default
		[16]	= map_on,		-- ATTENTION: confirm G5 set to default
	}
	if func[mdf] then func[mdf]() end
end

function OnEvent(event, arg, family)
	--OutputLogMessage("\n"..event.." "..arg)
	if event == "MOUSE_BUTTON_PRESSED" and arg == keys.swi then
		PressAndReleaseKey(keys.indicator) -- works in Windows OS only
		Sleep(100)
		if IsKeyLockOn(keys.indicator) then
			swi_is_on 	= true
			gain_mom	= true
			gain_momentum()
			--EnablePrimaryMouseButtonEvents(true)
		else
			swi_is_on 	= false
			gain_mom	= nil
			--EnablePrimaryMouseButtonEvents(false)
		end
	end
	if event == "G_PRESSED" then
		local func = gk_map[family][arg]
		if func then func() end
	end
	if event == "G_RELEASED" then
		if gk_release then gk_release() end
	end
	if event == "MOUSE_BUTTON_PRESSED" and arg == keys.dpidn then
		cube_mdf(mdf_ck())
	end
	if event == "MOUSE_BUTTON_PRESSED" and arg == keys.dpiup and not swi_on and not act_on then
		grid_mdf(mdf_ck())
	end
	if event == "MOUSE_BUTTON_PRESSED" and arg == keys.drp then
		tp_mdf(mdf_ck())
	end
	stand_on = false
	rmb_down = false
	while swi_is_on do
		if IsKeyLockOn(keys.indicator) then
			if move_on then
				ReleaseKey(keys.move)
				move_on = false
			end
			play_mdf(mdf_ck())
		else
			t0 = -20000
			ReleaseKey(keys.stand)
			ReleaseMouseButton(3)
			stand_on 	= false
			rmb_down 	= false
			swi_is_on	= false
			break
		end
	end
end
