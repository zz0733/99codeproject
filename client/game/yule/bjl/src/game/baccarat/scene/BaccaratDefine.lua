
--百家乐
cc.exports.AREA_XIAN         = 0 --闲家索引
cc.exports.AREA_PING         = 1 --平家索引
cc.exports.AREA_ZHUANG       = 2 --庄家索引
cc.exports.AREA_XIAN_TIAN    = 3 --闲天王
cc.exports.AREA_ZHUANG_TIAN  = 4 --庄天王
cc.exports.AREA_TONG_DUI     = 5 --同点平
cc.exports.AREA_XIAN_DUI     = 6 --闲对子
cc.exports.AREA_ZHUANG_DUI   = 7 --庄对子
cc.exports.AREA_MAX          = 8 --最大区域

-- 百家乐 --
local text = {
    ["BACCARAT_0"] = "庄：%d",
    ["BACCARAT_1"] = "闲：%d",
    ["BACCARAT_2"] = "平：%d",
    ["BACCARAT_3"] = "庄对：%d",
    ["BACCARAT_4"] = "闲对：%d",
    ["BACCARAT_5"] = "下庄成功",
    ["BACCARAT_6"] = "（%d点）",
    ["BACCARAT_7"] = "庄家金币不够赔付，下注失败！",
    ["BACCARAT_8"] = "游戏未结束，是否选择退出游戏？此时退出将按当前下注进行",
    ["BACCARAT_9"] = "庄家不能下注",
    ["BACCARAT_10"] = "请下庄后才能退出房间。",
    ["BACCARAT_11"]  = "请稍后，还没有到下注时间！",
    ["BACCARAT_12"]  = "申请上庄成功，加入申请队列！",
}
for k, v in pairs(text) do
    cc.exports.Localization_cn[k] = text[k]
end


local cmd = {
    ------ 百家乐 208-------------------------------------
    SUB_C_PLACE_JETTON			    = 1,	    --用户下注
    SUB_C_APPLY_BANKER			    = 2,	    --申请庄家
    SUB_C_CANCEL_BANKER			    = 3,	    --取消申请
    SUB_C_CONTINUES				    = 5,	    --续投
    SUB_C_CANCEL_DOWN			    = 6,	    --清除投注
    
    SUB_S_SysMessage_BACCARAT       = 302,      --系统消息
    SUB_S_GAME_FREE_BACCARAT        = 99,       --游戏空闲
    SUB_S_GAME_START_BACCARAT		= 100,      --游戏开始
    SUB_S_PLACE_JETTON              = 101,      --用户下注
    SUB_S_GAME_END_BACCARAT         = 102,      --游戏结束
    SUB_S_APPLY_BANKER              = 103,      --申请庄家
    SUB_S_CHANGE_BANKER             = 104,      --切换庄家
    SUB_S_CHANGE_USER_SCORE         = 105,      --更新分数
    SUB_S_SEND_RECORD               = 106,      --游戏记录
    SUB_S_PLACE_JETTON_FAIL         = 107,      --下注失败
    SUB_S_CANCEL_BANKER             = 108,      --取消申请
    SUB_S_CONTINUE_NOTIFY           = 110,      --续投通知
    SUB_S_CANCELDOWN_NOTIFY         = 111,      --清除投注
    SUB_S_CANCEL_BANKER_SUCCESS     = 112,      --取消庄家 
    ------ 百家乐 208-------------------------------------
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
cc.exports.Localization_cn["Loading_208"] = text