--region Lhdz_Events.lua
--Date
--Auther Ace
--Desc [[龙虎斗游戏内事件定义]]
--此文件由[BabeLua]插件自动生成

local prefixFlag = "Lhdz_Events_"
local Lhdz_Events = 
{
    MSG_LHDZ_GAME_SCENE_INIT            = prefixFlag .. "MSG_LHDZ_GAME_SCENE_INIT",         -- 初始化场景
    MSG_LHDZ_GAME_STATUS                = prefixFlag .. "MSG_LHDZ_GAME_STATUS",             -- 游戏状态
    MSG_LHDZ_GAME_RESULT                = prefixFlag .. "MSG_LHDZ_GAME_RESULT",             -- 游戏结算
    MSG_LHDZ_GAME_CHIP                  = prefixFlag .. "MSG_LHDZ_GAME_CHIP",               -- 玩家下注
    MSG_LHDZ_GAME_CANCEL                = prefixFlag .. "MSG_LHDZ_GAME_CANCEL",             -- 清除下注
    MSG_LHDZ_GAME_CONTINUE              = prefixFlag .. "MSG_LHDZ_GAME_CONTINUE",           -- 玩家续投
    MSG_LHDZ_GAME_UPDATE_BANKERLIST     = prefixFlag .. "MSG_LHDZ_GAME_UPDATE_BANKERLIST",  -- 更新庄家列表
    MSG_LHDZ_GAME_UPDATE_BANKER         = prefixFlag .. "MSG_LHDZ_GAME_UPDATE_BANKER",      -- 更新庄家信息
    MSG_LHDZ_GAME_BANKERSCORE           = prefixFlag .. "MSG_LHDZ_GAME_BANKERSCORE",        -- 更新庄家分数
    MSG_LHDZ_GAME_COUNT_TIME            = prefixFlag .. "MSG_LHDZ_GAME_COUNT_DOWN",         -- 倒计时
    MSG_LHDZ_GAME_TABLE_USER            = prefixFlag .. "MSG_LHDZ_GAME_TABLE_USER",         -- 更新上桌玩家
    MSG_LHDZ_GAME_RANK                  = prefixFlag .. "MSG_LHDZ_GAME_RANK",               -- 更新排行榜
}

return Lhdz_Events
--endregion
