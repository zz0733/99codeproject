--region *.lua
--Date 2017-2-25
--Author xufei
--Desc 
--此文件由[BabeLua]插件自动生成

local HandredcattleRes =
{
    g_strBackground         = "LoginScene/LoginBg.png",
    --csb
    ["CSB_GAME_MAIN"]           = "game/handredcattle/HandredcattleSceneLayer.csb",
    ["CSB_GAME_RULE"]           = 'game/handredcattle/HandredcattleHelp.csb',
    ["CSB_GAME_TREND"]          = "game/handredcattle/HandredcattleTrendView.csb",
    ["CSB_GAME_TREND_NODE"]     = "game/handredcattle/HandredcattleTrendItem.csb",
    ["CSB_GAME_LOADING"]        = "game/handredcattle/HandredcattleLoadingLayer.csb",
    ["CSB_GAME_USERINFO"]       = "game/handredcattle/HandredcattleOtherInfoLayer.csb",
    ["CSB_GAME_USERINFO_NODE"]  = "game/handredcattle/HandredcattleOtherInfoItem.csb",
    ["CSB_GAME_TREND_VIEW"]     = 'game/handredcattle/HandredcattleTrend.csb',
    ["CSB_GAME_DEALER_QUEUE"]   = 'game/handredcattle/HandredcattleQueue.csb',
    ["CSB_GAME_PLAYER_LIST"]    = 'game/handredcattle/HandredcattlePlayerList.csb',
    ["CSB_GAME_SETTING"]        = 'game/handredcattle/HandredcattleSetting.csb',
    ["CSB_GAME_BET_TIP"]        = 'game/handredcattle/HandredcattleBetTip.csb',


    --sprite
    ["IMG_LIANZHUANG"]      = {
      [1] = "gui-wz-%d.png",
      [2] = "",  
      [3] = "gui-wz-wanj.png",  
      [4] = "gui-wz-wanj.png",    
    },
    ["IMG_RESULT"]          = "gui-niuniu-niu-%d.png",
    ["IMG_SOUND_ON"]        = "gui-niuniu-button-shengying-2.png",
    ["IMG_SOUND_OFF"]       = "gui-niuniu-button-shengying.png",
    ["IMG_MUSIC_ON"]        = "gui-niuniu-button-yingyue-2.png",
    ["IMG_MUSIC_OFF"]       = "gui-niuniu-button-yingyue.png",
    ["IMG_JETTON"]          = "game-jetton-%d.png",
    ["IMG_JETTON_GRAY"]     = "new-game-jetton-%d-hui.png",
    ["IMG_PUSH"]            = "gui-niuniu-button-push.png",
    ["IMG_PUSH1"]           = "gui-niuniu-button-push2.png",
    ["IMG_SHENQING"]        = "gui-gm-button-sqsz.png",
    ["IMG_QUXIAO"]          = "gui-gm-button-qxsz.png",
    ["IMG_SCROLL_BG"]       = "gui-niuniu-scroll-bg.png",
    ["IMG_NULL"]            = "gui-texture-null.png",
    ["IMG_SCROLL_BUTTON"]   = "gui-niuniu-scroll-icon.png",
    ["IMG_TREND_WIN"]       = "gui-niuniu-trend-win.png",
    ["IMG_TREND_LOSE"]      = "gui-niuniu-trend-failure.png",

    --sound
    ["MUSIC_OF_BGM"]        = "sound-bg.mp3",
    ["SOUND_START_WAGER"]   = "sound-start-wager.mp3",
    ["SOUND_END_WAGER"]     = "sound-end-wager.mp3",
    ["SOUND_ZHUANG_1"]      = "zhuang-1.mp3",
    ["SOUND_ZHUANG_2"]      = "zhuang-2.mp3",
    ["SOUND_OF_BUTTON"]     = "sound-button.mp3",
    --["SOUND_OF_CLOCK"]      = "sound-clock-ring.mp3",
    --["SOUND_OF_CLEAR"]      = "sound-clear.mp3",
    ["SOUND_OF_CLOSE"]      = "sound-close.mp3",
    ["SOUND_OF_COUNTDOWN"] = "sound-countdown.mp3",
    ["SOUND_OF_FANPAI"]     = "sound-fanpai.mp3",
    --["SOUND_OF_FAPAI"]      = "sound-fapai.mp3",
    ["SOUND_OF_FAPAI"]      = "sound-sendcard.mp3",
    ["SOUND_OF_GOLD"]       = "sound-gold.wav",
    ["SOUND_OF_JETTON"]     = "sound-jetton.mp3",
    --["SOUND_OF_TIE"]        = "sound-tie.mp3",
    ["SOUND_OF_WIN"]        = "sound-result-win.mp3",
    ["SOUND_OF_LOSE"]       = "sound-result-lose.mp3",
    ["SOUND_OF_NOBET"]      = "sound-result-nobet.mp3",
    ["SOUND_OF_BETHIGH"]    = "sound-bethigh.mp3",
    ["SOUND_OF_BETLOW"]     = "sound-betlow.mp3",
    ["SOUND_OF_GETGOLD"]    = "sound-get-gold.mp3",
    --fnt
    ["FNT_RESULT_WIN"]      = "game/handredcattle/font/sz_pdk3.fnt",
    ["FNT_RESULT_LOSE"]     = "game/handredcattle/font/sz_pdk4.fnt",
    --animation 
    ["JSON_OF_DAOJISHI"]    = "game/handredcattle/effect_public/daojishi_1/daojishi_1.ExportJson",                              --倒计时
    ["JSON_OF_DENGDAI"]     = "game/handredcattle/effect/bairenniuniu_dengdaikaiju/bairenniuniu_dengdaikaiju.ExportJson",       --等待阶段动画----
    ["JSON_OF_JIEDUAN"]     = "game/handredcattle/effect/kaishixiazhu_kaijiang/kaishixiazhu_kaijiang.ExportJson",               --阶段提示动画
    ["JSON_OF_PAIXING"]     = "game/handredcattle/effect/bairenniuniu_kaipai/bairenniuniu_kaipai.ExportJson",                   --结算牌型动画
    ["JSON_OF_BGNV"]        = "game/handredcattle/effect/bairenniuniu_nv/bairenniuniu_nv.ExportJson",                           --背景女动画----------
    ["JSON_OF_WIN"]         = "game/handredcattle/effect/bairenniuniu_ying/bairenniuniu_ying.ExportJson",                       --赢动画
    --effect
    ["ANI_OF_DAOJISHI"]     = "daojishi_1",
    ["ANI_OF_DENGDAI"]      = "bairenniuniu_dengdaikaiju",
    ["ANI_OF_JIEDUAN"]      = "kaishixiazhu_kaijiang",
    ["ANI_OF_PAIXING"]      = "bairenniuniu_kaipai",
    ["ANI_OF_BGNV"]         = "bairenniuniu_nv",
    ["ANI_OF_WIN"]          = "bairenniuniu_ying",
}

HandredcattleRes.vecReleaseAnim = 
{
    HandredcattleRes.JSON_OF_NAOZHONG,
    HandredcattleRes.JSON_OF_DAOJISHI,
    HandredcattleRes.JSON_OF_DENGDAI,
    HandredcattleRes.JSON_OF_JIEDUAN,
    HandredcattleRes.JSON_OF_PAIXING,
    HandredcattleRes.JSON_OF_BGNV,
    HandredcattleRes.JSON_OF_FAPAI,
    HandredcattleRes.JSON_OF_WIN,
}
HandredcattleRes.vecReleasePlist = 
{
    {"game/handredcattle/image/plist/game-jetton.plist", "game/handredcattle/image/plist/game-jetton.png"},   
    {"game/handredcattle/image/plist/niuniu-game.plist",     "game/handredcattle/image/plist/niuniu-game.png"}, 
    {"game/handredcattle/image/plist/gui-poker-1.plist",     "game/handredcattle/image/plist/gui-poker-1.png"}, 
}
HandredcattleRes.vecReleaseImg = {}
HandredcattleRes.vecLoadingSound = 
{
    HandredcattleRes.SOUND_OF_BUTTON,
    HandredcattleRes.SOUND_OF_CLEAR,
    --HandredcattleRes.SOUND_OF_CLOCK,
    HandredcattleRes.SOUND_OF_CLOSE,
    HandredcattleRes.SOUND_OF_COUNTDOWN,
    HandredcattleRes.SOUND_OF_FANPAI,
    HandredcattleRes.SOUND_OF_FAPAI,
    HandredcattleRes.SOUND_OF_GOLD,
    HandredcattleRes.SOUND_OF_JETTON,
    HandredcattleRes.SOUND_OF_TIE,
    HandredcattleRes.SOUND_OF_WIN,
    HandredcattleRes.SOUND_OF_LOSE,
    HandredcattleRes.SOUND_OF_NOBET,
    HandredcattleRes.SOUND_ZHUANG_1,
    HandredcattleRes.SOUND_ZHUANG_2,
}
HandredcattleRes.vecReleaseSound = 
{
    "sound-bethigh.mp3",
    "sound-betlow.mp3",
    "sound-button.mp3",
    "sound-close.mp3",
    "sound-countdown.mp3",
    "sound-end-wager.mp3",
    "sound-fanpai.mp3",
    "sound-fapai.mp3",
    "sound-get-gold.mp3",
    "sound-gold.wav",
    "sound-jetton.mp3",
    "sound-result-lose.mp3",
    "sound-result-nobet.mp3",
    "sound-result-win.mp3",
    "sound-sendcard.mp3",
    "sound-start-wager.mp3",
    "zhuang-1.mp3",
    "zhuang-2.mp3",

    "NiuSpeak_M/cow_0.mp3",
    "NiuSpeak_M/cow_1.mp3",
    "NiuSpeak_M/cow_10.mp3",
    "NiuSpeak_M/cow_11.mp3",
    "NiuSpeak_M/cow_12.mp3",
    "NiuSpeak_M/cow_13.mp3",
    "NiuSpeak_M/cow_14.mp3",
    "NiuSpeak_M/cow_2.mp3",
    "NiuSpeak_M/cow_3.mp3",
    "NiuSpeak_M/cow_4.mp3",
    "NiuSpeak_M/cow_5.mp3",
    "NiuSpeak_M/cow_6.mp3",
    "NiuSpeak_M/cow_7.mp3",
    "NiuSpeak_M/cow_8.mp3",
    "NiuSpeak_M/cow_9.mp3",

    "NiuSpeak_W/cow_0.mp3",
    "NiuSpeak_W/cow_1.mp3",
    "NiuSpeak_W/cow_10.mp3",
    "NiuSpeak_W/cow_11.mp3",
    "NiuSpeak_W/cow_12.mp3",
    "NiuSpeak_W/cow_13.mp3",
    "NiuSpeak_W/cow_14.mp3",
    "NiuSpeak_W/cow_2.mp3",
    "NiuSpeak_W/cow_3.mp3",
    "NiuSpeak_W/cow_4.mp3",
    "NiuSpeak_W/cow_5.mp3",
    "NiuSpeak_W/cow_6.mp3",
    "NiuSpeak_W/cow_7.mp3",
    "NiuSpeak_W/cow_8.mp3",
    "NiuSpeak_W/cow_9.mp3",
}

HandredcattleRes.vecLoadingAnim = HandredcattleRes.vecReleaseAnim

HandredcattleRes.vecLoadingMusic = {
    HandredcattleRes.MUSIC_OF_BGM,
}
HandredcattleRes.vecChipImage_bg = 
{
    "game/handredcattle/chip/bg-chip-01.png",
    "game/handredcattle/chip/bg-chip-02.png",
    "game/handredcattle/chip/bg-chip-03.png",
    "game/handredcattle/chip/bg-chip-04.png",
    "game/handredcattle/chip/bg-chip-05.png",
    "game/handredcattle/chip/bg-chip-06.png",
}
HandredcattleRes.vecChipImage = 
{
    "cm_1.png",
    "cm_10.png",
    "cm_50.png",
    "cm_100.png",
    "cm_500.png",
}
return HandredcattleRes

--endregion

