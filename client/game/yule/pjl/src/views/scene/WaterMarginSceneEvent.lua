--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local prefixFlag = "WaterMarginScene_Event_"

local WaterMarginScene_Events =
{
    MSG_WATER_INIT_GAME   = prefixFlag .. "MSG_WATER_INIT_GAME",  --初始化watermargin 水浒传信息
    MSG_UPDATE_USER_SCORE = prefixFlag .. "MSG_UPDATE_USER_SCORE",  --更新分数
    MSG_WATER_MARGIN_UPDATE_BET_INFO = prefixFlag .. "MSG_WATER_MARGIN_UPDATE_BET_INFO",  --分数控制
    MSG_UPDATE_WATER_SCENE1_RESULT = prefixFlag .. "MSG_UPDATE_WATER_SCENE1_RESULT",  --1模式结果
    MSG_UPDATE_WATER_SCENE2_RESULT = prefixFlag .. "MSG_UPDATE_WATER_SCENE2_RESULT",  --2
    MSG_RETURN_GAME_SCENE1 = prefixFlag .. "MSG_RETURN_GAME_SCENE1",  --2
    MSG_UPDATE_ROLL_MSG = prefixFlag .. "MSG_UPDATE_ROLL_MSG",  --2
    MSG_UPDATE_WATER_GAME_END = prefixFlag .. "MSG_UPDATE_WATER_GAME_END",  --2
    MSG_UPDATE_USER_SCORE_OTHER_VIEW = prefixFlag .. "MSG_UPDATE_USER_SCORE_OTHER_VIEW",  --2
    MSG_NETWORK_FAILURE = prefixFlag .. "MSG_NETWORK_FAILURE",  --2
    MSG_LITTLE_MARY_RESULT = prefixFlag .. "MSG_LITTLE_MARY_RESULT",  --2
    MSG_START_GAME_LITTLE_MARY = prefixFlag .. "MSG_START_GAME_LITTLE_MARY",  --2
    MSG_PAUSE_SCENE1_MUSIC = prefixFlag .. "MSG_PAUSE_SCENE1_MUSIC",  --2  
    MSG_RESUME_SCENE1_MUSIC = prefixFlag .. "MSG_RESUME_SCENE1_MUSIC",  --2  
    MSG_INSTANT_FINISH_SCENE1 = prefixFlag .. "MSG_INSTANT_FINISH_SCENE1",  --2      
    MSG_STOP_WATER_SCENE1_AUTO = prefixFlag .. "MSG_STOP_WATER_SCENE1_AUTO",  --2
    MSG_ENTER_LITTLEMARY_WAIT = prefixFlag .. "MSG_ENTER_LITTLEMARY_WAIT",
    MSG_ENTER_LITTLEMARY = prefixFlag .. "MSG_ENTER_LITTLEMARY",
    MSG_ENTER_COMPARE = prefixFlag .. "MSG_ENTER_COPARE",      
}

return WaterMarginScene_Events

--endregion
