--region LhdzRecordLayer.lua
--Date
--Auther Ace
--Des [[龙虎斗历史记录界面]]
--此文件由[BabeLua]插件自动生成

local LhdzTrendLayer = class("LhdzTrendLayer", cc.Layer)
--local AudioManager = cc.exports.AudioManager

local Lhdz_Res = require("game.yule.lhdz.src.game.longhudazhan.scene.Lhdz_Res")
local Lhdz_Const = require("game.yule.lhdz.src.game.longhudazhan.scene.Lhdz_Const")
local LhdzDataMgr = require("game.yule.lhdz.src.game.longhudazhan.manager.LhdzDataMgr")

LhdzTrendLayer.instance_ = nil
function LhdzTrendLayer.create()
    LhdzTrendLayer.instance_ = LhdzTrendLayer.new():init()
    return LhdzTrendLayer.instance_
end

function LhdzTrendLayer:ctor()
    self:enableNodeEvents()

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
end

function LhdzTrendLayer:init()
    self:initVar()
    self:initCSB()
    return self
end

function LhdzTrendLayer:onEnter()
end

function LhdzTrendLayer:onExit()
end

function LhdzTrendLayer:initVar()
    self.m_pLayerTrend = nil
    self.m_pNodeVS = nil
    self.m_pNodeHistorys = nil
    self.m_pNodeTrend = nil
    self.m_pNodeTrendTable = nil
    self.m_pNodeTrendItem = nil
    self.m_pNodeRecord = nil
    self.m_pNodeRecordTable = nil
    self.m_pNodeRecordItem = nil
    self.m_pNodeCount = nil
    
    self.m_pBtnClose = nil

    self.m_pLbTigerCount = nil
    self.m_pLbDragonCount = nil
    self.m_pLbDrawCount = nil
    self.m_pLbTotalCount = nil
    self.m_pLbDragonRate = nil -- 龙胜率
    self.m_pLbTigerRate = nil -- 虎胜率

    self.m_pSpHistory = {}
    self.m_pSpTwentyTrend = nil -- 20局走势

    self.m_pProgressDragon = nil
    self.m_pProgressTiger = nil

    self.m_pTrendTableView = nil
    self.m_pRecordTableView = nil

    self.m_nRecordSize = 0
    self.m_nTrendSize = 0
end

function LhdzTrendLayer:initCSB()
    local _pUiLayer = cc.CSLoader:createNode(Lhdz_Res.CSB_OF_TREND)
    _pUiLayer:setAnchorPoint(cc.p(0.5,0.5))
    _pUiLayer:setPosition(cc.p(667, 375 + (display.size.height - 750) / 2))
    self.m_rootUI:addChild(_pUiLayer, Z_ORDER_TOP)

    self.m_pLayerRoot = _pUiLayer:getChildByName("Panel_root")
    local diffX = 145 - (1624-display.size.width)/2 
    self.m_pLayerRoot:setPositionX(diffX)
    
    self.m_pLayerTrend = self.m_pLayerRoot:getChildByName("Panel_trend")
    self.m_pNodeVS = self.m_pLayerTrend:getChildByName("Node_vs")
    self.m_pProgressDragon = self.m_pNodeVS:getChildByName("Image_dragon")
    self.m_pProgressTiger = self.m_pNodeVS:getChildByName("Image_tiger")
    self.m_pSpTwentyTrend = self.m_pNodeVS:getChildByName("Sprite_twenty_trend")
    self.m_pLbDragonRate = self.m_pNodeVS:getChildByName("BitmapFontLabel_dragon")
    self.m_pLbTigerRate = self.m_pNodeVS:getChildByName("BitmapFontLabel_tiger")

    self.m_pNodeHistorys = self.m_pLayerTrend:getChildByName("Node_historys")
    for i=1, Lhdz_Const.MAX_HISTORY_COUNT do
        self.m_pSpHistory[i] = self.m_pNodeHistorys:getChildByName(string.format("Sprite_history_%d", i))
        self.m_pSpHistory[i]:setVisible(false)
    end
    self.m_pNodeTrend = self.m_pLayerTrend:getChildByName("Node_trend")
    self.m_pNodeTrendTable = self.m_pNodeTrend:getChildByName("Panel_trend_tableView")
    self.m_pNodeTrendItem = self.m_pNodeTrend:getChildByName("Panel_trendItem")
    self.m_pNodeTrendItem:setVisible(false)

    self.m_pNodeRecord = self.m_pLayerTrend:getChildByName("Node_record")
    self.m_pNodeRecordTable = self.m_pNodeRecord:getChildByName("Panel_record_tableView")
    self.m_pNodeRecordItem = self.m_pNodeRecord:getChildByName("Node_recordItem")
    self.m_pNodeRecordItem:setVisible(false)

    self.m_pNodeCount = self.m_pLayerTrend:getChildByName("Node_count")
    self.m_pLbTigerCount = self.m_pNodeCount:getChildByName("BitmapFontLabel_tiger_count")
    self.m_pLbDragonCount = self.m_pNodeCount:getChildByName("BitmapFontLabel_dragon_count")
    self.m_pLbDrawCount = self.m_pNodeCount:getChildByName("BitmapFontLabel_draw_count")
    self.m_pLbTotalCount = self.m_pNodeCount:getChildByName("BitmapFontLabel_total_count")

    self.m_pBtnClose = self.m_pLayerTrend:getChildByName("Button_close")
    self.m_pBtnClose:addClickEventListener(function()
--        AudioManager.getInstance():playSound(Lhdz_Res.vecSound.SOUND_OF_CLOSE)
        self:removeFromParent()
    end)
    -- 设置弹窗动画节点
    --self:setTargetActNode(self.m_pLayerTrend)
    self:showPop()
end

function LhdzTrendLayer:updateInfo()
    self:updateWinRare()
    self:updateHistory()
    self:updateAreaWinCount()
    self:updateTrendList()
    self:updateRecordList()
end

-- 更新龙虎胜率
function LhdzTrendLayer:updateWinRare()
    local dragonPercent, tigerPercent = LhdzDataMgr.getInstance():getTwentyWinPercent()
    self.m_pProgressDragon:setContentSize(cc.size(894*dragonPercent/100, self.m_pProgressDragon:getContentSize().height))
    self.m_pProgressTiger:setContentSize(cc.size(894*tigerPercent/100, self.m_pProgressTiger:getContentSize().height))
    self.m_pLbDragonRate:setString(string.format("%d%%", dragonPercent))
    self.m_pLbTigerRate:setString(string.format("%d%%", tigerPercent))
    self.m_pLbDragonRate:setVisible(dragonPercent > 0)
    self.m_pLbTigerRate:setVisible(tigerPercent > 0)

    local dragonSize = self.m_pProgressDragon:getPositionX() + self.m_pProgressDragon:getContentSize().width
    local tigerSize = self.m_pProgressTiger:getPositionX() - self.m_pProgressTiger:getContentSize().width
    --self.m_pLbDragonRate:setPositionX(dragonSize - 10)
    --self.m_pLbTigerRate:setPositionX(tigerSize + 10)
    local nTrendPosX = dragonSize + self.m_pSpTwentyTrend:getContentSize().width/2 + 11
    if dragonPercent == 0 and tigerPercent == 0 then
        nTrendPosX = 0
    end
    --self.m_pSpTwentyTrend:setPositionX(nTrendPosX)
end

function LhdzTrendLayer:updateHistory()
    local nSize = LhdzDataMgr.getInstance():getHistoryListSize()
    if nSize > Lhdz_Const.MAX_HISTORY_COUNT then
        nSize = Lhdz_Const.MAX_HISTORY_COUNT
    end
    for i=nSize, 1, -1 do
        local pHistory = LhdzDataMgr.getInstance():getHistoryByIndex(nSize-i+1)
        local path = Lhdz_Res.PNG_OF_ICON_DRAW
        if pHistory.cbAreaType == Lhdz_Const.AREA.DRAGON then
            path = Lhdz_Res.PNG_OF_ICON_DRAGON
        elseif pHistory.cbAreaType == Lhdz_Const.AREA.TIGER then
            path = Lhdz_Res.PNG_OF_ICON_TIGER
        end
        self.m_pSpHistory[i]:setVisible(true)
        self.m_pSpHistory[i]:setSpriteFrame(path)
    end
end

function LhdzTrendLayer:updateAreaWinCount()
    self.m_pLbTigerCount:setString(LhdzDataMgr.getInstance():getTigerWinCount())
    self.m_pLbDragonCount:setString(LhdzDataMgr.getInstance():getDragonWinCount())
    self.m_pLbDrawCount:setString(LhdzDataMgr.getInstance():getDrawWinCount())
    self.m_pLbTotalCount:setString(LhdzDataMgr.getInstance():getHistoryListSize())
end

--  更新牌路
function LhdzTrendLayer:updateTrendList()
    if not self.m_pTrendTableView then
        local tableSize = self.m_pNodeTrendTable:getContentSize()
        self.m_pTrendTableView = cc.TableView:create(tableSize)
--        self.m_pTrendTableView:setIgnoreAnchorPointForPosition(false)
        self.m_pTrendTableView:setAnchorPoint(cc.p(0,0))
        self.m_pTrendTableView:setPosition(cc.p(0,0))
        self.m_pTrendTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        self.m_pTrendTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pTrendTableView:setTouchEnabled(true)
        self.m_pTrendTableView:setDelegate()
        self.m_pNodeTrendTable:addChild(self.m_pTrendTableView)

        self.m_pTrendTableView:registerScriptHandler(handler(self,self.trendTableCellSizeForIndex), cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_pTrendTableView:registerScriptHandler(handler(self,self.trendTableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
        self.m_pTrendTableView:registerScriptHandler(handler(self,self.numberOfCellsInTrendTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    end
    self.m_nTrendSize = LhdzDataMgr.getInstance():getTrendListSize()
    self.m_pTrendTableView:reloadData()
    local offsetX = self.m_pNodeTrendTable:getContentSize().width - self.m_pTrendTableView:getContentSize().width
    self.m_pTrendTableView:setContentOffset(cc.p(offsetX, 0))
end

function LhdzTrendLayer:initTrendTableViewCell(cell, index)
    local tableItem = cell:getChildByName("TrendItem")
    if not tableItem then
        tableItem = self.m_pNodeTrendItem:clone()
        tableItem:setName("TrendItem")
        tableItem:setVisible(true)
        tableItem:setPosition(cc.p(0, 0))
        cell:addChild(tableItem)
    end
    for i=1, 5 do
        local trendInfo = LhdzDataMgr.getInstance():getTrendListByIndex(index+1)
        local pSpItem = tableItem:getChildByName(string.format("Image_item_%d", i))
        if trendInfo then
            pSpItem:setVisible(trendInfo[i].cbAreaType~=-1)
            local path = Lhdz_Res.PNG_OF_ICON_DRAW
            if trendInfo[i].cbAreaType == Lhdz_Const.AREA.DRAGON then
                path = Lhdz_Res.PNG_OF_ICON_DRAGON
            elseif trendInfo[i].cbAreaType == Lhdz_Const.AREA.TIGER then
                path = Lhdz_Res.PNG_OF_ICON_TIGER
            end
            if trendInfo[i].cbAreaType ~= -1 then
                pSpItem:loadTexture(path, ccui.TextureResType.plistType)
            end
        else
            pSpItem:setVisible(false)
        end
    end
    return cell
end

function LhdzTrendLayer:trendTableCellAtIndex(table, index)
    local cell = table:dequeueCell()
    if not cell then
        cell = cc.TableViewCell:new()
    end
    self:initTrendTableViewCell(cell, index);
    return cell
end

function LhdzTrendLayer:trendTableCellSizeForIndex(table, index)
    return 47, 233
end

function LhdzTrendLayer:numberOfCellsInTrendTableView(table)
    return self.m_nTrendSize > 20 and self.m_nTrendSize or 20
end

--  更新牌型走势
function LhdzTrendLayer:updateRecordList()
    if not self.m_pRecordTableView then
        local tableSize = self.m_pNodeRecordTable:getContentSize()
        self.m_pRecordTableView = cc.TableView:create(tableSize)
--        self.m_pRecordTableView:setIgnoreAnchorPointForPosition(false)
        self.m_pRecordTableView:setAnchorPoint(cc.p(0,0))
        self.m_pRecordTableView:setPosition(cc.p(0,0))
        self.m_pRecordTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        self.m_pRecordTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pRecordTableView:setTouchEnabled(true)
        self.m_pRecordTableView:setDelegate()
        self.m_pNodeRecordTable:addChild(self.m_pRecordTableView)

        self.m_pRecordTableView:registerScriptHandler(handler(self,self.recordTableCellSizeForIndex), cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_pRecordTableView:registerScriptHandler(handler(self,self.recordTableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
        self.m_pRecordTableView:registerScriptHandler(handler(self,self.numberOfCellsInRecordTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    end
    self.m_nRecordSize = LhdzDataMgr.getInstance():getHistoryListSize()
    self.m_pRecordTableView:reloadData()
    local offsetX = 0
    if math.ceil(LhdzDataMgr.getInstance():getHistoryListSize()/2) > 5 then
        offsetX = self.m_pNodeRecordTable:getContentSize().width - self.m_pRecordTableView:getContentSize().width
    end
    self.m_pRecordTableView:setContentOffset(cc.p(offsetX, 0))
end

function LhdzTrendLayer:initRecordTableViewCell(cell, index)
    local tableItem = cell:getChildByName("RecordItem")
    if not tableItem then
        tableItem = self.m_pNodeRecordItem:clone()
        tableItem:setName("RecordItem")
        tableItem:setVisible(true)
        tableItem:setPosition(cc.p(0, 0))
        cell:addChild(tableItem)
    end
    local historySize = LhdzDataMgr:getInstance():getHistoryListSize()
    local history = LhdzDataMgr:getInstance():getHistoryByIndex(historySize - index)
    for i=1, 2 do
        local pSpItemBg = tableItem:getChildByName(string.format("Image_item_bg_%d", i))
        local pLbValue = pSpItemBg:getChildByName("BitmapFontLabel_value")
        local pSpSubscript = pSpItemBg:getChildByName("Image_subscript") -- 角标
        local wintag = pSpItemBg:getChildByName("lhdz_sp_wintag")

        wintag:setVisible(false)
        pSpItemBg:setVisible(history~=nil)
        pLbValue:setVisible(history~=nil)
        pSpSubscript:setVisible(false)
        if history then
            local path = Lhdz_Res.PNG_OF_RECORD_GREEN
            if i == 1 then
                path = Lhdz_Res.PNG_OF_RECORD_BLUE
            elseif i == 2 then
                path = Lhdz_Res.PNG_OF_RECORD_RED
            end
            pSpItemBg:loadTexture(path, ccui.TextureResType.plistType)
--            local value = LhdzDataMgr.getInstance():getCardValueAndColor(history.cbCardData[i])
--            local v1 = LhdzDataMgr.getInstance():getCardValueAndColor(history.cbCardData[1])
--            local v2 = LhdzDataMgr.getInstance():getCardValueAndColor(history.cbCardData[2])
--            if v1>v2 then
--                wintag:setVisible(i == 1)
--            elseif v1<v2 then
--                wintag:setVisible(i == 2)
--            end
--            if value == 11 then
--                value = "J"
--            elseif value == 12 then
--                value = "Q"
--            elseif value == 13 then
--                value = "K"
--            elseif value == 1 then
--                value = "A"
--            end
--            pLbValue:setString(tostring(value))
            if historySize - index <= 1  and i==2 then
                pSpSubscript:setVisible(true)
            end
        end
    end
    return cell
end

function LhdzTrendLayer:recordTableCellAtIndex(table, index)
    local cell = table:dequeueCell()
    if not cell then
        cell = cc.TableViewCell:new()
    end
    self:initRecordTableViewCell(cell, index);
    return cell
end

function LhdzTrendLayer:recordTableCellSizeForIndex(table, index)
    return 87, 86
end

function LhdzTrendLayer:numberOfCellsInRecordTableView(table)
    return self.m_nRecordSize
end

function LhdzTrendLayer:showPop()
    self.m_pLayerTrend:setScale(0.0)
    local show = cc.Show:create()
    local scaleTo = cc.ScaleTo:create(0.4, 1.0)
    local ease = cc.EaseBackOut:create(scaleTo)
    local seq = cc.Sequence:create(show,ease)
    self.m_pLayerTrend:runAction(seq)
end

return LhdzTrendLayer

--endregion
