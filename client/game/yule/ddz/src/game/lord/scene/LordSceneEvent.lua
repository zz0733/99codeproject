--region *.lua
--Date 2017-4-4
--Author zhangenzhi
--此文件由[BabeLua]插件自动生成

local LordScene_Events =
{
    Main_Entry                  = "LordScene_Event_mainEntry",        --进入游戏场景
    Exit_Layer                  = "LordScene_Event_exitEnter",        --离开游戏场景

    Main_Layer                  = "LordScene_Event_mainLayer",        --进入主界面
    Lord_Socket_Disconnect      = "LordScene_Event_SocketDisconnect", --游戏掉线
    Lord_Socket_ReconSuc        = "LordScene_Event_SocketReconSuc",   --重连成功
    Lord_Socket_NoNetWork       = "LordScene_Event_SocketNoNetWork",  --重连失败

    MSG_GAME_EXIT               = "LordScene_Event_gameExit",         --退出游戏
    MSG_USER_WAIT               = "LordScene_Event_userWait",         --准备游戏
    MSG_USER_FREE               = "LordScene_Event_userFree",         --用户站立
    MSG_UDPATE_USR_SCORE        = "LordScene_Event_updateUserScore",  --用户信息变动
    MSG_LANDLORD_INIT           = "LordScene_Event_lordInit",         --游戏初始化
    MSG_LANDLORD_START          = "LordScene_Event_lordStart",        --游戏开始
    MSG_LANDLORD_CALL           = "LordScene_Event_lordCall",         --游戏叫分
    MSG_LANDLORD_BANKER         = "LordScene_Event_lordBanker",       --确定地主
    MSG_LANDLORD_ADDTIME_NOTIFY = "LordScene_Event_addTimeNotify",    --加倍通知
    MSG_LANDLORD_OUTCARD        = "LordScene_Event_lordOutCard",      --玩家出牌
    MSG_LANDLORD_PASS           = "LordScene_Event_lordPass",         --玩家过牌
    MSG_LANDLORD_CONCLUDE       = "LordScene_Event_lordConclude",     --一局结束
    MSG_USER_OFFLINE            = "LordScene_Event_userOffline",      --用户掉线
    MSG_USER_COMEBACK           = "LordScene_Event_userComeBack",     --用户回来
    MSG_USER_ROBOT              = "LordScene_Event_userRobot",        --用户脱管
    MSG_BANK_INFO               = "LordScene_Event_bankInfo",         --银行信息
}

return LordScene_Events

--endregion
