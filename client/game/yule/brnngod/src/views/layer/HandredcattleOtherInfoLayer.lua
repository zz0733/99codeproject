--region HandredcattleOtherInfoLayer.lua
--Date 2018/03/16
--百人牛牛其他玩家信息界面
--endregion
local ExternalFun                   = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local HeadSprite                    = require(appdf.EXTERNAL_SRC .. "HeadSprite")
local HandredcattleOtherInfoLayer   = class("HandredcattleTrendLayer", cc.Layer)
--local Handredcattle_Events        = require("game.handredcattle.scene.HandredcattleEvent")
local module_pre                    = "game.yule.brnngod.src"
local HandredcattleRes              = appdf.req(module_pre .. ".views.layer.handClasses.HandredcattleRes")

function HandredcattleOtherInfoLayer.create(playerTab_)
    local playerInfo = playerTab_
    HandredcattleOtherInfoLayer.instance_ = HandredcattleOtherInfoLayer.new(playerInfo)
    return HandredcattleOtherInfoLayer.instance_
end

function HandredcattleOtherInfoLayer:ctor(playerTab__)
    self.playerInfoTable = playerTab__
    self:enableNodeEvents()
    self:init()
end

function HandredcattleOtherInfoLayer:init()
    self:initVar()
    self:initCSB()
    self:initView()

    return self
end 

function HandredcattleOtherInfoLayer:onEnter()
end

function HandredcattleOtherInfoLayer:onExit()
end

function HandredcattleOtherInfoLayer:initVar()
    self.m_vecOtherInfo = {}
    --按金币大小排序
    local tab = self.playerInfoTable
    table.sort(tab, function(a,b)
        local ascore = a[6]
        local bscore = b[6]
        return ascore > bscore
    end)
    self.m_vecOtherInfo = tab
end

function HandredcattleOtherInfoLayer:initCSB()
    self.m_rootUI       = display.newNode()
    self.m_rootUI:addTo(self)
    self.m_pathUI       = cc.CSLoader:createNode(HandredcattleRes.CSB_GAME_USERINFO)
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

function HandredcattleOtherInfoLayer:initView()
    self:initTableView()
    self:initSlider()
    if #self.m_vecOtherInfo < 5 then
        local slider = tolua.cast(self.m_rootNode:getChildByTag(100), "cc.ControlSlider")
        if slider then slider:setVisible(false) end
    end
end

function HandredcattleOtherInfoLayer:initSlider()
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
    slider:setPosition(cc.p(446 , 371))
    slider:setRotation(90)
    slider:setValue(12)
    slider:setTag(100)
    slider:setScaleX(1.26)
    slider:setEnabled(false)
    self.m_rootNode:addChild(slider, 50)
end

function HandredcattleOtherInfoLayer:onReturnClicked()
    ExternalFun.playSoundEffect(HandredcattleRes.SOUND_OF_CLOSE)
    self:removeFromParent()
end

function HandredcattleOtherInfoLayer:initTableView()
     if self.m_pTableView == nil then
        self.m_pTableView = cc.TableView:create(cc.size(335,438))
        self.m_pTableView:setAnchorPoint(cc.p(0,0))
        self.m_pTableView:setPosition(cc.p(120,152))
        self.m_pTableView:setTouchEnabled(true)
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

function HandredcattleOtherInfoLayer:initTableViewCell(cell, idx)
    print("______________"..idx)
    local userinfo = self.m_vecOtherInfo[idx+1]
    if not userinfo then return end
    local node = cc.CSLoader:createNode(HandredcattleRes.CSB_GAME_USERINFO_NODE)
    node:setPosition(cc.p(5,0))
    cell:addChild(node)

    local name = node:getChildByName("Text_name")
    local strNick = self.playerInfoTable[idx+1][2]
    name:setString(strNick)

    local gold = node:getChildByName("Text_gold")
    gold:setString(self.playerInfoTable[idx+1][6])

    local wFaceID = userinfo.wFaceID or 0
--    local strHeadIcon = string.format("hall/image/file/gui-icon-head-%02d.png", wFaceID % G_CONSTANTS.FACE_NUM + 1)
    local icon = node:getChildByName("Image_icon")
    self.playerInfoTable[idx+1]["avatar_no"] = self.playerInfoTable[idx+1][3]
    local head = HeadSprite:createClipHead(self.playerInfoTable[idx+1], 100)
    head:setAnchorPoint(cc.p(0,0))
    head:setPosition(cc.p(-10,-10))
--    head:setScale(icon:getContentSize().width/head:getContentSize().width)
    icon:addChild(head)--loadTexture(strHeadIcon,ccui.TextureResType.localType)
end

function HandredcattleOtherInfoLayer:cellSizeForTable(table, idx)
    return 320,107
end

function HandredcattleOtherInfoLayer:tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    if not cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end
    self:initTableViewCell(cell, idx)
    return cell
end

function HandredcattleOtherInfoLayer:numberOfCellsInTableView(table)
    return #self.m_vecOtherInfo
end

function HandredcattleOtherInfoLayer:tableCellTouched(table, cell)
end

function HandredcattleOtherInfoLayer:scrollViewDidScroll(pView)
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

return HandredcattleOtherInfoLayer
