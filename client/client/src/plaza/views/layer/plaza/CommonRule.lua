--region *.lua
--Date
--
--endregion
local CommonRule = class("CommonRule", FixLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

function CommonRule:ctor(scene, kindID)
    self._scene = scene
    self.super:ctor(self)
    self:enableNodeEvents()
    self:init()
    self:initRule(kindID)
end

function CommonRule:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)

    --root
    self.m_rootUI = display.newNode()
    self.m_rootUI:setCascadeOpacityEnabled(true)
    self.m_rootUI:addTo(self)
    
    --csb
    self.m_pathUI = cc.CSLoader:createNode("hall/csb/CommonRule.csb")
    self.m_pathUI:addTo(self.m_rootUI)

    --offset X
    self.m_pNodeRoot    = self.m_pathUI:getChildByName("CommonRule")
    local diffX = 145 - (1624 - display.size.width) / 2
    self.m_pNodeRoot:setPositionX(diffX)

    --offset Y
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    --界面
    self.m_pBtnClose2 = self.m_pNodeRoot:getChildByName("Button_close_0")
    self.m_pImgBg    = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pBtnClose = self.m_pImgBg:getChildByName("Button_close")
    self.m_pNodeRule = self.m_pImgBg:getChildByName("Node_rule")
    self.m_pLbTips   = self.m_pImgBg:getChildByName("Text_tips")
    
    --按钮回调
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    self.m_pBtnClose2:addClickEventListener(handler(self, self.onCloseClicked))
end

function CommonRule:onEnter()
    self.super:onEnter()
    self:showWithStyle()
end

function CommonRule:onExit()
    self.super:onExit()
end

function CommonRule:onCloseClicked()
   ExternalFun.playClickEffect()
    
    self:onMoveExitView()
end

function CommonRule:initRule(nKindID)

    local kindID = nKindID
    local enterGameInfo = self._scene:getEnterGameInfo()
    local modulestr = string.gsub(enterGameInfo._KindName, "%.", "/")

    local path = device.writablePath.."game/" .. modulestr .. "/res/gui/rule.png"
    local size = self.m_pNodeRule:getContentSize()
    local spRule = display.newSprite(path)
    local spSize = spRule:getContentSize()
    local currSize = cc.size(size.width, 0)

    if spSize.height > size.height then
        currSize.height = spSize.height
    else
        currSize.height = size.height
    end

    local function initTableViewCell(cell, idx)
        local spRule = display.newSprite(path)
        spRule:setAnchorPoint(cc.p(0.0, 1.0))
        spRule:setPosition(cc.p(0, currSize.height))
        spRule:addTo(cell)
    end
    local function tableCellTouched(table, cell)
    end
    local function tableCellAtIndex(table, idx)
        local cell = table:cellAtIndex(idx)
        if not cell then
            cell = cc.TableViewCell:new()
        else
            cell:removeAllChildren()
        end
        initTableViewCell(cell, idx)
        return cell
    end
    local function cellSizeForTable(table, idx)
        return currSize.width, currSize.height
    end
    local function numberOfCellsInTableView(table)
        return 1
    end
    
    if not self.m_pTableRule then
        self.m_pTableRule = cc.TableView:create(size)
        self.m_pTableRule:setAnchorPoint(cc.p(0,0))
        self.m_pTableRule:setPosition(cc.p(0, 0))
        self.m_pTableRule:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        self.m_pTableRule:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pTableRule:setTouchEnabled(true)
        self.m_pTableRule:setDelegate()
        self.m_pTableRule:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
        self.m_pTableRule:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
        self.m_pTableRule:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
        self.m_pTableRule:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        self.m_pTableRule:addTo(self.m_pNodeRule)
    end
    self.m_pTableRule:reloadData()
end

return CommonRule
