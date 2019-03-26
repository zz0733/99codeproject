
--region Handredcattle_Const.lua
--Date 2017.0315
--Desc 百人牛牛常量定义

local Handredcattle_Const = {}

Handredcattle_Const.DOWN_COUNT_HOX      = 4
Handredcattle_Const.PLAYERS_COUNT_HOX   = 5
Handredcattle_Const.HAND_COUNT          = 5
Handredcattle_Const.CARD_DIFFX          = 32
Handredcattle_Const.JETTON_ITEM_COUNT   = 6

Handredcattle_Const.waitArmPos = cc.p(632, 152)
Handredcattle_Const.waitArmTag = 11

Handredcattle_Const.jieduanArmPos = cc.p(666, 354)
Handredcattle_Const.jieduanArmTag = 12

Handredcattle_Const.daojishiArmPos = cc.p(660, 376)
Handredcattle_Const.daojishiArmTag = 19

Handredcattle_Const.winArmPos = {
    [1]= cc.p(294,343),
    [2]= cc.p(539,343),
    [3]= cc.p(783,343),
    [4]= cc.p(1031,343),
}
Handredcattle_Const.winArmTag = 50

Handredcattle_Const.resultPos = {
    [1]= cc.p(683.5,633),
    [2]= cc.p(300.5,187),
    [3]= cc.p(550,187),
    [4]= cc.p(795.5,187),
    [5]= cc.p(1039.5,187),
}

Handredcattle_Const.cardStartPos = {
    [1]= cc.p(592,651),
    [2]= cc.p(196,155),
    [3]= cc.p(441,155),
    [4]= cc.p(687,155),
    [5]= cc.p(931,155),
}

Handredcattle_Const.jettonStartPos = {
    [1]= cc.p(350,83),
    [2]= cc.p(488,83),
    [3]= cc.p(623,83),
    [4]= cc.p(760,83),
    [5]= cc.p(896,83),
    [6]= cc.p(1034,83),
}

return Handredcattle_Const

--endregion
