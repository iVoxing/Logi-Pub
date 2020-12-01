function OnEvent(event, arg, family)
	--OutputLogMessage("Event: "..event.." Arg: "..arg.."\n")
	if event == "MOUSE_BUTTON_PRESSED" and arg == 4 then
		ClearLog()
		--local t0, tt, ts, ta,
		local inside = true
		local tx = "Delay Offset"
		if IsModifierPressed("lctrl") then
			inside = false
			tx = "Virtual Delay"
		end
		local dl, run = 50, 20
		tx = dl.."ms "..tx..": \n=================\n"
		local ts = 0
		OutputLogMessage(tx)
		for i = 1, run do
			local t0 = GetRunningTime()
			Sleep(dl)
			local tt = GetRunningTime() - t0
			if inside then
				tt = tt - dl
			end
			ts = ts + tt
			OutputLogMessage(i..":\t"..tt.."\n")
		end
		local ta = ts / run
		OutputLogMessage("=================\nAverage:\t"..ta.."\n")
	end
end