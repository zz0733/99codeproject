
--九线拉王--
cc.exports.Localization_cn["TIGER_TOP_PRIZE_0"]  = "<font face='fonts/arial.ttf' size='26' color='#c75fd8'>天降横财！<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>恭喜玩家<font face='fonts/arial.ttf' size='24' color='#08fd70'>%s<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>获得了<font face='fonts/arial.ttf' size='26' color='#f0d676'>%d倍<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>奖励，共赢得<img src='public/image/gui-coin.png' height='35' width='35'></img><font face='fonts/arial.ttf' size='28' color='#f0d676'><i><b>%s</b></i></font>"
cc.exports.Localization_cn["TIGER_TOP_PRIZE_1"]  = "<font face='fonts/arial.ttf' size='26' color='#f00000'>财神降临！<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>恭喜玩家<font face='fonts/arial.ttf' size='24' color='#08fd70'>%s<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>获得了<font face='fonts/arial.ttf' size='26' color='#f0d676'>%d倍<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>超级奖励，共赢得<img src='public/image/gui-coin.png' height='35' width='35'></img><font face='fonts/arial.ttf' size='28' color='#f0d676'><i><b>%s</b></i></font>"
cc.exports.Localization_cn["TIGER_TOP_PRIZE_2"]  = "<font face='fonts/arial.ttf' size='26' color='#0ad600'>好运挡不住！<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>恭喜玩家<font face='fonts/arial.ttf' size='24' color='#08fd70'>%s<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>抽中钻石奖励，获得连续<font face='fonts/arial.ttf' size='26' color='#f0d676'>%d次<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>免费游戏的机会"
cc.exports.Localization_cn["TIGER_TOP_PRIZE_3"]  = "<font face='fonts/arial.ttf' size='26' color='#ff9ebe'>重磅消息！<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>恭喜玩家<font face='fonts/arial.ttf' size='24' color='#08fd70'>%s<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>幸运抽中777超级大奖，获得了<font face='fonts/arial.ttf' size='26' color='#f0d676'>%d倍<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>奖励，共赢得<img src='public/image/gui-coin.png' height='35' width='35'></img><font face='fonts/arial.ttf' size='28' color='#f0d676'><i><b>%s</b></i></font>"
cc.exports.Localization_cn["TIGER_TOP_PRIZE_4"]  = "<font face='fonts/arial.ttf' size='26' color='#00a8ff'>出大事了！<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>恭喜玩家<font face='fonts/arial.ttf' size='24' color='#08fd70'>%s<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>斩获金宝箱超级大奖，获得<img src='public/image/gui-coin.png' height='35' width='35'></img><font face='fonts/arial.ttf' size='28' color='#f0d676'><i><b>%s </b></i></font><font face='fonts/arial.ttf' size='24' color='#d4d4d4'>奖池彩金，一秒变土豪!"

local text = {
    --老虎机--
    ["TIGER_1"]  = "奖池: %lld",
    ["TIGER_2"]  = "累计赢取: %lld",
    ["TIGER_3"]  = "请先选择线数及底注。",
    ["TIGER_4"]  = "您的筹码不足, 开始失败！",
    ["TIGER_5"]  = "下注:%lld",
    ["TIGER_6"]  = "您的筹码不足，下注失败！",
    ["TIGER_7"]  = "数据包错误。",
    ["TIGER_8"]  = "不在游戏状态。",
    ["TIGER_9"]  = "累计赢取: %lld万",
    ["TIGER_10"]  = "%.1f亿",
    ["TIGER_11"]  = "%.1f万",
    ["TIGER_12"]  = "%lld",
}
for k, v in pairs(text) do
    cc.exports.Localization_cn[k] = text[k]
end

local cmd = {
        --服务器命令结构
        TIGER_MDM_GF_GAME               = 200,
        SUB_S_GAME_START                = 200,           --游戏开始
        SUB_S_UP_DATE                   = 201,           --更新数据
        SUB_S_GAME_RESULT               = 202,           --游戏结果
        SUP_S_GAME_END                  = 203,           --游戏结束
        SUP_S_FREE_TIMES                = 204,           --免费次数
        SUP_S_EXTRA_TIMES               = 205,           --额外倍数
        SUP_S_WIN_GOLD_SCORE            = 206,           --赢取彩金
        SUP_S_LIB_GOLD_SCORE            = 207,           --彩金库
        SUP_S_SHOW_PLAYER               = 209,           --展示其他玩家
        SUP_S_ERROR                     = 210,           --错误信息
        SUP_S_UPDATE_SHOW_PLAYER        = 211,           --其他玩家金币更新
        SUP_S_SERVER_MESSAGE            = 220,           --服务器消息
        SUP_S_TP_MESSAGE_INFO           = 212,           --大奖消息

        -- 玩家操作 客户端命令结构
        SUB_C_GameStart                 = 251,           --开始
        SUB_C_DownLine                  = 252,           --押线
        SUB_C_AddJetton                 = 253,           --加注
        SUB_C_GameEnd                   = 254,           --结束
        SUP_C_CHOOSE_LINE               = 255,           --选择押线
        SUP_C_GameStartEx			    = 256,			 --新的游戏开始
}

--for k, v in pairs(cmd) do
--    cc.exports.G_C_CMD[k] = cmd[k]
--end

--加载界面的提示语
local text = {
    "押多押少全看缘，赢多赢少高兴就好。",
    "多押线，下重注，大奖就要跑过来。",
    "连押满的勇气都没有的人，怎么可能被奖池青睐？",
    "饿死胆小的，撑死胆大的，相信自己，这一把押满！",
}
cc.exports.Localization_cn["Loading_202"] = text
