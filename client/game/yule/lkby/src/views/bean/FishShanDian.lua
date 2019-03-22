-- region FishShanDian.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 闪电鱼 node
local module_pre = "game.yule.lkby.src"
local FishDataMgr = require(module_pre..".views.manager.FishDataMgr")
local SimpleFish  = require(module_pre..".views.bean.SimpleFish")
local FishEvent   = require(module_pre..".views.scene.FishEvent")

local SLFacade = cc.exports.SLFacade

local FishShanDian = class("FishShanDian", cc.Node)

function FishShanDian.create(pParent, pFish, chairID, pNode)

    local pBomb = FishShanDian.new()
    pBomb:init(pParent, pFish, chairID, pNode)
    return pBomb
end 

function FishShanDian:ctor()
    self:enableNodeEvents()
    self.m_bIsDeleted = false
    self.m_ChairID = INVALID_CHAIR
    self.m_vecSimpleFish = {}
end

function FishShanDian:onEnter()
    SLFacade:addCustomEventListener(FishEvent.MSG_FISH_SWITCH_SCENE, handler(self, self.onMsgSwitchScene), self.__cname .. self.m_nFishID)
end

function FishShanDian:onExit()
    SLFacade:removeCustomEventListener(FishEvent.MSG_FISH_SWITCH_SCENE, self.__cname .. self.m_nFishID)
end

function FishShanDian:init(pParent, pFish, chairID, pNode)

    self.m_pParent = pParent
    self.m_pActionNode = pNode --用来执行动作
    self.m_ChairID = chairID
    self.m_nFishID = pFish:getID()
    self.m_nSeatIndex = FishDataMgr:getInstance():SwitchViewChairID(chairID)

    --偏移位置
    local nOffsetX = self:getTargetPosition()
    local nRandomX = self:getRandomPosition()
    self:setRandomPos(nRandomX, 0)
    self:setTargetPos(nOffsetX + nRandomX, 375)

    --保存要用的数据
    self.m_pFishPosition = cc.p(self.m_fTargetX, self.m_fTargetY) --终点位置
    self.m_pFishArray = pFish.m_arrShanDianFish --拖鱼数据
    self.m_pFishKind = pFish:getRealFishKind() --闪电鱼kind
    self.m_pFishScore = pFish:getFishScore() --闪电鱼gold

    local nCountFish = #pFish.m_arrShanDianFish --拖鱼的个数
    local nMoveTime = 0.5 --闪电鱼移动时间
    local nDelayTime = 0.8 --其他鱼拖鱼时间

    --动画
    self:initArmature()

    --父节点执行动作
    local pAction = cc.Sequence:create(
        cc.CallFunc:create(function()
            local pFish = FishDataMgr.getInstance():getFishByID(self.m_nFishID)
            if pFish then
                pFish:setDie(true)
                pFish:setLocalZOrder(20 + 5)
                pFish:runAction(cc.MoveTo:create(nMoveTime, self.m_pFishPosition))
            end
        end),
        cc.DelayTime:create(nMoveTime + 0.5),
        cc.CallFunc:create(function()
            local pFish = FishDataMgr.getInstance():getFishByID(self.m_nFishID)
            if pFish then
                pFish:setShanDianQuanDie()
            end
            self:moveShanDianFish()
        end),
        cc.DelayTime:create(nDelayTime * nCountFish + 0.5),
        cc.CallFunc:create(function()
            if self.m_pActionNode then
                self.m_pActionNode:stopActionByTag(self.m_nFishID)
            end
            if self.m_pParent then
                self.m_pParent:showFishCatchGoldEffect(self.m_pFishKind, self.m_pFishPosition, self.m_ChairID, self.m_pFishScore, 1)
            end
            local pFish = FishDataMgr.getInstance():getFishByID(self.m_nFishID)
            if pFish then
                pFish:setCatchStatus()
            end
            self:delLianSuoEffect()
        end))
    pAction:setTag(self.m_nFishID)
    self.m_pActionNode:runAction(pAction)
end

function FishShanDian:initArmature()

    -- 添加连线动画
    self.m_pLianxianArmature = ccs.Armature:create("liansuoshandian_buyu")
    self.m_pLianxianArmature:setAnchorPoint(cc.p(0, 0.5))
    self.m_pLianxianArmature:setPosition(self.m_pFishPosition)
    self.m_pLianxianArmature:setVisible(false)
    self.m_pLianxianArmature:addTo(self, 20 + 5)

    -- 添加文字动画
    self.m_pLianSuoLabelArmature = ccs.Armature:create("liansuoshandianwenzidonghua_buyu")
    self.m_pLianSuoLabelArmature:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_pLianSuoLabelArmature:setTag(0)

    -- 文字动画位置
    local pos = self:getDefinePostion()
    if self.m_nSeatIndex >= GAME_PLAYER_FISH / 2 then
        pos.y = pos.y - 55
    else
        pos.y = pos.y + 55
    end
    self.m_pLianSuoLabelArmature:setPosition(pos)

    -- 文字动画倒转
    if self.m_nSeatIndex >= GAME_PLAYER_FISH / 2 then
        self.m_pLianSuoLabelArmature:setRotation(180.0)
    end

    -- 文字动画回调
    local function animationEvent(armature, moveMentType, moveMentId)
        if moveMentType == ccs.MovementEventType.complete 
        or moveMentType == ccs.MovementEventType.loopComplete
        then
            if moveMentId == "Animation1"
            and armature:getName() == "liansuoshandianwenzidonghua_buyu"
            and armature:getTag() == 0
            then
                --弹出文字动画->闪烁文字动画
                armature:setTag(1)
                armature:getAnimation():play("Animation2")
            end
        end 
    end
    self.m_pLianSuoLabelArmature:getAnimation():setMovementEventCallFunc(animationEvent)
    self.m_pLianSuoLabelArmature:addTo(self, 80)
end

function FishShanDian:moveShanDianFish()

    self.m_pLianSuoLabelArmature:getAnimation():play("Animation1")
    self.m_pLianxianArmature:getAnimation():play("Animation1")
    
    -- 创建鱼
    for i = 1, 5 do
        local nFishKind = self.m_pFishKind
        local eSimpleType = self.m_pFishArray[i]
        local pSimple = SimpleFish.create(eSimpleType, self.m_nFishID)
        if pSimple == nil then
            local a = 0
        else
            local diff = FishDataMgr:getInstance():getQuanQuanDistance(nFishKind, eSimpleType)
            -- 2条鱼之间的间隔
            local inputTarget = cc.p(self.m_fTargetX, self.m_fTargetY)
            -- 出生点
            local inputAngle = math.random(0, 360)
            local x = 0
            local y = 0
            x,y = FishDataMgr:getInstance():GetTargetPoint2(inputTarget.x, inputTarget.y, math.angle2radian(inputAngle), x, y)
            local maxDis = math.abs(cc.pGetDistance(inputTarget, cc.p(x, y)))
            local begin = self:getTargetPositionByAngle(inputTarget, inputAngle, math.random(diff + 50, maxDis))
            -- 目标点
            local target = self:getTargetPositionByAngle(inputTarget, inputAngle, diff)
            local nDistance = math.abs(cc.pGetDistance(begin, inputTarget))

            pSimple:setTarget(target)
            pSimple:setLineAngle(inputAngle)
            pSimple:setLineDistance(nDistance)
            pSimple:setLineDiff(diff)
            pSimple:setSimpleFishId(i)
            pSimple:setPosition(begin)
            pSimple:setAnchorPoint(cc.p(0.5, 0.5))
            pSimple:setVisible(false)
            pSimple:addTo(self, 10 + 5)
            table.insert(self.m_vecSimpleFish,pSimple)

            -- 鱼移动
            local nDelayTime = 0.8 --其他鱼拖鱼时间
            local delay = cc.DelayTime:create(0.8 * (i-1))
            local show = cc.Show:create()
            local callLine = cc.CallFunc:create(function()
                -- 连线变化
                self.m_pLianxianArmature:setVisible(true)
                self.m_pLianxianArmature:setRotation(pSimple:getLineAngle() - 90)
                self.m_pLianxianArmature:setScaleX(pSimple:getLineDistance() / 288)
                local scaleTo = cc.ScaleTo:create(0.8, pSimple:getLineDiff() / 288, 1)
                self.m_pLianxianArmature:runAction(scaleTo)
            end)
            local moveTo = cc.MoveTo:create(0.8, pSimple:getTarget())
            local callback = cc.CallFunc:create(function()
                -- 当前的死了
                pSimple:setSimpleFishChangeColor()
            end)
            pSimple:runAction(cc.Sequence:create(delay, show, callLine, moveTo, callback))
        end
    end
end 

--有用户离开的时候 隐藏文字
function FishShanDian:setWenZiVisibleFalse()
    if self.m_pLianSuoLabelArmature ~= nil then
        self.m_pLianSuoLabelArmature:setVisible(false)
    end 
end

function FishShanDian:delLianSuoEffect()

    if self.m_bIsDeleted then
        return
    end

    self.m_bIsDeleted = true

    for i = 1, #self.m_vecSimpleFish do
        self.m_vecSimpleFish[i]:removeFromParent()
        self.m_vecSimpleFish[i] = nil
    end
    self.m_vecSimpleFish = {}
    self:removeAllChildren()
    self:removeFromParent()
end 

function FishShanDian:getDefinePostion()

    local x = 0
    local y = 0
    if self.m_nSeatIndex < GAME_PLAYER_FISH / 2 then
        x = 233 + 655 * self.m_nSeatIndex
        y = -3
    else
        x = 233 +(3 - self.m_nSeatIndex) * 655
        y = 756
    end
    return cc.p(x, y)
end 

function FishShanDian:getTargetPositionByAngle(begin, angle, distance)

    local x = 0
    local y = 0
    angle =   math.angle2radian(angle)
    if angle >= 0 and angle <= M_PI_2 then

        x = begin.x + math.sin(angle) * distance
        y = begin.y + math.cos(angle) * distance

    elseif angle > M_PI_2 and angle <= M_PI then

        angle = angle - M_PI_2
        x = begin.x + math.cos(angle) * distance
        y = begin.y - math.sin(angle) * distance

    elseif angle > M_PI and angle <= M_PI_2 * 3 then

        angle = angle - M_PI
        x = begin.x - math.sin(angle) * distance
        y = begin.y - math.cos(angle) * distance

    elseif angle > M_PI_2 * 3 and angle <= M_PI * 2 then

        angle =(M_PI * 2) - angle
        x = begin.x - math.sin(angle) * distance
        y = begin.y + math.cos(angle) * distance
    end

    return cc.p(x, y)
end 

function FishShanDian:onMsgSwitchScene()

    --可能提前停止动作
    if self.m_pActionNode then
        self.m_pActionNode:stopActionByTag(self.m_nFishID)
    end

    --冒金币
    if self.m_pParent then
        self.m_pParent:showFishCatchGoldEffect(self.m_pFishKind, self.m_pFishPosition, self.m_ChairID, self.m_pFishScore, 1)
    end

    --删掉闪电鱼
    local pFish = FishDataMgr.getInstance():getFishByID(self.m_nFishID)
    if pFish then
        pFish:setCatchStatus()
    end

    --删掉拖的鱼
    self:delLianSuoEffect()
end

function FishShanDian:getChairId()
    return self.m_ChairID
end

function FishShanDian:setRandomPos(x, y)
    
    self.m_fRandomX = x or 0
    self.m_fRandomY = y or 0
end

function FishShanDian:setTargetPos(x, y)
    
    self.m_fTargetX = x or 0
    self.m_fTargetY = y or 0
end

function FishShanDian:getTargetPosition()
    if self.m_nSeatIndex == 1 or self.m_nSeatIndex == 2  then
        return 918
    else
        return 233
    end
end

function FishShanDian:getRandomPosition()
    return math.random(1, 200) - 100
end

return FishShanDian

-- endregion
