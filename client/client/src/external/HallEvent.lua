--region *.lua
--Date 2016-9-1
--Author xufei
--此文件由[BabeLua]插件自动生成

local prefixFlag = "Hall_Event_"

cc.exports.Hall_Events =
{
    HALL_SCENE          = prefixFlag .. "hall_scene",               --大厅场景

    Login_Entry         = prefixFlag .. "loginEntry",               --登录界面
    Hall_Entry          = prefixFlag .. "hallEntry",                --进入游戏场景

    SHOW_CHOOSE_ROOM_DLG = prefixFlag .. "chooseRoomEntry",          --选择游戏弹窗
    IS_IN_ROOM          = prefixFlag .. "isInRoom",                 --在游戏中
    APP_ENTER_FOREGROUND_EVENT = prefixFlag .. "appEnterBackground",  --返回APP
    MSG_CHANGE_BANK_PWD = prefixFlag .. "bankPwd",                  --银行密码
    MSG_UDPATE_USR_SCORE = prefixFlag .. "updateUserScore",                 --更新金币
    MSG_BANK_DETAILS    = prefixFlag .. "bank_details",                 --银行信息
    MSG_BANK_VERIFY_PWD = prefixFlag .. "verifyPwd",                 --确认密码
    ------------------
    SHOW_BIND_VIEW             = prefixFlag .. "showbINDView",          -- 显示绑定页面
    SHOW_EXCHANGE_VIEW          = prefixFlag .. "showExchangeView",     -- 显示兑换页面
    BANK_TRANSFER_SELECT_DAYS  = prefixFlag .. "bankTransferSelectDays",  -- 银行转帐日志，选中了时间
    CLOSE_TRANSFER_SELECT_DAYS  = prefixFlag .. "closeTransferSelectDays",  -- 关闭银行转帐日志时间时间选择view
    UPDATA_DOWNLOAD_PERCENT    = prefixFlag .. "updateDownLoadPercent",   -- 更新大厅游戏下载进度
    UPDATA_DOWNLOAD_ERROR      = prefixFlag .. "updateDownLoadError",     -- 大厅游戏下载失败
    GAMELIST_CLICKED_GAME      = prefixFlag .. "GameListClickedGame",     -- 二级游戏列表点击了游戏图标
    ROOMLIST_BACK_TO_GAMELIST  = prefixFlag .. "RoomListBackToGameList",  -- 三级等级场列表返回二级游戏列表
    UPDATA_HALL_MSG_TAG        = prefixFlag .. "updateHallMsgTag",        -- 更新大厅消息小红点
    UPDATA_USER_NICK_HEAD      = prefixFlag .. "updateUserNickHead",      -- 更新玩家昵称和头像
    MSG_BANK_REFRESH           = prefixFlag .. "updateBankView",      -- 刷新银行界面
    MSG_UPDATE_RELIEVE         = prefixFlag .. "updateRelieve",           --刷新救济金数据
    MSG_UPDATE_USR_SPREAD_INFO = prefixFlag .. "updataUserSpreadInfo",    --推荐/推广信息
    MSG_UPDATE_USR_SPREAD_DETAILS_INFO = prefixFlag .. "updataUserSpreadDetailsInfo",    --推荐/推广信息
    MSG_BANK_USER_INFO         = prefixFlag .. "bankUserInfo",            -- 银行转帐目标玩家信息
    MSG_QUERY_BINDING          = prefixFlag .. "queryBinding",            -- 玩家绑定信息 
    MSG_DINGPHONE_OK           = prefixFlag .. "phoneBinding",            -- 微信绑定手机成功 
    MSG_BINDING_SUCCESS        = prefixFlag .. "bindingSuccess",          -- 绑定成功
    MSG_SHOW_ROOM_CHOOSE_LAYER = prefixFlag .. "showRoomChooseLayer",     -- 选择模式界面点击跳转二级列表
    MSG_EXCHANGE_SUCCESS       = prefixFlag .. "exchangeSuccess",         -- 提现成功
    MSG_EXCHANGE_FAILURE       = prefixFlag .. "exchangeFailure",         -- 提现失败
    MSG_UPDATE_GAME_LIST       = prefixFlag .. "getChannelInfo",          -- 拉取大厅控制开关 --modify by nick
    MSG_DEL_ALL_MSG            = prefixFlag .. "deleteAllMessage",        -- 删除所有消息记录
    MSG_OPEN_BROADCAST_VIEW    = prefixFlag .. "openbroadcastview",       -- 收到公告信息
    MSG_GET_ROOM_LIST          = prefixFlag .. "getroomlist",             -- 收到房间列表信息
    HIDE_HALL_BG_BLUR          = prefixFlag .. "hideHallBgBlur",          -- 隐藏大厅虚化背景
    MSG_REGISTER_OK            = prefixFlag .. "registerok",              -- 注册成功
    MSG_PHONEREGISTER_OK       = prefixFlag .. "phoneregisterok",         -- 手机号登陆成功
    MSG_OPEN_EXCHANE_LAYER     = prefixFlag .. "openexchangelayer",       -- 提现按钮事件
    ----------网络消息---------------
    CHECK_CHANNEL_BACK      = prefixFlag .. 1,  --查看屏蔽信息
    GET_TABLE_INFO_BACK     = prefixFlag .. 2,  --登录房间桌子信息回调
    LOGIN_GAME_FAILTURE     = prefixFlag .. 3,  --登录游戏房间失败
    GET_LIST_MESSAGE_BACK   = prefixFlag .. 4, --获取消息包
    GET_RECOM_MESSAGE_BACK  = prefixFlag .. 5, --获取推荐(推广)信息
    DEL_MSG_RESULT_BACK     = prefixFlag .. 6, --删除消息回调
    MSG_NICK_HEAD_MODIFIED  = prefixFlag .. 7, --更改头像和昵称回调
    MSG_UPDATE_RANKING      = prefixFlag .. 10, --更新排行版

    -- add by nick
    MSG_GMAE_ENTER_RECOMMEND    = prefixFlag .. "enter_game_recommend",  --进入主推游戏
    MSG_GAME_QUIT_RECOMMEND     = prefixFlag .. "quit_game_recommend",   --退出主推游戏

    MSG_GMAE_ENTER_LIST         = prefixFlag .. "enter_game_list",  --进入游戏列表
    MSG_GAME_QUIT_LIST          = prefixFlag .. "quit_game_list",   --退出游戏列表

    MSG_HALL_CLICKED_GAME       = prefixFlag .. "roomlist_click_room",  --点击进入游戏

    SHOW_USER_CENTER            = prefixFlag .. "show_user_center", --进入用户中心

    MSG_CLOSE_REGISTER          = prefixFlag .. "close_resiter_view", --关闭注册界面

    MSG_SHOW_VIEW               = prefixFlag .. "show_view",            --打开界面

    MSG_SHOW_ERROR              = prefixFlag .. "show_error",           --显示错误界面

    MSG_SHOW_MODE_VIEW          = prefixFlag .. "show_mode",            --显示模式选择

    --add by dan
    MSG_UPDATE_EXCHANGE_STATUS  = prefixFlag .. "update_exchange_status",            --兑换按钮状态
    MSG_CLOSE_SPREAD          = prefixFlag .. "close_spread_view", --关闭推广员界面
    MSG_UPDATE_SPREAD_MOLD          = prefixFlag .. "update_spread_mold", --更新推广员模板

    MSG_UPDATE_DOWNLOAD         = prefixFlag .. "update_game_download",      --更新检测完

    MSG_UPDATE_REVERT           = prefixFlag .. "update_revert",            --更新客服回复
    MSG_GET_REPORT_WECHAT       = prefixFlag .. "get_report_wechat",        --获取到举报微信号
    MSG_GET_SHARE_PRESENT       = prefixFlag .. "get_share_present",        --获取分享奖励

    MSG_CHECK_IS_OPEN_PAY       = prefixFlag .. "check_is_open_pay",        --查询提现个人开关
    MSG_UDPATE_USR_SCORE    = prefixFlag .. "updateUsrScore1",                 --更新金币
    SHOW_SPREAD_ACTIVITY        = prefixFlag .. "show_spread_activity",     --进入推广员活动界面
    ENTER_RECOMMEND_GAME        = prefixFlag .. "enter_recommend_game",     --进入推荐游戏
    MSG_SHOW_SHOP               = prefixFlag .. "showShop",                 --显示商店
    MSG_GAME_LOAD_SUCCESS       = prefixFlag .. "loadSuccess",              --加载游戏完成
    MSG_SHOW_FISH_EFFECT        = prefixFlag .. "showfisheffect",           -- 显示捕鱼特效

    MSG_RECHARGE_WEB            = prefixFlag .. "recharge_web",             --网页充值
    MSG_ENTER_FOREGROUND_RECHARGE    = prefixFlag .. "enter_foreground_recharge", --恢复前台
    MSG_BANK_INFO               = prefixFlag .. "bankInfo",                 --更新银行
    MSG_RECHARGE_DETAIL_BACK    = prefixFlag .. "recharge_detail_back",     --充值详情返回
    MSG_GET_AGENT               = prefixFlag .. "getAgentBack",             --获取代理人信息回调
    MSG_QUERY_RECHARGE              = prefixFlag .. "query_recharge",       --查询充值结果
    MSG_SHOW_REGISTER           = prefixFlag .. "msg_show_register",       --打开注册界面
    MSG_CLOSE_CURRENT_DIALOG    = prefixFlag .. "close_current_dialog",    --关闭对话框
    MSG_CLOSE_SPREAD_LAYER      = prefixFlag .. "close_spread_layer",      --关闭推广员界面
    MSG_OPEN_SPREADRX_LAYER     = prefixFlag .. "open_spread_recevie_xiangqing_layer", --打开推广员奖励领取详情
        --打开大厅界面
    MSG_OPEN_HALL_LAYER     = prefixFlag .. "msg_open_hall_layer", 
    MSG_GAME_EXIT           = prefixFlag .. "gameExit",                        --退出游戏
    MSG_FISH_CLOSE         = prefixFlag .. "fish_close", --关闭捕鱼
    MSG_SHOW_SHOP           = prefixFlag .. "showShop",                        --显示商店
    SHOW_EXIT_VIEW          = prefixFlag .. "exitview",                        --退出大厅
    SHOW_OPEN_BANK          = prefixFlag .. "openbank",                        --打开银行
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
        CLOSE_BROADCAST                     = 43,  -- 是否关闭广播,1关闭,0开放
        CLOSE_REGISTER                      = 44,  -- 是否关闭注册送金币,1关闭,0开放
    },
    MSG_POP_NOTICE                  = prefixFlag .. "pop_notice",       --公告弹窗
}

return cc.exports.Hall_Events
--endregion
