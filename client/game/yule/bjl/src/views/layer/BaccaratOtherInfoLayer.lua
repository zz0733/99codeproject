--region BaccaratOtherInfoLayer.lua
--Date 2018/03/16
--百人牛牛其他玩家信息界面
--endregion
local module_pre = "game.yule.bjl.src"
local BaccaratOtherInfoLayer   = class("BaccaratOtherInfoLayer", cc.Layer)
local BaccaratDataMgr          = appdf.req(module_pre .. ".game.baccarat.manager.BaccaratDataMgr")
local BaccaratRes              = appdf.req(module_pre .. ".game.baccarat.scene.BaccaratRes")
local BaccaratEvent            = appdf.req(module_pre .. ".game.baccarat.scene.BaccaratEvent")
local HeadSprite               = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
function BaccaratOtherInfoLayer.create()
    BaccaratOtherInfoLayer.instance_ = BaccaratOtherInfoLayer.new()
    return BaccaratOtherInfoLayer.instance_
end

function BaccaratOtherInfoLayer:ctor()
    self:enableNodeEvents()
    self:init()
end

function BaccaratOtherInfoLayer:init()
    self:initVar()
    self:initCSB()
    self:initView()
end 

function BaccaratOtherInfoLayer:onEnter()
end

function BaccaratOtherInfoLayer:onExit()
end

function BaccaratOtherInfoLayer:initVar()
    self.m_vecOtherInfo = {}
    --按金币大小排序
    self.m_vecOtherInfo = BaccaratDataMgr.getInstance():getMembers()
end

function BaccaratOtherInfoLayer:initCSB()
    self.m_rootUI       = display.newNode()
    self.m_rootUI:addTo(self)
    self.m_pathUI       = cc.CSLoader:createNode(BaccaratRes.CSB_GAME_USERINFO)
    self.m_pathUI:addTo(self.m_rootUI)
    self.m_rootNode     = self.m_pathUI:getChildByName("Panel_1")
    self.m_pBtnClose    = self.m_pathUI:getChildByName("BTN_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))

    if display.size.width == 1624 then
        self.m_rootNode:setPosition(cc.p(-75,0))
    else
        self.m_rootNode:setPosition(cc.p(0,0))
    end
end

function BaccaratOtherInfoLayer:initView()
    self:initTableView()
    self:initSlider()
    if #self.m_vecOtherInfo < 5 then
        local slider = tolua.cast(self.m_rootNode:getChildByTag(100), "cc.ControlSlider")
        if slider then slider:setVisible(false) end
    end
end

function BaccaratOtherInfoLayer:initSlider()
    local spBg = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_SCROLL_BG)
    -- //添加一个滑动条的背景
    local spBg0 = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_SCROLL_BG)
    spBg0:setAnchorPoint(cc.p(0, 0))
    spBg:addChild(spBg0, 20)
    
    local pgSp = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_NULL)
    pgSp:setOpacity(0)
    local spTub = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_SCROLL_BUTTON)
    local spTub1 = cc.Sprite:createWithSpriteFrameName(BaccaratRes.IMG_SCROLL_BUTTON)
    local slider = cc.ControlSlider:create(spBg, pgSp, spTub, spTub1)
    if not slider then
        return false
    end
    
    slider:setAnchorPoint(cc.p(0.5, 0.5))
    slider:setMinimumValue(0)
    slider:setMaximumValue(130)
    slider:setPosition(cc.p(446 , 371))
    slider:setRotation(90)
    slider:setValue(12)
    slider:setTag(100)
    slider:setScaleX(1.26)
    slider:setEnabled(false)
    self.m_rootNode:addChild(slider, 50)
end

function BaccaratOtherInfoLayer:onReturnClicked()
--    AudioManager.getInstance():playSound(BaccaratRes.SOUND_OF_CLOSE)
    self:removeFromParent()
end

function BaccaratOtherInfoLayer:initTableView()
     if self.m_pTableView == nil then
        self.m_pTableView = cc.TableView:create(cc.size(335,438))
        self.m_pTableView:setAnchorPoint(cc.p(0,0))
        self.m_pTableView:setPosition(cc.p(120,152))
--        self.m_pTableView:setIgnoreAnchorPointForPosition(false)
        self.m_pTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.m_pTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        self.m_pTableView:setDelegate()
        self.m_pTableView:registerScriptHandler(handler(self,self.scrollViewDidScroll), CCTableView.kTableViewScroll)
        self.m_pTableView:registerScriptHandler(handler(self,self.cellSizeForTable), CCTableView.kTableCellSizeForIndex)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellAtIndex), CCTableView.kTableCellSizeAtIndex)
        self.m_pTableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView), CCTableView.kNumberOfCellsInTableView)
        self.m_pTableView:registerScriptHandler(handler(self,self.tableCellTouched), CCTableView.kTableCellTouched)
        self.m_pTableView:reloadData()
        self.m_rootNode:addChild(self.m_pTableView)
    else
        self.m_pTableView:reloadData()
    end
end

function BaccaratOtherInfoLayer:initTableViewCell(cell, idx)
    local userinfo = self.m_vecOtherInfo[idx+1]
    if not userinfo then return end
    local node = cc.CSLoader:createNode(BaccaratRes.CSB_GAME_USERINFO_NODE)
    node:setPosition(cc.p(5,0))
    cell:addChild(node)

    local name = node:getChildByName("Text_name")
    local strName = self.m_vecOtherInfo[idx+1][2]
    name:setString(strName)

    local gold = node:getChildByName("Text_gold")
    gold:setString(self.m_vecOtherInfo[idx+1][6])

    local pImgAvatar = node:getChildByName("Image_icon")
    local head = HeadSprite:createClipHead({userid = self.m_vecOtherInfo[idx+1][1], nickname = self.m_vecOtherInfo[idx+1][2], avatar_no = self.m_vecOtherInfo[idx+1][3]},75)
    head:setAnchorPoint(cc.p(0.5,0.5))
    pImgAvatar:addChild(head)
end

function BaccaratOtherInfoLayer:cellSizeForTable(table, idx)
    return 320,107
end

function BaccaratOtherInfoLayer:tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    if not cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end
    self:initTableViewCell(cell, idx)
    return cell
end

function BaccaratOtherInfoLayer:numberOfCellsInTableView(table)
    return #self.m_vecOtherInfo
end

function BaccaratOtherInfoLayer:tableCellTouched(table, cell)
end

function BaccaratOtherInfoLayer:scrollViewDidScroll(pView)
    local slider = tolua.cast(self.m_rootNode:getChildByTag(100), "cc.ControlSlider")
    if not slider then
        return
    end
    local max = (#self.m_vecOtherInfo) * 107 - 438
    local value = 106 + (math.floor(pView:getContentOffset().y * 106 / max) + 12)
    value = value < 12 and 12 or value
    value = value > 118 and 118 or value
    slider:setValue(value)
end

return BaccaratOtherInfoLayer
