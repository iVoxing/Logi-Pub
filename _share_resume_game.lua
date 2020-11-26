-- share_resume_game.lua
-- 暗黑 3 撕票助手（共享版）
-- 2020-11-11，iVoxing 發佈在凱恩社區

-- 功能：
--  在城鎮或遊戲/野外，一鍵退出，並自動重新進入。

-- 使用方法：
--  建議用 G 鍵盤的 G 鍵啟動
--  這是針對 Windows 系統的版本，mac 版本暫不提供

-- 操作：
--    1 在城鎮裡面，按 G 鍵啟動，角色小退，並自動重新進入遊戲；
--    2 在遊戲中，或者野外，按 G 鍵啟動，3 秒左右按任意輔助鍵，倒計時結束後，角色小退，重新進入遊戲；
--    3 進大秘境立刻撕票，建議先出門，再按照 1 操作；
--    建議盡量採用 1 的方式。

local keys = {
    clear = "x",            -- 重要：關閉所有打開的窗口，改成自己的設置，並且一定要有這個按鍵設置
}
local w_h_ratio = 16 / 9    -- 重要：改成自己的屏幕比例，比如：3440 / 1440，注意要有這個斜杠（除號）

local x, y = 1, 2
function resume_game()
    -- 注意：這裡忽略了黑邊模式，如果需要用黑邊模式，請自己點測坐標，或者用我的計算表計算，並修改下表
    -- 確實需要卻搞不定也可以聯繫我
    local this_screen = {
        leave_game = {7923 * 16 / 9 / w_h_ratio, 29275},  -- 離開遊戲
        start_game = {8192 * 16 / 9 / w_h_ratio, 31457},  -- 開始遊戲
        mid        = {32768, 32768},                      -- 屏幕中點
    }
    function mdf_check()   -- 輔助鍵狀態檢測
        local mdf_state = 0
        if IsModifierPressed("ctrl")  then mdf_state = mdf_state + 1 end
        if IsModifierPressed("shift") then mdf_state = mdf_state + 2 end
        if IsModifierPressed("alt")   then mdf_state = mdf_state + 4 end
        return mdf_state
    end
    AbortMacro()
    Sleep(100)
    PressAndReleaseKey("escape")   -- 這次 ESC 是保證退出儲物箱子的搜索框
    Sleep(10)
    PressAndReleaseKey(keys.clear) -- 這次清屏是保證退出儲物箱子
    Sleep(10)
    PressAndReleaseKey("escape")   -- 這次 ESC 才是退出遊戲界面
    Sleep(100)
    MoveMouseToVirtual(this_screen.leave_game[x], this_screen.leave_game[y])
    Sleep(10)
    PressAndReleaseMouseButton(1)
    Sleep(3000)             -- 注意：這裡可能需要根據自己的電腦調整數字
    local n = 7             -- 城鎮, 注意：如果進遊戲後，人物向左邊移動，請把 n 值改小
    if mdf_check() > 0 then -- 野外，按住任意輔助鍵一小會兒
        n = n + 10
    end
    Sleep(2000)             -- 注意：這裡可能需要根據自己的電腦調整數字
    for i = 1, n do    
        MoveMouseToVirtual(this_screen.start_game[x], this_screen.start_game[y])
        Sleep(10)
        PressAndReleaseMouseButton(1)
        Sleep(500)
    end
    MoveMouseToVirtual(this_screen.mid[x], this_screen.mid[y])
end

-- 重要：以下僅僅是按鍵綁定的示例，不能照抄
function OnEvent(event, arg, family)
    -- 綁定 G 鍵盤 G6 按鍵
    -- 根據自己的設備和設置調整
    if event == "G_PRESSED" and arg == 6 then
        resume_game()
    end
    -- 綁定 G 鼠標 G7 按鍵（比如 G903 的右側前按鍵）
    -- 根據自己的設備和設置調整
    if event == "MOUSE_BUTTON_PRESSED" and arg == 7 then
        resume_game()
    end
end