--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local ShareWindowHelp = class("ShareWindowHelp",FixLayer)

local G_ShareWindowHelp = nil
function ShareWindowHelp.create()
    G_ShareWindowHelp = ShareWindowHelp.new():init()
    return G_ShareWindowHelp
end

function ShareWindowHelp:ctor()
    self:enableNodeEvents()
    self.m_rootUI = display.newNode():addTo(self)
end

function ShareWindowHelp:init()

    self.m_pathUI = cc.CSLoader:createNode("dt/ShareWindow_Help.csb")
    self.m_rootUI:addChild(self.m_pathUI)

    self.BTN_close = self.m_pathUI:getChildByName("image_bg"):getChildByName("button_close")
    self.Layer_close = self.m_pathUI:getChildByName("button_blocktouch")
    self.m_pathUI:setPositionY(80)
    self.BTN_close:addClickEventListener(handler(self, self.closeLayer))
    self.Layer_close:addClickEventListener(handler(self, self.closeLayer))

    return self
end

function ShareWindowHelp:closeLayer()
   self:onMoveExitView()
end

function ShareWindowHelp:onEnter()
   
end

function ShareWindowHelp:onExit()

    G_ShareWindowHelp = nil
end

return ShareWindowHelp

--endregion
