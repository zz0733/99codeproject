--[[
  登录界面
      2015_12_03 C.P
      功能：登录/注册
--]]
appdf.req(appdf.CLIENT_SRC.."plaza.models.yl")
if not FixLayer then
	appdf.req(appdf.EXTERNAL_SRC .."FixLayer")
end
if not GlobalUserItem then
	appdf.req(appdf.CLIENT_SRC.."plaza.models.GlobalUserItem")
end
if not Hall_Events then
	appdf.req(appdf.EXTERNAL_SRC .."HallEvent")
end
if not SLFacade then
	appdf.req(appdf.EXTERNAL_SRC .."SLFacade")
end

 cc.exports.Localization_cn = appdf.req(appdf.EXTERNAL_SRC .."Localization_cn")
 cc.exports.FloatMessage    = appdf.req(appdf.EXTERNAL_SRC .."FloatMessage")
 cc.exports.FloatPopWait    = appdf.req(appdf.EXTERNAL_SRC .."FloatPopWait")

local LogonScene = class("LogonScene", cc.load("mvc").ViewBase)
local ClientPopWait = appdf.req(appdf.EXTERNAL_SRC .. "ClientPopWait")
local LogonLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.logon.LogonLayer")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")
local SubLayer      = appdf.req(appdf.PLAZA_VIEW_SRC .."SubLayer")
-- logindata
local MSG_LOGINDATA = 101
-- logindatalater
local MSG_LOGINDATA_LATER = 102

--全局处理lua错误
cc.exports.g_LuaErrorHandle = function ()
	cc.exports.bHandlePopErrorMsg = true
	if isDebug() then
		print("debug return")
		return true
	else
		print("release return")
		return false
	end
end

-- 全局系统数据(wifi/信号/电量/ios客户端打开链接)
cc.exports.g_SystemInfo = function( info )
	print("onGetSystemInfo")
    local event = cc.EventCustom:new(appdf.CLIENT_NOTIFY)
    event.msg = info
    event.what = yl.CLIENT_MSG_SYSTEMINFO	
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

-- log函数
function logFunc( logmsg, bExtraData )
	bExtraData = bExtraData or false
	local msg = ""
	if type(logmsg) == "table" then
		local ok = false
		ok, msg = xpcall(function()
            return cjson.encode(logmsg)
        end, function(errormsg)
        	LogAsset:getInstance():logData(debug.traceback(),bExtraData)
        end)
	elseif type( logmsg ) == "string" then
		msg = logmsg
	end
	if nil ~= msg and "" ~= msg then
		LogAsset:getInstance():logData(msg, bExtraData)
	end
end

--加载配置
function LogonScene.onceExcute()
	local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
	--文件日志
	LogAsset:getInstance():init(MultiPlatform:getInstance():getExtralDocPath(), true, true)
	--配置微信
	MultiPlatform:getInstance():thirdPartyConfig(yl.ThirdParty.WECHAT, yl.WeChat)
	--配置支付宝
	MultiPlatform:getInstance():thirdPartyConfig(yl.ThirdParty.ALIPAY, yl.AliPay)
	--配置竣付通
	MultiPlatform:getInstance():thirdPartyConfig(yl.ThirdParty.JFT, yl.JFT)
	--配置分享
	MultiPlatform:getInstance():configSocial(yl.SocialShare)
	--配置高德
	MultiPlatform:getInstance():thirdPartyConfig(yl.ThirdParty.AMAP, yl.AMAP)
	-- 监听系统信息
end
LogonScene.onceExcute()

-- 初始化界面
function LogonScene:onCreate()
    local this = self
	-- 触摸屏蔽
    ExternalFun.popupTouchFilter(30, true)
	ExternalFun.registerNodeEvent(self)
    local logonCallBack = function (result,message)
		this:onLogonCallBack(result,message)
	end
	self._logonFrame = LogonFrame:getInstance()
    self._logonFrame:setCallBackDelegate(self, logonCallBack)

	--读取配置
	GlobalUserItem.LoadData()
    -- 初始化本地账号信息
    AccountManager.getInstance():initLocalAccount()                             
	--背景音乐
	ExternalFun.playLogonBackgroudAudio()
    if GlobalUserItem.bVoiceAble then
        AudioEngine.setMusicVolume(GlobalUserItem.nMusic/100.0)
    else
        AudioEngine.setMusicVolume(0)
    end
    
    if GlobalUserItem.bSoundAble then
        AudioEngine.setEffectsVolume(GlobalUserItem.nSound/100.00) 
    else
        AudioEngine.setEffectsVolume(0) 
    end

	-- 资源更新
	self.m_tabUpdateRes = {}
	--创建登录界面
	self._logonLayer = LogonLayer:create(self)
		:move(0,0)
		:addTo(self)

	-- 资源更新列表
	self.m_tabUpdateRes = {}
	self.m_tabUpdateRes["list"] = {}

   local function onMsgEvent(event)
        local name = event:getEventName()
        local msg = unpack(event._userdata)
        self:_enterPlaza()
    end

   local function OnRegisterOK(event)
        self:logonByAccount(GlobalUserItem.tabUserLogonInfor.account, GlobalUserItem.tabUserLogonInfor.password)
    end

    SLFacade:addCustomEventListener(Hall_Events.Hall_Entry, onMsgEvent, self.__cname)
    SLFacade:addCustomEventListener(Hall_Events.MSG_REGISTER_OK,  OnRegisterOK, self.__cname) --注册成功

    local function OnPhoneRegisterOK(event)
        self:sendGetAccount()
        print("OnPhoneRegisterOK+++++++++++++++++")
    end
    SLFacade:addCustomEventListener(Hall_Events.MSG_PHONEREGISTER_OK,  OnPhoneRegisterOK, self.__cname) --手机号登陆成功
end

-- 进入场景而且过渡动画结束时候触发。
function LogonScene:onEnterTransitionFinish()
    -- 解除屏蔽
    ExternalFun.dismissTouchFilter()
    SLFacade:removeCustomEventListener(Hall_Events.MSG_PHONEREGISTER_OK,   self.__cname)
    self:addChild(SubLayer.new(), yl.MAX_INT)
end

function LogonScene:onExit()
    SLFacade:removeCustomEventListener(Hall_Events.Hall_Entry, self.__cname)
    SLFacade:removeCustomEventListener(Hall_Events.MSG_REGISTER_OK, self.__cname)
end

function LogonScene:onHttpReceiveEvent( event )
    print("--- LogonScene:onHttpReceiveEvent ---")
    if nil == event then
        return
    end
    local jstable = event.jstable 
    if type(jstable) ~= "table" then
        dump(jstable, "LogonScene onHttpReceiveEvent param jstable invalid", 6)
        return
    end
    local msgWhat = event.msgWhat
--    if msgWhat == MSG_LOGINDATA then
--        self:_getLoginData(jstable)
--    elseif msgWhat == MSG_LOGINDATA_LATER then
--        self:_getLoginDataLater(jstable)
--    end
end

-- 

--微信登陆
function LogonScene:thirdPartyLogin(plat)
    local this = self
	self._tThirdData = {}
	self:showPopWait()
	self:runAction(cc.Sequence:create(cc.DelayTime:create(15), cc.CallFunc:create(function()
			this:dismissPopWait()
			this._logonFrame:onCloseSocket()
--			this._logonLayer:onLogonFail()
		end)))
	local function loginCallBack ( param )
		this:dismissPopWait()
		if type(param) == "string" and string.len(param) > 0 then
			local ok, datatable = pcall(function()
				return cjson.decode(param)
			end)
			if ok and type(datatable) == "table" then
				local account = datatable["unionid"] or ""
				local nick = datatable["screen_name"] or ""
				this._szHeadUrl = datatable["profile_image_url"] or ""
				local gender = datatable["gender"] or ""
                local openid = datatable["openid"] or ""
				local nGender = yl.GENDER_FEMALE
				if gender == "男" then
					nGender = yl.GENDER_MANKIND
				end
				this._Operate = this._logonFrame.OP_OTHERLOGIN
				this._tThirdData = 
				{
					szAccount = account,
					szNick = nick,
					cbGender = nGender,
					platform = yl.PLATFORM_LIST[plat],
				}
				print("微信登陆 ==> ", gender)

                self:logonByWeChat(openid, account, nick, nGender)
				--this._logonLayer:onLogon()
				--this._logonFrame:onLoginByThirdParty(account, nick, nGender, yl.PLATFORM_LIST[plat], this._szHeadUrl)
				return
			end
		end
		--this._logonLayer:onLogonFail()
	end
	MultiPlatform:getInstance():thirdPartyLogin(plat, loginCallBack)
end

--登录注册回调
function LogonScene:onLogonCallBack(result,value)
    print("——————————————————")
    if type(value) == "table" then
        if value.tag == "account_login" then
            if value.result == "ok"  then -- 登陆成功
                 self:sendGetAccount()             
            else
                showToast(self,value.result,2,cc.c4b(250,0,0,255));
                self:dismissPopWait()       
            end
        elseif value.tag == "get_account" then
            if value.result == "ok"  then -- 获取用户信息成功
                GlobalUserItem.tabAccountInfo = value.body
                self:enterPlaza()
            else
                showToast(self,"用户信息获取失败",2,cc.c4b(250,0,0,255));
                self:dismissPopWait()
            end
        elseif value.tag == "guest_login" then 
            if value.result == "ok"  then --游客登录成功            
                self:sendGetAccount()
            else
                showToast(self,value.result,2,cc.c4b(250,0,0,255));
                self:dismissPopWait()
            end
        elseif value.tag == "wechat_oauth" then 
            if value.result == "ok"  then --微信登录成功            
                self:sendGetAccount()
            else
                showToast(self,value.result,2,cc.c4b(250,0,0,255));
                self:dismissPopWait()
            end
        elseif value.tag == "mobile_oauth" then 
            if value.result == "ok"  then --手机号登陆成功
                    self:sendGetAccount()
            elseif value.result == "phonecode"  then --手机号需要输入验证码
                    self._logonLayer:getYanzhengmaView()
            else
                showToast(self,value.result,2,cc.c4b(250,0,0,255));
                self:dismissPopWait()
            end
        elseif value.tag == "get_rooms"  then
            if value.result == "ok"  then --获取房间列表成功
                self:onRoomListEvent(value.body)
            else
                --todo
            end

        end
    end

    if result == -1 then
        if type(value) == "string" and value ~= "" then
		    showToast(self,value,2,cc.c4b(250,0,0,255));
	    end
        self:dismissPopWait()
    end
end

--显示等待
function LogonScene:showPopWait()
   FloatPopWait.getInstance():show("请稍后")
end

--关闭等待
function LogonScene:dismissPopWait()
    FloatPopWait.getInstance():dismiss()
end

function LogonScene:enterPlaza()
	self._logonLayer:onLoginFinish()
    GlobalUserItem.tabUserLogonInfor.uid = GlobalUserItem.tabAccountInfo.userid
    GlobalUserItem.bFinishLogon = true
    --保存用户信息
    if GlobalUserItem.tabAccountInfo then
        local strAccountInfo = json.encode(GlobalUserItem.tabAccountInfo)
	    local tabAccountInfo = md5(strAccountInfo)..strAccountInfo
	    saveByEncrypt("user_gameconfig.plist","lastuserinfor",tabAccountInfo)
        --保存账号列表
        AccountManager.getInstance():updateAccountInfo()
    end
end

function LogonScene:_enterPlaza()
	-- 检查资源
	if not self:updateGameResource() then
		--进入游戏列表
		self:getApp():enterSceneEx(appdf.CLIENT_SRC.."plaza.views.ClientScene","FADE",1)
	end
end

function LogonScene:updateGameResource()
	self:getApp()._updateGroup = {}
	local needUpdate = false
	if 0 ~= #self.m_tabUpdateRes["list"] then
		local updateinfo = {}
		updateinfo["list"] = self.m_tabUpdateRes["list"]
		updateinfo["config"] = self.m_tabUpdateRes["config"]
		updateinfo["localconfig"] = self.m_tabUpdateRes["configpath"]
		updateinfo.ismd5 = false
		updateinfo.updateversion = false

		table.insert(self:getApp()._updateGroup, updateinfo)
		needUpdate = true
	end
	--进入更新场景
	if needUpdate then
		self:getApp():enterSceneEx(appdf.CLIENT_SRC .. "plaza.views.ResUpdateScene", "FADE", 1)
	end

	return needUpdate
end

--保存登录类型
function LogonScene:saveAccoutLoginData()
    cc.UserDefault:getInstance():setIntegerForKey("loginAccountType",GlobalUserItem.tabUserLogonInfor.logontype)
    if GlobalUserItem.tabUserLogonInfor.logontype == yl.LOGON_TYPE.ACCOUNT then
        cc.UserDefault:getInstance():setStringForKey("Account",GlobalUserItem.tabUserLogonInfor.account)
        cc.UserDefault:getInstance():setStringForKey("Password",GlobalUserItem.tabUserLogonInfor.password)
    elseif GlobalUserItem.tabUserLogonInfor.logontype == yl.LOGON_TYPE.WECHAT  then
        cc.UserDefault:getInstance():setStringForKey("wAccount",GlobalUserItem.tabUserLogonInfor.account)
        cc.UserDefault:getInstance():setStringForKey("Openid",GlobalUserItem.tabUserLogonInfor.openid)
        cc.UserDefault:getInstance():setStringForKey("Nick",GlobalUserItem.tabUserLogonInfor.nickname)
        cc.UserDefault:getInstance():setStringForKey("NGender",GlobalUserItem.tabUserLogonInfor.nGender)
    elseif GlobalUserItem.tabUserLogonInfor.logontype == yl.LOGON_TYPE.PHONE  then
        cc.UserDefault:getInstance():setStringForKey("pAccount",GlobalUserItem.tabUserLogonInfor.account)
    end
end

--账号登录
function LogonScene:logonByAccount(account,password)
    local tabmsg = {}
    tabmsg["type"] = "AccountService"
    tabmsg["tag"] = "account_login"
    tabmsg["body"] = {}
    tabmsg["body"]["password"] = password
    tabmsg["body"]["is_verify"] = 1
    tabmsg["body"]["is_new"] = 1
    tabmsg["body"]["client_type"] = yl.getDeviceType()
    tabmsg["body"]["username"] = account
    tabmsg["body"]["device_id"] = MultiPlatform:getInstance():getMachineId()    --机器码
    tabmsg["body"]["machineCode"] = MultiPlatform:getInstance():getMachineId()  --机器码
    self:showPopWait()
    self._logonFrame:sendGameData(tabmsg)

    --记录登陆信息
    GlobalUserItem.tabUserLogonInfor.logontype  = yl.LOGON_TYPE.ACCOUNT
    GlobalUserItem.tabUserLogonInfor.account = account
    GlobalUserItem.tabUserLogonInfor.password = password
end

--微信登录
function LogonScene:logonByWeChat(openid, account, nick, nGender)
    local tabmsg = {}
    tabmsg["type"] = "AccountService"
    tabmsg["tag"] = "wechat_oauth"
    tabmsg["body"] = {}
    tabmsg["body"]["openid"] = openid
    tabmsg["body"]["unionid"] = account
    tabmsg["body"]["nickname"] = nick
    tabmsg["body"]["sex"] = nGender
    tabmsg["body"]["is_unity"] = 1
    tabmsg["body"]["device_id"] = MultiPlatform:getInstance():getMachineId()    --机器码
    tabmsg["body"]["agent_id"] = 0
    tabmsg["body"]["reg_client_type"] = yl.getDeviceType()
    self:showPopWait()
    self._logonFrame:sendGameData(tabmsg)

    --记录登陆信息
    GlobalUserItem.tabUserLogonInfor.logontype  = yl.LOGON_TYPE.WECHAT     --微信登陆
    GlobalUserItem.tabUserLogonInfor.account = account
    GlobalUserItem.tabUserLogonInfor.openid = openid
    GlobalUserItem.tabUserLogonInfor.nickname = nick
    GlobalUserItem.tabUserLogonInfor.nGender = nGender
end

--游客登陆
function LogonScene:VisitorAccount()
    local vistorinfor = AccountManager.getInstance():getCurrentVistorInfor()
    local uid_value = 0
    if vistorinfor then
        uid_value = vistorinfor[1]
    end
    local tabmsg = {}
    tabmsg["type"] = "AccountService"
    tabmsg["tag"] = "guest_login"
    tabmsg["body"] = {}
    tabmsg["body"]["uid"] = uid_value
    tabmsg["body"]["agent_id"] = ""   --推荐人ID
    tabmsg["body"]["reg_client_type"] =  yl.getDeviceType()
    tabmsg["body"]["device_id"] = MultiPlatform:getInstance():getMachineId()
    tabmsg["body"]["is_new"] = 1
    tabmsg["body"]["verify_code"] = ""
    tabmsg["body"]["is_verify"] = 1
     
    self:showPopWait() 
    self._logonFrame:sendGameData(tabmsg)

     --记录登陆信息
    GlobalUserItem.tabUserLogonInfor.logontype  = yl.LOGON_TYPE.VISTOR
    GlobalUserItem.tabUserLogonInfor.uid = uid_value
end

--手机号登陆
function LogonScene:phoneNumAccount(str_phoneNum_,str_phoneCode)
    local phoneCode = str_phoneCode or ""
    local tabmsg = {}
    tabmsg["type"] = "AccountService"
    tabmsg["tag"] = "mobile_oauth"
    tabmsg["body"] = {}
    tabmsg["body"]["agent_id"] = ""
    tabmsg["body"]["reg_client_type"] = 1
    tabmsg["body"]["phone"] = str_phoneNum_
    tabmsg["body"]["device_id"] = MultiPlatform:getInstance():getMachineId()
    tabmsg["body"]["phonecode"] = phoneCode
      
    self._logonFrame:sendGameData(tabmsg)

    self.phoneNum = str_phoneNum_
    --记录登陆信息
    GlobalUserItem.tabUserLogonInfor.logontype  = yl.LOGON_TYPE.PHONE
    GlobalUserItem.tabUserLogonInfor.account = str_phoneNum_

end

--获得手机验证码
function LogonScene:getYanzhengmaForAccount(str_phoneNum_)
    local tabmsg = {}
    tabmsg["type"] = "AccountService"
    tabmsg["tag"] = "send_mobile_sms"
    tabmsg["body"] = {}
    tabmsg["body"]["phone"] = str_phoneNum_
      
    self._logonFrame:sendGameData(tabmsg)

end

--获取用户信息
function LogonScene:sendGetAccount()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "get_account"
    msgta["body"] = ""
    self._logonFrame:sendGameData(msgta)
    self:showPopWait()

    self:saveAccoutLoginData() --保存登录信息
end

return LogonScene