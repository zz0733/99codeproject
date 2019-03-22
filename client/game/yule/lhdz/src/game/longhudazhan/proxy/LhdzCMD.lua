--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local LhdzCMD = {

    --游戏命令
    MDM_GF_GAME					    = 200,			--游戏命令
        --服务器命令结构
        SUB_S_GameInfo_LHDZ			    =   100,                    --游戏信息
        SUB_S_SysMessage_LHDZ           =   101,                    --系统消息
        SUB_S_UserChipNotify			=   102,			        --下注通知
        SUB_S_GameResultInfo			=   103,			        --游戏结算信息
        SUB_S_RequestBanker			    =   104,			        --申请庄家(单人申请庄家时发送)
        SUB_S_UpdateBanker			    =   105,			        --更新庄家信息(每回合结束都会更新)
        SUB_S_ContiueChip			    =   106,			        --玩家续投结果
        SUB_S_CancelChip			    =   107,			        --取消投注
        SUB_S_TableUser			        =   108,			        --上桌玩家
        SUB_S_Rank			            =   109,			        --排名
        SUB_S_Updata_Banker_Score       =   110,			        --更新庄家分数

        --客户端命令结构
        SUB_C_UserChip		            =   200,					    --玩家下注
        SUB_C_RequestBanker	            =   201,					    --申请坐庄或下庄
        SUB_C_ContinueChip	            =   202,					    --玩家续投
        SUB_C_CancelChip	            =   203,					    --取消投注
        SUB_C_RequestRank	            =   204,					    --请求排行
        SUB_C_Card_Config	            =   205,					    --配牌操作
}

return LhdzCMD
--endregion
