-- region FishPao.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 炮台 node
local module_pre = "game.yule.lkby.src"
local FishDataMgr = require(module_pre..".views.manager.FishDataMgr")
local FishRes     = require(module_pre..".views.scene.FishSceneRes")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local FishPao = class("FishPao", cc.Node)

function FishPao:ctor()
    self.m_nSeatIndex = -1
    self.m_nPaoType = BULLET_KIND_1_NORMAL
    self.m_pPaoArmture = nil
    self.m_pPaoArmtureBuff = nil
end

function FishPao:create(bulletKind, chairID)

    local pFishPao =  FishPao:new()
    pFishPao:init(bulletKind, chairID)
    return pFishPao
end 

function FishPao:init(bulletKind, chairID, bChange)

    bChange = bChange or false

    self.m_nChiarID = chairID
    self.m_nSeatIndex = FishDataMgr:getInstance():SwitchViewChairID(self.m_nChiarID)
    self.m_nPaoType = bulletKind

    -- 开炮动画
    local nIndex = self:getPaoSpriteIndex()

    if self.m_pPaoArmture then
        self.m_pPaoArmture:removeFromParent()
        self.m_pPaoArmture = nil
    end
    local strArmature = string.format("pao%d_buyu", nIndex)
    self.m_pPaoArmture = ccs.Armature:create(strArmature)
    self.m_pPaoArmture:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_pPaoArmture:setPosition(cc.p(50, 50))
    self.m_pPaoArmture:setTag(nIndex)
    self.m_pPaoArmture:addTo(self, 20)

    if self:isPaoBuff() then
        self:createBuff(nIndex)
    end
    -- 上排的炮要旋转180度
    if self.m_nSeatIndex >= GAME_PLAYER_FISH / 2 and not bChange then
        self:setRotation(180)
    end
end 

function FishPao:effectEnd(armature, type, name)

    if armature == nil then
        return
    end
    armature:removeFromParent()
end 

function FishPao:createBuff(nBuffIndex)

    if self.m_pPaoArmtureBuff ~= nil then

        self.m_pPaoArmtureBuff:removeFromParent()
        self.m_pPaoArmtureBuff = nil
    end
    -- 炮buff
    local strArmature = string.format("pao%dbuff_buyu", nBuffIndex)
    self.m_pPaoArmtureBuff = ccs.Armature:create(strArmature)
    self.m_pPaoArmtureBuff:getAnimation():play("Animation1")
    self.m_pPaoArmtureBuff:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_pPaoArmtureBuff:setPosition(cc.p(50, 50))
    self.m_pPaoArmtureBuff:addTo(self, 40)
end 

function FishPao:changePao(bulletKind)

    if self.m_pPaoArmtureBuff ~= nil then
        self.m_pPaoArmtureBuff:removeFromParent()
        self.m_pPaoArmtureBuff = nil
    end

    self:init(bulletKind, self.m_nChiarID, true)
    return self
end 

function FishPao:paoTag()

    if self.m_pPaoArmture ~= nil then
        return self.m_pPaoArmture:getTag()
    end
    return 0
end 

function FishPao:addPaoBuff()

    -- 设置炮的类型
    local nType = self.m_nPaoType
    --local kind = getBulletKindByIndex(nType + 3)
    --add by nick
    local kind = BulletKind[nType+3]
    self.m_nPaoType = kind
    self:createBuff(self:getPaoSpriteIndex())
end 

function FishPao:delPaoBuff()

    if self.m_pPaoArmtureBuff then
        self.m_pPaoArmtureBuff:removeFromParent()
        self.m_pPaoArmtureBuff = nil
    end

    if self:isPaoBuff() then
        local nType = self.m_nPaoType
        --local kind = getBulletKindByIndex(nType - 3)
        -- add by nick
        local kind = BulletKind[nType-3]
        self.m_nPaoType = kind
    end
end 

function FishPao:fireAnimation(playSound)

    if self.m_pPaoArmture == nil then
        return
    end
    if playSound then
        -- 开炮音效
        local strSoundPath = ""
        if self:isPaoBuff() then
            strSoundPath = FishRes.SOUND_OF_FIRE_BUFF
        else
            strSoundPath = FishRes.SOUND_OF_FIRE
        end
        ExternalFun.playGameEffect(strSoundPath)
    end
    -- 开炮动画
    self.m_pPaoArmture:getAnimation():play("Animation1")
end 

function FishPao:rotatePao(angle)

    -- 旋转角度
    self:setRotation(angle)
end 

function FishPao:getPaoSpriteIndex()

    local nIndex = 0
    local nMul = FishDataMgr:getInstance():getMulripleByIndex(self.m_nChiarID)
    local nBase = FishDataMgr.getInstance():getBaseScore()
    if nMul < FISH_PAO_SCORE_1 * nBase then 
        nIndex = 1
    else
        nIndex = 2
    end 
    return nIndex
end 

function FishPao:isPaoBuff()

    return self.m_nPaoType >= BulletKind.BULLET_KIND_1_ION
end 

return FishPao

-- endregion
