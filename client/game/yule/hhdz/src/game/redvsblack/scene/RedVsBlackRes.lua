--region *.lua
--Desc 
--此文件由[BabeLua]插件自动生成

local RedVsBlackRes = 
{
    --界面资源
    CSB_GAME_TREND          = "game/redvsblack/Layer/RedVsBlackTrendLayer.csb",
    CSB_GAME_USERINFO       = "game/redvsblack/Layer/OtherInfoLayer.csb",
    CSB_GAME_USERINFO_NODE  = "game/redvsblack/Layer/OtherInfoItem.csb",
    CSB_GAME_LOADING        = "game/redvsblack/Layer/RedVsBlackLoadingLayer.csb",
    CSB_GAME_MAIN           = "game/redvsblack/Layer/RedVsBlackLayer.csb",

    --字体
    FNT_ROOMNUMBER       = "public/font/11.fnt",
    FNT_RESULTGOLD       = "game/redvsblack/font/txt-number.fnt",
    FNT_RESULT_LOSE      = "game/redvsblack/font/sz_pdk4.fnt",
    FNT_RESULT_WIN       = "game/redvsblack/font/sz_pdk3.fnt",

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
    SOUND_OF_BUTTON      = "public/sound/sound-button.mp3", --按钮点击
    SOUND_OF_CLOSE       = "game/redvsblack/sound/sound-close.mp3", --关闭按钮
    SOUND_OF_FAPAI       = "game/redvsblack/sound/sound-fapai.mp3", --发牌
    SOUND_OF_FANPAI      = "game/redvsblack/sound/sound-fapai.mp3", --翻牌
    SOUND_OF_NOBET       = "game/redvsblack/sound/sound-result-nobet.mp3", --未下注
    SOUND_OF_WIN         = "game/redvsblack/sound/sound-result-win.mp3", --赢
    SOUND_OF_LOSE        = "game/redvsblack/sound/sound-result-lose.mp3", --输
    SOUND_OF_CARDTYPE    = "game/redvsblack/sound/sound-cardtype-%d.mp3", --牌型
    SOUND_OF_BETLOW      = "game/redvsblack/sound/sound-bet2.mp3", --低价值筹码音效
    SOUND_OF_BETHIGH     = "game/redvsblack/sound/sound-bet.mp3", --高价值筹码音效
    SOUND_OF_STARTBET    = "game/redvsblack/sound/sound-start-bet.mp3", --开始下注
    SOUND_OF_STOPBET     = "game/redvsblack/sound/sound-stop-bet.mp3", --停止下注
    SOUND_OF_RESULTGOLD  = "game/redvsblack/sound/sound-gold.wav", --结算金币
    SOUND_OF_GETGOLD     = "game/redvsblack/sound/sound-get-gold.mp3", --获取金币
    SOUND_OF_BGM         = "game/redvsblack/sound/sound-bg.mp3", --背景音乐
    SOUND_OF_COUNT       = "game/redvsblack/sound/sound-countdown.mp3", --3秒倒计时音效

    --动画
    ANI_CARDTYPE         = "fanpaijieguo",
    ANI_KING             = "king",
    ANI_QUEEN            = "queen",
    ANI_DAOJISHI         = "daojishi_1",
    ANI_ZHUANCHANG       = "zhuanchang",
    

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
