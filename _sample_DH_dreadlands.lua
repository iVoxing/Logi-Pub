-- DH Cold Hungering Arrow, Gears of Dreadlands
-- S21, S22
-- skill
--		1 		Fan of Knives / Companion
--		2 		Vengeance
--		3 		Preparation
--		4 		Shadow Power / Smoke Screen
--		left	Hungering Arrow
--		right	Strafe
-- Play:
--		Press Capslock on (Mac only)
--		Press G5 to start
--		Press and hold Alt to attack
--		Press and hold Ctrl to evade, run, or open doors etc
--		Press and hold to pause game and read logs
--		Press both Shift and Alt to dismiss follower
OutputLogMessage("\nDH Dreadlands Set, Cold Hungering Arrow")

pl_set = {
	power		= 50,
	speed		= 25,
	vitality	= 2000,
	area_damage = 50,
}

my_load("_sample_g_general")

local keys 		= _keys
local swi_is_on = false	
local pet, fan	= 1, 2	
local sk_1		= fan		
local sk_4_rpt 	= 4980		-- smoke: 50, 	shadow: 4950
local t0		= -20000	
local dsms_flwr
local gain_mom
local rf_pause	= false
local stand_on	= false
local rmb_down	= false
local move_on	= false
local mb1_dl	= 16

local skill = {
	lmb	= {timer = t0, rp_time = mb1_dl, 	key = 1,},
	[1] = {timer = t0, rp_time = 50, 		key = keys.skill_1,},		-- Pet or Fan
	[2] = {timer = t0, rp_time = 50, 		key = keys.skill_2,},		-- Vengeance
	[3] = {timer = t0, rp_time = 50, 		key = keys.skill_3,},		-- Preparation
	[4] = {timer = t0, rp_time = sk_4_rpt,	key = keys.skill_4,},		-- Shadow
	ent = {timer = t0, rp_time = 30000, 	key = "enter",},			-- Keep messages on
	scr = {timer = t0, rp_time = 10000, 	key = keys.screenshot},
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
	if GetRunningTime() - sk.timer >= sk.rp_time then
		if type(sk.key) == "string" then
			PressAndReleaseKey(sk.key)
			if sk.key == "enter" then
				PressAndReleaseKey("escape")
			end
		else
			if sk.key == 1 then
				PressAndReleaseMouseButton(1)
			end
		end
		sk.timer = GetRunningTime()
	end
end

function gain_momentum()
	if gain_mom and not IsModifierPressed("ctrl") then
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

function hunger_n_strafe(mdf)
	--local mb1_dl = 16	-- 16, 17, 18, 484, 485, 18 may be the best
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
	function set_move_off()
		if move_on then
			ReleaseKey(keys.move)
			move_on = false
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
	function play_HnS()
		set_rmb_down()
		refresh(skill[1])
		refresh(skill[2])
		refresh(skill[3])
		refresh(skill[4])
		refresh(skill.lmb)
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


	-- works
	-- sample of IsMouseButtonPressed usage


	if IsMouseButtonPressed(5) then
		set_stand_off()
		play_HnS()		
		refresh(skill.ent)
	end

	local func = {
		[0] = function()
			g_resume()
			set_stand_off()
			set_move_off()
			set_rmb_up()
			--refresh(skill.ent)
		end,
		[1] = function() 
			g_resume()
			set_stand_on()
			set_move_off()
			mb1_dl = 3600
			play_HnS()
		end,
		[2] = function()
			g_resume()
			set_stand_off()
			set_move_on()
			mb1_dl = 18
			play_HnS()		
			--refresh(skill.ent)
		end,
		[4] = function()
			g_resume()
			set_stand_off()
			set_move_off()
			mb1_dl = 17
			play_HnS()		
			--refresh(skill.ent)
		end,
		[7] = function() 
			if dsms_flwr then
				dsms_flwr()
			end
		end,
		[8] 	= g_pause,		-- ATTENTION: confirm G4 set to default
		[9] 	= g_pause,		-- ATTENTION: confirm G4 set to default
		[12] 	= g_pause,		-- ATTENTION: confirm G4 set to default
		[13] 	= g_pause,		-- ATTENTION: confirm G4 set to default
		[16] = function()		-- ATTENTION: confirm G5 set to default
			set_stand_off()
			play_HnS()		
			--refresh(skill.ent)
		end,
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
			dsms_flwr	= function () dismiss_follower() dsms_flwr = nil end
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
			--refresh(skill.scr)	-- ATTENTION: this works, a little performance loss
			if move_on then
				ReleaseKey(keys.move)
				move_on = false
			end
			hunger_n_strafe(mdf_ck())
		else
			swi_is_on = false
			t0 = -20000
			ReleaseKey(keys.stand)
			stand_on = false
			ReleaseMouseButton(3)
			rmb_down = false
			break
		end
	end
end
