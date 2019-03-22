--region *.lua
--Date
--
--endregion
local MessageDialog = class("MessageDialog", FixLayer)

local G_NoticeDialog = nil
function MessageDialog.create()
    G_NoticeDialog = MessageDialog.new():init()
    return G_NoticeDialog
end

function MessageDialog:ctor()
    self.super:ctor(self)
    self:enableNodeEvents()

    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
end

function MessageDialog:init()
    self:setTargetShowHideStyle(self, FixLayer.SHOW_DLG_NORMAL, FixLayer.HIDE_DLG_NORMAL)

    self.m_pathUI = cc.CSLoader:createNode("hall/csb/MessageCenterDialog.csb")
    self.m_rootUI:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("MessageCenterDialog")
    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    self.m_pImgBg    = self.m_pNodeRoot:getChildByName("Image_bg")
    self.m_pBtnClose = self.m_pImgBg:getChildByName("BTN_close")
    self.m_pTextMsg  = self.m_pImgBg:getChildByName("Label_1")
    
    self.m_pBtnClose:addClickEventListener(handler(self, self.onCloseClicked))
    return self
end

function MessageDialog:onEnter()
    self.super:onEnter()
    self:showWithStyle()
end

function MessageDialog:onExit()
    self.super:onExit()
end

function MessageDialog:setMsgText(text)
    if not text then return end
    self.m_pTextMsg:setString(text)
end

function MessageDialog:onCloseClicked()
--    AudioManager:getInstance():playSound("public/sound/sound-close.mp3")
    
    self:onMoveExitView()
end

return MessageDialog
