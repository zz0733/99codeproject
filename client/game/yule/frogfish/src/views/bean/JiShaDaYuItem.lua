-- region JiShaDaYuItem.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 击杀大鱼特效动画 node.

local module_pre = "game.yule.frogfish.src"
local FishRes     = require(module_pre..".views.scene.FishSceneRes")
local FishDataMgr = require(module_pre..".views.manager.FishDataMgr")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local JiShaDaYuItem = class("JiShaDaYuItem", cc.Node)

JiShaDaYuItem.m_nChairId = 0           --这个chairId  是 viewChairId

function JiShaDaYuItem:ctor()
    self.m_fishSoundID = 0
    self.m_nChairId = 0
end

function JiShaDaYuItem.create(_fishKind, _llScore, _nSeatIndex)

    local pJiShaDaYuItem = JiShaDaYuItem.new()
    pJiShaDaYuItem:init(_fishKind, _llScore, _nSeatIndex)
    return pJiShaDaYuItem
end 

function JiShaDaYuItem:getChairId()
    return self.m_nChairId
end

function JiShaDaYuItem:init(_fishKind, _llScore, _nSeatIndex)
    self.m_nChairId = _nSeatIndex

    --节点
    local node = display.newNode()
    self:addChild(node, 90 + 1)

    --得分
    local bBoss = (_fishKind == FishKind.FISH_JINCHAN)
    local nMeChairID =FishDataMgr:getInstance():getMeChairID()
    local nViewChairID = FishDataMgr:getInstance():SwitchViewChairID(nMeChairID)
    local isMeSelf = nViewChairID == _nSeatIndex
    local strPath = isMeSelf and FishRes.FONT_OF_SUZI_NUMBER or FishRes.FONT_OF_SUZI_NUMBER_SILVER
    local strllScore = (_llScore) --string.format("%d.%02d", (_llScore/100), math.abs((_llScore)%100))
    local lb = cc.Label:createWithBMFont(strPath, strllScore)
    lb:setAnchorPoint(cc.p(0.5,0.5))
    lb:addTo(node, 1)

    --动画
    if bBoss then
        local armature = ccs.Armature:create("bingo-boss")
        armature:getAnimation():play("bingo-boss", -1, 0)
        local function animationEvent(armature,moveMentType,moveMentId)
            if moveMentType == ccs.MovementEventType.complete or moveMentType == ccs.MovementEventType.loopComplete then 
                if moveMentId == "bingo-boss" then 
                    self:removeArmature(armature)
                end 
            end 
        end
        armature:getAnimation():setMovementEventCallFunc(animationEvent)

        lb:setScale(0.54)
        lb:setPosition(cc.p(-10,-55))
        node:addChild(armature)

        ExternalFun.playGameEffect(FishRes.SOUND_OF_BINGO)
    else
        local armature = ccs.Armature:create("bingo")
        armature:getAnimation():play("Animation1")
        local function animationEvent(armature,moveMentType,moveMentId)
            if moveMentType == ccs.MovementEventType.complete or moveMentType == ccs.MovementEventType.loopComplete then 
                if moveMentId == "Animation1" then 
                    self:removeArmature(armature)
                end 
            end 
        end
        armature:getAnimation():setMovementEventCallFunc(animationEvent)
        node:addChild(armature)

        lb:setScale(0.72)
        lb:setPosition(cc.p(0, 0))
        lb:setRotation(-20)
        local squence = cc.Sequence:create(cc.RotateTo:create(0.5, 20), cc.RotateTo:create(0.5, -20))
        lb:runAction(cc.RepeatForever:create(squence))

        -- 播放音效
        if self.m_fishSoundID ~= 0 then
            ExternalFun.stopGameEffect(self.m_fishSoundID)
            self.m_fishSoundID = 0
        end
        self.m_fishSoundID = ExternalFun.playGameEffect(FishRes.SOUND_OF_BINGO)
    end
    
    return true
end 

function JiShaDaYuItem:removeSchedule(dt)

    self:removeFromParent()
end 

function JiShaDaYuItem:removeArmature(armature)

    ExternalFun.stopGameEffect(self.m_fishSoundID)
    self.m_fishSoundID = 0
    if armature ~= nil then

        armature:removeFromParent()
        armature = nil
    end
    self:removeFromParent()
end 

return JiShaDaYuItem

-- endregion
