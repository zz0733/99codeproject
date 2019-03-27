local ClientScene = class("ClientScene", cc.load("mvc").ViewBase)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local ClientPopWait = appdf.req(appdf.EXTERNAL_SRC .. "ClientPopWait")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local NotifyMgr = appdf.req(appdf.EXTERNAL_SRC .. "NotifyMgr")
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")

-- ui
local ClientSceneLayer = appdf.req(appdf.PLAZA_VIEW_SRC .. "ClientSceneLayer")                  -- 大厅层管理
local TargetShareLayer = appdf.req(appdf.PLAZA_VIEW_SRC .. "TargetShareLayer")                  -- 分享           
local SubLayer      = appdf.req(appdf.PLAZA_VIEW_SRC .."SubLayer")
-- ui

-- net
local GameFrameEngine = appdf.req(appdf.CLIENT_SRC.."plaza.models.GameFrameEngine")             -- 游戏服务    
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")                 

-- 初始化
function ClientScene:onCreate()
    -- 是否弹出认证提示
    self.bPopIdentify = false
    -- 触摸屏蔽
    ExternalFun.popupTouchFilter(30, true)
	ExternalFun.registerNodeEvent(self)

	-- 大厅活动层
	self._sceneLayer = ClientSceneLayer:create(self)
		:setContentSize(yl.WIDTH,yl.HEIGHT)
		:addTo(self)
	self._sceneLayer:setKeyboardEnabled(true)
    -- 大厅弹窗层
    self._scenePopLayer = display.newLayer()
        :setContentSize(yl.WIDTH,yl.HEIGHT)
        :addTo(self)
    self.m_bEnableKeyBack = true

    -- 记录游戏
    self:updateCurrentGame()

    -- 网络
    self._gameFrame = GameFrameEngine:create(self,function (code,result)
        self:onFrameEngineCallBack(code,result)
    end)

     --游戏网络回调
    local  plazaCallBack = function(result,message)
       self:onPlazaCallBack(result,message)
    end

    --大厅网络处理
    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, plazaCallBack)

    -- 后台监听
    setbackgroundcallback(function (bEnter)
        if type(self.onBackgroundCallBack) == "function" then
            self:onBackgroundCallBack(bEnter)
        end
    end)

    -- 大厅界面
    self:onChangeShowMode(yl.SCENE_PLAZA)
end

function ClientScene:addPopLayer( lay )
    if nil == lay then
        print("ClientScene:addPopLayer param lay is nil")
        return
    end
    self._scenePopLayer:addChild(lay)
end

-- 游戏网络回调
function ClientScene:onFrameEngineCallBack(code,message)
    print("onFrameEngineCallBack:", code)
    if message then
        showToast(self, message, 1)
    end
    if code == -1 then
        self:dismissPopWait()
        local curScene = self._sceneLayer:getCurrentTag()
        if curScene == yl.SCENE_GAME then
            local curScene = self._sceneLayer:getCurrentLayer()
            if curScene and curScene.onExitRoom then
                curScene:onExitRoom(1)
            else
                self:onKeyBack()
            end
        end
    end
end

--大厅网络回调
function ClientScene:onPlazaCallBack(result,message)
    if type(message) == "table" then
        if message.tag == "read_messages" then
            if message.result == "ok" then
                for i =1, #message.body do
                    local item = message.body[i]
                    local msg = {}
                    msg.title = item.content
                    msg.autoremove = true
                    msg.showcount = 1
                    msg.id = item.id
                    RollMsg.getInstance():onAddNotice(msg)
                end
            end 
        elseif message.tag == "safe_accountInfo" then
            if message.result == "ok" then
                GlobalUserItem.tabAccountInfo.Safeinfor = {}
                GlobalUserItem.tabAccountInfo.Safeinfor = message.body

                 -- 通知       
                local eventListener = cc.EventCustom:new(yl.RY_USERINFO_NOTIFY)
                eventListener.obj = yl.RY_MSG_USERIDENTIFY
                cc.Director:getInstance():getEventDispatcher():dispatchEvent(eventListener)
            end
        elseif message.tag == "get_account" then
            if message.result == "ok"  then -- 获取用户信息成功
                GlobalUserItem.tabAccountInfo = message.body

                -- 通知       
                local eventListener = cc.EventCustom:new(yl.RY_USERINFO_NOTIFY)
                eventListener.obj = yl.RY_MSG_USERWEALTH
                cc.Director:getInstance():getEventDispatcher():dispatchEvent(eventListener)
            end
        elseif message.tag == "get_zfb_account" then
            if message.result == "ok"  then -- 获取支付绑定的信息成功
                --客户端临时存储
                GlobalUserItem.tabAccountInfo.payBindMsg = message.body
            end
        end
    end
end

-- 后台回调
function ClientScene:onBackgroundCallBack( bEnter )
    if not bEnter then
--        print("onBackgroundCallBack not bEnter")
--        if nil ~= self._gameFrame and self._gameFrame:isSocketServer() and GlobalUserItem.bAutoConnect then         
--            self._gameFrame:onCloseSocket()
--        end
--        self._sceneLayer:setKeyboardEnabled(false)
    else
--        print("onBackgroundCallBack  bEnter")
--        local curTag = self._sceneLayer:getCurrentTag()
--        if curTag == yl.SCENE_GAME then               
--            if self._gameFrame:isSocketServer() == false and GlobalUserItem.bAutoConnect then
--                self._gameFrame:OnResetGameEngine()
--                self:onStartGame()
--            end
--        end

--        self._sceneLayer:setKeyboardEnabled(true)
    end
end

function ClientScene:onReQueryFailure(code, msg)
    print("房间请求失败")
    self:dismissPopWait()
    if nil ~= msg and type(msg) == "string" then
        showToast(self,msg,2)
    end
    GlobalUserItem.bMatch = false
    self._gameFrame:onCloseSocket()
end

function ClientScene:onEnterTable()
    print("ClientScene onEnterTable")
    self:dismissPopWait()
    local tag = self._sceneLayer:getCurrentTag()
    if tag == yl.SCENE_GAME then
        self._gameFrame:setViewFrame(self._sceneLayer:getCurrentLayer())
    else
        self:onChangeShowMode(yl.SCENE_GAME)----------------------
    end
end

--启动游戏
function ClientScene:onStartGame()
    local app = self:getApp()
    local entergame = self:getEnterGameInfo()
    if nil == entergame then
        showToast(self, "游戏信息获取失败", 3)
        self:dismissPopWait()
        return
    end
    self:showPopWait()
    self._gameFrame:setScene(self)
    self._gameFrame:onInitData()
    self._gameFrame:setKindInfo(GlobalUserItem.nCurGameKind, entergame._KindVersion)
    self._gameFrame:setViewFrame(self)
    self._gameFrame:onCloseSocket()
    self._gameFrame:onLogonRoom()
    
end

--定时查询公告
function ClientScene:onTimeRequestNotice()
    --获取公告
    self:requestNotice()
    local function countDown()
        self:requestNotice()
    end
    cc.exports.TimerProxy:addTimer(123, countDown, 10, -1, false)
end

--发送心跳
function ClientScene:onTimeSendBeatHeart()
    local function countDown()
        --游戏心跳
        local curScene = self._sceneLayer:getCurrentTag()
        local msgta = "{}"
        if curScene == yl.SCENE_GAME then
           msgta = "{\"type\":\"socket\", \"tag\":\"ping\",\"body\":\"1111111111111\"}"
        end
        if nil ~= self._gameFrame and self._gameFrame:isSocketServer() then
            self._gameFrame:sendSocketData(msgta)
            print("游戏心跳>>>>>>>>>>>>>>>>>>>>>")
        end
    end
    cc.exports.TimerProxy:addTimer(110, countDown, 10, -1, false)
end

function ClientScene:onEnterTransitionFinish()
    --self.m_listener = cc.EventListenerCustom:create(appdf.CLIENT_NOTIFY,handler(self, self.onClientNotify))
    --cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_listener, self)
    -- 解除屏蔽
    ExternalFun.dismissTouchFilter()

    --定时公告
    self:onTimeRequestNotice()
    --游戏心跳
    self:onTimeSendBeatHeart()
    --获取安全信息
    self:requestSafeInfor()
    --获取支付宝银行卡绑定信息
    self:requestpPayWayInfor()
    self.m_Weixinbangding       = SLFacade:addCustomEventListener(Hall_Events.MSG_DINGPHONE_OK, handler(self, self.onWechatBindPhoneOK))

    self:addChild(SubLayer.new(), yl.MAX_INT)
end

--微信绑定手机号成功
function ClientScene:onWechatBindPhoneOK()
    self:sendGetAccount()
    SLFacade:dispatchCustomEvent(Hall_Events.MSG_QUERY_BINDING)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
        SLFacade:dispatchCustomEvent(Hall_Events.MSG_QUERY_BINDING)
    end)))
end

function ClientScene:onExit()
    removebackgroundcallback()
--    if nil ~= self.m_listener then
--        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.m_listener)
--        self.m_listener = nil
--    end
    if nil ~= self._gameFrame then
        self._gameFrame:setScene(nil)
        self._gameFrame:onCloseSocket()
        self._gameFrame = nil
    end


    cc.exports.TimerProxy:removeTimer(123)
    cc.exports.TimerProxy:removeTimer(110)

    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
end


-- 截屏通知
function ClientScene:onClientNotify( event )
    local what = event.what
    local msg = event.msg
    if what == yl.CLIENT_MSG_TAKE_SCREENSHOT then
        print("截屏啦")
        local gameLayer = self._sceneLayer:getChildByTag(yl.SCENE_GAME)
        if nil ~= gameLayer and nil ~= gameLayer.onTakeScreenShot then
            gameLayer:onTakeScreenShot(msg)
        end
    elseif what == yl.CLIENT_MSG_HTTP_WEALTH then
        self:dismissPopWait()
        local jstable = event.jstable
        dump(jstable, "jstable", 6)
        if type(jstable) == "table" then
            local data = jstable["data"]
            if type(data) == "table" then
                local valid = data["valid"]
                if true == valid then
                    local diamond = tonumber(data["diamond"]) or 0
                    local needupdate = false
                    if diamond ~= GlobalUserItem.tabAccountInfo.lDiamond then
                        needupdate = true
                        GlobalUserItem.tabAccountInfo.lDiamond = diamond
                    end
                    -- 金币
                    local score = tonumber(data["score"]) or 0
                    if nil ~= score and score ~= GlobalUserItem.tabAccountInfo.lUserScore then
                        needupdate = true
                        GlobalUserItem.tabAccountInfo.lUserScore = score
                    end
                    if needupdate then
                        print("update score")
                        --通知更新        
                        local eventListener = cc.EventCustom:new(yl.RY_USERINFO_NOTIFY)
                        eventListener.obj = yl.RY_MSG_USERWEALTH
                        cc.Director:getInstance():getEventDispatcher():dispatchEvent(eventListener)
                    end 
                end
            end
        end
        local queryCallBack = event.queryCallBack
        if type(queryCallBack) == "function" then
            queryCallBack()
        end
    end
end

-- 退出大厅
function ClientScene:exitPlaza()
    -- 删除授权
    if MultiPlatform:getInstance():isAuthorized(yl.ThirdParty.WECHAT) then
        print("OptionLayer 删除微信授权")
        MultiPlatform:getInstance():delAuthorized(yl.ThirdParty.WECHAT)
    end
	self._sceneLayer:setKeyboardEnabled(false)
    --通知管理
    NotifyMgr:getInstance():clear()
    -- 重置
    GlobalUserItem.reSetData()
    --读取配置
    GlobalUserItem.LoadData()
	self:getApp():enterSceneEx(appdf.CLIENT_SRC.."plaza.views.LogonScene","FADE",1)
    --断开网络
    self._plazaFrame:onCloseSocket()
end

-- 回退
function ClientScene:onKeyBack()
    if not self.m_bEnableKeyBack then
        print("ClientScene onKeyBack 不允许回退")
        return
    end    
    self:onChangeShowMode()
end

-- 切换界面
function ClientScene:onChangeShowMode(nTag, param, transitionCallBack)
    self._sceneLayer:onChangeShowMode(nTag, param)
end

-- 切换结束
function ClientScene:onChangeShowModeEnd( lastTag, curTag )
    -- 从游戏退出
    if nil ~= lastTag and yl.SCENE_GAME == lastTag then
       --更新分数
       self:sendGetAccount()
    end
end

--显示等待
function ClientScene:showPopWait(isTransparent)
   FloatPopWait.getInstance():show("请稍后")
end

--关闭等待
function ClientScene:dismissPopWait()
   FloatPopWait.getInstance():dismiss()
end


--关闭等待
function ClientScene:dismissReConnect()
    if self._popWait ~= nil and tolua.isnull(self._popWait) == false then
        self._popWait:removeFromParent()
        self._popWait = nil
    end 
end

-- 断网等待
function ClientScene:showReConnect()
    self:dismissReConnect()
    local reconnect = ClientPopWait.ReConnectPopWait:create(20, function(dt)
        if 10 == dt then
            print("尝试重连")
            self._gameFrame:setViewFrame(self._scene)
            self._gameFrame:OnResetGameEngine()
            self._gameFrame:onLogonRoom()
        elseif 0 >= dt then
            print("重连超时")
            local curTag = self._sceneLayer:getCurrentTag()
            if curTag == yl.SCENE_GAME then
                self:dismissReConnect()           
                self._gameFrame:onCloseSocket()
                self._gameFrame:removeNetQuery()
                self:onKeyBack()
            end
        end
    end)
    self:addChild(reconnect)
    reconnect:setLocalZOrder(yl.MAX_INT)
    self._popWait = reconnect
end

-- 刷新当前游戏
function ClientScene:updateCurrentGame()
    local info = self:getGameInfo(GlobalUserItem.nCurGameKind)
    self:updateEnterGameInfo(info)
end

-- 更新进入游戏记录
function ClientScene:updateEnterGameInfo( info )
    --更新前先清除数据
    GlobalUserItem.m_tabEnterGame = nil

    GlobalUserItem.m_tabEnterGame = info
end

-- 获取进入游戏记录
function ClientScene:getEnterGameInfo(  )
    return GlobalUserItem.m_tabEnterGame
end

-- 获取游戏信息
function ClientScene:getGameInfo(wKindID)
    for k,v in pairs(self:getApp()._gameList) do
        for m,z in pairs(v) do
            if tonumber(z._KindID) == tonumber(wKindID) then
                return z
            end
        end
    end
    return nil
end

-- 语音按钮
function ClientScene:createVoiceBtn(pos, zorder, parent)
    self._sceneLayer:createVoiceBtn(pos, zorder, parent)
end

-- 语音控制
function ClientScene:startVoiceRecord()
    self._sceneLayer:startVoiceRecord()
end

function ClientScene:stopVoiceRecord()
    self._sceneLayer:stopVoiceRecord()
end

function ClientScene:cancelVoiceRecord()
    self._sceneLayer:cancelVoiceRecord()
end

-- 游戏更新
function ClientScene:updateGame(dwKindID)
    return false
end

-- 链接游戏
function ClientScene:loadGameList(dwKindID)
    return false
end

function ClientScene:getPopLevel()
    local popLevel = nil
    local popList = self._scenePopLayer:getChildren()
    local popCount = #popList
    if 0 ~= popCount then
        local lastPop = popList[popCount]
        if nil ~= lastPop.getLevel then
            popLevel = popList[popCount]:getLevel() + 1
        else
            popLevel = TransitionLayer.SECOND_LEVEL
        end
    else
        popLevel = TransitionLayer.SECOND_LEVEL
    end
    return popLevel
end

-- 第三方分享
-- @parma[target] (0 无  1 朋友圈  2 微信好友  3 朋友圈和微信好友 4 面对面  5 朋友圈和面对面  6 微信好友和面对面  7 全部)
function ClientScene:popTargetShare( callback, target, level )
    local popLevel = level
    if nil == popLevel then
        popLevel = self:getPopLevel()
    end
    local tl = TargetShareLayer:create(self, {callback = callback, target = target}, popLevel)
    self:addPopLayer(tl)
end

-- 查询用户财富
function ClientScene:queryUserScoreInfo( queryCallBack )
end

-- 认证引导
function ClientScene:popIdentify()
--    local popLevel = self:getPopLevel()
--    local il = UserCenterLayer.IdentifyLayer:create(self, {}, popLevel)
--    self:addPopLayer(il)
    il:setRemoveListener(function()
        self:popReward()
    end)
end

-- 移除一个弹窗
function ClientScene:removePop()
    local bHandle = false
    local popList = self._scenePopLayer:getChildren()
    local popCount = #popList
    if popCount > 0 then
        local lastChild = popList[popCount]
        if nil ~= lastChild then
            if nil ~= lastChild.onKeyBack then
                bHandle = lastChild:onKeyBack()
            end
            if not bHandle then
                -- 动画
                if nil ~= lastChild.animationRemove then
                    lastChild:animationRemove()
                else
                    lastChild:removeFromParent()
                end
                bHandle = true
            end
        end
    end
    return bHandle
end

-- 移除所有弹窗
function ClientScene:removeAllPop()
    -- 移除弹窗
    local popList = self._scenePopLayer:getChildren()
    local popCount = #popList
    for k,v in pairs(popList) do
        if v:isVisible() then
            if v.animationRemove then
                v:animationRemove()
            else
                v:removeFromParent()
            end
        else
            v:removeFromParent()
        end
    end
end

-- 设置
function ClientScene:popSet()
    local plazalayer = self._sceneLayer:getChildByTag(yl.SCENE_PLAZA)
    if nil ~= plazalayer and nil ~= plazalayer.popSet then
        plazalayer:popSet()
    end
end

-- 战绩
function ClientScene:popMark()
    local plazalayer = self._sceneLayer:getChildByTag(yl.SCENE_PLAZA)
    if nil ~= plazalayer and nil ~= plazalayer.popMark then
        plazalayer:popMark()
    end
end

-- 分享
function ClientScene:popSpread()
    local plazalayer = self._sceneLayer:getChildByTag(yl.SCENE_PLAZA)
    if nil ~= plazalayer and nil ~= plazalayer.popSpread then
        plazalayer:popSpread()
    end
end

-- 客服
function ClientScene:popService()
    local plazalayer = self._sceneLayer:getChildByTag(yl.SCENE_PLAZA)
    if nil ~= plazalayer and nil ~= plazalayer.popService then
        plazalayer:popService()
    end
end

-- 商店
function ClientScene:popShopLayer( shopType )
    local plazalayer = self._sceneLayer:getChildByTag(yl.SCENE_PLAZA)
    if nil ~= plazalayer and nil ~= plazalayer.popShopLayer then
        plazalayer:popShopLayer(shopType)
    end
end

-- 房间
function ClientScene:enterRoomList()
--    local plazalayer = self._sceneLayer:getChildByTag(yl.SCENE_PLAZA)
--    if nil ~= plazalayer and nil ~= plazalayer.enterRoomList then
--        plazalayer:enterRoomList()
--    end
end

-- 获取公告
function ClientScene:requestNotice()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "read_messages"
    msgta["body"] = {}
    self._plazaFrame:sendGameData(msgta)
end

-- 获取个人安全信息
function ClientScene:requestSafeInfor()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "safe_accountInfo"
    msgta["body"] = {}
    self._plazaFrame:sendGameData(msgta)
end

--获取用户信息
function ClientScene:sendGetAccount()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "get_account"
    msgta["body"] = ""
    self._plazaFrame:sendGameData(msgta)
end

--获取支付宝银行卡绑定信息
function ClientScene:requestpPayWayInfor()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "get_zfb_account"
    msgta["body"] = ""
    self._plazaFrame:sendGameData(msgta)
end

return ClientScene