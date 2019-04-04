

--鱼所处路径状态
cc.exports.PathStepType = 
{
    PST_NONE = 0,   --未开始移动状态
    PST_ONE = 1,    --路径1状态
    PST_TWO = 2,    --路径2状态
    PST_FREE = 3,   --发散路径状态
    PST_OVER = 10,  --路径走完
}

cc.exports.MOVE_FORWARD_PATH = 999 --发散路径ID

cc.exports.BulletKind = {
    ["BULLET_KIND_1_NORMAL"] = 0,
    ["BULLET_KIND_2_NORMAL"] = 1,
    ["BULLET_KIND_3_NORMAL"] = 2,
    ["BULLET_KIND_1_ION"]    = 3,
    ["BULLET_KIND_2_ION"]    = 4,
    ["BULLET_KIND_3_ION"]    = 5,
    ["BULLET_KIND_COUNT"]    = 6,

    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4,
    [6] = 5,
    [7] = 6,
}
yl.setDefault(BulletKind, BulletKind.BULLET_KIND_1_NORMAL)


cc.exports.BOMB_ITEM_COUNT = 50
cc.exports.BOMB_TYPE_JINGB = 0       -- 金箍棒
cc.exports.BOMB_TYPE_FOZHANG = 1     -- 万佛朝宗
cc.exports.BOMB_TYPE_SPECIAL = 2     -- 特殊大鱼

cc.exports.GAME_PLAYER_FISH = 4

cc.exports.kMaxCatchFishCount = 3
cc.exports.kMaxChainFishCount = 6
cc.exports.MAX_FISH_TEAM = 12

cc.exports.TAG_SHAN_DIAN = 901
cc.exports.TAG_FEI_JIN_BI = 902
cc.exports.TAG_JI_SHA_DA_YU_ZHUAN_PAN = 903
cc.exports.TAG_JI_SHA_DA_YU_BOMB = 904

cc.exports.BULLET_SPEED_DIFF = 1.2
cc.exports.BULLET_NUM_MAX = 10
cc.exports.MOVE_SHENDIAN_SPEED = 250

cc.exports.FISH_PAO_SCORE_1 = 6
cc.exports.FISH_PAO_SCORE_2 = 100


-- 捕鱼类 全局变量 ----------------------------------------------------------
cc.exports.paireFishKind = {}
cc.exports.paireFishKind[1] = 0
cc.exports.paireFishKind[5] = 1
cc.exports.paireFishKind[11] = 2
cc.exports.paireFishKind[3] = 3
cc.exports.paireFishKind[7] = 4
cc.exports.paireFishKind[9] = 5
cc.exports.paireFishKind[17] = 6
cc.exports.paireFishKind[15] = 7
cc.exports.paireFishKind[14] = 8
cc.exports.paireFishKind[16] = 9
cc.exports.paireFishKind[19] = 10
cc.exports.paireFishKind[21] = 11
cc.exports.paireFishKind[23] = 12

cc.exports.paireFishKind[25] = 13
cc.exports.paireFishKind[33] = 14
cc.exports.paireFishKind[30] = 15
cc.exports.paireFishKind[32] = 16
cc.exports.paireFishKind[31] = 17
cc.exports.paireFishKind[26] = 18
cc.exports.paireFishKind[27] = 19
cc.exports.paireFishKind[28] = 20
cc.exports.paireFishKind[29] = 21

cc.exports.paireFishKind[2] = 28
cc.exports.paireFishKind[6] = 28
cc.exports.paireFishKind[12] = 28
cc.exports.paireFishKind[4] = 28
cc.exports.paireFishKind[8] = 28
cc.exports.paireFishKind[10] = 28

cc.exports.paireFishKind[24] = 27
cc.exports.paireFishKind[36] = 26
cc.exports.paireFishKind[22] = 27
cc.exports.paireFishKind[34] = 22

cc.exports.FishKind = {                   --金蝉捕鱼         --李逵捕鱼     --大闹天宫
    FISH_WONIUYU = 0,          --小黄鱼           --小黄鱼       --蜗牛鱼
    FISH_LVCAOYU = 1,          --小草鱼           --小草鱼       --绿草鱼
    FISH_HUANGCAOYU = 2,       --黄草鱼
    FISH_DAYANYU = 3,          --大眼鱼
    FISH_HUANGBIANYU = 4,      --黄边鱼
    FISH_XIAOCHOUYU = 5,       --小丑鱼
    FISH_XIAOCIYU = 6,         --小刺鱼
    FISH_LANYU = 7,            --蓝鱼
    FISH_DENGLONGYU = 8,       --灯笼鱼
    FISH_HAIGUI = 9,           --海龟
    FISH_HUABANYU = 10,        --花斑鱼                          --没有
    FISH_HUDIEYU = 11,         --蝴蝶鱼                          --没有
    FISH_KONGQUEYU = 12,       --孔雀鱼
    FISH_JIANYU = 13,          --剑鱼
    FISH_BIANFUYU = 14,        --蝙蝠鱼
    FISH_YINSHA = 15,          --银鲨
    FISH_JINSHA = 16,          --金鲨
    FISH_BAWANGJING = 17,      --霸王鲸           --霸王鲸       --没有
    FISH_HAIDAN = 18,           --海胆
    FISH_SHUANGTOUQIE = 19,    --企鹅
    FISH_XIAOYINLONG = 20,     --小银龙
    FISH_XIAOJINLONG = 21,     --小金龙
    FISH_JINCHAN = 22,         --金蝉             --李逵         --没有

    FISH_FOSHOU = 26,          --佛手             --七星剑       --佛手
    FISH_BGLU = 27,            --炼丹炉           --水浒传/忠义堂--炼丹炉
    FISH_DNTG = 28,            --大闹天宫         --有           --有
    FISH_YJSD = 29,            --一箭双雕         --没有         --有
    FISH_YSSN = 30,            --一石三鸟         --没有         --有
    FISH_PIECE = 31,           --金玉满堂         --有           --没有
    FISH_CHAIN = 33,           --闪电鱼-连(0-8)

    FISH_SHENXIANCHUAN = 100,   --神仙船
    FISH_MEIRENYU = 100,        --美人鱼

    FISH_KIND_COUNT = 34,
};

cc.exports.FISH_INVALID = 0
cc.exports.FISH_ALIVE = 1
cc.exports.FISH_DIED = 2

cc.exports.STATUS_START = 0
cc.exports.STATUS_STAY = 1
cc.exports.STATUS_MIDDLE = 2
cc.exports.STATUS_MOVE = 3
cc.exports.STATUS_END = 4
cc.exports.STATUS_UNUSE = 5

cc.exports.MAX_FISH_GOLD_NUM = 80
cc.exports.FISHGOLD_TYPE_GOLD = 0
cc.exports.FISHGOLD_TYPE_SILVER = 1

cc.exports.MAX_FISH_CIRCLE = 24

cc.exports.FROGGOLD_TYPE_GOLD = 0
cc.exports.FROGGOLD_TYPE_SILVER = 1


--捕鱼提示--
cc.exports.Localization_cn["FISH_0"] = "由于您一分钟未发射子弹将在%.0f秒后离开游戏"
cc.exports.Localization_cn["FISH_1"] = "您一分钟未发射子弹，退回到游戏大厅"
cc.exports.Localization_cn["FISH_2"] = "您的设备不够流畅，将为您关闭游戏阴影效果。"


local cmd = {
    ------ 捕鱼 362---------------------------------------
	SUB_C_USER_FIRE                 =    1,
	SUB_C_EXCHANGE_FISHSCORE        =    2,
	SUB_C_TIMER_SYNC                =    3,
	SUB_C_STOCK_OPERATE             =    4,
	SUB_C_ADMIN_CONTROL             =    5,
	SUB_C_CATCH_FISH                =    6,
	SUB_C_BGLU_FISH                 =    7,
	SUB_C_USER_READY                =    8,
	SUB_C_USER_FISH_SYNC            =    9,
	SUB_C_USER_CUR_SCORE            =    10,

	SUB_S_SCENE_FISH				=   100,
	SUB_S_SCENE_BULLETS				=   101,
	SUB_S_EXCHANGE_FISHSCORE		=   102,
	SUB_S_USER_FIRE					=	103,
	SUB_S_BULLET_DOUBLE_TIMEOUT	    =   104,
	SUB_S_DISTRIBUTE_FISH			=	105,
	SUB_S_SWITCH_SCENE				=   106,
	SUB_S_CATCH_CHAIN				=   107,
	SUB_S_CATCH_FISH_GROUP			=   108,
	SUB_S_FORCE_TIMER_SYNC			=   109,
	SUB_S_TIMER_SYNC				=   110,
	SUB_S_STOCK_OPERATE_RESULT		=   111,
	SUB_S_ADMIN_CONTROL			    =   112 ,
	SUB_S_DISTRIBUTE_FISH_TEAM		=   113,
	SUB_S_DISTRIBUTE_FISH_CIRCLE	=	114,
	SUB_S_RETURN_BULLET_SCORE		=   115,
	SUB_S_USER_FISH_SYNC            =   116,
	SUB_S_USER_SCORE_SYNC           =   117, --同步金币
	SUB_S_USER_FIRE_ERROR			=	118, --发射子弹错误
    ------ 捕鱼 362---------------------------------------
}

--for k, v in pairs(cmd) do
--    cc.exports.G_C_CMD[k] = cmd[k]
--end

--加载界面的提示语
local text = {
    "好的游戏，带给您更好的生活体验。",
    "好的捕鱼游戏都需要时间来证明。",
    "从来没有哪一款捕鱼游戏像我们这样耿直不忽悠！",
}
cc.exports.Localization_cn["Loading_362"] = text