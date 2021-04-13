-- Wizard Firebird, Image FBB
-- S23
-- Skill:
--		1		Explosive blast
--		2		Frost nova
--		3		Teleport
--		4		Mirror image
--		left	Spectral Blade
--		right	Disintegrate
-- Macro on G Mouse:
--		"1", 100ms loop, Banding on G5
-- Play:
--		Press G5 to lock blasting and channelling
--		at cold 0 or elec 0, Press G4 to set loop time, +ALT to set loop mode to 16s
--		seek elite to fight, by manually teleporting
--		Press and hold SHIFT then click left to start loop
--		follow the script, seeking elite or oculus circle or safe area
--		Release SHIFT to end loop

OutputLogMessage("\nWizard Firebird, Image FBB")

pl_set = {
	power 		= 50,
	speed 		= 50,
	vitality 	= 1000,
	area_damage = 0,
}

my_load("_sample_g_general")

local mode		= 1			-- 1 for 8s loop, 2 for 16s
local keys		= _keys
local swi_is_on = false
local act_is_on	= false
local active_s2	= true
local act_flow	= nil
local t0		= nil
local t0_offset	= 0			-- for adjust, such as -5
local t_range	= 10
local swi_macro = "1_100ms"	-- blast, simple loop macro
local rmb_down	= false
local x, y 		= 1, 2

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

function set_act_flow_time()
	t0 = GetRunningTime() + t0_offset	-- at cold 0, or elec 0
	act_flow = {
		t_00 = {timing = t0,		func = loop_start,},
		t_05 = {timing = t0 + 1000,	func = jump_to_target,},	-- jump to target
		t_20 = {timing = t0 + 2200,	func = image_n_channel,},	-- call image, channel
		t_35 = {timing = t0 + 3200,	func = jump_to_target,},	-- jump to target or oculus circle
	}
end

function time_check(t)
	if math.fmod(GetRunningTime() - t, 8000 * mode) < t_range then
		return true
	else
		return false
	end
end

function loop_start()
	act_is_on = true
	set_rmb_down()
end

function jump_to_target()
	if act_is_on then
		PressAndReleaseKey("d")
	end
end

function image_n_channel()
	PressAndReleaseKey("v")	-- image
	if active_s2 then
		PressAndReleaseKey("s")	-- frost nova
	end
	-- always channelling, no action here
end

EnablePrimaryMouseButtonEvents(true)

function OnEvent(event, arg, family)
	--OutputLogMessage("\n"..event.." "..arg)

	if event == "MOUSE_BUTTON_PRESSED" and arg == keys.swi then
		swi_is_on = not swi_is_on
		AbortMacro()
		if swi_is_on then
			PlayMacro(swi_macro)
		end
	end

	if event == "MOUSE_BUTTON_PRESSED" and arg == keys.act then
		set_act_flow_time() -- cold 0, or elec 0
		act_is_on = false
		mode = 1
		if IsModifierPressed("lalt") then
			mode = 2
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

	while true do
		if IsModifierPressed("lshift") and swi_is_on then
			set_rmb_down()
			if act_flow then
				for i, act in pairs(act_flow) do
					if time_check(act.timing) then
						act.func()
					end
				end
			else
				set_act_flow_time() -- cold 0, or elec 0
				act_is_on = true
			end
		else
			act_is_on = false
			set_rmb_up()
			break
		end
	end

end
