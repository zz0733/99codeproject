--region RechargeLayer.lua
--Date 2017.04.24.
--Auther JackyXu.
--Desc: 充值中心主页面

local G_TagRechargeMsgEvent = "TagRechargeLayerMsgEvent" -- 事件监听 Tag

local FloatMessage      = cc.exports.FloatMessage
local TransitionLayer   = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local ExternalFun       = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local RechargeCommonView= appdf.req(appdf.PLAZA_VIEW_SRC.."bean.RechargeCommonView")
local AgentContactDlg   = appdf.req(appdf.PLAZA_VIEW_SRC.."bean.AgentContactDlg")
--local RechargeAgentView = appdf.req(appdf.PLAZA_VIEW_SRC.."bean.RechargeAgentView")
--local RechargeWebView = appdf.req(appdf.PLAZA_VIEW_SRC.."bean.RechargeWebView")
local RechargePointView = appdf.req(appdf.PLAZA_VIEW_SRC.."bean.RechargePointView")
local GameListManager   = appdf.req(appdf.PLAZA_VIEW_SRC.."bean.GameListManager")
local CommonGoldView    = appdf.req(appdf.PLAZA_VIEW_SRC.."CommonGoldView")      --通用金币框
local LogonFrame        = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")
local MultiPlatform     = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform") 
local G_RechargeAgentEventTag  = "RechargeAgentEventTag" -- 事件监听TAG

local G_StrSelectItemPath = {
    [1] = {"hall/plist/shop/gui-shop-btn-agent-normal.png",     "hall/plist/shop/gui-shop-btn-agent-select.png",  },-- 代理 
    [2] = {"hall/plist/shop/gui-shop-btn-zfb-normal.png",       "hall/plist/shop/gui-shop-btn-zfb-select.png",},-- 支付宝 
    [3] = {"hall/plist/shop/gui-shop-btn-wx-normal.png",        "hall/plist/shop/gui-shop-btn-wx-select.png", },-- 微信 
    [4] = {"hall/plist/shop/gui-shop-btn-koukou-normal.png",    "hall/plist/shop/gui-shop-btn-koukou-select.png",     },-- QQ 
    [5] = {"hall/plist/shop/gui-shop-btn-union-normal.png",     "hall/plist/shop/gui-shop-btn-union-select.png",  },-- 银行卡 
    [6] = {"hall/plist/shop/gui-shop-btn-jindon-normal.png",    "hall/plist/shop/gui-shop-btn-jindon-select.png", },-- 京东
    [7] = {"hall/plist/shop/gui-shop-btn-dianka-normal.png",    "hall/plist/shop/gui-shop-btn-dianka-select.png", },-- 京东
}
local payparam = {
    ["Type_Alipay"] = "http://pay456game.tianshen898.com/client_unity/pay/?username=%s&money_amount=%d&bank_type_code=ALIPAY&package_id=comazgodqp456",
    ["Type_WeChat"] = "http://pay456game.tianshen898.com/account/payh5/?username=%s&money_amount=%d&bank_type_code=WECHATPAY",
    ["Type_Bank"] = "http://pay456game.tianshen898.com/account/payh5/?username=%s&money_amount=%d&bank_type_code=BANKWAP"
}
local RechargeLayer = class("RechargeLayer",  FixLayer)--TransitionLayer)

local G_RechargeLayer = nil
function RechargeLayer.create()
    G_RechargeLayer = RechargeLayer.new():init()
    return G_RechargeLayer
end

function RechargeLayer:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    local this = self
    ExternalFun.registerNodeEvent(this)
    RechargeLayer.super.ctor( self, scene, param, level )

    self.m_pNodeSub = nil
    self.m_pButtonTable = {}
    self.m_buttonPos = {}
    self.m_pRechargeCommonView = nil
    self.m_pRechargeAgentView = nil
    self.m_pRechargePointView = nil
    self.m_tmLastClicked = 0
    self.m_bBankSubViewMoving = false
    self.m_pViewIndex = 0
    self.m_pRechargeWebView = nil
    self.m_RechargeHandle = nil

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    cc.SpriteFrameCache:getInstance():addSpriteFrames("hall/plist/gui-shop.plist","hall/plist/gui-shop.png")
    
    local  onUseRankCallBack = function(result,message)
       self:onAgentViewCallBack(result,message)
    end
    --大厅网络处理
    self._plazaFrame = LogonFrame:getInstance()
    self._plazaFrame:setCallBackDelegate(self, onUseRankCallBack)

        -- 加载动画
--    self:scaleTransitionIn(self.m_rootUI)
end

function RechargeLayer:init()
--    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)

    --init csb
    self.m_pathUI = cc.CSLoader:createNode("dt/ZCShop.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750)/2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("center")
    self.m_pNodeAgentCell = self.m_pathUI:getChildByName("panel_itemOne")       --代理按钮
    self.m_pNodeAgentCell:setVisible(false)
    self.btn_moneyMolde = self.m_pathUI:getChildByName("button_rechangeItem")   --充值按钮模板
    self.btn_moneyMolde:setVisible(false)
    local diffX = display.size.width/2--145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pImgBg            = self.m_pNodeRoot:getChildByName("image_Bg")

    self.m_pBgLayer = cc.LayerColor:create(cc.c4b(0,0,0,70), 1800, 750)
    self.m_pBgLayer:setPosition(ccp(-100,-10))
    self.m_pImgBg:addChild(self.m_pBgLayer,-20000)

--    self.m_pNodeCommonGold   = self.m_pNodeRoot:getChildByName("node_commonGold")
    self.m_pButtonList       = self.m_pImgBg:getChildByName("Image_1"):getChildByName("listView_tabBtnList")
    self.m_pButtonItem       = self.m_pImgBg:getChildByName("Image_1"):getChildByName("panel_tabItem")
    self.m_pButtonItem:setVisible(false)
    self.m_pBtnClose         = self.m_pImgBg:getChildByName("button_closeBtn")
    self.m_pNodeSub          = self.m_pImgBg:getChildByName("panel_node")
         -- 加载动画
    --self:scaleTransitionIn(self.m_pathUI)
--    self:scaleShakeTransitionIn(self.m_pathUI)  --入场动画

    self.m_pButtonList:setScrollBarEnabled(false)
    self.m_pButtonList:setVisible(false)

    return self
end

function RechargeLayer:onEnter()
    self.super:onEnter()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)
    self:showWithStyle()

    self:initBtnEvent()
    SLFacade:addCustomEventListener(Hall_Events.MSG_GET_AGENT, handler(self, self.onMsgAgentInfo), G_RechargeAgentEventTag)
    SLFacade:addCustomEventListener(Hall_Events.MSG_RECHARGE_WEB,         		handler(self, self.showRechargeWebView),   self.__cname)
    SLFacade:addCustomEventListener(Hall_Events.MSG_ENTER_FOREGROUND_RECHARGE,        handler(self, self.onEnterForeground),     self.__cname)
    SLFacade:addCustomEventListener(Hall_Events.MSG_BANK_INFO,            		handler(self, self.onMsgBankInfo),         self.__cname)
    SLFacade:addCustomEventListener(Hall_Events.MSG_RECHARGE_DETAIL_BACK, 		handler(self, self.onRechargeSwitch),      self.__cname)

    self:getBankInfo()

    --如果在大厅，打开充值界面，请求一下开关信息
    --得到开关信息了再根据开关信息看是否请求充值详情
    local needNewRequest = self:needNewRequest()
    if not GameListManager.getInstance():getIsLoginGameSucFlag() then
        if needNewRequest then
            self:onRechargeSwitch()
        else
            self:onRechargeSwitch()
        end
    end

    self:initAlipayView()   --初始化支付宝充值

end

function RechargeLayer:onExit()
    self.super:onExit()

    SLFacade:removeCustomEventListener(Hall_Events.MSG_RECHARGE_WEB,          	self.__cname)
    SLFacade:removeCustomEventListener(Hall_Events.MSG_ENTER_FOREGROUND_RECHARGE,     self.__cname)
    SLFacade:removeCustomEventListener(Hall_Events.MSG_BANK_INFO,             	self.__cname)
    SLFacade:removeCustomEventListener(Hall_Events.MSG_RECHARGE_DETAIL_BACK,  	self.__cname)

    if self.m_RechargeHandle ~= nil then
        scheduler.unscheduleGlobal(self.m_RechargeHandle)
        self.m_RechargeHandle = nil
    end

    G_RechargeLayer = nil
    
end

function RechargeLayer:initBtnEvent()
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseBtnClicked))
end

-- 支付开关控制
function RechargeLayer:onRechargeSwitch()
--    Veil:getInstance():HideVeil(VEIL_REQUEST_DATA)
    --Agent开关屏蔽
    self.m_bIsClosedAgent = GameListManager.getInstance():getGameSwitch(Hall_Events.GAMESWITCH.CLOSE_RECHARGE_AGENT)           -- 如果这个值为1，则需要关闭代理充值(人工充值)
    --AliPay开关屏蔽
    self.m_bIsClosedAliPay = GameListManager.getInstance():getGameSwitch(Hall_Events.GAMESWITCH.CLOSE_ERCHARGE_ALIPAY_WEB)      -- 在RECHARGE为0的时候，如果这个值为1，则需要关闭支付宝网页充值
    --WeChat开关屏蔽
--    self.m_bIsClosedWeChat = GameListManager.getInstance():getGameSwitch(Hall_Events.GAMESWITCH.CLOSE_RECHARGE_WETCHAT_WEB)    -- 如果这个值为1，则需要关闭微信网页充值
--    --bank银行卡开关
--    self.m_bIsClosedBank = GameListManager.getInstance():getGameSwitch(Hall_Events.GAMESWITCH.CLOSE_RECHARGE_BANK_WEB)          -- 银行卡支付,1关闭,0开放
--    --qq开关
--    self.m_bIsClosedQQ = GameListManager.getInstance():getGameSwitch(Hall_Events.GAMESWITCH.CLOSE_RECHARGE_QQ_WEB)             -- qq网页支付,1关闭,0开放             
--    --jd京东开关
--    self.m_bIsClosedJD = GameListManager.getInstance():getGameSwitch(Hall_Events.GAMESWITCH.CLOSE_RECHARGE_JD_WEB)             -- 京东支付,1关闭,0开放
    --点卡开关
--    self.m_bIsClosedPoint = GameListManager.getInstance():getGameSwitch(Hall_Events.GAMESWITCH.CLOSE_RECHARGE_POINTCARD)       -- 在RECHARGE为0的时候，如果这个值为1，则需要关闭点卡充值

     --计算显示概率
    local isCloseStrategy = GameListManager.getInstance():getGameSwitch(Hall_Events.GAMESWITCH.CLOSE_RECHARGE_STRATEGY)        -- 充值策略,1关闭,0开放
    if not isCloseStrategy then
--        self:onCalculateShow()
    end
    self.m_bIsClosedQQ = true


    -- 根据开关显示按钮
    self.bClose ={
        [1] = self.m_bIsClosedAgent,
        [2] = self.m_bIsClosedAliPay,
        [3] = self.m_bIsClosedWeChat,
        [4] = self.m_bIsClosedQQ,
        [5] = self.m_bIsClosedBank,
        [6] = self.m_bIsClosedJD,
        [7] = self.m_bIsClosedPoint,
    }

    self.m_pButtonList:setVisible(true)
    local addCount = 0 
    for k, v in ipairs(self.bClose) do
        if not v then 
            addCount = addCount + 1
            local curItem = nil
            if addCount == 0 then
                curItem =  self.m_pButtonItem 
                curItem:setTag(k)
                self.m_pViewIndex = k
            else
                curItem = self.m_pButtonItem:clone()
                curItem:setVisible(true)
                self.m_pButtonList:pushBackCustomItem(curItem)
                curItem:setTag(k)
            end
            local iconNormal = curItem:getChildByName("unlight")
--            iconNormal:loadTexture(G_StrSelectItemPath[k][1], ccui.TextureResType.plistType)
            local iconSelect = curItem:getChildByName("light")
--            iconSelect:loadTexture(G_StrSelectItemPath[k][2], ccui.TextureResType.plistType)
--            local button = curItem:getChildByName("Button_info")
            local icon = cc.Sprite:createWithSpriteFrameName(G_StrSelectItemPath[k][2])
            icon:setAnchorPoint(cc.p(0.5,0.5))
            icon:setPosition(cc.p(curItem:getSize().width/2,curItem:getSize().height/2))
            icon:addTo(curItem)
            curItem:addClickEventListener(function(sender)
                self:onClickedItem(k)
            end)
        end
    end 

    --如果左边按钮>6个,可以滑动
    if addCount > 6 then
        self.m_pButtonList:setTouchEnabled(true)
    else
        self.m_pButtonList:setTouchEnabled(false)
    end

    if self.m_pViewIndex == 0 then
        self.m_pViewIndex = 1
    end
    self:refreshButtonStatus(self.m_pViewIndex)
end

function RechargeLayer:onCalculateShow()
    
    if self.m_bIsClosedAgent then --如果代理充值关闭 就不再计算只显示代理的概率
        return
    end
    local rechargeScore = PlayerInfo.getInstance():getRechargeScore()
    local buyScore  = PlayerInfo.getInstance():getBuyScore()
    if rechargeScore == 0 and buyScore == 0 then  --未充值过的玩家
        return
    end
    local rechargeCount = PlayerInfo.getInstance():getRechargeCount()
    local buyCount  = PlayerInfo.getInstance():getBuyCount()
    --local strFloatMsg = "官充次数："..rechargeCount.." 官充金额："..rechargeScore.." 代理充值次数："..buyCount.." 代理充值金额："..buyScore
    --FloatMessage.getInstance():pushMessage(strFloatMsg)
    local gameId = PlayerInfo.getInstance():getGameID()
    math.randomseed(os.time()) --设置随机数种子
    local rand = math.random(1, 100)
    if buyCount <= 0 then 
        --未代理充值成功过
        if rechargeCount > 10 or rechargeScore > 500000 then 
            local strKey = string.format("%dOnlyAgentCountA",gameId)
            local localCount = cc.UserDefault:getInstance():getIntegerForKey(strKey, 0)
            local noun = 60
            if localCount >= 3 then
                noun = noun-(localCount-2)*10 > 0 and noun-(localCount-2)*10 or 0
            end
            --FloatMessage.getInstance():pushMessage("已显示次数："..localCount.."   只显示代理的概率："..noun.."%")
            if rand <= noun then 
                self.m_bIsClosedAgent  = true
                self.m_bIsClosedAliPay = true
                self.m_bIsClosedWeChat = true
                self.m_bIsClosedQQ     = false
                self.m_bIsClosedBank   = true
                self.m_bIsClosedJD     = true
                self.m_bIsClosedPoint  = true
                cc.UserDefault:getInstance():setIntegerForKey(strKey, localCount+1)
            end
        end
    else 
        --代理充值成功过
        local strKey = string.format("%dOnlyAgentCountB",gameId)
        local localCount = cc.UserDefault:getInstance():getIntegerForKey(strKey, 0)
        local strKey2 = string.format("%dAgentBuyCount",gameId)
        local localBuyCount = cc.UserDefault:getInstance():getIntegerForKey(strKey2, 1)
        local strKey3 = string.format("%dAgentCurrentNoun",gameId)
        local noun = cc.UserDefault:getInstance():getIntegerForKey(strKey3, 80)
        if buyCount > localBuyCount then 
            --代理充值次数发生变化
            noun = noun+(buyCount-localBuyCount)*10 >= 100 and 100 or noun+(buyCount-localBuyCount)*10
            cc.UserDefault:getInstance():setIntegerForKey(strKey, 0)
            cc.UserDefault:getInstance():setIntegerForKey(strKey2, buyCount)
            cc.UserDefault:getInstance():setIntegerForKey(strKey3, noun)
        else
            if localCount >= 3 then 
                noun = noun-5 > 0 and noun-5 or 0
            end
        end
        --FloatMessage.getInstance():pushMessage("已显示次数："..localCount.."   只显示代理的概率："..noun.."%")
        if rand <= noun then 
            self.m_bIsClosedAgent  = true
            self.m_bIsClosedAliPay = true
            self.m_bIsClosedWeChat = true
            self.m_bIsClosedQQ     = false
            self.m_bIsClosedBank   = true
            self.m_bIsClosedJD     = true
            self.m_bIsClosedPoint  = true
            if localBuyCount == buyCount then 
                cc.UserDefault:getInstance():setIntegerForKey(strKey, localCount+1)
                cc.UserDefault:getInstance():setIntegerForKey(strKey3, noun)   
            end
        end
    end
end

----------------
-- 按纽响应
-- 关闭
function RechargeLayer:onCloseBtnClicked()
    ExternalFun.playSoundEffect("public/sound/sound-close.mp3")
    
--    self.m_pathUI:removeFromParent()
    self:onMoveExitView()
end

-- 按纽响应
function RechargeLayer:onClickedItem(nIndex)
    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")
    self:refreshButtonStatus(nIndex)
end

function RechargeLayer:refreshButtonStatus(nIndex)
    for k, v in ipairs(self.bClose) do
        if not v then 
            local curItem = self.m_pButtonList:getChildByTag(k)
            
            local imageNormal = curItem:getChildByName("unlight")
            local imageSelect = curItem:getChildByName("light")
   
            if k == nIndex then
                curItem:setTouchEnabled(false)
                imageNormal:setVisible(false)
                imageSelect:setVisible(true)
            else
                curItem:setTouchEnabled(true)
                imageNormal:setVisible(true)
                imageSelect:setVisible(false)
            end
        end
    end 

    self:cleanSubView()
    self:showSubView(nIndex)
end

function RechargeLayer:showSubView(index)
    if index == 1 then -- 代理充值
        if self.m_pRechargeAgentView == nil then
            self:initAgentView()
        end
        self.m_pRechargeAgentView:setVisible(true)
    elseif index == 2 then  --支付宝
        self.m_pRechargeAlipayView:setVisible(true)
        self.rechargeType = 2
    elseif index == 3 then  --微信充值
        self.rechargeType = 3
    elseif index == 2 or index == 3 or index == 4 or index == 5 or index == 6 then  -- 支付宝/微信充值/QQ/银行卡/京东

        if not self.m_pRechargeCommonView then
            self.m_pRechargeCommonView = RechargeCommonView.create()
            self.m_pNodeSub:addChild(self.m_pRechargeCommonView)
        end
        self.m_pRechargeCommonView:setVisible(true)

        local rechargeType
        if index == 2 then
            rechargeType = Hall_Events.Recharge_Type.Type_Alipay
        elseif index == 3 then
            rechargeType = Hall_Events.Recharge_Type.Type_WeChat
        elseif index == 4 then
            rechargeType = Hall_Events.Recharge_Type.Type_QQ
        elseif index == 5 then
            rechargeType = Hall_Events.Recharge_Type.Type_Bank
        elseif index == 6 then
            rechargeType = Hall_Events.Recharge_Type.Type_JingDong
        end
        self.m_pRechargeCommonView:setRechargeType(rechargeType)

    elseif index == 7 then  --点卡充值
        if not self.m_pRechargePointView then
            self.m_pRechargePointView = RechargePointView.create()
            self.m_pNodeSub:addChild(self.m_pRechargePointView)
        end
        self.m_pRechargePointView:setVisible(true)
    end
end
-------------------------------代理充值----------------------------------
--代理充值
function RechargeLayer:initAgentView()
    self.m_pRechargeAgentView = self.m_pImgBg:getChildByName("panel_vipPayPanel"):setVisible(true)
    self.m_pBtnFresh = self.m_pRechargeAgentView:getChildByName("button_vipRefBtn")
    self.m_pBtnFresh:addClickEventListener(handler(self, self.onFreshBtnClick))
    self.m_pNodeTable   = self.m_pRechargeAgentView:getChildByName("listView_contentList")
    self:sendReguestAgentList()
    FloatPopWait.getInstance():show("请稍后")
    self:initTableView()
end
function RechargeLayer:initTableView()
    if not self.m_pTableView then
        self.m_nTableHeight = self.m_pNodeTable:getContentSize().height
        self.m_pTableView = cc.TableView:create(self.m_pNodeTable:getContentSize());
--        self.m_pTableView:setIgnoreAnchorPointForPosition(false);
        self.m_pTableView:setAnchorPoint(cc.p(0,0));
        self.m_pTableView:setPosition(cc.p(0, 0));
        self.m_pTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_BOTTOMUP);
        self.m_pTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL);
        self.m_pTableView:setDelegate()
        self.m_pTableView:registerScriptHandler(handler(self,self.scrollViewDidScroll), CCTableView.kTableViewScroll)
        self.m_pTableView:registerScriptHandler(handler(self,self.cellSizeForTable), CCTableView.kTableCellSizeForIndex)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellAtIndex), CCTableView.kTableCellSizeAtIndex)
        self.m_pTableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView), CCTableView.kNumberOfCellsInTableView)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellTouched), CCTableView.kTableCellTouched)
        self.m_pRechargeAgentView:addChild(self.m_pTableView);
    end
end
function RechargeLayer:cellSizeForTable(table, idx)
    return 660, 133;
end
function RechargeLayer:tableCellAtIndex(table, idx)
    local cell = table:cellAtIndex(idx)
    if not cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end
    self:initTableViewCell(cell, idx);
    return cell
end
function RechargeLayer:numberOfCellsInTableView(table)
    local count = #GlobalUserItem.tabAccountInfo.agentList
    return math.ceil(count / 3);
end
function RechargeLayer:tableCellTouched(table, cell)
end
function RechargeLayer:initTableViewCell(cell, nIdx)

    local count = #GlobalUserItem.tabAccountInfo.agentList
    local startX = 18
    for i=1,3 do
        local tag = nIdx * 3 + i
        if tag > count then
            return
        end
        local info = GlobalUserItem.tabAccountInfo.agentList[tag]

        local agentNode = self.m_pNodeAgentCell:clone()
        agentNode:setVisible(true)
        agentNode:setPosition(cc.p(startX+i*210-105, 68))
        cell:addChild(agentNode)
        local pBgBtn = agentNode:getChildByName("button_payCellBtn")
        pBgBtn:setScale9Enabled(true)
        local pBtnSize = pBgBtn:getContentSize()
        pBgBtn:setSwallowTouches(false)
        pBgBtn:setTag(tag)

        -- 添加响应
         pBgBtn:addClickEventListener(handler(self,self.onCopyClicked))
        -- name
        local name = info[2]
        local lb_name = agentNode:getChildByName("text_name")--cc.Label:createWithSystemFont(name, "Helvetica", 24);
        lb_name:setString(name)

    end
end
function RechargeLayer:scrollViewDidScroll(pView)
    local slider = tolua.cast(self.m_pNodeTable:getChildByTag(100), "cc.ControlSlider")
    if not slider then
        return;
    end    
    local max = self.m_nTableHeight - 390;
    slider:setValue((pView:getContentOffset().y + max));
end


function RechargeLayer:onFreshBtnClick()
    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")

    self.m_pBtnFresh:setVisible(false)
    --手动刷新延时1秒发送请求，防连点
    FloatPopWait.getInstance():show("请稍后")
    ActionDelay(self, function()
        --请求人工充值信息
        self:sendReguestAgentList()
    end, 1.5)
end
function RechargeLayer:cleanSubView()
    if self.m_pRechargeCommonView then
        self.m_pRechargeCommonView:removeFromParent()
        self.m_pRechargeCommonView = nil
    end
    if self.m_pRechargeAgentView then
        self.m_pRechargeAgentView:setVisible(false)
    end
    if self.m_pRechargeAlipayView then
        self.m_pRechargeAlipayView:setVisible(false)
    end  
    if self.m_pRechargePointView then
        self.m_pRechargePointView:removeFromParent()
        self.m_pRechargePointView = nil
    end
end

function RechargeLayer:onCopyClicked(pSender)
--    ExternalFun.playClickEffect()
    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")
    local nIndex = pSender:getTag()
    print("RechargeAgentView:onCopyClicked:", nIndex)

    local agentInfo = GlobalUserItem.tabAccountInfo.agentList[nIndex]


    local agentNum = agentInfo[3]
    local agentName = agentInfo[2]
    MultiPlatform:getInstance():copyToClipboard(agentNum)
    local agentType = 1
    local RechargeViewNode = self.m_pathUI
    AgentContactDlg:create(agentNum,agentName, agentType):addTo(RechargeViewNode, Z_ORDER_COMMON)
end

--收到请求列表的返回消息
function RechargeLayer:onMsgAgentInfo(pUserdata)
    ActionDelay(self, function()
        FloatPopWait.getInstance():dismiss()
        self.m_pBtnFresh:setVisible(true)
        
        self.m_pTableView:reloadData()

        local slider = tolua.cast(self.m_pNodeTable:getChildByTag(100), "cc.ControlSlider")
        local count = #GlobalUserItem.tabAccountInfo.agentList
        if slider then
            local maxHeight = 120 * math.ceil(count / 3)
            self.m_nTableHeight = maxHeight
            local max = maxHeight - 390
            local maxVaule = (max > 0 and max or 0);
            slider:setMaximumValue(maxVaule)
        end

        -- 只有一屏则隐藏滚动条
        if count < 10 then
            local slider = tolua.cast(self.m_pNodeTable:getChildByTag(100), "cc.ControlSlider")
            if slider then
                slider:setVisible(false)
            end
        end
    end, 0.4)
end
--------------------------支付宝充值----------------------------
function RechargeLayer:initAlipayView()
    self.m_pRechargeAlipayView = self.m_pImgBg:getChildByName("panel_samplePayPanel")   --支付宝充值层    
    self.tab_moneyNode = {}     --存放预留按钮位置的节点
    self.tab_moneyBtn = {}      --存放新建的按钮
    self.m_pRechargeAlipayView:getChildByName("image_contentAlipay"):getChildByName("sprite_notInputTitle"):setVisible(false)
    for i = 1,10 do
        local node = self.m_pRechargeAlipayView:getChildByName("image_contentAlipay"):getChildByName("node_btnCont"):getChildByName("node_btn_"..i)
        table.insert(self.tab_moneyNode,node)
    end
    for i = 1,8 do
        local btn_money = self.btn_moneyMolde:clone()
        btn_money:setVisible(true)
        btn_money:getChildByName("money"):setString(i*100)
        btn_money:setTag(i)
        table.insert(self.tab_moneyBtn,btn_money)
        btn_money:setPosition(self.tab_moneyNode[i]:getPosition())
        btn_money:addTo(self.m_pRechargeAlipayView:getChildByName("image_contentAlipay"):getChildByName("node_btnCont"))
        btn_money:addTouchEventListener(function(sender,eventType)
            if not sender:isVisible() then return end
            if eventType==ccui.TouchEventType.began then
                ExternalFun.playSoundEffect("public/sound/sound-button.mp3")
                if sender then
                    sender:stopAllActions()
                    local pZoomTitleAction = cc.ScaleTo:create(0.05, 1.05, 1.05)
                    sender:runAction(pZoomTitleAction)
                end
            elseif eventType==ccui.TouchEventType.canceled then
                if sender then
                    sender:stopAllActions()
                    sender:setScale(1.0)
                end
            elseif eventType==ccui.TouchEventType.ended then 
                if sender then
                    sender:stopAllActions()
                    sender:setScale(1.0)
                end
                -- 响应选中
                self:onClickedAdd(i)
            end
        end)
    end
    --输入框
    self.inputBg = self.m_pRechargeAlipayView:getChildByName("image_contentAlipay"):getChildByName("image_inputBg")
    self.m_pEditBox = self.inputBg:getChildByName("text_readonlyInput")
    self.m_pEditBox:setString("请输入充值金额,最低100元")
    self.btn_clearInput = self.inputBg:getChildByName("button_clearInputBtn")   --输入框的清空按钮
    self.btn_clearInput:addClickEventListener(handler(self, self.onClickedAdd)) 
    self.btn_pay = self.m_pRechargeAlipayView:getChildByName("button_payBtn")   --立即充值按钮
    self.btn_pay:addClickEventListener(handler(self, self.onClickedCommit))
end
--不同面值按钮响应 
function RechargeLayer:onClickedAdd(nIndex)
    nIndex = tonumber(nIndex)
    if nIndex == nil then
        nIndex = 0
    end
    local moneyAdd = nIndex*100
    if moneyAdd ~= 0 then
        self.m_pEditBox:setText(moneyAdd)
    else
        self.m_pEditBox:setText("请输入充值金额,最低100元")
    end
    
end

function RechargeLayer:onClickedCommit(pSender)
    ExternalFun.playSoundEffect("public/sound/sound-button.mp3")
    if not self.m_pEditBox then
        return
    end
    local str = nil
    if self.rechargeType == 2 then
        str = self.m_pEditBox:getString()
    end

    if string.len(str) <= 0 then
        FloatMessage.getInstance():pushMessage("STRING_056")
        return
    end
    if not LuaUtils.string_number(str) then
        FloatMessage.getInstance():pushMessage("STRING_057")
        return
    end
    local money = tonumber(str)
    if type(money) ~= "number" then
        FloatMessage.getInstance():pushMessage("STRING_057")
        return
    end

    local nickName = GlobalUserItem.tabAccountInfo.nickname
    if self.rechargeType == 2 then
        local url = string.format(payparam.Type_Alipay,nickName,money)
        MultiPlatform:getInstance():openBrowser( url )
    elseif self.rechargeType == 3 then
        local url = string.format(payparam.Type_WeChat,nickName,money)
        MultiPlatform:getInstance():openBrowser( url )
    else
        print("不支持的支付类型!")
    end
end
----------------------------------------------------------------
function RechargeLayer:showRechargeWebView(_event)
    local strUserData = unpack(_event._userdata)
    print("showRechargeWebView strUserData:"..strUserData)
    if(strUserData == "" or strUserData == nil) then
       return
    end
    local vecStrings = {}
    vecStrings = string.split(strUserData, ";")
    if table.nums(vecStrings) == 0 then
        return
    end

    local nType = tonumber(vecStrings[1])
    local strData = vecStrings[2]
    local bVisible = tonumber(vecStrings[3])
    --"http://cashier.yfegame.com/pay/CreateOrderGateway?payType=QQWap&apiName=9127Pay-2&minAmount=0"
	--fix 增加时间戳参数
    local strUrl = string.format("%s?game_timestamp=%d",ClientConfig.getInstance():getCreateOrderUrl(), os.time())

    if self.m_pRechargeWebView then
--        self:removeWebView()
        self.m_pRechargeWebView:removeFromParent()
        self.m_pRechargeWebView = nil
    end
--    if not self.m_pRechargeWebView then
       self.m_pRechargeWebView = RechargeWebView:create(self)
--       self.m_pRechargeWebView:setWebViewInfoPost(nType, strUrl, strData)
       self.m_pRechargeWebView:setWebViewInfoPost(nType, strData, bVisible)
--    end
    
    self:addChild(self.m_pRechargeWebView)
end

function RechargeLayer:removeWebView()
    self.m_pRechargeWebView:removeFromParent()
    self.m_pRechargeWebView = nil
end

function RechargeLayer:onEnterForeground(_event)
    
    local isClosedAppStore = GameListManager.getInstance():getGameSwitch(Hall_Events.GAMESWITCH.CLOSE_RECHARGE_APPSTORE)
    if not isClosedAppStore then --如果是appstore界面打开 返回前台不请求充值结果
        return
    end
    SLFacade:dispatchCustomEvent(Hall_Events.MSG_QUERY_RECHARGE)
end

function RechargeLayer:getBankInfo()
--    if GameListManager.getInstance():getIsLoginGameSucFlag() then
--        CMsgGame:sendBankQueryInsureInfo()--5-1-查询
--    else
--        CMsgHall:sendQueryInsureInfoLite--3-425-获取银行和钱包的金币
--    end
end 

function RechargeLayer:onMsgBankInfo()
    --银行充值成功通知客户端
    print("=========onMsgBankInfo==========")
--    local lastScore = PlayerInfo.getInstance():getLastUserInsure()
--    local newScore = PlayerInfo.getInstance():getUserInsure()
--    local subScore = newScore - lastScore
--    if subScore > 0  then
--        FloatMessage.getInstance():pushMessage("STRING_047")
--    end
--    PlayerInfo.getInstance():setLastUserInsure(newScore)
end   

function RechargeLayer:onMsgChannelBack()
    Veil:getInstance():HideVeil(VEIL_REQUEST_DATA)    
    --请求充值详情
    if GameListManager.getInstance():getIsLoginGameSucFlag() then
    	self:onRechargeSwitch()
    else
        local isCloseStrategy = GameListManager.getInstance():getGameSwitch(G_CONSTANTS.GAMESWITCH.CLOSE_RECHARGE_STRATEGY)
        if isCloseStrategy then
            self:onRechargeSwitch()
        else
            CMsgHall:sendGetRechargeDetail()
			self:showWithStyle()      
		end
    end
end   

--超过十分钟需要请求排行版
function RechargeLayer:needNewRequest()
    local curTime = os.time()  
    local time = 10*60
    local lastQueryTime = GlobalUserItem.tabAccountInfo.lastGetQueryChannelTime or 0
    if curTime - lastQueryTime > time then
        GlobalUserItem.tabAccountInfo.lastGetQueryChannelTime = os.time()
        return true
    else
        return false
    end
end
-----------------------------------------------------------
function RechargeLayer:onAgentViewCallBack(result,message)
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if type(message) == "table" then
        if message.tag == "get_agency_ranking" then
            if message.result == "ok" then
                GlobalUserItem.tabAccountInfo.agentList = {}
                GlobalUserItem.tabAccountInfo.agentList = message.body
                
                SLFacade:dispatchCustomEvent(Hall_Events.MSG_GET_AGENT)
            end 
        end
    end
end
function RechargeLayer:sendReguestAgentList()
    print("请求服务器代理数据")
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "get_agency_ranking"
    msgta["body"] = {123456789}
--    msgta["body"]["openid"] = 1
    LogonFrame:sendGameData(msgta)
end

return RechargeLayer
