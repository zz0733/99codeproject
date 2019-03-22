--region Lhdz_Res.lua
--Date
--Auther Ace
--Desc [[龙虎斗资源定义]]
--此文件由[BabeLua]插件自动生成

local Lhdz_Res = {} --所有资源

--csb
Lhdz_Res.CSB_OF_MAINSCENE       = "game/longhudazhan/lhdzMainLayer.csb"
Lhdz_Res.CSB_OF_RULE            = "game/longhudazhan/lhdzRuleLayer.csb"
Lhdz_Res.CSB_OF_RANK            = "game/longhudazhan/lhdzRankLayer.csb"
Lhdz_Res.CSB_OF_RANK_ITEM       = "game/longhudazhan/lhdzRankInfoItem.csb"
Lhdz_Res.CSB_OF_TREND           = "game/longhudazhan/lhdzTrendLayer.csb"
Lhdz_Res.CSB_OF_USERINFO        = "game/longhudazhan/lhdzUserInfo.csb"
Lhdz_Res.CSB_OF_LOADING         = "game/longhudazhan/lhdzLoading.csb"
Lhdz_Res.CSB_OF_MESSAGEBOX      = "game/longhudazhan/lhdzmessage-box.csb"

--plist
Lhdz_Res.vecPlist = {
    {"game/longhudazhan/plist/gui-longhudazhan-main.plist",     "game/longhudazhan/plist/gui-longhudazhan-main.png", },
    {"game/longhudazhan/plist/bankImages.plist",     "game/longhudazhan/plist/bankImages.png", },
    --{"game/longhudazhan/plist/new-game-jetton.plist",               "game/longhudazhan/plist/new-game-jetton.png", },
    {"game/longhudazhan/plist/MessageBoxPlist.plist",     "game/longhudazhan/plist/MessageBoxPlist.png", },
}

Lhdz_Res.PNG_OF_LOADING_BG = "game/longhudazhan/gui/gui-longhudazhan-loading-bg.jpg"

Lhdz_Res.PNG_OF_SOUND_ON = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-btn-effect-on.png"
Lhdz_Res.PNG_OF_SOUND_OFF = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-btn-effect-off.png"
Lhdz_Res.PNG_OF_MUSIC_ON = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-btn-music-on.png"
Lhdz_Res.PNG_OF_MUSIC_OFF = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-btn-music-off.png"

-- 星粒子
Lhdz_Res.PLIST_OF_GOLD = "game/longhudazhan/plist/fuhao-coin.plist"
Lhdz_Res.PLIST_OF_BAGUA = "game/longhudazhan/plist/guifu_1.plist"

Lhdz_Res.PNG_OF_JETTON = "cm/%d.png"--"game/longhudazhan/gui-longhudazhan-main/new-game-jetton-%d.png"   --筹码
Lhdz_Res.PNG_OF_STATUS_BET = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-status-bet.png"  --下注状态
Lhdz_Res.PNG_OF_STATUS_LOTTERY = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-status-lottery.png"  -- 开奖状态
Lhdz_Res.PNG_OF_HEAD = "gui-icon-head-%02d.png" -- 头像
Lhdz_Res.PNG_OF_ICON_DRAGON = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-icon-dragon.png" -- 龙
Lhdz_Res.PNG_OF_ICON_TIGER = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-icon-tiger.png" -- 虎
Lhdz_Res.PNG_OF_ICON_DRAW = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-icon-draw.png" -- 和
Lhdz_Res.PNG_OF_CARD_VALUE = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-value-%d-%d.png" -- 牌值
Lhdz_Res.PNG_OF_CARD_COLOR = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-color-%d.png" -- 花色
Lhdz_Res.PNG_OF_CARD_BIGCOLOR = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-color-big%d.png" -- 花色
Lhdz_Res.PNG_OF_RECORD_GREEN = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-trend-green.png" --
Lhdz_Res.PNG_OF_RECORD_BLUE = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-trend-blue.png" --
Lhdz_Res.PNG_OF_RECORD_RED = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-trend-red.png" --
--Lhdz_Res.PNG_OF_BANKER_SYSTEM = "game/longhudazhan/gui-longhudazhan-main/gui-wz-xtong.png" -- 系统庄家
--Lhdz_Res.PNG_OF_BANKER_USER = "game/longhudazhan/gui-longhudazhan-main/gui-wz-wanj.png" -- 玩家庄家
Lhdz_Res.PNG_OF_BANKERCHANGE = "game/longhudazhan/gui-longhudazhan-main/gui-wz-lh.png" -- 庄家轮换

Lhdz_Res.PNG_OF_BANKER_CONTINUE = "game/longhudazhan/gui-longhudazhan-main/gui-wz-%d.png" -- 连庄
Lhdz_Res.PNG_OF_BANKER_SPLINE = "game/longhudazhan/gui-longhudazhan-main/banklistfengexian.png" -- 庄家列表的线
Lhdz_Res.PNG_OF_CHIP_EFFECT = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-chip-effect.png"

Lhdz_Res.PNG_OF_BAGUAEFFECT = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-baguaani.png" -- 光效八卦
Lhdz_Res.PNG_OF_BAGUAFLY = "game/longhudazhan/gui-longhudazhan-main/gui-lhdz-baguafly.png" -- 飞行八卦


Lhdz_Res.MESSAGEBOX_IMG = {
    RECHARGE = "game/longhudazhan/plist/MessageBox/message-recharge.png",
    QUIT     = "game/longhudazhan/plist/MessageBox/message-quit.png",
}

Lhdz_Res.FNT_OF_COUNTDOWN = "game/longhudazhan/font/sz-lhdz-01.fnt"
Lhdz_Res.FNT_OF_RESULT_WIN = "game/longhudazhan/font/lhd_jbjia.fnt"
Lhdz_Res.FNT_OF_RESULT_LOSE = "game/longhudazhan/font/lhd_jbjian.fnt"
Lhdz_Res.FONT_ROOM          = "game/longhudazhan/font/jxlw_fc.fnt"
Lhdz_Res.vecReleaseImg = {
    "game/longhudazhan/gui/gui-longhudazhan-bg.jpg",
    "game/longhudazhan/gui/gui-longhudazhan-table.png",
    "game/longhudazhan/gui/gui-longhudazhan-dialog-bg.png",
    "game/longhudazhan/gui/gui-longhudazhan-rule-content.png",
}

--animation
Lhdz_Res.strAnimPath = "game/longhudazhan/effect/"
Lhdz_Res.vecAnim = {
    ["SendCard"] = "longhudazhan4_fanpai"
}

--动画
Lhdz_Res.JSON_OF_LOADING = "public/effect/tongyon_loding/tongyon_loding.ExportJson" --加载

--动画名称
Lhdz_Res.ANI_OF_LAODING = "tongyon_loding" --加载

Lhdz_Res.ANI_OF_BACKGROUND = "game/longhudazhan/effect/longhudazhan4_beijing/longhudazhan4_beijing.%s" -- 背景
Lhdz_Res.ANI_OF_LANTERN = "game/longhudazhan/effect/longhudazhan4_denglong/longhudazhan4_denglong.%s" -- 灯笼
Lhdz_Res.ANI_OF_ANIMAL = "game/longhudazhan/effect/longhudazhan4_long/longhudazhan4_long.%s" -- 龙虎
Lhdz_Res.ANI_OF_NEXT_GAME = "game/longhudazhan/effect/longhudazhan4_xiajukaishi/longhudazhan4_xiajukaishi.%s" -- 下局
Lhdz_Res.ANI_OF_PAIXIAO = "game/longhudazhan/effect/longhudazhan4_paixiao/longhudazhan4_paixiao.%s" -- 牌效
Lhdz_Res.ANI_OF_GAME_TIPS = "game/longhudazhan/effect/longhudazhan4_kaiju/longhudazhan4_kaiju.%s" -- 游戏提示

Lhdz_Res.ANI_OF_GETCHIP2 = "game/longhudazhan/effect/xuanwo2/jinbixuanwo.%s" -- 吃筹码金币效果

Lhdz_Res.ANI_OF_LAOHUTEXIAO = 
{
    FILEPATH = "game/longhudazhan/effect/laohutexiao_Animation/laohutexiao_Animation.ExportJson",
    FILENAME = "laohutexiao_Animation",
}

Lhdz_Res.ANI_OF_CHIPEFFECT = {
    FILEPATH = "game/longhudazhan/effect/chouma_Animation/chouma_Animation.ExportJson",
    FILENAME = "chouma_Animation",
}

Lhdz_Res.ANI_OF_WINNER = {
    FILEPATH = "game/longhudazhan/effect/longhudazhan4_zhongjiang/longhudazhan4_zhongjiang.ExportJson",
    FILENAME = "longhudazhan4_zhongjiang",
}

Lhdz_Res.ANI_OF_CHANGEUSER = {
    FILEPATH = "game/longhudazhan/effect/longyuhufanpai_Animation/longyuhufanpai_Animation.ExportJson",
    FILENAME = "longyuhufanpai_Animation",
    ANILIST = {
        BEGIN = {
            NAME = "Animation1",
            NODES = {
                HEAD = "Layer6_Copy1",  --动画节点，用于替换资源
            },
        },
        END = {
            NAME = "Animation2",
            NODES = {
                HEAD = "Layer6_Copy1",  --动画节点，用于替换资源
            },
        },
    },
}

Lhdz_Res.ANI_OF_TOPWINEFFECT = {
    FILEPATH = "game/longhudazhan/effect/fuhao/fuhao.ExportJson",
    FILENAME = "fuhao",
    ANILIST = {
        RICHNORMAL = {
            NAME = "Animation1_2",
        },
        RICHPLAY = {
            NAME = "Animation1",
        },
        LUCKYNORMAL = {
            NAME = "Animation5_2",
        },
        LUCKYPLAY = {
            NAME = "Animation5",
        },
    },
}

--Lhdz_Res.ANI_OF_WINHU = {
--    FILEPATH = "game/longhudazhan/effect/longhu_hulong_Animation/longhu_hulong_Animation.ExportJson",
--    FILENAME = "longhu_hulong_Animation",
--}

--game sound
Lhdz_Res.vecSound = {
    
    SOUND_OF_START_BET      = "game/longhudazhan/sound/sound-start-wager.mp3",  -- 播放“开始下注”动画
    SOUND_OF_STOP_BET       = "game/longhudazhan/sound/sound-end-wager.mp3",    -- 播放“停止下注”动画
    SOUND_OF_DRAGON         = "game/longhudazhan/sound/sound-dragon.mp3",   -- 比牌结果为龙赢
    SOUND_OF_TIGER          = "game/longhudazhan/sound/sound-tiger.mp3",    -- 比牌结果为虎赢
    SOUND_OF_DRAW           = "game/longhudazhan/sound/sound-draw.mp3",   -- 比牌结果为和
    SOUND_OF_VALUE          = "game/longhudazhan/sound/sound-%d.mp3",   -- 翻牌结果为%d点
    SOUND_OF_BANKER         = "game/longhudazhan/sound/sound-banker.mp3",   --更换庄家
    SOUND_OF_BATTLE         = "game/longhudazhan/sound/sound-battle.mp3",   -- 播放龙vs虎动画
    SOUND_OF_WINDOW         = "game/longhudazhan/sound/sound-window.mp3",   -- 播放窗口飞行动画
    SOUND_OF_JETTON         = "game/longhudazhan/sound/sound-jetton.mp3",   -- 玩家自己切换筹码或下注时
    SOUND_OF_JETTON_LOW     = "game/longhudazhan/sound/sound-bet.mp3",            -- 金额低于100块的播放低价值音效
    SOUND_OF_JETTON_HIGH    = "game/longhudazhan/sound/sound-bethigh.mp3",        -- 金额大于100块的播放高价值音效
    SOUND_OF_RESULT_JETTON  = "game/longhudazhan/sound/sound-result-jetton.mp3", -- 播放结算筹码飞行动画，每段播放一次
    SOUND_OF_STAR           = "game/longhudazhan/sound/sound-star.mp3", -- 播放神算子玩家首次下注的星标飞行动画
    SOUND_OF_RING           = "game/longhudazhan/sound/sound-clock-ring.mp3",   -- 下注最后5秒
    SOUND_OF_SEND_CARD      = "game/longhudazhan/sound/sound-fapai.mp3",   -- 发牌
    SOUND_OF_FLOP_CARD      = "game/longhudazhan/sound/sound-fanpai.mp3",   -- 翻牌
    SOUND_OF_POPSCORE       = "game/longhudazhan/sound/sound-popscore.mp3",   -- 自己本轮赢钱
    SOUND_OF_POPGOLD       = "game/longhudazhan/sound/sound-gold.mp3",   -- 弹金币音效
--    SOUND_OF_WIN            = "game/longhudazhan/sound/sound-result-win.mp3",   -- 自己本轮赢钱
--    SOUND_OF_LOSE           = "game/longhudazhan/sound/sound-result-lose.mp3",   -- 自己本轮输钱
--    SOUND_OF_NOBET          = "game/longhudazhan/sound/sound-result-nobet.mp3",   -- 自己本轮未下注或不输不赢
    SOUND_OF_BUTTON         = "public/sound/sound-button.mp3",   -- 点击除筹码外的其他按钮
    SOUND_OF_CLOSE          = "public/sound/sound-close.mp3",   -- 关闭弹窗
}

--game sound
Lhdz_Res.vecLoadingSound = {
    "game/longhudazhan/sound/sound-start-wager.mp3",  -- 播放“开始下注”动画
    "game/longhudazhan/sound/sound-end-wager.mp3",    -- 播放“停止下注”动画
    "game/longhudazhan/sound/sound-dragon.mp3",   -- 比牌结果为龙赢
    "game/longhudazhan/sound/sound-tiger.mp3",    -- 比牌结果为虎赢
    "game/longhudazhan/sound/sound-draw.mp3",   -- 比牌结果为和
    "game/longhudazhan/sound/sound-1.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-2.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-3.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-4.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-5.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-6.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-7.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-8.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-9.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-10.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-11.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-12.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-13.mp3",   -- 翻牌结果
    "game/longhudazhan/sound/sound-banker.mp3",   --更换庄家
    "game/longhudazhan/sound/sound-battle.mp3",   -- 播放龙vs虎动画
    "game/longhudazhan/sound/sound-window.mp3",   -- 播放窗口飞行动画
    "game/longhudazhan/sound/sound-jetton.mp3",   -- 玩家自己切换筹码或下注时
    "game/longhudazhan/sound/sound-bet.mp3",            -- 金额低于100块的播放低价值音效
    "game/longhudazhan/sound/sound-bethigh.mp3",        -- 金额大于100块的播放高价值音效
    "game/longhudazhan/sound/sound-result-jetton.mp3", -- 播放结算筹码飞行动画，每段播放一次
    "game/longhudazhan/sound/sound-star.mp3", -- 播放神算子玩家首次下注的星标飞行动画
    "game/longhudazhan/sound/sound-clock-ring.mp3",   -- 下注最后3秒
    "game/longhudazhan/sound/sound-fapai.mp3",   -- 发牌
    "game/longhudazhan/sound/sound-fanpai.mp3",   -- 翻牌
    "game/longhudazhan/sound/sound-popscore.mp3",
    "game/longhudazhan/sound/sound-gold.mp3",
--    "game/longhudazhan/sound/sound-result-win.mp3",   -- 自己本轮赢钱
--    "game/longhudazhan/sound/sound-result-lose.mp3",   -- 自己本轮输钱
--    "game/longhudazhan/sound/sound-result-nobet.mp3",   -- 自己本轮未下注或不输不赢
    "public/sound/sound-button.mp3",   -- 点击除筹码外的其他按钮
    "public/sound/sound-close.mp3",   -- 关闭弹窗
}

Lhdz_Res.vecLoadingMusic = {
    MUSIC_OF_BGM    = "game/longhudazhan/sound/sound-bg.mp3",  -- 背景音
}

return Lhdz_Res
--endregion
