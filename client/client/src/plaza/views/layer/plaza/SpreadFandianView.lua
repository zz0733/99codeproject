--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local SpreadFandianView = class("SpreadFandianView", cc.Layer)
    --lzg
    --[[
    local UsrMsgManager = require("common.manager.UsrMsgManager")
    ]]--
local G_SpreadFandianView = nil
function SpreadFandianView.create()
    G_SpreadFandianView = SpreadFandianView.new():init()
    return G_SpreadFandianView
end

function SpreadFandianView:ctor()
    self:enableNodeEvents()
    self.m_rootUI = display.newNode():addTo(self)
end

function SpreadFandianView:init()

    self.m_pathUI = cc.CSLoader:createNode("hall/csb/SpreadTutorial.csb")
    self.m_rootUI:addChild(self.m_pathUI)

    return self
end

function SpreadFandianView:onEnter()
   
end

function SpreadFandianView:onExit()

    G_SpreadFandianView = nil
end

return SpreadFandianView

--endregion
