--region *.lua
--Date
--
--endregion

--local GameRuleLayer = class("GameRuleLayer", cc.Node)
local GameRuleLayer = class("GameRuleLayer", cc.Layer)

function GameRuleLayer.create()
    return GameRuleLayer:new()
end

function GameRuleLayer:ctor()
    self:enableNodeEvents()
    self:init()
end

function GameRuleLayer:init()

    self.m_pathUI = cc.CSLoader:createNode("zhajinhua/ZhajhHelp.csb")
    self.m_pathUI:addTo(self)
    self.btn_mask = self.m_pathUI:getChildByName("panel_mask")

    self.m_pBg = self.m_pathUI:getChildByName("image_bg")

    self.m_pBtnClose = self.m_pBg:getChildByName("button_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))

--    self.m_pNodespr = self.m_pBg:getChildByName("node_sprNode"):setVisible(true)

--    self.m_pNodedes = self.m_pBg:getChildByName("node_desNode"):setVisible(false)

--    self:initView()
end 

function GameRuleLayer:onEnter()
end

function GameRuleLayer:onExit()
end

function GameRuleLayer:onReturnClicked()
    self:removeFromParent()
end

function GameRuleLayer:initView()
    local cardTypeBtn = self.m_pBg:getChildByName("button_cardTypeBtn")
    cardTypeBtn:addClickEventListener(handler(self,self.onCaedTypeClicked))

    local desBtn = self.m_pBg:getChildByName("button_desBtn")
    desBtn:addClickEventListener(handler(self,self.onDesClicked))
end 

function GameRuleLayer:onCaedTypeClicked()
    self.m_pNodespr:setVisible(true)
    self.m_pNodedes:setVisible(false) 
end

function GameRuleLayer:onDesClicked()
    self.m_pNodespr:setVisible(false)
    self.m_pNodedes:setVisible(true)
end

return GameRuleLayer