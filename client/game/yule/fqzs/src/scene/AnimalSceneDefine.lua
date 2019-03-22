
-- 飞禽走兽 201--------------------------------------------------------------
local text = {
    ["FLY_0"]  = "燕子",
    ["FLY_1"]  = "孔雀",
    ["FLY_2"]  = "鸽子",
    ["FLY_3"]  = "老鹰",
    ["FLY_4"]  = "兔子",
    ["FLY_5"]  = "熊猫",
    ["FLY_6"]  = "猴子",
    ["FLY_7"]  = "狮子",
    ["FLY_8"]  = "鲨鱼",
    ["FLY_9"]  = "金鲨鱼",
    ["FLY_10"] = "通吃",
    ["FLY_11"] = "通赔",
    ["FLY_12"] = "申请人数：%d",
    ["FLY_13"] = "前面人数：%d",
    ["FLY_14"] = "庄家不能下注",
    ["FLY_15"] = "请下庄后才能退出房间。",
}
for k, v in pairs(text) do
    cc.exports.Localization_cn[k] = text[k]
end

local cmd = {
    -- 飞禽走兽 201-----------------------------------------------------------------
    CMD_ChipStart_S_P				=101,				        --下注开始
    CMD_ChipStop_S_P				=102,				        --下注结束
    CMD_GameStart_S_P				=103,				        --游戏开始
    CMD_GameEnd_S_P					=104,				        --游戏结束
    CMD_UpdataChip_S_P				=105,				        --更新下注
    CMD_ChipSucc_S_P				=106,				        --下注成功
    CMD_SysMessage_S_P				=107,				        --系统消息
    CMD_GameInfo_S_P				=109,				        --游戏信息
    CMD_GameResultInfo_S_P			=110,				        --游戏结算信息
    CMD_ContinueChip_S_P			=111,				        --续投
    CMD_GameOpenLog_C_P			    =112,			            --游戏开奖纪录
    CMD_ClearChip_S_P				=113,				        --清空投注回应
    CMD_BankerScoreNeed_S_P         =122,                       --玩家上庄最低金币要求 

    CMD_UserChip_C_P				=151,				        --玩家下注
    CMD_ContinueChip_C_P			=152,			            --玩家续投回应
    CMD_ClearChip_C_P				=153,			            --清空投注

    BANKER_REQ_RESULT_SC		    =8001,				        --申请结果
    BANKER_SITUSERINFO_SC		    =8002,				        --坐庄信息
    BANKER_REQUPBANKER_CS		    =8051,				        --申请上庄
    -- 飞禽走兽 201-----------------------------------------------------------------
}
--for k, v in pairs(cmd) do
--    cc.exports.G_C_CMD[k] = cmd[k]
--end

--加载界面的提示语
local text = {
    "赢家永远都是敢下注的人。",
    "玩是高尚娱乐，搏是低级趣味。",
    "不到最后的那一刻，所有的胜利都是假的。",
    "爱拼才会红，敢搏才能赢，要想富，下重注。",
}
cc.exports.Localization_cn["Loading_201"] = text

-- 飞禽走兽 201-----------------------------------------------------------------