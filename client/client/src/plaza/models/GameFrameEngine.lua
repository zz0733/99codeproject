local BaseFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.BaseFrame")
local GameFrameEngine = class("GameFrameEngine",BaseFrame)

local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local QueryDialog = appdf.req("app.views.layer.other.QueryDialog")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")


function GameFrameEngine:ctor(view,callbcak)
	GameFrameEngine.super.ctor(self,view,callbcak)
	self._kindID = 0
	self._kindVersion = 0

	-- 断网对话框
	self.m_netQuery = nil

	-- 短连接服务
	self._shotFrame = nil

	-- 是否发送 option 消息
	self.m_bSendOption = false

    self.m_lastSendLogon = 0


	self:onInitData()
end

function GameFrameEngine:setKindInfo(id,version)
	self._kindID = id 
	self._kindVersion = version
	return self
end

function GameFrameEngine:setScene( scene )
	self._scene = scene
end

function GameFrameEngine:onInitData()
	-- 房间信息
	self._wTableCount = 0
	self._wChairCount = 0
	self._wServerType = 0
	self._dwServerRule = 0
	self._UserList = {}
	self._tableUserList = {}
	self._tableStatus = {}
	self._delayEnter = false

	self._wTableID	 	= yl.INVALID_TABLE
	self._wChairID	 	= yl.INVALID_CHAIR
	self._cbTableLock	= 0
	self._cbGameStatus 	= 0
	self._cbAllowLookon	= 0
	self.bChangeDesk = false
	self.bEnterAntiCheatRoom = false 		--进入防作弊房间
	GlobalUserItem.bWaitQuit = false 		-- 退出等待
	self._tabVoiceMsgQueue = {}
	self._bPlayVoiceRecord = false
	self._nPlayVoiceId = nil

    --发送完毕登陆房间收不到消息提示
    self._bshowTips = false

	-- 断线重连次数
	self.m_nReConCount = 5
	self:removeNetQuery()
	self.m_bSendOption = false
end

function GameFrameEngine:removeNetQuery()
	if nil ~= self.m_netQuery then
		self.m_netQuery:removeFromParent()
		self.m_netQuery = nil
	end
end

function GameFrameEngine:setEnterAntiCheatRoom( bEnter )
	self.bEnterAntiCheatRoom = bEnter
end

function GameFrameEngine:connectGameServer()
    print("建立连接.....")
	if not self:onCreateGameSocket() and nil ~= self._callBack then
		self._callBack(-1,"")
	end
end


--连接房间
function GameFrameEngine:onLogonRoom()
    self:connectGameServer()
end
--连接结果
function GameFrameEngine:onConnectCompeleted()
    print("游戏网络恢复...........")
    local duration = os.time()-self.m_lastSendLogon
     print("延时多久发送..........."..duration)
    --立刻登陆
    if duration >= 5 then
        self:sendLogonRoom()
        return
    end

    local function countDown()
       cc.exports.TimerProxy:removeTimer(315)
       self:sendLogonRoom()
    end
    cc.exports.TimerProxy:removeTimer(315)
    cc.exports.TimerProxy:addTimer(315, countDown, 5-duration,1, false)
end


function GameFrameEngine:sendLogonRoom()
    print("发送登陆房间...........")
    local msgdata = {}
    msgdata["type"] = "account"
    msgdata["tag"] = "login"
    msgdata["body"] = {}
    msgdata["body"]["userid"] = GlobalUserItem.tabAccountInfo.userid
    msgdata["body"]["password"] = GlobalUserItem.tabAccountInfo.password
    msgdata["body"]["first_money"] = 0
    msgdata["body"]["version"] = 0
    msgdata["body"]["client_type"] = yl.getDeviceType()
    msgdata["body"]["client_info"] = ""
    msgdata["body"]["fixseat"] = GlobalUserItem.tabRoomInfo.fixseat or false
    msgdata["body"]["dbname"] = ""
    msgdata["body"]["roomid"] = GlobalUserItem.tabRoomInfo.room_id

    local strvalue =  string.gsub(cjson.encode(msgdata), "\\", "")
	if not self:sendSocketData(strvalue) and nil ~= self._callBack then
		self._callBack(-1,"")
	end

    self.m_lastSendLogon = os.time()
    self._bshowTips = true
end

--网络信息
function GameFrameEngine:onSocketEvent(main,sub,dataBuffer)
    local value = cjson.decode(dataBuffer:readvalue())
    local utype = value.type
    -- 当前游戏场景
	if nil ~= self._scene and nil ~= self._scene._sceneLayer then
		curTag = self._scene._sceneLayer:getCurrentTag()
	end
	if curTag == yl.SCENE_GAME then
        if self._viewFrame and self._viewFrame.onEventGameMessage then
			self._viewFrame:onEventGameMessage(value.tag,value.body)
		end
        return
    end

    if value.type == "account" then
        self:onSocketAccountEvent(value.tag,value.body)
    elseif value.type == "seatmatch" then
       self:onSocketSeatMatchEvent(value.tag,value.body)
    end
end

local targetPlatform = cc.Application:getInstance():getTargetPlatform()
--网络错误
function GameFrameEngine:onSocketError(pData)
    print("游戏网络断了...........")
	self:onCloseSocket()
    appdf.swichGameIp()

    if nil ~= self._scene and pData and type(pData) ~= "string"then
	    local curTag = nil
        local errorcode = pData:readword()
	    -- 当前游戏场景
	    if nil ~= self._scene and nil ~= self._scene._sceneLayer then
		    curTag = self._scene._sceneLayer:getCurrentTag()
	    end
	    if curTag == yl.SCENE_GAME  then
            self._scene:dismissPopWait()
	        self:removeNetQuery()
            if errorcode == 11 then
                self._scene:showReConnect()
            else
                self._callBack(-1,"")
            end
        else
            if self._bshowTips then
                 print("亲，点的太快了，慢些点！！")
                 self:connectGameServer()
            end
	    end
    
    end

end


function GameFrameEngine:onSocketAccountEvent(tag, boday)
    print(tag.."+++++++++++++++++++++++")
    self._bshowTips = false
    if tag == "login_success" then
        GlobalUserItem.tabAccountInfo.re_enter = boday.re_enter
        GlobalUserItem.tabAccountInfo.into_money = boday.into_money

        if self._viewFrame and self._viewFrame.onEnterTable then
			self._viewFrame:onEnterTable()
		end
    elseif tag == "login_failed_paramwrong" then
        self._callBack(-1,"参数错误")
    elseif tag == "login_failed_nousemoney" then
        local tips = "有效金额不足无法进入房间"
        if #boday > 0 then
            tips = "您当前正在[ "..boday[1].." ]游戏中,请稍后再进!"
        end
        self._callBack(-1,tips)
    elseif tag == "room_entry_failed_auth" then
        self._callBack(-1,"私人房间密码错误")
    elseif tag == "login_failed_inactive" then
        self._callBack(-1,"封号")
    elseif tag == "login_failed_auth" then
        self._callBack(-1,"用户名密码错误")
    elseif tag == "login_failed_nomoney" then
        local tips = "钱不够"
        if #boday > 0 then
            tips = "您当前正在[  "..boday[1].."  ]游戏中，请稍后再进!"
        end
        self._callBack(-1,tips)
    elseif tag == "login_failed_full" then
        self._callBack(-1,"满员")
    elseif tag == "login_failed_guest" then
        self._callBack(-1,"游客到期")
    elseif tag == "login_failed_closed" then
        self._callBack(-1,"房间已关闭")
    elseif tag == "login_failed_notexist" then
        self._callBack(-1,"房间不存在")
    elseif tag == "login_failed_lowlv" then
        self._callBack(-1,"级别不足")
    elseif tag == "login_failed_timeout" then
        self._callBack(-1,"登录超时")
    elseif tag == "login_failed_assetsover" then
        self._callBack(-1,"资产过多请移步高一级房间")
    elseif tag == "login_failed_ip" then
        self._callBack(-1,"您的IP被限制")
    elseif tag == "login_failed_maxloseday" then
        self._callBack(-1,"防沉迷: 今天输赢超限,明天再来")
    elseif tag == "login_failed_maxlosegame" then
        self._callBack(-1,"防沉迷: 本局输赢超限,明天再来")
    elseif tag == "login_failed_nodb" then
        self._callBack(-1,"数据源不存在")
    elseif tag == "login_failed_leaving" then
        self._callBack(-1,"结算未完成")
    elseif tag == "login_failed_x" then
        self._callBack(-1,"未知的错误")
    end
end


function GameFrameEngine:onSocketSeatMatchEvent(tag, boday)
    if tag == "on_login" then 
        self:onSocketUserEnter(boday)
    elseif tag == "seatlist" then
        local desks = boday.desks
        local ranks = boday.ranks

        self._wTableCount = #desks

        --用户进入
        for k,v in pairs(ranks) do
            self:onSocketUserEnter(v)
        end

        --桌子状态
        for i =1,#desks do
            local tableinfor = desks[i] 
            local tableid = tableinfor[1]
            local deskinfor = tableinfor[3]

            --设置桌子状态
            self:setTableStatus(tableid, (tableinfor[2] == true and 1 or 0), (tableinfor[4] == true and 1 or 0))

            for j= 1, #deskinfor do
                 local chairid = j
                 local usrinfor = deskinfor[j]
                 if type(usrinfor) == "table" then
                     local useid = usrinfor[1]
                     local useritem = self._UserList[useid]
                     if useritem then
                        self:onUpDataTableUser(tableid, chairid, useritem, true)                  --桌子用户
                     end
                 end
            end
        end

        if self._viewFrame and self._viewFrame.onEnterRoom then
			self._viewFrame:onEnterRoom()
		end
     elseif tag == "on_passwd" then
        local tableid = boday[1]
        local cbTableLock = boday[2] == true and 1 or 0    -- 加密状态
        self:setTableStatus(tableid, nil, cbTableLock)

        --更新
        if self._viewFrame and self._viewFrame.upDataTableStatus then
			self._viewFrame:upDataTableStatus(tableid)
		end
     elseif tag == "on_update" then
        local updateinfor = boday
        for i=1,#updateinfor do
            local userinfor = updateinfor[i]
            local useritem = self._UserList[userinfor[1]]
            if useritem then
                useritem.lScore = userinfor[2]
                useritem.Level = userinfor[3]
            end
        end
     elseif tag == "on_logout" then
        self:onRemoveUser(boday)
     elseif tag == "on_situp" then
        local useritem = self._UserList[boday[2]]
        local tableid = boday[1]
        if useritem then
            self:onUpDataTableUser(tableid, useritem.wChairID, useritem, false)
        end

        --更新
        if self._viewFrame and self._viewFrame.upDataTableStatus then
			self._viewFrame:upDataTableStatus(tableid)
		end

     elseif tag == "on_sitdown" then
        local useritem = self._UserList[boday[2]]
        if useritem then
            self:onUpDataTableUser(boday[1], boday[4], useritem, true)
        end 

         --更新
        if self._viewFrame and self._viewFrame.upDataTableStatus then
			self._viewFrame:upDataTableStatus(boday[1])
		end
     elseif tag == "on_end" then
        local tableid = boday
        self:setTableStatus(tableid, 0, nil)
         --更新
        if self._viewFrame and self._viewFrame.upDataTableStatus then
			self._viewFrame:upDataTableStatus(tableid)
		end
     elseif tag == "on_begin" then
        local tableid = boday
        self:setTableStatus(tableid, 1, nil)
        --更新
        if self._viewFrame and self._viewFrame.upDataTableStatus then
			self._viewFrame:upDataTableStatus(tableid)
		end
    end
end

function GameFrameEngine:GetTableCount()
	return self._wTableCount
end

function GameFrameEngine:GetChairCount()
	return self._wChairCount
end

--用户进入
function GameFrameEngine:onSocketUserEnter(dataBuffer)
	local userItem = {}
	userItem.dwUserID = dataBuffer[1]
    userItem.szNickName = dataBuffer[2]
    userItem.wFaceID = dataBuffer[3]
    userItem.Level = dataBuffer[4]
    userItem.lScore = dataBuffer[5]
    userItem.NetSpeed = dataBuffer[6]
    userItem.wTableID = dataBuffer[7]
    userItem.wChairID = 0
    userItem.WinCount = dataBuffer[8]
    userItem.LoseCount = dataBuffer[9]
    userItem.RunCount = dataBuffer[10]
    userItem.WinRate = dataBuffer[11]
    userItem.VipLevel = dataBuffer[12]

    self._UserList[userItem.dwUserID] = userItem
end


function GameFrameEngine:OnResetGameEngine()
	if self._viewFrame and self._viewFrame.OnResetGameEngine then
		self._viewFrame:OnResetGameEngine()
	end
end

--更新桌椅用户
function GameFrameEngine:onUpDataTableUser(tableid,chairid,useritem, sitdown)
	local id = tableid
	local idex = chairid
	if not self._tableUserList[id]  then
		self._tableUserList[id] = {}
	end
	if sitdown then
		self._tableUserList[id][idex] = useritem.dwUserID
        useritem.wTableID = tableid
        useritem.wChairID = chairid
	else
		self._tableUserList[id][idex] = nil
        useritem.wTableID = 0
        useritem.wChairID = 0
	end
end

--获取桌子用户
function GameFrameEngine:getTableUserItem(tableid,chairid)
	local id = tableid
	local idex = chairid
	if self._tableUserList[id]  then
		local userid = self._tableUserList[id][idex] 
		if userid then
			return clone(self._UserList[userid])
		end
	end
end

function GameFrameEngine:getTableInfo(index)
	if index > 0  then
		return self._tableStatus[index]
	end
end

function GameFrameEngine:setTableStatus(index, play, lock)
    if not self._tableStatus[index]  then
		self._tableStatus[index] = {}
	end

    if play ~= nil then
        self._tableStatus[index].cbPlayStatus = play
    end
    if lock ~= nil then
        self._tableStatus[index].cbTableLock = lock
    end
end

--获取自己游戏信息
function GameFrameEngine:GetMeUserItem()
	return self._UserList[GlobalUserItem.tabAccountInfo.dwUserID]
end

--获取游戏状态
function GameFrameEngine:GetGameStatus()
	return self._cbGameStatus
end

--设置游戏状态
function GameFrameEngine:SetGameStatus(cbGameStatus)
	self._cbGameStatus = cbGameStatus
end

--获取桌子ID
function GameFrameEngine:GetTableID()
	return self._wTableID
end

--获取椅子ID
function GameFrameEngine:GetChairID()
	return self._wChairID
end

--移除用户
function GameFrameEngine:onRemoveUser(dwUserID)
	self._UserList[dwUserID] = nil
end

--坐下请求
function GameFrameEngine:SitDown(table ,chair, password)

    local msgdata = {}
    msgdata["type"] = "seatmatch"
    msgdata["tag"] = "sit"
    msgdata["body"] = {}
    msgdata["body"][1] = table
    msgdata["body"][2] = chair
    msgdata["body"][3] = password or ""
    local strvalue = cjson.encode(msgdata)
	--记录坐下信息
	if nil ~= GlobalUserItem.m_tabEnterGame and type(GlobalUserItem.m_tabEnterGame) == "table" then
		print("update game info")
		GlobalUserItem.m_tabEnterGame.nSitTable = table
		GlobalUserItem.m_tabEnterGame.nSitChair = chair
	end
	return self:sendSocketData(strvalue)
end

--起立
function GameFrameEngine:StandUp()
    local msgdata = {}
    msgdata["type"] = "game"
    msgdata["tag"] = "quit"
    local strvalue = cjson.encode(msgdata)
    return self:sendSocketData(strvalue)
end


return GameFrameEngine