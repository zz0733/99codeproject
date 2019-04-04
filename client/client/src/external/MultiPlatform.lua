--
-- Author: zhong
-- Date: 2016-07-29 17:10:55
--

--[[
* 跨平台管理
* tip: require 该模块时路径要统一 "client.src.external.MultiPlatform"
]]

local MultiPlatform = class("MultiPlatform")

local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var
local targetPlatform = cc.Application:getInstance():getTargetPlatform()

--平台
local PLATFORM = {}
PLATFORM[cc.PLATFORM_OS_ANDROID] = appdf.EXTERNAL_SRC .. "platform.Bridge_android"
PLATFORM[cc.PLATFORM_OS_IPHONE] = appdf.EXTERNAL_SRC .. "platform.Bridge_ios"
PLATFORM[cc.PLATFORM_OS_IPAD] = appdf.EXTERNAL_SRC .. "platform.Bridge_ios"
PLATFORM[cc.PLATFORM_OS_MAC] = appdf.EXTERNAL_SRC .. "platform.Bridge_ios"

function MultiPlatform:ctor()
	self.sDefaultTitle = ""
	self.sDefaultContent = ""
	self.sDefaultUrl = ""
end

--实现单例
MultiPlatform._instance = nil
function MultiPlatform:getInstance(  )
	if nil == MultiPlatform._instance then
		print("new instance")
		MultiPlatform._instance = MultiPlatform:create()
	end
	return MultiPlatform._instance
end

function MultiPlatform:getSupportPlatform()
	local plat = targetPlatform
	--ios特殊处理
	if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then
		plat = cc.PLATFORM_OS_IPHONE
	end

	return plat
end

--获取设备id
function MultiPlatform:getMachineId()
	local plat = self:getSupportPlatform()

	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).getMachineId then
		return g_var(PLATFORM[plat]).getMachineId( )
	else
		print("unknow platform ==> " .. plat)
		return "A501164B366ECFC9E249163873094D51"
	end	
end

--获取设备ip
function MultiPlatform:getClientIpAdress()
	local plat = self:getSupportPlatform()

	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).getMachineId then
		return g_var(PLATFORM[plat]).getClientIpAdress( )
	else
		print("unknow platform ==> " .. plat)
		return "192.168.1.1"
	end	
end

--获取外部存储可写文档目录
function MultiPlatform:getExtralDocPath()
	local plat = self:getSupportPlatform()
	local path = device.writablePath
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).getExtralDocPath then
		path = g_var(PLATFORM[plat]).getExtralDocPath( )
	else
		print("undefined funtion or unknow platform ==> " .. plat)
	end	

	if false == cc.FileUtils:getInstance():isDirectoryExist(path) then
		cc.FileUtils:getInstance():createDirectory(path)
	end
	return path
end

-- 选择图片
-- callback 回调函数
-- needClip 是否需要裁减图片
function MultiPlatform:triggerPickImg( callback, needClip )
	local plat = self:getSupportPlatform()

	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).triggerPickImg then
		g_var(PLATFORM[plat]).triggerPickImg( callback, needClip )
	else
		print("unknow platform ==> " .. plat)
	end	
end

--配置第三方平台
function MultiPlatform:thirdPartyConfig(thirdparty, configTab)
	configTab = configTab or {}

	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).thirdPartyConfig then
		g_var(PLATFORM[plat]).thirdPartyConfig( thirdparty, configTab )
	else
		print("unknow platform ==> " .. plat)
	end	
end

--分享相关
function MultiPlatform:configSocial(socialTab)
	socialTab = socialTab or {}
	socialTab.title = socialTab.title or ""
	socialTab.content = socialTab.content or ""
	socialTab.url = socialTab.url or ""

	self.sDefaultTitle = socialTab.title
	self.sDefaultContent = socialTab.content
	self.sDefaultUrl = socialTab.url

	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).configSocial then
		g_var(PLATFORM[plat]).configSocial( socialTab )
	else
		print("unknow platform ==> " .. plat)
	end	
end

--第三方登陆
function MultiPlatform:thirdPartyLogin(thirdparty, callback)
	if nil == callback or type(callback) ~= "function" then
		return false, "need callback function"
	end

	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).thirdPartyLogin then
--		if isDebug() and plat == cc.PLATFORM_OS_ANDROID then
--			callback(cjson.encode({
--			unionid = MultiPlatform:getInstance():getMachineId(),
--			screen_name = "精华",
--			profile_image_url = yl.HTTP_URL .. "/image/custom.png",
--			gender = 1
--		}))
--		else
--			return g_var(PLATFORM[plat]).thirdPartyLogin( thirdparty, callback )
--		end
        return g_var(PLATFORM[plat]).thirdPartyLogin( thirdparty, callback )
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		callback(cjson.encode({
			openid = "NBC4ABC45BC45ABC45ABC45ABC45ER",
			unionid = "NBC4ABC45BC45ABC45ABC45ABC45ER",
			screen_name = "大神4444",
			--openid = "zlefd9a6e00b56939a7177cba25edcescgd",
			--unionid = "Bbfd9a6e00b56939a7177cba25edceff",
			--screen_name = "aaB",
--			unionid = "Cefd9a6e00b56939a7177cba25edcesa",
--			screen_name = "大神C",
--			unionid = "F4D6E33704692EB606943800E64772E5",
--			screen_name = "大神F3",
--			unionid = "D1fd9a6e00b56939a7177cba25edcesb",
--			screen_name = "大神D",
			--unionid = "aafd9a6e00b56939a7177cba25edcesa",
			--screen_name = "大神E",
--			unionid = "lk3d9a6e00b56939a7177cba25edcesc",
--			screen_name = "大神lj",
--			unionid = "KkC4ABC45BC45ABC45ABC45ABC45ER",
--			screen_name = "大神C",
--			unionid = "EeC4ABC45BC45ABC45ABC45ABC45ER",
--			screen_name = "大神K",
--			unionid = "o9ZMqwg7kYlwSSyqakebmnEYiiUE",
--			screen_name = "大神ccK",
--			 unionid = "LBC4ABC45BC45ABC45ABC45ABC45ER",
--			 screen_name = "大神L",
			-- unionid = "MBC4ABC45BC45ABC45ABC45ABC45ER",
			-- screen_name = "大神M",
			-- unionid = "NBC4ABC45BC45ABC45ABC45ABC45ER",
			-- screen_name = "大神N",
			-- unionid = "OBC4ABC45BC45ABC45ABC45ABC45ER",
			-- screen_name = "大神O",
			-- unionid = "PBC4ABC45BC45ABC45ABC45ABC45ER",
			-- screen_name = "大神P",
			-- unionid = "WebUserNin201707181143025361",
			-- screen_name = "大神WEB",
			-- unionid = "KBC4ABC45BC45ABC45ABC45ABC45EA",
			-- screen_name = "大神WEB",
			-- unionid = "WebUserNin201707211001241309",
			-- screen_name = "大神WEBC",
			-- unionid = "JQURUIHYZBSHTRKILTJSKBJCDOJWL",
			-- screen_name = "大神WEBD",
			-- unionid = "QBC4ABC45BC45ABC45ABC45ABC45ER",
			-- screen_name = "大神Q",
			-- unionid = "RBC4ABC45BC45ABC45ABC45ABC45ER",
			-- screen_name = "大神R",
			-- unionid = "SBC4ABC45BC45ABC45ABC45ABC45ER",
			-- screen_name = "大神S",
			-- unionid = "UBC4ABC45BC45ABC45ABC45ABC45ER",
			-- screen_name = "大神U",
			-- unionid = "VBC4ABC45BC45ABC45ABC45ABC45ER",
			-- screen_name = "大神V",
--			unionid = "WBC4ABC45BC45ABC45ABC45ABC45ER",
--			screen_name = "大神W",
			-- unionid = "WBCasdasd4ABC45BC45ABC45ABC45ABC45ER",
			-- screen_name = "大神Wdw",

			profile_image_url = yl.HTTP_URL .. "/image/custom.png",
			gender = "男"
		}))
		return true, msg
	end	
end

--分享
function MultiPlatform:startShare(callback)
	if nil == callback or type(callback) ~= "function" then
		return false, "need callback function"
	end
	-- 判断微信配置
	if yl.WeChat.AppID == "" or yl.WeChat.AppID == " " then
		local runScene = cc.Director:getInstance():getRunningScene()
		if nil ~= runScene then
			showToast(runScene, "分享失败, 错误代码:" .. yl.ShareErrorCode.NOT_CONFIG, 2, cc.c4b(250,0,0,255))
		end
		return false, "not config wechat"
	end

	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).startShare then
		return g_var(PLATFORM[plat]).startShare( callback )
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg		
	end	
end

--自定义分享
-- imgOnly 值为字符串 "true" 表示只分享图片
function MultiPlatform:customShare( callback, title, content, url, img, imgOnly )
	if nil == callback or type(callback) ~= "function" then
		return false, "need callback function"
	end
	-- 判断微信配置
	if yl.WeChat.AppID == "" or yl.WeChat.AppID == " " then
		local runScene = cc.Director:getInstance():getRunningScene()
		if nil ~= runScene then
			showToast(runScene, "分享失败, 错误代码:" .. yl.ShareErrorCode.NOT_CONFIG, 2, cc.c4b(250,0,0,255))
		end
		return false, "not config wechat"
	end

	title = title or self.sDefaultTitle
	content = content or self.sDefaultContent
	img = img or ""
	url = url or self.sDefaultUrl
	imgOnly = imgOnly or "false"

	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).customShare then
		return g_var(PLATFORM[plat]).customShare( title,content,url,img, imgOnly,callback )
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg		
	end
end

-- 分享到指定平台
function MultiPlatform:shareToTarget( target, callback, title, content, url, img, imgOnly )
	if nil == callback or type(callback) ~= "function" then
		return false, "need callback function"
	end
	-- 判断微信配置
	if yl.WeChat.AppID == "" or yl.WeChat.AppID == " " then
		local runScene = cc.Director:getInstance():getRunningScene()
		if nil ~= runScene then
			showToast(runScene, "分享失败, 错误代码:" .. yl.ShareErrorCode.NOT_CONFIG, 2, cc.c4b(250,0,0,255))
		end
		return false, "not config wechat"
	end

	title = title or self.sDefaultTitle
	content = content or self.sDefaultContent
	img = img or ""
	url = url or self.sDefaultUrl
	imgOnly = imgOnly or "false"

	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).shareToTarget then
		return g_var(PLATFORM[plat]).shareToTarget( target, title, content, url, img, imgOnly, callback )
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg		
	end
end

--第三方支付
--[[
payparam = 
{
	price,
	count,
	productname,
	orderid,
}
]]
function MultiPlatform:thirdPartyPay(thirdparty, payparamTab, callback)
	if nil == callback or type(callback) ~= "function" then
		return false, "need callback function"
	end
	payparamTab = payparamTab or {}

	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).thirdPartyPay then
		return g_var(PLATFORM[plat]).thirdPartyPay( thirdparty, payparamTab, callback )
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		callback(nil)	
		return false, msg
	end	
end

--竣付通获取支付列表
function MultiPlatform:getPayList(token, callback)
	if nil == callback or type(callback) ~= "function" then
		return false, "need callback function"
	end

	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).getPayList then
		return g_var(PLATFORM[plat]).getPayList( token, callback )
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		callback("")
		return false, msg		
	end
end

--第三方平台是否安装
function MultiPlatform:isPlatformInstalled(thirdparty)
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).isPlatformInstalled then
		return g_var(PLATFORM[plat]).isPlatformInstalled( thirdparty )
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg		
	end
end

--图片存储至系统相册
function MultiPlatform:saveImgToSystemGallery(filepath, filename)
	if false == cc.FileUtils:getInstance():isFileExist(filepath) then
		local msg = filepath .. " not exist"
		print(msg)
		return false, msg
	end
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).saveImgToSystemGallery then
		return g_var(PLATFORM[plat]).saveImgToSystemGallery( filepath, filename )
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg		
	end
end

-- 录音权限判断
function MultiPlatform:checkRecordPermission()
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).checkRecordPermission then
		return g_var(PLATFORM[plat]).checkRecordPermission( )
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg
	end
end

-- 请求单次定位
function MultiPlatform:requestLocation(callback)
	callback = callback or -1

	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).requestLocation then
		return g_var(PLATFORM[plat]).requestLocation(callback)
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		if type(callback) == "function" then
			callback("")
		end
		return false, msg
	end
end

-- 计算距离
function MultiPlatform:metersBetweenLocation( loParam )
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).metersBetweenLocation then
		return g_var(PLATFORM[plat]).metersBetweenLocation(loParam)
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg
	end
end

-- 请求通讯录
function MultiPlatform:requestContact(callback)
	callback = callback or -1

	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).requestContact then
		return g_var(PLATFORM[plat]).requestContact(callback)
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg
	end
end

-- 启动浏览器
function MultiPlatform:openBrowser( url )
	url = url or yl.HTTP_URL
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).openBrowser then
		return g_var(PLATFORM[plat]).openBrowser(url)
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg
	end
end

-- 复制到剪贴板
function MultiPlatform:copyToClipboard( msg )
	if type(msg) ~= "string" then
		print("复制内容非法")
		return 0, "复制内容非法"
	end
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).copyToClipboard then
		return g_var(PLATFORM[plat]).copyToClipboard(msg)
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return 0, msg
	end
end

-- 判断平台是否授权
function MultiPlatform:isAuthorized( thirdparty )
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).isAuthorized then
		return g_var(PLATFORM[plat]).isAuthorized( thirdparty )
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg		
	end
end

-- 删除平台授权
function MultiPlatform:delAuthorized( thirdparty, callback )
	callback = callback or -1
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).delAuthorized then
		return g_var(PLATFORM[plat]).delAuthorized( thirdparty, callback )
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg		
	end
end

-- 调用录音服务
function MultiPlatform:testRecordService()
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).testRecordService then
		return g_var(PLATFORM[plat]).testRecordService( )
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg		
	end
end

-- 网络是否可用
function MultiPlatform:isNetworkAvailable()
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).isNetworkAvailable then
		return g_var(PLATFORM[plat]).isNetworkAvailable()
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg		
	end
end

-- 跳转设置
function MultiPlatform:goToSetting()
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).goToSetting then
		return g_var(PLATFORM[plat]).goToSetting()
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return false, msg		
	end
end

-- 获取启动数据
function MultiPlatform:getLaunchData()
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).getLaunchData then
		return g_var(PLATFORM[plat]).getLaunchData()
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return ""		
	end
end

-- 获取粘贴板内容
function MultiPlatform:getCopyBoardData( callback )
	if type(callback) ~= "function" then
		return
	end
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).getCopyBoardData then
		return g_var(PLATFORM[plat]).getCopyBoardData(callback)
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return callback("")		
	end
end

-- 获取包名
function MultiPlatform:getClientPackageName()
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).getClientPackageName then
		return g_var(PLATFORM[plat]).getClientPackageName()
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return ""
	end
end

-- 获取设备token
function MultiPlatform:getDeviceToken()
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).getDeviceToken then
		return g_var(PLATFORM[plat]).getDeviceToken()
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return "91C6E897E346C74CE8D1DB0AC06E2C13"
	end
end

-- 拨打电话
function MultiPlatform:systemCall( szTel )
	local plat = self:getSupportPlatform()
	if nil ~= g_var(PLATFORM[plat]) and nil ~= g_var(PLATFORM[plat]).systemCall then
		return g_var(PLATFORM[plat]).systemCall(szTel)
	else
		local msg = "unknow platform ==> " .. plat
		print(msg)
		return 0, msg
	end
end

return MultiPlatform