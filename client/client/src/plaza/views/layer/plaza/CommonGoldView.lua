--region CommonGoldView.lua
--Date 2017.08.09.
--Auther Goblin.
--Modify by JackyXu on 2018.01.06
--Desc:  大厅通用顶部金币 view

local CommonGoldView = class("CommonGoldView", cc.Node)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

function CommonGoldView:ctor(tag)
    self:enableNodeEvents()
    self.tag = tag
    self:init()
end

function CommonGoldView:init()

    --init csb
    self.m_commonGoldUI = cc.CSLoader:createNode("hall/csb/HallCommonGold.csb")
    self:addChild(self.m_commonGoldUI)

    self.pNodeRoot         = self.m_commonGoldUI:getChildByName("HallCommonGold")
    self.node_bank         = self.pNodeRoot:getChildByName("node_bank")
    self.node_gold         = self.pNodeRoot:getChildByName("node_gold")
    self.m_pLbBankMoney     = self.node_bank:getChildByName("TXT_bankScore")
    self.m_pLbGold          = self.node_gold:getChildByName("TXT_userScore")
    self.Button_showcharge  = self.node_gold:getChildByName("Button_showcharge")
    self.Button_showbank    = self.node_bank:getChildByName("Button_showbank")
    self.IMG_bank_bg = self.node_bank:getChildByName("IMG_bank_bg")
    self.IconCharge_bg = self.node_gold:getChildByName("IMG_gold_bg")
    self.Button_showcharge:addClickEventListener(handler(self,self.showChargeClicked))
    self.Button_showbank:addClickEventListener(handler(self,self.showBankClicked))
    self:changeLayerByTag(self.tag)
    self:onMsgUpdateSocre()
end

function CommonGoldView:changeLayerByTag(tag)
    if tag == "RoomChooseLayer" then
       self.node_bank:setVisible(false)
       self.Button_showcharge:setVisible(false)
       self.IconCharge_bg:setVisible(true)
    elseif tag == "BankInfoLayer" then

       self.Button_showcharge:setVisible(false)
       self.IconCharge_bg:setVisible(false)

       self.Button_showbank:setVisible(false)
       self.IMG_bank_bg:setVisible(false)
    elseif tag == "GameRoomLayer" then
       self.node_bank:setVisible(false)
       self.Button_showcharge:setVisible(false)
       self.IconCharge_bg:setVisible(true)
    end
end


function CommonGoldView:onEnter()
    self.m_listener = cc.EventListenerCustom:create(yl.RY_USERINFO_NOTIFY,handler(self, self.onUserInfoChange))
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_listener, self)
end

function CommonGoldView:onExit()
    if nil ~= self.m_listener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(self.m_listener)
        self.m_listener = nil
    end 
end


function CommonGoldView:onUserInfoChange( event  )
    print("----------userinfo change notify------------")

    local msgWhat = event.obj
    
    if nil ~= msgWhat then
       if msgWhat == yl.RY_MSG_USERWEALTH then
            --更新财富
            self:onMsgUpdateSocre()
        end
    end
end

-- 点击 "+" 响应
function CommonGoldView:onAddBtnClicked()
    ExternalFun.playClickEffect()
    local _event = {
        name = Hall_Events.MSG_SHOW_SHOP,
        packet = nil,
    }
    SLFacade:dispatchCustomEvent(Hall_Events.MSG_SHOW_SHOP, _event)

end

-- 点击 "+" 响应
function CommonGoldView:showBankClicked()
    ExternalFun.playClickEffect()
    local _event = {
        name = Hall_Events.SHOW_OPEN_BANK,
        packet = nil,
    }
    SLFacade:dispatchCustomEvent(Hall_Events.SHOW_OPEN_BANK, _event)
end

-- 点击 "+" 响应
function CommonGoldView:showChargeClicked()
    ExternalFun.playClickEffect()
    local _event = {
        name = Hall_Events.MSG_SHOW_SHOP,
        packet = nil,
    }
    SLFacade:dispatchCustomEvent(Hall_Events.MSG_SHOW_SHOP, _event)
end

-- 更新项部金币
function CommonGoldView:onMsgUpdateSocre()
    --用户金币
    self.m_pLbGold:setString(GlobalUserItem.tabAccountInfo.bag_money)

    -- 保险箱金币
    self.m_pLbBankMoney:setString(GlobalUserItem.tabAccountInfo.bank_money)
end

return CommonGoldView
