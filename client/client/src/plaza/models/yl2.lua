yl = yl or {}

yl.WIDTH								= 1334--1136--1334
yl.HEIGHT								= 750--640--750

yl.DEVICE_TYPE							= 0x10
yl.KIND_ID								= 122
yl.STATION_ID							= 1   

yl.HTTP_URL = ""

if  device.platform  == "android" then
    --基础配置地址
    yl.BASE_CONFIG = 
    {
        "http://download.tianshenyule.cc/unity/jiuwanqpandroid.xml",
        "http://download.tianshenyule.net/unity/jiuwanqpandroid.xml",
        "http://download.tianshenyule.vip/unity/jiuwanqpandroid.xml",
        "http://oss.aliyuncs.com/dong888/unity/jiuwanqpandroid.xml",
    } 
elseif device.platform  == "ios" then
    --基础配置地址
    yl.BASE_CONFIG = 
    {
        "http://download.tianshenyule.cc/unity/jiuwanqpqyios.xml",
        "http://download.tianshenyule.net/unity/jiuwanqpqyios.xml",
        "http://download.tianshenyule.vip/unity/jiuwanqpqyios.xml",
        "http://oss.aliyuncs.com/dong888/unity/jiuwanqpqyios.xml",
    }
else
    --基础配置地址
    yl.BASE_CONFIG = 
    {
        "http://download.tianshenyule.net/unity/jiuwanqpandroid.xml",
    } 
end

yl.CLIENTFILE = "client_hh.info"
yl.update_url = {
    "http://hhehe.oss-cn-hangzhou.aliyuncs.com/hhgame/config/"..yl.CLIENTFILE.."?"..os.time(),
}              

-- http请求支持(loginScene)
yl.HTTP_SUPPORT							= true
-- 是否显示信息弹窗的ip和位置信息
yl.SHOW_IP_ADDRESS                      = true
-- 是否单游戏模式(游戏列表数目为1生效)
yl.SINGLE_GAME_MODOLE                   = true
-- 是否自动登录
yl.AUTO_LOGIN                           = true
-- windows过滤更新
yl.DISABLE_WIN_UPDATE                   = false
-- windows lua代码检查后缀
yl.WIN_SRC_SUFFIX                       = ""

-- 判断条件
yl.ENABLE_VALUE                         = 0

-- 消息类型
yl.SYSTEM_MSG                           = 1     -- 系统消息
yl.TRUMPET_MSG                          = 2     -- 喇叭消息

-- 广告动作
yl.AD_ACTION_TOSHOP                     = "ad_to_shop_action"   -- 跳转商店
yl.AD_ACTION_TOSPREAD                   = "ad_to_spread_action" -- 跳转推广
yl.AD_ACTION_CREATEROOM                 = "ad_to_createroom_action" -- 创建界面
yl.AD_ACTION_VIDEO                      = "ad_to_video_action" -- 回放
yl.AD_ACTION_IDENTIFY                   = "ad_to_identify_action" -- 认证

yl.PLAZA_ROOMLIST_LAYER                 = "__plaza_roomlist_layer__"

-- 登录类型
yl.LOGON_TYPE = 
{
    ACCOUNT = 1,         -- 账号登录
    REGISTER = 2,        -- 注册登录
    PHONE = 3,           -- 手机号登陆
    VISTOR = 4,          -- 游客登陆
    WECHAT = 5,          -- 微信登陆
}

yl.COMMON_LOADING_ANI                   = "common_loading_animation" -- 通用loading

yl.DOWN_PRO_INFO						= 1
yl.DOWN_UNZIP_STATUS					= 2
yl.DOWN_COMPELETED						= 3
yl.DOWN_ERROR_PATH						= 4 									--路径出错
yl.DOWN_ERROR_CREATEFILE				= 5 									--文件创建出错
yl.DOWN_ERROR_CREATEURL					= 6 									--创建连接失败
yl.DOWN_ERROR_NET		 				= 7 									--下载失败
yl.DOWN_ERROR_UNZIP 					= 8

yl.SCENE_PLAZA                          = 1         -- 大厅界面
yl.SCENE_ROOMLIST                       = 2         -- 房间列表
yl.SCENE_ROOM  							= 3         -- 房间
yl.SCENE_GAME                           = 21        -- 游戏界面

yl.SCENE_EX_END 						= 50

yl.MAIN_SOCKET_INFO						= 0

yl.SUB_SOCKET_CONNECT					= 1
yl.SUB_SOCKET_ERROR						= 2
yl.SUB_SOCKET_CLOSE						= 3

yl.US_NULL								= 0x00		--没有状态
yl.US_FREE								= 0x01		--站立状态
yl.US_SIT								= 0x02		--坐下状态
yl.US_READY								= 0x03		--同意状态
yl.US_LOOKON							= 0x04		--旁观状态
yl.US_PLAYING					 		= 0x05		--游戏状态
yl.US_OFFLINE							= 0x06		--断线状态

yl.INVALID_TABLE						= 65535
yl.INVALID_CHAIR						= 65535
yl.INVALID_ITEM							= 65535
yl.INVALID_USERID						= 0			--无效用户
yl.INVALID_BYTE                         = 255
yl.INVALID_WORD                         = 65535

yl.GENDER_FEMALE						= 0				--女性性别
yl.GENDER_MANKIND						= 1				--男性性别

yl.GAME_GENRE_GOLD						= 0x0001		--金币类型
yl.GAME_GENRE_SCORE						= 0x0002		--点值类型
yl.GAME_GENRE_MATCH						= 0x0004		--比赛类型
yl.GAME_GENRE_EDUCATE					= 0x0008		--训练类型
yl.GAME_GENRE_PERSONAL 					= 0x0010 		-- 约战类型

yl.SERVER_GENRE_PASSWD					= 0x0002 		-- 密码类型

yl.SR_ALLOW_AVERT_CHEAT_MODE			= 0x00000040	--隐藏信息

yl.UR_OPEN_TRANSFER                     = 0x00000040    -- 开放转账

yl.LEN_GAME_SERVER_ITEM					= 183 +68			--房间长度
--yl.LEN_GAME_SERVER_ITEM					= 177			--房间长度
yl.LEN_TASK_PARAMETER					= 813			--任务长度
yl.LEN_TASK_STATUS						= 5             --任务长度

yl.LEN_MD5								= 33			--加密密码
yl.LEN_ACCOUNTS							= 32			--帐号长度
yl.LEN_NICKNAME							= 32			--昵称长度
yl.LEN_PASSWORD							= 33			--密码长度
yl.LEN_USER_UIN							= 33
yl.LEN_QQ                               = 16            --Q Q 号码
yl.LEN_EMAIL                            = 33            --电子邮件
yl.LEN_COMPELLATION 					= 16			--真实名字
yl.LEN_SEAT_PHONE                       = 33            --固定电话
yl.LEN_MOBILE_PHONE                     = 12            --移动电话
yl.LEN_PASS_PORT_ID                     = 19            --证件号码
yl.LEN_COMPELLATION                     = 16            --真实名字
yl.LEN_DWELLING_PLACE                   = 128           --联系地址
yl.LEN_UNDER_WRITE                      = 32            --个性签名
yl.LEN_PHONE_MODE                       = 21            --手机型号
yl.LEN_SERVER                           = 32            --房间长度
yl.LEN_TRANS_REMARK						= 32			--转账备注
yl.LEN_TASK_NAME						= 64			--任务名称
yl.LEN_WEEK                             = 7
yl.LEN_DEVICE_TOKEN                     = 65            --绑定标志长度
yl.LEN_FACE_URL                         = 500           --头像链接长度

yl.LEN_MACHINE_ID						= 33			--序列长度
yl.LEN_USER_CHAT						= 128			--聊天长度
yl.SOCKET_TCP_BUFFER					= 16384			--网络缓冲

ylSUB_CM_SYSTEM_MESSAGE					= 1				--系统消息
ylSUB_CM_ACTION_MESSAGE					= 2				--动作消息

yl.SMT_CHAT								= 0x0001		--聊天消息
yl.SMT_EJECT							= 0x0002		--弹出消息
yl.SMT_GLOBAL							= 0x0004		--全局消息
yl.SMT_PROMPT							= 0x0008		--提示消息
yl.SMT_TABLE_ROLL						= 0x0010		--滚动消息

yl.SMT_CLOSE_ROOM						= 0x0100		--关闭房间
yl.SMT_CLOSE_GAME						= 0x0200		--关闭游戏
yl.SMT_CLOSE_LINK						= 0x0400		--中断连接
yl.SMT_CLOSE_INSURE						= 0x0800		--关闭银行

--货币类型
yl.CONSUME_TYPE_GOLD					= 0x01			--游戏币
yl.CONSUME_TYPE_USEER_MADEL				= 0x02			--元宝
yl.CONSUME_TYPE_CASH					= 0x03			--游戏豆
yl.CONSUME_TYPE_LOVELINESS				= 0x04			--魅力值

--发行范围
yl.PT_ISSUE_AREA_PLATFORM				= 0x01			--大厅道具（大厅可以使用）
yl.PT_ISSUE_AREA_SERVER					= 0x02			--房间道具（在房间可以使用）
yl.PT_ISSUE_AREA_GAME					= 0x04			--游戏道具（在玩游戏时可以使用）
--喇叭物品
yl.LARGE_TRUMPET                        = 306           --大喇叭id
yl.SMALL_TRUMPET                        = 307           --小喇叭id

--赠送目标类型
yl.PRESEND_NICKNAME						= 0
yl.PRESEND_GAMEID						= 1

--notifycation
yl.RY_USERINFO_NOTIFY					= "ry_userinfo_notify"		-- 玩家信息更新通知
yl.RY_MSG_USERHEAD						= 101						-- 更新用户头像
yl.RY_MSG_USERWEALTH					= 102						-- 更新用户财富
yl.RY_MSG_USERIDENTIFY                  = 103                       -- 实名认证

yl.RY_MSG_USERRECHARGE					= 104						-- 更新用户支付结果

yl.RY_FRIEND_NOTIFY                     = "ry_friend_notify"        --好友更新
yl.RY_MSG_FRIENDDEL                     = 101                       --好友删除

yl.TRUMPET_COUNT_UPDATE_NOTIFY			= "ry_trumpet_count_update" --喇叭数量更新

yl.RY_JFTPAY_NOTIFY						= "ry_jftpay_notify"		--竣付通支付后台切换通知

yl.RY_NEARUSER_NOTIFY                   = "ry_nearuser_notify"      --附近玩家信息获取
yl.RY_IMAGE_DOWNLOAD_NOTIFY             = "ry_image_download_notify"--图片下载结束

yl.CLIENT_NOTIFY                        = appdf.CLIENT_NOTIFY       -- 客户端通知
yl.CLIENT_MSG_TAKE_SCREENSHOT           = appdf.CLIENT_MSG_TAKE_SCREENSHOT -- 截屏事件
yl.CLIENT_MSG_HTTP_WEALTH               = appdf.CLIENT_MSG_TAKE_SCREENSHOT + 1 -- http请求用户财富
yl.CLIENT_MSG_SYSTEMINFO                = appdf.CLIENT_MSG_TAKE_SCREENSHOT + 2 -- 系统信息
yl.CLIENT_MSG_BACKGROUND_ENTER          = appdf.CLIENT_MSG_TAKE_SCREENSHOT + 3 -- 客户端从后台切换回来

yl.RY_VOICE_NOTIFY                      = "ry_game_voice_notify"    --录音监听
yl.RY_MSG_VOICE_START                   = 201                       --录音开始
yl.RY_MSG_VOICE_END                     = 202                       --录音结束

--分享配置
yl.SocialShare =
{
	title 								= "游戏大厅", --@share_title_social
	content 							= "来自游戏大厅的分享", --@share_content_social
	url 								= yl.HTTP_URL
}

-- 分享错误代码
yl.ShareErrorCode = 
{
    NOT_CONFIG                          = 1
}

--微信配置定义
yl.WeChat = 
{
	AppID 								= "wxed452f3dd725aa19",         --@wechat_appid_wx
	AppSecret 							= "08042a52acd4e6b669b0c8faed3ba956", --@wechat_secret_wx
	-- 商户id
	PartnerID 							= "", --@wechat_partnerid_wx
	-- 支付密钥					        
	PayKey 								= "", --@wechat_paykey_wx
	URL 								= yl.HTTP_URL,
}

--支付宝配置
yl.AliPay = 
{
	-- 合作者身份id
	PartnerID							= " ", --@alipay_partnerid_zfb
	-- 收款支付宝账号						
	SellerID							= " ", --@alipay_sellerid_zfb
	-- rsa密钥
	RsaKey								= " ", --@alipay_rsa_zfb
	NotifyURL							= yl.HTTP_URL .. "/Notify/Alipay.aspx",
	-- ios支付宝Schemes
	AliSchemes							= "SZCYAliPay", --@alipay_schemes_zfb
}

--竣付通配置
yl.JFT =
{
	--商户支付密钥
	PayKey 								= " ", --@jft_paykey_jtpay
	--商户id											
	PartnerID 							= " ", --@jft_partnerid_jtpay
	--token												
	TokenURL							= "http://api.jtpay.com/jft/sdk/token/", --@jft_tokenurl_jtpay
	--后台通知url
	NotifyURL							= yl.HTTP_URL .. "/Pay/JFTAPP/Notify.aspx",
	--appid				
	JftAppID							= " ", --@jft_appid_jtpay								
	JftAesKey							= " ", --@jft_aeskey_jtpay
	JftAesVec 							= " ", --@jft_aesvec_jtpay
}

--高德配置
yl.AMAP = 
{
	-- 开发KEY
	AmapKeyIOS							= " ", --@ios_devkey_amap
	AmapKeyAndroid						= " ", --@android_devkey_amap
}

yl.PLATFORM_WX							= 5				--微信平台

--第三方平台定义(同java/ios端定义值一致)
yl.ThirdParty = 
{
	WECHAT 								= 0,	-- 微信
	WECHAT_CIRCLE						= 1,	-- 朋友圈
	ALIPAY								= 2,	-- 支付宝
	JFT								 	= 3,	-- 俊付通
	AMAP 								= 4,	-- 高德地图
	IAP 							 	= 5,	-- ios iap
    SMS                                 = 6,    -- 分享到短信
    LQ                                  = 7,    -- 零钱支付
}
--平台id列表(服务器登陆用)
yl.PLATFORM_LIST = {}
yl.PLATFORM_LIST[yl.ThirdParty.WECHAT]	= 5

yl.MAX_INT                              = 2 ^ 15
--是否动态加入
yl.m_bDynamicJoin                       = false
--设备类型
yl.DEVICE_TYPE_LIST = {}
yl.DEVICE_TYPE_LIST[cc.PLATFORM_OS_WINDOWS] = 0x01
yl.DEVICE_TYPE_LIST[cc.PLATFORM_OS_ANDROID] = 0x11
yl.DEVICE_TYPE_LIST[cc.PLATFORM_OS_IPHONE] 	= 0x31
yl.DEVICE_TYPE_LIST[cc.PLATFORM_OS_IPAD] 	= 0x41

cc.exports.M_PI = 3.14159265358979323846 
cc.exports.M_PI_2 = 1.57079632679489661923

local poker_data = 
{
	0x00,
	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, -- 方块
    0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, -- 梅花
    0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, -- 红桃
    0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, -- 黑桃
    0x4E, 0x4F
}
-- 逻辑数值
yl.POKER_VALUE = {}
-- 逻辑花色
yl.POKER_COLOR = {}
-- 纹理花色
yl.CARD_COLOR = {}
function yl.GET_POKER_VALUE()
	for k,v in pairs(poker_data) do
		yl.POKER_VALUE[v] = math.mod(v, 16)
		yl.POKER_COLOR[v] = bit:_and(v , 0XF0)
		yl.CARD_COLOR[v] = math.floor(v / 16)
	end
end
yl.GET_POKER_VALUE()

-- 界面z轴定义
function yl.GET_ZORDER_ENUM( nStart, nStep, keyTable )
    local enStart = 1
    if nil ~= nStart then
        enStart = nStart
    end

    local args = keyTable
    local enum = {}
    for i=1,#args do
        enum[args[i]] = enStart
        enStart = enStart + nStep
    end

    yl.ZORDER = enum
end
local zOrderTab = 
{
    "Z_FILTER_LAYER",       -- 触摸过滤
    "Z_AD_WEBVIEW",         -- 首页广告
    "Z_HELP_WEBVIEW",       -- 帮助界面(网页对话框)
    "Z_HELP_BUTTON",        -- 通用帮助按钮
    "Z_TARGET_SHARE",       -- 通用分享选择层
    "Z_VOICE_BUTTON",       -- 通用语音按钮
    "Z_INVITE_DLG",         -- 邀请对话框
}

--判断是否对象
function yl.isObject(obj)
    return (obj.__cname ~= nil)
end

--获取设备类型
function yl.getDeviceType()
    local reg_client_type = 0
    if device.platform  == "android" then
        reg_client_type = 1
    elseif device.platform  == "ios" then
        reg_client_type = 2
    elseif device.platform  == "windows" then
        reg_client_type = 3
    end
    
    return reg_client_type
end

function yl.getLevelDescribe(level)
	local lLevelDesc={ "务农","佃户","雇工","作坊主","农场主","地主","大地主","财主","富翁","大富翁","小财神","大财神","赌棍","赌侠","赌王","赌圣","赌神","职业赌神"}
    if level > #lLevelDesc then
        level = #lLevelDesc
    end
	return lLevelDesc[level]
end

--获得本地字符串
function yl.getLocalString(key)
   return cc.exports.Localization_cn[key]
end

--中国电信号段:133、149、153、173、177、180、181、189、199
--中国联通号段:130、131、132、145、155、156、166、175、176、185、186
--中国移动号段:134(0-8)、135、136、137、138、139、147、150、151、152、157、158、159、178、182、183、184、187、188、198
--其他号段
--  电信：1700、1701、1702
--  移动：1703、1705、1706
--  联通：1704、1707、1708、1709、171
--检查是否是手机号格式
function yl.CheckIsMobile(str)
    local s = string.match(str,"[1][3,4,5,6,7,8,9]%d%d%d%d%d%d%d%d%d")
    return s == str
end

-- 纯数字组成
function yl.string_number(str)
    for index=1, #str do
        local num = string.sub(str, index, index)
        if (num ~= '0' and num ~= '1' and
            num ~= '2' and num ~= '3' and
            num ~= '4' and num ~= '5' and
            num ~= '6' and num ~= '7' and
            num ~= '8' and num ~= '9' and 
            num ~= '.') then
            return false
        end
    end
    return true
end

-- 纯数字组成
function yl.string_number2(str)
    for index=1, #str do
        local num = string.sub(str, index, index)
        if (num ~= '0' and num ~= '1' and
            num ~= '2' and num ~= '3' and
            num ~= '4' and num ~= '5' and
            num ~= '6' and num ~= '7' and
            num ~= '8' and num ~= '9') then
            return false
        end
    end
    return true
end

function yl.getCharLength(str)
    str = str or ""
    local strLength = 0
    local len = string.len(str)
    while str do
        local fontUTF = string.byte(str,1)

        if fontUTF == nil then
            break
        end
        --lua中字符占1byte,中文占3byte
        if fontUTF > 127 then 
            local tmp = string.sub(str,1,3)
            strLength = strLength+2
            str = string.sub(str,4,len)
        else
            local tmp = string.sub(str,1,1)
            strLength = strLength+1
            str = string.sub(str,2,len)
        end
    end
    return strLength
end

--检查是否包含中文
function yl.check_include_chinese(str)
    for i=1, string.len(str) do
        local ch = string.byte(str, i)
        if ch > 127 then
            return true
        end
    end
    return false
end

-- 检查是否都是中文
function yl.check_string_chinese(str)
    for i=1, string.len(str) do
        local ch = string.byte(str, i)
        if not (ch == 46) then
            if ch <= 127 then
                return false
            end
        end

        --[[if(stru16Str[i] == u'·') then
            continue;
        end
        if(!StringUtils::isCJKUnicode(stru16Str[i]))
            return false;
        end]]
    end
    return true;
end

-- 邮箱格式验证
function yl.check_email(strEmail)
    local nLen = string.len(strEmail)
    if nLen < 5 then
        return false;
    end

    local ch = string.byte(strEmail, 1)
    if not ((ch >= 97 and ch <= 122) or (ch >= 65 and ch <= 90) or (ch >= 48 and ch <= 57))  then
    -- if !((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9')) then
        return false;
    end

    local atCount, atPos, dotCount = 0, 0, 0;
    for i=2, nLen do
        ch = string.byte(strEmail, i)
        if not ((ch >= 97 and ch <= 122) or (ch >= 65 and ch <= 90) or (ch >= 48 and ch <= 57) or
           (ch == 95) or (ch == 45) or (ch == 46) or (ch == 64) )  then
        -- if (!((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9') || (ch == '_') || (ch == '-') || (ch == '.') || (ch == '@')))
            return false;
        end
        if ch == 64 then
        -- if (ch == '@')
            atCount = atCount+1;
            atPos = i;
        elseif (atCount>0) and (ch == 46) then
        -- else if ( (atCount>0) && (ch == '.') )
            dotCount = dotCount+1;
        end
    end
    if (ch == 46 or ch == 64) then
    -- if (ch == '.' || ch == '@') then
        return false;
    end
    
    if (atCount ~= 1) or (dotCount < 1) or (dotCount > 3)  then
        return false;
    end

    -- 查找 "@." / ".@"
    for i=2, nLen do
        ch = string.byte(strEmail, i)
        if ch == 64 then -- '@'
            if i+1 < nLen then
                local tempCh = string.byte(strEmail, i+1)
                if tempCh == 46 then
                    return false
                end
            end
        elseif ch == 46 then -- '.'
            if i+1 < nLen then
                local tempCh = string.byte(strEmail, i+1)
                if tempCh == 64 then
                    return false
                end
            end
        end
    end

    --[[if ((str.find("@.") ~= str.npos) or (str.find(".@") ~= str.npos)) then
        return false;
    end]]

    return true;
end

function yl.isUnicodeValid(ch)
    --print("------ch:"..ch)
    if (ch >= 48 and ch <= 57) or (ch >= 97 and ch <= 122) or (ch >= 65 and ch <= 90) or (ch == 95) then
    -- if ( (ch >= u'0' && ch <= u'9') || (ch >= u'a' && ch <= u'z') || (ch >= u'A' && ch <= u'Z') || ch == u'_' )
        return true;
    end
    
     --空格
    if ch == 32 then
        return false
    end 

    if ch == 46 then
    -- if (ch == u'.')
        return true;
    end
    
    return ch > 127;
end
-- 获取注册和修改昵称，保证昵称合法性
function yl.isNickVaild(str)
    for i=1, string.len(str) do
        local ch = string.byte(str, i)
        if not yl.isUnicodeValid(ch) then
            return false;
        end
    end
    --iOS 检测中文空格 连续的226 128 134
    if device.platform == "ios" then
        local index = 0
        for i=1, string.len(str) do
            local ch = string.byte(str, i)
            if ch == 226 or ch == 128 or ch == 134 then
                if ch == 226 then
                    index = 1
                end
                if index == 1 and ch == 128 then
                    index = 2
                end
                if index == 2 and ch == 134 then
                    return false
                end
            else
                index = 0
            end
        end
    end

    return true;
end

-- 纯字母组成
function yl.string_word(str)
    local result = false
    for i=1, #str do
        local ch = string.byte(str, i)
        if (ch >= 97 and ch <= 122) or (ch >= 65 and ch <= 90) then
        --if((*str>='a'&&*str<='z') || (*str>='A'&&*str<='Z'))
            result = true
        else
            result = false
            break
        end
    end
    return result
end

function yl.check_paypassword(strPassWord)
    -- 为纯数字或纯字母
    if yl.string_number(strPassWord) or yl.string_word(strPassWord) then
        return false
    end
    
    local r1 = false
    -- 检查必须同时包含数字和字母
    for i=1,#strPassWord do
        local ch = string.byte(strPassWord, i)
        if (ch >= 97 and ch <= 122) or (ch >= 65 and ch <= 90) then
        -- if((*str1>='a'&&*str1<='z') || (*str1>='A'&&*str1<='Z'))
            r1 = true
            break
        end
    end
    local r2 = false
    for i=1,#strPassWord do
        local ch = string.byte(strPassWord, i)
        if (ch >= 48 and ch <= 57) then
        --if(((*str2)>='0' && (*str2)<='9'))
            r2 = true
            break
        end
    end
    
    local result = r1 and r2
    return result
end

--u_start：截取字符串开始位置
--u_end：截取字符串结束位置
function yl.utf8_sub(str, u_start, u_end)
    local temp = ""
    local n = string.len(str)
    local tempLen = 0
    local offset = 0
    local i = 1
    local asi
    local b, e
    while i <= n do
        if not b and offset >= u_start then
            b = i
        end

        asi = string.byte(str, i)
        local dis = 1
        local diffI = 1
        if asi >= 0xF0 then 
            diffI =  4
            dis = 2
        elseif asi >= 0xE0 then 
            diffI =  3
            dis = 2
        elseif asi >= 0xC0 then 
            diffI =  2
            dis = 2
--        elseif (asi >= 0x30 and asi <= 0x39) then
--            i = i + 1
        else

        end

        offset = offset + dis
        if not e and offset > u_end then
            e = i - 1
            break
        end
        i = i + diffI
    end

    if not b then 
        return str,false
    end

    if not e then 
        e = n
    end
    temp = string.sub(str, b, e)
    return temp, (n - string.len(temp)) > 0
end
--[[
    --用户昵称
    --nlen 需要显示的字符串长度 (以字母长度为准) 
    eg: nLen = 8 / 游客520000210 --> 游客5200.. 
        nLen = 8 / 520000210 --> 52000021..
--]]
function yl.getDisplayNickName( strNickName, nLen, isDianEnd)
    if not strNickName or strNickName == "" then return end
    local str, isWithDian = yl.utf8_sub(strNickName, 0, nLen)
    if (isDianEnd and isWithDian) then
	    str = str .. ".."
    end
    return str
end

 function yl.readJsonFileByFileName(fileName)
    local filePath = fileName
    local strPath   = cc.FileUtils:getInstance():fullPathForFilename(filePath)
    local jsonStr = cc.FileUtils:getInstance():getStringFromFile(strPath)
    if not jsonStr or jsonStr ~= "" then
        return cjson.decode(jsonStr)
    end
end

 --游戏种类
 yl.GameClassifyType = {

        --GAME_CLASSIFY_MAIN      = 1,        --推荐游戏
        GAME_CLASSIFY_ALL       = 1,       --所有游戏
        GAME_CLASSIFY_ARCADE    = 2,        --多人游戏
        GAME_CLASSIFY_FISH      = 3,        --捕鱼游戏
        GAME_CLASSIFY_TIGER     = 4,        --街机游戏
        GAME_CLASSIFY_CARD      = 5,        --对战游戏

        GAME_CLASSIFY_CASUAL    = 6,        --休闲

        
}

yl.vecReleaseAnim = 
{
    "hall/effect/jiujijin_1/jiujijin_1.ExportJson",
    --"hall/effect/shangcheng/shangcheng.ExportJson",

    "hall/effect/jiazai_1/jiazai_1.ExportJson",
    "hall/effect/kuaisukaishi/kuaisukaishi.ExportJson",
    "hall/effect/pay_loading/pay_loading.ExportJson",
    "hall/effect/hall_animation/hall_animation.ExportJson",
    "public/effect/choumaxuanzhongguangxiao_shoujiban/choumaxuanzhongguangxiao_shoujiban.ExportJson",
    "hall/effect/naozhong/naozhong.ExportJson",
    "hall/effect/naozhong_new/naozhong_new.ExportJson",
    "hall/effect/shaoguangAnimation/shaoguangAnimation.ExportJson",
    "hall/effect/gamekind_effect/gamekind_effect.ExportJson",
}

yl.vecReleasePlist = 
{
    { "hall/plist/gui-hall.plist",              "hall/plist/gui-hall.png",         },
    { "hall/image/gui-apple-shop.plist",        "hall/image/gui-apple-shop.png",   },
    { "hall/image/gui-room.plist",              "hall/image/gui-room.png",         },
    { "hall/plist/gui-bank.plist",              "hall/plist/gui-bank.png",         },
    { "hall/plist/gui-broadcast.plist",         "hall/plist/gui-broadcast.png",    },
    { "hall/plist/gui-dialog.plist",            "hall/plist/gui-dialog.png",       },
    { "hall/plist/gui-gui-exchange.plist",      "hall/plist/gui-gui-exchange.png", },
    { "hall/plist/gui-help.plist",              "hall/plist/gui-help.png",         },
    { "hall/plist/gui-login.plist",             "hall/plist/gui-login.png",        },
    { "hall/plist/gui-rank.plist",              "hall/plist/gui-rank.png",         },
    { "hall/plist/gui-spread.plist",            "hall/plist/gui-spread.png",       },
    { "hall/plist/gui-userinfo.plist",          "hall/plist/gui-userinfo.png",     },
    { "hall/plist/gui-gamekind.plist",          "hall/plist/gui-gamekind.png"      },
    { "hall/image/gui-setting.plist",           "hall/image/gui-setting.png",      },
}


function yl.setDefault(tb, defaultValue)
    local mt = {__index = function () 
        return defaultValue
    end, }
    setmetatable(tb, mt)
end

--定义获取毫秒时间
local strDebug = ""
local ok, socket = pcall(function()
    return require("socket")
end)
if type(gettimems) == "function" then
    cc.exports.gettime = function()
        return gettimems()
    end
    strDebug = "Use Get Time Function: Utils:gettime()"
elseif ok and socket then
    cc.exports.gettime = function()
        return socket.gettime()
    end
    strDebug = "Use Get Time Function: socket.gettime()"
else
    cc.exports.gettime = function()
        return os.clock()
    end
    strDebug = "Use Get Time Function: os.clock()"
end
--显示FPS
cc.Director:getInstance():setDisplayStats(false)

--@brief 切割字符串，并用“...”替换尾部
--@param sName:要切割的字符串
--@return nMaxCount，字符串上限,中文字为2的倍数
--@param nShowCount：显示英文字个数，中文字为2的倍数,可为空
--@note 函数实现：截取字符串一部分，剩余用“...”替换
function yl.GetShortName(sName, nMaxCount, nShowCount)
    if sName == nil or nMaxCount == nil then
        return
    end
    local sStr = sName
    local tCode = {}
    local tName = {}
    local nLenInByte = #sStr
    local nWidth = 0
    if nShowCount == nil then
       nShowCount = nMaxCount - 3
    end
    for i=1,nLenInByte do
        local curByte = string.byte(sStr, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local char = nil
        if byteCount > 0 then
            char = string.sub(sStr, i, i+byteCount-1)
            i = i + byteCount -1
        end
        if byteCount == 1 then
            nWidth = nWidth + 1
            table.insert(tName,char)
            table.insert(tCode,1)
            
        elseif byteCount > 1 then
            nWidth = nWidth + 2
            table.insert(tName,char)
            table.insert(tCode,2)
        end
    end
    
    if nWidth > nMaxCount then
        local _sN = ""
        local _len = 0
        for i=1,#tName do
            _sN = _sN .. tName[i]
            _len = _len + tCode[i]
            if _len >= nShowCount then
                break
            end
        end
        sName = _sN .. "..."
    end
    return sName
end

function yl.getDisplayNickNameInGame(name, maxLen, showLen)
    
    return yl.GetShortName(name, maxLen or 6, showLen or 6)
end

-- 按长度截取字符串
-- isDianEnd 末尾是否加 “..”
-- nLen 为显示实际长度，一个汉字两个字节,字母数字一个字节
function yl.getDisplayString(str, fontWidth, allWidth, strDian)

    local strArr = yl.utf8SubArray(str)
    local nCount = 1
    local cw = 0

    local allCount = table.nums(strArr)
    local strLength = 0
    --fix 先计算自己的长度是否超过最大值，没超过就return
    for i = 1, allCount do
        local s = strArr[i].str
        if string.byte(s, 1) > 127 then 
            strLength = strLength + fontWidth
        else
            strLength = strLength + fontWidth/2
        end
    end
    if strLength <= allWidth then
        return str
    end

    --加上点的长度
    for i=1, string.len(strDian) do
        cw = cw + fontWidth/2
    end
    local isOut = false
    while nCount < allCount do
        local s = strArr[nCount].str
        if string.byte(s, 1) > 127 then 
            cw = cw + fontWidth
        else
            cw = cw + fontWidth/2
        end 
        if cw > allWidth then 
            isOut = true
            --为了字符长度始终不大于显示长度,-1
            nCount = nCount - 1
            break
        end
        nCount = nCount +1 
    end 

    local temp = str
    if isOut then
        temp = ""
        for i=1, nCount  do
            temp = temp..strArr[i].str
        end
        if string.len(strDian) > 0 then
            temp = temp..strDian
        end
    end
    return temp
end

function yl.utf8SubArray(str)
    if not str or str == "" then return {} end
    local temp = str
    local tempStr = ""
    local tempArr = {}
    local n = string.len(str)
    local offset = 1
    local i = 1
    local asi
    while i <= n do
        asi = string.byte(str, i)
        if asi >= 0xF0 then 
            i = i + 4
        elseif asi >= 0xE0 then 
            i = i + 3
        elseif asi >= 0xC0 then 
            i = i + 2
        else
            i = i + 1
        end
        local arr = {}
        arr.str = string.sub(temp, offset, i-1)
        arr.index = i
        table.insert(tempArr, arr)
        offset = i
        temp = str
    end
    return tempArr
end

function onOpenLayer(layer, shadow, root)
    if layer then
        local scale1 = 0.75
        local scale2 = 1.0
        local time = 0.3
        local scaleto = cc.EaseBackOut:create(cc.ScaleTo:create(time, scale2))
        layer:setScale(scale1)
        layer:runAction(scaleto)
    end

    if shadow then
        local opacity1 = 100
        local opacity2 = 255
        local time = 0.3
        local fadeto = cc.FadeTo:create(time, opacity2)
        shadow:setOpacity(opacity1)
        shadow:runAction(fadeto)
    end
end

function onCloseLayer(layer, shadow, root)
    
    if layer and root then
        local scale1 = 1.0
        local scale2 = 0.5
        local time = 0.3
        local scaleto = cc.EaseBackIn:create(cc.ScaleTo:create(time, scale2))
        local close = cc.CallFunc:create(function() root:removeFromParent() end)
        local seq = cc.Sequence:create(scaleto, close)
        layer:setScale(1.0)
        layer:runAction(seq)
    end

    if shadow then
        local opacity1 = 255
        local opacity2 = 50
        local time = 0.3
        local fadeto = cc.FadeTo:create(time, opacity2)
        shadow:setOpacity(opacity1)
        shadow:runAction(fadeto)
    end
end

yl.GET_ZORDER_ENUM( yl.MAX_INT, -1, zOrderTab )