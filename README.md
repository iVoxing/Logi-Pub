# Logi-Pub

## 目錄

+ 概述
+ 文件描述
+ 模塊簡介

## 概述

這裡的東西，沒基礎的朋友估計看不明白；懂行的，也許略有點參考作用。
內容也十分的蕪雜。有的模塊，我自己都沒有再用了，比如用於雙開的那些。

需要強調的一點是，我的主力電腦是 mac，所以模塊裡面有一些是針對 mac 的，尤其是 alfred 相關模塊。
講真，alfred 很香。Windows 上目前找不到替代。
但是對於暗黑3，alfred 的幫助也比較有限。有一些功能主要是炫技，而比如在遊戲內臨時改一下參數什麼的，還算比較實用。

D3 一些日常的操作，需要宏化、腳本化的，這裡面都有了。
一鍵傳送，到 A1、A2、隊友；
一鍵丟光，自己丟、小號丟，各種花式丟法；
魔盒轉換，橫向、豎向；
拆裝備，一個個拆、一包全拆；
點巔峰，按預設、快速點主屬性、開荒 800 點巔峰之前按預設——這個真心好用；
快速撕票……
如此等等

我的這些模塊，有兩個比較顯著的特點。

一是兼容不同的屏幕和系統。畢竟我有兩台電腦、三個屏幕在用。
這一點之前發了個貼子專門論述過。

二是經常用到輔助鍵，並且有一個比較清爽的方式。
苦於 G 鍵不夠用的玩家，我的思路也許會給你一些啟發。

## 文件描述

### _sample_script.lua
這個文件的內容，需複製到 LGHUB 的腳本編輯器裡面。注意修改路徑，以指向其他 lua 文件集中保存的位置。
從道理上講，我們可以把完整的腳本內容統統放到腳本編輯器裡面，但顯然那樣既不方便修改維護，也不利於模塊共用，因此並不推薦。
腳本加載成功，則會自動調用下面兩個文件。

### _sample_g_vars.lua
這個文件用於存放一些需要快速修改的變量，主要是用於配合 macOS 裡面的 alfred workflow 在不離開遊戲的情況下修改腳本變量。
大部分玩家基本上用不到這個功能，因此可以無視。
但把一些通用、常用的變量集中在一起修改，這個思路，還是可供借鑒的。

### _sample_profile.lua
這個通過腳本編輯器內的代碼自動調用的文件，是一個配裝示例。這裡的配裝即「冰吞」、「骨矛」這樣的具體打法。
這個文件的關鍵部分是需要玩家自己定義的，比如按鍵設置等。
這個文件則又會加載 _sample_g_general.lua 這個通用模塊。
73~88 行，則展示了如何把功能模塊分配到各個 G 鍵。

### _sample_g_low_pa.lua
這個文件是定義「低巔峰分配方案」用的。而「低巔峰分配方案」是指我們在開荒時，按照這個方案設定，一鍵分配巔峰點數。
示例文件的方案是，第一頁，點滿跑速，然後剩下的全點體能；第二頁，冷卻、爆率、爆傷、攻速……如此等等。
這個文件只定義方案，具體的執行模塊，則在 _sample_g_general.lua 裡面。

### _sample_g_general.lua
這個就是本帖分享的重點，通用模塊。玩家需要做的事是——
1. 檢視屏幕表是否與自己的屏幕匹配，如果不匹配，可以用 _share_D3_Screen.xlsx 這個電子表格計算出自己的屏幕表，並添加。
當然，不需要的也可以刪除。
2. 閱讀理解各個功能模塊，並按照 _sample_profile.lua 示例的方法，分配到鼠標 G 鍵；以及，按 859 行 gk_map 表示例的方法，分配給鍵盤 G 鍵。鼠標和鍵盤各是一套分配，可以重複分配，比如示例裡面，魔盒轉換的 cube_mdf 就同時分配給了鼠標 G8 和 鍵盤 G4，這樣用鼠標或鍵盤就都可以操作。

## _sample_g_general.lua 模塊介紹

按代碼順序

### _keys
按鍵定義表，這是基礎設置，必須跟自己的設置一致。道理很簡單，不多講。

### screen_test
這個是屏幕檢測模塊，但對 Windows 屏幕僅能判斷是否是 Windows。可以改進，但目前我沒有做這個工作。
這個模塊是一切屏幕坐標相關操作的基礎。
表的製作，另有帖子詳述，這裡不重複了。

### app_switch
程序切換——主要用途是雙開時，切換大小號。雙開相關的丟光、傳送等操作，都要用到這個模塊。

### macro_pause
宏暫停——腳本調用外部宏的情況下才會用到，為了保持兼容性，很多地方都會用到。

### macro_stop
宏停止——腳本調用外部宏的情況下才會用到，為了保持兼容性，很多地方都會用到。

### macro_resume
宏恢復——腳本調用外部宏的情況下才會用到。

### play_sound
通過 Alfred workflow 發出一個系統聲音——僅 macOS + alfred 有用。

### dismiss_follower
解散隨從——某些配裝在殺王階段可能需要解散隨從，那麼可以用這個。

### resume_game
撕票——另有一個帖子介紹，這裡不重複了。

### drop
丟光——主要是給雙開用的，有三種方式：
1. 丟光並切換；
2. 丟光、小退（小號不點寶石）並切換；
3. 丟光，不退不切換。
丟光及其他所有背包操作，我都設置了起止點，可以自行規定起止點。這樣可以避免扔下或拆掉某些位置的物品。

### salvage_all
一鍵全拆。可設起止點，如上述。

### paragon_allot
巔峰分配——三種模式：
1. 快速模式，即直接點滿主屬性；
2. 低巔峰模式，按低巔峰分配方案，一鍵點滿；
3. 按預設分配。
注意，單純的腳本並不知道玩家的巔峰點數，因此 2、3 模式需要設定變量 _paragon_level，這個變量放在 _sample_g_vars.lua。

### grid_mdf
丟光和拆物品，我歸納為背包操作，因此用這個模塊組織在同一個 G 鍵上。
按示例的設定，這個 G 鍵的行為表現為——
單按，拆掉單件物品；
+ +ctrl +shift，丟掉全部物品（有起止點）；
+ +alt，拆掉全部物品；
+ +ctrl +shift +alt，如果是 macOS + alfred，則顯示一個關於這個 G 鍵的組合鍵對應功能的說明，相當於 help。

### tp_mdf
與 grid_mdf 類似，傳送功能組織到一個 G 鍵。
單按，傳送到城鎮，相當於 T；
+ +ctrl，傳送到新崔斯特姆（A1）；
+ +shif，傳送到秘密營地（A2）；
+ +alt，傳送到隊友1；
+ +ctrl +alt，安全傳送，即換上回城肩，回城，再換回原來的肩膀——這個功能幾乎沒啥意義了。
+ +ctrl +shift +alt，如果是 macOS + alfred，則顯示一個關於這個 G 鍵的組合鍵對應功能的說明，相當於 help。

### mdf_check
一個核心模塊，用於檢查輔助鍵按下的狀況。

### mdf_wait
有時候需要鬆開輔助鍵之後才方便運行接下來的代碼，這個模塊就是等待玩家鬆開輔助鍵。

### cube_mdf
魔盒操作，+ctrl 豎向跑單格，+shift 橫向跑雙格。鬆開即停。
每次都從第一個開始，我想過要不要從鼠標位置起跑，後來覺得沒必要。

### say
發消息——現在大家都用語音了，不再有用。

### say_mdf
通過輔助鍵組合，快速發送不同的預設消息。沒啥用了。

### gk_press
定義鍵盤 G 鍵行為的模塊，玩家可以不用管。這個模塊做了一個「長按」功能，相當於又給玩家增加了幾顆 G 鍵。但我自己 G 鍵夠多的了，也就沒怎麼用這個長按。
長按啥意思呢，比如傳送，我按 G5 就相當於按 T，但如果按 G5 超過預設時間比如半秒，就運行安全傳送模塊了。
G 鍵不夠用，又不喜歡輔助鍵的玩家，可以參考這個思路。

### gk_map
分配鍵盤 G 鍵的表，如果有 G 鍵盤，在這裡設置。
