--region *.lua
--Date
--游戏常亮
--endregion

cc.exports.G_CONSTANTS = {
    
    SERVER_DNS_MAIN = 2,
    SERVER_DNS_BACKUP = 3, 

    IP = "",
    IP_LOGIN_PORT = 8300,
    INTERFACE_VERSION = 101056515,
    VERSION_FRAME = 6003,
    GAME_IP = "",
    GAME_PORT = 8300,
    GAME_TAG = 2,

    FACE_NUM = 10,
    INVALID_CHAIR = 65535,
    INVALID_TABLE = 65535,


    --连接类型
    CLIENT_KIND_UNKOWN         = 0,									--未知连接类型
    CLIENT_KIND_FALSH          = 1,									--网页类型
    CLIENT_KIND_PC             = 2,									--电脑类型
    CLIENT_KIND_IOS            = 3,									--IOS类型
    CLIENT_KIND_ANDROID        = 4,									--Android类型
    CLIENT_KIND_MAXTYPE        = 5,									--最大的连接类

    -- 系统消息类型掩码
    SMT_CHAT                   = 0x0001,                             -- 聊天消息
    SMT_EJECT                  = 0x0002,                             -- 弹出消息
    SMT_GLOBAL                 = 0x0004,                             -- 全局消息
    SMT_PROMPT                 = 0x0008,                             -- 提示消息
    SMT_TABLE_ROLL             = 0x0010,                             -- 滚动消息
    SMT_ANIMATION              = 0x0020,                             -- 动画消息 
    SMT_COLOR_FRONT            = 0x0040,                             -- 彩字消息

    --控制掩码
    SMT_CLOSE_ROOM             = 0x0100,                            --关闭房间
    SMT_CLOSE_GAME             = 0x0200,                            --关闭游戏
    SMT_CLOSE_LINK             = 0x0400,                            --中断连接
    SMT_CLOSE_PLAZA            = 0x0800,                            --关闭大厅
    SMT_GAME_MAINTAIN          = 0x1000,                            --游戏维护

    MAX_CHANNEL_STATUS_COUNT   = 200,
    MAX_CLIENT_ACTIVITY        = 10,

    --登录房间失败原因
    LOGON_FAIL_SERVER_INVALIDATION  = 200,                                 --房间失效
    LOGON_FAIL_SERVER_ROOM_SCORE    = 201,                                 --积分限制
    SRL_SERVER_OPENED			    = 2,								--房间开启
    SRL_SERVER_CLOSED			    = 1,								--房间关闭

    -- add by nick --------------
    SRL_SERVER_LIMIT                = 3,                                --服务器禁止
    -- add by nick --------------

    EXPERIENCE_TIP_TIME            = 600,                               --体验房提示弹出间隔时间(秒)

    --获取活动信息
    MAX_SHARE_PRESENT_COUNT		= 7,
    MAX_GIVE_AWAY_COUNT         = 10,

    MAX_VERIFY_CODE_COUNT = 5,  -- 验证码个数


    GAMESWITCH =
    {
        GAMEKIND = 0,
        RECHARGE = 1,
        TRANSFER = 2,   -- 银行转帐
        SPEAKER  = 3,
        USERLIST = 4,
        CLOSE_EXCHANGE                      = 5,   -- 提现
        CLOSE_RECHARGE_APPSTORE             = 6,   -- 在RECHARGE为0的时候，如果这个值为1，则需要关闭appstore充值
        CLOSE_RECHARGE_WETCHAT              = 7,   -- 在RECHARGE为0的时候，如果这个值为1，则需要关闭微信充值
        CLOSE_ERCHARGE_ALIPAY_WEB           = 8,   -- 在RECHARGE为0的时候，如果这个值为1，则需要关闭支付宝网页充值
        CLOSE_ERCHARGE_ALIPAY_CLIENT        = 9,   -- 在RECHARGE为0的时候，如果这个值为1，则需要关闭支付宝客户端充值
        CLOSE_RECHARGE_POINTCARD            = 10,  -- 在RECHARGE为0的时候，如果这个值为1，则需要关闭点卡充值
        CLOSE_ACTIVITY_RECHARGE             = 11,  -- 充值活动
        CLOSE_ACTIVITY_SHARE                = 12,  -- 分享活动
        CLOSE_ACTIVITY_COMMENT              = 13,  -- 评论活动
        CLOSE_RANK                          = 14,  -- 排行榜
        CLOSE_SPREAD                        = 15,  -- 推广员
        CLOSE_GIFT                          = 16,  -- 红包
        CLOSE_RECHARGE_WETCHAT_WEB          = 17,  -- 如果这个值为1，则需要关闭微信网页充值
        CLOSE_RECHARGE_WETCHAT_HEEPAY       = 18,  -- 如果这个值为1，则需要关闭汇付宝微信充值
        CLOSE_RECHARGE_ALIPAY_HEEPAY        = 19,  -- 如果这个值为1，则需要关闭汇付宝支付宝充值
        CLOSE_ACTIVITY_DEFAULT_4            = 20,
        CLOSE_ACTIVITY_DEFAULT_5            = 21,
        CLOSE_ACTIVITY_DEFAULT_6            = 22,
        CLOSE_ACTIVITY_DEFAULT_7            = 23,
        CLOSE_ACTIVITY_DEFAULT_8            = 24,
        CLOSE_ACTIVITY_DEFAULT_9            = 25,
        CLOSE_ACTIVITY_DEFAULT_10           = 26,
        CLOSE_CHOOSE_ROOM                   = 27,  -- 在RECHARGE为0的时候，如果这个值为1，则需要选择房间
        CLOSE_ALIPAY_WEBVIEW                = 28,  -- 如果这个值为1,隐藏支付宝充值流程网页显示
        CLOSE_WECHAT_WEBVIEW                = 29,  -- 如果这个值为1,隐藏微信充值流程网页显示
        CLOSE_RECHARGE_INVITE               = 30,  -- 如果这个值为1，则需要关闭代理招商
        CLOSE_RECHARGE_AGENT                = 31,  -- 如果这个值为1，则需要关闭代理充值(人工充值)
        CLOSE_DRAWINGS_CARD                 = 32,  -- 银行卡提现,1关闭,0开放
        CLOSE_DRAWINGS_ALIPAY               = 33,  -- 支付宝提现,1关闭,0开放
        CLOSE_RECHARGE_BANK_WEB             = 34,  -- 银行卡支付,1关闭,0开放
        CLOSE_RECHARGE_QQ_WEB               = 35,  -- qq网页支付,1关闭,0开放
        CLOSE_EXCHANGE_BY_RECHARGE          = 36,  -- 0代表兑换功能不受充值影响 1代表充值了才显示兑换
        CLOSE_RECHARGE_JD_WEB               = 37,  -- 京东支付,1关闭,0开放
        CLOSE_RECHARGE_STRATEGY             = 38,  -- 充值策略,1关闭,0开放
        CLOSE_DELAY_EXCHANGE                = 39,  -- 是否延迟展示结算,1关闭,0开放
        CLOSE_WEBSITE_SHOW                  = 40,  -- 是否显示官网,1关闭,0开放
        CLOSE_SERVICE                       = 41,  -- 是否关闭客服,1关闭,0开放
        CLOSE_SUGGEST                       = 42,  -- 是否关闭建议,1关闭,0开放
    },

    EGAME_TYPE_CODE = 
    {
        EGAME_TYPE_FLYWALK          = 201,       --飞禽走兽
        EGAME_TYPE_TIGER            = 202,       --老虎机
        EGAME_TYPE_DICE             = 203,       --骰宝
        EGAME_TYPE_HORSE            = 204,       --赛马
        EGAME_TYPE_NIUNIU           = 205,       --百人牛牛
        EGAME_TYPE_WATERMARGIN      = 206,       --水浒传
        EGAME_TYPE_CAR              = 207,       --车行
        EGAME_TYPE_BACCARAT         = 208,       --百家乐
        EGAME_TYPE_FRUIT            = 209,       --水果机
        EGAME_TYPE_TICKETS          = 210,       --刮刮乐
        EGAME_TYPE_3DHORSE          = 211,       --皇家赛马
        EGAME_TYPE_DIAMOND_DRAG     = 212,       --连环夺宝
        EGAME_TYPE_REDVSBLACK       = 213,       --红黑大战
        EGAME_TYPE_LONGHUDAZHAN     = 215,       --龙虎大战
        EGAME_TYPE_FISHING          = 352,       --大闹天宫
        EGAME_TYPE_FROG_FISH        = 361,       --金蟾捕鱼
        EGAME_TYPE_LK_FISH          = 362,       --李逵捕鱼
        EGAME_TYPE_LONG_FISH        = 363,       --深海捕龙
        EGAME_TYPE_LANDLORD         = 401,       --斗地主
        EGAME_TYPE_TWONIUNIU        = 402,       --二人牛牛
        EGAME_TYPE_TWOSHOWHAND      = 403,       --二人梭哈
        EGAME_TYPE_TONGBINIUNIU     = 404,       --通比牛牛
        EGAME_TYPE_ZHAJINHUA        = 407,       --扎金花
        EGAME_TYPE_XPNN             = 409,       --血拼牛牛
        EGAME_TYPE_HPMAHJONG        = 410,       --火拼麻将 
	    EGAME_TYPE_TEXAS            = 411,       --德州扑克
        EGAME_TYPE_PAODEKUAI        = 412,       --跑得快
        EGAME_TYPE_QZNN             = 413,       --抢庄牛牛
    },

    -----------大厅中游戏种类类型定义-----------
    --游戏种类
    GameClassifyType = {

        GAME_CLASSIFY_MAIN      = 0,        --推荐游戏
        GAME_CLASSIFY_ARCADE    = 1,        --多人游戏
        GAME_CLASSIFY_TIGER     = 2,        --单机游戏
        GAME_CLASSIFY_FISH      = 3,        --捕鱼游戏
        GAME_CLASSIFY_CARD      = 4,        --对战游戏

        GAME_CLASSIFY_CASUAL    = 5,        --休闲
    },

    --用户状态
    US_NULL						= 0,		--没有状态
    US_FREE						= 1,		--起立状态
    US_SIT						= 2,		--坐下状态
    US_READY					= 3,		--准备状态
    US_LOOKON					= 4,		--旁观状态
    US_PLAYING					= 5,		--游戏状态
    US_OFFLINE					= 6,		--断线状态
    US_WAIT                     = 7,		--等待状态

    WINDOWS_MSG                 = 0,        --窗口提示类型
    UPRUN_MSG                   = 1,        --浮动提示类型
    MANAGER_MSG                 = 2,        --管理员提示类型
    ROLL_MSG                    = 3,        --游戏中的跑马灯消息

    NetWorkEvent = {
	Socket_Disconnect = "Socket_Disconnect"	,
	Socket_ReconSuc = "Socket_ReconSuc",
	Socket_NoNetWork = "Socket_NoNetWork",
    },

    -- UI 显示层级定义
    Z_ORDER_HIDDEN              = -10,
    Z_ORDER_BOTTOM              = 0,
    Z_ORDER_BACKGROUND          = 10,
    Z_ORDER_STATIC              = 20,
    Z_ORDER_MINDDLE             = 40,
    Z_ORDER_COMMON              = 50,
    Z_ORDER_OVERRIDE            = 80,
    Z_ORDER_MODAL               = 90,
    Z_ORDER_TOP                 = 100,

    --牌型
    --扑克类型
    CardValue_Nothing					= 0,                  --牛破
    CardValue_One						= 1,                  --牛一
    CardValue_Two						= 2,                  --牛二
    CardValue_Three						= 3,                  --牛三
    CardValue_Four						= 4,                  --牛四
    CardValue_Five						= 5,                  --牛五
    CardValue_Six						= 6,                  --牛六
    CardValue_Seven						= 7,                  --牛七
    CardValue_Eight						= 8,                  --牛八
    CardValue_Nine						= 9,                  --牛九
    CardValue_Ten						= 10,                 --牛牛
    CardValue_Yin						= 11,                 --银牛（4花牛）
    CardValue_Jin						= 12,                 --金牛（5花牛）
    CardValue_Bomb						= 13,                 --炸弹（是由四张相同的牌）
    CardValue_Small						= 14,                 --五小牛

    GAME_STATUS_FREE                    = 0,                  --空闲状态

    -- 支付类型
    Recharge_Type =
    {
        Type_AppStore                   = 0,        -- appstore
        Type_Alipay                     = 1,        -- 支付宝
        Type_WeChat                     = 2,        -- 微信支付
        Type_QQ                         = 3,        -- qq
        Type_Bank                       = 4,        -- 银行卡
        Type_JingDong                   = 5,        -- 京东
        Type_PointCard                  = 6,        -- 点卡
    },

    -- 支付状态
    Recharge_Status = 
    {
        Order_Success                   = 0,        -- 订单支付成功
        Order_Create_Failed             = 1,        -- 下单失败
        Order_Verify_Failed             = 2,        -- 订单校验失败
        Order_Failed                    = 3,        -- 支付失败未知错误
        Network_Error                   = 4,        -- 网络错误
        Uninstall_WX                    = 5,        -- 未安装微信客户端
        Uninstall_AliPay                = 6,        -- 未安装支付宝客户端
        Order_Processing                = 7,        -- 正在处理中
    },

    -- 渠道类型
    ChannelType = 
    {
        SDK_NULL                        = 0,        -- 无平台
        CN_DFH_IOS_OFFICIAL             = 1,        -- 大富豪斗地主 官方渠道
    },

    ResChannelType = 
    {
        SDK_NULL                        = 0,        --

        --玖玖棋牌
        RES_JJ_POKER                    = 1, --玖玖棋牌
        RES_JJ_ZHAJINHUA                = 2, --玖玖诈金花
        RES_JJ_CHEDAN                	= 3, --玖玖棋牌(结算改为撤单分支)
        RES_JJ_SHOUYI                	= 4, --玖玖棋牌(结算改为收益分支)

        RES_YW_POKER                    = 11, --永旺棋牌
    },

    -- 数据库定义
    DBConst = {
        DB_ERROR                        = -1,       -- 处理失败
        DB_SUCCESS                      = 0,        -- 处理成功
        DB_NEEDMB                       = 18,       -- 处理失败
        DB_SERVERLOCKER                 = 77,       -- 房间被锁的标志
        DB_CAPTCHA_ERROR                = 100,      -- 验证码错误
        DB_MOBILE_PHONE_VERIFY          = 10,       -- 手机二次验证
        DB_WECHAT_NEED_VERIFY           = 20,       -- 需要微信验证
        DB_WECHAT_VERIFY_TIMEOUT        = 21,       -- 微信验证已经过期
        DB_WECHAT_VERIFY_ERROR          = 22,       -- 微信验证错误
        DB_MOBIlE_PHONE_VERIFY_ERROR    = 23,       -- 手机注册验证码验证码错误
        DB_SESSION_TIMEOUT              = 30,       -- Session过期
    },
}


--用户状态
cc.exports.US_NULL					= 0x00								--没有状态
cc.exports.US_FREE					= 0x01								--站立状态
cc.exports.US_SIT					= 0x02								--坐下状态
cc.exports.US_READY					= 0x03								--同意状态
cc.exports.US_LOOKON				= 0x04								--旁观状态
cc.exports.US_PLAYING				= 0x05								--游戏状态
cc.exports.US_OFFLINE				= 0x06								--断线状态
cc.exports.US_WAIT                  = 0x07								--等待匹配状态

cc.exports.Z_ORDER_HIDDEN           = -10
cc.exports.Z_ORDER_BOTTOM           = 0
cc.exports.Z_ORDER_BACKGROUND       = 10
cc.exports.Z_ORDER_STATIC           = 20
cc.exports.Z_ORDER_MINDDLE          = 40
cc.exports.Z_ORDER_COMMON           = 50
cc.exports.Z_ORDER_OVERRIDE         = 80
cc.exports.Z_ORDER_MODAL            = 90
cc.exports.Z_ORDER_TOP              = 100

cc.exports.INVALID_CHAIR			= 0xFFFF			--无效椅子
cc.exports.INVALID_TABLE			= 0xFFFF			--无效桌子

cc.exports.LEN_MOBILE_PHONE = 12       --移动电话

cc.exports.M_PI = 3.14159265358979323846 
cc.exports.M_PI_2 = 1.57079632679489661923

--游戏状态（todo：放到游戏内）
cc.exports.GAME_STATUS_FREE	=		0			-- 空闲状态
cc.exports.GAME_STATUS_PLAY	=		100			-- 游戏状态
cc.exports.GAME_STATUS_WAIT	=		200			-- 等待状态


