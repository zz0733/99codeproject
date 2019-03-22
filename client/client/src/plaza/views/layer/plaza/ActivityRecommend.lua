--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--region *.lua
--Date

local ActivityRecommend = class("ActivityRecommend", cc.Node)
local FloatMessage      = cc.exports.FloatMessage
--local GameListManager   = require("common.manager.GameListManager")
local scheduler = cc.Director:getInstance():getScheduler()
local AUTO_SCROLL_TIME = 5
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")   

function ActivityRecommend:ctor(pageSize)
    self:enableNodeEvents()
    self.m_fWidth = pageSize.width
    self.m_fHeight = pageSize.height
    self.m_pItems = {}
    self.m_pNodeCircle = nil

    self:init()
end

function ActivityRecommend:onEnter()
    
end

function ActivityRecommend:onExit()
    self:stopAutoScroll()
end

function ActivityRecommend:init()
    self.m_rootUI = display.newNode()
    self.m_rootUI:setPosition(cc.p(0,0))
    self.m_rootUI:addTo(self)

    local recommand = 401 -- PlayerInfo.getInstance():getRecommandGameKindID()
    local isGameExist = true--GameListManager.getInstance():isGameKindExist(recommand)
    local strPath = string.format("hall/image/file/gui-activity-game%d.png", recommand)
    local isFileExist =  cc.FileUtils:getInstance():isFileExist(strPath)
    if isGameExist and isFileExist then
        self:pushPageLayout(self:getGameLayout())
    end
    local isClosedWebSite = false-- GameListManager.getInstance():getGameSwitch(G_CONSTANTS.GAMESWITCH.CLOSE_WEBSITE_SHOW)
    if not isClosedWebSite then
        self:pushPageLayout(self:getWebsiteLayout())
    end
    local isCloseSpread = false -- GameListManager.getInstance():getGameSwitch(G_CONSTANTS.GAMESWITCH.CLOSE_SPREAD)
    if not isCloseSpread then
        self:pushPageLayout(self:getSpreadLayout())
    end

    self.m_nTotalActivity = table.nums(self.m_pItems)

    self.m_pPageView = ccui.PageView:create()
    --self.m_pPageView:setAutoScrollStopEpsilon(0.005)
    self.m_pPageView:addTo(self.m_rootUI)
    self.m_pPageView:setContentSize(self.m_fWidth, self.m_fHeight)
    self.m_pPageView:setAnchorPoint(cc.p(0.5,0.5))
    self.m_pPageView:setPosition(self.m_fWidth/2, self.m_fHeight/2)
    if self.m_nTotalActivity > 1 then
        self.m_pPageView:setTouchEnabled(true)
    else
        self.m_pPageView:setTouchEnabled(false)
    end
    self:initPagePanel()
    self:initCirCle()
end

function ActivityRecommend:startAutoScroll()
    if self.m_pAutoHandler then
         scheduler:unscheduleScriptEntry(self.m_pAutoHandler)
        self.m_pAutoHandler = nil
    end
    
   -- self.m_pAutoHandler = scheduler.performWithDelayGlobal(function()
   --     self:scrollToNext()
   -- end, AUTO_SCROLL_TIME)
    local nextpage = function()
        self:scrollToNext()
    end
    self.m_pAutoHandler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(nextpage, AUTO_SCROLL_TIME, false)

end

function ActivityRecommend:stopAutoScroll()
    if self.m_pAutoHandler then
        --scheduler.unscheduleGlobal(self.m_pAutoHandler)
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.m_pAutoHandler)
        self.m_pAutoHandler = nil
    end
end

function ActivityRecommend:scrollToNext()
    --滚动到下一个
    local curIdx = self.m_pPageView:getCurrentPageIndex()
    self.m_pPageView:scrollToPage(curIdx + 1)
end

function ActivityRecommend:initPagePanel()
    local pages = table.nums(self.m_pItems) or 0
     -- 监听滑动事件
    self.m_pPageView:addEventListener(function(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            self:onPageViewEvent(sender, eventType)
        end
    end)

    self.m_nTotalPage = pages + 1
    if 1 == pages then
        self:addCustomPageView(1, 0)
    elseif pages >= 2 then
        self:addCustomPageView(pages, 0)
        for i = 1, pages do
            self:addCustomPageView(i, i)
        end
        self:addCustomPageView(1, pages + 1)
        self.m_pPageView:jumpToPercentHorizontal(1/self.m_nTotalPage*100)
        self:startAutoScroll()
    end
end

-- @realIndex:     该页显示的内容索引(数组的索引1 ~ pages)
-- @pageIndex:     插入位置（pageView的页码索引）
function ActivityRecommend:addCustomPageView(realIndex, pageIndex)
	local layout = self.m_pItems[realIndex]:clone()
    self.m_pPageView:insertPage(layout, pageIndex)
end

function ActivityRecommend:pushPageLayout(layout)
    layout:retain()
    table.insert(self.m_pItems, layout)
end

function ActivityRecommend:onPageViewEvent(sender, eventType)
    local curPage = self.m_pPageView:getCurrentPageIndex()
    --print("========onPageViewEvent=======  curPage = %d",curPage)
    local realIndex = curPage
    if eventType == ccui.PageViewEventType.turning then
        --滑到最后一个移动到第2个
        if curPage == self.m_nTotalPage then
            realIndex = 1
            ActionDelay(self.m_pPageView, function()
                self.m_pPageView:setCurrentPageIndex(1)
                self:startAutoScroll()
            end, 0.02) 
        elseif curPage == 0 then --滑动到第一个移动到倒数第二个
            realIndex = self.m_nTotalActivity
            ActionDelay(self.m_pPageView, function()
                self.m_pPageView:setCurrentPageIndex(self.m_nTotalPage - 1)
                self:startAutoScroll()
            end, 0.02) 
        else
            self:startAutoScroll()
        end
        --滑动后下面小圆点的状态刷新
        self:updateCirCle(realIndex)
    end
end

--推荐展示-官网
function ActivityRecommend:getWebsiteLayout(layout)
    local strWebsite = "www.tianshen898.com"
    local layout=ccui.Layout:create()
    layout:setContentSize(self.m_fWidth, self.m_fHeight)
    layout:setPosition(0,0)
    layout:setTouchEnabled(true)
    layout:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began or
           eventType == ccui.TouchEventType.moved then
            self:stopAutoScroll()
        elseif eventType == ccui.TouchEventType.ended or
           eventType == ccui.TouchEventType.canceled then
            self:startAutoScroll()
        end
    end ) 
    layout:addClickEventListener(function()
        ExternalFun.playClickEffect()
        MultiPlatform.getInstance():copyToClipboard(strWebsite)
        FloatMessage.getInstance():pushMessage("STRING_204")
    end) 
    --bg
    local image = ccui.ImageView:create("hall/image/file/gui-activity-website.png", ccui.TextureResType.localType)
    image:setAnchorPoint(cc.p(0.5,0.5))
    image:setPosition(cc.p(self.m_fWidth/2, self.m_fHeight/2))
    layout:addChild(image)
    --官网
    local lbWebsite = ccui.Text:create(strWebsite, "Helvetica", 26)
    lbWebsite:setPosition(cc.p(165, 90))
    lbWebsite:setAnchorPoint(cc.p(0.5, 0))
    lbWebsite:setColor(cc.c3b(0xFF,0xFF,0xFF))
    image:addChild(lbWebsite)

    return layout
end

--推荐展示-全民推广
function ActivityRecommend:getSpreadLayout(layout)
    local layout=ccui.Layout:create()
    layout:setContentSize(self.m_fWidth, self.m_fHeight)
    layout:setPosition(0,0)
    layout:setTouchEnabled(true)
    layout:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began or
           eventType == ccui.TouchEventType.moved then
            self:stopAutoScroll()
        elseif eventType == ccui.TouchEventType.ended or
           eventType == ccui.TouchEventType.canceled then
            self:startAutoScroll()
        end
    end ) 
    layout:addClickEventListener(function()
        ExternalFun.playClickEffect()
        local _event = {
            name = Hall_Events.SHOW_SPREAD_ACTIVITY,
            packet = nil,
        }
        SLFacade:dispatchCustomEvent(Hall_Events.SHOW_SPREAD_ACTIVITY, _event)
    end) 
    local image = ccui.ImageView:create("hall/image/file/gui-activity-spread.png", ccui.TextureResType.localType)
    image:setAnchorPoint(cc.p(0.5,0.5))
    image:setPosition(cc.p(self.m_fWidth/2, self.m_fHeight/2))
    layout:addChild(image)

    return layout
end

--推荐展示-推荐游戏
function ActivityRecommend:getGameLayout(layout)
    local recommand = 401 --PlayerInfo.getInstance():getRecommandGameKindID()
    local KindID = "1006" --写死斗地主
    local layout=ccui.Layout:create()
    layout:setContentSize(self.m_fWidth, self.m_fHeight)
    layout:setPosition(0,0)
    layout:setTouchEnabled(true)
    layout:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began or
           eventType == ccui.TouchEventType.moved then
            self:stopAutoScroll()
        elseif eventType == ccui.TouchEventType.ended or
           eventType == ccui.TouchEventType.canceled then
            self:startAutoScroll()
        end
    end ) 
    layout:addClickEventListener(function()
        ExternalFun.playClickEffect()
        local _event = {
            name = Hall_Events.ENTER_RECOMMEND_GAME,
            packet = {gamekind = KindID},
        }
        SLFacade:dispatchCustomEvent(Hall_Events.ENTER_RECOMMEND_GAME, _event)
    end) 
    --bg
    local strPath = string.format("hall/image/file/gui-activity-game%d.png", recommand)
    local image = ccui.ImageView:create(strPath, ccui.TextureResType.localType)
    image:setAnchorPoint(cc.p(0.5,0.5))
    image:setPosition(cc.p(self.m_fWidth/2, self.m_fHeight/2))
    layout:addChild(image)
    --需要给推荐游戏加上new hot
    local info = GameListManager.getInstance():getGameListInfo(recommand)
    if info and info.dwStatus > 0 then
        local pLogo = nil
        if info.dwStatus == 1 then
            pLogo = ccui.ImageView:create("hall/plist/hall/gui-logo-new.png", ccui.TextureResType.plistType)
        elseif info.dwStatus == 2 then
            pLogo = ccui.ImageView:create("hall/plist/hall/gui-logo-hot.png", ccui.TextureResType.plistType)
        else
            pLogo = ccui.ImageView:create("hall/plist/hall/gui-logo-new.png", ccui.TextureResType.plistType)
        end
        pLogo:setPosition(cc.p(299.5, 403.5))
        pLogo:addTo(image)

        if pLogo then
            local manager = ccs.ArmatureDataManager:getInstance()
            manager:addArmatureFileInfo("hall/effect/shaoguangAnimation/shaoguangAnimation.ExportJson")    
            local pArmature = ccs.Armature:create("shaoguangAnimation")
            if pArmature then
                pArmature:getAnimation():play("Animation1", -1, 1)
                --pArmature:setAnchorPoint(0.5, 0.5)
                pArmature:setPosition(cc.p(40, 40))
                pArmature:addTo(pLogo)
            end
        end
    end

    return layout
end

--推荐展示-保存官网地址(ios浏览器打开提示保存到桌面)
function ActivityRecommend:getSaveLayout(layout)
    local layout=ccui.Layout:create()
    layout:setContentSize(self.m_fWidth, self.m_fHeight)
    layout:setPosition(0,0)
    layout:setTouchEnabled(true)
    layout:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began or
           eventType == ccui.TouchEventType.moved then
            self:stopAutoScroll()
        elseif eventType == ccui.TouchEventType.ended or
           eventType == ccui.TouchEventType.canceled then
            self:startAutoScroll()
        end
    end ) 
    layout:addClickEventListener(function()
         --TODO:
         LuaNativeBridge:getInstance():openURL(PlayerInfo.getInstance():getOfficialWebsite())
    end) 
    --bg
    local strPath = string.format("hall/image/file/gui-activity-website.png", PlayerInfo.getInstance():getRecommandGameKindID())
    local image = ccui.ImageView:create(strPath, ccui.TextureResType.localType)
    image:setAnchorPoint(cc.p(0.5,0.5))
    image:setPosition(cc.p(self.m_fWidth/2, self.m_fHeight/2))
    layout:addChild(image)

    return layout
end

function ActivityRecommend:initCirCle()
    --滑动点
    self.m_pNodeCircle = display.newNode()
    self.m_pNodeCircle:setPosition(cc.p(self.m_fWidth/2, 20))
    self.m_pNodeCircle:addTo(self.m_rootUI)

    if self.m_nTotalActivity <= 1 then
        return
    end

    local beginX = 0
    if self.m_nTotalActivity % 2 == 0 then --偶数个
        beginX = 15 - 30*self.m_nTotalActivity/2
    else --奇数个
        beginX = - 30*math.floor(self.m_nTotalActivity/2)
    end
    for i = 1, self.m_nTotalActivity  do
        local sp = cc.Sprite:createWithSpriteFrameName("hall/plist/hall/gui-hall-page-normal.png")
        sp:setTag(i)
        sp:setPosition(cc.p( beginX + (i-1)*30, 0))
        self.m_pNodeCircle:addChild(sp)
    end
    self:updateCirCle(1)
end

function ActivityRecommend:updateCirCle(realIndx)
    if self.m_nTotalActivity <= 1 then
        return
    else
        for i = 1, self.m_nTotalActivity do
        local sp = self.m_pNodeCircle:getChildByTag(i)
        if realIndx == i then
            sp:setSpriteFrame("hall/plist/hall/gui-hall-page-active.png")
        else
            sp:setSpriteFrame("hall/plist/hall/gui-hall-page-normal.png")
        end
    end
    end
end

return ActivityRecommend


--endregion
