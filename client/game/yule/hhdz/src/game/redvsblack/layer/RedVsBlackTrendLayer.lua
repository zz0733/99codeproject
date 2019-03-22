-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成	

local RedVsBlackDataManager = require("game.yule.hhdz.src.game.redvsblack.manager.RedVsBlackDataManager")
local RedVsBlackEvent       = require("game.yule.hhdz.src.game.redvsblack.scene.RedVsBlackEvent")
local RedVsBlackRes         = require("game.yule.hhdz.src.game.redvsblack.scene.RedVsBlackRes")
--local AudioManager          = appdf.req("game.yule.hhdz.src.models.AudioManager")

local RedVsBlackTrendLayer  = class("RedVsBlackTrendLayer", cc.Layer)

local ringIconPath = { RedVsBlackRes.IMG_RING_RED, RedVsBlackRes.IMG_RING_BLACK }

--region 初始化
function RedVsBlackTrendLayer.create()
	return RedVsBlackTrendLayer:new()
end  

function RedVsBlackTrendLayer:ctor()
    self:enableNodeEvents()
    self:init()
end

function RedVsBlackTrendLayer:onEnter()
    self.update_list_listener = SLFacade:addCustomEventListener(RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_HISTORY_INFO, handler(self, self.Handle_Custom_Ack))
    onOpenLayer(self.m_pathUI:getChildByName("Panel_bg"), self.m_pathUI:getChildByName("Panel_1"), self)
end 

function RedVsBlackTrendLayer:onExit()
    SLFacade:removeEventListener(self.update_list_listener)
end

function RedVsBlackTrendLayer:init()

    self.m_isTouch = false
    self.m_needRefreshDalu = false
    self.m_needRefreshCardType = false
    self.m_pViewTypeMaxCol = 0
    self.m_pViewIconMaxCol = 0

    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
    
    self.m_pathUI = cc.CSLoader:createNode(RedVsBlackRes.CSB_GAME_TREND)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0, diffY))
    self.m_pathUI:addTo(self.m_rootUI)

    local diffX = 145-(1624-display.size.width)/2
    local _panel = self.m_pathUI:getChildByName("Panel_bg"):getChildByName("Node_root")
    _panel:setPositionX(diffX)

    local _btn_close = _panel:getChildByName("Btn_close")
    _btn_close:addClickEventListener(function()
        self:onReturnClicked(1)
    end)

    self.Panel_type = _panel:getChildByName("Panel_type")
    self.Panel_dalu = _panel:getChildByName("Panel_dalu")
    self.iconPanel = _panel:getChildByName("Panel_icon")
    self.redperLabel = _panel:getChildByName("Text_redPercent")
    self.blackperLabel = _panel:getChildByName("Text_blackPercent")
    self.progressPanel = _panel:getChildByName("Panel_percent")
    self:initCardTypeTableView(true)
    self:viewIconList()
    self:viewPercentProgress()

    --self:addtestdalurecord()
    -- 显示大路列表之前 先重置数据对象
    RedVsBlackDataManager.getInstance():resetPaiLuVec()
    self:initDaluTableView(true)
end
--endregion

--region 牌型滑动列表

function RedVsBlackTrendLayer:initCardTypeTableView(isFirst)
	if not self.m_pCardTypeView then
        self.m_pCardTypeView = cc.TableView:create(cc.size(812, 71))
        self.m_pCardTypeView:setBounceable(true)
--        self.m_pCardTypeView:setIgnoreAnchorPointForPosition(false)
        self.m_pCardTypeView:setAnchorPoint(cc.p(0,0))
        self.m_pCardTypeView:setPosition(cc.p(7,2))
        self.m_pCardTypeView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        self.m_pCardTypeView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pCardTypeView:setTouchEnabled(true)
        self.m_pCardTypeView:setDelegate()
        self.Panel_type:addChild(self.m_pCardTypeView)

        self.m_pViewTypeMaxCol = math.floor(RedVsBlackDataManager.getInstance():getTmpHistoryListSize() / 2) + RedVsBlackDataManager.getInstance():getTmpHistoryListSize() % 2

        local cellSizeForTable = function (table, idx)
            return 81, 70
        end

        -- 必须设置一个最小可显示值 否则显示的数据不能左对齐
        local numberOfCellsInTableView = function (table)
            return self.m_pViewTypeMaxCol > 10 and self.m_pViewTypeMaxCol or 10
        end

        local tableCellAtIndex = function (table, idx)
            local cell = table:dequeueCell();
            if not cell then
                cell = cc.TableViewCell:new()
            else
                cell:removeAllChildren()
            end

            for i = 1, 2 do
                local recordID = idx * 2 + i
                local tmp = RedVsBlackDataManager.getInstance():getTmpHistoryByIdx(recordID)
                if nil == tmp then break end
                local texturepath = ""
                if 1 == tmp.bCardType then
                    texturepath = RedVsBlackRes.IMG_TYPE_SINGLE
                else
                    texturepath = RedVsBlackRes.IMG_TYPE_NOSINGLE
                end
                local sp = cc.Sprite:createWithSpriteFrameName(texturepath)
                local typeStr = RedVsBlackDataManager.getInstance():getCardTypeDesc(tmp.bCardType)
                local label = cc.LabelTTF:create(typeStr, "Arial", 24)
                label:setAnchorPoint(0.5, 0.5)
                label:setPosition(cc.p(39.5, 16))
                label:addTo(sp)

                if recordID == RedVsBlackDataManager.getInstance():getTmpHistoryListSize() then -- 最后一个需显示"N"图标
                    cc.Sprite:createWithSpriteFrameName(RedVsBlackRes.IMG_ICON_NEW)
                    :setAnchorPoint(0.5, 0.5)
                    :setPosition(69, 22)
                    :addTo(sp)
                end

                sp:setPosition(0, 71 - i*35)
                sp:setAnchorPoint(0, 0)
                sp:addTo(cell, G_CONSTANTS.Z_ORDER_STATIC)
            end

            return cell
        end

        self.m_pCardTypeView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_pCardTypeView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
        self.m_pCardTypeView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    end
    self.m_pCardTypeView:reloadData()
    -- 初始状态显示到最后一条 超过20条 滚动到最后一个
    if isFirst then
        if RedVsBlackDataManager.getInstance():getTmpHistoryListSize() > 20 then
            self.m_pCardTypeView:setContentOffset(
                cc.p(self.m_pCardTypeView:getViewSize().width - self.m_pCardTypeView:getContentSize().width, 0)
            )
--        else
--            self.m_pCardTypeView:setContentOffset(cc.p(0,0))
        end
    end
end

function RedVsBlackTrendLayer:refreshCardTypeView()
    -- 在滑动浏览tableview时候 进行reloaddata 会有几率崩溃
    -- 原因是 ui界面正在刷新时 tableview内部更改了数据源 导致数据读取错误
    local historySize = RedVsBlackDataManager.getInstance():getTmpHistoryListSize()
    self.m_pViewTypeMaxCol = math.floor( historySize / 2) + historySize % 2
    --local posold = self.m_pCardTypeView:getContentOffset()
    self.m_pCardTypeView:reloadData()
    --self.m_pCardTypeView:setContentOffset(posold)
    
    -- 修改新结果来了之后 自动移位到最后一列
    self.m_pCardTypeView:setContentOffset(
        cc.p(self.m_pCardTypeView:getViewSize().width - self.m_pCardTypeView:getContentSize().width, 0))
end
--endregion

--region 大路滑动列表
function RedVsBlackTrendLayer:initDaluTableView(isFirst)
	if not self.m_pDaluTypeView then
        self.m_pCardDaluView = cc.TableView:create(cc.size(783, 235))
--        self.m_pCardDaluView:setIgnoreAnchorPointForPosition(false)
        self.m_pCardDaluView:setAnchorPoint(cc.p(0,0))
        self.m_pCardDaluView:setPosition(cc.p(0,5))
        self.m_pCardDaluView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        self.m_pCardDaluView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pCardDaluView:setTouchEnabled(true)
        self.m_pCardDaluView:setDelegate()
        self.Panel_dalu:addChild(self.m_pCardDaluView)

        self.m_pViewIconMaxCol = RedVsBlackDataManager.getInstance():getPaiLuVecSize()

        local cellSizeForTable = function (table, idx)
            return 39, 238
        end

        local numberOfCellsInTableView = function (table)
            return self.m_pViewIconMaxCol > 20 and self.m_pViewIconMaxCol or 20
        end

        local tableCellAtIndex = function (table, idx)
            local cell = table:dequeueCell();
            if not cell then
                cell = cc.TableViewCell:new()
            else
                cell:removeAllChildren()
            end

            for i = 1, 6 do
                local pailuVal = RedVsBlackDataManager.getInstance():getPaiLuVal(idx+1, i)
                local bgpath = RedVsBlackRes.IMG_DALUBG
                local sp = cc.Sprite:createWithSpriteFrameName(bgpath)
                if 0 < pailuVal then
                    local ringicon = cc.Sprite:createWithSpriteFrameName(ringIconPath[pailuVal])
                    ringicon:setPosition(20, 19)
                    ringicon:setAnchorPoint(0.5, 0.5)
                    ringicon:addTo(sp)
                    if RedVsBlackDataManager.getInstance():isLastItem(idx+1, i) then
                        ringicon:runAction(cc.Blink:create(5, 5))
                    end
                end
                sp:setPosition(0, 235 - i*39)
                sp:setAnchorPoint(0, 0)
                sp:addTo(cell, G_CONSTANTS.Z_ORDER_STATIC)
            end
            return cell
        end

        self.m_pCardDaluView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_pCardDaluView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
        self.m_pCardDaluView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    end
    self.m_pCardDaluView:reloadData()

    if isFirst and RedVsBlackDataManager.getInstance():getPaiLuVecSize() > 20 then
        self.m_pCardDaluView:setContentOffset(
            cc.p(self.m_pCardDaluView:getViewSize().width - self.m_pCardDaluView:getContentSize().width, 0))
    end
end

function RedVsBlackTrendLayer:refreshDaluView()
    RedVsBlackDataManager.getInstance():resetPaiLuVec()
    self.m_pViewIconMaxCol = RedVsBlackDataManager.getInstance():getPaiLuVecSize()
    --local posold = self.m_pCardDaluView:getContentOffset()
    self.m_pCardDaluView:reloadData()
    --self.m_pCardDaluView:setContentOffset(posold)
    self.m_pCardDaluView:setContentOffset(
        cc.p(self.m_pCardDaluView:getViewSize().width - self.m_pCardDaluView:getContentSize().width, 0))
end

--endregion

--region 显示最新20局胜负小图标
function RedVsBlackTrendLayer:viewIconList()
    self.iconPanel:removeAllChildren()
    local iconPath = { RedVsBlackRes.IMG_POINT_RED, RedVsBlackRes.IMG_POINT_BLACK }

    local siz = RedVsBlackDataManager.getInstance():getTmpHistoryListSize()
    -- 红黑胜负icon显示
    for i = 1, 20 do
        local tmp = RedVsBlackDataManager.getInstance():getTmpHistoryByAscIdx(i)
        if nil == tmp then break end
        local sp = cc.Sprite:createWithSpriteFrameName(iconPath[tmp.bWin + 1])
        -- 单个icon占位46 边距11
        sp:setPosition(897 - (i-1) * 46, 24)
        sp:addTo(self.iconPanel)
    end
end
--endregion

--region 显示最近20局胜负百分比,红方直接用的1像素资源进行拉伸(用grogress的方式做背景图比较麻烦)
function RedVsBlackTrendLayer:viewPercentProgress()
    local redwinnum = 0
    local curNum = 0
    for i = 1, 20 do
        local tmp = RedVsBlackDataManager.getInstance():getTmpHistoryByAscIdx(i)
        if nil == tmp then break end
        curNum = curNum + 1
        if 0 == tmp.bWin then redwinnum = redwinnum + 1 end
    end

    if curNum > 0 then
        local curPer = math.modf( redwinnum * 100 / curNum)
        local perStep = 9.16 -- (920 - 4) / 100
        local scaleval = perStep * curPer
        local Img_pred = self.progressPanel:getChildByName("Img_pred")
        Img_pred:setVisible(true)
        local sz = Img_pred:getContentSize()
        Img_pred:setContentSize(scaleval, sz.height)
        self.redperLabel:setString( curPer .. "%" )
        self.blackperLabel:setString((100 - curPer) .. "%")
    else
        self.redperLabel:setString("0%")
        self.blackperLabel:setString("0%")
    end
end
--endregion

--region 事件回调
function RedVsBlackTrendLayer:Handle_Custom_Ack(_event)
    local _userdata = unpack(_event._userdata)
    if not _userdata then
        return
    end
    local eventID = _userdata.name
    local msg = _userdata.packet

    if eventID == RedVsBlackEvent.MSG_REDVSBLACK_UPDATE_HISTORY_INFO then
        self:onMsgUpdateTrendView()
    end
end

function RedVsBlackTrendLayer:onMsgUpdateTrendView()
    RedVsBlackDataManager.getInstance():synTmpHistory()
    self:viewIconList()
    self:viewPercentProgress()
    self:refreshCardTypeView()
    self:refreshDaluView()
end

function RedVsBlackTrendLayer:onReturnClicked()
--    AudioManager.getInstance():playSound(RedVsBlackRes.SOUND_OF_CLOSE)
    onCloseLayer(self.m_pathUI:getChildByName("Panel_bg"), self.m_pathUI:getChildByName("Panel_1"), self)
--    self:setVisible(false)
--    self:removeFromParent()
end
--endregion

--region 测试路数显示代码
--function RedVsBlackTrendLayer:addtestdalurecord()
--    local redmsg = {bWin = 0, bCardType = 1}
--    local blackmsg = {bWin = 1, bCardType = 3}

--    local insertRedWin = function (num)
--        for i = 1, num do
--            RedVsBlackDataManager.getInstance():addHistoryToList(redmsg)
--        end
--    end

--    local insertBlackWin = function (num)
--        for i = 1, num do
--            RedVsBlackDataManager.getInstance():addHistoryToList(blackmsg)
--        end
--    end

--    RedVsBlackDataManager.getInstance():clearHistory()
--    insertRedWin(11)
--    insertBlackWin(10)
--    insertRedWin(10)
--    insertBlackWin(10)
--    insertRedWin(7)
--    insertBlackWin(8)
--    insertRedWin(11)
--    insertBlackWin(10)
--    insertRedWin(10)
--    insertBlackWin(10)
--end
--endregion

return RedVsBlackTrendLayer