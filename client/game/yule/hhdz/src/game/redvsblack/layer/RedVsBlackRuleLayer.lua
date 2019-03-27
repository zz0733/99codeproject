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
    self:init()
end

function RedVsBlackRuleLayer:init()

    self.m_pathUI = cc.CSLoader:createNode("RBWar/RBWarHelpViewNew.csb")
    self.m_pathUI:addTo(self)
    self.btn_mask = self.m_pathUI:getChildByName("Panel_1")

    self.m_pBg = self.m_pathUI:getChildByName("image_bg")

    self.m_pBtnClose = self.m_pBg:getChildByName("button_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))

    self.m_pNodespr = self.m_pBg:getChildByName("node_sprNode"):setVisible(true)
    
    self.m_pNodedes = self.m_pBg:getChildByName("node_desNode"):setVisible(false)

    self:initView()
end 

function RedVsBlackRuleLayer:onEnter()
end

function RedVsBlackRuleLayer:onExit()
end

function RedVsBlackRuleLayer:onReturnClicked()
    self:removeFromParent()
end

function RedVsBlackRuleLayer:initView()
    local cardTypeBtn = self.m_pBg:getChildByName("button_cardTypeBtn")
    cardTypeBtn:addClickEventListener(handler(self,self.onCaedTypeClicked))

    local desBtn = self.m_pBg:getChildByName("button_desBtn")
    desBtn:addClickEventListener(handler(self,self.onDesClicked))
end 

function RedVsBlackRuleLayer:onCaedTypeClicked()
    self.m_pNodespr:setVisible(true)
    self.m_pNodedes:setVisible(false) 
end

function RedVsBlackRuleLayer:onDesClicked()
    self.m_pNodespr:setVisible(false)
    self.m_pNodedes:setVisible(true)
end

return RedVsBlackRuleLayer