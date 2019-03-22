--[[
	登录模块
]]

local BaseFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.BaseFrame")

local LogonFrame = class("LogonFrame",BaseFrame)
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")


function LogonFrame:ctor()
	LogonFrame.super.ctor(self,nil,nil)
	self._plazaVersion = appdf.VersionValue(6,7,0,1)
	self._stationID = yl.STATION_ID
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	local tmp = yl.DEVICE_TYPE_LIST[targetPlatform]
	self._deviceType = tmp or yl.DEVICE_TYPE
	self._szMachine = MultiPlatform:getInstance():getMachineId()
	self._szDeviceToken = MultiPlatform:getInstance():getDeviceToken()

end

LogonFrame.instance = nil
function LogonFrame:getInstance()
    if LogonFrame.instance == nil then
        LogonFrame.instance = LogonFrame:create()
        self:onCreateSocket()
        --回调匹配
        self.tableCallBack = {}
        self.tabMsgDeque = {}
        self:onTimeSendBeatHeart()
    end
    return self
end

function LogonFrame:setCallBackDelegate(delegate,callback)
    self:setCallBack(callback)
    self:setViewFrame(delegate)

    local pairsCallBack = {} 
    pairsCallBack.delegate = delegate
    pairsCallBack.callback = callback
    table.insert(self.tableCallBack, pairsCallBack)
end

function LogonFrame:removeInValidCallBackDelegate()
    for k,v in pairs(self.tableCallBack) do
        if not yl.isObject(v.delegate)  then
            table.remove(self.tableCallBack, k)
        end
    end
end

--连接结果
function LogonFrame:onConnectCompeleted()
    print("网络恢复...........")
    if GlobalUserItem.bFinishLogon then
        if GlobalUserItem.tabUserLogonInfor.logontype == yl.LOGON_TYPE.ACCOUNT then
            local tabmsg = {}
            tabmsg["type"] = "AccountService"
            tabmsg["tag"] = "account_login"
            tabmsg["body"] = {}
            tabmsg["body"]["password"] = GlobalUserItem.tabUserLogonInfor.password
            tabmsg["body"]["is_verify"] = 1
            tabmsg["body"]["is_new"] = 1
            tabmsg["body"]["client_type"] = yl.getDeviceType()
            tabmsg["body"]["username"] = GlobalUserItem.tabUserLogonInfor.account
            tabmsg["body"]["device_id"] = MultiPlatform:getInstance():getMachineId()    --机器码
            tabmsg["body"]["machineCode"] = MultiPlatform:getInstance():getMachineId()  --机器码
            self:sendGameData(tabmsg)
        elseif GlobalUserItem.tabUserLogonInfor.logontype == yl.LOGON_TYPE.REGISTER then
            local tabmsg = {}
            tabmsg["type"] = "AccountService"
            tabmsg["tag"] = "account_login"
            tabmsg["body"] = {}
            tabmsg["body"]["password"] = GlobalUserItem.tabUserLogonInfor.password
            tabmsg["body"]["is_verify"] = 1
            tabmsg["body"]["is_new"] = 1
            tabmsg["body"]["client_type"] = yl.getDeviceType()
            tabmsg["body"]["username"] = GlobalUserItem.tabUserLogonInfor.account
            tabmsg["body"]["device_id"] = MultiPlatform:getInstance():getMachineId()    --机器码
            tabmsg["body"]["machineCode"] = MultiPlatform:getInstance():getMachineId()  --机器码
            self:sendGameData(tabmsg)
            
        elseif GlobalUserItem.tabUserLogonInfor.logontype == yl.LOGON_TYPE.VISTOR then
             local tabmsg = {}
            tabmsg["type"] = "AccountService"
            tabmsg["tag"] = "guest_login"
            tabmsg["body"] = {}
            tabmsg["body"]["uid"] = GlobalUserItem.tabUserLogonInfor.uid or 0
            tabmsg["body"]["agent_id"] = ""   --推荐人ID
            tabmsg["body"]["reg_client_type"] =  yl.getDeviceType()
            tabmsg["body"]["device_id"] = MultiPlatform:getInstance():getMachineId()
            tabmsg["body"]["is_new"] = 1
            tabmsg["body"]["verify_code"] = ""
            tabmsg["body"]["is_verify"] = 1
            self:sendGameData(tabmsg)
        elseif GlobalUserItem.tabUserLogonInfor.logontype == yl.LOGON_TYPE.PHONE then
             local tabmsg = {}
            tabmsg["type"] = "AccountService"
            tabmsg["tag"] = "mobile_oauth"
            tabmsg["body"] = {}
            tabmsg["body"]["agent_id"] = ""
            tabmsg["body"]["reg_client_type"] = 1
            tabmsg["body"]["phone"] = GlobalUserItem.tabUserLogonInfor.account
            tabmsg["body"]["device_id"] = MultiPlatform:getInstance():getMachineId()
            tabmsg["body"]["phonecode"] = ""
            self:sendGameData(tabmsg)
        elseif GlobalUserItem.tabUserLogonInfor.logontype == yl.LOGON_TYPE.WECHAT then
             local tabmsg = {}
            tabmsg["type"] = "AccountService"
            tabmsg["tag"] = "wechat_oauth"
            tabmsg["body"] = {}
            tabmsg["body"]["openid"] = GlobalUserItem.tabUserLogonInfor.openid
            tabmsg["body"]["unionid"] = GlobalUserItem.tabUserLogonInfor.account
            tabmsg["body"]["nickname"] = GlobalUserItem.tabUserLogonInfor.nickname
            tabmsg["body"]["sex"] = GlobalUserItem.tabUserLogonInfor.nGender
            tabmsg["body"]["is_unity"] = 1
            tabmsg["body"]["device_id"] = MultiPlatform:getInstance():getMachineId()    --机器码
            tabmsg["body"]["agent_id"] = 0
            tabmsg["body"]["reg_client_type"] = yl.getDeviceType()
            self:sendGameData(tabmsg)
        end
    end

    --发送失败的消息
    for i = 1, #self.tabMsgDeque do
        self:sendGameData(self.tabMsgDeque[i])
    end
    self.tabMsgDeque = {}

    self:sethearttime(5000)
    self:setdelaytime(14000)
end

--网络信息
function LogonFrame:onSocketEvent(main,sub,pData)
    local value = cjson.decode(pData:readvalue())
    self:dispatchMsg(1, value)
end


function LogonFrame:dispatchMsg(result,message)
    --派发消息
    for k,v in pairs(self.tableCallBack) do
        if yl.isObject(v.delegate) then
            v.callback(result,message)
        end
    end

    --移除无效
    self:removeInValidCallBackDelegate()
end

--网络错误
function LogonFrame:onSocketError(pData)
	if self._threadid == nil then
		return
	end

	self:onCloseSocket()
    appdf.swichLogonIp()
    self:dispatchMsg(-1,"")

    local function countDown()
        self:onCreateSocket()
        if cc.exports.TimerProxy:hasTimer(120) then
            cc.exports.TimerProxy:removeTimer(120)
        end
    end

    cc.exports.TimerProxy:addTimer(120, countDown, 2,1, false)

    print("大厅网络断了...........")
end

--发送数据
function LogonFrame:sendGameData(msgta)
    local strvalue = msgta
    if type(msgta) == "table" then
       strvalue = cjson.encode(msgta)
    end
    if not self:sendSocketData(strvalue)then
        print("发送消息失败，网络连接成功，再发送....")
        --保存发送失败的消息
        table.insert(self.tabMsgDeque, strvalue)

        --连接网络
        self:onCreateSocket()
	end
end


--发送心跳
function LogonFrame:onTimeSendBeatHeart()
    local function countDown()
        --大厅心跳
        local msgta = "{\"type\":\"socket\", \"tag\":\"ping\",\"body\":\"1\"}"
        self:sendGameData(msgta)
        print("大厅心跳")
    end
    if cc.exports.TimerProxy:hasTimer(911) then
        cc.exports.TimerProxy:removeTimer(911)
    end
    cc.exports.TimerProxy:addTimer(911, countDown, 10, -1, false)
end

return LogonFrame