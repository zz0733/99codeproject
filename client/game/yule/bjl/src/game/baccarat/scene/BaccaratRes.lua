--region *.lua
--Date 2017-2-25
--Author xufei
--此文件由[BabeLua]插件自动生成

local BaccaratRes = --所有资源
{
    CSB_GAME_LOADING        = "game/baccarat/BaccaratLoadingLayer.csb",
    CSB_GAME_TREND          = "game/baccarat/BaccaratTrendLayer.csb",
    CSB_GAME_MAIN           = "Baccarat/BaccaratScene.csb",
    CSB_GAME_USERINFO       = "Baccarat/BaccaratPlayerList.csb",
    CSB_GAME_USERINFO_NODE  = "game/baccarat/OtherInfoItem.csb",
    CSB_GAME_POKER          = "game/baccarat/Poker.csb",
    --font

    --image
    IMG_MUSIC_ON         = "gui-btn-musicon.png",
    IMG_MUSIC_OFF        = "gui-btn-musicoff.png",
    IMG_SOUND_ON         = "gui-btn-soundon.png",
    IMG_SOUND_OFF        = "gui-btn-soundoff.png",
    IMG_PUSH             = "gui-baccarat-button-push.png",
    IMG_POP              = "gui-baccarat-button-pop.png",
    IMG_DALUCELL_BG      = "gui-baccarat-road-gezi2.png",
    IMG_XIAOLUCELL_BG    = "gui-baccarat-road-gezi3.png",
    IMG_ROADSMALL_BG     = "gui-baccarat-road-gezi4.png",
    IMG_TABLE_ZHUANG     = "gui-baccarat-road-zhuang.png",
    IMG_TABLE_XIAN       = "gui-baccarat-road-xian.png",
    IMG_TABLE_PING       = "gui-baccarat-road-ping.png",
    IMG_TABLE_XIANPING   = "gui-baccarat-road-greenclash.png",
    IMG_TABLE_ZHUANGPING = "gui-baccarat-road-redclash.png",
    IMG_TABLE_XIANWIN    = "gui-baccarat-road-greencircle.png",
    IMG_TABLE_ZHUANGWIN  = "gui-baccarat-road-redcircle.png",    
    IMG_TABLE_XIANDUI    = "gui-baccarat-road-greenicon.png",
    IMG_TABLE_ZHUANGDUI  = "gui-baccarat-road-redicon.png",    
    IMG_SCROLL_BG        = "gui-otherinfo-scroll-bg.png",
    IMG_NULL             = "gui-texture-null.png",
    IMG_SCROLL_BUTTON    = "gui-otherinfo-scroll-icon.png",
    IMG_HUANZHUANG       = "gui-baccarat-huanzhuang.png",
    IMG_LIANZHUANG       = "gui-wz-%d.png",
    IMG_CARDPOINT        = "huanle30s_%ddian.png",
    IMG_GAMECHIP         = "gui-baccarat_status_xiazhu.png",
    IMG_GAMEOPEN         = "gui-baccarat_status_kaijiang.png",
    IMG_SMALL_ZHUANG     = "gui-baccarat-road-zhuangs.png",
    IMG_SMALL_XIAN       = "gui-baccarat-road-xians.png",
    IMG_SMALL_PING       = "gui-baccarat-road-pings.png",
    

    --gui-baccarat.plist
    --game sound
    SOUND_OF_CARD    = "game/baccarat/sound/sound-baccarat_card.wav", --开牌
    --SOUND_OF_FAN     = "game/baccarat/sound/sound-fanpai.mp3", --翻牌
    SOUND_OF_NOBET   = "game/baccarat/sound/sound-result-nobet.mp3", --未下注
    SOUND_OF_WIN     = "game/baccarat/sound/sound-result-win.mp3", --赢
    SOUND_OF_LOSE    = "game/baccarat/sound/sound-result-lose.mp3", --输
    SOUND_OF_BG      = "game/baccarat/sound/sound-happy-bg.mp3", --背景音乐
    SOUND_OF_COUNT   = "game/baccarat/sound/sound-countdown.mp3", --3秒倒计时音效
    SOUND_OF_GETGOLD = "Baccarat/sound/new_chips.mp3",

    --system sound
    --SOUND_OF_CLOCK       = "game/baccarat/sound/sound-clock-ring.mp3", --闹钟
    SOUND_OF_JETTON      = "game/baccarat/sound/sound-jetton.mp3", --下注
    SOUND_OF_WAGER_START = "Baccarat/sound/start.mp3", --下注
    SOUND_OF_WAGER_STOP  = "Baccarat/sound/stopbet.mp3", --下注
    SOUND_OF_XPOINT      = "game/baccarat/sound/sound-baccarat-xpoint-%d.mp3", --闲家点数
    SOUND_OF_ZPOINT      = "game/baccarat/sound/sound-baccarat-zpoint-%d.mp3", --庄家点数
    SOUND_OF_PING        = "game/baccarat/sound/sound-baccarat-ping.mp3", --平局
    SOUND_OF_XIANWIN     = "game/baccarat/sound/sound-baccarat-xianwin.mp3", --闲赢
    SOUND_OF_ZHUANGWIN   = "game/baccarat/sound/sound-baccarat-zhuangwin.mp3", --庄赢
    SOUND_OF_TIANWANG   = "game/baccarat/sound/sound-baccarat-tianwang.mp3", --天王
    
    SOUND_OF_ZHUANG      = { --庄家轮换
        "game/baccarat/sound/zhuang-1.mp3",
        "game/baccarat/sound/zhuang-2.mp3",
    },
    SOUND_OF_BUTTON      = "public/sound/sound-button.mp3", --按钮
    SOUND_OF_CLOSE       = "public/sound/sound-close.mp3", --关闭
    SOUND_OF_BETLOW      = "game/baccarat/sound/sound-betlow.mp3", --低价值筹码音效
    SOUND_OF_BETHIGH     = "game/baccarat/sound/sound-bethigh.mp3", --高价值筹码音效
    SOUND_OF_CMD         = {
        "game/baccarat/sound/sound-win-big-1.mp3", --1
        "game/baccarat/sound/sound-win-big-2.mp3", --2
        "game/baccarat/sound/sound-win-middle-1.mp3", --3
        "game/baccarat/sound/sound-win-middle-2.mp3", --4
        "game/baccarat/sound/sound-win-small-1.mp3", --5
        "game/baccarat/sound/sound-win-small-2.mp3", --6
        "game/baccarat/sound/sound-lose-big-%d.mp3", --7
        "game/baccarat/sound/sound-lose-middle-1.mp3", --8
        "game/baccarat/sound/sound-lose-middle-2.mp3", --9
        "game/baccarat/sound/sound-lose-small-1.mp3", --10
        "game/baccarat/sound/sound-lose-small-2.mp3", --11
    },

    --动画
    ANI_FILE_DAOJISHI   = "daojishi_1",
    ANI_FILE_FANPAI     = "huanle30s_fanpai",
    ANI_FILE_ZHUANCHANG = "kaishixiazhu_kaijiang",
    ANI_NAME_BEGINCHIP  = "Animation1",
    ANI_NAME_STOPCHIP   = "Animation2",
    ANI_FILE_CARDTYPE   = "huanle30s_kaipai",
    ANI_FILE_YING       = "jiesuan_ying",
    ANI_YING_NAME       = {
        BEGAN           = "Animation1",
        LOOP            = "Animation2",
    },
    ANI_CARDTYPE_NAME   = {
        NAME_DUIZI      = "Animation1", --对子
        NAME_TIANWANG   = "Animation2", --天王
        NAME_SAMEPING   = "Animation3", --同点平
        NAME_PING       = "Animation4", --平
        BONE_LOWPOINT   = "huanle30s_4dian",
        BONE_HIGHPOINT  = "huanle30s_8dian",
        [0]             = "Animation5", --0-7点
        [1]             = "Animation5", --0-7点
        [2]             = "Animation5", --0-7点
        [3]             = "Animation5", --0-7点
        [4]             = "Animation5", --0-7点
        [5]             = "Animation5", --0-7点
        [6]             = "Animation5", --0-7点
        [7]             = "Animation5", --0-7点
        [8]             = "Animation6", --8,9点
        [9]             = "Animation6", --8,9点
    },
    ANI_FILE_WAIT       = "huanle30s_dengdaixiaju",

    --字体
    FNT_RESULT_LOSE = "common/font/num_lose.fnt",
    FNT_RESULT_WIN  = "common/font/num_win.fnt",

    vecReleaseAnim = {  -- 退出时需要释放的动画资源
        "game/baccarat/effect_public/daojishi_1/daojishi_1.ExportJson", --最后3秒倒计时
        "game/baccarat/effect_public/kaishixiazhu_kaijiang/kaishixiazhu_kaijiang.ExportJson", --开始下注/停止下注
        "game/baccarat/effect/huanle30s_fanpai/huanle30s_fanpai.ExportJson", --翻牌动画 牌值节点:"A" 花色节点:"heitao"
        "game/baccarat/effect/huanle30s_kaipai/huanle30s_kaipai.ExportJson", --牌型动画
        "game/baccarat/effect/huanle30s_dengdaixiaju/huanle30s_dengdaixiaju.ExportJson", --等待下一局
        "game/baccarat/effect_public/jiesuan_ying/jiesuan_ying.ExportJson", --赢动画
        "game/baccarat/effect/huanle30s_beijing/huanle30s_beijing.ExportJson", --背景
    },

    vecReleasePlist = {
        {"game/baccarat/plist/new-game-jetton.plist",  "game/baccarat/plist/new-game-jetton.png",   },
        {"game/baccarat/plist/gui-poker-1.plist",  "game/baccarat/plist/gui-poker-1.png",   },
        
    },

    vecReleaseImg = {
       
    },
    spriteState = {
        [1] = "Baccarat/image/clock_state_bet.png",
        [2] = "Baccarat/image/clock_state_idle.png",
    },

      -- 牌
    IMG_CARDS = {
        [0] = "common/card/314.png",[1] = "common/card/32.png",[2] = "common/card/33.png",[3] = "common/card/34.png",[4] = "common/card/35.png",[5] = "common/card/36.png",[6] = "common/card/37.png",[7] = "common/card/38.png",[8] = "common/card/39.png",[9] = "common/card/310.png",[10] = "common/card/311.png",[11] = "common/card/312.png",[12] = "common/card/313.png",

        [13] = "common/card/214.png",[14] = "common/card/22.png",[15] = "common/card/23.png",[16] = "common/card/24.png",[17] = "common/card/25.png",[18] = "common/card/26.png",[19] = "common/card/27.png",[20] = "common/card/28.png",[21] = "common/card/29.png",[22] = "common/card/210.png",[23] = "common/card/211.png",[24] = "common/card/212.png",[25] = "common/card/213.png",

        [26] = "common/card/114.png",[27] = "common/card/12.png",[28] = "common/card/13.png",[29] = "common/card/14.png",[30] = "common/card/15.png",[31] = "common/card/16.png",[32] = "common/card/17.png",[33] = "common/card/18.png",[34] = "common/card/19.png",[35] = "common/card/110.png",[36] = "common/card/111.png",[37] = "common/card/112.png",[38] = "common/card/113.png",[39] = "common/card/114.png",

        [39] = "common/card/014.png",[40] = "common/card/02.png",[41] = "common/card/03.png",[42] = "common/card/04.png",[43] = "common/card/05.png",[44] = "common/card/06.png",[45] = "common/card/07.png",[46] = "common/card/08.png",[47] = "common/card/09.png",[48] = "common/card/010.png",[49] = "common/card/011.png",[50] = "common/card/012.png",[51] = "common/card/013.png",
    },
    vecResult = {
        ZHUANG = "Baccarat/image/result/dians_banker/%d.png",
        XIAN   = "Baccarat/image/result/dians_player/%d.png",
        TYPE = {
            [1] = "Baccarat/image/result/result_player.png",
            [2] = "Baccarat/image/result/result_banker.png",
            [3] = "Baccarat/image/result/result_he.png",
        },
    },

    vecReleaseSound = {
         --game sound
        "game/baccarat/sound/sound-baccarat-ping.mp3",
        "game/baccarat/sound/sound-baccarat-tianwang.mp3",
        "game/baccarat/sound/sound-baccarat-xianwin.mp3",
        "game/baccarat/sound/sound-baccarat-xpoint-0.mp3",
        "game/baccarat/sound/sound-baccarat-xpoint-1.mp3",
        "game/baccarat/sound/sound-baccarat-xpoint-2.mp3",
        "game/baccarat/sound/sound-baccarat-xpoint-3.mp3",
        "game/baccarat/sound/sound-baccarat-xpoint-4.mp3",
        "game/baccarat/sound/sound-baccarat-xpoint-5.mp3",
        "game/baccarat/sound/sound-baccarat-xpoint-6.mp3",
        "game/baccarat/sound/sound-baccarat-xpoint-7.mp3",
        "game/baccarat/sound/sound-baccarat-xpoint-8.mp3",
        "game/baccarat/sound/sound-baccarat-xpoint-9.mp3",
        "game/baccarat/sound/sound-baccarat-zhuangwin.mp3",
        "game/baccarat/sound/sound-baccarat-zpoint-0.mp3",
        "game/baccarat/sound/sound-baccarat-zpoint-1.mp3",
        "game/baccarat/sound/sound-baccarat-zpoint-2.mp3",
        "game/baccarat/sound/sound-baccarat-zpoint-3.mp3",
        "game/baccarat/sound/sound-baccarat-zpoint-4.mp3",
        "game/baccarat/sound/sound-baccarat-zpoint-5.mp3",
        "game/baccarat/sound/sound-baccarat-zpoint-6.mp3",
        "game/baccarat/sound/sound-baccarat-zpoint-7.mp3",
        "game/baccarat/sound/sound-baccarat-zpoint-8.mp3",
        "game/baccarat/sound/sound-baccarat-zpoint-9.mp3",
        "game/baccarat/sound/sound-baccarat_card.wav",
        "game/baccarat/sound/sound-bethigh.mp3",
        "game/baccarat/sound/sound-betlow.mp3",
        "game/baccarat/sound/sound-countdown.mp3",
        "game/baccarat/sound/sound-end-wager.mp3",
        "game/baccarat/sound/sound-get-gold.mp3",
        "game/baccarat/sound/sound-jetton.mp3",
        "game/baccarat/sound/sound-lose-big-1.mp3",
        "game/baccarat/sound/sound-lose-big-2.mp3",
        "game/baccarat/sound/sound-lose-big-3.mp3",
        "game/baccarat/sound/sound-lose-big-4.mp3",
        "game/baccarat/sound/sound-lose-middle-1.mp3",
        "game/baccarat/sound/sound-lose-middle-2.mp3",
        "game/baccarat/sound/sound-lose-small-1.mp3",
        "game/baccarat/sound/sound-lose-small-2.mp3",
        "game/baccarat/sound/sound-result-lose.mp3",
        "game/baccarat/sound/sound-result-nobet.mp3",
        "game/baccarat/sound/sound-result-win.mp3",
        "game/baccarat/sound/sound-start-wager.mp3",
        "game/baccarat/sound/sound-win-big-1.mp3",
        "game/baccarat/sound/sound-win-big-2.mp3",
        "game/baccarat/sound/sound-win-middle-1.mp3",
        "game/baccarat/sound/sound-win-middle-2.mp3",
        "game/baccarat/sound/sound-win-small-1.mp3",
        "game/baccarat/sound/sound-win-small-2.mp3",
        "game/baccarat/sound/zhuang-1.mp3",
        "game/baccarat/sound/zhuang-2.mp3",
    },
}

BaccaratRes.vecLoadingPlist = BaccaratRes.vecReleasePlist
BaccaratRes.vecLoadingImg   = BaccaratRes.vecReleaseImg
BaccaratRes.vecLoadingAnim  = BaccaratRes.vecReleaseAnim

BaccaratRes.vecLoadingSound = {
         --game sound
        "game/baccarat/sound/sound-baccarat-ping.mp3",
        "game/baccarat/sound/sound-baccarat-tianwang.mp3",
        "game/baccarat/sound/sound-baccarat-xianwin.mp3",
        "game/baccarat/sound/sound-baccarat-zhuangwin.mp3",
        "game/baccarat/sound/sound-baccarat_card.wav",
        "game/baccarat/sound/sound-bethigh.mp3",
        "game/baccarat/sound/sound-betlow.mp3",
        "game/baccarat/sound/sound-countdown.mp3",
        "game/baccarat/sound/sound-end-wager.mp3",
        "game/baccarat/sound/sound-get-gold.mp3",
        "game/baccarat/sound/sound-jetton.mp3",
        "game/baccarat/sound/sound-result-lose.mp3",
        "game/baccarat/sound/sound-result-nobet.mp3",
        "game/baccarat/sound/sound-result-win.mp3",
        "game/baccarat/sound/sound-start-wager.mp3",
}

BaccaratRes.vecLoadingMusic = {
    "game/baccarat/sound/sound-happy-bg.mp3",
}

return BaccaratRes
--endregion
