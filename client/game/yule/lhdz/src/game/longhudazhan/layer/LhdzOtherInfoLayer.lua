--region lhdzOtherInfoLayer.lua
--Date 2018/03/16
--龙虎斗其他玩家信息界面
--endregion
local module_pre = "game.yule.lhdz.src."
local LhdzDataMgr           = appdf.req(module_pre.."game.longhudazhan.manager.LhdzDataMgr")
local Lhdz_Res              = appdf.req(module_pre.."game.longhudazhan.scene.Lhdz_Res")
local lhdzOtherInfoLayer  = class("lhdzOtherInfoLayer", cc.Layer)
local HeadSprite               = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")

function lhdzOtherInfoLayer:ctor()
    self:enableNodeEvents()
    self:init()
    self:show()
end

function lhdzOtherInfoLayer:init()
    self:initVar()
    self:initCSB()
    self:initView()
end 

function lhdzOtherInfoLayer:onEnter()
end

function lhdzOtherInfoLayer:onExit()
end
-- 弹出
function lhdzOtherInfoLayer:show()

    local pNode = self.m_pathUI
    if (pNode ~= nil)then
        pNode:stopAllActions()
        pNode:setScale(0.0)
        local show = cc.Show:create()
        local scaleTo = cc.ScaleTo:create(0.4, 1.0)
        local ease = cc.EaseBackOut:create(scaleTo)
        local callback = cc.CallFunc:create(function ()
            --self:callbackMove()
        end)
        local seq = cc.Sequence:create(show,ease,callback)
        pNode:runAction(seq)
    end
end

function lhdzOtherInfoLayer:initVar()
    self.m_vecOtherInfo = {}
    --按金币大小排序
    local tab = LhdzDataMgr.getInstance():getRankUserByIndex() --CUserManager.getInstance():getUserInfoInTable(PlayerInfo.getInstance():getTableID())
    table.sort(tab, function(a,b)
        local ascore = a[6]
        local bscore = b[6]
        return ascore > bscore
    end)
    table.copy(tab,self.m_vecOtherInfo)
end

function lhdzOtherInfoLayer:initCSB()
    self.m_rootUI       = display.newNode()
    self.m_rootUI:addTo(self)
    self.m_pathUI       = cc.CSLoader:createNode(Lhdz_Res.CSB_GAME_USERINFO)
    self.m_pathUI:setAnchorPoint(cc.p(0.5,0.5))
    self.m_pathUI:setPosition(cc.p(self.m_pathUI:getContentSize().width/2,self.m_pathUI:getContentSize().height/2))
    self.m_pathUI:addTo(self.m_rootUI)
    self.m_rootNode     = self.m_pathUI:getChildByName("Panel_1")
    self.m_pBg          = self.m_pathUI:getChildByName("image_bg")
    self.m_pBtnClose    = self.m_pBg:getChildByName("button_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))
    self.m_pTxtNum      = self.m_pBg:getChildByName("text_left__"):getChildByName("text_num")
    self.m_pTxtNum:setString(table.nums(self.m_vecOtherInfo))
    self.m_plistView    = self.m_pBg:getChildByName("listView_list")
    self.m_plistView:setScrollBarEnabled(false)
    self.m_NodeItem     = self.m_pathUI:getChildByName("panel_itemModelLine")

end

function lhdzOtherInfoLayer:initView()
    self:initTableView()
end

function lhdzOtherInfoLayer:onReturnClicked()
    self:removeFromParent()
end

function lhdzOtherInfoLayer:initTableView()
     if self.m_pTableView == nil then
         local size = self.m_plistView:getContentSize()
         local pos = cc.p(self.m_plistView:getPosition())
        self.m_pTableView = cc.TableView:create(size)
         self.m_pBg:addChild(self.m_pTableView)
         --self.m_pTableView:setAnchorPoint(cc.p(0,0))
         self.m_pTableView:setPosition(pos)
         --        self.m_pTableView:setIgnoreAnchorPointForPosition(false)
         self.m_pTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
         self.m_pTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
         self.m_pTableView:setDelegate()
         --self.m_pTableView:registerScriptHandler(handler(self,self.scrollViewDidScroll), CCTableView.kTableViewScroll)
         self.m_pTableView:registerScriptHandler(handler(self,self.cellSizeForTable), CCTableView.kTableCellSizeForIndex)
         self.m_pTableView:registerScriptHandler(handler(self,self.tableCellAtIndex), CCTableView.kTableCellSizeAtIndex)
         self.m_pTableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView), CCTableView.kNumberOfCellsInTableView)
         self.m_pTableView:registerScriptHandler(handler(self,self.tableCellTouched), CCTableView.kTableCellTouched)
         self.m_pTableView:reloadData()
         self.m_plistView:removeFromParent()
    else
        self.m_pTableView:reloadData()
    end
end

function lhdzOtherInfoLayer:initTableViewCell(cell, idx)
    local item = cell:getChildByName("itemNode")
    for j = 1, 3 do
        local player = item:getChildByName(string.format("panel_player_%d",j))
        player:setVisible(true)
        local icon = player:getChildByName("image_avatar")
        local name = player:getChildByName("text_name")
        local money = player:getChildByName("image_coinIcon"):getChildByName("text_coin")
        if #self.m_vecOtherInfo >= (3*(idx -1) + j) then
            local head = icon:getChildByName("headSprite")
            local idxTmp = (3*(idx -1) + j)
            local userItem = {userid = self.m_vecOtherInfo[idxTmp][1], nickname = self.m_vecOtherInfo[idxTmp][2], avatar_no = self.m_vecOtherInfo[idxTmp][3]}
            if head then
                head:updateHead(userItem)
            else
                local head = HeadSprite:createClipHead(userItem,129)
                head:setAnchorPoint(cc.p(0,0))
                head:setName("headSprite")
                icon:addChild(head)
            end

            name:setString(LuaUtils.getDisplayNickName(self.m_vecOtherInfo[3*(idx -1) + j][2],12,true))
            money:setString(self.m_vecOtherInfo[3*(idx -1) + j][6])
        end
        if idx == math.ceil(table.nums(self.m_vecOtherInfo)/3 ) then
            local lastnum = 0
            if (table.nums(self.m_vecOtherInfo)%3) ~= 0 then
                lastnum = (table.nums(self.m_vecOtherInfo)%3)
            end
            if lastnum == 1 then
                if j == 3 or j == 2 then
                    player:setVisible(false)
                end
            elseif lastnum == 2 then
                if j == 3 then
                    player:setVisible(false)
                end
            end
        end
    end

end

function lhdzOtherInfoLayer:cellSizeForTable(table, idx)
    local cellSize = self.m_NodeItem:getContentSize()
    return cellSize.width,cellSize.height
end

function lhdzOtherInfoLayer:tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    if not cell then
        cell = cc.TableViewCell:new()
        local itemNode = self.m_NodeItem:clone()
        itemNode:setVisible(true)
        itemNode:setPosition(cc.p(0,0))
        itemNode:setName("itemNode")
        cell:addChild(itemNode)
    end
    self:initTableViewCell(cell, idx + 1)
    return cell
end

function lhdzOtherInfoLayer:numberOfCellsInTableView(table)
    return math.ceil(#self.m_vecOtherInfo / 3)
end

function lhdzOtherInfoLayer:tableCellTouched(table, cell)
end

function lhdzOtherInfoLayer:scrollViewDidScroll(pView)
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
--得到整数部分
function lhdzOtherInfoLayer:getIntValue(num)
    local tt = 0
    num,tt = math.modf(num/1);
    return num
end
return lhdzOtherInfoLayer
