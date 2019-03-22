--region *.lua
--此文件由[BabeLua]插件自动生成

--斗地主

cc.exports.FULL_COUNT				=54			--全牌数目
cc.exports.MAX_COUNT				=20			--最大手牌数目
cc.exports.NORMAL_COUNT				=17			--常规数目
cc.exports.LANDLORD_COUNT           =3          --地主牌
cc.exports.GAME_PLAYER_LANDLORD		=3			--游戏人数

--逻辑类型
cc.exports.CT_ERROR	                =0			--错误类型
cc.exports.CT_SINGLE				=1			--单牌类型
cc.exports.CT_DOUBLE				=2			--对牌类型
cc.exports.CT_THREE					=3			--三条类型
cc.exports.CT_SINGLE_LINE			=4			--单连类型
cc.exports.CT_DOUBLE_LINE			=5			--对连类型
cc.exports.CT_THREE_LINE			=6			--三连类型
cc.exports.CT_THREE_TAKE_ONE		=7			--三带一单
cc.exports.CT_THREE_TAKE_TWO		=8			--三带一对
cc.exports.CT_FOUR_TAKE_ONE			=9			--四带两单
cc.exports.CT_FOUR_TAKE_TWO			=10			--四带两对
cc.exports.CT_BOMB_CARD				=11			--炸弹类型
cc.exports.CT_MISSILE_CARD			=12			--火箭类型

cc.exports.GS_T_FREE				= 0					--空闲状态
cc.exports.GS_T_CALL				= 100		        --游戏状态1
cc.exports.GS_T_PLAY				= 100+1				--游戏状态2
cc.exports.GS_T_CONCLUDE			= 100+2				--游戏状态3

cc.exports.INVALID_CHAIR			= 0xFFFF			--无效椅子
cc.exports.INVALID_TABLE			= 0xFFFF			--无效桌子

--获取数值
cc.exports.GetCardValue = function(cbCardData)
    return bit.band(cbCardData, 0x0F)
end

--获取花色
cc.exports.GetCardColor = function(cbCardData)
    return bit.band(cbCardData, 0xF0)
end

--获取牌数
cc.exports.getCardCount = function(cbCardData)
    local count = 0
    for k, v in pairs(cbCardData) do
        if v > 0 then
            count = count + 1
        end
    end
    return count
end

--索引变量
cc.exports.cbIndexCount=5

--分析结构
--cc.exports.tagAnalyseResult = {
--    cbBlockCount = {},                  --扑克数目
--    cbCardData = {}                     --扑克数据
--}
--cc.exports.tagDistributing = {
--    cbCardCount = 0,                    --扑克数目
--    cbDistributing = {}                 --分布信息
--}   
--搜索结果
--cc.exports.tagSearchCardResult = {
--    cbSearchCount = 0,                  --结果数目
--    cbCardCount = {},                   --扑克数目
--    cbResultCard = {}                   --结果扑克
--} 

--排序类型
cc.exports.ST_ORDER = 1 --大小排序
cc.exports.ST_COUNT = 2 --数目排序
cc.exports.ST_CUSTOM = 3 --自定排序

--扑克数量
cc.exports.m_cbCardData = {
    --1, 2,   3,   4,   5,   6,   7,   8,   9,   10,  J,   Q,   K
    0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,	--方块 A - K
    0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,	--梅花 A - K
    0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,	--红桃 A - K
    0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,	--黑桃 A - K
    0x4E,0x4F,
}
--间距定义
cc.exports.DEF_DISTANCE				= 42
cc.exports.DEF_SHOOT_DISTANCE		= 22

--牌的状态
cc.exports.EMOUSEHANDLE = 
{
	EMOUSEHANDLE_PUSH = 1,
	EMOUSEHANDLE_MOVE = 2,
	EMOUSEHANDLE_RELEASE = 3,
}

cc.exports.E_TIP_TYPE = 
{
    E_TIP_TYPE_READY  = 0,	    --准备
    E_TIP_TYPE_CANCEL = 1,	    --不要
    E_TIP_TYPE_SCORE0 = 2,	    --不叫
    E_TIP_TYPE_SCORE1 = 3,	    --1分
    E_TIP_TYPE_SCORE2 = 4,	    --2分
    E_TIP_TYPE_SCORE3 = 5,	    --3分
    E_TIP_TYPE_ADDTIMES = 6,	--加倍
    E_TIP_TYPE_NO_ADDTIMES = 7,	--不加倍
}

cc.exports.E_GARTOON_STATE = 
{
    NORMAL          = 0,
    WIN             = 1,
    LOSE            = 2,
    ROBOT           = 3,
}

-- 斗地主 --
cc.exports.Localization_cn["LANDLORD_0"]  = "牌数据错误"
cc.exports.Localization_cn["LANDLORD_1"]  = "出牌类型错误"

local cmd = {
    ----- 斗地主 401--------------------------------------
    SUB_C_CALL_SCORE			    = 1,	        --用户叫分
    SUB_C_OUT_CARD				    = 2,	        --用户出牌
    SUB_C_PASS_CARD				    = 3,	        --用户放弃
    SUB_C_TRUSTEESHIP			    = 4,	        --玩家托管
    SUB_C_ADD_TIMES                 = 5,            --农民加倍

    SUB_S_GAME_START_LANDLORD	    = 100,	        --游戏开始
    SUB_S_CALL_SCORE			    = 101,	        --用户叫分
    SUB_S_BANKER_INFO			    = 102,	        --庄家信息
    SUB_S_OUT_CARD				    = 103,	        --用户出牌
    SUB_S_PASS_CARD				    = 104,	        --用户放弃
    SUB_S_GAME_CONCLUDE			    = 105,	        --游戏结束
    SUB_S_SET_BASESCORE			    = 106,	        --设置基数
    SUB_S_TRUSTEESHIP_NOTICE	    = 107,	        --玩家托管通知
    SUB_S_USER_GENDER               = 108,	        --玩家性别
    SUB_S_ADD_TIMES_NOTIFY          = 112,          --加倍通知（通知农民的加倍操作）
    SUB_S_USER_OUTCARD_FAIL		    = 113,          --玩家出牌失败
    ----- 斗地主 401--------------------------------------
}

--for k, v in pairs(cmd) do
--    cc.exports.G_C_CMD[k] = cmd[k]
--end

--加载界面的提示语
local text = {
    "沉闷的赢钱总比畅快的输钱要好。",
    "大牌要你命，小牌能救命。",
    "保守不是最好的策略，但冲动只会让你结束的更快。",
    "断臂也比失去生命强，牌局如此，人生亦如此。",
    "需要靠运气摸牌的时候，往往都摸不到自己想要的牌。",
}
cc.exports.Localization_cn["Loading_401"] = text

--endregion
