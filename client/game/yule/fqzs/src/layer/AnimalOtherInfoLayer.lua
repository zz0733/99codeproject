--region AnimalOtherInfoLayer.lua
--Date 2018/04/04
--飞禽走兽其他玩家信息界面
--endregion
local module_pre = "game.yule.fqzs.src"
local AnimalOtherInfoLayer   = class("AnimalOtherInfoLayer", cc.Layer)
local CBetManager            = appdf.req(module_pre .. ".manager.CBetManager")
local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")
function AnimalOtherInfoLayer.create()
    AnimalOtherInfoLayer.instance_ = AnimalOtherInfoLayer.new():init()
    return AnimalOtherInfoLayer.instance_
end

function AnimalOtherInfoLayer:ctor()
    self:enableNodeEvents()
end

function AnimalOtherInfoLayer:init()
    self:initVar()
    self:initCSB()
    self:initView()

    return self
end 

function AnimalOtherInfoLayer:onEnter()
end

function AnimalOtherInfoLayer:onExit()
end

function AnimalOtherInfoLayer:initVar()
    self.m_vecOtherInfo = {}
    --按金币大小排序
    local tab = CBetManager.getInstance():getUserInfoList()

    self.m_vecOtherInfo = tab
end

function AnimalOtherInfoLayer:initCSB()
    self.m_rootUI       = display.newNode()
    self.m_rootUI:addTo(self)
    self.m_pathUI       = cc.CSLoader:createNode("game/animals/OtherInfoLayer.csb")
    self.m_pathUI:addTo(self.m_rootUI)
    self.m_rootNode     = self.m_pathUI:getChildByName("Panel_1")
    self.m_pBtnClose    = self.m_pathUI:getChildByName("BTN_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))

    if display.size.width == 1624 then
        self.m_rootNode:setPosition(cc.p(40,40))
    else
        self.m_rootNode:setPosition(cc.p(145,40))
    end
end

function AnimalOtherInfoLayer:initView()
    self:initTableView()
    self:initSlider()
    if #self.m_vecOtherInfo < 5 then
        local slider = tolua.cast(self.m_rootNode:getChildByTag(100), "cc.ControlSlider")
        if slider then slider:setVisible(false) end
    end
end


function AnimalOtherInfoLayer:initSlider()
    local spBg = cc.Sprite:createWithSpriteFrameName(self:getRealFrameName("gui-niuniu-scroll-bg.png"))
    -- //添加一个滑动条的背景
    local spBg0 = cc.Sprite:createWithSpriteFrameName(self:getRealFrameName("gui-niuniu-scroll-bg.png"))
    spBg0:setAnchorPoint(cc.p(0, 0))
    spBg:addChild(spBg0, 20)
    
    local pgSp = cc.Sprite:createWithSpriteFrameName(self:getRealFrameName("gui-texture-null.png"))
    pgSp:setOpacity(0)
    local spTub = cc.Sprite:createWithSpriteFrameName(self:getRealFrameName("gui-niuniu-scroll-icon.png"))
    local spTub1 = cc.Sprite:createWithSpriteFrameName(self:getRealFrameName("gui-niuniu-scroll-icon.png"))
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

function AnimalOtherInfoLayer:onReturnClicked()
--    AudioManager.getInstance():playSound("game/animals/sound/sound-close.mp3")
    self:removeFromParent()
end

function AnimalOtherInfoLayer:initTableView()
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

function AnimalOtherInfoLayer:initTableViewCell(cell, idx)
    local userinfo = self.m_vecOtherInfo[idx+1]
    if not userinfo then return end
    local node = cc.CSLoader:createNode("game/animals/OtherInfoItem.csb")
    node:setPosition(cc.p(5,0))
    cell:addChild(node)
    
    local name = node:getChildByName("Text_name")
    local strName = LuaUtils.getDisplayNickNameInGame(userinfo[2])
    name:setString(strName)

    local gold = node:getChildByName("Text_gold")
    gold:setString(userinfo[6] or "0")

--    local wFaceID = userinfo.wFaceID or 0
--    local strHeadIcon = string.format("hall/image/file/gui-icon-head-%02d.png", wFaceID % G_CONSTANTS.FACE_NUM + 1)
    local icon = node:getChildByName("Image_icon")
    local head = HeadSprite:createClipHead({userid = self.m_vecOtherInfo[idx+1][1], nickname = self.m_vecOtherInfo[idx+1][2], avatar_no = self.m_vecOtherInfo[idx+1][3]},75)
    head:setAnchorPoint(cc.p(0,0))
    icon:addChild(head)
--    icon:loadTexture(strHeadIcon,ccui.TextureResType.localType)
end

function AnimalOtherInfoLayer:cellSizeForTable(table, idx)
    return 320,107
end

function AnimalOtherInfoLayer:tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    if not cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end
    self:initTableViewCell(cell, idx)
    return cell
end

function AnimalOtherInfoLayer:numberOfCellsInTableView(table)
    return #self.m_vecOtherInfo
end

function AnimalOtherInfoLayer:tableCellTouched(table, cell)
end

function AnimalOtherInfoLayer:scrollViewDidScroll(pView)
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

function AnimalOtherInfoLayer:getRealFrameName( name )
    local realName = string.format( "game/animals/gui/%s", name)
    return realName
end

return AnimalOtherInfoLayer
