-- _DH_冰吞雙控分享版 2020-11-23

-- 技能設置：
--    1 戰寵/刀扇
--    2 復仇
--    3 蓄勢待發
--    4 暗影/煙幕

-- G 鼠標設置：
--    Windows 用戶在 LGS 或者 GHUB 裡面，綁定 capslock 按鍵到 G5，mac 用戶不用這樣，因為無效
--    如果要用 G4 速刷，注意確保 G4 沒有綁定別的宏

-- 操作：
--    按啟動開關 G5 開始（macOS 需先手動按亮鎖定鍵），開關可修改
--    啟動後會自動疊動能（可關閉此功能），按住 ctrl 或者 alt 或者鼠標 G4 即開始戰鬥，G4 可以修改
--        ctrl 模式：  一追一掃，移動速度穩定，不開塔，不開門；
--        alt/G4 模式：鼠標指向怪，則一追一掃；指向空地，則快速移動；指向塔/門，則開塔/門；
--        shift 模式： 暫停遊戲，並查看對話記錄，用於檢查精英數量、狀態。按下查看，鬆開回到遊戲。
--    小秘境可以用 alt/G4 模式，動能不足時，指向怪，或臨時切換成 ctrl 模式。
---------------------------------------------------------------------------------
local keys = {
    swi     = 5,            -- 啟動開關，可以修改成其他 G 鍵
    fast    = 4,            -- 用於單手操作，相當於按 alt，可以修改為其他鼠標 G 鍵
    skill_1 = "1",          -- 技能 1~4 按鍵。注意：要與遊戲內按鍵綁定一致
    skill_2 = "2", 
    skill_3 = "3", 
    skill_4 = "4",
    stand   = "a",          -- 強制站立，注意：要與遊戲內按鍵綁定一致。強烈建議不要使用 shift 或任何輔助按鍵
    indicator = "capslock", -- 可修改為其他鎖定鍵，比如 numlock、M 鍵，建議保留本設置
}
local swi_is_on = false        
local sk_4_rpt  = 5000      -- 煙幕: 50, 暗影: 5000，修改成自己的配置
local t0        = -20000
local gain_mom  = false
local g_m_auto  = true      -- 啟動時自動疊動能（一次）開關，改成 false 可關閉
local rmb_down  = false
local stand_on  = false
local rf_pause  = false

local skill = {
    -- 注意：以下技能，如果不需要自動刷新，可以把 auto = true 改為 auto = false
    sk1 = {timer = t0, key = keys.skill_1, auto = true, rp_time = 50,},       -- 戰寵/刀扇
    sk2 = {timer = t0, key = keys.skill_2, auto = true, rp_time = 50,},       -- 復仇     
    sk3 = {timer = t0, key = keys.skill_3, auto = true, rp_time = 50,},       -- 蓄勢待發 
    sk4 = {timer = t0, key = keys.skill_4, auto = true, rp_time = sk_4_rpt,}, -- 暗影/煙幕
}

function mdf_check()
    local mdf_state = 0
    if IsModifierPressed("ctrl")       then mdf_state = mdf_state + 1 end
    if IsModifierPressed("shift")      then mdf_state = mdf_state + 2 end
    if IsModifierPressed("alt")        then mdf_state = mdf_state + 4 end
    if IsMouseButtonPressed(keys.fast) then mdf_state = mdf_state + 8 end
    return mdf_state
end

function refresh(sk)
    local stand_dly = 5
    if (GetRunningTime() - sk.timer >= sk.rp_time) and sk.auto then
        if type(sk.key) == "string" then
            PressAndReleaseKey(sk.key)
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
    if gain_mom and g_m_auto then
        refresh(skill.sk2)
        refresh(skill.sk4)
        PressKey(keys.stand)
        Sleep(20)
        PressMouseButton(1)
        Sleep(2000)
        ReleaseMouseButton(1)
        ReleaseKey(keys.stand)
        gain_mom = nil        
    end
end

function hunger_n_strafe(mdf)
    local mb1_dl = 18            -- 16, 17, 18, 484, 485, 18 may be the best
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
        refresh(skill.sk1)
        refresh(skill.sk2)
        refresh(skill.sk3)
        refresh(skill.sk4)
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

    local func = {
        [0] = function()
            g_resume()
            set_stand_off()
            set_rmb_up()
        end,
        [1] = function()
            set_stand_on()
            play_HnS()
        end,
        [2] = g_pause,
        [4] = function()
            set_stand_off()
            play_HnS()
        end,
        [8] = function() 
            set_stand_off()
            play_HnS()
        end,
    }
    if func[mdf] then func[mdf]() end
end

-- 添加其他模塊：

-- 添加結束

function OnEvent(event, arg, family)
    --OutputLogMessage("\n"..event.." "..arg)
    -- 調用其他模塊

    -- 調用結束
    
    -- 以下請勿修改
    if event == "MOUSE_BUTTON_PRESSED" and arg == keys.swi and family == "mouse" then
        Sleep(100)
        if IsKeyLockOn(keys.indicator) then
            swi_is_on = true
            gain_mom  = true
            gain_momentum()
        else
            swi_is_on = false
            gain_mom  = nil
        end
    end
    stand_on = false
    rmb_down = false
    while swi_is_on do
        if IsKeyLockOn(keys.indicator) then
            hunger_n_strafe(mdf_check())
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