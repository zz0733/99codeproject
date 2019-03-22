--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local SpreadRewardIntroduceView = class("SpreadRewardIntroduceView", cc.Layer)

local G_SpreadRewardIntroduceView = nil
function SpreadRewardIntroduceView.create()
    G_SpreadRewardIntroduceView = SpreadRewardIntroduceView.new():init()
    return G_SpreadRewardIntroduceView
end

function SpreadRewardIntroduceView:ctor()
    self:enableNodeEvents()
    self.m_rootUI = display.newNode():addTo(self)
end

function SpreadRewardIntroduceView:init()

    self.m_pathUI = cc.CSLoader:createNode("hall/csb/SpreadRewardIntroduce.csb")
    self.m_rootUI:addChild(self.m_pathUI)

    return self
end

function SpreadRewardIntroduceView:onEnter()
   
end

function SpreadRewardIntroduceView:onExit()

    G_SpreadRewardIntroduceView = nil
end

return SpreadRewardIntroduceView

--endregion
