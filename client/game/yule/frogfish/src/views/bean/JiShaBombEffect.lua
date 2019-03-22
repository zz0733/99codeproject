-- region JiShaBombEffect.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 击杀大鱼特效动画 node.

local module_pre = "game.yule.frogfish.src"
local FishRes     = require(module_pre..".views.scene.FishSceneRes")
local FishDataMgr = require(module_pre..".views.manager.FishDataMgr")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local JiShaBombEffect = class("JiShaBombEffect", cc.Node)

JiShaBombEffect.m_nChairId = 0           --这个chairId  是 viewChairId

function JiShaBombEffect:ctor()
    self.m_fishSoundID = 0
    self.m_nChairId = 0
    self.fishArmture = nil 
    self.bombType = 0
    self.m_PaoPos = cc.p(0, 0 )
end

function JiShaBombEffect.create(_fishKind, _llScore, _nSeatIndex)

    local pJiShaBombEffect = JiShaBombEffect.new()
    if not pJiShaBombEffect:init(_fishKind, _llScore, _nSeatIndex) then
       return nil
    end
    return pJiShaBombEffect
end 

function JiShaBombEffect:getChairId()
    return self.m_nChairId
end

function JiShaBombEffect:init(_fishKind, _llScore, _nSeatIndex)
    self.m_nChairId = _nSeatIndex

    --节点
    local node = display.newNode()
    self:addChild(node, 90 + 1)

    --得分
    --local bBoss = (_fishKind == FishKind.FISH_JINCHAN)
    local nMeChairID = FishDataMgr:getInstance():getMeChairID()
    local nViewChairID = FishDataMgr:getInstance():SwitchViewChairID(nMeChairID)
    local isMeSelf = nViewChairID == _nSeatIndex
    local strPath = isMeSelf and FishRes.FONT_OF_SUZI_NUMBER or FishRes.FONT_OF_SUZI_NUMBER_SILVER
    local strllScore = (_llScore) --string.format("%d.%02d", (_llScore/100), math.abs((_llScore)%100))
    local lb = cc.Label:createWithBMFont(strPath, strllScore)
    lb:setAnchorPoint(cc.p(0.5,0.5))
    lb:addTo(node, 1)

    if  _fishKind == FishKind.FISH_FOSHOU 
       or _fishKind == FishKind.FISH_BGLU 
       or _fishKind == FishKind.FISH_DNTG 
       or _fishKind == FishKind.FISH_YJSD 
       or _fishKind == FishKind.FISH_YSSN 
       or _fishKind == FishKind.FISH_PIECE then

        local mulriple = FishDataMgr:getInstance():getMulripleByIndex(nMeChairID) --当前自己的子弹倍率
        local armature =  nil 
        if _llScore / mulriple >= 50 then
            armature = ccs.Armature:create("baofuliAnimation")
            self.bombType = 1
        else 
            armature = ccs.Armature:create("jishamoshi_Animation")
            self.bombType = 0
        end
        if armature == nil then
            return false
        end
        armature:getAnimation():play("Animation1", -1, 0)
        local function animationEvent(armature,moveMentType,moveMentId)
            if moveMentType == ccs.MovementEventType.complete or moveMentType == ccs.MovementEventType.loopComplete then 
                if moveMentId == "Animation1" then 
                    self:removeArmature(armature)
                end 
            end 
        end
        armature:getAnimation():setMovementEventCallFunc(animationEvent)

        lb:setScale(0.76)
        if self.bombType == 1 then
            lb:setPosition(cc.p(-10, -95))
        else
            lb:setPosition(cc.p(0, -15))
        end
        node:addChild(armature)

        ExternalFun.playGameEffect(FishRes.SOUND_OF_BINGO)
    end    

    if  _fishKind == FishKind.FISH_FOSHOU 
       or _fishKind == FishKind.FISH_BGLU 
       or _fishKind == FishKind.FISH_DNTG 
       or _fishKind == FishKind.FISH_YJSD 
       or _fishKind == FishKind.FISH_YSSN 
       or _fishKind == FishKind.FISH_PIECE then
        --盘盘动画
        local strPan = FishDataMgr.getInstance():getArmatureNameByFishKind(_fishKind)
        local strLive = FishDataMgr.getInstance():getAnimationLiveNameByFishKind(_fishKind)
        self.fishArmture = ccs.Armature:create(strPan)
        if self.fishArmture ~= nil then            
            self.fishArmture:getAnimation():play(strLive)
            self.fishArmture:setAnchorPoint(cc.p(0.5, 0.5))
            local fScale = FishDataMgr.getInstance():getFishScale( _fishKind )
            if self.bombType == 1 then
                self.fishArmture:setPosition(cc.p(-108, -42))
            else 
                self.fishArmture:setPosition(cc.p(38, 47))
                fScale = fScale * 0.8
            end           
            if _fishKind == FishKind.FISH_PIECE then
                self.fishArmture:setScale( fScale * 0.28)
            else 
                self.fishArmture:setScale( fScale * 0.4)
            end
            self.fishArmture:addTo(node, 20)
        end
        end
    return true
end 

function JiShaBombEffect:removeSchedule(dt)

    self:removeFromParent()
end 

function JiShaBombEffect:removeArmature(armature)
    local pMove = cc.MoveTo:create(0.25, self.m_PaoPos)
    local pScale = cc.ScaleTo:create(0.25, 0.2)
    local pAction = cc.Spawn:create(pMove, pScale)
    local pMoveEnd = cc.CallFunc:create(function()
        ExternalFun.playGameEffect(self.m_fishSoundID)
        self.m_fishSoundID = 0
        if armature ~= nil then
            armature:removeFromParent()
            armature = nil
        end
        if self.fishArmture ~= nil then
            self.fishArmture:removeFromParent()
            self.fishArmture = nil
        end
        self:removeFromParent()
        end )

    local pAction = cc.Sequence:create(pAction, pMoveEnd)
    self:runAction(pAction)
end 

return JiShaBombEffect

-- endregion
