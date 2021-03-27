pl_set = {
	power 		= 50,
	speed 		= 15,
	vitality 	= 2500,
	area_damage = 50,
}

my_load("_g_general")

local act_is_on = false
local swi_is_on = false
local t0		= -20000
local stand_dly = 5
local keys 		= _keys

local skill = {
	[1] = {timer = t0, rp_time = 100, key = keys.skill_1,},
	[2] = {timer = t0, rp_time = 100, key = keys.skill_2,},
	[3] = {timer = t0, rp_time = 100, key = keys.skill_3,},
	[4] = {timer = t0, rp_time = 5000, key = keys.skill_4,},
}

function refresh(sk)
	if GetRunningTime() - sk.timer > sk.rp_time then
		if type(sk.key) == "string" then
			PressAndReleaseKey(sk.key)
		else
			if sk.key == 1 then
				PressKey(keys.stand)
				Sleep(stand_dly)
				PressAndReleaseMouseButton(1)
				ReleaseKey(keys.stand)
			else
				PressAndReleaseMouseButton(sk.key)
			end
		end
		sk.timer = GetRunningTime()
	end
end

function refresh_all()
	for i, k in ipairs(skill) do
		refresh(k)
	end
end

function reset_timer(sk)
	sk.timer = t0
end

function reset_timer_all(...)
	for i, k in ipairs({...}) do
		reset_timer(k)
	end
end

function OnEvent(event, arg, family)
	--OutputLogMessage("\n"..event.." "..arg)
	if event == "MOUSE_BUTTON_PRESSED" and arg == keys.swi then
		swi_is_on = not swi_is_on
		if swi_is_on then
			EnablePrimaryMouseButtonEvents(true)
			if not IsKeyLockOn(keys.indicator) then
				PressAndReleaseKey(keys.indicator)
			end
		else
			EnablePrimaryMouseButtonEvents(false)
			if IsKeyLockOn(keys.indicator) then
				PressAndReleaseKey(keys.indicator)
			end
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
		cube_mdf(mdf_check())
	end
	if event == "MOUSE_BUTTON_PRESSED" and arg == keys.dpiup and not swi_on and not act_on then
		grid_mdf(mdf_check())
	end
	if event == "MOUSE_BUTTON_PRESSED" and arg == keys.drp then
		tp_mdf(mdf_check())
	end
	act_t0 = false
	while swi_is_on do
		if IsMouseButtonPressed(3) then
			return
		elseif mdf_check() == 4 or IsKeyLockOn(keys.indicator) then
			refresh(skill[1])
			--refresh(skill[2])
			--refresh(skill[3])
			--refresh(skill[4])
		else
			swi_is_on = false
			t0 = -20000
			break
		end
	end
end
