--region *.lua
--Date
--
--endregion

local HandredcattleTrendLayer   = class("HandredcattleTrendLayer", cc.Node)
--local Handredcattle_Events      = require("game.handredcattle.scene.HandredcattleEvent")
--local HoxDataMgr                = require("game.handredcattle.manager.HoxDataMgr")
--local scheduler                 = require("cocos.framework.scheduler")
local module_pre                    = "game.yule.brnngod.src"
local HandredcattleRes              = appdf.req(module_pre .. ".views.layer.handClasses.HandredcattleRes")

local TrendItemHeight = 41
local TrendItemWidth  = 142

function HandredcattleTrendLayer:ctor(table_)
    self.histroyTable = table_
    self:enableNodeEvents()
    self:initVar()
    self:initCSB()
end

function HandredcattleTrendLayer:initVar()
    self.m_nHistoryNum      = 0
    self.canClick           = true
    self.isScrolling        = false
    self.m_vecLatestSprite  = {}
    self.pAreaResultWin     = {}
    self.pAreaResultFail    = {}
end

function HandredcattleTrendLayer:initCSB()
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)

    self.m_pathUI = cc.CSLoader:createNode(HandredcattleRes.CSB_GAME_TREND)
    self.m_pathUI:addTo(self.m_rootUI)
    self.m_rootNode = self.m_pathUI:getChildByName("Panel_1")

    self.m_pNodeTableView = self.m_rootNode:getChildByName("LV_info")
    self.m_pNodeTableView:setScrollBarEnabled(false)
    self.m_pNodeTableView:setTouchEnabled(true)
--    self.m_pNodeTableView:addEventListener(function(sender,eventType)
--        self:scrollViewDidScroll()
--        if eventType == ccui.ScrollviewEventType.autoscrollEnded then
--            self.isScrolling = false
--            self.canClick = true
--        end
--    end)
    for i = 1, 4 do
        self.pAreaResultWin[i]  = self.m_rootNode:getChildByName(string.format("TXT_win_%d",i))
        self.pAreaResultFail[i] = self.m_rootNode:getChildByName(string.format("TXT_failure_%d",i))
    end
    self.pSumCount  = self.m_rootNode:getChildByName("TXT_label_num")
    self.m_pNodeNew = self.m_rootNode:getChildByName("IMG_new_tag")
--    self.m_pNewItem = cc.CSLoader:createNode(HandredcattleRes.CSB_GAME_TREND_NODE)
--    self.m_pNewItem:setAnchorPoint(0, 0)
--    self.m_pNewItem:setPositionX(TrendItemWidth / 2)
--    self.m_rootNode:getChildByName("Sprite_bg"):getChildByName("Sprite_newbg"):addChild(self.m_pNewItem)
    --隐藏
    for i = 1, 4 do
        self.m_rootNode:getChildByName("TXT_win_"..i):setVisible(false)
        self.m_rootNode:getChildByName("TXT_failure_"..i):setVisible(false)
    end
    self.m_rootNode:getChildByName("TXT_label_num"):setVisible(false)
end 

function HandredcattleTrendLayer:init()
    return self
end

function HandredcattleTrendLayer:onEnter()
    self:updateView()
    SLFacade:addCustomEventListener("Handredcattle_Event_13", handler(self, self.Handle_Custom_Ack), self.__cname)        
end

function HandredcattleTrendLayer:onExit()
    SLFacade:removeCustomEventListener("Handredcattle_Event_13", self.__cname)
end

function HandredcattleTrendLayer:Handle_Custom_Ack(_event)
    local _userdata = unpack(_event._userdata)
    if not _userdata then
        return
    end
    local eventID = _userdata.name
    local msg = _userdata.packet

    if eventID == "Handredcattle_Event_13" then
        self:onMsgUpdateTrendView()
    end
end

function HandredcattleTrendLayer:updateView()
    self:onMsgUpdateTrendView()
end
--通知更新新一局的数据
function HandredcattleTrendLayer:onEventUpdata( tab_ )
    table.remove(self.histroyTable,1)
    table.insert(self.histroyTable,tab_)
    self:onMsgUpdateTrendView()
end
function HandredcattleTrendLayer:onMsgUpdateTrendView()
    self:initTableView()
    self:updateTrendResultData()
    --self:updateLatestPartResult()
    --self:createSlider() 
end

function HandredcattleTrendLayer:initTableView()
    self.m_root_tp = cc.CSLoader:createNode(HandredcattleRes.CSB_GAME_TREND_NODE)
    self._list_item = {}
    self.m_pNodeTableView:removeAllChildren()

    local nTotalCount = #self.histroyTable--HoxDataMgr:getInstance():getHistoryListSize()-----------------------------------------------
    --self.m_nHistoryNum = nTotalCount >= 1 and (nTotalCount - 1) or nTotalCount
    self.m_nHistoryNum = nTotalCount
    --local val = self.m_nHistoryNum < 7 and self.m_nHistoryNum or 0
    local val = self.m_nHistoryNum
    self.m_nHistoryNum = self.m_nHistoryNum < 7 and 7 or self.m_nHistoryNum
    self.m_pNodeTableView:setInnerContainerSize(cc.size(118, self.m_nHistoryNum * TrendItemHeight))
    for i = self.m_nHistoryNum, 1, -1 do
        self._list_item[i] = self:initItem(i)
        self:SetItemInfo(self._list_item[i], i, val == i)
        --self:SetItemInfo(self._list_item[i], index)
--        if val > 0 and i > val then
--            self:SetItemInfo(self._list_item[i], -1)
--        else
--            self:SetItemInfo(self._list_item[i], i)
--        end
    end
    self.m_pNodeTableView:scrollToBottom(0,true)
--    local slider = tolua.cast(self.m_rootNode:getChildByTag(100), "cc.ControlSlider")
--    if slider then
--        slider:setValue(12)
--    end
end

function HandredcattleTrendLayer:updateTrendResultData()
    local pStr = nil
    if self.pSumCount then
        pStr = string.format("本日局数：%d",00)--HoxDataMgr.getInstance():getTotalBoard())
        self.pSumCount:setString(pStr)
    end
    --各区域全部输赢
--    for i = 1,4 do --DOWN_COUNT_HOX do
--        local winCount = HoxDataMgr.getInstance():getWinBoardCount(i)
--        local loseCount = HoxDataMgr.getInstance():getLoseBoardCount(i)
--        self.pAreaResultWin[i]:setString(string.format("%d",winCount))
--        self.pAreaResultFail[i]:setString(string.format("%d",loseCount))
--    end
end

function HandredcattleTrendLayer:updateLatestPartResult()
    local nTotalCount = #self.histroyTable--HoxDataMgr.getInstance():getHistoryListSize()
    if nTotalCount < 1 then return end
    self:SetItemInfo(self.m_pNewItem, nTotalCount)
    --self.m_pNewItem:setPosition(cc.p(TrendItemWidth/2, self.m_pNodeTableView:getPositionY()))
end

function HandredcattleTrendLayer:initItem(nRowIdx)    
    --(nRowIdx == 1) and self.m_root_tp or self.m_root_tp:clone()
    --子控件必须都是wiget子类才能clone！！！
    local item = cc.CSLoader:createNode(HandredcattleRes.CSB_GAME_TREND_NODE)
    item:setVisible(true)
    item:setPosition(cc.p(TrendItemWidth/2,(self.m_nHistoryNum-nRowIdx) * TrendItemHeight + 7))
    self.m_pNodeTableView:addChild(item)
    return item
end

function HandredcattleTrendLayer:SetItemInfo(_item, index, isLast)
    local historyInfo = self.histroyTable[index]--HoxDataMgr.getInstance():getHistoryByIdx(index)
    if historyInfo then
        for i = 1, 4 do
            local state = historyInfo[i]
            if state > 0 then
                state = true
            else
                state = false
            end
            local str = state and HandredcattleRes.IMG_TREND_WIN or HandredcattleRes.IMG_TREND_LOSE
            local spFlag = _item:getChildByName(string.format("IMG_result_%d",i))
            spFlag:loadTexture(str, ccui.TextureResType.plistType)
        end
        if isLast then
            local sp = cc.Sprite:createWithSpriteFrameName("gui-niuniu-trend-newbg.png")
                        :setAnchorPoint(0.5, 0)
            local ic = cc.Sprite:createWithSpriteFrameName("gui-niuniu-new-icon.png")
                        :setAnchorPoint(0.5, 0)
                        :setPosition(TrendItemWidth/2 - 5 , -7)
            _item:addChild(sp)
            _item:addChild(ic)
        end
    else
        for i = 1, 4 do
            local spFlag = _item:getChildByName(string.format("IMG_result_%d",i))
            spFlag:setVisible(false)
        end        
    end
end

function HandredcattleTrendLayer:scrollViewDidScroll()
    local slider = tolua.cast(self.m_rootNode:getChildByTag(100), "cc.ControlSlider")
    if not slider then
        return
    end
    local max = (self.m_nHistoryNum * TrendItemHeight) - 304
    local value = 106 + (math.floor(self.m_pNodeTableView:getInnerContainerPosition().y * 106 / max) + 12)
    slider:setValue(value)
end

function HandredcattleTrendLayer:createSlider()
    local slider = tolua.cast(self.m_rootNode:getChildByTag(100), "cc.ControlSlider")
    if slider then return end
    local spBg = cc.Sprite:createWithSpriteFrameName(HandredcattleRes.IMG_SCROLL_BG)
    -- //添加一个滑动条的背景
    local spBg0 = cc.Sprite:createWithSpriteFrameName(HandredcattleRes.IMG_SCROLL_BG)
    spBg0:setAnchorPoint(cc.p(0, 0))
    spBg:addChild(spBg0, 20)

    local pgSp = cc.Sprite:createWithSpriteFrameName(HandredcattleRes.IMG_NULL)
    pgSp:setOpacity(0)
    local spTub = cc.Sprite:createWithSpriteFrameName(HandredcattleRes.IMG_SCROLL_BUTTON)
    local spTub1 = cc.Sprite:createWithSpriteFrameName(HandredcattleRes.IMG_SCROLL_BUTTON)
    local slider = cc.ControlSlider:create(spBg, pgSp, spTub, spTub1)
    if not slider then
        return false
    end
    
    slider:setAnchorPoint(cc.p(0.5, 0.5))
    slider:setMinimumValue(0)
    slider:setMaximumValue(130)
    --slider:setPosition(cc.p(self.m_pNodeTableView:getContentSize().width + 5 , 299))
    slider:setPosition(cc.p(self.m_pNodeTableView:getPositionX() + self.m_pNodeTableView:getContentSize().width, 
                            self.m_pNodeTableView:getPositionY()))
    slider:setRotation(90)
    slider:setValue(12)
    slider:setTag(100)
    slider:setScaleX(0.85)
    slider:setEnabled(false)
    self.m_rootNode:addChild(slider, 50)
end

return HandredcattleTrendLayer