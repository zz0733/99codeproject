-- region FishGold.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 打中鱼后掉落金币UI node.
local module_pre = "game.yule.monkeyfish.src"
local FishDataMgr  = require(module_pre..".views.manager.FishDataMgr")
local FishRes      = require(module_pre..".views.scene.FishSceneRes")
local DataCacheMgr = require(module_pre..".views.manager.DataCacheMgr")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local FishGold = class("FishGold", cc.Node)

function FishGold:ctor()
    self:enableNodeEvents()

    self.m_pStartPos = cc.p(0, 0)
    self.m_pDesPos = cc.p(0, 0)
    self.m_pMiddlePos = cc.p(0, 0)
    self.m_iPlaySound = 0
    self.m_fTimeCount = 0
    self.m_fDelayTime = 0
    self.m_fMoveTime = 0

    self.status = STATUS_START
    self.goldType = FROGGOLD_TYPE_GOLD

    self.m_pArmGold = nil
    self.m_nScore = 0
    self.m_nChairId = -1
end

function FishGold:create()
    local pFish = FishGold.new()
    pFish:init()
    return pFish
end 


function FishGold:init()
    self.status = STATUS_UNUSE
    self.m_pArmGold = ccs.Armature:create("jinbitexiao_jinchanbuyu")
    self:addChild(self.m_pArmGold)
    self.m_pArmGold:setVisible(false)
    return true
end 

function FishGold:onEnter()
end 

function FishGold:onExit()
end 

FishGold.nGoldSpeed = 50 / cc.Director:getInstance():getAnimationInterval()

FishGold.strArmGold = {
    [FROGGOLD_TYPE_GOLD] = {
        "Animation_gold_1",
        "Animation_gold_2",
        "Animation_gold_3",
    },
    [FROGGOLD_TYPE_SILVER] = {
        "Animation_silver_1",
        "Animation_silver_2",
        "Animation_silver_3",
    },
}

function FishGold:showFishGold2(startPos, desPos, index, playSound, middlePos, nGoldType)

    self.m_pStartPos = startPos
    self.m_pDesPos = desPos
    self.m_iPlaySound = playSound
    self.m_pMiddlePos = middlePos
    self.m_fDelayTime = (index - 1) * 0.03
    self.status = STATUS_MOVE

    local distance = cc.pGetDistance(self.m_pDesPos, self.m_pStartPos)
    self.m_fMoveTime = distance / self.nGoldSpeed

    self:setVisible(true)
    self:setPosition(self.m_pStartPos)

    self.m_pArmGold:setVisible(false)
    self.m_pArmGold:setRotation(0)

    self.strArmGoldShow = FishGold.strArmGold[nGoldType][1]
    self.strArmGoldRotate = FishGold.strArmGold[nGoldType][2]
    self.strArmGoldHide = FishGold.strArmGold[nGoldType][3]

    --金币弹出回调
    local animationEvent = function(armatureBack,movementType,movementID)
        if  movementType == ccs.MovementEventType.complete
        and movementID == self.strArmGoldShow
        then
            local vec = cc.pSub(self.m_pDesPos, self.m_pStartPos)
            local angle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1)))
            self.m_pArmGold:setRotation(angle)
            self.m_pArmGold:getAnimation():play(self.strArmGoldRotate)

            --金币逐个移动
            local pDelay = cc.DelayTime:create(self.m_fDelayTime)
            local pMove = cc.MoveTo:create(self.m_fMoveTime, self.m_pDesPos)
            local pMoveEnd = cc.CallFunc:create(function()
                
                --金币声音
                if 1 == self.m_iPlaySound or self.m_iPlaySound == 2 then
                    if DataCacheMgr:getInstance():PlayGoldGetSound() then
                        ExternalFun.playGameEffect(FishRes.SOUND_OF_GOLD)
                        --print("qqqqqqqqqqqqqqqqqq:--------------------PlayGoldGetSound")
                    end
                end
                --加分数
                if self.m_nScore > 0 and self.m_nChairId > -1 then 
                    --杀死直接加分了,不再需要飞完金币加分
                    --FishDataMgr:getInstance():exchangeAddFishScore(self.m_nChairId, self.m_nScore)
                end
                --回收金币
                local animationEvent = function(armatureBack,movementType,movementID)
                    if  movementType == ccs.MovementEventType.complete
                    and movementID == self.strArmGoldHide
                    then
                        self.m_pArmGold:setVisible(false)
                        self.status = STATUS_UNUSE
                        self.m_nScore = 0
                        self.m_nChairId = -1
                    end
                end
                --金币消失
                self.m_pArmGold:getAnimation():setMovementEventCallFunc(animationEvent)
                self.m_pArmGold:getAnimation():play(self.strArmGoldHide)
            end)
            local pAction2 = cc.Sequence:create(pDelay, pMove, pMoveEnd)
            self:runAction(pAction2)
        end
    end
    self.m_pArmGold:getAnimation():setMovementEventCallFunc(animationEvent)

    --金币逐个显示
    local pDelay = cc.DelayTime:create(self.m_fDelayTime)
    local pPlay = cc.CallFunc:create(function()
        --弹出金币
        self.m_pArmGold:setVisible(true)
        self.m_pArmGold:getAnimation():play(self.strArmGoldShow)
    end)
    local pAction1 = cc.Sequence:create(pDelay, pPlay)
    self:runAction(pAction1)
end

function FishGold:setGoldScore(score)
     self.m_nScore = score
end

function FishGold:setChairId(chairId)
    self.m_nChairId = chairId or -1
end

function FishGold:getChairId()
     return self.m_nChairId
end

function FishGold:setAnimationEnd()
      self.status = STATUS_END
      self.m_fTimeCount     = 0.5
end
function FishGold:getStatus()
    return self.status
end 

function FishGold:setGoldType(goldType_)
    self.goldType = goldType_
end 

function FishGold:initUsed()
    self.status = STATUS_MOVE
    self.m_nScore = 0
    self.m_nChairId = -1
end

--function FishGold:setGray()
--    if self.goldType == FROGGOLD_TYPE_SILVER then
--        local pBone = self.m_pArmGold:getBone("Layer2")
--        local pManager = pBone:getDisplayManager()
--        local vecDisplay = pManager:getDecorativeDisplayList()

--        for k, v in pairs(vecDisplay) do
--            if v and v:getDisplay() then
--                local spData = v:getDisplay()
--                ShaderUtils:addShader(spData, "gray")
--            end
--        end
--    end
--end

--function FishGold:removeGray()
--    if self.goldType == FROGGOLD_TYPE_SILVER then
--        local pBone = self.m_pArmGold:getBone("Layer2")
--        local pManager = pBone:getDisplayManager()
--        local vecDisplay = pManager:getDecorativeDisplayList()

--        for k, v in pairs(vecDisplay) do
--            if v and v:getDisplay() then
--                local spData = v:getDisplay()
--                ShaderUtils:removeShader(spData)
--            end
--        end
--    end
--end

return FishGold

-- endregion
