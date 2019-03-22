--region FishRes.lua
--Date 2017-08-14
--Author JackyXu
--Desc 金蝉捕鱼路径定义

local resPathBase = "game/frogfish/" -- 资源文件基础文件夹路径，避免拷贝文件导致路径错误
local FishRes = 
{
    vecReleaseAnim = {
        --炮
        resPathBase .. "effect/pao1_buyu/pao1_buyu.ExportJson",
        resPathBase .. "effect/pao2_buyu/pao2_buyu.ExportJson",
        --炮buff
        resPathBase .. "effect/pao1buff_buyu/pao1buff_buyu.ExportJson",
        resPathBase .. "effect/pao2buff_buyu/pao2buff_buyu.ExportJson",
        --buff捕鱼
        resPathBase .. "effect/buff_buyu/buff_buyu.ExportJson",
        --海浪
        resPathBase .. "effect/hailang_buyu/hailang_buyu.ExportJson",
        --睡眠
        resPathBase .. "effect/zzz-dingpao_buyu/zzz-dingpao_buyu.ExportJson",
        --气泡
        resPathBase .. "effect/qipao_buyu/qipao_buyu.ExportJson",
        --闪电特效
        resPathBase .. "effect/shandianpao1_buyu/shandianpao1_buyu.ExportJson",
        resPathBase .. "effect/shandianpao2_buyu/shandianpao2_buyu.ExportJson",
        resPathBase .. "effect/shandianpao3_buyu/shandianpao3_buyu.ExportJson",
        --特殊鱼种
        resPathBase .. "effect/teshuyuzhong_buyu/teshuyuzhong_buyu.ExportJson",
        --连锁闪电
        resPathBase .. "effect/liansuoshandian_buyu/liansuoshandian_buyu.ExportJson",
        --连锁闪电文字
        resPathBase .. "effect/liansuoshandianwenzidonghua_buyu/liansuoshandianwenzidonghua_buyu.ExportJson",
        --锁定捕鱼
        resPathBase .. "effect/suoding_buyu/suoding_buyu.ExportJson",
        --炮台切换
        resPathBase .. "effect/paotaiqiehuan_buyu/paotaiqiehuan_buyu.ExportJson",
        --入场提醒
        resPathBase .. "effect/ruchangtixing_likpiyu/ruchangtixing_likpiyu.ExportJson",
        --鱼
        resPathBase .. "effect/animals/yu0_buyu/yu0_buyu.ExportJson",
        resPathBase .. "effect/animals/yu1_buyu/yu1_buyu.ExportJson",
        resPathBase .. "effect/animals/yu2_buyu/yu2_buyu.ExportJson",
        resPathBase .. "effect/animals/yu3_buyu/yu3_buyu.ExportJson",
        resPathBase .. "effect/animals/yu4_buyu/yu4_buyu.ExportJson",
        resPathBase .. "effect/animals/yu5_buyu/yu5_buyu.ExportJson",
        resPathBase .. "effect/animals/yu6_buyu/yu6_buyu.ExportJson",
        resPathBase .. "effect/animals/yu7_buyu/yu7_buyu.ExportJson",
        resPathBase .. "effect/animals/yu8_buyu/yu8_buyu.ExportJson",
        resPathBase .. "effect/animals/yu9_buyu/yu9_buyu.ExportJson",
        resPathBase .. "effect/animals/yu10_buyu/yu10_buyu.ExportJson",
        resPathBase .. "effect/animals/yu11_buyu/yu11_buyu.ExportJson",
        resPathBase .. "effect/animals/yu12_buyu/yu12_buyu.ExportJson",
        resPathBase .. "effect/animals/yu13_buyu/yu13_buyu.ExportJson",
        resPathBase .. "effect/animals/yu14_buyu/yu14_buyu.ExportJson",
        resPathBase .. "effect/animals/yu15_buyu/yu15_buyu.ExportJson",
        resPathBase .. "effect/animals/yu16_buyu/yu16_buyu.ExportJson",
        resPathBase .. "effect/animals/yu17_buyu/yu17_buyu.ExportJson",
        resPathBase .. "effect/animals/yu18_buyu/yu18_buyu.ExportJson",
        resPathBase .. "effect/animals/yu19_buyu/yu19_buyu.ExportJson",
        resPathBase .. "effect/animals/yu20_buyu/yu20_buyu.ExportJson",
        resPathBase .. "effect/animals/yu21_buyu/yu21_buyu.ExportJson",
        resPathBase .. "effect/animals/yu22_buyu/yu22_buyu.ExportJson",
        resPathBase .. "effect/animals/yu23_buyu/yu23_buyu.ExportJson",
        resPathBase .. "effect/animals/yu24_buyu/yu24_buyu.ExportJson",
        resPathBase .. "effect/animals/yu25_buyu/yu25_buyu.ExportJson",
        resPathBase .. "effect/animals/yu26_buyu/yu26_buyu.ExportJson",
        resPathBase .. "effect/animals/yu27_buyu/yu27_buyu.ExportJson",
        resPathBase .. "effect/animals/goldfrog/goldfrog.ExportJson",
        --炼丹炉动画
        resPathBase .. "effect/bombeffect/ding_buyu/ding_buyu.ExportJson",
        resPathBase .. "effect/bombeffect/ruyijingubangdonghua_buyu/ruyijingubangdonghua_buyu.ExportJson",
        resPathBase .. "effect/bombeffect/wudifenghuolun_buyu/wudifenghuolun_buyu.ExportJson",
        resPathBase .. "effect/bombeffect/zhengyaotadonghua_buyu/zhengyaotadonghua_buyu.ExportJson",
        --特殊鱼动画
        resPathBase .. "effect/specialfish/danaotiankongyuanpan_buyu/danaotiankongyuanpan_buyu.ExportJson",
        resPathBase .. "effect/specialfish/yijianshuangdiao_buyu/yijianshuangdiao_buyu.ExportJson",
        resPathBase .. "effect/specialfish/yishisanniao_buyu/yishisanniao_buyu.ExportJson",
        resPathBase .. "effect/specialfish/jinyumantang_buyu/jinyumantang_nuyu.ExportJson",
        --捕鱼动画
        resPathBase .. "effect/dieeffect/fish_effect_bomb_big_02/fish_effect_bomb_big_02.ExportJson",
        resPathBase .. "effect/dieeffect/fish_effect_bomb_big_03/fish_effect_bomb_big_03.ExportJson",
        --金币特效
        resPathBase .. "effect/jinbitexiao_jinchanbuyu/jinbitexiao_jinchanbuyu.ExportJson",
        --击杀大鱼转盘效果
        resPathBase .. "effect/bingo/bingo.ExportJson",
        --击杀boss效果
        resPathBase .. "effect/bingo-boss/bingo-boss.ExportJson",
        --击杀炸弹的结算动画，大于等于100倍
        resPathBase .. "effect/baofuliAnimation/baofuliAnimation.ExportJson",
        --击杀炸弹的结算动画，小于100倍
        resPathBase .. "effect/jishamoshi_Animation/jishamoshi_Animation.ExportJson",
    },

    vecReleasePlist = {
        {resPathBase .. "gui/gui-fish.plist", resPathBase .. "gui/gui-fish.png", },
        {resPathBase .. "gui/gui-setting.plist", resPathBase .. "gui/gui-setting.png", },
    },

    vecReleaseImg = {
        resPathBase .. "gui/BG1.jpg",
        resPathBase .. "gui/BG2.jpg",
        resPathBase .. "gui/BG3.jpg",
    },

    vecReleaseSound = {
        resPathBase .. "sound/fish-fire.mp3",
        resPathBase .. "sound/fish-gold.mp3",

        resPathBase .. "sound/bingo.mp3",
        resPathBase .. "sound/fish6_1.mp3",
        resPathBase .. "sound/fish9_1.mp3",
        resPathBase .. "sound/fish12_1.mp3",
        resPathBase .. "sound/fish14_1.mp3",
        resPathBase .. "sound/fish15_1.mp3",
        resPathBase .. "sound/fish16_1.mp3",
        resPathBase .. "sound/fish18_1.mp3",
        resPathBase .. "sound/fish19_1.mp3",
        resPathBase .. "sound/fish20_1.mp3",
        resPathBase .. "sound/fish22_1.mp3",
        resPathBase .. "sound/fish23_1.mp3",
        resPathBase .. "sound/fish24_1.mp3",
        resPathBase .. "sound/fish25_1.mp3",
        resPathBase .. "sound/fish26_1.mp3",
        resPathBase .. "sound/fish28_1.mp3",
        resPathBase .. "sound/fish29_1.mp3",
        resPathBase .. "sound/fish30_1.mp3",
        resPathBase .. "sound/fish31_1.mp3",
        resPathBase .. "sound/fish32_1.mp3",
        resPathBase .. "sound/fish-click-screen.mp3",
        resPathBase .. "sound/fish-fire-buff.mp3",
        resPathBase .. "sound/fish-kill-big.mp3",
        resPathBase .. "sound/fish-kill-small.mp3",
        resPathBase .. "sound/fish-qipao.mp3",
        resPathBase .. "sound/fish-selected.mp3",
        resPathBase .. "sound/fish-shandian.mp3",
        resPathBase .. "sound/fish-tx-dinhaishenzhen.mp3",
        resPathBase .. "sound/fish-tx-wudifenghuolun.mp3",
        resPathBase .. "sound/fish-tx-zhengyaojingangta.mp3",
    },

    vecReleaseMusic = {
        resPathBase .. "sound/fish-bg-01.mp3",
        resPathBase .. "sound/fish-bg-02.mp3",
        resPathBase .. "sound/fish-bg-03.mp3",
    },

    ---------------------------------------------------

    --ccbi
    CCBI_OF_RULE = resPathBase .. "ccbi/gui-fish-rule.ccbi",
    CCIB_OF_LOAD = resPathBase .. "ccbi/gui-fish-loading.ccbi",
    CCBI_OF_PAO  = resPathBase .. "ccbi/gui-fish-pao.ccbi",
    CCBI_OF_MAIN = resPathBase .. "ccbi/gui-fish-main.ccbi",

    --plist
    PLIST_OF_LOADING     = resPathBase .. "gui/gui-fish-loading.plist",
    PLIST_OF_LOADING_PNG = resPathBase .. "gui/gui-fish-loading.png",
    PLIST_OF_FISH        = resPathBase .. "gui/gui-fish.plist",
    PLIST_OF_FISH_PNG    = resPathBase .. "gui/gui-fish.png",

    --animation
    EFFECT_OF_LOADING = resPathBase .. "effect/frog/frog.ExportJson",

    --png
    PNG_OF_RULE = resPathBase .. "gui/gui-fish-rule%d.png",
    PNG_OF_BG = {
        resPathBase .. "gui/BG1.jpg",
        resPathBase .. "gui/BG2.jpg",
        resPathBase .. "gui/BG3.jpg",
        resPathBase .. "gui/BG1.jpg",
        resPathBase .. "gui/BG2.jpg",
        resPathBase .. "gui/BG3.jpg",
        resPathBase .. "gui/BG1.jpg",
        resPathBase .. "gui/BG2.jpg",
    },

    --particle
    PARTICLE_OF_HAILANG     = resPathBase .. "particle/hailang_1.plist", --海浪
    PARTICLE_OF_BAOZHA_1    = resPathBase .. "particle/dingpaobaozha_1.plist",
    PARTICLE_OF_BAOZHA_2    = resPathBase .. "particle/dingpaobaozha_2.plist",
    PARTICLE_OF_DAYUJISHA   = resPathBase .. "particle/dayujisha1.plist", --大鱼击杀
    PARTICLE_OF_JIBITUOWEI  = resPathBase .. "particle/jibituowei.plist", --
    PARTICLE_OF_WDFHLBAOZHA = resPathBase .. "particle/wudifenghuolunbaozha_1_0.plist",--无敌风火轮爆炸
    --font
    FONT_OF_SUZI_PAO           = resPathBase .. "font/gui-common-suzi-orange-211.fnt",
    FONT_OF_SUZI_NUMBER        = resPathBase .. "font/numb.fnt",
    FONT_OF_SUZI_NUMBER_SILVER = resPathBase .. "font/numsilver.fnt",
    FONT_OF_SUZI_NUMBER_SCORE  = resPathBase .. "font/number-gold.fnt",
    FONT_OF_SUZI_NUMBER_1      = resPathBase .. "font/gui-fish1-jsdy-number1.fnt",

    --system mp3
    SOUND_OF_CLOSE  = "public/sound/sound-close.mp3",
    SOUND_OF_BUTTON = "public/sound/sound-button.mp3",

    --game mp3
    SOUND_OF_GOLD       = resPathBase .. "sound/fish-gold.mp3", --金币
    SOUND_OF_QIPAO      = resPathBase .. "sound/fish-qipao.mp3", --气泡
    SOUND_OF_SCREEN     = resPathBase .. "sound/fish-click-screen.mp3", --震屏
    SOUND_OF_KILL_SMALL = resPathBase .. "sound/fish-kill-small.mp3", --击杀小鱼
    SOUND_OF_KILL_BIG   = resPathBase .. "sound/fish-kill-big.mp3", --击杀大鱼
    SOUND_OF_SHANDIAN   = resPathBase .. "sound/fish-shandian.mp3", --闪电
    SOUND_OF_BIG_BOMB   = resPathBase .. "sound/quanpingzhadan.mp3", --全屏炸弹

    SOUND_OF_FISH = {
        [6] = resPathBase .. "sound/fish6_1.mp3",
        [9] = resPathBase .. "sound/fish9_1.mp3",
        [12] = resPathBase .. "sound/fish12_1.mp3",
        [14] = resPathBase .. "sound/fish14_1.mp3",
        [15] = resPathBase .. "sound/fish15_1.mp3",
        [16] = resPathBase .. "sound/fish16_1.mp3",
        [18] = resPathBase .. "sound/fish18_1.mp3",
        [19] = resPathBase .. "sound/fish19_1.mp3",
        [20] = resPathBase .. "sound/fish20_1.mp3",
        [22] = resPathBase .. "sound/fish22_1.mp3",
        [23] = resPathBase .. "sound/fish23_1.mp3",
        [24] = resPathBase .. "sound/fish24_1.mp3",
        [25] = resPathBase .. "sound/fish25_1.mp3",
        [26] = resPathBase .. "sound/fish26_1.mp3",
        [28] = resPathBase .. "sound/fish28_1.mp3",
        [29] = resPathBase .. "sound/fish29_1.mp3",
        [30] = resPathBase .. "sound/fish30_1.mp3",
        [31] = resPathBase .. "sound/fish31_1.mp3",
        [32] = resPathBase .. "sound/fish32_1.mp3",
    },
    SOUND_OF_BG = {
        [1] = resPathBase .. "sound/fish-bg-01.mp3",
        [2] = resPathBase .. "sound/fish-bg-02.mp3",
        [3] = resPathBase .. "sound/fish-bg-03.mp3",
    },
    SOUND_OF_ZHENGYAOJINGANGTA = resPathBase .. "sound/fish-tx-zhengyaojingangta.mp3",--镇妖塔(全局定)
    SOUND_OF_WUDIFENGHUOLUN    = resPathBase .. "sound/fish-tx-wudifenghuolun.mp3",--无敌风火轮(局部炸弹)
    SOUND_OF_RUYIJINGUBANG     = resPathBase .. "sound/fish-tx-dinhaishenzhen.mp3",--如意金箍棒(局部炸弹)
    SOUND_OF_FIRE_BUFF = resPathBase .. "sound/fish-fire-buff.mp3", --开炮音效
    SOUND_OF_FIRE = resPathBase .. "sound/fish-fire.mp3",--开炮音效
    SOUND_OF_BINGO = resPathBase .. "sound/bingo.mp3", --bingo

    FILE_OF_SCENE = resPathBase .. "Scene/Scene%d.json",
    FILE_OF_TRACE = resPathBase .. "Path/%d.dat",

    FISH_PATH = resPathBase .. "allPath/allcurve%d.dat", --新路径
    --FISH_COPY_PATH = "frogfish_allcurve_%d.dat", --新路径(android)
    FISH_COPY_PATH = "frogfish_newCurve_%d.dat", --新路径(android)
}

return FishRes

--endregion
