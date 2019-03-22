-- region SimpleFish.lua
-- Date     2017.04.07
-- zhiyuan
-- Desc 闪电鱼特创建的5条虚拟鱼（不是从服务器下发） sprite.
local module_pre = "game.yule.frogfish.src"
local FishDataMgr = require(module_pre..".views.manager.FishDataMgr")

local SimpleFish = class("SimpleFish", cc.Sprite)

function SimpleFish:ctor()
    self.m_pFishArmture = nil
    self.m_pQuanquanArmture = nil
    self.m_nMainFishId = 0
    self.m_posTarget = cc.p(0, 0)
    self.m_nSimpleFishId = -1
    self.m_fLineAngle = 0
    self.m_fLineDistance = 0
    self.m_fLineDiff = 0
end

function SimpleFish.create( fish_kind, mainFishId)

    if fish_kind == nil or mainFishId == nil then
        return nil
    end
    local pFish = SimpleFish.new()
    if pFish:init(fish_kind,mainFishId) == false then 
        return nil 
    end 
    return pFish
end 

function SimpleFish:init( fish_kind, mainFishId)

    local strArmName = FishDataMgr:getInstance():getArmatureNameByFishKind(fish_kind)
    local strAnimationLive = FishDataMgr:getInstance():getAnimationLiveNameByFishKind(fish_kind)
    if #strArmName == 0 then
        return false
    end 
    self.m_nMainFishId = mainFishId
    self.m_eFishKind = fish_kind

    --鱼动画
    self.m_pFishArmture = ccs.Armature:create(strArmName)
    self.m_pFishArmture:getAnimation():play(strAnimationLive)
    self.m_pFishArmture:setAnchorPoint(cc.p(0.5,0.5))
    self.m_pFishArmture:setPosition(cc.p(0, 0))
    self:addChild(self.m_pFishArmture, 20)
    
    --蓝鱼
    if fish_kind == FishKind.FISH_LANYU then
        local fScale = FishDataMgr:getInstance():getFishScale(fish_kind)
        self.m_pFishArmture:setScale(fScale)
    end

    --圈动画
    local fScale = FishDataMgr:getInstance():getQuanQuanScale(fish_kind)
    self.m_pQuanquanArmture = ccs.Armature:create("teshuyuzhong_buyu")
    self.m_pQuanquanArmture:getAnimation():play("Animation2")
    self.m_pQuanquanArmture:setAnchorPoint(cc.p(0.5,0.5))
    self.m_pQuanquanArmture:setPosition(cc.p(0, 0))
    self.m_pQuanquanArmture:setScale(fScale)
    self:addChild(self.m_pQuanquanArmture, 20 + 5)
    
    return true
end 

function SimpleFish:setSimpleFishDie()
    if self.m_pFishArmture ~= nil then 
        local strAnimationDie = FishDataMgr:getInstance():getAnimationDieNameByFishKind(self.m_eFishKind)
        self.m_pFishArmture:getAnimation():play(strAnimationDie)
        local function animationEvent(armature,moveMentType,moveMentId)
            if moveMentType == ccs.MovementEventType.complete or moveMentType == ccs.MovementEventType.loopComplete then 
                if moveMentId == strAnimationDie then 
                    self:dieEnd()
                end 
            end 
        end
        self.m_pFishArmture:getAnimation():setMovementEventCallFunc(animationEvent)
    end 
end 

function SimpleFish:setSimpleFishChangeColor()

    if self.m_pQuanquanArmture ~= nil then 
        self.m_pQuanquanArmture:getAnimation():play("Animation1")
    end 
end 

function SimpleFish:dieEnd()

    self:removeFromParent()
end 

function SimpleFish:setMainFishId(MainFishId)
     self.m_nMainFishId = MainFishId
end

function SimpleFish:getMainFishId()
     return self.m_nMainFishId
end

function SimpleFish:setSimpleFishId(SimpleFishId)
     self.m_nSimpleFishId = SimpleFishId
end

function SimpleFish:getSimpleFishId()
     return self.m_nSimpleFishId
end

function SimpleFish:setLineAngle(LineAngle)
     self.m_fLineAngle = LineAngle
end

function SimpleFish:getLineAngle()
     return self.m_fLineAngle
end

function SimpleFish:setLineDistance(LineDistance)
     self.m_fLineDistance = LineDistance
end

function SimpleFish:getLineDistance()
     return self.m_fLineDistance
end

function SimpleFish:setLineDiff(LineDiff)
     self.m_fLineDiff = LineDiff
end

function SimpleFish:getLineDiff()
     return self.m_fLineDiff
end

function SimpleFish:setTarget(Target)
     self.m_posTarget = Target
end

function SimpleFish:getTarget()
     return self.m_posTarget
end

return SimpleFish
-- endregion
