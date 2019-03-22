--region Tiger_Events.lua
--Date 2017-11.10
--Author JackyXu.
--Desc 水果老虎机游戏内事件定义

local Tiger_Events = 
{
    MSG_TIGER_GAME_START         = "tiger_evt_game_start",        --开始
    MSG_TIGER_GAME_UPDATE   	 = "tiger_evt_game_update",  	  --更新数据
    MSG_TIGER_GAME_RESULT        = "tiger_evt_game_result",       --游戏结果
    MSG_TIGER_GAME_END           = "tiger_evt_game_end",          --游戏结束
    MSG_TIGER_GAME_FREE_TIMES    = "tiger_evt_game_freeTime",  	  --免费次数
    MSG_TIGER_GAME_EXTRA_TIMES 	 = "tiger_evt_game_ExtraTime",    --额外倍数
    MSG_TIGER_GAME_WIN_SCORE     = "tiger_evt_game_winScore",  	  --赢取彩金
    MSG_TIGER_GAME_LIB_SCORE     = "tiger_evt_game_libScore",     --彩金库
    MSG_TIGER_GAME_ERROR         = "tiger_evt_game_errorMsg",     --错误消息
    MSG_TIGER_GAME_SHOW_PLAYER   = "tiger_evt_game_showPlayer",   --展示其他玩家
    MSG_TIGER_GAME_UPDATE_OTHER  = "tiger_evt_game_updateOther",  --其他玩家金币更新
}

return Tiger_Events

--endregion
