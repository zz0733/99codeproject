--region *.lua
--Desc 
--此文件由[BabeLua]插件自动生成

local RedVsBlackRes = 
{
    --界面资源
    CSB_GAME_USERINFO       = "RBWar/RBWarPlayerList.csb",
    CSB_GAME_MAIN           = "RBWar/RBWarScene.csb",

    --字体
    FNT_RESULT_LOSE      = "common/font/num_lose.fnt",
    FNT_RESULT_WIN       = "common/font/num_win.fnt",

    --图片
    IMG_POKER_BACKBG     = "game/redvsblack/plist/gui-redblack-poker_backbg.png",
    IMG_POKER_FRONTBG    = "game/redvsblack/plist/poker-frontbg.png",
    IMG_MUSIC_ON         = "game/redvsblack/plist/gui-btn-musicon.png",
    IMG_MUSIC_OFF        = "game/redvsblack/plist/gui-btn-musicoff.png",
    IMG_SOUND_ON         = "game/redvsblack/plist/gui-btn-soundon.png",
    IMG_SOUND_OFF        = "game/redvsblack/plist/gui-btn-soundoff.png",
    IMG_POINT_RED        = "game/redvsblack/plist/gui-redblack-redpoint.png",
    IMG_POINT_BLACK      = "game/redvsblack/plist/gui-redblack-blackpoint.png",
    IMG_RING_RED         = "game/redvsblack/plist/gui-redblack-redring.png",
    IMG_RING_BLACK       = "game/redvsblack/plist/gui-redblack-blackring.png",
    IMG_BANKER_UP        = "game/redvsblack/plist/gui-redblack-main-applydealer.png",
    IMG_BANKER_DOWN      = "game/redvsblack/plist/gui-redblack-main-downdealer.png",
    IMG_BANKER_UPP       = "game/redvsblack/plist/gui-redblack-main-applydealer-pressed.png",
    IMG_BANKER_DOWNP     = "game/redvsblack/plist/gui-redblack-main-downdealer-pressed.png",
    IMG_JETTON           = "cm/%d.png",--"new-game-jetton-%d.png",
    IMG_JETTON_DEFAULT   = "new-game-jetton-100.png",
    IMG_TYPE_SINGLE      = "game/redvsblack/plist/gui-redblack-single.png",
    IMG_TYPE_NOSINGLE    = "game/redvsblack/plist/gui-redblack-nosingle.png",
    IMG_MENU_POP         = "game/redvsblack/plist/gui-button-pop.png",
    IMG_MENU_PUSH        = "game/redvsblack/plist/gui-button-push.png",
    IMG_ICON_NEW         = "game/redvsblack/plist/gui-redblack-newicon.png",
    IMG_DALUBG           = "game/redvsblack/plist/gui-redblack-trend-dalubg.png",
    IMG_SCROLL_BG        = "game/redvsblack/plist/gui-otherinfo-scroll-bg.png",
    IMG_NULL             = "game/redvsblack/plist/gui-texture-null.png",
    IMG_SCROLL_BUTTON    = "game/redvsblack/plist/gui-otherinfo-scroll-icon.png",
    IMG_GAMECHIP         = "game/redvsblack/plist/gui-status-xiazhu.png",
    IMG_GAMECHIP_ICON    = "game/redvsblack/plist/gui-status-icon-xiazhu.png",
    IMG_GAMEOPEN         = "game/redvsblack/plist/gui-status-kaijiang.png",
    IMG_GAMECHIP_OPEN    = "game/redvsblack/plist/gui-status-icon-kaijiang.png",

    --声音
    SOUND_OF_BUTTON      = "RBWar/sound/ui_click.mp3", --按钮点击
    SOUND_OF_FAPAI       = "game/redvsblack/sound/sound-fapai.mp3", --发牌
    SOUND_OF_FANPAI      = "game/redvsblack/sound/sound-fapai.mp3", --翻牌

    SOUND_OF_WIN         = "game/redvsblack/sound/sound-result-win.mp3", --赢
    SOUND_OF_LOSE        = "game/redvsblack/sound/sound-result-lose.mp3", --输
    SOUND_OF_CARDTYPE    = "RBWar/sound/sound-cardtype-%d.mp3", --牌型
    SOUND_OF_BETLOW      = "game/redvsblack/sound/sound-bet2.mp3", --低价值筹码音效
    SOUND_OF_BETHIGH     = "game/redvsblack/sound/sound-bet.mp3", --高价值筹码音效
    SOUND_OF_STARTBET    = "game/redvsblack/sound/sound-start-bet.mp3", --开始下注
    SOUND_OF_STOPBET     = "game/redvsblack/sound/sound-stop-bet.mp3", --停止下注
    SOUND_OF_RESULTGOLD  = "game/redvsblack/sound/sound-gold.wav", --结算金币
    SOUND_OF_GETGOLD     = "RBWar/sound/on_get.mp3", --获取金币
    SOUND_OF_BGM         = "game/redvsblack/sound/sound-bg.mp3", --背景音乐
    SOUND_OF_COUNT       = "game/redvsblack/sound/sound-countdown.mp3", --3秒倒计时音效

    --动画
    ANI_CARDTYPE         = "fanpaijieguo",
    ANI_KING             = "king",
    ANI_QUEEN            = "queen",
    ANI_DAOJISHI         = "daojishi_1",
    ANI_ZHUANCHANG       = "zhuanchang",

    -- 牌
    IMG_CARDS = {
        [0] = "common/card/314.png",[1] = "common/card/32.png",[2] = "common/card/33.png",[3] = "common/card/34.png",[4] = "common/card/35.png",[5] = "common/card/36.png",[6] = "common/card/37.png",[7] = "common/card/38.png",[8] = "common/card/39.png",[9] = "common/card/310.png",[10] = "common/card/311.png",[11] = "common/card/312.png",[12] = "common/card/313.png",

        [13] = "common/card/214.png",[14] = "common/card/22.png",[15] = "common/card/23.png",[16] = "common/card/24.png",[17] = "common/card/25.png",[18] = "common/card/26.png",[19] = "common/card/27.png",[20] = "common/card/28.png",[21] = "common/card/29.png",[22] = "common/card/210.png",[23] = "common/card/211.png",[24] = "common/card/212.png",[25] = "common/card/213.png",

        [26] = "common/card/114.png",[27] = "common/card/12.png",[28] = "common/card/13.png",[29] = "common/card/14.png",[30] = "common/card/15.png",[31] = "common/card/16.png",[32] = "common/card/17.png",[33] = "common/card/18.png",[34] = "common/card/19.png",[35] = "common/card/110.png",[36] = "common/card/111.png",[37] = "common/card/112.png",[38] = "common/card/113.png",[39] = "common/card/114.png",

        [39] = "common/card/014.png",[40] = "common/card/02.png",[41] = "common/card/03.png",[42] = "common/card/04.png",[43] = "common/card/05.png",[44] = "common/card/06.png",[45] = "common/card/07.png",[46] = "common/card/08.png",[47] = "common/card/09.png",[48] = "common/card/010.png",[49] = "common/card/011.png",[50] = "common/card/012.png",[51] = "common/card/013.png",
    },

    -- 牌型
    ECardType = {
        [1] = "单张", 
        [2] = "对子", 
        [3] = "顺子", 
        [4] = "金花", 
        [5] = "顺金", 
        [6] = "豹子", 
        [7] = "235", 
    }, 
    IMG_ECardType = {
        [1] = "RBWar/image/new/rbwtype_1.png", 
        [2] = "RBWar/image/new/rbwtype_2.png", 
        [3] = "RBWar/image/new/rbwtype_3.png", 
        [4] = "RBWar/image/new/rbwtype_4.png", 
        [5] = "RBWar/image/new/rbwtype_5.png", 
        [6] = "RBWar/image/new/rbwtype_6.png", 
        [7] = "RBWar/image/new/rbwtype_7.png", 
    }, 
    spriteState = {
        [1] = "RBwar/image/brnn_zt0_1.png", -- 等待开局
        [2] = "RBwar/image/brnn_zt0_2.png", -- 等待下注
        [3] = "RBwar/image/brnn_zt0_3.png", -- 等待开牌
        [4] = "RBwar/image/brnn_zt0_4.png", -- 正在开牌
        [5] = "RBwar/image/brnn_zt0_6.png", -- 正在结算
    },
    vecReleaseAnim = 
    {
--        "game/redvsblack/effect/honghei/honghei.ExportJson",
        "game/redvsblack/effect/fanpaijieguo/fanpaijieguo.ExportJson",
        "game/redvsblack/effect/zhuanchang/zhuanchang.ExportJson",
        "game/redvsblack/effect/king/king.ExportJson",
        "game/redvsblack/effect/queen/queen.ExportJson",
        "game/redvsblack/effect/daojishi_1/daojishi_1.ExportJson", --最后3秒倒计时
    },

    vecReleasePlist = 
    {
        {"game/redvsblack/plist/gui-poker-1.plist", "game/redvsblack/plist/gui-poker-1.png"},
        {"game/redvsblack/plist/redvsblack.plist", "game/redvsblack/plist/redvsblack.png"},
        {"game/redvsblack/plist/new-game-jetton.plist", "game/redvsblack/plist/new-game-jetton.png"},
    },

    vecReleaseImg = {
    },

    vecReleaseSound = 
    {
        "game/redvsblack/sound/sound-bet.mp3",        -- 下注
        "game/redvsblack/sound/sound-bet2.mp3",       -- 下注
        "game/redvsblack/sound/sound-bg.mp3",         -- 背景bgm
        "game/redvsblack/sound/sound-button.mp3",     -- 按钮
        "game/redvsblack/sound/sound-cardtype-1.mp3", -- 六种牌型
        "game/redvsblack/sound/sound-cardtype-2.mp3",
        "game/redvsblack/sound/sound-cardtype-3.mp3",
        "game/redvsblack/sound/sound-cardtype-4.mp3",
        "game/redvsblack/sound/sound-cardtype-5.mp3",
        "game/redvsblack/sound/sound-cardtype-6.mp3",
        "game/redvsblack/sound/sound-clock-ring.mp3", -- 闹钟报警
        "game/redvsblack/sound/sound-close.mp3",      -- 关闭窗口
        "game/redvsblack/sound/sound-start-bet.mp3",  -- 开始下注
        "game/redvsblack/sound/sound-stop-bet.mp3",   -- 停止下注
        "game/redvsblack/sound/sound-fapai.mp3",      -- 发牌
        "game/redvsblack/sound/sound-fanpai.mp3",     -- 翻牌
        "game/redvsblack/sound/sound-gold.mp3",       -- 金币数字特效
        "game/redvsblack/sound/sound-countdown.mp3",  -- 倒计时
        "game/redvsblack/sound/sound-get-gold.mp3",   -- 获取金币
        "game/redvsblack/sound/sound-result-nobet.mp3", --未下注
        "game/redvsblack/sound/sound-result-win.mp3", --赢
        "game/redvsblack/sound/sound-result-lose.mp3", --输
    },

    vecLoadingMusic = {
        "game/redvsblack/sound/sound-bg.mp3",         -- 背景bgm
    },
}

RedVsBlackRes.vecLoadingPlist = RedVsBlackRes.vecReleasePlist
RedVsBlackRes.vecLoadingImg   = RedVsBlackRes.vecReleaseImg
RedVsBlackRes.vecLoadingAnim  = RedVsBlackRes.vecReleaseAnim

RedVsBlackRes.vecLoadingSound = {
    "game/redvsblack/sound/sound-bet.mp3",        -- 下注
    "game/redvsblack/sound/sound-bet2.mp3",       -- 下注
    "game/redvsblack/sound/sound-button.mp3",     -- 按钮
    "game/redvsblack/sound/sound-cardtype-1.mp3", -- 六种牌型
    "game/redvsblack/sound/sound-cardtype-2.mp3",
    "game/redvsblack/sound/sound-cardtype-3.mp3",
    "game/redvsblack/sound/sound-cardtype-4.mp3",
    "game/redvsblack/sound/sound-cardtype-5.mp3",
    "game/redvsblack/sound/sound-cardtype-6.mp3",
    "game/redvsblack/sound/sound-clock-ring.mp3", -- 闹钟报警
    "game/redvsblack/sound/sound-close.mp3",      -- 关闭窗口
    "game/redvsblack/sound/sound-start-bet.mp3",  -- 开始下注
    "game/redvsblack/sound/sound-stop-bet.mp3",   -- 停止下注
    "game/redvsblack/sound/sound-fapai.mp3",      -- 发牌
    "game/redvsblack/sound/sound-fanpai.mp3",     -- 翻牌
    "game/redvsblack/sound/sound-gold.mp3",       -- 金币数字特效
    "game/redvsblack/sound/sound-countdown.mp3", -- 倒计时
    "game/redvsblack/sound/sound-get-gold.mp3",   -- 获取金币
    "game/redvsblack/sound/sound-result-nobet.mp3", --未下注
    "game/redvsblack/sound/sound-result-win.mp3", --赢
    "game/redvsblack/sound/sound-result-lose.mp3", --输
}

return RedVsBlackRes
--endregion
