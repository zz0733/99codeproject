-- region FishNet.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 鱼网 node.
local module_pre = "game.yule.frogfish.src"
local DataCacheMgr = require(module_pre..".views.manager.DataCacheMgr")

local FishNet = class("FishNet", cc.Node)

function FishNet:ctor()
    self.m_pSpNet = nil
end

function FishNet:create(paoView, index)
    local pFishNet = DataCacheMgr:getInstance():GetNetFromFreePool()
    if pFishNet == nil then
        pFishNet = FishNet.new()
        pFishNet:addTo(paoView.m_pathUI, 20 + 4)
    end
    pFishNet:init()
    pFishNet:setVisible(true)
    return pFishNet
end 
function FishNet:SetUnuse()
   self:setVisible(false)
   DataCacheMgr:getInstance():AddNetToFreePool( self )

   --self:setPosition(cc.p(-100, -100))
end
function FishNet:init()
    if self.m_pSpNet == nil then
        self.m_pSpNet = display.newSprite("#gui-fish-net1.png")
        self.m_pSpNet:setAnchorPoint(cc.p(0.5, 0.5))
        self.m_pSpNet:setPosition(cc.p(0, 0))
        self:addChild(self.m_pSpNet, 20)        
    end
        
    self.m_pSpNet:setScale(0.02)
    local scale = cc.ScaleTo:create(0.08, 0.8)
    local ease = cc.EaseBounceOut:create(scale)
    local delay = cc.DelayTime:create(0.18)
    local callback = cc.CallFunc:create( function()
        self.m_pSpNet:stopAllActions()
        --self:removeFromParent()
        self:SetUnuse()
    end )

    self.m_pSpNet:runAction(cc.Sequence:create(ease, delay, callback))

--    local callFunc = cc.CallFunc:create( function()
--        self:removeFishNet()
--    end )
--    self:runAction(cc.Sequence:create(cc.DelayTime:create(1.0), callFunc))
end 

--function FishNet:removeFishNet( dt)

--    if not self.m_bIsDeleted then 
--        self.m_bIsDeleted = true
--        self:removeFromParent()
--    end 
--end 


return FishNet

-- endregion
