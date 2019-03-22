--region VipLayer.lua
--Date 2017.04.26.
--Auther JackyXu.
--Desc: 银行主页面

local SpineManager   = appdf.req(appdf.EXTERNAL_SRC .. "SpineManager")
local VipLayer       = class("VipLayer", FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local PAO_TEXT = {
    [0] = "默认炮台",
    [1] = "狂暴紫电",
    [2] = "天空之子",
    [3] = "暴裂熔岩",
    [4] = "炽热天使",
    [5] = "龙炎之怒",
    [6] = "神圣之光"
}
local VIP_MAX = 6

local VIP_VALUE = {
    [0] = 0,
    [1] = 30,
    [2] = 500,
    [3] = 3000,
    [4] = 10000,
    [5] = 30000,
    [6] = 70000,

    [7] = 70000,
}
function VipLayer:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_iCurPageIndex = 0

    local name = { "hall/plist/gui-userinfo.plist", "hall/plist/gui-userinfo.png", }
    display.loadSpriteFrames(name[1], name[2])
    self:init()
end

function VipLayer:onEnter()
    self.super:onEnter()

    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_BIG, FixLayer.HIDE_DLG_BIG)
    self:showWithStyle()
end

function VipLayer:onExit()
    self:clean()

    self.super:onExit()
end

function VipLayer:init()
    self:initCSB()
    self:initBtnEvent()
    self:initEvent()
    self:onUpdateUser()
    self:initPageView()
end

function VipLayer:clean()
    self:cleanEvent()
end

function VipLayer:initCSB()
    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    --csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/VipLayer.csb")
    self.m_pathUI:setPositionY((display.height - 750) / 2)
    self.m_pathUI:addTo(self.m_rootUI)

    --offset
    self.m_pNodeRoot = self.m_pathUI:getChildByName("Node_root")
    self.m_pNodeRoot:setPositionX((display.width - 1334) / 2)

    --btn
    self.m_pBtnClose = self.m_pNodeRoot:getChildByName("Button_Close")
    self.m_pBtnMall = self.m_pNodeRoot:getChildByName("Button_Mall")
    self.m_pBtnLeft = self.m_pNodeRoot:getChildByName("Button_Left")
    self.m_pBtnLeft2 = self.m_pNodeRoot:getChildByName("Button_Left2")
    self.m_pBtnRight = self.m_pNodeRoot:getChildByName("Button_Right")
    self.m_pBtnRight2 = self.m_pNodeRoot:getChildByName("Button_Right2")

    --node
    self.m_pImageLevel = self.m_pNodeRoot:getChildByName("Image_Vip")
    self.m_pProgressBar = self.m_pNodeRoot:getChildByName("LoadingBar")
    self.m_pTextPercent = self.m_pNodeRoot:getChildByName("Text_Percent")
    self.m_pNodeMM = self.m_pNodeRoot:getChildByName("Node_mm")

    --PageView
    self.m_pPageView = self.m_pNodeRoot:getChildByName("PageView")
    self.m_pPageItem = self.m_pPageView:getChildByName("Panel")

    --加上Spine MM
    self.skeletonNode = SpineManager.getInstance():getSpine("hall/effect/vip/vip")
    if self.skeletonNode ~= nil then
        self.skeletonNode:setPosition(cc.p(0 ,0))
        self.skeletonNode:setAnimation(0, "animation", true)
        self.m_pNodeMM:addChild(self.skeletonNode)
    end

    local seq = cc.Sequence:create(cc.MoveBy:create(0.4, cc.p(-8,0)),cc.MoveBy:create(0.4, cc.p(8,0)))
    self.m_pBtnLeft:runAction(cc.RepeatForever:create(seq))
    local seq2 = cc.Sequence:create(cc.MoveBy:create(0.4, cc.p(8,0)),cc.MoveBy:create(0.4, cc.p(-8,0)))
    self.m_pBtnRight:runAction(cc.RepeatForever:create(seq2))
end

function VipLayer:initBtnEvent()
    
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))
    self.m_pBtnMall:addClickEventListener(handler(self, self.onRecharegeClicked))
    self.m_pBtnLeft:addClickEventListener(handler(self, self.onLeftClicked))
    self.m_pBtnLeft2:addClickEventListener(handler(self, self.onLeftClicked))
    self.m_pBtnRight:addClickEventListener(handler(self, self.onRightClicked))
    self.m_pBtnRight2:addClickEventListener(handler(self, self.onRightClicked))
end

function VipLayer:initEvent()
--    SLFacade:addCustomEventListener(Hall_Events.MSG_UDPATE_USR_SCORE,  handler(self, self.onMsgUpdateInfo),     self.__cname) --更新金币
end

function VipLayer:cleanEvent()
--    SLFacade:removeCustomEventListener(Hall_Events.MSG_UDPATE_USR_SCORE,    self.__cname)
end

function VipLayer:onUpdateUser()
    
    --充值累计金额
    local value = GlobalUserItem.tabAccountInfo.exp_value/100
    value = value > VIP_VALUE[6] and VIP_VALUE[6] or value
    local level = GlobalUserItem.tabAccountInfo.vip_level--PlayerInfo.getInstance():getVipLevel()--vip等级

    --当前等级
    self.m_pImageLevel:loadTexture(self:getVipLogo_BIG(level), ccui.TextureResType.plistType)
     
    --当前进度
    local percent = self:getVipPercentByValue(value)
    self.m_pProgressBar:setPercent(percent * 100)
    local percent_text = string.format("%.0f/%.0f", value, VIP_VALUE[level+1])
    self.m_pTextPercent:setString(percent_text)

    --提示文字进度
--    local str ="<font size='24' color='#793C22'>再充值</font><font size='24' color='#FF4D00'>%.0f元</font><font size='24' color='#793C22'>，即可成为VIP%d，享更高特权</font>"
    local goldStr = self:getVipRechargeByValue(value)
    if self.m_pLbVip then
        self.m_pLbVip:removeFromParent()
    end
    self.m_pLbVip = ccui.RichText:create()
    self.m_pLbVip:setPosition(cc.p(750, 525))
    self.m_pLbVip:setAnchorPoint(cc.p(0.5, 0.5)) 
    self.m_pLbVip:addTo(self.m_pNodeRoot)
--    self.m_pLbVip:initWithXML(string.format(str, goldStr, level + 1) , {})
    local re1 = ccui.RichElementText:create(1,cc.c3b(121, 60, 34), 255,"再充值", "fonts/round_body.ttf", 24)
    local re2 = ccui.RichElementText:create(1,cc.c3b(255, 77, 0), 255,string.format("%.0f元", goldStr), "fonts/round_body.ttf", 24)
    local re3 = ccui.RichElementText:create(1,cc.c3b(121, 60, 34), 255,string.format("即可成为VIP%d，享更高特权", level + 1), "fonts/round_body.ttf", 24)
    self.m_pLbVip:pushBackElement(re1)
    self.m_pLbVip:pushBackElement(re2)
    self.m_pLbVip:pushBackElement(re3)
    self.m_pLbVip:formatText()
    self.m_pLbVip:setVisible(level < 6)
end
function VipLayer:getVipRechargeByValue(value)
    
    for i = 1, VIP_MAX do
        if value < VIP_VALUE[i] then
            return VIP_VALUE[i] - value
        end
    end
    return 0
end
function VipLayer:getVipPercentByValue(value)
    
    for i = 1, VIP_MAX do
        if value < VIP_VALUE[i] then
            return value / VIP_VALUE[i]
        end
    end
    return 100
end
function VipLayer:initPageView()
    for i = 1 ,VIP_MAX do
        local curPage = nil
        if i == 1 then
            curPage = self.m_pPageItem
        else
            curPage = self.m_pPageItem:clone()
            self.m_pPageView:addPage(curPage)
        end
        --根据vip等级更新信息
        local vipIcon1 = curPage:getChildByName("icon_VIP_icon")
        vipIcon1:loadTexture(self:getVipLogo(i), ccui.TextureResType.plistType)
        local vipIcon2 = curPage:getChildByName("icon_VIP_icon2")
        vipIcon2:loadTexture(self:getVipText(i), ccui.TextureResType.plistType)
        --头像框
        local vipHeadBg = curPage:getChildByName("Image_headBg")
        local vipFrame = cc.Sprite:createWithSpriteFrameName(string.format("hall/plist/userinfo/gui-frame-v%d.png", i))
        vipFrame:setAnchorPoint(cc.p(0.5, 0.5))
        vipFrame:setPosition(cc.p(100, 165))
        vipHeadBg:addChild(vipFrame)
        --炮台
        local vipPao = curPage:getChildByName("Image_fireBg")
        local paoFrame = cc.Sprite:createWithSpriteFrameName(string.format("hall/plist/vip/icon_vip_pao%d.png", i))
        paoFrame:setAnchorPoint(cc.p(0.5, 0.5))
        paoFrame:setPosition(cc.p(150, 175))
        vipPao:addChild(paoFrame)
        --炮台文字
        local vipPaoText = curPage:getChildByName("Image_fireBg"):getChildByName("Text_Pao")
        vipPaoText:setString(PAO_TEXT[i])
        --累计充值
--        local str = [[<font size='24' color='#793C22'>累积充值</font><font size='24' color='#FF4D00'>%d元</font>]]
        local goldStr = VIP_VALUE[i]
        local rechargeText = ccui.RichText:create()
--        rechargeText:initWithXML(string.format(str, goldStr) , {})
        local re1 = ccui.RichElementText:create(1,cc.c3b(121, 60, 34), 255,"累积充值", "fonts/round_body.ttf", 24)
        local re2 = ccui.RichElementText:create(1,cc.c3b(255, 77, 0), 255,string.format("%d元",goldStr), "fonts/round_body.ttf", 24)
        rechargeText:pushBackElement(re1)
        rechargeText:pushBackElement(re2)
        rechargeText:setPosition(cc.p(710,320))
        rechargeText:setAnchorPoint(cc.p(0.0, 0.5)) 
        rechargeText:addTo(curPage)
        rechargeText:formatText()
    end

    -- 监听滑动事件
    ccui.ScrollView.addEventListener(self.m_pPageView, function(sender, eventType)
        if eventType == ccui.ScrollviewEventType.autoscrollEnded then
            self.m_iCurPageIndex = sender:getCurrentPageIndex()
            self:updateVipInfo(self.m_iCurPageIndex)
            self:setButtonEnable(true)
        end
        --print(eventType, "now:", sender:getCurrentPageIndex())
    end)

    self.m_iCurPageIndex = GlobalUserItem.tabAccountInfo.vip_level
    self.m_iCurPageIndex = self.m_iCurPageIndex >= VIP_MAX and VIP_MAX - 1 or self.m_iCurPageIndex
    self.m_pPageView:setCurrentPageIndex(self.m_iCurPageIndex)
    self:updateVipInfo(self.m_iCurPageIndex)
end

function VipLayer:updateVipInfo(curPageIndex)
    --左右箭头
    self.m_pBtnLeft:setVisible(true)
    self.m_pBtnLeft2:setVisible(true)
    self.m_pBtnRight:setVisible(true)
    self.m_pBtnRight2:setVisible(true)
    if curPageIndex == 0 then
        self.m_pBtnLeft:setVisible(false)
        self.m_pBtnLeft2:setVisible(false)
    end
    if curPageIndex == VIP_MAX - 1 then
        self.m_pBtnRight:setVisible(false)
        self.m_pBtnRight2:setVisible(false)
    end
end

function VipLayer:gotoPage(pageIndex)
    self.m_pPageView:scrollToItem(pageIndex)
end

function VipLayer:setButtonEnable(enable)
    self.m_pBtnLeft:setTouchEnabled(enable)
    self.m_pBtnLeft2:setTouchEnabled(enable)
    self.m_pBtnRight:setTouchEnabled(enable)
    self.m_pBtnRight2:setTouchEnabled(enable)
end

function VipLayer:onMsgUpdateInfo()
    --查询银行信息成功,根据当前充值,vip等级更新界面
    self:onUpdateUser()
end

-- 关闭
function VipLayer:onReturnClicked()
    ExternalFun.playClickEffect()
    
    self:onMoveExitView()
end

--充值
function VipLayer:onRecharegeClicked()
    ExternalFun.playClickEffect()

--    --游戏中退出游戏打开充值，大厅中打开充值 
--    if GameListManager.getInstance():getIsLoginGameSucFlag() then
--        GameListManager.getInstance():setIsLoginGameSucFlag(false)
--        SLFacade:dispatchCustomEvent(Hall_Events.MSG_GAME_EXIT)
--        SLFacade:dispatchCustomEvent(Hall_Events.MSG_FISH_CLOSE)
--        PlayerInfo.getInstance():setCustomData("ShowRecharge")
--    else
        local _event = {
            name = Hall_Events.MSG_SHOW_SHOP,
            packet = nil,
        }
        SLFacade:dispatchCustomEvent(Hall_Events.MSG_SHOW_SHOP, _event)
--    end
end

--左
function VipLayer:onLeftClicked()
    ExternalFun.playClickEffect()

    self:gotoPage(self.m_iCurPageIndex - 1)
    self:setButtonEnable(false)
end

--右
function VipLayer:onRightClicked()
    ExternalFun.playClickEffect()

    self:gotoPage(self.m_iCurPageIndex + 1)
    self:setButtonEnable(false)
end

function VipLayer:getVipLogo_BIG(level)
    if 0 <= level and level <= 6 then
        return string.format("hall/plist/vip/icon_big_VIP%d.png", level)
    end
    return "hall/plist/hall/gui-texture-null.png"
end

function VipLayer:getVipLogo(level)
    if 0 < level and level <= 6 then
        return string.format("hall/plist/vip/icon_VIP%d.png", level)
    end
    return "hall/plist/hall/gui-texture-null.png"
end

function VipLayer:getVipText(level)
    if 0 <= level and level <= 6 then
        return string.format("hall/plist/vip/text-vip%d.png", level)
    end
    return "hall/plist/hall/gui-texture-null.png"
end



return VipLayer
