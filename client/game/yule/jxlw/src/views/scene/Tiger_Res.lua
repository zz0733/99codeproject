--region Tiger_Res.lua
--Date 2017.11.10
--Author JackyXu
--Desc 水果老虎机资源定义
local module_pre = "game.yule.jxlw.src.views"

local TigerConst     = require(module_pre..".scene.Tiger_Const")

local Tiger_Res = {} --所有资源

--csb
Tiger_Res.CSB_OF_MAINSCENE  = "fruitSuper/Fruit_Main.csb"
Tiger_Res.CSB_OF_RULE       = "game/tiger/layer/TigerRule.csb"
Tiger_Res.CSB_OF_LOADING    = "game/tiger/layer/TigerLoadingLayer.csb"

Tiger_Res.TIGER_MAIN_BG     = "game/tiger/gui/gui-tiger-bg.png"
Tiger_Res.TIGER_BTN_NORMAL  = "gui_tiger_btn_normal1.png"
Tiger_Res.TIGER_BTN_PRESS   = "gui_tiger_btn_press1.png"
Tiger_Res.TIGER_BTN_DISABLE = "gui_tiger_btn_disable1.png"

--animation
Tiger_Res.strAnimPath = "game/tiger/effect/"
Tiger_Res.vecAnim = {
    ["YOU_WIN"]             = "laohujijinbidonghua",        -- /你赢了
    ["BIG_WIN"]             = "laohujiAnimation",           -- /你赢了
    ["GAMEOVER_BOX"]        = "baoxiangjiesuan_laohuji",    -- /结算宝箱
    ["GAMEOVER_777"]        = "777jiesuan_laohuji",         -- /结算777
    ["GAMEOVER_SPICAIL"]    = "teshujiangli_laohujin",      -- /特殊结算
}

Tiger_Res.SPINE_OF_BG       = "jiuxianlawang4_beijing/jiuxianlawang4_beijing"

-- 特殊物品动画 anim name
Tiger_Res.vecSpicalGiftAnim = {
    [TigerConst.eResultType.Type_BAR]       = "bar",         -- bar
    [TigerConst.eResultType.Type_Diamond]   = "zhuanshi",    -- 钻石
    [TigerConst.eResultType.Type_Gold]      = "baoxiang",    -- 宝箱
    [TigerConst.eResultType.Type_777]       = "777",         -- 777
    [TigerConst.eResultType.Type_Bell]      = "lingdang",    -- 铃铛
}

-- 转奖框水果闪烁动画 anim name
Tiger_Res.vecFrameBlinkAnim = {
    [TigerConst.eResultType.Type_Litchi]     = "Animation3",    --荔枝
    [TigerConst.eResultType.Type_Orange]     = "Animation2",    --橘子
    [TigerConst.eResultType.Type_Mango]      = "Animation4",    --芒果
    [TigerConst.eResultType.Type_Watermelon] = "Animation8",    --西瓜
    [TigerConst.eResultType.Type_Apple]      = "Animation5",    --苹果
    [TigerConst.eResultType.Type_Cherry]     = "Animation9",    --樱桃
    [TigerConst.eResultType.Type_Grape]      = "Animation6",    --葡萄
    [TigerConst.eResultType.Type_Banana]     = "Animation7",    --香蕉
    [TigerConst.eResultType.Type_Pineapple]  = "Animation1",    --菠萝
}

-- 转奖框水果闪烁动画 anim name
Tiger_Res.vecFruitAnim = {
    {"lizhi/lizhi.json", "lizhi/lizhi.atlas"},                  --荔枝
    {"chengzi/chengzi.json", "chengzi/chengzi.atlas"},          --橘子
    {"mangguo/mangguo.json", "mangguo/mangguo.atlas"},          --芒果
    {"xigua/xigua.json", "xigua/xigua.atlas"},                  --西瓜
    {"pingguo/pingguo.json", "pingguo/pingguo.atlas"},          --苹果
    {"yingtao/yingtao.json", "yingtao/yingtao.atlas"},          --樱桃
    {"putao/putao.json", "putao/putao.atlas"},                  --葡萄
    {"lingdang/lingdang.json", "lingdang/lingdang.atlas"},      --铃铛
    {"xiangjiao/xiangjiao.json", "xiangjiao/xiangjiao.atlas"},  --香蕉
    {"boluo/boluo.json", "boluo/boluo.atlas"},                  --菠萝
    {"bar/bar.json", "bar/bar.atlas"},                          --BAR
    {"zhuanshi/zhuanshi.json", "zhuanshi/zhuanshi.atlas"},      --钻石
    {"baoxiang/baoxiang.json", "baoxiang/baoxiang.atlas"},      --宝箱
    {"777/777.json", "777/777.atlas"},                          --777
}

-- 777 / 宝箱结算动画 anim name
Tiger_Res.vec777BoxAnim = {
    ["MAIN_SCENE"]  = "Animation1",     -- 动画主场景
    ["RUN_ROUND"]   = "Animation3",     -- 转盘循环动画
    ["RUN_NUMBER"]  = "Animation2",     -- 转盘替换数字动画
}
Tiger_Res.str777BoxReplaceNode = "Layer1" -- 转盘数字替换节点

--plist
Tiger_Res.vecPlist = {
    {"game/tiger/plist/TigerPlist.plist",     "game/tiger/plist/TigerPlist.png", },
    {"game/tiger/plist/TigerIconPlist.plist", "game/tiger/plist/TigerIconPlist.png", },
}

--release image.
Tiger_Res.vecReleaseImg = {
    "game/tiger/gui/gui-tiger-bg.png",
    "game/tiger/gui/gui-tiger-loading-bg.png",
    "game/tiger/gui/gui-tiger-loading-icon.png",
    "game/tiger/gui/gui-tiger-rule-bg.png",
    "game/tiger/gui/gui-tiger-rule-content-1.png",
    "game/tiger/gui/gui-tiger-rule-content-2.png",
}

-- FMT
Tiger_Res.FMT_NODE_NUM_IMG      = "Img_num%d"     -- 线编号
Tiger_Res.FMT_NUM_RESULT_IMG    = "game/tiger/gui/gui-tiger-result-num-%d.png" -- 结算动画数字
Tiger_Res.FMT_LINE_IMG          = "game/tiger/gui/gui-tiger-line-%d.png"
Tiger_Res.FMT_NUM_LIGHT_IMG     = "game/tiger/gui/gui-tiger-num-%d.png"     -- light
Tiger_Res.FMT_NUM_GRAY_IMG      = "game/tiger/gui/gui-tiger-num-%d-1.png"   -- gray.
Tiger_Res.PNG_OF_HEAD           = "hall/image/file/gui-icon-head-%02d.png"--头像
Tiger_Res.PNG_OF_FMT_ICON       = "fruitSuper/image/icon/fruitV3Item-%d.png"   -- 图标 FMT.
Tiger_Res.PNG_OF_FMT_MIX_ICON   = "fruitSuper/image/icon/fruitV3Item-%d.png"    -- 转动图标 FMT.
Tiger_Res.PNG_OF_FMT_NUM_ICON   = "game/tiger/gui/gui-tiger-joke-num-%d.png"    -- 彩金滚动数字 FMT.
Tiger_Res.PNG_OF_NULL_ICON      = "game/tiger/gui/gui-tiger-texture-null.png"   -- 彩金滚动空图片


-- font
Tiger_Res.FONT_WHITE         = "game/tiger/font/llj_sz1.fnt"
Tiger_Res.FONT_PURPLE        = "game/tiger/font/llj_sz2.fnt"
Tiger_Res.FONT_YELLOW        = "game/tiger/font/llj_sz3.fnt"
Tiger_Res.FONT_GREEN         = "game/tiger/font/llj_sz4.fnt"
Tiger_Res.FONT_ROOM          = "game/tiger/font/jxlw_fc.fnt"

Tiger_Res.FONT_GOLDEN   = "game/tiger/font/numberbigwin.fnt"
--Tiger_Res.FONT_GOLDEN        = "game/tiger/font/jiesuan.fnt"
Tiger_Res.FONT_LINE_NORMAL   = "game/tiger/font/jxlw_xs.fnt"
Tiger_Res.FONT_LINE_DISABLE  = "game/tiger/font/jxlw_xsh.fnt"
Tiger_Res.FONT_DIZHU_NORMAL  = "game/tiger/font/dizhu_lan.fnt"
Tiger_Res.FONT_DIZHU_DISABLE = "game/tiger/font/dizhu_lanh.fnt"


-- loadingBG
Tiger_Res.PNG_OF_LOADING_BG = "game/tiger/gui/gui-tiger-loading-bg.jpg"
-- loading icon
Tiger_Res.PNG_OF_LOADING_ICON = "game/tiger/gui/gui-tiger-loading-icon.png"
--animation
Tiger_Res.JSON_OF_LOADING = "public/effect/lading/lading.ExportJson" --加载
--Tiger_Res.JSON_OF_CHAT_NOTICE = "image/effect/common/liaotiantixing_shoujiban/liaotiantixing_shoujiban.ExportJson" --新消息
--effect
Tiger_Res.ANI_OF_LAODING = "lading" --加载
Tiger_Res.ANI_OF_CHAT_NOTICE = "liaotiantixing_shoujiban" -- 聊天新消息提示动画

--image
Tiger_Res.PNG_OF_MUSIC_ON          = "game/tiger/gui/gui-tiger-btn-music-on.png"--音乐开
Tiger_Res.PNG_OF_MUSIC_OFF         = "game/tiger/gui/gui-tiger-btn-music-off.png"--音乐关
Tiger_Res.PNG_OF_SOUND_ON          = "game/tiger/gui/gui-tiger-btn-effect-on.png"--声音开
Tiger_Res.PNG_OF_SOUND_OFF         = "game/tiger/gui/gui-tiger-btn-effect-off.png"--声音关
Tiger_Res.PNG_OF_START_NOMAL       = "game/tiger/gui/gui-tiger-btn-start-1.png" -- 开始按纽常规状态
Tiger_Res.PNG_OF_START_NOMAL_PRESS = "game/tiger/gui/gui-tiger-btn-start-2.png" -- 开始按纽按下状态
--Tiger_Res.PNG_OF_START_NOMAL_DIS   = "game/tiger/gui/gui-tiger-btn-start-3.png" -- 开始按纽禁用状态
Tiger_Res.PNG_OF_START_AUTO        = "game/tiger/gui/gui-tiger-btn-start-4.png" -- 自动按纽常规状态
Tiger_Res.PNG_OF_START_AUTO_PRESS  = "game/tiger/gui/gui-tiger-btn-start-5.png" -- 自动按纽按下状态
--Tiger_Res.PNG_OF_START_AUTO_DIS    = "game/tiger/gui/gui-tiger-btn-start-6.png" -- 自动按纽按下状态

Tiger_Res.PNG_OF_BET_NOMAL        = "game/tiger/gui/gui-tiger-btn-baseScore-normal.png" -- 底注按钮常规状态
Tiger_Res.PNG_OF_BET_PRESS        = "game/tiger/gui/gui-tiger-btn-baseScore-pressed.png" -- 底注按钮按下状态
Tiger_Res.PNG_OF_BET_DISABLE      = "game/tiger/gui/gui-tiger-btn-baseScore-disable.png" -- 底注按钮禁用状态

Tiger_Res.PNG_OF_LINE_NORMAL      = "game/tiger/gui/gui-tiger-line-text.png" -- 线数图片普通状态
Tiger_Res.PNG_OF_LINE_DISABLE     = "game/tiger/gui/gui-tiger-line-text2.png" -- 线数图片禁用状态

Tiger_Res.PNG_OF_INTRODUCE_NORMAL  = "game/tiger/gui/gui-tiger-introduce-btn-nomal.png" -- 帮助页面游戏介绍按纽放开
Tiger_Res.PNG_OF_INTRODUCE_PRESS   = "game/tiger/gui/gui-tiger-introduce-btn-press.png" -- 帮助页面游戏介绍按纽选中
Tiger_Res.PNG_OF_RULE_NORMAL       = "game/tiger/gui/gui-tiger-rule-btn-nomal.png" -- 帮助页面游戏规则按纽放开
Tiger_Res.PNG_OF_RULE_PRESS        = "game/tiger/gui/gui-tiger-rule-btn-press.png" -- 帮助页面游戏规则按纽选中
Tiger_Res.PNG_OF_TXT_INTRODUCE     = "game/tiger/gui/gui-tiger-rule-content-1.png" -- 帮助页面游戏介绍图片
Tiger_Res.PNG_OF_TXT_RULE          = "game/tiger/gui/gui-tiger-rule-content-2.png" -- 帮助页面游戏规则图片
Tiger_Res.PNG_OF_MULTIPLE          = "game/tiger/gui/gui-tiger-lb-multiple.png"    -- 倍率
Tiger_Res.PNG_NUM_POINT_IMG        = "game/tiger/gui/gui-tiger-result-num-point.png" -- 结算动画小数点

--system sound
Tiger_Res.SOUND_OF_BUTTON   = "sound-button.mp3" --按钮
Tiger_Res.SOUND_OF_CLOSE    = "sound-close.mp3" --关闭
--game sound
Tiger_Res.vecSound = {
    SOUND_OF_LINE_BTN   = "sound-tiger-line-button.mp3", -- 线数按纽
    SOUND_OF_GAME_START = "sound-tiger-rool-start.mp3", -- 开始游戏
    SOUND_OF_GAME_STOP  = "sound-tiger-stop.mp3", -- 停止游戏
    SOUND_OF_ROLL_END   = "sound-tiger-roll-end.mp3",  -- 一列动画结束
    SOUND_OF_WIN_LINE   = "sound-tiger-win-line.mp3",  -- 赢得线数
    SOUND_OF_WIN_GAME   = "sound-win.mp3",      -- 赢了
    SOUND_OF_GET_GOLD   = "sound-get-gold.mp3", -- 获得金币

    -- 赢得大奖
    SOUND_OF_WIN_DIAM1  = "sound-diamond-1.mp3",
    SOUND_OF_WIN_DIAM2  = "sound-diamond-2.mp3",
    SOUND_OF_WIN_BOX1   = "sound-box-1.mp3",
    SOUND_OF_WIN_BOX2   = "sound-box-2.mp3",
    SOUND_OF_WIN_777_1  = "sound-777-1.mp3",
    SOUND_OF_WIN_777_2  = "sound-777-2.mp3",

    -- 动画音效
    SOUND_OF_777        = "sound-tiger-777.mp3",
    SOUND_OF_BOX        = "sound-tiger-box-2.mp3",

    -- 赢
    SOUND_OF_BIG_WIN_1      = "sound-win-big-1.mp3",
    SOUND_OF_BIG_WIN_2      = "sound-win-big-2.mp3",
    SOUND_OF_MIDDLE_WIN_1   = "sound-win-middle-1.mp3",
    SOUND_OF_MIDDLE_WIN_2   = "sound-win-middle-2.mp3",
    SOUND_OF_SMALL_WIN_1    = "sound-win-small-1.mp3",
    SOUND_OF_SMALL_WIN_2    = "sound-win-small-2.mp3",

    -- 输
    SOUND_OF_BIG_LOSE_1      = "sound-lose-big-1.mp3",
    SOUND_OF_BIG_LOSE_2      = "sound-lose-big-2.mp3",
    SOUND_OF_BIG_LOSE_3      = "sound-lose-big-3.mp3",
    SOUND_OF_BIG_LOSE_4      = "sound-lose-big-4.mp3",
    SOUND_OF_MIDDLE_LOSE_1   = "sound-lose-middle-1.mp3",
    SOUND_OF_MIDDLE_LOSE_2   = "sound-lose-middle-2.mp3",
    SOUND_OF_SMALL_LOSE_1    = "sound-lose-small-1.mp3",
    SOUND_OF_SMALL_LOSE_2    = "sound-lose-small-2.mp3",
}

Tiger_Res.vecMusic = {
    MUSIC_OF_BGM        = "music-tiger-bg.mp3",  --背景音乐
}

return Tiger_Res
--endregion

