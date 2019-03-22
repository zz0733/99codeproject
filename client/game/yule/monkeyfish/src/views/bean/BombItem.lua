-- region BombItem.lua
-- Date     2017.04.11
-- zhiyuan
-- Desc 炸弹特效 node.

local BombItem = class("BombItem", cc.Node)

function BombItem:ctor(fStartPos, wBombType)
    self.m_fStartPos = fStartPos
    self.m_fEndPos = cc.p(0, 0)
    self.m_wItemType = wBombType

    self:init()
end

function BombItem:init()
    self.m_fSpeed = math.random(0, 1) + math.random(0, 2) + 1 + 0.5
    local amount = BOMB_ITEM_COUNT
    local m_fFuDu = M_PI * 2 / amount * (math.random(0, 50) + 1)
    local fRaiLong = 1600
    if self.m_wItemType == BOMB_TYPE_SPECIAL then
        self.m_fSpeed = 0.5 + math.random(0, 1)
        fRaiLong = 800.0
    end

    self.m_fEndPos = cc.p(math.cos(m_fFuDu) * fRaiLong, math.sin(m_fFuDu) * fRaiLong)
    -- 设置方向
    local vec = cc.pSub(self.m_fEndPos, self.m_fStartPos)
    local angle = math.radian2angle(cc.pGetAngle(vec, cc.p(0, 1)))

    if self.m_wItemType == BOMB_TYPE_JINGB then

        local sprite = display.newSprite("#bglu_gunturning_006.png")
        sprite:setRotation(angle + 5)
        sprite:addTo(self)

        local move = cc.MoveTo:create(self.m_fSpeed, self.m_fEndPos)
        sprite:runAction(move)

    elseif self.m_wItemType == BOMB_TYPE_FOZHANG then

        local armture2 = ccs.Armature:create("wanfocaozhong_buyu")
        armture2:getAnimation():play("Animation1")
        armture2:addTo(self)
        armture2:setRotation(angle - 11)

        local move = cc.MoveTo:create(self.m_fSpeed, self.m_fEndPos)
        local scale = cc.ScaleTo:create(self.m_fSpeed, 3.5)
        local action = cc.Spawn:create(move, scale)
        armture2:runAction(action)

    elseif self.m_wItemType == BOMB_TYPE_SPECIAL then

        local sprite = display.newSprite("#gui-fish-lizi.png")
        sprite:addTo(self)

        local move = cc.MoveTo:create(self.m_fSpeed, self.m_fEndPos)
        local scale = cc.ScaleTo:create(self.m_fSpeed, 3)
        local spawn = cc.Spawn:create(move, scale)
        local fade = cc.FadeOut:create(0.2)
        local action = cc.Sequence:create(spawn, fade)
        sprite:runAction(action)

        self.m_fSpeed = self.m_fSpeed + 0.2
    end

    local delay = cc.DelayTime:create(self.m_fSpeed)
    local callFunc = cc.CallFunc:create(function()
        self:moveEnd()
    end)
    self:runAction(cc.Sequence:create(delay, callFunc))
end 

function BombItem:moveEnd(time)
    self:removeFromParent()
end 

function BombItem:removeArmature(armature)

    self:removeFromParent()
end 

return BombItem

-- endregion
