--region *.lua
--Date 2016-9-1
--Author xufei
--Desc 
--此文件由[BabeLua]插件自动生成

local AnimalSceneRes = 
{
    Background      = "",

    RetBtn          = "game/animals/animal_btn_back.png",

    vecReleaseAnim = {  -- 退出时需要释放的动画资源
        "game/animals/animation/feiqinzoushou_jinshax100/feiqinzoushou_jinshax100",
        "game/animals/animation/feiqinzoushou_shayu25/feiqinzoushou_shayu25",
        "game/animals/animation/feiqinzoushou_tongchi/feiqinzoushou_tongchi",
        "game/animals/animation/feiqinzoushou_tongpei/feiqinzoushou_tongpei",
        "game/animals/animation/naozhong_2/naozhong_2",
        "game/animals/animation/bairenniuniu_dengdaikaiju/bairenniuniu_dengdaikaiju",
        "game/animals/animation/daojishi_1/daojishi_1",
        --"game/animals/animation/feiqinzoushou_kaijiang/feiqinzoushou_kaijiang",
        "game/animals/animation/feiqinzoushou_changjingtexiao/feiqinzoushou_changjingtexiao",
        "game/animals/animation/feiqinzoushou_touzhong/feiqinzoushou_touzhong",
        "game/animals/animation/feiqinzoushou_xuanzhong/feiqinzoushou_xuanzhong",
        "game/animals/animation/feiqinzoushou_jiesuandongwu/feiqinzoushou_jiesuandongwu",
        "game/animals/animation/kaishixiazhu_kaijiang/kaishixiazhu_kaijiang",
        --"game/animals/animation/countnum_background/countnum_background",
    },

    vecReleasePlist = {
        "game/animals/plist/animal",
        "game/animals/plist/new-game-jetton",
    },

    vecReleaseImg = {
        "fqzs_bk.png",
        "loading.png",
    },

    vecReleaseSound = {},
}

AnimalSceneRes.vecLoadingPlist = {
    {"game/animals/plist/animal.plist", "game/animals/plist/animal.png", },
    {"game/animals/plist/new-game-jetton.plist", "game/animals/plist/new-game-jetton.png", },
}

AnimalSceneRes.vecLoadingImage = {
    "fqzs_bk.png",
    "loading.png",
}

AnimalSceneRes.vecLoadingAnim = {
    "game/animals/animation/feiqinzoushou_jinshax100/feiqinzoushou_jinshax100.ExportJson",
    "game/animals/animation/feiqinzoushou_shayu25/feiqinzoushou_shayu25.ExportJson",
    "game/animals/animation/feiqinzoushou_tongchi/feiqinzoushou_tongchi.ExportJson",
    "game/animals/animation/feiqinzoushou_tongpei/feiqinzoushou_tongpei.ExportJson",
    "game/animals/animation/naozhong_2/naozhong_2.ExportJson",
    "game/animals/animation/bairenniuniu_dengdaikaiju/bairenniuniu_dengdaikaiju.ExportJson",
    "game/animals/animation/daojishi_1/daojishi_1.ExportJson",
    --"game/animals/animation/feiqinzoushou_kaijiang/feiqinzoushou_kaijiang.ExportJson",
    "game/animals/animation/feiqinzoushou_changjingtexiao/feiqinzoushou_changjingtexiao.ExportJson",
    "game/animals/animation/feiqinzoushou_touzhong/feiqinzoushou_touzhong.ExportJson",
    "game/animals/animation/feiqinzoushou_xuanzhong/feiqinzoushou_xuanzhong.ExportJson",
    "game/animals/animation/feiqinzoushou_jiesuandongwu/feiqinzoushou_jiesuandongwu.ExportJson",
    "game/animals/animation/kaishixiazhu_kaijiang/kaishixiazhu_kaijiang.ExportJson",
    --"game/animals/animation/countnum_background/countnum_background.ExportJson",
}
AnimalSceneRes.vecLoadingSound = {
    "game/animals/soundpublic/sound-bethigh.mp3",
    "game/animals/soundpublic/sound-betlow.mp3",
    "game/animals/soundpublic/sound-button.mp3",
    "game/animals/soundpublic/sound-clear.mp3",
    "game/animals/soundpublic/sound-close.mp3",
    "game/animals/soundpublic/sound-count-down.mp3",
    "game/animals/soundpublic/sound-countdown.mp3",
    "game/animals/soundpublic/sound-end-wager.mp3",
    "game/animals/soundpublic/sound-get-gold.mp3",
    "game/animals/soundpublic/sound-gold.wav",
    "game/animals/soundpublic/sound-jetton.mp3",
    "game/animals/soundpublic/sound-lose.mp3",
    "game/animals/soundpublic/sound-start-wager.mp3",
    "game/animals/soundpublic/sound-countdown.mp3",
    "game/animals/sound/sound-fly-turn.mp3",
}
AnimalSceneRes.vecLoadingMusic = {
    "game/animals/sound/sound-fly-bg.mp3",   --15:背景音乐
}

AnimalSceneRes.vecReleaseSound = {
    "game/animals/soundpublic/sound-bethigh.mp3",
    "game/animals/soundpublic/sound-betlow.mp3",
    "game/animals/soundpublic/sound-button.mp3",
    "game/animals/soundpublic/sound-clear.mp3",
    "game/animals/soundpublic/sound-close.mp3",
    "game/animals/soundpublic/sound-count-down.mp3",
    "game/animals/soundpublic/sound-countdown.mp3",
    "game/animals/soundpublic/sound-end-wager.mp3",
    "game/animals/soundpublic/sound-get-gold.mp3",
    "game/animals/soundpublic/sound-gold.wav",
    "game/animals/soundpublic/sound-jetton.mp3",
    "game/animals/soundpublic/sound-lose-big-1.mp3",
    "game/animals/soundpublic/sound-lose-big-2.mp3",
    "game/animals/soundpublic/sound-lose-big-3.mp3",
    "game/animals/soundpublic/sound-lose-big-4.mp3",
    "game/animals/soundpublic/sound-lose-middle-1.mp3",
    "game/animals/soundpublic/sound-lose-middle-2.mp3",
    "game/animals/soundpublic/sound-lose-small-1.mp3",
    "game/animals/soundpublic/sound-lose-small-2.mp3",
    "game/animals/soundpublic/sound-lose.mp3",
    "game/animals/soundpublic/sound-start-wager.mp3",
    "game/animals/soundpublic/sound-win-big-1.mp3",
    "game/animals/soundpublic/sound-win-big-2.mp3",
    "game/animals/soundpublic/sound-win-middle-1.mp3",
    "game/animals/soundpublic/sound-win-middle-2.mp3",
    "game/animals/soundpublic/sound-win-small-1.mp3",
    "game/animals/soundpublic/sound-win-small-2.mp3",
    "game/animals/soundpublic/zhuang-1.mp3",
    "game/animals/soundpublic/zhuang-2.mp3",
    
    "game/animals/sound/sound-fly-0.mp3",
    "game/animals/sound/sound-fly-1.mp3",
    "game/animals/sound/sound-fly-10.mp3",
    "game/animals/sound/sound-fly-11.mp3",
    "game/animals/sound/sound-fly-2.mp3",
    "game/animals/sound/sound-fly-3.mp3",
    "game/animals/sound/sound-fly-4.mp3",
    "game/animals/sound/sound-fly-5.mp3",
    "game/animals/sound/sound-fly-6.mp3",
    "game/animals/sound/sound-fly-7.mp3",
    "game/animals/sound/sound-fly-8.mp3",
    "game/animals/sound/sound-fly-9.mp3",
    "game/animals/sound/sound-fly-turn.mp3",
}

return AnimalSceneRes
--endregion
