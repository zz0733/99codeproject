--region TreatyView.lua
--Date 2017.04.26.
--Auther JackyXu.
--Desc: 游戏申明协议 view

local TreatyView = class("TreatyView",FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .."ExternalFun")

local G_TreatyView = nil
function TreatyView.create()
    G_TreatyView = TreatyView.new():init()
    return G_TreatyView
end

function TreatyView:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_pNodeTable = nil
    self.m_pTitle = nil
    self.m_pTableView = nil
    self.m_nTableHeight = 3559

    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)

    -- 拦截触摸事件向下传递
    --local touchListener = cc.EventListenerTouchOneByOne:create()
    --touchListener:registerScriptHandler(function(touch, event)
    --    -- body
    --    event:stopPropagation()
    --    return true
    --end, cc.Handler.EVENT_TOUCH_BEGAN)
    --local eventDispatcher = self.m_rootUI:getEventDispatcher()
    --eventDispatcher:addEventListenerWithSceneGraphPriority(touchListener, self.m_rootUI)

end

function TreatyView:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)
    self:setVeilAlpha(0)
    --init csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/TreatyDialog.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("TreatyDialog")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pImgBg     = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pNodeTable = self.m_pImgBg:getChildByName("node_table")
    self.m_pBtnClose  = self.m_pImgBg:getChildByName("BTN_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))

    return self
end

function TreatyView:onEnter()
    self.super:onEnter()
    self:showWithStyle()

    self:initTableView()
    self:createSlider()
end

function TreatyView:onExit()
    self.super:onExit()

    G_TreatyView = nil
end


function TreatyView:cellSizeForTable(table, idx)
    return self.m_pNodeTable:getContentSize().width, self.m_nTableHeight
end

function TreatyView:tableCellAtIndex(table, idx)
    local cell = table:cellAtIndex(idx)
    if not cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end

    self:initTableViewCell(cell, idx)

    return cell
end

function TreatyView:numberOfCellsInTableView(table)
    return 1
end

function TreatyView:tableCellTouched(table, cell)
end

function TreatyView:initTableViewCell(cell, nIdx)
    local sp = cc.Sprite:create("hall/image/file/treatyText.png")
    sp:setAnchorPoint(cc.p(0,1))
    sp:setPosition(cc.p(0,sp:getContentSize().height))
    cell:addChild(sp)
end

function TreatyView:scrollViewDidScroll(pView)
    local slider = tolua.cast(self.m_pNodeTable:getChildByTag(100), "cc.ControlSlider")
    if not slider then
        return
    end
    
    local max = self.m_nTableHeight - 350
    slider:setValue((pView:getContentOffset().y + max))
end

function TreatyView:initTableView()
    self.m_pTableView = cc.TableView:create(self.m_pNodeTable:getContentSize())
    self.m_pTableView:setAnchorPoint(cc.p(0,0))
    self.m_pTableView:setIgnoreAnchorPointForPosition(false)
    -- //self.m_pTableView:setPosition(cc.p(-25,-25))
    self.m_pTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.m_pTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.m_pTableView:setDelegate()
    self.m_pTableView:registerScriptHandler(handler(self,self.scrollViewDidScroll), CCTableView.kTableViewScroll)
    self.m_pTableView:registerScriptHandler(handler(self,self.cellSizeForTable), CCTableView.kTableCellSizeForIndex)
    self.m_pTableView:registerScriptHandler(handler(self,self.tableCellAtIndex), CCTableView.kTableCellSizeAtIndex)
    self.m_pTableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView), CCTableView.kNumberOfCellsInTableView)
    self.m_pTableView:registerScriptHandler(handler(self,self.tableCellTouched), CCTableView.kTableCellTouched)
    self.m_pTableView:reloadData()
    self.m_pNodeTable:addChild(self.m_pTableView)
end

function TreatyView:createSlider()
    local spBg = cc.Sprite:createWithSpriteFrameName("gui-dialog-huadongt-xian.png")
    -- //添加一个滑动条的背景
    local spBg0 = cc.Sprite:createWithSpriteFrameName("gui-dialog-huadongt-xian.png")
    spBg0:setAnchorPoint(cc.p(0, 0))
    spBg0:setScaleX(1.14)
    spBg0:setPosition(cc.p(-27,0))
    spBg:addChild(spBg0, 20) --Z_ORDER_STATIC)
    
    local pgSp = cc.Sprite:createWithSpriteFrameName("gui-dialog-null.png")
    local spTub = cc.Sprite:createWithSpriteFrameName("gui-dialog-huadongt-button.png")
    local spTub1 = cc.Sprite:createWithSpriteFrameName("gui-dialog-huadongt-button.png")

    local slider = cc.ControlSlider:create(spBg, pgSp, spTub, spTub1)
    if not slider then
        return false
    end
    
    slider:setAnchorPoint(cc.p(0.5, 0.5))
    slider:setMinimumValue(0)
    local max = self.m_nTableHeight - 350
    local maxVaule = (max > 0 and max or 0)
    slider:setMaximumValue(maxVaule)
    slider:setPosition(cc.p(self.m_pNodeTable:getContentSize().width + 20 , self.m_pNodeTable:getContentSize().height / 2))
    slider:setRotation(90)
    slider:setValue(slider:getMinimumValue())
    slider:setTag(100)
    slider:setScaleX(0.9)
    slider:setEnabled(false)
    self.m_pNodeTable:addChild(slider, 50) -- Z_ORDER_COMMON)
end

-- 返回
function TreatyView:onReturnClicked(pSender)
    ExternalFun.playClickEffect()

    self:onMoveExitView()
end

return TreatyView
