--region RedVsBlackOtherInfoLayer.lua
--Date 2018/03/16
--百人牛牛其他玩家信息界面
--endregion

local RedVsBlackRes             = appdf.req("game.yule.hhdz.src.game.redvsblack.scene.RedVsBlackRes")
local RedVsBlackDataManager     = appdf.req("game.yule.hhdz.src.game.redvsblack.manager.RedVsBlackDataManager")
local RedVsBlackOtherInfoLayer  = class("RedVsBlackOtherInfoLayer", cc.Layer)
local HeadSprite               = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
function RedVsBlackOtherInfoLayer.create()
    RedVsBlackOtherInfoLayer.instance_ = RedVsBlackOtherInfoLayer.new()
    return RedVsBlackOtherInfoLayer.instance_
end

function RedVsBlackOtherInfoLayer:ctor()
    self:enableNodeEvents()
    self:init()
end

function RedVsBlackOtherInfoLayer:init()
    self:initVar()
    self:initCSB()
    self:initView()
end 

function RedVsBlackOtherInfoLayer:onEnter()
end

function RedVsBlackOtherInfoLayer:onExit()
end

function RedVsBlackOtherInfoLayer:initVar()
    self.m_vecOtherInfo = {}
    --按金币大小排序
    local tab = RedVsBlackDataManager.getInstance():getRankUser() --CUserManager.getInstance():getUserInfoInTable(PlayerInfo.getInstance():getTableID())
    table.sort(tab, function(a,b)
        local ascore = a[6]
        local bscore = b[6]
        return ascore > bscore
    end)
    self.m_vecOtherInfo = tab
end

function RedVsBlackOtherInfoLayer:initCSB()
    self.m_rootUI       = display.newNode()
    self.m_rootUI:addTo(self)
    self.m_pathUI       = cc.CSLoader:createNode(RedVsBlackRes.CSB_GAME_USERINFO)
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

function RedVsBlackOtherInfoLayer:initView()
    self:initTableView()
    self:initSlider()
    if #self.m_vecOtherInfo < 5 then
        local slider = tolua.cast(self.m_rootNode:getChildByTag(100), "cc.ControlSlider")
        if slider then slider:setVisible(false) end
    end
end

function RedVsBlackOtherInfoLayer:initSlider()
    local spBg = cc.Sprite:createWithSpriteFrameName(RedVsBlackRes.IMG_SCROLL_BG)
    -- //添加一个滑动条的背景
    local spBg0 = cc.Sprite:createWithSpriteFrameName(RedVsBlackRes.IMG_SCROLL_BG)
    spBg0:setAnchorPoint(cc.p(0, 0))
    spBg:addChild(spBg0, 20)
    
    local pgSp = cc.Sprite:createWithSpriteFrameName(RedVsBlackRes.IMG_NULL)
    pgSp:setOpacity(0)
    local spTub = cc.Sprite:createWithSpriteFrameName(RedVsBlackRes.IMG_SCROLL_BUTTON)
    local spTub1 = cc.Sprite:createWithSpriteFrameName(RedVsBlackRes.IMG_SCROLL_BUTTON)
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

function RedVsBlackOtherInfoLayer:onReturnClicked()
--    AudioManager.getInstance():playSound(RedVsBlackRes.SOUND_OF_CLOSE)
    self:removeFromParent()
end

function RedVsBlackOtherInfoLayer:initTableView()
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

function RedVsBlackOtherInfoLayer:initTableViewCell(cell, idx)
    local userinfo = self.m_vecOtherInfo[idx+1]
    if not userinfo then return end
    local node = cc.CSLoader:createNode(RedVsBlackRes.CSB_GAME_USERINFO_NODE)
    node:setPosition(cc.p(5,0))
    cell:addChild(node)

    local name = node:getChildByName("Text_name")
    local strName = LuaUtils.getDisplayNickNameInGame(userinfo[2])
    name:setString(strName)

    local gold = node:getChildByName("Text_gold")
    gold:setString(LuaUtils.getFormatGoldAndNumber(userinfo[6] or "0"))

--    local wFaceID = userinfo[1] or 0
--    local strHeadIcon = string.format("gui-icon-head-%02d.png", wFaceID % G_CONSTANTS.FACE_NUM + 1)
--    local icon = node:getChildByName("Image_icon")
--    icon:loadTexture(strHeadIcon,ccui.TextureResType.localType)

    local pImgAvatar = node:getChildByName("Image_icon")
    local head = HeadSprite:createClipHead({userid = self.m_vecOtherInfo[idx+1][1], nickname = self.m_vecOtherInfo[idx+1][2], avatar_no = self.m_vecOtherInfo[idx+1][3]},75)
    head:setAnchorPoint(cc.p(0.5,0.5))
    pImgAvatar:addChild(head)

end

function RedVsBlackOtherInfoLayer:cellSizeForTable(table, idx)
    return 320,107
end

function RedVsBlackOtherInfoLayer:tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    if not cell then
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end
    self:initTableViewCell(cell, idx)
    return cell
end

function RedVsBlackOtherInfoLayer:numberOfCellsInTableView(table)
    return #self.m_vecOtherInfo
end

function RedVsBlackOtherInfoLayer:tableCellTouched(table, cell)
end

function RedVsBlackOtherInfoLayer:scrollViewDidScroll(pView)
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

return RedVsBlackOtherInfoLayer
