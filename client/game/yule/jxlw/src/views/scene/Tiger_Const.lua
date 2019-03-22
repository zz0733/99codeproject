--region Tiger_Const.lua
--Date 2017.11.10
--Author JackyXu
--Desc 水果老虎机常量定义

local TigerConst = {}

TigerConst.MAX_PLAYER_COUNT     = 6

-- 状态定义
TigerConst.GAME_TIGER_FREE      = 0        --等待开始
TigerConst.GAME_TIGER_PLAY      = 100      --游戏状态

--逻辑定义
TigerConst.LINE_CARD_COUNT      = 5        --线上牌子数
TigerConst.CARD_INDEX           = 15       --牌子索引数
TigerConst.LINE_COUNT           = 9        --线数
TigerConst.MAX_MULTIPLE         = 5        --最大底注倍数

-- 游戏线数
TigerConst.MIN_LINE_NUM         = 1
TigerConst.MAX_LINE_NUM         = 9
TigerConst.ICON_ROW             = 3
TigerConst.ICON_COL             = 5
TigerConst.MAX_BET_INDEX        = 5
TigerConst.MAX_LINE_ICON_NUM    = 24

-- 游戏结果
TigerConst.eResultType = {
    Type_Nothing    = 0,
    Type_Litchi     = 1,    --荔枝
    Type_Orange     = 2,    --橘子
    Type_Mango      = 3,    --芒果
    Type_Watermelon = 4,    --西瓜
    Type_Apple      = 5,    --苹果
    Type_Cherry     = 6,    --樱桃
    Type_Grape      = 7,    --葡萄
    Type_Bell       = 8,    --铃铛
    Type_Banana     = 9,    --香蕉
    Type_Pineapple  = 10,   --菠萝
    Type_BAR        = 11,   --百搭
    Type_Diamond    = 12,   --钻石
    Type_Gold       = 13,   --彩金
    Type_777        = 14,   --奖金游戏
}

-- 各条线对应牌子编号
TigerConst.vecCardLineDate =   -- [LINE_COUNT*LINE_CARD_COUNT]
{
    6,7,8,9,10,         -- 1
    1,2,3,4,5,          -- 2
    11,12,13,14,15,     -- 3
    1,7,13,9,5,         -- 4
    11,7,3,9,15,        -- 5
    6,2,3,4,10,         -- 6
    6,12,13,14,10,      -- 7
    1,2,8,14,15,        -- 8
    11,12,8,4,5,        -- 9
}

-- 结算各牌子中奖个数(3,4,5)对应倍数 
TigerConst.vecBeiLv = {
    {50,200,2000},   -- 荔枝
    {20,50,300},    -- 橘子
    {15,25,250},    -- 芒果
    {10,20,200},    -- 西瓜
    {8,20,150},     -- 苹果
    {6,20,100},     -- 樱桃
    {5,40,90},      -- 葡萄
    {8,35,85},      -- 铃铛
    {6,30,80},      -- 香蕉
    {5,15,75}       -- 菠萝
}
TigerConst.vecBarBeiLv = {5,100,900,6000}       -- bar
TigerConst.vec777BeiLv = {1000,3000,5000}
TigerConst.vecBoxPercent = {10,30,50}  --奖池百分比

-- 转盘动画时长
TigerConst.vecSectionTimeFirst  = {0.5, 0.6, 0.7, 0.8, 0.9}
TigerConst.vecSectionTimeSecond = {0.8, 1.0, 1.2, 1.4, 1.6}
TigerConst.vecSectionTimeEnd    = {0.5, 0.5, 0.5, 0.5, 0.5}

-- 按纽缩放动画时长
TigerConst.ZOOM_ACTION_TIME_STEP = 0.05

TigerConst.TAG_777_BOX_NUM_START = 400  -- 777、box 滚动数字动画起始TAG
TigerConst.TAG_777_BOX_START = 500      -- 777、box 动画创建UI的起始TAG

TigerConst.BIG_WIN_MULTIPLE = 100

TigerConst.eGameState = {
    State_Nothing = 0, 
    State_Wait = 1,        
    State_Turn = 2,       --转盘阶段
    State_NormalWin = 3,    --结算阶段  
    State_BigWin = 4,
    State_SpecialWin = 5,     
}

TigerConst.WinLinePos = {
    cc.p(655.87, 412.67), -- 1
    cc.p(661.03, 571.48), -- 2
    cc.p(667, 253.16),    -- 3
    cc.p(664.26, 403.53), -- 4
    cc.p(663.93, 428.76), -- 5
    cc.p(664.00, 493.00), -- 6
    cc.p(665.36, 339.85), -- 7
    cc.p(643.85, 415.85), -- 8
    cc.p(678.85, 412.62), -- 9
}

return TigerConst