--region *.lua
--Date 2016-9-1
--Author xufei
--此文件由[BabeLua]插件自动生成

local prefixFlag = "AnimalScene_Event_"

local AnimalScene_Events =
{
    Main_Entry          = prefixFlag .. "mainEntry",    --进入游戏场景

    Animal_Socket_Disconnect  = prefixFlag .. "SocketDisconnect", --游戏掉线
    Animal_Socket_ReconSuc    = prefixFlag .. "SocketReconSuc",   --重连成功
    Animal_Socket_NoNetWork   = prefixFlag .. "SocketNoNetWork",  --重连失败

    EVENT_CMD_ChipStart_S_P         = prefixFlag .. "onMsgChange_EVENT_CMD_ChipStart_S_P",  --开始下注
    EVENT_CMD_ChipStop_S_P          = prefixFlag .. "onMsgChange_EVENT_CMD_ChipStop_S_P",  --结束下注
    EVENT_CMD_GameStart_S_P         = prefixFlag .. "onMsgChange_EVENT_CMD_GameStart_S_P",  --游戏开始
    EVENT_SUB_GF_GAME_SCENE         = prefixFlag .. "onMsgGameInit",  ---初始化场景筹码信息
    EVENT_CMD_GameInfo_S_P          = prefixFlag .. "onGameInfoUpdate",  --更新游戏信息
    EVENT_CMD_UpdataChip_S_P        = prefixFlag .. "onMsgGameAllServer",  --监听105刷新
    EVENT_CMD_ChipSucc_S_P          = prefixFlag .. "onMsgGameShip",  -- 下注成功
    EVENT_CMD_ContinueChip_S_P      = prefixFlag .. "onMsgContinueSuccess",  --续投
    EVENT_CMD_ClearChip_S_P         = prefixFlag .. "onMsgGameShipClean",  --清空
    EVENT_BANKER_SITUSERINFO_SC     = prefixFlag .. "onMsgUpdateZhuangInfo",  --更新庄家信息
    EVENT_CMD_GameResultInfo_S_P    = prefixFlag .. "onMsgGetAwards",  --//更新玩家金币,不在这里更新,改为结算单弹窗后
    EVENT_CMD_SysMessage_S_P        = prefixFlag .. "addRollMessageInfo",   -- 系统消息
    EVENT_CMD_BankerScoreNeed_S_P   = prefixFlag .. "updateBankerScoreNeedInfo",  -- 上庄需求
    EVENT_CMD_GameOpenLog_C_P       = prefixFlag .. "updateHistoryByFirst",  -- 更新历史，只用来更新第一次历史
    EVENT_SUB_GR_USER_SCORE         = prefixFlag .. "onMsgUpdateUsrScore", -- 更新银行等金币事件
    MSG_ANIMAL_COUNT_DOWN           = prefixFlag .. "MSG_ANIMAL_COUNT_DOWN", --
}

return AnimalScene_Events

--endregion
