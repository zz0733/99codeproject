--region *.lua
--Date
--
--endregion

--local RedVsBlackRuleLayer = class("RedVsBlackRuleLayer", cc.Node)
local RedVsBlackRuleLayer = class("RedVsBlackRuleLayer", cc.Layer)

function RedVsBlackRuleLayer.create()
    return RedVsBlackRuleLayer:new()
end

function RedVsBlackRuleLayer:ctor()
    self:enableNodeEvents()

    self.isBottom = false
    self.perPageMaxHeight = 310
    self.m_nSelectedType = 1
    self.m_nShowContentPageNum = 1
    self.m_nShowContentCurPage = 1
    self.m_nCurContentHeight = 0

    self:init()
end

function RedVsBlackRuleLayer:init()

    self.m_pathUI = cc.CSLoader:createNode("game/redvsblack/Layer/RedVsBlackRuleLayer.csb")
    self.m_pathUI:addTo(self)
    self.btn_mask = self.m_pathUI:getChildByName("btn_mask")
    self.m_pPanel_scroll = self.m_pathUI:getChildByName("Panel_scroll")
    self.m_pBtnClose = self.m_pathUI:getChildByName("Btn_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))
    self.btn_mask:addClickEventListener(handler(self, self.onReturnClicked))
    self:initView()
end 

function RedVsBlackRuleLayer:onEnter()
end

function RedVsBlackRuleLayer:onExit()
end

function RedVsBlackRuleLayer:onReturnClicked()
--    AudioManager.getInstance():playSound("game/redvsblack/sound/sound-close.mp3")
    self:removeFromParent()
end

function RedVsBlackRuleLayer:initView()
--    self.m_pCardTypeView = cc.TableView:create(cc.size(840, 628))
----    self.m_pCardTypeView:setIgnoreAnchorPointForPosition(false)
--    self.m_pCardTypeView:setAnchorPoint(cc.p(0,1))
--    self.m_pCardTypeView:setPosition(cc.p(0, 628))
--    self.m_pCardTypeView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
--    self.m_pCardTypeView:setVerticalFillOrder(cc.TABLEVIEW_FILL_BOTTOMUP)
--    self.m_pCardTypeView:setTouchEnabled(true)
--    self.m_pCardTypeView:setDelegate()
--    self.m_pPanel_scroll:addChild(self.m_pCardTypeView)

--    local cellSizeForTable = function (table, idx)
--        if 1 == idx then
--            return 827, 104
--        else
--            return 827, 783 -- µ×²¿50Áô°×
--        end
--    end

--    local numberOfCellsInTableView = function (table)
--        return 2
--    end

--    local tableCellAtIndex = function (table, idx)
--        local cell = table:dequeueCell();
--        if not cell then
--            cell = cc.TableViewCell:new()
--        else
--            cell:removeAllChildren()
--        end

--        local sp = nil
--        if 1 == idx then
--            sp = cc.Sprite:createWithSpriteFrameName("gui-redblack-rule-recommend.png")
--            sp:setPosition(35, 71)
--        else
--            sp = cc.Sprite:create("game/redvsblack/imges/gui-redblack-rule-rules.png")
--            sp:setPosition(33, 750)
--        end
--        sp:setAnchorPoint(0, 1)
--        sp:addTo(cell, G_CONSTANTS.Z_ORDER_STATIC)

--        return cell
--    end

--    self.m_pCardTypeView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
--    self.m_pCardTypeView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
--    self.m_pCardTypeView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
--    self.m_pCardTypeView:reloadData()
end 

return RedVsBlackRuleLayer