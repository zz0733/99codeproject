
cc.exports.Localization_cn["WATER_TOP_PRIZE_0"]  = "<font face='fonts/arial.ttf' size='26' color='#c75fd8'>拳打镇关西！<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>恭喜玩家<font face='fonts/arial.ttf' size='24' color='#08fd70'>%s<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>拳打镇关西，获得<font face='fonts/arial.ttf' size='26' color='#f0d676'>%d倍<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>奖励，共赢得<img src='public/image/gui-coin.png' height='35' width='35'></img><font face='fonts/arial.ttf' size='28' color='#f0d676'><i><b>%s</b></i></font>"
cc.exports.Localization_cn["WATER_TOP_PRIZE_1"]  = "<font face='fonts/arial.ttf' size='26' color='#f00000'>义夺快活林！<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>恭喜玩家<font face='fonts/arial.ttf' size='24' color='#08fd70'>%s<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>义夺快活林，获得<font face='fonts/arial.ttf' size='26' color='#f0d676'>%d倍<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>超级奖励，共赢得<img src='public/image/gui-coin.png' height='35' width='35'></img><font face='fonts/arial.ttf' size='28' color='#f0d676'><i><b>%s</b></i></font>"
cc.exports.Localization_cn["WATER_TOP_PRIZE_2"]  = "<font face='fonts/arial.ttf' size='26' color='#00a8ff'>智取生辰纲！<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>恭喜玩家<font face='fonts/arial.ttf' size='24' color='#08fd70'>%s<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>替天行道智取生辰纲，获得<font face='fonts/arial.ttf' size='26' color='#f0d676'>%d倍<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>终极奖励，共赢得<img src='public/image/gui-coin.png' height='35' width='35'></img><font face='fonts/arial.ttf' size='28' color='#f0d676'><i><b>%s</b></i></font>"
cc.exports.Localization_cn["WATER_TOP_PRIZE_3"]  = "<font face='fonts/arial.ttf' size='26' color='#ff9ebe'>白龙庙聚义！<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>恭喜玩家<font face='fonts/arial.ttf' size='24' color='#08fd70'>%s<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>白龙庙英雄小聚义，抽中全屏奖，获得总押注<font face='fonts/arial.ttf' size='26' color='#f0d676'>%d倍<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>奖励，共赢得<img src='public/image/gui-coin.png' height='35' width='35'></img><font face='fonts/arial.ttf' size='28' color='#f0d676'><i><b>%s</b></i></font>"
cc.exports.Localization_cn["WATER_TOP_PRIZE_4"]  = "<font face='fonts/arial.ttf' size='26' color='#0ad600'>芒砀振军风！<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>恭喜玩家<font face='fonts/arial.ttf' size='24' color='#08fd70'>%s<font face='fonts/arial.ttf' size='24' color='#d4d4d4'>芒砀振军风勇闯小玛丽，共赢得<img src='public/image/gui-coin.png' height='35' width='35'></img><font face='fonts/arial.ttf' size='28' color='#f0d676'><i><b>%s </b></i></font><font face='fonts/arial.ttf' size='24' color='#d4d4d4'>"
    

local text = {
    --水浒传--
    ["WATER_1"]  = "x%d=%d倍",
    ["WATER_2"]  = "%d点%s %s",
    ["WATER_3"]  = "大",
    ["WATER_4"]  = "小",
    ["WATER_5"]  = "和",
    ["WATER_6"]  = "\n你赢了,\n敢再来一次吗？",
    ["WATER_7"]  = "\n你输了,\n下次再来试手气吧!",
    ["WATER_8"]  = "%.0f 秒后自动运行",
    ["WATER_9"]  = "次数：%d",
    ["WATER_10"]  = "中奖:%d",
    ["WATER_11"]  = "总中奖:%d",
    ["WATER_12"]  = "您的次数已用完,将退出小玛丽",
    ["WATER_13"]  = "抽中退出游戏",
    ["WATER_14"]  = "当前获得%0.2f金币",
    ["WATER_15"]  = "%s全盘奖 %d倍",
    ["WATER_16"]  = "%s混合全盘奖 %d倍",
    ["WATER_17"]  = "人物",
    ["WATER_18"]  = "武器",
    ["WATER_19"]  = "斧头",
    ["WATER_20"]  = "银枪",
    ["WATER_21"]  = "大刀",
    ["WATER_22"]  = "鲁智深",
    ["WATER_23"]  = "林冲",
    ["WATER_24"]  = "宋江",
    ["WATER_25"]  = "替天行道",
    ["WATER_26"]  = "忠义堂",
    ["WATER_27"]  = "水浒传",
    ["WATER_28"]  = "游戏结束%d秒后退出!",
    ["WATER_29"]  = "+抽奖%d次",
    ["WATER_30"]  = "链接超时,退回主游戏",
}
--for k, v in pairs(text) do
--    cc.exports.Localization_cn[k] = text[k]
--end

local cmd = {

    -- 水浒传 206-----------------------------------------------------
        SUB_C_ADD_CREDIT_SCORE              =1,               -- 加注
        SUB_C_REDUCE_CREDIT_SCORE           =2,               -- 减注
        SUB_C_SCENE1_START                  =3,               -- 场景1开始
        SUB_C_SCENE2_BUY_TYPE               =4,               -- 买大小
        SUB_C_SCORE                         =5,               -- 得分
        SUB_C_SCENE3_START                  =6,               -- 场景3开始
        SUB_C_GLOBAL_MESSAGE                =7,               --
        --SUB_C_STOCK_OPERATE                 =8               --
        SUB_C_PRO_INQUIRY                   =9,               -- 概率查询
        SUB_C_SAVE_PRO                      =10,
        SUB_C_PERSON_CONTROL                =11,              -- 个人控制
        SUB_C_GameEnd_WATER                 =12,              -- 游戏结束(水浒传游戏结束)
        SUB_C_SCENE1_START_NEW              =13,              -- 新场景1开始(传下注倍率)

        SUB_S_SCENE1_START                  =100,             --滚动结果
        SUB_S_SCENE2_RESULT                 =101,             --骰子结果(比大小)
        SUB_S_SCENE3_RESULT                 =102,             --玛丽结果
        SUB_S_STOCK_RESULT                  =103,             --库存操作结果
        SUB_S_PRO_INQUIRY_RESULT            =104,             --概率查询结果
        SUB_S_PERSON_RESULT                 =105,             --个人结果
        SUB_S_DOUBLE_RECORD                 =106,             --比倍记录
        SUB_S_CREDIT_SCORE_UPDATE           =107,             --分数控制
        SUB_S_GAME_END                      =109,             --游戏结束
        SUB_S_SERVER_MESSAGE                =111,             --跑马灯
        SUB_S_RETURN_SCENE1                 =112,             --回到主场景1(子游戏中断网)
        SUP_S_TP_MESSAGE_INFO               =113,             --大奖消息
        -- 水浒传 206-----------------------------------------------------
}

--for k, v in pairs(cmd) do
--    cc.exports.G_C_CMD[k] = cmd[k]
--end

--加载界面的提示语
local text = {
    "智取生辰纲，一夜暴富在今朝！",
    "大河向东流哇，天上的星星参北斗哇。",
    "真正的梁山好汉，定要大碗喝酒大块吃肉，一掷千金为兄弟！",
    "及时雨宋江、豹子头林冲、花和尚鲁智深，好汉云集《水浒传》！",
}
cc.exports.Localization_cn["Loading_206"] = text