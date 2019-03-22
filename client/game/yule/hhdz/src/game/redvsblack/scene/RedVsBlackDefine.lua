

--红黑大战--
local text = {
    ["RVB_WARN_1"] = "请稍后，还没有到下注时间！",
    ["RVB_WARN_2"] = "庄家不能下注",
    ["RVB_WARN_3"] = "庄家金币不够赔付，下注失败！",
    ["RVB_WARN_4"] = "请下庄后才能退出房间。",
    ["RVB_WARN_5"] = "筹码不足，是否立即跳转充值？",
    ["RVB_TEXT_1"] = "申请人数:",
    ["RVB_TEXT_2"] = "前面人数:",
}
for k, v in pairs(text) do
    cc.exports.Localization_cn[k] = text[k]
end

--local cmd = {
--    ----- 红黑大战 213--------------------------------------
--    --服务器命令结构
--    SUB_S_GameInfo					    = 301,                --游戏信息
--    SUB_S_SysMessage				    = 302,                --系统消息
--    SUB_S_SendTableUser				    = 303,                --上桌玩家信息
--    SUB_S_ChipSucc					    = 304,                --下注成功
--    SUB_S_GameResultInfo			    = 305,                --游戏结算信息
--    SUB_S_RequestBankerList			    = 306,                --申请庄家列表
--    SUB_S_RequestBanker                 = 307,                --申请庄家(单人申请庄家时发送)
--    SUB_S_UpdateBanker                  = 308,                --更新庄家信息(每回合结束都会更新)
--    SUB_S_ContiueChip				    = 310,                --玩家续投结果
--    SUB_S_UpdateChip				    = 311,                --上一秒的投注总和
--    SUB_S_CancelChip				    = 312,                --取消投注
--    SUB_S_GOLD_OVER                     = 313,                --库存被赢光
--    SUB_S_CurrentBanker                 = 314,                --当前庄家信息

--    --客户端命令结构
--    SUB_C_UserChip					    = 351,				  --玩家下注
--    SUB_C_RequestBanker                 = 352,				  --申请庄家
--    SUB_C_ContinueChip                  = 353,				  --玩家续投
--    SUB_C_CancelChip				    = 354,				  --取消投注
--    ----- 红黑大战 213--------------------------------------
--}

--for k, v in pairs(cmd) do
--    cc.exports.G_C_CMD[k] = cmd[k]
--end

--加载界面的提示语
local text = {
    "赢家永远都是敢下注的人。",
    "要想富，下重注。",
    "马无夜草不肥，人无横财不富，下重注，夺横财！",
    "赌的就是豹子，要的就是热血与激情！",
}
cc.exports.Localization_cn["Loading_213"] = text