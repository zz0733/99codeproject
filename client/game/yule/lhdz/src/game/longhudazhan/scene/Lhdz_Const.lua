--region Lhdz_Const.lua
--Date
--Author Ace
--Desc [[龙虎斗常量定义]]
--此文件由[BabeLua]插件自动生成

cc.exports.Localization_cn["LHDZ_1"] = "请下庄后才能退出房间！"
cc.exports.Localization_cn["LHDZ_2"] = "您的筹码低于上庄条件：%.2f，不能申请上庄！"
cc.exports.Localization_cn["LHDZ_3"] = "筹码不足，无法投注!!"
cc.exports.Localization_cn["LHDZ_4"] = "庄家不能下注！"
cc.exports.Localization_cn["LHDZ_5"] = "没有更多玩家数据了！"
cc.exports.Localization_cn["LHDZ_6"] = "游戏币不足，是否进行充值！"
cc.exports.Localization_cn["LHDZ_7"] = "房间0%d"

--加载界面的提示语
local text = {
    "点击玩家头像，可以直接查看该玩家的详细信息。",
    "点击续投按钮，可以快速押注上一局相同的筹码。",
    "点击其他玩家，可以即时查看当前游戏房间所有玩家的投注信息。",
    "神算子的投注信息，可以为您提供有效的投注参考。",
    "牌路和牌型走势信息，可以作为您投注的重要依据。",
}
cc.exports.Localization_cn["Loading_215"] = text

local Lhdz_Const = {}

-- 游戏状态
Lhdz_Const.STATUS = {
    GAME_SCENE_FREE                 = 3,        -- 空闲状态
    GAME_SCENE_BET                  = 1,        -- 下注状态
    GAME_SCENE_RESULT               = 2,        -- 结算状态
}

-- 下注区域
Lhdz_Const.AREA = {
    DRAGON                          = 1,        -- 龙
    TIGER                           = 2,        -- 虎
    DRAW                            = 3,        -- 和
}

--游戏倍数
Lhdz_Const.MULTIPLE = {
    DRAGON                          = 2,        -- 龙
    TIGER                           = 2,        -- 虎
    DRAW                            = 9,        -- 和
}

Lhdz_Const.BTNEFFCRT_COLOR = {
    cc.c3b(23,135,178),   -- 5
    cc.c3b(74,90,255),    -- 10
    cc.c3b(223,115,197),  -- 50
    cc.c3b(214,81,81),    -- 100
    cc.c3b(191,169,23),   -- 500
    cc.c3b(191,191,191),  -- 1000
}

Lhdz_Const.SCOREWIDTH = {
    MAXWIDTH = 168,  --数值居中显示最大宽度
    PRE = 23,        --+-符号宽度
    DOT = 9,         --小数点宽度
    NUM = 24,        --数字宽度
}

Lhdz_Const.FLYSTAR = {
    STAR_BEGINPOS = cc.p(1207, 546),
    STAR_ENDPOS = {
        cc.p(237, 400), -- 龙
        cc.p(838.5, 400), -- 虎
        cc.p(542, 400), -- 和
    },
    FLY_TIME = {
        0.6,
        0.4,
        0.46
    },
    BEZIERPOS = {
        {cc.p(983, 625), cc.p(374, 545)},
        {cc.p(1096, 600), cc.p(884, 518)},
        {cc.p(1031, 597), cc.p(686, 524)},
    }
}

Lhdz_Const.TABEL_USER_COUNT         = 6         -- 上桌玩家
Lhdz_Const.GAME_DOWN_COUNT          = 3         -- 下注区域数
Lhdz_Const.FLYPARTICAL_COUNT        = 2         -- 飞行粒子数量
Lhdz_Const.JETTON_ITEM_COUNT        = 6         -- 筹码数
Lhdz_Const.JETTON_ITEM_USE_COUNT    = 5         -- 使用筹码数
Lhdz_Const.CARD_COUNT               = 2         -- 牌数
Lhdz_Const.MAX_BANKER_COUNT         = 20        -- 上庄列表玩家
Lhdz_Const.MAX_HISTORY_COUNT        = 20        -- 历史开奖记录
Lhdz_Const.CHIP_VALUES_COUNT        = 8         -- 筹码数值个数
Lhdz_Const.RESULT_PUMP              = 0.05      -- 结算抽水

return Lhdz_Const
--endregion
