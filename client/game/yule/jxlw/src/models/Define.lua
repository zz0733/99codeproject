--
-- Author: zhong
-- Date: 2016-11-02 17:46:07
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local Define = {}
local TAG_START             = 100
local enumTable = 
{
    "BT_EXIT",
    "BT_CHAT",
    "BT_TRU",
    "BT_SET",
    "BT_READY",
    "BT_CALLSCORE0",
    "BT_CALLSCORE1",
    "BT_CALLSCORE2",
    "BT_CALLSCORE3",
    "BT_PASS",
    "BT_SUGGEST",
    "BT_OUTCARD",
    "BT_INVITE",
    "BT_SWITCH_1",
    "BT_SWITCH_2"
}
Define.TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)

local zorders = 
{
    "RESULT_ZORDER",
    "PRIROOM_ZORDER",
    "CHAT_ZORDER",
    "EFFECT_ZORDER",
    "SET_ZORDER"
}
Define.TAG_ZORDER = ExternalFun.declarEnumWithTable(1, zorders)

-- 叫分动画(基本)
Define.CALLSCORE_ANIMATION_KEY = "callscore_key"
-- 叫分1
Define.CALLONE_ANIMATION_KEY = "1_score_key"
-- 叫分2
Define.CALLTWO_ANIMATION_KEY = "2_score_key"
-- 叫分3
Define.CALLTHREE_ANIMATION_KEY = "3_score_key"
-- 飞机动画
Define.AIRSHIP_ANIMATION_KEY = "airship_key"
-- 火箭动画
Define.ROCKET_ANIMATION_KEY = "rocket_key"
-- 报警动画
Define.ALARM_ANIMATION_KEY = "alarm_key"
-- 炸弹动画
Define.BOMB_ANIMATION_KEY = "bomb_key"
-- 语音动画
Define.VOICE_ANIMATION_KEY = "voice_ani_key"

-- 托管延迟
Define.TRU_DELAY = 0.5

return Define