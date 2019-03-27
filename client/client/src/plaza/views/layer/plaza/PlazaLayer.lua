--
-- Author: zhong
-- Date: 2017-05-24 10:39:00
--
-- 大厅层
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local PlazaLayer = class("PlazaLayer", TransitionLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local UIPageView = appdf.req(appdf.EXTERNAL_SRC .. "UIPageView")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame") 
local HallGameListView = appdf.req(appdf.CLIENT_SRC .. "plaza.views.layer.plaza.HallGameListView")     --游戏列表

--功能界面
local HallViewClassify    = appdf.req(appdf.PLAZA_VIEW_SRC.."HallViewClassify")                     --游戏列表
local ExchangeCenterLayer = appdf.req(appdf.PLAZA_VIEW_SRC .."ExchangeCenterLayer")                 --提现界面
local MessageCenterLayer  = appdf.req(appdf.PLAZA_VIEW_SRC .. "MessageCenterLayer")                 --消息界面
local RechargeLayer       = appdf.req(appdf.PLAZA_VIEW_SRC.."bean.RechargeLayer")                   --充值界面
local ServiceView         = appdf.req(appdf.PLAZA_VIEW_SRC .. "ServiceView")                        --在线客服界面
local ServiceCenterView   = appdf.req(appdf.PLAZA_VIEW_SRC .. "ServiceCenterView")                  --客服界面
local SettingView         = appdf.req(appdf.PLAZA_VIEW_SRC .. "SettingLayer")                       --设置界面
local SpreadLayer         = appdf.req(appdf.PLAZA_VIEW_SRC.."SpreadLayer")                          --推广界面
local UserCenterLayer     = appdf.req(appdf.PLAZA_VIEW_SRC .. "UserCenterLayer")                    --用户中心
local SuggestLayer        = appdf.req(appdf.PLAZA_VIEW_SRC .."SuggestLayer")                        --你提我改
local CommonGoldView      = appdf.req(appdf.PLAZA_VIEW_SRC.."CommonGoldView")                       --通用金币框
local RegisterActDlg      = appdf.req(appdf.PLAZA_VIEW_SRC.."RegisterActivityDlg")                  --注册送金币
local RoomChooseLayer     = appdf.req(appdf.PLAZA_VIEW_SRC.."RoomChooselayer")                      -- 房间列表
local BankInfoLayer       = appdf.req(appdf.PLAZA_VIEW_SRC .. "BankInfoLayer")                      -- 银行
local ShopLayer           = appdf.req(appdf.PLAZA_VIEW_SRC .. "ShopLayer")                          -- 商城
local RankLayer           = appdf.req(appdf.PLAZA_VIEW_SRC .. "RankLayer")                          -- 排行榜
local BindZhifubaoView    = appdf.req(appdf.PLAZA_VIEW_SRC.."bean.BindZhifubaoView")                --绑定支付宝界面
local BindBankView        = appdf.req(appdf.PLAZA_VIEW_SRC.."bean.BindBankView")                    --绑定银行卡界面
local VipLayer            = appdf.req(appdf.PLAZA_VIEW_SRC .. "VipLayer")                           -- vip
local RegisterView        = appdf.req(appdf.CLIENT_SRC .."plaza.views.layer.logon.RegisterView")    --注册界面
local AnnouncementCenter  = appdf.req(appdf.PLAZA_VIEW_SRC .. "AnnouncementCenter")                 --公告界面
local AdView              = appdf.req(appdf.PLAZA_VIEW_SRC .. "AdView")                             --左侧广告栏
local ActivityNoticeView  = appdf.req(appdf.PLAZA_VIEW_SRC .. "ActivityNoticeView")                 --公告界面
--定义
local Z_ORDER_HIDDEN      = -10
local Z_ORDER_BOTTOM      = 0
local Z_ORDER_BACKGROUND  = 10
local Z_ORDER_STATIC      = 20
local Z_ORDER_MINDDLE     = 40
local Z_ORDER_COMMON      = 50
local Z_ORDER_OVERRIDE    = 80
local Z_ORDER_MODAL       = 90
local Z_ORDER_TOP         = 100
function PlazaLayer:ctor( scene, param )
    PlazaLayer.super.ctor( self, scene, param )
        --房间相关
    self.m_pGameListView    = nil --游戏列表
    self.m_pModeChooseView  = nil --模式列表
    self.m_pRoomChooseView  = nil --房间列表
    self.m_pMarqueeMsg      = nil --公告信息
    self.m_pHallMainGameListView = nil--审核游戏房间

    self.m_nLastTouchTime = nil

    self.m_pBtnCharge = {} --充值按钮
    self.m_pBtnUserInfo     = {}    --个人信息中心
    self.m_pHallSceneArm    = nil   --大厅背景动画
    --开关
    self.isShowRelieve      = true --返回大厅是否显示救济金
    self.m_bEnterGame = false --是否拉进游戏

    -- 大厅交互动画
    self.m_pHallEnterAction = nil
    
    --模糊背景
    --self.blurSprite = nil
    --烟花节点
    --self.m_funcUpdate = nil
    self.m_iUpdateActionIndex = 0
    self._logonFrame = LogonFrame:getInstance()
    local logonCallBack = function (result,message)
        self:onLogonCallBack(result,message)
    end
    self._logonFrame = LogonFrame:getInstance()
    self._logonFrame:setCallBackDelegate(self, logonCallBack)
    --初始化随机种子
    math.newrandomseed()
    self:initCCB()
    self:initEvent()
    self:initBtnEvent()
    self:initHall()
end


function PlazaLayer:initCCB()
    self:setPosition(0, 0)

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
   
    --init csb
    self.m_pathUI = cc.CSLoader:createNode("dt/GameHallScene.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))
    
    self.m_pNodeRootUI = self.m_pathUI:getChildByName("HallView"):getChildByName("node_hallUI")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRootUI:setPositionX(diffX)

    self.image_topBar = self.m_pNodeRootUI:getChildByName("image_topBar")
    self.panel_bottomBar = self.m_pNodeRootUI:getChildByName("panel_bottomBar")
    self.scrollView_littlegamescroll = self.m_pNodeRootUI:getChildByName("scrollView_littlegamescroll")
    self.adPanel            = self.m_pNodeRootUI:getChildByName("panel_adPanel")
    if LuaUtils.isIphoneXDesignResolution() then
         self.adPanel:setPositionX(0)
    end
    --顶部按钮
    self.m_pQuanmindaili    = self.image_topBar:getChildByName("button_downloadEWMnew"):getChildByName("fileNode_tuiguangRun")
    self.m_pUserInfo        = self.image_topBar:getChildByName("panel_userInfoPanel"):getChildByName("node_portrait"):getChildByName("Button_userinfo")

    --顶部文字
    self.m_pNameNick         = self.image_topBar:getChildByName("panel_userInfoPanel"):getChildByName("text_userName")
    self.m_pIDText           = self.image_topBar:getChildByName("panel_userInfoPanel"):getChildByName("text_userId")
    self.m_pSpVip            = self.image_topBar:getChildByName("panel_userInfoPanel"):getChildByName("node_portrait"):getChildByName("sprite_vipSpr")
    self.m_pSpFrameImage     = self.image_topBar:getChildByName("panel_userInfoPanel"):getChildByName("node_portrait"):getChildByName("image_portrait")
    self.m_pSpHeadImage     = self.image_topBar:getChildByName("panel_userInfoPanel"):getChildByName("node_portrait"):getChildByName("image_portraitFrame")
    --底部按钮
    self.m_pBtnCharge       = self.panel_bottomBar:getChildByName("button_shopBtn")
    self.m_pBtnRank         = self.panel_bottomBar:getChildByName("button_rankBtn")
    self.m_pBtnNotice       = self.panel_bottomBar:getChildByName("button_activtyNoticeBtn")
    self.m_pBtnBank         = self.panel_bottomBar:getChildByName("button_safeBtn")
    self.m_pBtnService      = self.panel_bottomBar:getChildByName("button_supportBtn")
    self.m_pBtnShare        = self.panel_bottomBar:getChildByName("button_downloadEWM")
    self.m_pBtnCash         = self.panel_bottomBar:getChildByName("button_exchangeBtn")
    self.m_pBtnMail         = self.panel_bottomBar:getChildByName("button_mailBtn")
    --大厅喇叭
    --self.m_pNodeMarqueue    = self.m_pNodeRootUI:getChildByName("node_marque")

    -- 大厅通用顶部金币和银行
    self.m_commonGoldUI = CommonGoldView:create("HallSceneLayer_CommonGoldView")
    self.m_commonGoldUI:setPosition(ccp(330,35))
    self.m_commonGoldUI:addTo(self.image_topBar)
  
    --所有按钮
    self.m_pButtonAll = {
        self.m_pBtnRank,
        self.m_pBtnCash,    
        self.m_pBtnBank,    
        self.m_pBtnService, 
        self.m_pBtnShare,   
        self.m_pBtnCharge,
        self.m_pBtnNotice,
        self.m_pUserInfo,

    }


    ExternalFun.playCSBani("dt/tuiguang.csb", "tuiguang", self.m_pBtnShare, true)
    ExternalFun.playCSBani("dt/shop_effect.csb", "animation0",self.m_pBtnCharge, true)
    --防止点击按钮
    self:setButtonEnable(false)
    self:addRollmsgView()

end


--界面事件---------------------------------------

function PlazaLayer:addRollmsgView(bEnable)
    -- 滚动消息 ------------------
    local r = require(appdf.EXTERNAL_SRC .."RollMsg").new()
    cc.exports.RollMsg.getInstance = function() return r end
    r:setPosition(0, 0)
    r:addTo(self.m_pNodeRootUI)
end

function PlazaLayer:setButtonEnable(bEnable)
    print("======bEnable:",bEnable)
    for i, button in pairs(self.m_pButtonAll) do
        button:setTouchEnabled(bEnable)
    end
end

function PlazaLayer:refreshButtonPos()
 
   if GlobalUserItem.tabAccountInfo.telephone == "" then --未绑定手机
      self.m_pBtnGuest:setVisible(true)
       return
   else
      self.m_pBtnGuest:setVisible(false)
   end

   local distance_all = self.m_pStopX - self.m_pStartX

    local button_show = {}
    for i, btn in pairs(self.m_pButtonDown) do
        if btn:isVisible() then
            table.insert(button_show, btn)
        end
    end

    local button_width = {}
    for i, btn in pairs(button_show) do
        button_width[i] = btn:getContentSize().width
    end

    local distance_button = 0
    for i, width in pairs(button_width) do
        if i == 1 or i == #button_width then
            distance_button = distance_button + width / 2
        else
            distance_button = distance_button + width
        end
    end

    local distance_free = (distance_all - distance_button) / (#button_show - 1)

    local fix_pos = {}
    for i, width in ipairs(button_show) do
        if i == 1 then
            fix_pos[i] = self.m_pStartX
        elseif i == #button_show then
            fix_pos[i] = self.m_pStopX
        else
            fix_pos[i] = fix_pos[i - 1] + button_width[i - 1] / 2 + distance_free + button_width[i] / 2
        end
    end

    for i, btn in pairs(button_show) do
        btn:setPositionX(fix_pos[i])
    end
end

-- 进大厅界面动画
function PlazaLayer:showEnterHallAction()
    print("========showEnterHallAction==========")
    if self.m_pHallEnterAction then
        self.m_pathUI:stopAction(self.m_pHallEnterAction)
        self.m_pHallEnterAction = nil
    end
    local actionName = "ActionNormal"
    self.m_pHallEnterAction = cc.CSLoader:createTimeline("hall/csb/HallViewNew.csb")
    self.m_pathUI:runAction(self.m_pHallEnterAction)
    self.m_pHallEnterAction:play(actionName, false)
    
    local eventFrameCall = function(frame)  
        self.m_pHallEnterAction:clearFrameEventCallFunc()
        self.m_pHallEnterAction = nil
        self:setButtonEnable(true)
        --未绑定手机号直接弹出小姐姐注册界面
        local guest = GlobalUserItem.tabAccountInfo.telephone
        if guest == "" then
            if not GlobalUserItem.tabUserLogonInfor.isGuideRegister then
                self:showGuestNotice()
                GlobalUserItem.tabUserLogonInfor.isGuideRegister = true
            end
        end
    end

    self.m_pHallEnterAction:setLastFrameCallFunc(eventFrameCall)
end


function PlazaLayer:initBtnEvent()
      -- 玩家按钮
    self.m_pUserInfo:addClickEventListener(handler(self,self.onHeadBtnClicked))
    --充值按钮
    self.m_pBtnCharge:addClickEventListener(handler(self,self.onShopClicked))

    -- 点击放大倍数
    --self.m_pBtnGuest:setZoomScale(0.3)
    self.m_pBtnRank:setZoomScale(0.3)
    self.m_pBtnCash:setZoomScale(0.3)
    self.m_pBtnBank:setZoomScale(0.3)
    self.m_pBtnService:setZoomScale(0.3)
    self.m_pBtnShare:setZoomScale(0.3)
    --self.m_pBtnNotice:setZoomScale(0.3)
    --self.m_pBtnVip:setZoomScale(0.3)

    -- 绑定按钮
    --self.m_pBtnGuest:addClickEventListener(handler(self,self.onGuestClicked))
    self.m_pBtnRank:addClickEventListener(handler(self,self.onRankClicked))
    self.m_pBtnCash:addClickEventListener(handler(self,self.onCashClicked))
    self.m_pBtnBank:addClickEventListener(handler(self,self.onBankClicked))
    self.m_pBtnService:addClickEventListener(handler(self,self.onServiceClicked))
    self.m_pBtnShare:addClickEventListener(handler(self,self.onSpreadClicked))
    self.m_pBtnNotice:addClickEventListener(handler(self,self.onNoticeClicked))
    self.m_pBtnMail:addClickEventListener(handler(self,self.onMailClicked))
end


function PlazaLayer:initHall() 
    --游戏分类界面
    self.m_pClassifyLayer = HallViewClassify:create(self._scene)
    self.m_pClassifyLayer:setVisible(true)
    self.m_pClassifyLayer:addTo(self.m_pNodeRootUI)  

    self.m_pAdView = AdView:create()
    self.m_pAdView:setPosition(self.adPanel:getContentSize().width/2, self.adPanel:getContentSize().height/2 )
    self.adPanel:addChild(self.m_pAdView)

    self.scrollView_littlegamescroll:setVisible(false)
    --用户信息
    self:updateUserInfo()

    --响应更新用户数据
    --self:onMsgUpdateUserScore()
    

    --启动一个定时器，如果30秒后，还没拉取到游戏列表，显示刷新按钮
    --self:doWaitRefresh()

    --更新游戏列表
--    self:updateGameListView(nil)
end

function PlazaLayer:getSpine(spineName)
       armature = sp.SkeletonAnimation:create(spineName..".json", spineName..".atlas", 1)
       return armature
end

function PlazaLayer:onEnterTransitionFinish()

    PlazaLayer.super.onEnterTransitionFinish(self)
    self:showEnterHallAction()

    -- 创建头像
    local head = HeadSprite:createClipHead(GlobalUserItem.tabAccountInfo, 76)
    if nil ~= head then
        head:setPosition(ccp(self.m_pSpHeadImage:getPositionX()-1,self.m_pSpHeadImage:getPositionY()-1))
        head:setAnchorPoint(cc.p(0,0))
        self.m_pSpFrameImage:addChild(head)
        self._head = head
        --self.m_pSpHeadImage:setVisible(false)
    end

    --播放大厅背景音乐
    ExternalFun.playPlazzBackgroudAudio()

end

function PlazaLayer:onExit()
    if nil ~= self.m_listener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.m_listener)
        self.m_listener = nil
    end 

    self:cleanEvent()
    self:cleanHall()

    PlazaLayer.super.onExit(self)
end

function PlazaLayer:popNoticeLayer()
    local pn = NoticeLayer:create(self._scene, {} , NoticeLayer.SECOND_LEVEL)
    self._scene:addPopLayer(pn)
end


-- 弹出战绩
function PlazaLayer:popMark()
    local ul = BankInfoLayer:create(self._scene, {}, BankInfoLayer.SECOND_LEVEL)
    self._scene:addPopLayer(ul)  
end

-- 弹出设置
function PlazaLayer:popSet()
    local st = SettingLayer:create(self._scene, {}, SettingLayer.SECOND_LEVEL)
    self._scene:addPopLayer(st)
end

function PlazaLayer:popRankLayer()
    local rl = RankListLayer:create(self._scene, {}, RankListLayer.SECOND_LEVEL)
    self._scene:addPopLayer(rl)

end 

-- 弹出客服
function PlazaLayer:popService()
    local ser = ServiceLayer:create(self._scene, {}, ServiceLayer.SECOND_LEVEL)
    self._scene:addPopLayer(ser)
end

-- 弹出商店
function PlazaLayer:popShopLayer( shopType )
    -- 是否开启
--    local sl = ShopLayer:create(self._scene, shopType, ShopLayer.SECOND_LEVEL)
    local sl = RechargeLayer:create(self._scene, shopType, ShopLayer.SECOND_LEVEL)
    self._scene:addPopLayer(sl)
end

-- 弹出玩法
function PlazaLayer:popIntroduction()
end

-- 进入房间列表
function PlazaLayer:enterRoomList()
    local sl = RoomListLayer:create(self._scene, {}, RoomListLayer.SECOND_LEVEL)
    self._scene:addPopLayer(sl)
    sl:setName(yl.PLAZA_ROOMLIST_LAYER)
end
function PlazaLayer:onUserInfoChange( event  )
    print("----------userinfo change notify------------")

    local msgWhat = event.obj
    
    if nil ~= msgWhat then
        if msgWhat == yl.RY_MSG_USERHEAD then
            --更新头像
            if nil ~= self._head then
                self._head:updateHead(GlobalUserItem)
            end
        elseif msgWhat == yl.RY_MSG_USERWEALTH then
            --更新财富
            self:updateUserInfo()
        elseif msgWhat == yl.RY_MSG_USERIDENTIFY then
        end
    end
end

function PlazaLayer:updateScrollWebsite()
    --官网地址:
    self.m_pLbWebSit:setString("www.tianshen898.com")
    self.m_pLbWebSit:setFontSize(32)
end

--更新用户信息
function PlazaLayer:updateUserInfo()

	--用户昵称
	--self.m_pNameNick:setColor(cc.c3b(255, 230, 174))
	self.m_pNameNick:setString(GlobalUserItem.tabAccountInfo.nickname)
    --local v =  { "hall/plist/gui-vip.plist", "hall/plist/gui-vip.png", }
    --display.loadSpriteFrames(v[1], v[2])
    --vip等级
    --local vip_lv = GlobalUserItem.tabAccountInfo.vip_level
    --local vip_path = string.format("hall/plist/vip/img-vip%d.png", vip_lv)
    --self.m_pSpVip:loadTexture(vip_path, ccui.TextureResType.plistType)

    --ID
    self.m_pIDText:setString("ID:"..GlobalUserItem.tabAccountInfo.userid)
    --self.m_pIDText:setColor(cc.c3b(255, 230, 174))
    --头像框
    --local frame = GlobalUserItem.tabAccountInfo.vip_level
    --local framePath = string.format("hall/plist/userinfo/gui-frame-v%d.png", frame)
    --self.m_pSpFrameImage:loadTexture(framePath, ccui.TextureResType.plistType)

    local head = HeadSprite:createNormal(GlobalUserItem.tabAccountInfo, 76)
    if nil ~= head then
        head:setPosition(ccp(self.m_pSpHeadImage:getPositionX()-1,self.m_pSpHeadImage:getPositionY()-1))
        head:setAnchorPoint(cc.p(0,0))
        self.m_pSpFrameImage:addChild(head)
        self._head = head
        --self.m_pSpHeadImage:setVisible(false)
    end
end

function PlazaLayer:initEvent()

    self.event_ = {
       
        -- 注册自定义事件
        { name = Hall_Events.MSG_SHOW_REGISTER,             handle = self.showRigstView },
        { name = Hall_Events.MSG_SHOW_SHOP,                 handle = self.Handle_Custom_Ack },
        { name = Hall_Events.GAMELIST_CLICKED_GAME,         handle = self.Handle_Custom_Ack },
        { name = Hall_Events.ROOMLIST_BACK_TO_GAMELIST,     handle = self.Handle_Custom_Ack },
        { name = Hall_Events.SHOW_CHOOSE_ROOM_DLG,          handle = self.Handle_Custom_Ack },
        { name = Hall_Events.MSG_UPDATE_RELIEVE,            handle = self.Handle_Custom_Ack },
        { name = Hall_Events.MSG_SHOW_ROOM_CHOOSE_LAYER,    handle = self.Handle_Custom_Ack },
        { name = Hall_Events.SHOW_EXCHANGE_VIEW,            handle = self.Handle_Custom_Ack },
        { name = Hall_Events.MSG_HALL_CLICKED_GAME,         handle = self.Handle_Custom_Ack },
        { name = Hall_Events.UPDATA_HALL_MSG_TAG,           handle = self.Handle_Custom_Ack },
        { name = Hall_Events.MSG_UPDATE_REVERT,             handle = self.Handle_Custom_Ack },
        { name = Hall_Events.MSG_NICK_HEAD_MODIFIED,        handle = self.Handle_Custom_Ack },
        { name = Hall_Events.SHOW_BIND_VIEW,                handle = self.Handle_Custom_Ack },
        { name = Hall_Events.SHOW_SPREAD_ACTIVITY,          handle = self.Handle_Custom_Ack },
        { name = Hall_Events.SHOW_EXIT_VIEW,                handle = self.ExitPlaza },
        { name = Hall_Events.SHOW_OPEN_BANK,                handle = self.OpenBank },
        { name = Hall_Events.MSG_OPEN_HALL_LAYER,           handle = self.onOpenLayer },
        { name = Hall_Events.MSG_POP_NOTICE,                handle = self.showNoticePop },
        { name = Hall_Events.MSG_REGISTER_OK,               handle = self.OnRegisterOK },
        { name = Hall_Events.MSG_OPEN_EXCHANE_LAYER,        handle = self.openExchengeLayer },
        { name = Hall_Events.MSG_CLOSE_SPREAD_LAYER,        handle = self.closeSpreadLayer },
    }

    for i, event in pairs(self.event_) do
        SLFacade:addCustomEventListener(event.name, handler(self, event.handle), self.__cname)
    end
end

function PlazaLayer:cleanEvent()
    for i, event in pairs(self.event_) do
        SLFacade:removeCustomEventListener(event.name, self.__cname)
    end
end

function PlazaLayer:cleanHall()
    --删除
    self:removeAllChildren()

    for k, v in pairs(yl.vecReleasePlist) do
		local dict = cc.FileUtils:getInstance():getValueMapFromFile(v[1])
		local framesDict = dict["frames"]
		if nil ~= framesDict and type(framesDict) == "table" then
			for k,v in pairs(framesDict) do
				local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(k)
				if nil ~= frame then
					frame:release()
				end
			end
		end
    end

    for k, v in pairs(yl.vecReleasePlist) do
        cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(v[1])
	    cc.Director:getInstance():getTextureCache():removeTextureForKey(v[2])
    end

    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
end


function PlazaLayer:Handle_Custom_Ack(_event)
    local _userdata = unpack(_event._userdata);
    if not _userdata then
        return
    end
    local eventID = _userdata.name
    local msg = _userdata.packet

    if eventID == Hall_Events.UPDATA_HALL_MSG_TAG then -- 消息中心小红点
        self:onUpdateHallMsgTag()
    elseif eventID == Hall_Events.MSG_UPDATE_RELIEVE then --刷新救济金

        self:updateRelieveLabel(msg.score)

    elseif eventID == Hall_Events.SHOW_EXCHANGE_VIEW then -- 显示兑换中心
        if PlayerInfo.getInstance():getIsGuest() then
            self:showGuestNotice()
        else
            self:showExchangeView()
        end
    elseif eventID == Hall_Events.SHOW_BIND_VIEW then -- 显示绑定界面
        
        local name = msg.bindtype
        if name == "zhifubao" then
            self:showBindZhifubaoView()
        elseif name == "bank" then 
            self:showBindBankView()
        end
    elseif eventID == Hall_Events.MSG_SHOW_SHOP then --打开充值
        self:showRechargeView()

    elseif eventID == Hall_Events.ROOMLIST_BACK_TO_GAMELIST then -- 三级房间列表返回二级游戏列表
        local _nGameKindID = msg.nKindId
        local nClassifyType = msg.nClassify
        --返回二级列表时，不用重设
        if self.m_pGameListView:isVisible() == false then
            self:initGameListView(nClassifyType)
        end

    elseif eventID == Hall_Events.GAMELIST_CLICKED_GAME then -- 进入游戏房间
        local _nGameKindID = tonumber(msg.nKindId)
        self:onGameEnter(_nGameKindID)

    elseif eventID == Hall_Events.SHOW_CHOOSE_ROOM_DLG then -- 展示房间选择弹框
        local _nGameKindID = tonumber(msg.wKindID)
        local _nBaseScore = tonumber(msg.dwBaseScore)
        self:showChooseRoomDialog(_nGameKindID, _nBaseScore)

    elseif eventID == Hall_Events.MSG_SHOW_ROOM_CHOOSE_LAYER then --进入房间列表
        self:initRoomChooseView()

    elseif eventID == Hall_Events.MSG_GMAE_ENTER_RECOMMEND then --进入主推游戏
        self:onGameEnter(msg, true)
        
    elseif eventID == Hall_Events.MSG_GAME_QUIT_RECOMMEND then --退出主推游戏
        self:backToEntrance()

    elseif eventID == Hall_Events.MSG_GMAE_ENTER_LIST then --进入游戏列表
        self:initGameListView(msg)

    elseif eventID == Hall_Events.MSG_GAME_QUIT_LIST then --退出游戏列表
        
    elseif eventID == Hall_Events.MSG_SHOW_MODE_VIEW then --模式选择界面

        self:initModeChooseView(msg.nKindId)
        
    elseif eventID == Hall_Events.MSG_HALL_CLICKED_GAME then --点击进入游戏(全部游戏从此进入)
        
        -- 防连点
        local nCurTime = cc.exports.gettime()
        if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 0.2 then
            FloatMessage.getInstance():pushMessage("操作频繁，稍后再试")
            return
        end
        self.m_nLastTouchTime = nCurTime
       
        GlobalUserItem.tabRoomInfo = msg
        self._scene:onStartGame()

    elseif eventID == Hall_Events.MSG_UPDATE_REVERT then --客服回复提示
        local bIsHaveNew = UsrMsgManager.getInstance():isHaveNewFeedBack()
        local nNewRevert = UsrMsgManager.getInstance():getNewFeedBackNumber()
        self.m_pNodeSuggestNo:setVisible(bIsHaveNew or nNewRevert > 0)
        self.m_pLbSuggestNo:setString(nNewRevert)
    elseif eventID == Hall_Events.MSG_NICK_HEAD_MODIFIED then
        --更新头像
        print("666")
        if nil ~= self._head then
            self._head:updateHead(GlobalUserItem.tabAccountInfo)
        end
    elseif eventID == Hall_Events.SHOW_SPREAD_ACTIVITY then   --打开推广员界面
         self:showSpreadView()
    end
end

-- 二级界面返回一级页面->游戏列表返回游戏分类
function PlazaLayer:backToEntrance()
    print("========backToEntrance==========")
    -- 进入大厅交互动画
   self.m_pClassifyLayer:setVisible(true)
   self.m_pAdView:setVisible(true)
   self.image_topBar:setVisible(true)   --隐藏救济金
   self.panel_bottomBar:setVisible(true)    --上方按钮

    --隐藏二级页面
    if self.m_pGameListView then
        self.m_pGameListView:setVisible(false)
    end

    --4.隐藏房间列表
    if self.m_pRoomChooseView then
        self.m_pRoomChooseView:removeFromParent()
        self.m_pRoomChooseView = nil
    end

    --显示救济金
   -- self:updateRelieve()
end

function PlazaLayer:updateRelieve()
    local bShowRelieve = self.isShowRelieve
    self.m_pNodeRelieve:setVisible(bShowRelieve)
end

--1.显示游戏分类
function PlazaLayer:initGameEntranceView()

    --1.显示游戏分类
    if self.m_pNodeGameEntrance then
        self.m_pNodeGameEntrance:setVisible(true)
    end

    --2.隐藏游戏列表
    if self.m_pGameListView then
        self.m_pGameListView:setVisible(false)
    end

    --3.隐藏模式列表
    if self.m_pModeChooseView then
        self.m_pModeChooseView:onMoveExitView(FixLayer.HIDE_NO_STYLE)
        self.m_pModeChooseView = nil
    end

    --4.隐藏房间列表
    if self.m_pRoomChooseView then
        self.m_pRoomChooseView:removeFromParent()
        self.m_pRoomChooseView = nil
    end
end

--2.显示游戏列表
function PlazaLayer:initGameListView(_nGameType)
    
    print("========initGameListView==========")
    --0.显示界面
    self.m_pNodeRelieve:setVisible(false)   --隐藏救济金
    self.m_pBtnRefresh:setVisible(false)    --刷新按钮
    self.m_pNodeTopBar:setVisible(false)    --隐藏上方按钮
    self.m_pNodeBottomBar:setVisible(true)  --显示下方按钮
    self.m_pNodeMenu:setVisible(true)       --显示上下按钮
    self:showEnterHallAction()              --运行按钮动作

    --1.隐藏游戏分类
    if self.m_pNodeGameEntrance then
        self.m_pNodeGameEntrance:setVisible(false)
    end

    --2.显示游戏列表
    if self.m_pGameListView then
        self.m_pGameListView:init(_nGameType)
        self.m_pGameListView:showTopBar()
        self.m_pGameListView:setVisible(true)
    end

    --3.隐藏模式列表
    if self.m_pModeChooseView then
        self.m_pModeChooseView:onMoveExitView(FixLayer.HIDE_NO_STYLE)
        self.m_pModeChooseView = nil
    end

    --4.隐藏房间列表
    if self.m_pRoomChooseView then
        self.m_pRoomChooseView:removeFromParent()
        self.m_pRoomChooseView = nil
    end
end

-- 3.显示百人牛牛倍数场选择页面
function PlazaLayer:initModeChooseView(_nGameKindID)

    self.m_pNodeRelieve:setVisible(false)   --隐藏救济金

    --1.隐藏游戏分类
    if self.m_pNodeGameEntrance then
        self.m_pNodeGameEntrance:setVisible(false)
    end

    --2.隐藏游戏列表
    if self.m_pGameListView then
        self.m_pGameListView:setVisible(false)
    end

    --3.显示模式列表
    if self.m_pModeChooseView then
        self.m_pModeChooseView:onMoveExitView(FixLayer.HIDE_NO_STYLE)
        self.m_pModeChooseView = nil
    end
    --self:showBlur(true)
    self.m_pModeChooseView = ModeChooseLayer.create()
    self.m_pModeChooseView:init(_nGameKindID)
    self.m_pModeChooseView:addTo(self.m_rootUI, Z_ORDER_COMMON)

    --4.隐藏房间列表
    if self.m_pRoomChooseView then
        self.m_pRoomChooseView:removeFromParent()
        self.m_pRoomChooseView = nil
    end
end

-- 4.显示房间列表界面
function PlazaLayer:initRoomChooseView(bRecommend)
    
    --隐藏按钮
  
   self.m_pClassifyLayer:setVisible(false)
   self.m_pAdView:setVisible(false)
   self.image_topBar:setVisible(false)   --隐藏救济金
   self.panel_bottomBar:setVisible(false)    --上方按钮

    --1.隐藏游戏分类
    if self.m_pNodeGameEntrance then
        self.m_pNodeGameEntrance:setVisible(false)
    end

    --2.隐藏游戏列表
    if self.m_pGameListView then
        self.m_pGameListView:setVisible(false)
    end

    --3.隐藏模式列表
    if self.m_pModeChooseView then
        self.m_pModeChooseView:onMoveExitView(FixLayer.HIDE_NO_STYLE)
        self.m_pModeChooseView = nil
    end

    if self.m_pRoomChooseView then
        self.m_pRoomChooseView:removeFromParent()
        self.m_pRoomChooseView  = nil
    end

    --4.显示房间列表
    if not self.m_pRoomChooseView then
        local entergame = self._scene:getEnterGameInfo()
        if nil ~= entergame then
            local modulestr = string.gsub(entergame._KindName, "%.", "/")
            local targetPlatform = cc.Application:getInstance():getTargetPlatform()
            local customRoomFile = ""
            if cc.PLATFORM_OS_WINDOWS == targetPlatform then
                customRoomFile = "game/" .. modulestr .. "src/views/GameRoomLayer.lua"
            else
                customRoomFile = "game/" .. modulestr .. "src/views/GameRoomLayer.luac"
            end
            if cc.FileUtils:getInstance():isFileExist(customRoomFile) then
                self.m_pRoomChooseView = appdf.req(customRoomFile):create(self._scene)
            end
        end
        if nil == self.m_pRoomChooseView then
             self.m_pRoomChooseView = RoomChooseLayer:create(self._scene)
        end 

        self.m_pRoomChooseView:setVisible(true)
        self.m_pRoomChooseView:init(1)
        self.m_pRoomChooseView:addTo(self.m_rootUI, Z_ORDER_COMMON)
    end
end

-- 进入游戏
function PlazaLayer:onGameEnter(_nGameKindID, bRecommend)
    self:getRoomList()
end

function PlazaLayer:showUserView() --用户
    local pUserCenterLayer = UserCenterLayer:create(self)
    pUserCenterLayer:setName("UserCenterLayer")
    pUserCenterLayer:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end

function PlazaLayer:showSettingView() --设置
    local pSettingView = SettingView.create(self._scene)
    pSettingView:setName("SettingView")
    pSettingView:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end

--注册界面
function PlazaLayer:showRigstView()
    local pRegisterView = RegisterView.create(2)
    pRegisterView:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end

function PlazaLayer:showExchangeView() --兑换
   local pOnCashView = ExchangeCenterLayer.create(self._scene)
   pOnCashView:setName("ExchangeCenterLayer")
   pOnCashView:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end

function PlazaLayer:showSpreadView() --推广员

   local pSpreadView = SpreadLayer.create(self._scene)
   pSpreadView:setName("SpreadLayer")
   pSpreadView:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)

end

--公告弹窗
function PlazaLayer:showNoticePop()
--    FloatMessage.getInstance():pushMessage("公告弹窗")
--    if CBroadcastManager.getInstance():getPopBroadcastCount() > 0 then 
--        local popMsg = CBroadcastManager.getInstance():getPopBroadcastInfoAtIndex(1)
--        local pAnnouncementMsg = AnnouncementMsg.new()
--        pAnnouncementMsg:setMessage(popMsg,0)
--        pAnnouncementMsg:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
--        CBroadcastManager.getInstance():delPopBroadcastInfoByID(popMsg.dwAnnounceID)
--    end
end

function PlazaLayer:OnRegisterOK()
    self._scene:exitPlaza()
end

function PlazaLayer:openExchengeLayer()
    self:closeSpreadLayer()
    self:showExchangeView()
end

function PlazaLayer:closeSpreadLayer()
    local spreadlayer = self.m_rootUI:getChildByName("SpreadLayer")
    if spreadlayer then
        spreadlayer:onMoveExitView()
    end
end

function PlazaLayer:showServiceView() --客服界面
   local ServiceView = ServiceCenterView.create(self._scene)
   ServiceView:setName("ServiceCenterView")
   ServiceView:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end

function PlazaLayer:showGuestNotice() --注册提示
    --关闭兑换时，不显示游客提示
    print("游客显示游客提示")
    --fix 如果提现没有关闭,但是因为延迟显示提现打开,不能弹出提示升级
    --fix bug,游客提示升级再点击兑换,如果有就return
    if self.m_rootUI:getChildByName("GuestNotice") then
        return
    end

    local pRegisterActDlg =  RegisterActDlg.create()
    pRegisterActDlg:setName("GuestNotice")
    pRegisterActDlg:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end
--消息
function PlazaLayer:showMessageLayer()
    local pMessageCenterLayer = MessageCenterLayer:create()
    pMessageCenterLayer:setName("MessageCenterLayer")
    pMessageCenterLayer:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end
function PlazaLayer:onNoticeClicked()
    ExternalFun.playClickEffect() 

    --打开公告
    self:showActivityNoticeView()
end

function PlazaLayer:onMailClicked()
    ExternalFun.playClickEffect() 

    --打开公告
    self:showAnnouncementCenter()
end
function PlazaLayer:showActivityNoticeView()
    local pAnnouncementCenter = ActivityNoticeView.new()
    pAnnouncementCenter:setName("ActivityNoticeView")
    pAnnouncementCenter:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end
function PlazaLayer:showAnnouncementCenter()
    local pAnnouncementCenter = AnnouncementCenter.new()
    pAnnouncementCenter:setName("AnnouncementCenter")
    pAnnouncementCenter:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end
--你提我改
function PlazaLayer:showSuggestView()
    local pSuggestView = SuggestLayer:create()
    pSuggestView:setName("SuggestLayer")
    pSuggestView:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end

--排行榜
function PlazaLayer:showRankView()
    local pRankView = RankLayer:create()
    pRankView:setName("RankLayer")
    pRankView:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end

--按键事件----------------------------------------------
function PlazaLayer:onHeadBtnClicked() --用户
    ExternalFun.playClickEffect()

    self:showUserView()
end

function PlazaLayer:onSettingClick() --设置
    ExternalFun.playClickEffect()

    self:showSettingView()
end

function PlazaLayer:onRelieveClicked() ---救济金
    ExternalFun.playClickEffect()

    -- 防连点
    local nCurTime = os.time()
    if self.m_nLastTouchTime and nCurTime - self.m_nLastTouchTime <= 0.1 then
        return
    end
    self.m_nLastTouchTime = nCurTime

    local nScore = GlobalUserItem.tabAccountInfo.bag_money     --  背包里的钱
    local nInsure = GlobalUserItem.tabAccountInfo.bank_money   --  保险箱里的钱
    local nLimit = 200                                         --  总和不到200才发救济金
    if (nInsure + nScore) >= nLimit then
        local format = yl.getLocalString("RELIEVE_TIPS_1")
        local relieve = GlobalUserItem.tabAccountInfo.relieve_time or 0   --  还可以领取救济金的次数（消息未有）
        local strRelieve = string.format(format, relieve)
        FloatMessage.getInstance():pushMessage(strRelieve)
    else
        local userID = GlobalUserItem.tabAccountInfo.userid
        --暂时注释掉功能
        --self:sendGetRelieve(userID)
    end
end

function PlazaLayer:sendGetRelieve(userID) -- 发送救济金请求  
    ExternalFun.playClickEffect()

    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "Relievetimes"
    msgta["body"] = {}
    msgta["body"]["id"] = userID
    self._plazaFrame:sendGameData(msgta)    

end

function PlazaLayer:onShopClicked() -- 充值按钮
    ExternalFun.playClickEffect()

    self:showRechargeView()
end
function PlazaLayer:onCashClicked() -- 兑换按纽
    ExternalFun.playClickEffect()
    self:showExchangeView()
end

--支付宝绑定
function PlazaLayer:showBindZhifubaoView()
   local pOnCashView = ExchangeCenterLayer.create(self._scene)
   pOnCashView:setName("ExchangeCenterLayer")
   pOnCashView:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end

--银行卡绑定
function PlazaLayer:showBindBankView()
   local pOnCashView = ExchangeCenterLayer.create(self._scene)
   pOnCashView:setName("ExchangeCenterLayer")
   pOnCashView:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end
function PlazaLayer:onMsgClicked() -- 消息按纽
    ExternalFun.playClickEffect()

    --消息界面
    self:showMessageLayer()
end

function PlazaLayer:onBankClicked() -- 银行按纽
    ExternalFun.playClickEffect()

    self:popMark()
end

--充值
function PlazaLayer:showRechargeView()
--    FloatMessage.getInstance():pushMessage("功能开发中，敬请期待")
    self:popShopLayer()
end

-- 二级界面返回一级界面
function PlazaLayer:onHallReturnClicked()

    ExternalFun.playClickEffect()

    self:backToEntrance()
end

-- 服务按纽
function PlazaLayer:onServiceClicked()
    ExternalFun.playClickEffect()
    self:OpenServiceUrl()
    --self:showServiceView()
end

--推广员
function PlazaLayer:onSpreadClicked()
    ExternalFun.playClickEffect()

    self:showSpreadView()
end

--刷新按钮
function PlazaLayer:onRefreshClicked()
    ExternalFun.playClickEffect()

    self.m_pBtnRefresh:setVisible(false)
    
    --self.m_bRequestLoginDataDone = false
    GameListManager.getInstance():setIsHadSendHallReqList(false)
    self:updateGameListView()

    --启动定时器
    self:doWaitRefresh()
end

--游戏分类
function PlazaLayer:onGameBtnClicked(pSender)
    ExternalFun.playClickEffect()

    local nTag = pSender:getTag()
    self:initGameListView(nTag)
end

--复制网址
function PlazaLayer:onCopyClicked()
    ExternalFun.playClickEffect()
    local strWebSit = self.m_pLbWebSit:getText()
    MultiPlatform:getInstance():copyToClipboard(strWebSit)

    if device.platform == "windows" then
        FloatMessage.getInstance():pushMessage("在手机端操作")
    else
        FloatMessage.getInstance():pushMessage("STRING_204")
    end
end

--你提我改
function PlazaLayer:onSuggestClicked()
    ExternalFun.playClickEffect()
    
    self:showSuggestView()
end

-- 游客送注册送金
function PlazaLayer:onGuestClicked()
    ExternalFun.playClickEffect()

    self:showGuestNotice()
end

--排行榜
function PlazaLayer:onRankClicked()
    ExternalFun.playClickEffect()
    
    self:showRankView()
end

function PlazaLayer:onOpenLayer(event)
    
    local layer = unpack(event._userdata)

    if layer == "vip" then
        self:showVipLayer()
    end
end
function PlazaLayer:onVipClicked()
   ExternalFun.playClickEffect()
    --打开vip
    self:showVipLayer()
end
--会员
function PlazaLayer:showVipLayer()
    
    local pVipLayer = VipLayer.new()
    pVipLayer:setName("VipLayer")
    pVipLayer:addTo(self.m_rootUI, Z_ORDER_OVERRIDE)
end
--按键事件----------------------------------------------
function PlazaLayer:OpenBank(event)

    self:popMark()

end

--打开客服链接
function PlazaLayer:OpenServiceUrl()
    local strUrl = "https://chat7.livechatvalue.com/chat/chatClient/chatbox.jsp?companyID=919952&configID=62602&jid=2988069417&s=1"
    cc.Application:getInstance():openURL(strUrl)
end

function PlazaLayer:ExitPlaza(event)
    local layer = unpack(event._userdata)

    if layer == "exit" then
        self._scene:exitPlaza()
    end
    
end

function PlazaLayer:getRoomList()
    local entergame = self._scene:getEnterGameInfo()
    if entergame then
        local msgta = {}
        msgta["type"] = "AccountService"
        msgta["tag"] = "get_rooms"
        msgta["body"] = {}
        msgta["body"]["minv"] = 0
        msgta["body"]["agentid"] = 0
        msgta["body"]["maxv"] = 39999
        msgta["body"]["gt"] = entergame._KindID
        msgta["body"]["rt"] = entergame.GameTypeIDs

        self._logonFrame:sendGameData(msgta)
    end
end

function PlazaLayer:onLogonCallBack(result,message)
    if message.tag == "get_rooms" then 
        if message.result == "ok" then
            self:showRoomList(message.body)
        else
            if type(message.result) == "string" then
               showToast(self,message.result,2,cc.c4b(250,0,0,255));
            end
        end  
    end
end

function PlazaLayer:showRoomList(data)
   local roomTable = {}
   for k,v in pairs(data) do
       if type(v.is_active) == "boolean" and v.is_active == true then
           table.insert(roomTable, v)
       end
   end
   if #roomTable == 1 then
       self:loginGame(roomTable)
   else
      self:initRoomChooseView()
   end 
end

function PlazaLayer:loginGame(data)
    --房间数据
    local tmp = data[1]
    -- 请求进入游戏
    local _event = {
        name = Hall_Events.MSG_HALL_CLICKED_GAME,
        packet = tmp,
    }
    SLFacade:dispatchCustomEvent(Hall_Events.GAMELIST_CLICKED_GAME, _event)
end

return PlazaLayer