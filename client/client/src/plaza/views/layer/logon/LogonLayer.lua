--region *.lua
--Date 2017-2-25
--Author xufei
--Desc 
--此文件由[BabeLua]插件自动生成

local AccountLoginLayer = appdf.req(appdf.CLIENT_SRC .."plaza.views.layer.logon.AccountLoginLayer")
local LogonView = appdf.req(appdf.CLIENT_SRC .."plaza.views.layer.logon.LogonView")
local AccountView = appdf.req(appdf.CLIENT_SRC .."plaza.views.layer.logon.AccountView")
local AccountManager = appdf.req(appdf.CLIENT_SRC .."plaza.views.layer.logon.AccountManager")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .."ExternalFun")
local ServiceView  = appdf.req(appdf.CLIENT_SRC .."plaza.views.layer.plaza.ServiceView")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local LoginLayer = class("LoginLayer", cc.Layer)


local tabTips = 
{
    "有你这样的牌友陪着我，也不枉我选了这条路。",
    "唯一比凶猛的对手更可怕的是你错误的打牌方法。",
    "需要靠抽牌才能赢的时候你通常都抽不到。",
    "当你把对手套进去的时候，通常你自己也被套进去了。",
    "专业对手的行为总是可以预测的，但我们的对手大多不专业。",
    "那个一直弃牌的傻瓜才是可以一口吞掉你的巨鲨。",
    "装成保守的牌手，你的底牌会被想象的无限大。",
    "不要坐在两个比你更有攻击性的对手中间。",
    "不要用你所有的筹码去验证你没有根据的想法。",
    "人生无非是让别人笑笑，偶尔也笑笑别人。",
    "岁月是把杀猪刀，紫了葡萄，黑了木耳，软了香蕉。",
    "断臂也比失去生命强，牌局如此，人生亦如此。",
    "对于新手，不要随便ALL IN，记住“不见兔子不撒鹰”。",
    "下注要对得起自己的底牌。",
    "真正的绅士不会谈论离别的女人和错过的底牌。",
}

function LoginLayer:ctor(scene)
    self._scene = scene
    self._bFinishLoadRes = false
    self:enableNodeEvents()
    self.m_rootUI = display.newNode():addTo(self)
       --var
    self.m_percent_show = 0
    self.m_schuler_show = nil
    self.m_percent_login = 0
    self.m_schuler_login = nil
    --init csb
    self.m_pathUI = cc.CSLoader:createNode("login/LoginScene.csb")--("hall/csb/LoginView.csb")
    self.m_pathUI:addTo(self.m_rootUI)
    self.m_pathUI:setPositionY((display.height - 750) / 2)
    self.m_pNodeRootUI = self.m_pathUI:getChildByName("node_rootUI")
    self.m_pNodeRootUI:setPositionX((display.width - 1334) / 2)

    --背景图
    self.m_pImgBg           = self.m_pNodeRootUI:getChildByName("IMG_login_bg")
    --游戏LOGO
    self.m_pImgLogo         = self.m_pNodeRootUI:getChildByName("IMG_logo")
    --客服按钮
    self.m_BtnService       = self.m_pNodeRootUI:getChildByName("BTN_service")
    --按钮node
    self.m_node_btn         = self.m_pNodeRootUI:getChildByName("IMG_toolBg")
    self.m_BtnGuest         = self.m_node_btn:getChildByName("BTN_guest")   --游客登录button
    self.m_BtnLogin         = self.m_node_btn:getChildByName("BTN_login")   --账号登录button
    self.m_BtnAccount       = self.m_node_btn:getChildByName("BTN_account") --全部账号button
    --载入资源Node  
    self.m_pNodeLoad        = self.m_pNodeRootUI:getChildByName("IMG_loadBg")   --载入资源Node  
    self.m_pProgress        = self.m_pNodeLoad:getChildByName("Progress_bar")   --载入资源进度条
    self.m_ptheader         = self.m_pProgress:getChildByName("pt_header")
    --提示文字Node 
    self.m_pNodeTips        = self.m_pNodeRootUI:getChildByName("Node_Tips")
    self.m_lb_version       = self.m_pNodeTips:getChildByName("TXT_version")

    self.m_BtnGuest:addClickEventListener(handler(self, self.onVisitorClicked))
    self.m_BtnLogin:addClickEventListener(handler(self, self.onLoginClicked))
    self.m_BtnAccount:addClickEventListener(handler(self, self.onAccountClicked))
    self.m_BtnService:addClickEventListener(handler(self, self.onServiceClicked))

--    self.skeletonNode = sp.SkeletonAnimation:create("hall/effect/login-animation/animation.json", "hall/effect/login-animation/animation.atlas", 1)
--    self.skeletonNode:setPosition(cc.p(812 ,375))
--    self.skeletonNode:setAnimation(0, "animation", true)
--    self.skeletonNode:update(0)
--    self.skeletonNode:addTo(self.m_pImgBg)
    --fix 客服按钮全面屏适配
    local posX = 1334 + (display.size.width - 1334)/2 - 100
    self.m_BtnService:setPositionX(posX)
    --初始化进度条
    self.m_pNodeLoad:setVisible(false)
    self.m_pProgress:setPercent(0)
    local size = self.m_pProgress:getVirtualRendererSize()
	self.m_ptheader:setPositionX(size.width * 0 / 100)

    local verstr = self._scene:getApp():getVersionMgr():getResVersion() or "0"
    -- 重新设置版本号
    local strVersion1 = appdf.BASE_C_VERSION
    local strVersion2 = verstr
    local strVersion3 = string.sub(strVersion2, 4, -1)
    local strVersion = string.format("%s%s", strVersion1, strVersion3)
    self.m_strVersion = strVersion
    self.m_lb_version:setString(strVersion)

    --显示fps时移动位置
    if cc.Director:getInstance():isDisplayStats() then
        self.m_lb_version:setPosition(display.cx / 2, display.cy)
    end

        --下方提示语
    self.m_lbTips = ccui.RichText:create()
    self.m_lbTips:setPosition(display.cx, 12)
    self.m_lbTips:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_lbTips:addTo(self.m_pNodeTips)

    --随机提示语
    self.m_String_format = cc.exports.Localization_cn["LOADING_FORMAT"]
    self.m_String_word = tabTips--GameDefine["STRING_TIPS_HALL"]
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))

    --下方提示语
    self:onUpdateWord()
    self.m_onUpdate_word = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        self:onUpdateWord()
    end, 10.0,false)
end
function LoginLayer:onUpdateWord()

    --新的标语
    self.m_lbTipsNew = ccui.RichText:create()
    self.m_lbTipsNew:setPosition(667, 45)
    self.m_lbTipsNew:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_lbTipsNew:setOpacity(0)
    self.m_lbTipsNew:setVisible(false)
    self.m_lbTipsNew:addTo(self.m_pNodeTips)
    
    --设置语句
    math.newrandomseed()
    local nRandom = math.random(1, #self.m_String_word)
--    local strTip = string.format(self.m_String_format, self.m_String_word[nRandom])
    --print("strTips", strTip)
    local re1 = ccui.RichElementText:create(1,cc.c3b(255, 255, 255), 255,self.m_String_word[nRandom], "fonts/round_body.ttf", 22)
--    self.m_lbTipsNew:initWithXML(strTip, {})
    self.m_lbTipsNew:pushBackElement(re1)
    self.m_lbTipsNew:formatText()

    --切换新标语
    self.m_lbTipsNew:runAction(cc.Sequence:create(
        cc.Hide:create(),
        cc.CallFunc:create(function() --旧的渐隐
            if self.m_lbTips then
                self.m_lbTips:runAction(cc.FadeOut:create(1.0))
            end
        end),
        cc.DelayTime:create(self.m_lbTips and 1.05 or 0.05),
        cc.CallFunc:create(function() --旧的删除
            if self.m_lbTips then
                self.m_lbTips:removeFromParent()
                self.m_lbTips = nil
            end
        end),
        cc.Show:create(),
        cc.FadeIn:create(1.0), --新的渐现
        cc.CallFunc:create(function()
            self.m_lbTips = self.m_lbTipsNew
            self.m_lbTipsNew = nil
        end)))
end
function LoginLayer:onEnter()
    performWithDelay(self,function()  
         self:onUpdateButton(true) --显示登录按钮
    end,1)
end

function LoginLayer:onExit()
    if self.m_onUpdate_word then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_onUpdate_word)
        self.m_onUpdate_word = nil
    end
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("hall/effect/login-animation/login-animation.ExportJson")
end

function LoginLayer:onUpdateButton(bVisible)
--    -- 按钮移动动画
--    if bVisible then
--        local action = cc.CSLoader:createTimeline("hall/csb/LoginView.csb")
--        action:play("animation0", false)
--        self.m_pathUI:runAction(action)
--    end

--    --登录按钮
--    self.m_loginBtn:setVisible(bVisible)
--    self.m_registerBtn:setVisible(bVisible)
--    self.m_visitorLoginBtn:setVisible(bVisible)
--    self.m_serviceBtn:setVisible(bVisible)
        -- 按钮移动动画
    if bVisible then
--        local action = cc.CSLoader:createTimeline("login/LoginScene.csb")--("hall/csb/LoginView.csb")
--        action:play("animation0", false)
--        self.m_pathUI:runAction(action)

        local moveBy1 = cc.MoveBy:create(0.3,cc.p(0,300))
        local moveBy2 = cc.MoveBy:create(0.1,cc.p(0,-40))
        local moveBy3 = cc.MoveBy:create(0.1,cc.p(0,20))        

        local eventFrameCall = function(frame)
            self:checkAutoLogin()
            self.m_BtnLogin:setTouchEnabled(true)
            self.m_BtnAccount:setTouchEnabled(true)
            self.m_BtnGuest:setTouchEnabled(true)
        end
        local func = cc.CallFunc:create(eventFrameCall)
--        action:setLastFrameCallFunc(eventFrameCall)
        self.m_node_btn:runAction(cc.Sequence:create(moveBy1,moveBy2,moveBy3,func))

        self.m_BtnLogin:setVisible(true)
        self.m_BtnAccount:setVisible(true)
        self.m_BtnGuest:setVisible(true)
    else
        self.m_BtnLogin:setVisible(false)
        self.m_BtnAccount:setVisible(false)
        self.m_BtnGuest:setVisible(false)
    end

    --屏蔽客服按钮
--    local isClosedService = GameListManager.getInstance():isCloseService()
--    if self.m_BtnService and isClosedService then
--        self.m_BtnService:setVisible(false)
--    end
end

function LoginLayer:onMsgNetworkFail()
    cc.exports.Veil.getInstance():HideVeil()
end

function LoginLayer:onMsgLoginNetworkFail()

    FloatMessage.getInstance():pushMessage("STRING_043")
    cc.exports.closeConnectSocket()
    cc.exports.Veil.getInstance():HideVeil()
end

function LoginLayer:PreLoadResoure()

    if self._bFinishLoadRes then
        SLFacade:dispatchCustomEvent(Hall_Events.Hall_Entry)
        return
    end
   -----------------------------------
   ------预加载资源
   -----------------------------------
    --image大图
    local imagePath = 
    {
        "hall/image/file/bg1-hall.jpg",
    }

    local m_nImageOffset = 0
    local totalSource = #yl.vecReleasePlist
    local function imageLoaded(texture)
         m_nImageOffset = m_nImageOffset + 1
         self.m_pProgress:setPercent(m_nImageOffset / totalSource * 100)
         local size = self.m_pProgress:getVirtualRendererSize()
	     self.m_ptheader:setPositionX(size.width * (m_nImageOffset / totalSource * 100) / 100)
         if m_nImageOffset == totalSource then
             --加载plist
            for k, v in pairs(yl.vecReleasePlist) do
               --if false == cc.SpriteFrameCache:getInstance():isSpriteFramesWithFileLoaded(v[1]) then
               if true then
		            cc.SpriteFrameCache:getInstance():addSpriteFrames(v[1])
		            --手动retain所有的头像帧缓存、防止被释放
		            local dict = cc.FileUtils:getInstance():getValueMapFromFile(v[1])
		            local framesDict = dict["frames"]
		            if nil ~= framesDict and type(framesDict) == "table" then
			            for k,v in pairs(framesDict) do
				            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(k)
				            if nil ~= frame then
					            frame:retain()
				            end
			            end
		            end
	            end
            end

            for i = 1, #imagePath do --大图
                display.loadImage(imagePath[i])
            end
            self._bFinishLoadRes = true
            SLFacade:dispatchCustomEvent(Hall_Events.Hall_Entry)
         end
    end

    --加载png
    for k, v in pairs(yl.vecReleasePlist) do
        cc.Director:getInstance():getTextureCache():addImageAsync(v[2], imageLoaded)
    end
end

--登录完成,为避免进入大厅卡顿,有限加载部分资源
function LoginLayer:onLoginFinish(_event)
    --登录按钮
    self.m_node_btn:setVisible(false)
    self.m_pNodeLoad:setVisible(true)
    self.m_pProgress:setPercent(0)
    local size = self.m_pProgress:getVirtualRendererSize()
	self.m_ptheader:setPositionX(size.width * 0 / 100)
    
    --关闭相关界面
    local LogonView = self.m_rootUI:getChildByName("LogonView")
    if LogonView ~= nil then
        LogonView:onMoveExitView()
    end
     local loginLayer = self.m_rootUI:getChildByName("AccountLoginLayer")
    if loginLayer ~= nil then
        loginLayer:onMoveExitView()
    end

    self:PreLoadResoure()
end

-----------------------------------------------
function LoginLayer:checkAutoLogin()
    if not self:isNeedAutoLogin() then
       return
    end
    -- 等待0.5秒自动登录
    self:ActionDelay(self, function()
        self:sendAutoLogin()
    end, 0.5)
end

--是否需要自动登录
function LoginLayer:isNeedAutoLogin()
    local lastLoginType = cc.UserDefault:getInstance():getIntegerForKey("loginAccountType")
    if lastLoginType == 0 then
       return false
    end

    local isNeedAutoLogin = cc.UserDefault:getInstance():getBoolForKey("noNeedAutoLogin")
    if isNeedAutoLogin then
       cc.UserDefault:getInstance():setBoolForKey("noNeedAutoLogin",false)
       return false
    end

    return true
end

function LoginLayer:ActionDelay(_delegate, call, time)
    
    local delay = cc.DelayTime:create(time or 0.3)
    local callback = cc.CallFunc:create(handler(_delegate, call))
    local seq = cc.Sequence:create(delay, callback)
    _delegate:runAction(seq)
end

--处理自动登录
function LoginLayer:sendAutoLogin()
   local lastLoginType = cc.UserDefault:getInstance():getIntegerForKey("loginAccountType")
   if lastLoginType == yl.LOGON_TYPE.ACCOUNT  then

        local account = cc.UserDefault:getInstance():getStringForKey("Account")
        local password = cc.UserDefault:getInstance():getStringForKey("Password")
        if string.len(account) < 1 or string.len(password) < 1 then
            return false
        else
            self:sendAccountLogin(account, password)
        end
    elseif lastLoginType == yl.LOGON_TYPE.VISTOR then   --游客账号

        self:sendGuestLogin()

   elseif lastLoginType == yl.LOGON_TYPE.WECHAT then

        local account = cc.UserDefault:getInstance():getStringForKey("wAccount")
        local Openid = cc.UserDefault:getInstance():getStringForKey("Openid")
        local Nick = cc.UserDefault:getInstance():getStringForKey("Nick")
        local NGender = cc.UserDefault:getInstance():getStringForKey("NGender")
        if string.len(account) < 1 or string.len(Openid) < 1 or string.len(Nick) < 1 or string.len(NGender) < 1 then
            return false
        else
            self:logonByWeChat(Openid, account, Nick, NGender)
        end
   elseif lastLoginType == yl.LOGON_TYPE.PHONE then

        local account = cc.UserDefault:getInstance():getStringForKey("pAccount")
        if string.len(account) < 1 then
            return false
        else
            self:phoneNumAccount(account)
        end
   end

end

function LoginLayer:sendGuestLogin()
    self._scene:VisitorAccount()
end

function LoginLayer:logonByWeChat(openid, account, nick, nGender)
    self._scene:logonByWeChat(openid, account, nick, nGender)
end

function LoginLayer:phoneNumAccount(account)
    self._scene:phoneNumAccount(account)
    self.phoneNumforYanzhengma = account
end

function LoginLayer:sendAccountLogin(name, pswd)
    self._scene:logonByAccount(name, pswd)
end

function LoginLayer:onLoginClicked()
--    ExternalFun.playClickEffect()

--    if self.m_rootUI:getChildByName("AccountLoginLayer") then
--        return
--    end

--    --打开账户登录界面
--    local loginLayer = AccountLoginLayer.create()
--    loginLayer.delegate = self
--    loginLayer:setName("AccountLoginLayer")
--    loginLayer:addTo(self.m_rootUI, 10)
    self:onRegisterClicked()
end

function LoginLayer:onRegisterClicked()
    ExternalFun.playClickEffect()

    --打开登陆界面
    local LogonView = LogonView.create(1, self._scene)
    LogonView:setName("LogonView")
    LogonView:addTo(self.m_rootUI, 10)
end
function LoginLayer:onAccountClicked()
    ExternalFun.playClickEffect()

    -- 防连点 ----------------
    local nCurTime = os.time()
    if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 0 then
        return
    end
    self.m_nLastTouchTime = nCurTime
    ---------------------------
    --屏蔽全部账号，使用上次登录
--    self.pAccountView = AccountView:create(self)
--    self.pAccountView:setName("AccountView")
--    self.pAccountView:addTo(self.m_rootUI, 10)
--    self:sendAutoLogin()
    self:sendGuestLogin()
end
function LoginLayer:onServiceClicked()
    
    ExternalFun.playClickEffect()

    -- 防连点 ----------------
    local nCurTime = os.time()
    if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 0 then
        return
    end
    self.m_nLastTouchTime = nCurTime
    ---------------------------
        --客服界面
    ServiceView.create():addTo(self.m_rootUI, 10)
    
end

function LoginLayer:onVisitorClicked()
    ExternalFun.playClickEffect()

    -- 防连点 ----------------
    local nCurTime = os.time();
    if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 0 then
        return
    end
    self.m_nLastTouchTime = nCurTime
    ---------------------------

    -- 游客登录
    --self:sendGuestLogin()
    self._scene:thirdPartyLogin(yl.ThirdParty.WECHAT)
end

function LoginLayer:getYanzhengmaView()
--    self:onRegisterClicked()
    local LoginView = self.m_rootUI:getChildByName("LogonView")
    if LoginView == nil then
        --打开登录界面
        LoginView = LogonView.create(1, self._scene)
        LoginView:setName("LogonView")
        LoginView:addTo(self.m_rootUI, 10)
        LoginView.m_pathUI:removeFromParent()
        LoginView.m_pathUI_yanzhengma:setVisible(true)
    --    registerView.strCellPhone = self.phoneNumforYanzhengma
        LoginView.logonLayerGetYanzhengma = self.phoneNumforYanzhengma       
    end
    
end
return LoginLayer
--endregion
