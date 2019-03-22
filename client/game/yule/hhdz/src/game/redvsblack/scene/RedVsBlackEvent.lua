--region *.lua
--Date

--此文件由[BabeLua]插件自动生成

local prefixFlag = "RedVsBlack_Event_"

local RedVsBlack_Events =
{
    MSG_REDVSBLACK_UPDATE_BANKER_INFO      = prefixFlag .. "1", --更新庄家数据
    MSG_REDVSBLACK_SCENE_UPDATE            = prefixFlag .. "2", --更新庄家数据
    MSG_REDVSBLACK_UDT_GAME_STATUE         = prefixFlag .. "3", --更新游戏状态
    MSG_REDVSBLACK_GAME_END                = prefixFlag .. "4", --开始比牌
    MSG_REDVSBLACK_UPDATE_TABLE_INFO       = prefixFlag .. "5", --更新桌子信息
    MSG_GAME_SHIP                          = prefixFlag .. "6", --投注成功
    MSG_GAME_CONTINUE_SUCCESS              = prefixFlag .. "7", --续投成功
    MSG_REDVSBLACK_REQUEST_BANKER_INFO     = prefixFlag .. "8", --上庄申请、取消
    MSG_UPDATE_ROLL_MSG                    = prefixFlag .. "9", --系统消息
    MSG_UPDATE_BANKER_REQUESTLIST          = prefixFlag .. "10",--请求上庄的列表
    MSG_REDVSBLACK_UPDATE_HISTORY_INFO     = prefixFlag .. "13",--更新历史数据
}   

return RedVsBlack_Events

--endregion
